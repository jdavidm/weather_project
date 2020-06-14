* Project: WB Weather
* Created on: June 2020
* Created by: McG
* Stata v.16

* does
	* cleans Ethiopia household variables, wave 3 PP sec3
	* looks like a field roster
	* hierarchy: holder > parcel > field > crop
	* seems to correspond to Malawi ag-modC and ag-modJ
	
* assumes
	* customsave.ado
	* distinct.ado

* TO DO:
	* figure out why so many observations arent matched from master data when merging in conv_id

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root = "$data/household_data/ethiopia/wave_3/raw"
	loc export = "$data/household_data/ethiopia/wave_3/refined"
	loc logout = "$data/household_data/ethiopia/logs"

* open log
	log using "`logout'/wv3_PPSEC3", append


* **********************************************************************
* 1 - preparing ESS 2015/16 (Wave 3) - Post Planting Section 3 
* **********************************************************************

* build conversion id into conversion dataset
	clear
	use 		"`root'/ET_local_area_unit_conversion.dta"
	gen		 	conv_id = string(region) + " " + string(zone) + " " + string(woreda) + " " + string(local_unit)
	save 		"`root'/ET_local_area_unit_conversion_use.dta", replace
	clear

* load pp section 3 data
	use 		"`root'/sect3_pp_w3.dta", clear

* dropping duplicates
	duplicates 	drop

* investigate unique identifier
	describe
	sort 		holder_id ea_id parcel_id field_id
	isid 		holder_id parcel_id field_id, missok

* creating district identifier
	egen 		district_id = group( saq01 saq02)
	lab var 	district_id "Unique district identifier"
	distinct	saq01 saq02, joint
	*** 69 distinct district
	*** same as pp sect2, good

* field status check
	rename 		pp_s3q03 status, missing
	tab			status, missing
	*** none missing status

* dropping all plot obs that weren't cultivated	
	drop 		if status != 1
	* 10,061 dropped

* drop observations with a missing field_id
	summarize 	if missing(parcel_id,field_id)
	drop 		if missing(parcel_id,field_id)
	isid 		holder_id parcel_id field_id
	
* creating a merge variable for sect9_ph_w2
	generate 	field_ident = holder_id + " " + string(parcel_id) + " " + string(field_id)
	
* creating parcel identifier
	rename		parcel_id parcel
	tostring	parcel, replace
	generate 	parcel_id = holder_id + " " + ea_id + " " + parcel
	
* creating unique field identifier
	rename		field_id field
	tostring	field, replace
	generate 	field_id = holder_id + " " + ea_id + " " + parcel + " " + field
	isid 		field_id

* create conversion key 
	generate 	conv_id = string(saq01) + " " + string(saq02) + " " + ///
					string(saq03) + " " + string(pp_s3q02_c)
	merge 		m:1 conv_id using "`root'/ET_local_area_unit_conversion_use.dta"
	*** 13,748 obs not matched from master data
	*** why is this...
	
* look at crop mix
	generate 	crop_1 = pp_s3q31_b if pp_s3q31_b >= 0
	label var	crop_1 "What is the crop used for the first and second harvest? (Crop #1 Code)"
	generate 	crop_2 = pp_s3q31_d if pp_s3q31_d >= 0
	label var	crop_2 "What is the crop used for the first and second harvest? (Crop #2 Code)"
	

************************************************************************
**	2 - constructing conversion factors 
************************************************************************	

* create units of measure for each observation
*	drop 		region zonename zone woredaname woreda
	replace 	local_unit = pp_s3q02_c if local_unit == .
	summarize 	local_unit pp_s3q02_c
	*** 69 fewer pp_s3q02_c

* infer local units from district, region, or country means
	egen 		avg_dis = mean(conversion), by(saq01 saq02 pp_s3q02_c)
	egen 		avg_reg = mean(conversion), by(saq01 pp_s3q02_c)
	egen 		avg_eth = mean(conversion), by(pp_s3q02_c)
	
