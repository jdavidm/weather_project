* Project: WB Weather
* Created on: May 2020
* Created by: ek
* Stata v.16

* does
	* reads in Nigera, WAVE 1 (2011), POST HARVEST (first visit), ECVMA2_AS2E2P2
	* determines primary crop & cleans harvest
	* converts to kilograms
	* produces value of harvest (Naria) 
	* including determining regional prices ... 
	* outputs clean data file ready for combination with wave 1 hh data

* assumes
	* customsave.ado
	* probably a conversion file
	
* TO DO:
	* EVERYTHING
	* clarify "does"
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc 	root	= 	"$data/household_data/niger/wave_1/raw"
	loc 	export	= 	"$data/household_data/niger/wave_1/refined"
	loc 	cnvrt	= 	"$data/household_data/niger/wave_1/raw"
	loc 	logout	= 	"$data/household_data/niger/logs"

* open log
	cap log close 
	log 	using 	"`logout'/2011_AS2E1P2_p", append

* **********************************************************************
* 1 - harvest information
* **********************************************************************

* import the first relevant data file
	use "`root'/ecvmaas2e_p2_en.dta", clear 
	
* need to rename for English
	rename 			passage visit
	label 			var visit "number of visit"
	rename			grappe clusterid
	label 			var clusterid "cluster number"
	rename			menage hh_num
	label 			var hh_num "household number - not unique id"
	*** will need to do these in every file
	rename 			as02eq0 ord 
	label 			var ord "number of order		
	
* need to include clusterid, hhnumber, order, field, and parcel to uniquely identify
	describe
	sort 			clusterid hh_num ord 
	isid 			clusterid hh_num ord 
		
	rename 			as02eq06 cropid
	tab 			cropid
	tab 			as02eq05 if cropid == 48
	*** 31 are other
	*** include sugar cane, morgina, malohiya, etc. 
	*** only 31 out of 11983 - drop them
	drop			if cropid == 48
	
* examine market participation 
	tab 			as02eq11
	rename 			as02eq11 soldprod
	replace			soldprod = . if soldprod == 9 
	tab 			soldprod 
	*** 1300 (10.86 percent) sold crops 

* examine kg harvest value sold
	tab 			as02eq12c, missing
	*** 10795 missing
	
	replace			as02eq12c = . if as02eq12c == 9999 
	*** 9 changed to missing (obs = 9999) - seems to be . in many cases for Niger
	
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
	*** average 245.95, max 11000, min 2 
	*** how could you sell zero - replace to missing

* replace any +3 s.d. away from median as missing, by cropid
	sort 			cropid
	sum				harvkgsold, detail 
	by 				cropid: replace	harvkgsold = . if harvkgsold > `r(p50)'+ (3*`r(sd)')
	sum				harvkgsold, detail
	*** replaced 32 values, max is now 2595, mean 122.9  
	
* impute missing values
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed harvkgsold // identify harvkgsold as the variable being imputed
	sort			clusterid hh_num ord cropid, stable // sort to ensure reproducability of results
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
	*** imputed observations changed 45 observations for people who sold 
	*** mean 122.9 to 148.83, max stays at 2595 
	
* check out amount sold
* currently reported in West African CFA franc
	tab 			as02eq13 
	rename			as02eq13 earnwaf
	replace 		earnwaf = . if earnwaf == 9999999 
	*** 2 changed to missing

	
* convert to usd
	gen 			earn = earnwaf/517.0391802
	lab var			earn 	"total earnings from sales in 2010 USD"
	tab 			earn, missing
	*** 10787 missing
	sum				earn, detail
	*** mean 60.9, max 4255, min 0.3868
	*** total of 1273 observations 
	
* **********************************************************************
* 3 - price information - following ag_i in Malawi 
* **********************************************************************

* merge in regional information 
	merge m:1		clusterid hh_num using "`export'/2011_ms00p1"
	*** 12058 matched, 2 from master not matched, 1720 from using (which is fine)
	keep if _merge == 3
	drop _merge

* condensed crop codes
	inspect 		cropid
	*** generally things look all right - only 30 unique values 

* gen price per kg
	sort 			cropid
	by 				cropid: gen cropprice = earn / harvkgsold 
	*** 10785 missing values, but 10,661 did not sell
	sum 			cropprice, detail
	*** mean = 0.427, max = 10.82, min = 0.0193
	*** will do some imputations later

* rename enumeration zd
	rename 			enumeration zd
	lab var 		zd "enumeration zone"
	
* make datasets with crop price information
	preserve
	collapse 		(p50) p_zd=cropprice (count) n_zd=cropprice, by(cropid region dept canton zd)
	save 			"`export'/2011_ase1p2_p1.dta", replace 
	restore
	
	preserve
	collapse 		(p50) p_can=cropprice (count) n_can=cropprice, by(cropid region dept canton)
	save 			"`export'/2011_ase1p2_p2.dta", replace 	
	restore
	
	preserve
	collapse 		(p50) p_dept=cropprice (count) n_dept=cropprice, by(cropid region dept)
	save 			"`export'/2011_ase1p2_p3.dta", replace 	
	restore
	
	preserve
	collapse 		(p50) p_reg=cropprice (count) n_reg=cropprice, by(cropid region)
	save 			"`export'/2011_ase1p2_p4.dta", replace 
	restore
	
	preserve
	collapse 		(p50) p_crop=cropprice (count) n_crop=cropprice, by(cropid)
	save 			"`export'/2011_ase1p2_p5.dta", replace 
		
* **********************************************************************
* 4 - end matter, clean up to save
* **********************************************************************

* if directly following malawi, would be able to proceed with different process
* however, did not work in niger
* mismatched when attemping to match it into harvest file 
* look at malawi code for reference, as needed 
* but see 2014_ase1p2 for next steps

	clear 

* close the log
	log		close

/* END */	
	