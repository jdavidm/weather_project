* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Niger, WAVE 2 (2014), POST HARVEST, ECVMA2 AS2E1P2
	* file will broadly follow ag_i from Malawi "kitchen sink"
	* cleans harvest (quantity in kg)
	* determines prices and thus values 
	* outputs clean data file ready for combination with wave 2 plot data

* assumes
	* customsave.ado
	* mdesc.ado

* TO DO:
	* all of it

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc 	root	= 	"$data/household_data/niger/wave_2/raw"
	loc 	export	= 	"$data/household_data/niger/wave_2/refined"
	loc 	cnvrt	= 	"$data/household_data/niger/wave_2/raw"
	loc 	logout	= 	"$data/household_data/niger/logs"

* open log
	log 	using 	"`logout'/2014_AS2E1P2_p", append

* **********************************************************************
* 1 - harvest information
* **********************************************************************

* import the first relevant data file
	use				"`root'/ECVMA2_AS2E2P2", clear
	*** not exact match in file name 
		
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
	rename 			AS02EQD ord 
	label 			var ord "number of order"
	*** field and parcel not recorded in this file
	
* need to include clusterid, hhnumber, extension, order, field, and parcel to uniquely identify
	describe
	sort 			clusterid hh_num extension ord 
	isid 			clusterid hh_num extension ord 
		
	rename 			AS02EQ110B cropid
	tab 			cropid
	*** 19 are "autre" 
	*** include zucchini, morgina, cane sugar, spice, malohiya, etc. 
	*** only 19 out of 5225 - drop them
	drop			if cropid == 48
	

* examine market participation 
	tab 			AS02EQ11
	rename 			AS02EQ11 soldprod
	replace			soldprod = . if soldprod == 9 
	tab 			soldprod 
	*** 1067 (22 percent) sold crops 

* examine kg harvest value sold
	tab 			AS02EQ12C, missing
	*** 4134 missing
	replace			AS02EQ12C = . if AS02EQ12C > 8999 
	*** 12 changed to missing (obs = 9999) - seems to be . in many cases for Niger
	rename 			AS02EQ12C harvkgsold 

	describe
	sort 			clusterid hh_num extension ord
	isid 			clusterid hh_num extension ord 

* **********************************************************************
* 2 - generate sold harvested values
* **********************************************************************

* examine quantity harvested variable sold
	lab	var			harvkgsold "quantity harvested and sold, in kilograms"
	sum				harvkgsold, detail
	*** this is across all crops
	*** average 426, max 8960, min 0 
	*** how could you sell zero - replace to missing
	replace 		harvkgsold = . if harvkgsold == 0 
	*** 24 changed to missing 

* replace any +3 s.d. away from median as missing, by cropid
	sort 			cropid
	sum				harvkgsold, detail 
	by 				cropid: replace	harvkgsold = . if harvkgsold > `r(p50)'+ (3*`r(sd)')
	sum				harvkgsold, detail
	*** replaced 38 values, max is now 1446, mean 191  
	
* impute missing values
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed harvkgsold // identify kilo_fert as the variable being imputed
	sort			hh_num extension ord cropid, stable // sort to ensure reproducability of results
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
	*** imputed observations changed 100 observations for people who sold 
	*** mean 191 to 156, max stays at 1446 
	
* check out amount sold
* currently reported in West African CFA franc
	tab 			AS02EQ13 
	rename			AS02EQ13 earnwaf
	replace 		earnwaf = . if earnwaf == 9999999 
	*** 6 changed to missing
	replace 		earnwaf = . if earnwaf == 0 
	*** 6 changed to missing
* convert to usd
	gen 			earn = earnwaf/549.4396989
	lab var			earn 	"total earnings from sales in 2010 USD"
	tab 			earn, missing
	*** 4146 missing
	sum				earn, detail
	*** mean 190, max 5496, min 0.018 
	*** total of 1061 observations 
	
* **********************************************************************
* 3 - price information - following ag_i in Malawi 
* **********************************************************************

* merge in regional information 
	merge m:1		clusterid hh_num extension using "`cnvrt'/2014_ms00p1"
	*** 5207 matched, 0 from master not matched, 1817 from using (which is fine)
	keep if _merge == 3
	drop _merge

