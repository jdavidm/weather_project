* Project: WB Weather
* Created on: Aug 2020
* Created by: ek
* Stata v.16

* does
	* Crop output
	* reads Uganda wave 1 crop output (2009_AGSEC5A) for the 1st season
	* 3A - 5A are questionaires for the first planting season
	* 3B - 5B are questionaires for the second planting season

* assumes
	* customsave.ado
	* mdesc.ado

* TO DO:


* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths	
	loc 	root 		= 		"$data/household_data/uganda/wave_1/raw"  
	loc     export 		= 		"$data/household_data/uganda/wave_1/refined"
	loc 	logout 		= 		"$data/household_data/uganda/logs"
	
* open log	
	cap log close
	log using "`logout'/2009_AGSEC5A", append

* **********************************************************************
* 1 - import data and rename variables
* **********************************************************************

* import wave 2 season 1
	use "`root'/2009_AGSEC5A.dta", clear
	
	rename 		Hhid hhid
	rename 		A5aq5 cropid
	rename 		A5aq1 prcid
	rename		A5aq3 pltid
	rename		A5aq4 cropname
	
	describe
	sort hhid prcid pltid
	*** cannot uniquely identify observations by hhid, prcid, or pltid because there multiple crops on the same plot
* missing cropid's also lack crop names, drop those observations
	mdesc 		cropid
	*** 1494 obs
	tab 		cropname if cropid == .
	drop 		if cropid == .
	*** dropped 1494 observations

* drop cropid is other
	drop 		if cropid == 890
	*** 69 observations dropped
*Create unique parcel/plot identifier
*	generate parcel_id = HHID + " " + string(prcid)
*	generate plot_id = HHID + " " + string(prcid) + " " + string(pltid)
*	isid plot_id

* **********************************************************************
* 3 - Quantity harvested
* **********************************************************************
	
	tab			cropname
	*** beans are the most numerous crop being 17.6% of crops planted
	***	maize is the second highest being 17%
	*** maize will be main crop following most other countries in the study
	
* Convert harv quantity to kg
	*** harvest quantity is in a variety of measurements
	*** included in the file are the conversions from other measurements to kg
	
	rename 			A5aq6a harvqty
	rename			A5aq6d harvkgconv
	rename			A5aq8 harvvlush
	
* summarize the value of sales in shillings
	sum 			harvvlush, detail
	*** mean 1.53e+07, min 0, max 1.30e+09
	
	label var 		harvvlush "Value of crop sold in ugandan shilling"
	label var  		harvkgconv "Conversion factor from other to kg"
	label var 		harvqty "Harvest quantity not converted"
	
* lost harvest is coded as harvestqty = 99999
	replace 		harvqty = 0 if harvqty == 99999
	
	gen 			harvqtykg = harvqty*harvkgconv
	*** 4461 missing values
	label var		harvqtykg "weight of harvest in kg's"
	
	mdesc 			harvkgconv
	*** 4456 are missing harvkgconv
	mdesc			harvqty
	*** 1197 are missing harvqty
	tab 			harvkgconv   if harvqtykg ==.  & harvqty != .
	*** no observations
	replace 		harvqtykg = 0 if harvqty == 0
	*** 1790 changes made
	sort 			harvqtykg
	replace 		harvqtykg = 0 if harvqty == 99999
	mdesc			harvqtykg
	*** 1260 missing
	replace			harvqtykg = 0 if harvqty == .
	*** 1197 changes

* replace missing conversion factors
	tab 			A5aq6c	if harvqtykg == .
	*** the units with missing conversions in the 49 missing obs are:
	*** 1, 9, 10, 22, 45, 64, 68, 69, 85, 87
	sum				harvkgconv if A5aq6c == 1
	*** the conversion factor ranges from 0 to 1000, std dev 29.2 and mean is 4.31
	*** the conversion factors do not seem to be general
	sum				harvkgconv if A5aq6c == 9
	*** ranges from 0 to 2000, mean 114.6
	*** the conversion factors are not general 
	*** we cannot extrapolate the conversion of other units to the missing conversion factor
	*** drop those missing observations
	drop 			if harvqtykg == .
	*** 63 observations dropped 
	
	sum 			harvqtykg, detail
	***	min 0, max 5000000, mean 781, std dev. 42283.19
	
	replace 		harvqtykg = . if harvqtykg > 90000
	*** 8 changes
	
	sum 			harvqtykg, detail
	*** min 0 , max 90000, std dev 2147.66, mean 315.28
	*** impute later
	
