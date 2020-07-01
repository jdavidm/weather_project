* Project: WB Weather
* Created on: June 2020
* Created by: McG
* Stata v.16

* does
	* cleans Ethiopia household variables, wave 1 PP sec3
	* looks like a field roster
	* hierarchy: holder > parcel > field > crop
	* seems to correspond to Malawi ag-modC and ag-modJ
	
* assumes
	* customsave.ado
	* distinct.ado

* TO DO:
	* what to do w/ obs where status = .

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root = "$data/household_data/ethiopia/wave_1/raw"
	loc export = "$data/household_data/ethiopia/wave_1/refined"
	loc logout = "$data/household_data/ethiopia/logs"

* open log
	log using "`logout'/wv1_PPSEC3", append


* **********************************************************************
* 1 - preparing ESS 20??/?? (Wave 1) - Post Planting Section 3 
* **********************************************************************

* load data
	use 		"`root'/sect3_pp_w1.dta", clear

* dropping duplicates
	duplicates 	drop

* investigate unique identifier
	describe
	sort 		holder_id parcel_id field_id
	isid 		holder_id parcel_id field_id

* creating district identifier
	egen 		district_id = group( saq01 saq02)
	label var 	district_id "Unique region identifier"	
	distinct	saq01 saq02, joint
	*** 69 distinct districts
	
* field status check
	rename 		pp_s3q03 status
	tab 		status, missing
	*** 233 missing status
	
* dropping all plot obs that weren't cultivated
	drop		if status >= 3 & status != .
	*** 8,509 obs dropped

* drop observations with a missing field_id
	sum 		if missing(parcel_id,field_id)
	drop 		if missing(parcel_id,field_id)
	isid 		holder_id parcel_id field_id
	
* creating parcel identifier
	rename		parcel_id parcel
	tostring	parcel, replace
	generate 	parcel_id = holder_id + " " + parcel
	
* creating unique field identifier
	rename		field_id field
	tostring	field, replace
	generate 	field_id = holder_id + " " + parcel + " " + field
	isid 		field_id

* merge in conversion data
	rename		saq01 region
	rename		saq02 zone
	rename 		saq03 woreda
	rename		pp_s3q02_c local_unit
	merge 		m:1 region zone woreda local_unit ///
					using "`root'/ET_local_area_unit_conversion.dta"
	*** 11,563 obs not matched from master data
	*** why is this...	
	

* **********************************************************************
* 2 - constructing conversion factors 
* **********************************************************************

* infer local units from district, region, or country means
	egen 		avg_dis = mean(conversion), by(region zone local_unit)
	egen 		avg_reg = mean(conversion), by(region local_unit)
	egen 		avg_eth = mean(conversion), by(local_unit)

	replace 	conversion  = avg_dis if conversion == .
	replace 	conversion  = avg_reg if conversion == .
	replace 	conversion  = avg_eth if conversion == .
	replace 	conversion = . if local_unit == .
	*** do not drop observations that lack local units since they may have gps values

	drop 		if _merge == 2
	drop 		_merge avg_dis avg_reg avg_eth

* generate self-reported land area of plot w/ conversions
	tabulate 	local_unit, missing // Unit of land area, self-reported
	generate 	cfactor = 10000 if local_unit=="Hectare":local_unit
	replace 	cfactor = 1 if local_unit=="Square Meters":local_unit
	replace 	cfactor = conversion if local_unit=="Timad":local_unit
	replace 	cfactor = conversion if local_unit=="Boy":local_unit
	replace 	cfactor = conversion if local_unit=="Senga":local_unit
	replace 	cfactor = conversion if local_unit=="Kert":local_unit
	summarize 	local_unit, detail // Quantity of land units, self-reported
	generate 	selfreport_sqm = cfactor * pp_s3q02_d if local_unit!=0
	summarize 	selfreport_sqm, detail // resulting land area (sq. meters)
	generate 	selfreport_ha = selfreport_sqm * 0.0001
	summarize 	selfreport_ha, detail // resulting land area (hectares)

* generate GPS & rope-and-compass land area of plot in hectares 
* as a starting point, we expect both to be more accurate than self-report 
	summarize 	pp_s3q04 pp_s3q08_a
	generate 	gps = pp_s3q05_c * 0.0001 if pp_s3q04 == 1
	generate 	rap = pp_s3q08_b * 0.0001 if pp_s3q08_a == 1
	summarize 	gps rap, detail

