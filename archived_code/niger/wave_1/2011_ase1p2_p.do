* Project: WB Weather
* Created on: May 2020
* Created by: ek
* Stata v.16

* does
	* reads in Niger, WAVE 1 (2011), POST HARVEST, ecvmaas2e_p2_en
	* file will broadly follow ag_i from Malawi "kitchen sink"
	* cleans harvest (quantity in kg)
	* determines prices and thus values 
	* outputs clean data file ready for combination with wave 1 plot data

* assumes
	* customsave.ado
	* mdesc.ado

* TO DO:
	* done

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc 	root	= 	"$data/household_data/niger/wave_1/raw"
	loc 	export	= 	"$data/household_data/niger/wave_1/refined"
	loc 	cnvrt	= 	"$data/household_data/niger/wave_1/refined"
	loc 	logout	= 	"$data/household_data/niger/logs"

* open log
	cap 	log 	close
	log 	using 	"`logout'/2011_as2e1p2_p", append

* **********************************************************************
* 1 - harvest information
* **********************************************************************

* import the first relevant data file
	use				"`root'/ecvmaas2e_p2_en", clear
	*** not exact match in file name 
	
* need to rename for English
	rename 			passage visit
	label 			var visit "number of visit"
	rename			grappe clusterid
	label 			var clusterid "cluster number"
	rename			menage hh_num
	label 			var hh_num "household number - not unique id"
	*** no variable known as extension in this file or this wave
	rename 			as02eq0 ord 
	label 			var ord "number of order"
	*** field and parcel not recorded in this file
	
	* need to include clusterid, hhnumber, order, field, and parcel to uniquely identify
	describe
	sort 			clusterid hh_num ord 
	isid 			clusterid hh_num ord 
		
	rename 			as02eq06 cropid
	tab 			cropid
	*** 31 are "other" 
	*** include zucchini, morgina, cane sugar, spice, malohiya, etc. 
	*** only 31 out of 11983 - drop them
	drop			if cropid == 48
	
	* examine market participation 
	tab 			as02eq11
	rename 			as02eq11 soldprod
	replace			soldprod = . if soldprod == 9 
	tab 			soldprod 
	*** 1300 (11 percent) sold crops 

* examine kg harvest value sold
	tab 			as02eq12c, missing
	*** 10795 missing
	replace			as02eq12c = . if as02eq12c > 8999 
	*** 14 changed to missing (obs = 9999) - seems to be . in many cases for Niger
	rename 			as02eq12c harvkgsold 

	describe
	sort 			clusterid hh_num ord
	isid 			clusterid hh_num ord 

* **********************************************************************
* 2 - generate sold harvested values
* **********************************************************************

* examine quantity harvested variable sold
	lab	var			harvkgsold "quantity harvested and sold, in kilograms"
	sum				harvkgsold, detail
	*** this is across all crops
	*** average 230, max 7200, min 2 
	*** how could you sell zero - replace to missing 

* replace any +3 s.d. away from median as missing, by cropid
	sort 			cropid
	sum				harvkgsold, detail 
	by 				cropid: replace	harvkgsold = . if harvkgsold > `r(p50)'+ (3*`r(sd)')
	sum				harvkgsold, detail
	*** replaced 35 values, max is now 2204, mean 124  
	
* impute missing values
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed harvkgsold // identify harvkgsold as the variable being imputed
	sort			hh_num ord cropid, stable // sort to ensure reproducability of results
	mi impute 		pmm harvkg i.clusterid i.cropid, add(1) rseed(245780) ///
						noisily dots force knn(5) bootstrap
	mi 				unset	

* how did the imputation go?
	tab				mi_miss
	tabstat			harvkgsold harvkgsold_1_, by(mi_miss) ///
						statistics(n mean min max) columns(statistics) ///
						longstub format(%9.3g) 
	replace			harvkgsold = harvkgsold_1_ if soldprod == 1
	lab var			harvkgsold "kg of harvest sold, imputed (only if produce was sold)"
	drop			harvkgsold_1_
	sum 			harvkgsold
	*** imputed observations changed 49 observations for people who sold 
	*** mean 124 to 142, max is 2150
	
