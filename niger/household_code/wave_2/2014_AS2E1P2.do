* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 2 (2014), POST HARVEST, ECVMA2 AS2E1P2
	* determines primary crops, cleans harvest (quantity in kg)
	* determines harvest for all crops - to determine value (based on prices)
	* outputs clean data file ready for combination with wave 2 plot data

* assumes
	* customsave.ado
	* mdesc.ado
	* harvconv.dta conversion file

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
	log 	using 	"`logout'/2014_AS2E1P2_1", append

* **********************************************************************
* 1 - harvest information
* **********************************************************************


* import the first relevant data file
	use				"`root'/ECVMA2_AS2E1P2", clear
		
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
		
	rename 				CULTURE cropid
	tab 				cropid
	*** main crop is "mil" = millet 
	*** cropcode for millet == 1
	*** second crop is cowpea, third is sorghum ... and then a huge (thousands) diference to peanut 

* drop observations in which it was not harvest season
	tab 				AS02EQ06A
	*** month started harvesting
	tab 				AS02EQ06B
	*** month finished harvesting
	drop if 		AS02EQ06A == 0 | AS02EQ06A == 1 | AS02EQ06A == 2 | ///
					AS02EQ06A == 3 | AS02EQ06A == 4 | AS02EQ06A == 5 | ///
					AS02EQ06A == 6 | AS02EQ06A == 7 
	*** drops 826 observations
	
* examine kg harvest value
	tab 			AS02EQ07C, missing
	*** 334 missing
	replace			AS02EQ07C = . if AS02EQ07C > 999997 
	*** 24 changed to missing (obs = 999998 and 999999) - seems to be . in many cases for Niger
	rename 			AS02EQ07C harvkg 

* convert missing harvest data to zero if harvest was lost to event
	replace			harvkg = 0 if AS02EQ08 == 1 & AS02EQ09 == 100
	*** 315 missing changed to 0

	describe
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

* replace any +3 s.d. away from median as missing, by cropid
	sort 			cropid
	by 				cropid: replace	harvkg = . if harvkg > `r(p50)'+(3*`r(sd)')
	sum				harvkg, detail
	*** replaced 123 values, max is now 2208 
	
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
	*** imputed 231 out of 8702 total observations
	*** mean from 219 to 225, max at 2208, min at 0 (no change in min or max)
	
* **********************************************************************
* 3 - examine millet harvest quantities
* **********************************************************************

* things should be addressed above - but will examine millet specifically

* check to see if outliers can be dealt with
	sum harvkg if 	cropid == 1
	*** mean = 365.96
	*** max = 2208
	*** min = 0 
	
* generate new variable that measures millet (1) harvest
	gen 			mz_hrv = harvkg 	if 	cropid == 1
	gen				mz_damaged = 1		if  cropid == 1 ///
						& mz_hrv == 0
	*** for consistency going to keep the mz abbreviation 
	*** 8617 missing values generated 
						
* summarize value of harvest
	sum				mz_hrv, detail
	*** no change from above 365.96, 2209, 0 

* replace any +3 s.d. away from median as missing
	replace			mz_hrv = . if mz_hrv > `r(p50)' + (3*`r(sd)')
	sum				mz_hrv, detail
	*** replaced 96 values, max is now 1350
	
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
	*** imputed 96 values out of 3340 total values
	*** mean from 327 to 329, max 1350 (no change), min 0 (no change)

* replace non-maize harvest values as missing
	replace			mz_hrv = . if mz_damaged == 0 & mz_hrv == 0
	*** 0 changes made 
	
* **********************************************************************
* 4 - end matter, clean up to save
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