* what can we say about the distribution?
	*kdensity 		harvqtykg
	*** left skewed with a massive long tail

* **********************************************************************
* 5 - generate sold harvested values
* **********************************************************************

* sold produce
	gen 	soldprod = 1 if A5aq7a > 0

* the conversion is not given in harvest sold
* we use the conversion factor from harvest if they have the same unit code as amount harvested
	count if A5aq6c == A5aq7c
	*** 6962 have the same unit code
	count if A5aq6c != A5aq7c & A5aq6c != . & A5aq7c != .
	***270 dont have the unit code
	
* convert quantity sold into kg
	gen 			harvkgsold = A5aq7a*harvkgconv if A5aq7c == A5aq6c
	replace 		harvkgsold = 0 if A5aq7a == 0
	replace			harvkgsold = 0 if A5aq7a == .
	replace 		harvkgsold = 0 if harvvlush == 0
	lab	var			harvkgsold "quantity harvested and sold, in kilograms"
	sum				harvkgsold, detail

	*** 0 min, mean 85.78, max 11250
	*** how could you sell zero - replace to missing
	
	mdesc 			harvkgsold
	*** none missing
	

	
* **********************************************************************
* 6 - merge location data
* **********************************************************************	
	
* merge the location identification
	merge m:1 hhid using "`export'/2009_GSEC1"
	*** 0 unmatched from master
	drop 		if _merge != 3
	
* encode district for the imputation
	encode		county, gen (countydstrng)
	encode		subcounty, gen (subcountydstrng)
	encode		parish, gen (parishdstrng)
	
* **********************************************************************
* harvest value cleaning excercise
* **********************************************************************

	gen 		cropvl = harvvlush / 1834.975213
	
	gen 		hascropvl = 1 if cropvl != .
	
	replace 		cropvl = . if cropvl > 20000
	*** 278 changes
	*replace 		cropvl = cropvl/10 if cropvl > 1000
	
* impute cropvl

* replace cropvl with missing if over 2 std dev from the mean
	sum 			cropvl, detail
	replace			cropvl = . if cropvl > `r(p50)'+ (2*`r(sd)')
	*** 327 changes
	
* impute cropvl if missing and harvest was sold
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously

* impute each variable in local	
	mi register			imputed cropvl // identify harvqty variable to be imputed
	sort				hhid prcid pltid, stable // sort to ensure reproducability of results
	mi impute 			pmm cropvl i.region cropid, add(1) rseed(245780) ///
								noisily dots force knn(5) bootstrap					
	mi 				unset	
	
* how did impute go?
	sum 			cropvl_1_, detail
	*** min 0, mean 429.89, max 1569.5

	replace 		cropvl = cropvl_1_ if hascropvl == 1
	
	drop 			cropvl_1_ mi_miss
* **********************************************************************
* 5 - collapse to the crop level
* **********************************************************************
	
* collapse the data to the crop level so that our imputations are reproducable and consistent
	collapse (sum) harvqtykg harvvlush cropvl harvkgsold (max) soldprod, by(hhid prcid pltid cropid)

	duplicates report hhid prcid pltid cropid

* drop missing prcid, pltid
	*** for now the solution to observations missing prcid or pltid is to drop them
	drop 		if prcid ==. | pltid ==.	
	*** 126 dropped
	
	isid hhid prcid pltid cropid	
	
* **********************************************************************
* 6 - merge location data
* **********************************************************************	
	
* merge the location identification
	merge m:1 hhid using "`export'/2009_GSEC1"
	*** 0 unmatched from master
	drop 		if _merge != 3
	
* encode district for the imputation
	encode		county, gen (countydstrng)
	encode		subcounty, gen (subcountydstrng)
	encode		parish, gen (parishdstrng)
	
*********************************************************************************************	
* 7 - impute harvqtykg
*********************************************************************************************	

* replace observations 3 std deviation from the mean and impute missing
	sum 			harvqtykg, detail
	replace			harvqtykg = . if harvqtykg > 4500
	*** 112 changes made
	
* impute missing quantity
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously

* impute harvqtykg	
	mi register			imputed harvqtykg // identify harvqty variable to be imputed
	sort				hhid prcid pltid, stable // sort to ensure reproducability of results
	mi impute 			pmm harvqtykg i.region cropid harvkgsold, add(1) rseed(245780) ///
								noisily dots force knn(5) bootstrap					
	mi 				unset	
	
