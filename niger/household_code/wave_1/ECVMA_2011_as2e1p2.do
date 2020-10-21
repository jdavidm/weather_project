* Project: WB Weather
* Created on: Aug 2020
* Created by: ek
* Stata v.16

* does
	* reads in Niger, WAVE 1 (2011), POST HARVEST, ecvmaas2e_p2_en
	* determines primary crops, cleans harvest (quantity in kg)
	* merges in price files that are already in USD
	* determines harvest for all crops - to determine value 
	* outputs clean data file ready for combination with wave 1 plot data

* assumes
	* cleaned price files from AS2E2P2
	* customsave.ado
	
* To Do:
	* done


* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		root	=		"$data/household_data/niger/wave_1/raw"
	loc		export	=		"$data/household_data/niger/wave_1/refined"
	loc		logout	= 		"$data/household_data/niger/logs"

* open log
	cap 	log 	close
	log 	using	"`logout'/2014_AS2E1P2", append

* **********************************************************************
* 1 - describing plot size - self-reported and GPS
* **********************************************************************
	
* import the first relevant data file
	use				"`root'/ecvmaas2e_p2_en", clear
	duplicates 		drop
	
	rename 			passage visit
	label 			var visit "number of visit - wave number"
	rename			grappe clusterid
	label 			var clusterid "cluster number"
	rename			menage hh_num
	label 			var hh_num "household number - not unique id"
	rename 			as02eq0 ord 
	label 			var ord "number of order"
	*** note that ord is the id number
	rename 			as02eq01 field 
	label 			var field "field number"
	rename 			as02eq03 parcel 
	label 			var parcel "parcel number"
	*** cant find "extension" variable like they have in wave 2. 
	
* need to include clusterid, hhnumber, order, field, and parcel to uniquely identify
	describe
	sort 			clusterid hh_num ord field parcel
	isid 			clusterid hh_num ord field parcel
	
	rename 			as02eq06 cropid
	tab 			cropid
	*** main crop is "mil" = millet 
	*** cropcode for millet == 1
	*** second crop is cowpea, third is sorghum and then peanuts a distant fourth
	
* drop if crop is "other"
	drop if cropid == 48
	
* drop observations in which it was not harvest season. Identify harvest season if farmers say they worked the land this rainy season
	tab as02eq04
	drop if as02eq04 == 2
	*** dropped 108 observations
	
* rename variables associated with harvest
	rename 			as02eq07c harvkg 
	rename 			as02eq07a harv 

* make harvkg 0 if household said they harvested nothing
	replace			harvkg = 0 if harvkg == . & harv == 0 	
	*** 3140 changes
	
* make harvkg missing if household said they did not harvest
	replace 		harvkg = . if harvkg == 0 & harv != 0 
	*** 0 changes

* replace miscoded variables as missing 
	replace			harvkg = . if harvkg > 999997 
	replace 		harv = 0 if harvkg == . & harv == 999999
	replace 		harvkg = 0 if harv == 0
	*** 11 changes (obs = 999998 and 999999) - seems to be . in many cases for Niger
	replace 		harvkg = 0 if harv == .
	replace 		harv = 0 if harvkg == 0 & harv == .
	*** 5 changes made
	
* convert missing harvest data to zero if harvest was lost to event
	replace			harvkg = 0 if as02eq08 == 1 & as02eq09 == 100
	*** 23 changes made

	sort 			clusterid hh_num ord field parcel
	isid 			clusterid hh_num ord field parcel
	
* **********************************************************************
* 2 - generate harvested values
* **********************************************************************

* examine quantity harvested variable
	lab	var			harvkg "quantity harvested, in kilograms"
	sum				harvkg, detail
	*** this is across all crops
	*** average  127.11, max 15000, min 0 

* replace any +3 s.d. away from median as missing
	replace			harvkg = . if harvkg > `r(p50)'+(3*`r(sd)')
	sum				harvkg, detail
	*** replaced 119 values, max is now 1392 
	
* impute missing values
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed harvkg // identify harvkg as the variable being imputed
	sort			hh_num field parcel ord cropid, stable // sort to ensure reproducability of results
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
	sum 			harvkg
	*** imputed 119 observations
	*** mean from 127.11 to 97.67, max unchanged at 1392
	
* **********************************************************************
* 3 - prices 
* **********************************************************************

* merge in regional information 
	merge m:1		clusterid hh_num using "`export'/2011_ms00p1"
	*** 11950 matched, 2 not matched from master, 1720 not matched from using
	
	keep if _merge == 3
	drop _merge
	
* rename enumeration zd
	rename 			enumeration zd
	label var 		zd "enumeration"
	
* merge price data back into dataset
	
	merge m:1 cropid region dept canton zd	        using "`export'/2011_ase1p2_p1.dta", gen(p1)
	drop			if p1 == 2
	*** 1 observation deleted
	
	merge m:1 cropid region dept canton 	        using "`export'/2011_ase1p2_p2.dta", gen(p2)
	drop			if p2 == 2
	*** 1 observation deleted

	merge m:1 cropid region dept 			        using "`export'/2011_ase1p2_p3.dta", gen(p3)
	drop			if p3 == 2
	*** 1 observation deleted

	merge m:1 cropid region 						using "`export'/2011_ase1p2_p4.dta", gen(p4)
	drop			if p4 == 2
	*** 1 observation deleted
	
	merge m:1 cropid 						        using "`export'/2011_ase1p2_p5.dta", gen(p5)
	keep			if p5 == 3
	*** 1 observation deleted
	
