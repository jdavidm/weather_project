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
	* we are only considering sold value based on the observations that were succesfully merged (line 159- 190)
	* outcome of last imputation is changing everytime we run


* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths	
	loc root 		= "$data/household_data/uganda/wave_1/raw"  
	loc export 		= "$data/household_data/uganda/wave_1/refined"
	loc logout 		= "$data/household_data/uganda/logs"
	loc conv 		= "$data/household_data/uganda/conversion_files"  

	
* open log	
	cap log 		close
	log using 		"`logout'/2009_AGSEC5A", append

	
* **********************************************************************
* 1 - import data and rename variables
* **********************************************************************

* import wave 2 season 1
	use 			"`root'/2009_AGSEC5A.dta", clear
	
	rename 			Hhid hhid
	rename 			A5aq5 cropid
	rename 			A5aq1 prcid
	rename			A5aq3 pltid
	rename			A5aq4 cropname
	rename 			A5aq6c unit_code
	rename			A5aq6b condition_code
	
	sort hhid prcid pltid
	*** cannot uniquely identify observations by hhid, prcid, or pltid 
	*** there multiple crops on the same plot
	
* missing cropid's also lack crop names, drop those observations
	mdesc 			cropid
	*** 1494 obs
	
	tab 			cropname if cropid == .
	drop 			if cropid == .
	*** dropped 1494 observations

* drop cropid is other, fallow, pasture, and trees
	drop 			if cropid > 880
	*** 497 observations dropped
	
* replace harvests with 99999 with a 0, 99999 is code for missing
	replace 		A5aq6a = 0 if A5aq6a == 99999
	*** 1277 changed to zero
	
* replace missing cropharvests with 0
	replace 		A5aq6a = 0 if A5aq6a == .
	*** 234 changed to zero

* missing prcid and pltid don't allow for unique id, drop missing
	drop			if prcid == .
	drop			if pltid == .
	duplicates 		drop
	*** there is still not a unique identifier, will deal with later
	
	
* **********************************************************************
* 2 - merge kg conversion file and create harvested quantity
* **********************************************************************
	
* merge in conversation file
	merge m:1 		cropid unit condition using ///
						"`conv'/ValidCropUnitConditionCombinations.dta" 
	*** unmatched 4195 from master, or 30% 
	
* drop from using
	drop 			if _merge == 2

* how many unmatched had a harvest of 0
	tab 			A5aq6a if _merge == 1
	*** 86%, 3217, have a harvest of 0
	
* how many unmatched because they used "other" to categorize the state of harvest?
	tab 			condition if _merge == 1
	mdesc 			condition if _merge == 1
	*** all unmatched observations have missing condition_code
	
	tab 			unit if _merge == 1

* replace ucaconversion to 1 if the harvest is 0
	replace 		ucaconversion = 1 if A5aq6a == 0
	*** 3221 changes

* some matched do not have ucaconversions, will use medconversion
	replace 		ucaconversion = medconversion if _merge == 3 & ucaconversion == .
	mdesc 			ucaconversion
	*** 4% missing, 535 missing
	
* Drop the variables still missing ucaconversion
	drop 			if ucaconversion == .
	*** 535 dropped
	
	drop 			_merge
	
	tab				cropname
	*** beans are the most numerous crop being 18% of crops planted
	***	maize is the second highest being 17%
	*** maize will be main crop following most other countries in the study
	
* replace missing harvest quantity to 0
	replace 		A5aq6a = 0 if A5aq6a == .
	*** no changes
	
* Convert harv quantity to kg
	gen 			harvqtykg = A5aq6a*ucaconversion
	label var		harvqtykg "quantity of crop harvested (kg)"
	mdesc 			harvqtykg
	*** all converted

* summarize harvest quantity
	sum				harvqtykg
	*** three crazy values, replace with missing
	
	replace			harvqtykg = . if harvqtykg > 100000
	*** replaced 3 observations
	
* summarize maize quantity harvest
	sum				harvqtykg if cropid == 130
	*** 287 mean, 75600 max
	

* **********************************************************************
* 3 - value of harvest
* **********************************************************************

