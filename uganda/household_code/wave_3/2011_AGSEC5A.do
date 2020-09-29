* Project: WB Weather
* Created on: Aug 2020
* Created by: ek
* Stata v.16

* does
	* Crop output
	* reads Uganda wave 3 crop output (2011_AGSEC5A) for the 1st season
	* 3A - 5A are questionaires for the first planting season
	* 3B - 5B are questionaires for the second planting season

* assumes
	* customsave.ado
	* mdesc.ado

* TO DO:
	*done.

* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths	
	loc 	root 		= 		"$data/household_data/uganda/wave_3/raw"  
	loc     export 		= 		"$data/household_data/uganda/wave_3/refined"
	loc 	logout 		= 		"$data/household_data/uganda/logs"
	loc 	conv 		= 		"$data/household_data/uganda/conversion_files"  

* open log	
	cap log close
	log using "`logout'/2011_AGSEC5A", append

* **********************************************************************
* 1 - import data and rename variables
* **********************************************************************

* import wave 2 season 1
	use "`root'/2011_AGSEC5A.dta", clear
	
	rename 		HHID hhid
	rename 		cropID cropid
	rename		plotID pltid
	rename		parcelID prcid
	rename 		a5aq6c unit
	rename		a5aq6b condition
	
	describe
	sort hhid prcid pltid cropid
	
* one observation is missing pltid
	*** the hhid is 4183002308
	replace		pltid = 5 if hhid == 4183002308 & pltid == .
	*** one change made
	
	*isid 		hhid prcid pltid cropid

* drop observations from plots that did not harvest because crop was immature
	drop if a5aq5_2 == 1
	*** 1484 observations deleted

	
* **********************************************************************
* 2 - merge kg conversion file
* **********************************************************************
	
	merge m:1 cropid unit condition using "`conv'/ValidCropUnitConditionCombinations.dta" 
	*** unmatched 506 from master 
	
* drop from using
	drop if _merge == 2

* how many unmatched had a harvest of 0
	tab a5aq6a if _merge == 1
	*** 80% have a harvest of 0
	
* how many unmatched because they used "other" to categorize the state of harvest?
	tab condition if _merge == 1
	*** 92% say the condition was "other(99)"
	
	tab cropid condition if condition != 99 & _merge == 1 & condition !=.
	
	tab unit if _merge == 1
	

* replace ucaconversion to 1 if the harvest is 0
	replace ucaconversion = 1 if a5aq6a == 0 & _merge == 1
	*** 392 changes

* manually replace conversion for the kilograms and sacks if the condition is other condition and the observation is unmatched
	*kgs
	replace ucaconversion = 1 if unit == 1 & _merge == 1
	*sack 120 kgs
	replace ucaconversion = 120 if unit == 9 & _merge == 1
	*sack 100 kgs
	replace ucaconversion = 100 if unit == 10 & _merge == 1
	* sack 80 kgs
	replace ucaconversion = 80 if unit == 11 & _merge == 1
	* sack 50 kgs
	replace ucaconversion = 50 if unit == 12 & _merge == 1
	

* drop the unmatched remaining observations
	drop if _merge == 1 & ucaconversion == .
	*** 69 observatinos deleted
	drop _merge
	
**********************************************************************
* 2 - Quantity harvested
* **********************************************************************
	
	tab			cropid
	*** beans are the most numerous crop being 18.84% of crops planted
	***	maize is the second highest being 16.93%
	*** maize will be main crop following most other countries in the study
	
* Convert harv quantity to kg
	*** harvest quantity is in a variety of measurements
	*** included in the file are the conversions from other measurements to kg
	
	rename 			a5aq6a harvqty
	label var 		harvqty "Harvest quantity, not converted to kg's"
	
	gen 			harvqtykg = harvqty*ucaconversion
	label var		harvqtykg "weight of harvest in kg's"
	*** 1300 missing 
	
	mdesc 			ucaconversion
	*** 1300 missing ucaconversion 
	*** will use farmer reported median conversion instead
	
	replace 		harvqtykg = harvqty*medconversion if ucaconversion == .
	*** 1300 hundred changes made
	
	mdesc 			harvqtykg
	*** none missing
	
	sum harvqtykg, detail
	*** min 0, max 416625, mean 535.4, will impute later
	

	
* what can we say about the distribution?
	*kdensity 		harvqtykg
	*** left skewed with a long tail
	

	
* **********************************************************************
* 3 - value of harvest
* **********************************************************************

