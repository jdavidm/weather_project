* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Niger, WAVE 2 (2014), POST HARVEST, ECVMA2 AS2E1P2
	* determines primary crops, cleans harvest (quantity in kg)
	* determines harvest for all crops - to determine value (based on prices)
	* outputs clean data file ready for combination with wave 2 plot data

* assumes
	* customsave.ado
	* mdesc.ado

* TO DO:
	* done

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc 	root	= 	"$data/household_data/niger/wave_2/raw"
	loc 	export	= 	"$data/household_data/niger/wave_2/refined"
	loc 	logout	= 	"$data/household_data/niger/logs"

* open log
	*log 	using 	"`logout'/2014_AS2E1P2_1", append

	
* **********************************************************************
* 1 - harvest information
* **********************************************************************

* import the first relevant data file
	use				"`root'/ECVMA2_AS2E1P2", clear
	duplicates 		drop
	
* need to rename for English
	rename 			PASSAGE visit
	label 			var visit "number of visit"
	rename			GRAPPE clusterid
	label 			var clusterid "cluster number"
	rename			MENAGE hh_num
	label 			var hh_num "household number - not unique id"
	rename 			EXTENSION extension 
	label 			var extension "extension of household"
	*** will need to do these in every file
	rename 			AS02EQ0 ord 
	label 			var ord "number of order"
	rename 			AS02EQ01 field 
	label 			var field "field number"
	rename 			AS02EQ03 parcel 
	label 			var parcel "parcel number"
	
* need to include clusterid, hhnumber, extension, order, field, and parcel to uniquely identify
	describe
	sort 			clusterid hh_num extension ord field parcel
	isid 			clusterid hh_num extension ord field parcel
		
	rename 			CULTURE cropid
	tab 			cropid
	*** main crop is "mil" = millet 
	*** cropcode for millet == 1
	*** second crop is cowpea, third is sorghum ... and then a huge (thousands) diference to peanut 

* look for the month household started harvesting
	tab 			AS02EQ06A
	
* drop observations in which it was not harvest season
	drop if 		AS02EQ06A == 0 | AS02EQ06A == 1 | AS02EQ06A == 2 | ///
					AS02EQ06A == 3 | AS02EQ06A == 4 | AS02EQ06A == 5 | ///
					AS02EQ06A == 6 | AS02EQ06A == 7 
	*** drops 826 observations
	
* check to see if household has finished harvesting
	tab 			AS02EQ06B	

* drop if household has not completed harvest	
	drop if 		AS02EQ06B == 99 
	*** drops 10 observations 
	
* rename variables associated with harvest
	rename 			AS02EQ07C harvkg 
	rename 			AS02EQ07A harv 

* make harvkg 0 if household said they harvested nothing
	replace			harvkg = 0 if harvkg == . & harv == 0 
	*** 343 changes made 

* make harvkg missing if household said they did not harvest
	replace 		harvkg = . if harvkg == 0 & harv != 0 
	*** 93 changes made

* replace miscoded variables as missing 
	replace			harvkg = . if harvkg > 999997 
	*** 18 changed to missing (obs = 999998 and 999999) - seems to be . in many cases for Niger

* convert missing harvest data to zero if harvest was lost to event
	replace			harvkg = 0 if AS02EQ08 == 1 & AS02EQ09 == 100
	*** 59 missing changed to 0
	
* drop "other / autre"
	drop 			if cropid == 48 
	*** 14 observations dropped 

	sort 			clusterid hh_num extension ord field parcel
	isid 			clusterid hh_num extension ord field parcel

	
* **********************************************************************
* 2 - generate harvested values
* **********************************************************************

* examine quantity harvested variable
	lab	var			harvkg "quantity harvested, in kilograms"
	sum				harvkg, detail
	*** this is across all crops
	*** average 281, max 24000, min 0 

* replace any +3 s.d. away from median as missing
	replace			harvkg = . if harvkg > `r(p50)'+(3*`r(sd)')
	sum				harvkg, detail
	*** replaced 122 values, max is now 2208 
	