* inspect imputation 
	sum 				harvqtykg_1_, detail
	*** 112 imputation
	*** mean 231.5, min 0, max 4440
	*** looks better

* replace the imputated variable
	replace 			harvqtykg = harvqtykg_1_
	*** 112 changes made
	
	drop 				harvqtykg_1_ mi_miss
	
	mdesc 				harvqtykg
	*** 0 missing
	

	

*********************************************************************************************	
* 9 - impute harvkgsold
*********************************************************************************************	
	
* replace any +3 s.d. away from median as missing, by cropid
	sort 			cropid
	sum				harvkgsold, detail 
	by 				cropid: replace	harvkgsold = . if harvkgsold > `r(p50)'+ (3*`r(sd)')
	sum				harvkgsold, detail
	*** replaced 173 values, max is now 1440, mean 46.91
	
* impute missing values
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed harvkgsold // identify harvkgsold as the variable being imputed
	sort			hhid prcid pltid cropid, stable // sort to ensure reproducability of results
	mi impute 		pmm harvkgsold i.district i.subcountydstrng i.cropid cropvl, add(1) rseed(245780) ///
						noisily dots force knn(5) bootstrap
	mi 				unset	

* how did the imputation go?
	tab				mi_miss
	tabstat			harvkgsold harvkgsold_1_, by(mi_miss) ///
						statistics(n mean min max) columns(statistics) ///
						longstub format(%9.3g) 
	replace			harvkgsold = harvkgsold_1_ if harvvlush != .
	lab var			harvkgsold "kg of harvest sold, imputed (only if produce was sold)"
	sum 			harvkgsold
	drop			harvkgsold_1_ mi_miss
	*** imputed observations changed 23 observations for people who sold 
	*** mean 46.91 to 47.76 , max stays at 1440 
	
* check out amount sold
* currently reported in Ugandan shilling
	tab 			harvvlush 
	replace 		harvvlush = . if harvvlush == 999999 
	*** 0 changed to missing
	
* ********************************************************************
* 10 - make cropvalue variable and impute it
* ********************************************************************	

* condensed crop codes
	inspect 		cropid
	*** generally things look all right - 53 unique values 

* gen price per kg
	sort 			cropid
	by 				cropid: gen cropprice = cropvl / harvkgsold 
	*** 7103 missing values, but 6992 did not sell
	sum 			cropprice, detail
	*** mean = 34.42, max = 2397, min = 0
	*** will do some imputations later
	
* make datasets with crop price information
	preserve
	collapse 		(p50) p_parish=cropprice (count) n_parish=cropprice, by(cropid region district countydstrng subcountydstrng parishdstrng)
	save 			"`export'/2009_agsec5a_p1.dta", replace 
	restore
	
	preserve
	collapse 		(p50) p_subcounty=cropprice (count) n_subcounty=cropprice, by(cropid region district countydstrng subcountydstrng)
	save 			"`export'/2009_agsec5a_p2.dta", replace 	
	restore
	
	preserve
	collapse 		(p50) p_county=cropprice (count) n_county=cropprice, by(cropid region district countydstrng)
	save 			"`export'/2009_agsec5a_p3.dta", replace 	
	restore
	
	preserve
	collapse 		(p50) p_dist=cropprice (count) n_district=cropprice, by(cropid region district)
	save 			"`export'/2009_agsec5a_p4.dta", replace 
	restore
	
	preserve
	collapse 		(p50) p_reg=cropprice (count) n_reg=cropprice, by(cropid region)
	save 			"`export'/2009_agsec5a_p5.dta", replace 
	restore
	
	preserve
	collapse 		(p50) p_crop=cropprice (count) n_crop=cropprice, by(cropid)
	save 			"`export'/2009_agsec5a_p6.dta", replace 	
	restore
	
* merge the price datasets back in
	merge m:1 cropid region district countydstrng subcountydstrng parishdstrng	        using "`export'/2009_agsec5a_p1.dta", gen(p1)
	*** all observations matched
	
	merge m:1 cropid region district countydstrng subcountydstrng 	        using "`export'/2009_agsec5a_p2.dta", gen(p2)
	*** all observations matched

	merge m:1 cropid region district countydstrng 			        using "`export'/2009_agsec5a_p3.dta", gen(p3)
	*** all observations matched
	
	merge m:1 cropid region district						using "`export'/2009_agsec5a_p4.dta", gen(p4)
	*** all observations matched
	
	merge m:1 cropid region						        using "`export'/2009_agsec5a_p5.dta", gen(p5)
	*** all observations matched
	
	merge m:1 cropid 						        using "`export'/2009_agsec5a_p6.dta", gen(p6)
	*** all observations matched