* value of crop sold in shillings
	rename			A5aq8 harvvlush
	label var 		harvvlush "Value of crop sold in ugandan shilling"
	
* summarize the value of sales in shillings
	sum 			harvvlush, detail
	*** mean 1.47e+07 min 0, max 1.30e+09

* generate crop is USD
	gen 		cropvl = harvvlush / 1834.975213
	lab var 	cropvl "total value of harvest in 2010 USD"
	*** value comes from World Bank: world_bank_exchange_rates.xlxs
	
	sum 		cropvl, detail
	*** mean 7987, min 0, max 708456
	

* **********************************************************************
* 3 - generate sold harvested values
* **********************************************************************

* value of harvest
	rename			A5aq8 harvvlush
	label var 		harvvlush "Value of crop sold in ugandan shilling"

* summarize the value of sales in shillings
	sum 			harvvlush, detail
	*** mean 1.47e+07, min 0, max 1.30e+09

* ensure all missing harvest quanitites have missing value sold observations
	tab 			harvvlush if A5aq6a == .
	*** no observations
	tab 			harvvlush if A5aq6a == 0
	*** 1 observation
	replace 		harvvlush = . if A5aq6a == 0
	*** 1 change

* rename condition of sold and unit of sold products
	rename 			A5aq7b sold_condition_code
	rename			A5aq7c sold_unit_code

* merge conversion for sold products
	merge m:1 		cropid sold_unit_code sold_condition_code using ///
						"`conv'/soldcropconversion.dta" 	
	*** 10273 not matched, 3166 matched 
	
* we are only considering sold value based on the observations that were succesfully merged

* sold produce
	gen 			soldprod = 1 if A5aq7a > 0 & A5aq7a != .
	label var 		soldprod "=1 if farmer reported a positive amount sold"
	tab 			soldprod
	*** 3336 had soldprod greater than 0
	
	drop 			if _merge == 2
	drop 			_merge

* some observations are missing ucaconversion but have medconversion, 
	replace 		sold_ucaconversion = sold_medconversion ///
						if sold_ucaconversion == . & soldprod == 1
	*** we can recover those observations 666 values
	
* at the least we ensure kg's get converted, some condition states were not in the conversion file 
* but it shouldnt matter if the product was always in kg's
	replace 		sold_ucaconversion = 1 if sold_unit_code == 1 & soldprod > 0
	* 109 changes made
	
	mdesc 			sold_ucaconversion if soldprod == 1
	*** 136 out of 3336 observations that sold are missing a conversion factor
	
* convert quantity sold into kg
	gen 			harvkgsold = A5aq7a*sold_ucaconversion if soldprod == 1
	lab	var			harvkgsold "quantity harvested and sold, in kilograms"

	tab 			harvkgsold
	mdesc 			harvkgsold if soldprod == 1
	*** 3200 observations non missing, 136 missing
	
	sum				harvkgsold, detail
	*** 0.02 min, mean 604, max 120000
	
* clean up varaibles
	replace			A5aq7a = 0 if A5aq7a == . & soldprod == .
	*** 3225 changed to zero
	
	replace			soldprod = 0 if soldprod == .
	*** 9392 changed to zero
	
	tab 			soldprod
	*** no missing, 26% sold crops
		
* replace missing values to 0
	replace 		harvvlush = 0 if harvvlush == .
	replace 		harvkgsold = 0 if harvkgsold == .

* collapse to crop leavel
	collapse 		(sum) harvqtykg harvvlush harvkgsold ///
						(max) soldprod, by(hhid prcid pltid cropid)
	*** collapsed 12728 obs to 11505

* check unique id
	isid 			hhid prcid pltid cropid

	
* **********************************************************************
* 4 - merge location data
* **********************************************************************	
	
* merge the location identification
	merge m:1 		hhid using "`export'/2009_GSEC1"
	*** 21 unmatched from master
	drop 			if _merge != 3
	
* just keep region and district identifer
	drop			wgt09wosplits wgt09 hh_status2009 _merge


* **********************************************************************
* 5 - impute crop value
* **********************************************************************