* value of crop sold in shillings
	rename			a5aq8 harvvlush
	label var 		harvvlush "Value of crop sold in ugandan shilling"
	
* summarize the value of sales in shillings
	sum 			harvvlush, detail
	*** mean 238676.1, min 10, max 4.56e+07
	
	sum 		harvvlush, detail
	lab var   	harvvlush "crop value (ugandan shilling)"
		
	gen 		cropvl = harvvlush / 2122.854348
	lab var 	cropvl "total value of harvest in 2010 USD"
	
	sum 		cropvl, detail
	*** mean 112.43, min 0, max 21480.51
	
* what can we say about distribution?
	*kdensity 	cropvl
	*** left skewed with long tail
	
* **********************************************************************
* 4 - generate sold harvested values
* **********************************************************************

* rename the conversion factor for sold harvest
	rename 			A5AQ7D soldkgconv 
	label var 		soldkgconv "conversion factor for amount sold"
	
* how many sold observations have a conversion factor
	count if soldkgconv != . & a5aq7a != .
	*** 2590 have the same unit code
	count if soldkgconv == . & a5aq7a > 0
	*** 2920 do not have a conversion factor 
	
* convert quantity sold into kg
	gen 			harvkgsold = a5aq7a*soldkgconv 
	lab	var			harvkgsold "quantity sold, in kilograms"
	
* kgs were not converted since they done require a conversion we'll just replace the harvkgsold with the amount sold
	replace			harvkgsold = a5aq7a if a5aq7c == 1
	
	mdesc 			harvkgsold
	
	sum				harvkgsold, detail
	*** 0.00 min, mean 136.34, max 10240

* drop obs if missing parcel or plot id
	drop if prcid == .
	*** 0 dropped
	drop if pltid == .
	*** 0 dropped
	
* drop duplicates
	duplicates drop

* replace missing values to 0
	replace harvvlush = 0 if harvvlush == .
	replace harvkgsold = 0 if harvkgsold == .

* **********************************************************************
* 5 - collapse to the crop level
* **********************************************************************
	
* collapse the data to the crop level so that our imputations are reproducable and consistent
	collapse (sum) harvqtykg harvvlush cropvl harvkgsold, by(hhid prcid pltid cropid)

	isid hhid prcid pltid cropid	
	
* **********************************************************************
* 6 - merge location data
* **********************************************************************	
	
* merge the location identification
	merge m:1 hhid using "`export'/2011_GSEC1"
	*** 280 unmatched from master
	*** 10571 matched
	drop 		if _merge != 3
	
* encode district for the imputation
	encode 		district, gen (districtdstrng)
	encode		county, gen (countydstrng)
	encode		subcounty, gen (subcountydstrng)
	encode		parish, gen (parishdstrng)
	
* **********************************************************************
* 7 - impute harvqtykg
* **********************************************************************

* replace observations 3 std deviation from the mean and impute missing
	*** 3 std dev from mean is 
	sum 			harvqtykg, detail
	replace			harvqtykg = . if harvqtykg > `r(p50)'+ (3*`r(sd)')
	*** 21 changed to missing

* impute missing harvqtykg
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously

* impute harvqtykg	
	mi register			imputed harvqtykg // identify harvqty variable to be imputed
	sort				hhid prcid pltid cropid, stable // sort to ensure reproducability of results
	mi impute 			pmm harvqtykg i.region i.districtdstrng i.countydstrng, add(1) rseed(245780) ///
								noisily dots force knn(5) bootstrap					
	mi 				unset	
	
* inspect imputation 
	sum 				harvqtykg_1_, detail
	*** 21 imputation
	*** mean 485.21, min 0, max 15990
	*** looks better

* replace the imputated variable
	replace 			harvqtykg = harvqtykg_1_ 
	*** 21 changes
	
	drop 				harvqtykg_1_ mi_miss
	
* ***********************************************************************
* 8 - impute cropvl
* ***********************************************************************	

* replace cropvl with missing if over 3 std dev from the mean
	sum 			cropvl, detail
	replace			cropvl = . if cropvl > `r(p50)'+ (3*`r(sd)')
	*** 42 changes
	
* impute cropvl if missing and harvest was sold
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously

* impute each variable in local	
	mi register			imputed cropvl // identify harvqty variable to be imputed
	sort				hhid prcid pltid cropid, stable // sort to ensure reproducability of results
	mi impute 			pmm cropvl i.region i.districtdstrng i.countydstrng i.subcountydstrng harvqtykg, add(1) rseed(245780) ///
								noisily dots force knn(5) bootstrap					
	mi 				unset	
	