* erase price files
	erase			"`export'/2009_agsec5a_p1.dta"
	erase			"`export'/2009_agsec5a_p2.dta"
	erase			"`export'/2009_agsec5a_p3.dta"
	erase			"`export'/2009_agsec5a_p4.dta"
	erase			"`export'/2009_agsec5a_p5.dta"
	erase			"`export'/2009_agsec5a_p6.dta"

	
	drop p1 p2 p3 p4 p5 p6

* check to see if we have prices for all crops
	tabstat 		p_parish n_parish p_subcounty n_subcounty p_county n_county p_dist n_district p_reg n_reg p_crop n_crop, ///
						by(cropid) longstub statistics(n min p50 max) columns(statistics) format(%9.3g) 
	*** no prices for wheat, fallow fields, bush and trees were also included but have no prices
	
* drop if we are missing prices
	drop			if p_crop == .
	*** dropped 557 observations
	
* make imputed price, using median price where we have at least 10 observations
* this code generlaly files parts of malawi ag_i
* but this differs from Malawi - seems like their code ignores prices 
	gene	 		croppricei = .
	*** 13316 missing values generated
	
	bys cropid (region district countydstrng subcountydstrng parishdstrng hhid prcid pltid): replace croppricei = p_parish if n_parish>=10 & missing(croppricei)
	*** 568 replaced
	bys cropid (region district countydstrng subcountydstrng parishdstrng hhid prcid pltid): replace croppricei = p_subcounty if p_subcounty>=10 & missing(croppricei)
	*** 4 replaced
	bys cropid (region district countydstrng subcountydstrng parishdstrng hhid prcid pltid): replace croppricei = p_county if n_county>=10 & missing(croppricei)
	*** 1812 replaced 
	bys cropid (region district countydstrng subcountydstrng parishdstrng hhid prcid pltid): replace croppricei = p_dist if n_district>=10 & missing(croppricei)
	*** 926 replaced
	bys cropid (region district countydstrng subcountydstrng parishdstrng hhid prcid pltid): replace croppricei = p_reg if n_reg>=10 & missing(croppricei)
	*** 9003 replaced 
	bys cropid (region district countydstrng subcountydstrng parishdstrng hhid prcid pltid): replace croppricei = p_crop if missing(croppricei)
	*** 1003 changes
	lab	var			croppricei	"implied unit value of crop"

* verify that prices exist for all crops
	mdesc 			croppricei
	*** no missing
	
	sum 			cropprice croppricei
	*** mean = 0.34, max = 45.3
	
* generate value of harvest 
	gen				cropvalue = harvqtykg * croppricei
	label 			variable cropvalue	"implied value of crops" 
	
* replace cropvalue with cropvl if cropvl is not missing and crop value is missing
	replace 		cropvalue = cropvl if cropvalue == . & cropvl != .
	*** 0 changes
	
* verify that we have crop value for all observations
	mdesc 			cropvalue
	*** 0 missing

* replace any +3 s.d. away from median as missing, by cropid
	sum 			cropvalue, detail
	*** mean 472.22, max 49782.69
*	kdensity		cropvalue
	replace			cropvalue = . if cropvalue > 500
	sum				cropvalue, detail
	*** replaced 2722 values
	
* impute missing values
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed cropvalue // identify cropvalue as the variable being imputed
	sort			hhid prcid pltid cropid, stable // sort to ensure reproducability of results
	mi impute 		pmm cropvalue i.region i.cropid, add(1) rseed(245780) ///
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
	*** mean is 131.8, max is 499.55 min is 0
	

* **********************************************************************
* 11 - end matter, clean up to save
* **********************************************************************

	keep hhid prcid pltid cropvalue harvqtykg region district county subcounty parish cropid

	compress
	describe
	summarize

* save file
		customsave , idvar(hhid) filename("2009_AGSEC5A.dta") ///
			path("`export'/`folder'") dofile(2009_AGSEC5A) user($user)

* close the log
	log	close

/* END */