* erase price files
	erase			"`export'/2011_ase1p2_p1.dta"
	erase			"`export'/2011_ase1p2_p2.dta"
	erase			"`export'/2011_ase1p2_p3.dta"
	erase			"`export'/2011_ase1p2_p4.dta"
	erase			"`export'/2011_ase1p2_p5.dta"
	
	drop p1 p2 p3 p4 p5

* check to see if we have prices for all crops
	tabstat 		p_can n_can p_dept n_dept p_reg n_reg p_crop n_crop, ///
						by(cropid) longstub statistics(n min p50 max) columns(statistics) format(%9.3g) 
	*** no prices for cucumbeer, gourd, cotton, fonio, wheat, gourd, souchet
	*** few observations in those crops
	
* drop if we are missing prices
	drop			if p_crop == .
	*** dropped 34 observations
	
* make imputed price, using median price where we have at least 10 observations
* this code generlaly files parts of malawi ag_i
* but this differs from Malawi - seems like their code ignores prices 
	gene	 		croppricei = .
	*** 11916 missing values generated
	
	bys cropid (clusterid hh_num field parcel ord): replace croppricei = p_zd if n_zd>=10 & missing(croppricei)
	*** 11746 replaced
	bys cropid (clusterid hh_num field parcel ord): replace croppricei = p_can if n_can>=10 & missing(croppricei)
	*** 0 replaced
	bys cropid (clusterid hh_num field parcel ord): replace croppricei = p_dept if n_dept>=10 & missing(croppricei)
	*** 0 replaced 
	bys cropid (clusterid hh_num field parcel ord): replace croppricei = p_reg if n_reg>=10 & missing(croppricei)
	*** 0 replaced
	bys cropid (clusterid hh_num field parcel ord): replace croppricei = p_crop if missing(croppricei)
	*** 170 replaced 
	lab	var			croppricei	"implied unit value of crop"

* verify that prices exist for all crops
	mdesc 			croppricei
	*** 0 missing
	
	sum 			cropprice croppricei
	*** mean = 0.316, max = 3.245
	
* generate value of harvest 
	gen				cropvalue = harvkg * croppricei
	label 			variable cropvalue	"implied value of crops" 
	
* verify that we have crop value for all observations
	mdesc 			cropvalue
	*** 0 missing

* replace any +3 s.d. away from median as missing, by cropid
	sum 			cropvalue, detail
	*** mean 29.0, max 1135.6
	replace			cropvalue = . if cropvalue > `r(p50)'+ (3*`r(sd)')
	sum				cropvalue, detail
	*** replaced 352 values
	*** reduces mean to 21.92, max to 170.66 
	
* impute missing values
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed cropvalue // identify cropvalue as the variable being imputed
	sort			hh_num field parcel ord cropid, stable // sort to ensure reproducability of results
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
	sum 			cropvalue
	*** imputed 352 out of 11916 total observations
	*** mean from 21.9 to 22.6, max at 170.66 no change in max

* **********************************************************************
* 4 - examine millet harvest quantities
* **********************************************************************

* check to see if outliers can be dealt with
	sum 			harvkg if cropid == 1
	*** mean = 166.68, max = 1357, min = 0 
	
* generate new variable that measures millet (1) harvest
	gen 			mz_hrv = harvkg 	if 	cropid == 1
	*** for consistency going to keep the mz abbreviation though crop is millet
	
* create variable =1 if millet was damaged	
	replace 		as02eq09 = . if as02eq09 == 999
	gen				mz_damaged = 1		if  cropid == 1 ///
						&  as02eq08 == 1 & as02eq09 == 100
	sort			mz_damaged
	tab 			mz_damaged, missing
	replace			mz_damaged = 0 if mz_damaged == . & cropid == 1
	*** all damaged millet have harvkg = zero
						
* replace any +3 s.d. away from median as missing
	sum				mz_hrv, detail
	replace			mz_hrv = . if mz_hrv > `r(p50)' + (3*`r(sd)')
	sum				mz_hrv
	*** replaced 142 values, max is now 710 instead of 1357
	
* impute missing values
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed mz_hrv // identify mz_hrv as the variable being imputed
	sort			hh_num field parcel ord cropid, stable // sort to ensure reproducability of results
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
	sum				mz_hrv
	*** imputed 142 values out of 4471 total values
	*** mean from 141.2 to 143.2, max 710 (no change), min 0 (no change)

* replace non-maize harvest values as missing
	replace			mz_hrv = . if mz_damaged == 0 & mz_hrv == 0
	*** 33 changes made 

* **********************************************************************
* 5 - end matter, clean up to save
* **********************************************************************

* create unique household-plot identifier
	sort			clusterid hh_num ord field parcel
	egen			plot_id = group(clusterid hh_num ord field parcel)
	lab var			plot_id "unique field and parcel identifier"

* create unique household-plot-crop identifier
	isid			clusterid hh_num ord field parcel cropid
	sort			clusterid hh_num ord field parcel cropid
	egen			cropplot_id = group(clusterid hh_num ord field parcel cropid)
	lab var			cropplot_id "unique field and parcel and crop identifier"
	
	keep 			clusterid hh_num ord field parcel region dept canton zd cropplot_id plot_id /// 
					mz_hrv mz_damaged cropvalue harvkg cropid 
					
	rename 			cropvalue vl_hrv 
	lab	var			vl_hrv "value of harvest, in 2010 USD"

	compress
	describe
	summarize

* save file
	customsave , idvar(cropplot_id) filename("2011_ase1p2.dta") ///
		path("`export'") dofile(2011_ase1p2) user($user)

* close the log
	log		close

/* END */