*  convert 2009 Shillings to constant 2010 USD
	gen 			cropvl = harvvlush / 1834.975213
	*** value comes from World Bank: world_bank_exchange_rates.xlxs

* summarize data
	sum 			cropvl
	*** max 708456, mean 2309, min 0
	
* replace largest outlier
	replace			cropvl = . if cropvl > 500000
	*** 1 change made

* replace any +2 s.d. away from median as missing, by cropid
	sort 			cropid
	sum				cropvl, detail 
	by 				cropid: replace	cropvl = . if cropvl > `r(p50)'+ (2*`r(sd)')
	sum				cropvl, detail
	*** replaced 216 values, max is now 23161, mean 1130
		
* impute cropvl if missing and harvest was sold
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously

* impute each variable in local	
	mi register			imputed cropvl // identify harvqty variable to be imputed
	sort				hhid prcid pltid cropid, stable // sort to ensure reproducability of results
	mi impute 			pmm cropvl cropid i.district, add(1) rseed(245780) ///
								noisily dots force knn(5) bootstrap					
	mi 				unset	
	
* how did impute go?
	sum 			cropvl_1_, detail
	*** min 0, max  23161, mean 1135

	replace 		cropvl = cropvl_1_ if mi_miss == 1
	
	drop 			cropvl_1_ mi_miss

	
*********************************************************************************************	
* 6 - impute harvqtykg
*********************************************************************************************	

* summarize data
	sum 			harvqtykg
	*** max 120200, mean 411, min 0
	
* replace largest outliers
	replace			harvqtykg = . if harvqtykg > 75000
	*** 5 change made

* replace any +2 s.d. away from median as missing, by cropid
	sort 			cropid
	sum				harvqtykg, detail 
	by 				cropid: replace	harvqtykg = . if harvqtykg > `r(p50)'+ (2*`r(sd)')
	sum				harvqtykg, detail
	*** replaced 267 values, max is now 2856, mean 222
	
* impute missing quantity
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously

* impute harvqtykg	
	mi register			imputed harvqtykg // identify harvqty variable to be imputed
	sort				hhid prcid pltid cropid, stable // sort to ensure reproducability of results
	mi impute 			pmm harvqtykg i.region cropid, add(1) rseed(245780) ///
								noisily dots force knn(5) bootstrap					
	mi 				unset	
	
* inspect imputation 
	sum 			harvqtykg_1_, detail
	*** mean 231, min 0, max 2856

* replace the imputated variable
	replace 		harvqtykg = harvqtykg_1_ if mi_miss == 1
	*** 272 changes made
	
	drop 			harvqtykg_1_ mi_miss
	
	
*********************************************************************************************	
* 7 - impute harvkgsold
*********************************************************************************************	
	
* summarize data
	sum 			harvkgsold
	*** max 120000, min 0 mean 168

* replace largest outliers
	replace			harvkgsold = . if harvkgsold > 60000
	*** 4 change made

* replace any +2 s.d. away from median as missing, by cropid	
	sort 			cropid
	sum				harvkgsold, detail 
	by 				cropid: replace	harvkgsold = . if harvkgsold > `r(p50)'+ (2*`r(sd)')
	sum				harvkgsold, detail
	*** replaced 135 values, max is now 2079, mean 68
	
* impute missing values
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed harvkgsold // identify harvkgsold as the variable being imputed
	sort			hhid prcid pltid cropid, stable // sort to ensure reproducability of results
	mi impute 		pmm harvkgsold i.cropid, add(1) rseed(245780) ///
						noisily dots force knn(5) bootstrap
	mi 				unset	

* inspect imputation 
	sum 			harvkgsold_1_, detail
	*** mean 69, min 0, max 2079

* replace the imputated variable
	replace 			harvkgsold = harvkgsold_1_ if mi_miss == 1
	*** 139 changes made
	
	drop 				harvkgsold_1_ mi_miss

	
* ********************************************************************
* 8 - make crop prices
* ********************************************************************	

* condensed crop codes
	inspect 		cropid
	*** generally things look all right - 43 unique values 