* fill out missing conversion factors
	replace 	conversion = avg_dis if conversion == .
	replace 	conversion = avg_reg if conversion == .
	replace 	conversion = avg_eth if conversion == .
	replace 	conversion = . if local_unit == .
	*** 14 changes made in the last line
	*** do not drop observations that lack local units since they may have gps values

	drop if 	_merge == 2
	drop 		avg_dis avg_reg avg_eth

* generate self-reported land area of plot w/ conversions
	tabulate 	pp_s3q02_c, missing // Unit of land area, self-reported
	*** missing 14 out of 23,244
	
	generate 	cfactor = 10000 if pp_s3q02_c==1
	replace 	cfactor = 1 if pp_s3q02_c==2
	replace 	cfactor = conversion if pp_s3q02_c==local_unit ///
					& pp_s3q02_c!=1 & pp_s3q02_c!=2
	tab			cfactor, missing
	*** cfactor missing from 7,757 obs


************************************************************************
**	3 - constructing area measurements
************************************************************************	

************************************************************************
**	3a - constructing area measurements (self-reported) 
************************************************************************	
	
* problem! There are over 12,000 obs with units of measure not included in the conversion file
	summarize 	pp_s3q02_c, detail // Quantity of land units, self-reported
	generate 	selfreport_sqm = cfactor * pp_s3q02_a if pp_s3q02_c!=0
	summarize 	selfreport_sqm, detail // resulting land area (sq. meters)
	generate 	selfreport_ha = selfreport_sqm * 0.0001
	summarize 	selfreport_ha, detail // resulting land area (hectares)

* to check the work above the following command is helpful
* 	order		(_merge conv_id saq01 region saq02 zone saq03 woreda pp_s3q02_c ///
*					local_unit conversion cfactor selfreport_sqm selfreport_ha)
	sort		_merge
	

************************************************************************
**	3b - constructing area measurements (gps & rope-and-compass) 
************************************************************************	

* generate GPS & rope-and-compass land area of plot in hectares 
* as a starting point, we expect both to be more accurate than self-report 
	summarize 	pp_s3q04 pp_s3q08_a
	generate 	gps = pp_s3q05_a * 0.0001 if pp_s3q04 == 1
	generate 	rap = pp_s3q08_b * 0.0001 if pp_s3q08_a == 1
	summarize 	gps rap, detail