* check out amount sold
	*** currently reported in West African CFA franc
	tab 			as02eq19c 
	rename			as02eq19c earnwaf
	replace 		earnwaf = . if earnwaf == 9999999 
	*** 9 changed to missing
	replace 		earnwaf = . if earnwaf == 0 
	*** 4078 changed to missing
	
* convert to usd
	gen 			earn = earnwaf/517.0391802
	lab var			earn 	"total earnings from sales in 2010 USD"
	tab 			earn, missing
	sum 			earn, detail
	*** mean 16, max is 116 and min is 0.009
	*** 12060 missing
	
	*** will impute missing money values from observations that reported selling but also reported receiving value of zero for selling
	
	* impute missing values
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed earn // identify earn as the variable being imputed
	sort			hh_num ord cropid, stable // sort to ensure reproducability of results
	mi impute 		pmm earn i.clusterid i.cropid, add(1) rseed(245780) ///
						noisily dots force knn(5) bootstrap
	mi 				unset	

* how did the imputation go?
	tab				mi_miss
	tabstat			earn earn_1_, by(mi_miss) ///
						statistics(n mean min max) columns(statistics) ///
						longstub format(%9.3g) 
	replace			earn = earn_1_ if soldprod == 1
	lab var			earn "total earnings from sales in 2010 USD, imputed (only if produce was sold)"
	drop			earn_1_
	sum				earn, detail
	*** imputed 1273
	*** mean 8 from 16, max 116, min 0.009, min and max stay the same
	
* **********************************************************************
* 3 - price information - following ag_i in Malawi 
* **********************************************************************

* merge in regional information 
	merge m:1		clusterid hh_num using "`cnvrt'/2011_ms00p1"
	*** 12058 matched, 2 from master not matched, 1720 from using (lower number not matched compared to wave 2 therefore accept)
	keep if _merge == 3
	drop _merge

	* condensed crop codes
	inspect 		cropid
	*** generally things look all right - only 30 unique values 

* gen price per kg
	sort 			cropid
	by 				cropid: gen cropprice = earn / harvkgsold 
	*** 12499 missing values, 1279 not missing
	sum 			cropprice, detail
	*** mean = 0.344, max = 8.46, min = 0.0000111
	*** will do some imputations later
	
* make datasets with crop price information
	preserve
	collapse 		(p50) p_zd=cropprice (count) n_zd=cropprice, by(cropid region dept canton)
	save 			"`export'/'2011_ase1p2_p1.dta", replace 
	restore
	
	preserve
	collapse 		(p50) p_can=cropprice (count) n_can=cropprice, by(cropid region dept canton)
	save 			"`export'/'2011_ase1p2_p2.dta", replace 	
	restore
	
	preserve
	collapse 		(p50) p_dept=cropprice (count) n_dept=cropprice, by(cropid region dept)
	save 			"`export'/'2011_ase1p2_p3.dta", replace 	
	restore
	
	preserve
	collapse 		(p50) p_reg=cropprice (count) n_reg=cropprice, by(cropid region)
	save 			"`export'/'2011_ase1p2_p4.dta", replace 
	restore
	
	preserve
	collapse 		(p50) p_crop=cropprice (count) n_crop=cropprice, by(cropid)
	save 			"`export'/'2011_ase1p2_p5.dta", replace 
	restore
	
	* merge price data back into dataset
	merge m:1 cropid region dept canton 	        using "`export'/'2011_ase1p2_p2.dta", assert(3) nogenerate
	merge m:1 cropid region dept 			        using "`export'/'2011_ase1p2_p3.dta", assert(3) nogenerate
	merge m:1 cropid region 						using "`export'/'2011_ase1p2_p4.dta", assert(3) nogenerate
	merge m:1 cropid 						        using "`export'/'2011_ase1p2_p5.dta", assert(3) nogenerate
	
* **********************************************************************
* 4 - end matter, clean up to save
* **********************************************************************
	
	* drop observations missing a cropid in order to make unique identifier
	drop if cropid==.

* create unique identifier (value exists only for saving)
	isid				clusterid hh_num ord cropid
	sort				clusterid hh_num ord cropid 
	egen				ident = group(clusterid hh_num ord) 
	lab var				ident "unique identifier"

	compress
	describe
	summarize

* save file
	customsave , idvar(ident) filename("2011_ase1p2_p.dta") ///
		path("`export'") dofile(2011_ase1p2_p) user($user)

* close the log
	log		close

/* END */