* gen price per kg
	sort 			cropid
	by 				cropid: gen cropprice = cropvl / harvkgsold 
	tab				soldprod
	*** 8468 missing values, but 8246 did not sell
	
	sum 			cropprice, detail
	*** mean = 131, max = 65395, min = 0
	*** will do some imputations later
	
* encode district for the imputation
	encode			county, gen (countydstrng)
	encode			subcounty, gen (subcountydstrng)
	encode			parish, gen (parishdstrng)
	

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
	
* drop if we are missing prices
	drop			if p_crop == .
	*** dropped 28 observations
	
* make imputed price, using median price where we have at least 10 observations
* this code generlaly files parts of malawi ag_i
* but this differs from Malawi - seems like their code ignores prices 
	gen	 			croppricei = .
	*** 11477 missing values generated
	
	bys cropid (region district countydstrng subcountydstrng parishdstrng hhid prcid pltid): replace croppricei = p_parish if n_parish>=10 & missing(croppricei)
	*** 289 replaced
	bys cropid (region district countydstrng subcountydstrng parishdstrng hhid prcid pltid): replace croppricei = p_subcounty if p_subcounty>=10 & missing(croppricei)
	*** 2125 replaced
	bys cropid (region district countydstrng subcountydstrng parishdstrng hhid prcid pltid): replace croppricei = p_county if n_county>=10 & missing(croppricei)
	*** 923 replaced 
	bys cropid (region district countydstrng subcountydstrng parishdstrng hhid prcid pltid): replace croppricei = p_dist if n_district>=10 & missing(croppricei)
	*** 1663 replaced
	bys cropid (region district countydstrng subcountydstrng parishdstrng hhid prcid pltid): replace croppricei = p_reg if n_reg>=10 & missing(croppricei)
	*** 5837 replaced 
	bys cropid (region district countydstrng subcountydstrng parishdstrng hhid prcid pltid): replace croppricei = p_crop if missing(croppricei)
	*** 640 changes
	lab	var			croppricei	"implied unit value of crop"

* verify that prices exist for all crops
	mdesc 			croppricei
	*** no missing
	
	sum 			cropprice croppricei
	*** mean = 42, max = 15174

* generate value of harvest 
	gen				cropvalue = harvqtykg * croppricei
	label 			variable cropvalue	"implied value of crops" 
	
* verify that we have crop value for all observations
	mdesc 			cropvalue
	*** 0 missing
	
* replace zero values with missing if some crop was harvested
	replace		cropvalue = . if cropvalue == 0 & harvqtykg != 0
	replace		cropvalue = 0 if harvqtykg == 0
	*** none replaced

* summarize data
	sum 			cropvalue, detail
	*** max 72048529, mean 5296, min 0
	
* replace largest outlier
	replace			cropvalue = . if cropvalue > 1000000
	*** 1 change made

* replace any +2 s.d. away from median as missing, by cropid
	sort 			cropid
	sum				cropvalue, detail 
	by 				cropid: replace	cropvalue = . if cropvalue > `r(p50)'+ (2*`r(sd)')
	sum				cropvalue, detail
	*** replaced 87 values, max is now 44469, mean 3570
	
* impute missing values
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed cropvalue // identify cropvalue as the variable being imputed
	sort			hhid prcid pltid cropid, stable // sort to ensure reproducability of results
	mi impute 		pmm cropvalue i.region i.cropid, add(1) rseed(245780) ///
						noisily dots force knn(5) bootstrap
	mi 				unset	

* inspect imputation 
	sum 			cropvalue_1_, detail
	*** mean 3586, min 0, max 44469

* replace the imputated variable
	replace 			cropvalue = cropvalue_1_ if mi_miss == 1
	*** 91 changes made
	
	drop 				cropvalue_1_ mi_miss
	
	
* **********************************************************************
* 11 - end matter, clean up to save
* **********************************************************************

	keep hhid prcid pltid cropvalue harvqtykg region district county subcounty ///
			parish cropid

	compress
	describe
	summarize

* save file
		customsave , idvar(hhid) filename("2009_AGSEC5A.dta") ///
			path("`export'/`folder'") dofile(2009_AGSEC5A) user($user)

* close the log
	log	close

/* END */