* how did impute go?
	sum 			cropvl_1_, detail
	*** min 0, mean 25.5, max 942.13, not a lot of variation
	*** compare step 9 on other waves
	replace 		cropvl = cropvl_1_
	*** 41 changes
	
	drop 			cropvl_1_ mi_miss
* do harvest value and harvest quantity contradict?
	tab				harvvlush if harvqty == 0
	replace 		harvvlush = 0 if harvqty == 0
	*** 0 changes made
	replace 		cropvl = 0 if harvqty == 0
	*** 0 changes made
	
* ************************************************************************
* 9 - impute harvkgsold
* ************************************************************************	
	
* replace any +3 s.d. away from median as missing, by crop
	sort 			cropid
	sum				harvkgsold, detail 
	*** mean 181.89, max 102400
	by 				cropid: replace	harvkgsold = . if harvkgsold > `r(p50)'+ (3*`r(sd)')
	sum				harvkgsold, detail
	*** replaced 28 values, max is now 5280, mean 118.7
	
* impute missing values
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed harvkgsold // identify harvkgsold as the variable being imputed
	sort			hhid prcid pltid cropid, stable // sort to ensure reproducability of results
	mi impute 		pmm harvkgsold i.districtdstrng i.cropid cropvl, add(1) rseed(245780) ///
						noisily dots force knn(5) bootstrap
	mi 				unset	

* how did the imputation go?
	tab				mi_miss
	tabstat			harvkgsold harvkgsold_1_, by(mi_miss) ///
						statistics(n mean min max) columns(statistics) ///
						longstub format(%9.3g) 
	replace			harvkgsold = harvkgsold_1_ if cropvl != . 
	lab var			harvkgsold "kg of harvest sold, imputed (only if produce was sold)"
	sum 			harvkgsold
	drop			harvkgsold_1_ mi_miss
	*** imputed observations changed 28 observations for people who sold 
	*** mean 121.24 , max stays at 5280 
	
* ********************************************************************
* 10 - make cropvalue variable and impute it
* ********************************************************************	
	
* check out amount sold
* currently reported in Ugandan shilling
	tab 			harvvlush 
	replace 		harvvlush = . if harvvlush == 9999999 
	*** 0 changed to missing

* in usd
	sum 		cropvl, detail
	*** max 942.12, mean 25.48, min 0
	
* condensed crop codes
	inspect 		cropid
	*** generally things look all right - only 51 unique values 

* gen price per kg
	sort 			cropid
	by 				cropid: gen cropprice = cropvl / harvkgsold 
	sum 			cropprice, detail
	*** mean = 0.494, max = 61.24, min = 0
	*** will do some imputations later
	
* make datasets with crop price information
	preserve
	collapse 		(p50) p_parish=cropprice (count) n_parish=cropprice, by(cropid region districtdstrng countydstrng subcountydstrng parishdstrng)
	save 			"`export'/2011_agsec5a_p1.dta", replace 
	restore
	
	preserve
	collapse 		(p50) p_subcounty=cropprice (count) n_subcounty=cropprice, by(cropid region districtdstrng countydstrng subcountydstrng)
	save 			"`export'/2011_agsec5a_p2.dta", replace 	
	restore
	
	preserve
	collapse 		(p50) p_county=cropprice (count) n_county=cropprice, by(cropid region districtdstrng countydstrng)
	save 			"`export'/2011_agsec5a_p3.dta", replace 	
	restore
	
	preserve
	collapse 		(p50) p_dist=cropprice (count) n_district=cropprice, by(cropid region districtdstrng)
	save 			"`export'/2011_agsec5a_p4.dta", replace 
	restore
	
	preserve
	collapse 		(p50) p_reg=cropprice (count) n_reg=cropprice, by(cropid region)
	save 			"`export'/2011_agsec5a_p5.dta", replace 
	restore
	
	preserve
	collapse 		(p50) p_crop=cropprice (count) n_crop=cropprice, by(cropid)
	save 			"`export'/2011_agsec5a_p6.dta", replace 	
	restore
	