* impute missing values
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed harvkg // identify kilo_fert as the variable being imputed
	sort			hh_num extension field parcel ord cropid, stable // sort to ensure reproducability of results
	mi impute 		pmm harvkg i.clusterid i.cropid, add(1) rseed(245780) ///
						noisily dots force knn(5) bootstrap
	mi 				unset	

* how did the imputation go?
	tab				mi_miss
	tabstat			harvkg harvkg_1_, by(mi_miss) ///
						statistics(n mean min max) columns(statistics) ///
						longstub format(%9.3g) 
	replace			harvkg = harvkg_1_
	lab var			harvkg "kg of harvest, imputed"
	drop			harvkg_1_
	*** imputed 228 out of 8678 total observations
	*** mean from 219 to 226, max at 2208, min at 0 (no change in min or max)

	
* **********************************************************************
* 3 - prices 
* **********************************************************************

* merge in regional information 
	merge m:1		clusterid hh_num extension using "`export'/2014_ms00p1"
	*** 8692 matched, 0 from master not matched, 1839 from using (which is fine)
	keep if _merge == 3
	drop _merge
	
* merge price data back into dataset
	merge m:1 cropid region dept canton zd	        using "`export'/'2014_ase1p2_p1.dta", gen(p1)
	drop			if p1 == 2
	
	merge m:1 cropid region dept canton 	        using "`export'/'2014_ase1p2_p2.dta", gen(p2)
	drop			if p2 == 2
	
	merge m:1 cropid region dept 			        using "`export'/'2014_ase1p2_p3.dta", gen(p3)
	drop			if p3 == 2
	
	merge m:1 cropid region 						using "`export'/'2014_ase1p2_p4.dta", gen(p4)
	drop			if p4 == 2
	
	merge m:1 cropid 						        using "`export'/'2014_ase1p2_p5.dta", gen(p5)
	keep			if p5 == 3
	*** 4 deleted - no prices for these crops
	
	drop p1 p2 p3 p4 p5

* check to see if we have prices for all crops
	tabstat 		p_zd n_zd p_can n_can p_dept n_dept p_reg n_reg p_crop n_crop, ///
						by(cropid) longstub statistics(n min p50 max) columns(statistics) format(%9.3g) 
	*** no prices for fonio, wheat (ble), mint (menthe)
	
* drop if we are missing prices
	drop			if p_crop == .
	*** dropped 17 observations
	
* make imputed price, using median price where we have at least 10 observations
* this code differs from Malawi - seems like their code ignores prices 
	generate 		croppricei = .
	*** 8659 missing values generated
	
	bys cropid (clusterid hh_num extension field parcel ord): replace croppricei = p_zd if n_zd>=10 & missing(croppricei)
	*** 583 replaced
	bys cropid (clusterid hh_num extension field parcel ord): replace croppricei = p_can if n_can>=10 & missing(croppricei)
	*** 391 replaced
	bys cropid (clusterid hh_num extension field parcel ord): replace croppricei = p_dept if n_dept>=10 & missing(croppricei)
	*** 2002 replaced 
	bys cropid (clusterid hh_num extension field parcel ord): replace croppricei = p_reg if n_reg>=10 & missing(croppricei)
	*** 4559 replaced
	bys cropid (clusterid hh_num extension field parcel ord): replace croppricei = p_crop if missing(croppricei)
	*** 1124 replaced 
	label 			variable croppricei	"implied unit value of crop"

* verify that prices exist for all crops
	mdesc 			croppricei
	*** 0 missing
	
	sum 			cropprice croppricei
	*** mean = 0.315, max = 2.23
	
* generate value of harvest 
	gen				cropvalue = harvkg * croppricei
	label 			variable cropvalue	"implied value of crops" 
	
* verify that we have crop value for all observations
	mdesc 			cropvalue
	*** 0 missing