* condensed crop codes
	inspect 		cropid
	*** generally things look all right - only 30 unique values 

* gen price per kg
	sort 			cropid
	by 				cropid: gen cropprice = earn / harvkgsold 
	*** 4146 missing values
	sum 			cropprice, detail
	*** mean = 0.75, max = 92, min = 0.0003 
	*** will do some imputations later
	
* make datasets with crop price information
	preserve
	collapse 		(p50) p_zd=cropprice (count) n_zd=cropprice, by(cropid region dept canton zd)
	save 			"`export'/'2014_ase1p2_p1.dta", replace 
	restore
	
	preserve
	collapse 		(p50) p_can=cropprice (count) n_can=cropprice, by(cropid region dept canton)
	save 			"`export'/'2014_ase1p2_p2.dta", replace 	
	restore
	
	preserve
	collapse 		(p50) p_dept=cropprice (count) n_dept=cropprice, by(cropid region dept)
	save 			"`export'/'2014_ase1p2_p3.dta", replace 	
	restore
	
	preserve
	collapse 		(p50) p_reg=cropprice (count) n_reg=cropprice, by(cropid region)
	save 			"`export'/'2014_ase1p2_p4.dta", replace 
	restore
	
	preserve
	collapse 		(p50) p_crop=cropprice (count) n_crop=cropprice, by(cropid)
	save 			"`export'/'2014_ase1p2_p5.dta", replace 
	restore

* merge price data back into dataset
	merge m:1 cropid region dept canton zd	        using "`export'/'2014_ase1p2_p1.dta", assert(3) nogenerate
	merge m:1 cropid region dept canton 	        using "`export'/'2014_ase1p2_p2.dta", assert(3) nogenerate
	merge m:1 cropid region dept 			        using "`export'/'2014_ase1p2_p3.dta", assert(3) nogenerate
	merge m:1 cropid region 						using "`export'/'2014_ase1p2_p4.dta", assert(3) nogenerate
	merge m:1 cropid 						        using "`export'/'2014_ase1p2_p5.dta", assert(3) nogenerate

* make total value of all household crop sales
* holding general Malawi code here 
* actually done in different file (with production)
/*	
* make imputed price, using median price where we have at least 10 observations
	tabstat 		p_zd n_zd p_can n_can p_dept n_dept p_reg n_reg p_crop n_crop, ///
						by(cropid) longstub statistics(n min p50 max) columns(statistics) format(%9.3g) 
	generate croppricei = .
	*** 5225 missing values generated
	replace croppricei = p_zd if n_zd>=10 & missing(croppricei)
	*** 259 replaced
	replace croppricei = p_can if n_can>=10 & missing(croppricei)
	*** 235 replaced
	replace croppricei = p_dept if n_dept>=10 & missing(croppricei)
	*** 1126 replaced 
	replace croppricei = p_reg if n_reg>=10 & missing(croppricei)
	*** 2592 replaced
	replace croppricei = p_crop if missing(croppricei)
	*** 998 replaced 
	label variable croppricei	"implied unit value of crop"
	*** label follows Malawi - but I wouldn't classify this as strictly being imputed 

	replace cropprice = croppricei if missing(cropprice) & soldprod == 1
	bysort hh_mum (cropid) : egen cropsales_value = sum(quant * cropprice) 
	label variable cropsales_value	"Self-reported value of crop sales" 
	bysort y3_hhid (cropid) : egen cropsales_valuei = sum(quant * croppricei) 
	label variable cropsales_valuei	"Implied value of crop sales" 
 
* restrict to one observation per household
	bysort y3_hhid (cropid) : keep if _n==1

* restrict to variables of interest 
	keep  y3_hhid cropsales_value cropsales_valuei
	order y3_hhid cropsales_value cropsales_valuei
*/

* **********************************************************************
* 4 - end matter, clean up to save
* **********************************************************************


* create unique identifier (value exists only for saving)
	isid				clusterid hh_num extension ord cropid
	sort				clusterid hh_num extension ord cropid 
	egen				ident = group(clusterid hh_num extension ord) 
	lab var				ident "unique identifier"

	compress
	describe
	summarize

* save file
	customsave , idvar(ident) filename("2014_ase1p2_p.dta") ///
		path("`export'") dofile(2014_ase1p2_p) user($user)

* close the log
	log		close

/* END */