* merge the price datasets back in
	merge m:1 cropid region districtdstrng countydstrng subcountydstrng parishdstrng	        using "`export'/2011_agsec5a_p1.dta", gen(p1)
	*** all observations matched
	
	merge m:1 cropid region districtdstrng countydstrng subcountydstrng 	        using "`export'/2011_agsec5a_p2.dta", gen(p2)
	*** all observations matched

	merge m:1 cropid region districtdstrng countydstrng 			        using "`export'/2011_agsec5a_p3.dta", gen(p3)
	*** all observations matched
	
	merge m:1 cropid region districtdstrng 						using "`export'/2011_agsec5a_p4.dta", gen(p4)
	*** all observations matched
	
	merge m:1 cropid region						        using "`export'/2011_agsec5a_p5.dta", gen(p5)
	*** all observations matched
	
	merge m:1 cropid 						        using "`export'/2011_agsec5a_p6.dta", gen(p6)
	*** all observatinos matched

* erase price files
	erase			"`export'/2011_agsec5a_p1.dta"
	erase			"`export'/2011_agsec5a_p2.dta"
	erase			"`export'/2011_agsec5a_p3.dta"
	erase			"`export'/2011_agsec5a_p4.dta"
	erase			"`export'/2011_agsec5a_p5.dta"
	erase			"`export'/2011_agsec5a_p6.dta"

	drop p1 p2 p3 p4 p5 p6

* check to see if we have prices for all crops
	tabstat 		p_parish n_parish p_subcounty n_subcounty p_county n_county p_dist n_district p_reg n_reg p_crop n_crop, ///
						by(cropid) longstub statistics(n min p50 max) columns(statistics) format(%9.3g) 
	*** no prices for wheat, fallow fields, bush and trees were also included but have no prices
	
* drop if we are missing prices
	drop			if p_crop == .
	*** dropped 4 observations
	
* make imputed price, using median price where we have at least 10 observations
* this code generlaly files parts of malawi ag_i
* but this differs from Malawi - seems like their code ignores prices 
	gene	 		croppricei = .
	*** 13316 missing values generated
	
	bys cropid (region districtdstrng countydstrng subcountydstrng parishdstrng hhid prcid pltid): replace croppricei = p_parish if n_parish>=10 & missing(croppricei)
	*** 568 replaced
	bys cropid (region districtdstrng countydstrng subcountydstrng parishdstrng hhid prcid pltid): replace croppricei = p_subcounty if p_subcounty>=10 & missing(croppricei)
	*** 4 replaced
	bys cropid (region districtdstrng countydstrng subcountydstrng parishdstrng hhid prcid pltid): replace croppricei = p_county if n_county>=10 & missing(croppricei)
	*** 1812 replaced 
	bys cropid (region districtdstrng countydstrng subcountydstrng parishdstrng hhid prcid pltid): replace croppricei = p_dist if n_district>=10 & missing(croppricei)
	*** 926 replaced
	bys cropid (region districtdstrng countydstrng subcountydstrng parishdstrng hhid prcid pltid): replace croppricei = p_reg if n_reg>=10 & missing(croppricei)
	*** 9003 replaced 
	bys cropid (region districtdstrng countydstrng subcountydstrng parishdstrng hhid prcid pltid): replace croppricei = p_crop if missing(croppricei)
	*** 1003 changes
	lab	var			croppricei	"implied unit value of crop"

* verify that prices exist for all crops
	mdesc 			croppricei
	*** no missing
	
	sum 			cropprice croppricei
	*** mean = 0.337, max = 32.97
	
* generate value of harvest 
	gen				cropvalue = harvqtykg * croppricei
	label 			variable cropvalue	"implied value of crops" 
	
* replace cropvalue with cropvl if cropvl is not missing and crop value is missing
	replace 		cropvalue = cropvl if cropvalue == . & cropvl != .
	*** 0 change
	
* verify that we have crop value for all observations
	mdesc 			cropvalue
	*** 0 missing
	
* replace any +3 s.d. away from median as missing, by crop
	sum 			cropvalue, detail
	*** mean 98.06, max 12365.43
	replace			cropvalue = . if cropvalue > `r(p50)'+ (3*`r(sd)')
	sum				cropvalue, detail
	*** replaced 122 values
	*** reduces mean to 79.26, max to 768.211
	
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
	*** mean is 80.06, max is 768.21 min is 0
	*** imputed 122
	
* **********************************************************************
* 11 - end matter, clean up to save
* **********************************************************************

	keep hhid prcid pltid cropvalue harvqtykg region district county subcounty parish cropid HHS_hh_shftd_dsntgrtd_2011 panel_wgt_2011

	compress
	describe
	summarize

* save file
		customsave , idvar(hhid) filename("2011_AGSEC5A.dta") ///
			path("`export'/`folder'") dofile(2011_AGSEC5A) user($user)

* close the log
	log	close

/* END */