* replace any +3 s.d. away from median as missing, by cropid
	sum 			cropvalue, detail
	replace			cropvalue = . if cropvalue > `r(p50)'+ (3*`r(sd)')
	sum				cropvalue, detail
	*** replaced 160 values
	
* impute missing values
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed cropvalue // identify kilo_fert as the variable being imputed
	sort			hh_num extension field parcel ord cropid, stable // sort to ensure reproducability of results
	mi impute 		pmm cropvalue i.clusterid i.cropid, add(1) rseed(245780) ///
						noisily dots force knn(5) bootstrap
	mi 				unset	

* how did the imputation go?
	tab				mi_miss
	tabstat			cropvalue cropvalue_1_, by(mi_miss) ///
						statistics(n mean min max) columns(statistics) ///
						longstub format(%9.3g) 
	replace			cropvalue = cropvalue_1_
	lab var			cropvalue "value of harvest, imputed"
	drop			cropvalue_1_
	*** imputed 228 out of 8659 total observations
	*** mean from 51.4 to 52.8, max at 379, min at 0 (no change in min or max)
	
	
* **********************************************************************
* 4 - examine millet harvest quantities
* **********************************************************************

* check to see if outliers can be dealt with
	sum 			harvkg if cropid == 1
	*** mean = 367, max = 2208, min = 0 
	
* generate new variable that measures millet (1) harvest
	gen 			mz_hrv = harvkg 	if 	cropid == 1
	*** for consistency going to keep the mz abbreviation though crop is millet
	
* create variable =1 if millet was damaged	
	gen				mz_damaged = 1		if  cropid == 1 ///
						&  AS02EQ08 == 1 & AS02EQ09 == 100
	sort			mz_damaged
	replace			mz_damaged = 0 if mz_damaged == .
	*** all damaged millet have yield zero
						
* replace any +3 s.d. away from median as missing
	sum				mz_hrv, detail
	replace			mz_hrv = . if mz_hrv > `r(p50)' + (3*`r(sd)')
	sum				mz_hrv
	*** replaced 92 values, max is now 1350 instead of 2208
	
* impute missing values
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed mz_hrv // identify kilo_fert as the variable being imputed
	sort			hh_num extension field parcel ord cropid, stable // sort to ensure reproducability of results
	mi impute 		pmm mz_hrv i.clusterid if cropid == 1, add(1) rseed(245780) ///
						noisily dots force knn(5) bootstrap
	mi 				unset	

* how did the imputation go?
	tab				mi_miss1 if cropid == 1
	tabstat			mz_hrv mz_hrv_1_ if cropid == 1, by(mi_miss) ///
						statistics(n mean min max) columns(statistics) ///
						longstub format(%9.3g) 
	replace			mz_hrv = mz_hrv_1_  if cropid == 1
	lab var			mz_hrv "Quantity of maize harvested (kg)"
	drop			mz_hrv_1_
	*** imputed 92 values out of 3337 total values
	*** mean from 3329 332, max 1350 (no change), min 0 (no change)

* replace non-maize harvest values as missing
	replace			mz_hrv = . if mz_damaged == 0 & mz_hrv == 0
	*** 13 changes made 

	
* **********************************************************************
* 5 - end matter, clean up to save
* **********************************************************************

* create unique household-plot identifier
	sort				clusterid hh_num extension ord field parcel
	egen				plot_id = group(clusterid hh_num extension ord field parcel)
	lab var				plot_id "unique field and parcel identifier"

* create unique household-plot-crop identifier
	isid				clusterid hh_num extension ord field parcel cropid
	sort				clusterid hh_num extension ord field parcel cropid
	egen				cropplot_id = group(clusterid hh_num extension ord field parcel cropid)
	lab var				cropplot_id "unique field and parcel and crop identifier"

	compress
	describe
	summarize

* save file
	customsave , idvar(plot_id) filename("2014_ase1p2_1.dta") ///
		path("`export'") dofile(2014_ase1p2_1) user($user)

* close the log
	log		close

/* END */