* compare GPS and self-report, and look for outliers in GPS 
	summarize 	gps, detail 	//	same command as above to easily access r-class stored results 
	list 		gps rap selfreport_ha if !inrange(gps,`r(p50)'-(3*`r(sd)'),`r(p50)'+(3*`r(sd)')) & !missing(gps)	
	*** looking at GPS and self-reported observations that are > ±3 Std. Dev's from the median 

* GPS on the larger side vs self-report
	tabulate 	gps if gps>2, plot	// GPS doesn't seem outrageous, 22 obs > 10 ha
	* in Wave 1 there were NO GPS measured fields > 10 ha

	sort 		gps		
	list 		gps rap selfreport_ha if gps>3 & !missing(gps), sep(0)	// Large gps values are sometimes way off from the self-reported

* GPS on the smaller side vs self-report 
	summarize 	gps if gps<0.002 // ~3,000 obs
	tabulate 	gps if gps<0.002, plot		
	*** like wave 1, data distirubtion is somewhat lumpy due to the precision constraints of the technology 
	*** including 430 obs that Stata recognizes as gps = 0 (and one that's negative)
	
	sort 		gps					
	list 		gps selfreport_ha if gps<0.002, sep(0)	// GPS tends to be less than self-reported size


************************************************************************
**	3c - evaluating various area measurements 
************************************************************************		
	
* evaluating correlations between various measures
	pwcorr 		gps rap 
	*** 0.57 correlation - midrange
	
	pwcorr 		gps rap if !inrange(gps,0.002,4)
	*** 0.6984 - correlation outside this range higher than overall
	
	pwcorr 		gps rap if inrange(gps,0.002,4) 
	*** 0.7772 - higher than outside the central range
	
	pwcorr 		selfreport_ha rap 	
	*** 0.24 correlation - low
	
	pwcorr 		selfreport_ha gps	
	*** 0.0022 correlation - very very low
	
	pwcorr 		selfreport_ha gps if inrange(gps,0.002,4) ///
					& inrange(selfreport_ha,0.002,4)
	*** 0.7023 - much much higher when range is restricted for both	
	
	twoway 		(scatter selfreport_ha gps if inrange(gps,0.002,4) ///
					& inrange(selfreport_ha,0.002,4))


************************************************************************
**	3d - constructing overall plotsize
************************************************************************					

* make plotsize using GPS area if it is within reasonable range
	generate 	plotsize = gps
	replace 	plotsize = rap if plotsize == . & rap != . // replace missing values with rap
	summarize 	selfreport_ha gps rap plotsize, detail	
	*** we have some self-report information where we are missing plotsize 
	
	summarize 	selfreport_ha if missing(plotsize), detail
	*** 127 obs w/ selfreport_ha missing plotsize

* impute missing plot sizes using predictive mean matching 
	mi set 		wide //	declare the data to be wide. 
	mi xtset, 	clear //	this is a precautinary step to clear any xtset that the analyst may have had in place previously
	mi register imputed plotsize //	identify plotsize as the variable being imputed 
	mi impute 	pmm plotsize selfreport_ha i.district_id, add(1) rseed(245780) ///
					noisily dots force knn(5) bootstrap 
	mi 			unset

* summarize results of imputation
	tabulate 	mi_miss	//	this binary = 1 for the full set of observations where plotsize_GPS is missing
	tabstat 	gps rap selfreport_ha plotsize plotsize_1_, by(mi_miss) ///
					statistics(n mean min max) columns(statistics) longstub ///
					format(%9.3g) 
	*** 127 imputations made
	
	drop		mi_miss

* verify that there is nothing to be done to get a plot size for the observations where plotsize_GPS_1_ is missing
	list 		gps rap selfreport_ha plotsize if missing(plotsize_1_), sep(0)
	*** there are some missing values that we have GPS for
	
	replace 	plotsize_1_ = gps if missing(plotsize_1_) & !missing(gps) // replace with existing gps values
	drop 		if missing(plotsize_1_) // drop remaining missing values

* manipulate variables for export
	rename 		(plotsize plotsize_1_)(plotsize_raw plotsize)
	label 		variable plotsize		"Plot Size (ha)"
	sum 		plotsize, detail
	*** i'm not a fan of the one negative plotsize
	
	replace		plotsize = 0 if plotsize < 0
	*** one change made, good
	

************************************************************************
**	4 - constructing other variables of interest
************************************************************************

************************************************************************
**	4a - irrigation and labor
************************************************************************

* look at irrigation dummy
	generate 	irrigated = pp_s3q12 if pp_s3q12 >= 1
	label 		variable irrigated "Is field irrigated?"

* household planting labor
* replace weeks worked equal to zero if missing
	replace		pp_s3q27_b = 0 if pp_s3q27_b == . 
	replace		pp_s3q27_f = 0 if pp_s3q27_f == . 
	replace		pp_s3q27_j = 0 if pp_s3q27_j == . 
	replace		pp_s3q27_n = 0 if pp_s3q27_n == . 
	
* find average # of days worked by first worker reported (most obs)
	sum 		pp_s3q27_c pp_s3q27_g pp_s3q27_k pp_s3q27_o
	*** pp_s3q27_c has by far the most obs, mean is 2.59
	
* replace days per week worked equal to 2.59 if missing and weeks were worked 
	replace		pp_s3q27_c = 0 if pp_s3q27_c == . &  pp_s3q27_b != 0 
	replace		pp_s3q27_g = 0 if pp_s3q27_g == . &  pp_s3q27_f != 0  
	replace		pp_s3q27_k = 0 if pp_s3q27_k == . &  pp_s3q27_j != 0  
	replace		pp_s3q27_o = 0 if pp_s3q27_o == . &  pp_s3q27_n != 0  
	
* replace days per week worked equal to 0 if missing and no weeks were worked
	replace		pp_s3q27_c = 0 if pp_s3q27_c == . &  pp_s3q27_b == 0 
	replace		pp_s3q27_g = 0 if pp_s3q27_g == . &  pp_s3q27_f == 0  
	replace		pp_s3q27_k = 0 if pp_s3q27_k == . &  pp_s3q27_j == 0  
	replace		pp_s3q27_o = 0 if pp_s3q27_o == . &  pp_s3q27_n == 0  
	
	summarize	pp_s3q27_b pp_s3q27_c pp_s3q27_f pp_s3q27_g pp_s3q27_j ///
					pp_s3q27_k pp_s3q27_n pp_s3q27_o
	*** it looks like the above approach works

* other hh labor
* there is an assumption here
	/* 	survey instrument splits question into # of men, total # of days
		where pp_s3q29_a is # of men and pp_s3q29_b is total # of days (men)
		there is also women and children (c & d and e % f)
		the assumption is that total # of days is the total
		and therefore does not require being multiplied by # of men
		there are weird obs that make this assumption shakey
		where # of men = 3 and total # of days = 1 for example
		the same dilemna/assumption applies to hired labor (pp_s3q28_*)
		this can be revised if we think this assumption is shakey */

* replace total days = 0 if total days is missing
	replace		pp_s3q29_b = 0 if pp_s3q29_b == . 
	replace		pp_s3q29_d = 0 if pp_s3q29_d == . 
	replace		pp_s3q29_f = 0 if pp_s3q29_f == . 	
	
* replace total days = 0 if total days is missing, hired labor
	replace		pp_s3q28_b = 0 if pp_s3q28_b == . 
	replace		pp_s3q28_e = 0 if pp_s3q28_e == . 
	replace		pp_s3q28_h = 0 if pp_s3q28_h == . 	
	
* generate aggregate hh and hired labor variables	
	generate 	laborday_plant_hh = (pp_s3q27_b * pp_s3q27_c) + ///
					(pp_s3q27_f * pp_s3q27_g) + (pp_s3q27_j * pp_s3q27_k) + ///
					(pp_s3q27_n * pp_s3q27_o) + pp_s3q29_b + pp_s3q29_d + ///
					pp_s3q29_f
	generate 	laborday_plant_hired = pp_s3q28_b + pp_s3q28_e + pp_s3q28_h
	
* check to make sure things look all right
	sum			laborday_plant_hh laborday_plant_hired
	*** hired mean is way lower than household
	*** could this be because of the above assumption? (line 309)
	*** or maybe just people hire way less labor than make use of hh labor
	
* combine hh and hired labor into one variable 
	generate 	labordays_plant = laborday_plant_hh + laborday_plant_hired
	drop 		laborday_plant_hh laborday_plant_hired
	label var 	labordays_plant "Total Days of Planting Labor - Household and Hired"
	

************************************************************************
**	4b - fertilizer
************************************************************************

* look at fertilizer use
	rename 		pp_s3q14 fert_any
	
	generate 	org_fert_any = pp_s3q25 if pp_s3q25 >= 1
	label 		variable org_fert_any "Do you use any organic fertilizer on field?"
	*** should I roll this into fert_any? 
	*** organic fertilizer is typically manure i think
	*** i'm not sure that we're concerned about manure
	
* constructing continuous fertilizer variable	
	generate 	fert_u = pp_s3q16  // urea
	replace		fert_u = 0 if pp_s3q16 == . & (pp_s3q19 != . | pp_s3q20a_2 != . ///
					| pp_s3q20a_7 != .)
	
	generate 	fert_d = pp_s3q19 // DAP
	replace		fert_d = 0 if pp_s3q19 == . & (pp_s3q16 != . | pp_s3q20a_2 != . ///
					| pp_s3q20a_7 != .)
	
	generate 	fert_n = pp_s3q20a_2 // NPS
	replace		fert_n = 0 if pp_s3q20a_2 == . & (pp_s3q16 != . | pp_s3q19 != . ///
					| pp_s3q20a_7 != .)
	*** unit of measure not specified, assuming kg
					
	generate 	fert_o = pp_s3q20a_7 // other chemical fertilizer
	replace		fert_o = 0 if pp_s3q20a_7 == . & (pp_s3q16 != . | pp_s3q19 != . ///
					| pp_s3q20a_2 != .)
	*** unit of measure not specified, assuming kg
	
	generate 	kilo_fert = fert_u + fert_d + fert_n + fert_o
	label var 	kilo_fert "Kilograms of fertilizer applied (Urea and DAP only)"
	drop 		fert_u fert_d fert_n fert_o
	*** kilo_fert only captures Urea and DAP - 5,172 obs
	*** no quantities are provided for compost, manure, or organic fertilizer
	*** will attempt to impute missing values
	
* investigating potential control variables for imputation
	pwcorr		kilo_fert plotsize
	*** figure this is a good place to start, larger plots might use more fert_any
	*** correlation is low - 0.0396
	
	pwcorr		kilo_fert selfreport_ha
	*** even lower - 0.0264
	
	pwcorr		kilo_fert labordays_plant
	*** still low - 0.0337
	*** will proceed without other control variables for now...

* attempting to impute missing fertilizer values using predictive mean matching 
	mi set 		wide //	declare the data to be wide. 
	mi xtset, 	clear //	this is a precautinary step to clear any xtset that the analyst may have had in place previously
	mi register imputed kilo_fert //	identify kilo_fert as the variable being imputed 
	mi impute 	pmm kilo_fert i.district_id, add(1) rseed(245780) ///
					noisily dots force knn(5) bootstrap 
	mi 			unset
	*** wait, does this assume that no one uses zero fertilizer?
	*** i can replace kilo_fert = 0 if fert_any == no
	*** i think i want to do this after i impute so all the zeros don't affect the imputation
	*** or! alternatively i could impute if fert_any == yes
	
* summarize results of imputation
	tabulate 	mi_miss	//	this binary = 1 for the full set of observations where kilo_fert is missing
	tabstat 	kilo_fert kilo_fert_1_, by(mi_miss) ///
					statistics(n mean min max) columns(statistics) longstub ///
					format(%9.3g) 
	*** 17,368 imputations made

	replace		kilo_fert_1_ = 0 if fert_any == 2 & kilo_fert == .
	*** 11,401 changes made
	*** see line 345
	
	drop		kilo_fert
	rename		kilo_fert_1_ kilo_fert
	

* ***********************************************************************
* 5 - cleaning and keeping
* ***********************************************************************

* renaming some variables of interest
	rename 		household_id hhid
	rename 		household_id2 hhid2	
	drop		region	
	rename 		saq01 region
	rename 		saq02 district
	label var 	district "District Code"
	rename 		saq03 ward	
	
* restrict to variables of interest 
* this is how world bank has their do-file set up
* if we want to keep all identifiers (i.e. region, zone, etc) we can do that easily
	keep  		holder_id- pp_s3q0a status kilo_fert labordays_plant plotsize ///
					irrigated fert_any field_ident parcel_id field_id district_id
	order 		holder_id- saq06 district_id parcel_id field_id

* Final preparations to export
	isid 		holder_id parcel field
	isid		field_id
	compress
	describe
	summarize
	sort 		holder_id parcel_id field_id
	customsave , idvar(field_id) filename(PP_SEC3.dta) path("`export'") ///
		dofile(PP_SEC3) user($user)

* close the log
	log	close