* compare GPS and self-report, and look for outliers in GPS 
	summarize 	gps, detail 	//	same command as above to easily access r-class stored results 
	list 		gps rap selfreport_ha if !inrange(gps,`r(p50)'-(3*`r(sd)'),`r(p50)'+(3*`r(sd)')) & !missing(gps)	
	*** look at GPS and self-reported observations that are > ±3 Std. Dev's from the median 

* GPS on the larger side vs self-report
	tabulate	gps if gps>2, plot	// GPS doesn't seem outrageous. 9ha is big but not unbelievable	
	sort 		gps		
	list 		gps rap selfreport_ha if gps>3 & !missing(gps), sep(0)	
	*** the big gps values are way off from the self-reported

* GPS on the smaller side vs self-report 
	tabulate 	gps if gps<0.002, plot	
	*** GPS data distribution is lumpy for small plots due to the precision constraints of the technology 
	
	sort 		gps					
	list 		gps selfreport_ha if gps<0.002, sep(0)	
	*** GPS tends to be less than self-reported size

	pwcorr 		gps rap 
	*** highly correlated
	
	pwcorr 		selfreport_ha rap 	
	*** correlation very low
	
	pwcorr 		selfreport_ha gps	
	*** correlation coefficient is extremely low
	
	pwcorr 		selfreport_ha gps if inrange(gps,0.002,4) & inrange(selfreport_ha,0.002,4)	
	*** much better if we restrict range for both

	twoway 		(scatter selfreport_ha gps if inrange(gps,0.002,4) & inrange(selfreport_ha,0.002,4))
	pwcorr 		gps rap if !inrange(gps,0.002,4) 
	*** low correlation outside of this range

* make plotsize_GPS using GPS area if it is within reasonable range
	generate 	plotsize_GPS = gps if gps>0.002 & gps<4
	replace 	plotsize_GPS = rap if plotsize_GPS == . & rap != . 
	*** replace missing values with rap
	
	summarize 	selfreport_ha gps rap plotsize_GPS, detail	
	***	we have some self-report information where we are missing plotsize_GPS 
	
	summarize 	selfreport_ha if missing(plotsize_GPS), detail

* impute missing plot sizes using predictive mean matching 
	mi set 		wide //	declare the data to be wide. 
	mi xtset, 	clear // this is a precautinary step to clear any xtset that the analyst may have had in place previously
	mi register	imputed plotsize_GPS //	identify plotsize_GPS as the variable being imputed 
	mi impute 	pmm plotsize_GPS selfreport_ha i.district_id, add(1) rseed(245780) ///
					noisily dots force knn(5) bootstrap 
	mi 			unset

* summarize results of imputation
	tabulate 	mi_miss	//	this binary = 1 for the full set of observations where plotsize_GPS is missing
	tabstat 	gps rap selfreport_ha plotsize_GPS plotsize_GPS_1_, by(mi_miss) ///
					statistics(n mean min max) columns(statistics) longstub ///
					format(%9.3g) 

* verify that there is nothing to be done to get a plot size for the observations where plotsize_GPS_1_ is missing
	list 		gps rap selfreport_ha plotsize_GPS if missing(plotsize_GPS_1_), sep(0) 
	*** there are some missing values that we have GPS for
	
	replace 	plotsize_GPS_1_ = gps if missing(plotsize_GPS_1_) & !missing(gps) // replace with existing gps values
	drop 		if missing(plotsize_GPS_1_) // drop remaining missing values

* manipulate variables for export
	rename 		(plotsize_GPS plotsize_GPS_1_)(plotsize_GPS_raw plotsize_GPS)
	label 		variable plotsize_GPS		"Plot Size (GPS - ha)"

* here is where I break from WB procedure as Malawi ag_c did not cover these variables
* I can modify these when I come across them in the Malawi do files

* look at irrigation dummy
	generate 	irrigated = pp_s3q12 if pp_s3q12 >= 1
	lab var 	irrigated "Is field irrigated?"

* look at fertilizer use
	generate 	fert_any = pp_s3q14 if pp_s3q14 >= 1
	lab var 	fert_any "Is fertilizer used on field?"
	generate 	org_fert_any = pp_s3q25 if pp_s3q25 >= 1
	lab var 	org_fert_any "Do you use any organic fertilizer on field?"
	generate 	kilo_fert = pp_s3q16_c + pp_s3q19_c
	lab var 	kilo_fert "Kilograms of fertilizer applied (Urea and DAP only)"
	*** kilo_fert only captures Urea and DAP 
	*** no quantities are provided for compost, manure, or organic fertilizer

* planting labor
	generate 	laborday_plant_hh = (pp_s3q27_b * pp_s3q27_c) + (pp_s3q27_f * ///
					pp_s3q27_g) + (pp_s3q27_j * pp_s3q27_k) + (pp_s3q27_n * ///
					pp_s3q27_o) + (pp_s3q27_r * pp_s3q27_s) + (pp_s3q27_v * ///
					pp_s3q27_w) + pp_s3q29_b + pp_s3q29_d + pp_s3q29_f
	generate 	laborday_plant_hired = pp_s3q28_b + pp_s3q28_e + pp_s3q28_h
	generate 	labordays_plant = laborday_plant_hh + laborday_plant_hired
	drop 		laborday_plant_hh laborday_plant_hired
	lab var 	labordays_plant "Total Days of Planting Labor - Household and Hired"

* look at crop mix
	generate 	crop_1 = pp_s3q31_b if pp_s3q31_b >= 0
	lab var 	crop_1 "What is the crop used for the first and second harvest? (Crop #1 Code)"
	generate 	crop_2 = pp_s3q31_d if pp_s3q31_d >= 0
	lab var 	crop_2 "What is the crop used for the first and second harvest? (Crop #2 Code)"

* creating a merge variable for sect9_ph_w1v2
*	generate 	field_ident = holder_id + " " + string(parcel_id) + " " + ///
*					string(field_id)


* ***********************************************************************
* 5 - cleaning and keeping
* ***********************************************************************

* renaming some variables of interest
	rename 		household_id hhid
	rename 		plotsize_GPS plotsize
	
* restrict to variables of interest 
* this is how world bank has their do-file set up
* if we want to keep all identifiers (i.e. region, zone, etc) we can do that easily
	keep  		holder_id- pp_saq07 status kilo_fert labordays_plant ///
					plotsize selfreport_ha irrigated fert_any ///
					org_fert_any crop_1 crop_2 field_id
	order 		holder_id- pp_saq07 parcel field field_id

* final preparations to export
	isid 		holder_id parcel field
	isid		field_id
	compress
	describe
	summarize
	sort 		holder_id parcel field
	customsave , idvar(field_id) filename(PP_SEC3.dta) path("`export'") ///
		dofile(PP_SEC3) user($user)

* close the log
	log	close
	
/* END */