* Project: WB Weather
* Created on: Aug 2020
* Created by: ek
* Stata v.16

* does
	* Crop output
	* reads Uganda wave 2 crop output (2010_AGSEC5A) for the 1st season
	* 3A - 5A are questionaires for the first planting season
	* 3B - 5B are questionaires for the second planting season

* assumes
	* customsave.ado
	* mdesc.ado

* TO DO:
	* 

* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths	
	loc 	root 		= 		"$data/household_data/uganda/wave_2/raw"  
	loc     export 		= 		"$data/household_data/uganda/wave_2/refined"
	loc 	logout 		= 		"$data/household_data/uganda/logs"
	loc 	conv 		= 		"$data/household_data/uganda/conversion_files"  

* open log	
	cap log close
	log using "`logout'/2010_AGSEC5A", append

* **********************************************************************
* 1 - import data and rename variables
* **********************************************************************

* import wave 2 season 1
	use "`root'/2010_AGSEC5A.dta", clear
	
	rename 		HHID hhid
	rename 		cropID cropid
	rename 		a5aq6c unit
	rename		a5aq6b condition
	
	describe
	sort hhid prcid pltid cropid
	*** cannot uniquely identify observations by hhid, prcid, or pltid because there multiple crops on the same plot
	*** will collapse to crop level after using variables that cannot be collapsed easily

* **********************************************************************
* 2 - merge kg conversion file
* **********************************************************************
	
	merge m:1 cropid unit condition using "`conv'/ValidCropUnitConditionCombinations.dta" 
	*** unmatched 3674 from master 
	
* drop from using

	drop if _merge == 2

* how many unmatched had a harvest of 0

	tab a5aq6a if _merge == 1
	*** 50% have a harvest of 0
	
* how many unmatched because they used "other" to categorize the state of harvest?

	tab condition if _merge == 1
	*** any condition is mostly missing from unmerged observations
		
	tab unit if _merge == 1
	
* replace ucaconversion to 1 if the harvest is 0

	replace ucaconversion = 1 if a5aq6a == 0 & _merge == 1
	*** 699 changes
	
* manually replace conversion for the kilograms and sacks if the condition is other condition and the observation is unmatched

	*kgs,  83 changes
	replace ucaconversion = 1 if unit == 1 & _merge == 1
	
	*sack 120 kgs, 13 changes
	replace ucaconversion = 120 if unit == 9 & _merge == 1
	
	*sack 100 kgs, 178 changes
	replace ucaconversion = 100 if unit == 10 & _merge == 1
	
	* sack 80 kgs, 6 changes
	replace ucaconversion = 80 if unit == 11 & _merge == 1
	
	* sack 50 kgs, 21 changes
	replace ucaconversion = 50 if unit == 12 & _merge == 1
	
	tab ucaconversion if _merge == 3 & ucaconversion != a5aq6d 
	*** 7745 different
	
	tab medconversion if _merge == 3 & medconversion != a5aq6d 
	*** 5321 different
	
	replace ucaconversion = medconversion if _merge == 3 & ucaconversion == .
	
	mdesc ucaconversion
	*** 19.27% missing
	
* 98.78% of observations missing conversion also had a missing harvest amount
	* replace those missing with 0
	
	mdesc ucaconversion if a5aq6a == .
	*** 98.78% missing
	
	replace a5aq6a = 0 if a5aq6a == .
	*** 2286 changes
	
	replace ucaconversion = 1 if a5aq6a == 0
	*** 2268 changes
	
* some missing harvests still have a value for amount sold. Will replace amount sold with 0 if harv qty is missing

	tab a5aq8 if a5aq6a == .
	*** 29 observations
	
	replace a5aq8 = . if a5aq6a == 0 & a5aq7a>0
	*** 29 observations
	
* drop any observations that remain and still dont have a conversion factor
	drop if ucaconversion == .
	*** 416 observations dropped
	
	drop _merge
* **********************************************************************
* 2 - Quantity harvested
* **********************************************************************
	
	tab			cropid
	*** beans are the most numerous crop being 16.23% of crops planted
	***	maize is the second highest being 15.23%
	*** maize will be main crop following most other countries in the study
	
* Convert harv quantity to kg
	*** harvest quantity is in a variety of measurements
	*** included in the file are the conversions from other measurements to kg
	
	rename 			a5aq6a harvqty
	label var 		harvqty "Harvest quantity not converted"

	gen 			harvqtykg = harvqty*ucaconversion
	label var		harvqtykg "weight of harvest in kg's"
	
	sum 			harvqtykg, detail
	***	min 0, max 70215, mean 347.18
	*** will impute later

* what can we say about the distribution?
	*kdensity 		harvqtykg
	*** left skewed with a long tail
	
* **********************************************************************
* 3 - value of harvest
* **********************************************************************
	
	rename			a5aq8 harvvlush
	label var 		harvvlush "Value of crop sold in ugandan shilling"
	
* sum value of sales in shillings
	sum 			harvvlush, detail
	*** mean 129872.7, max 1.01e+07, min 0
		
	gen 		cropvl = harvvlush / 2028.8813
	lab var 	cropvl "total value of harvest in 2010 USD"
	
	sum 		cropvl, detail
	*** mean 64.5, min 0, max 4968.25, std dev 202.69

* **********************************************************************
* 4 - generate sold harvested values
* **********************************************************************

* rename condition of sold and unit of sold products
	rename 			a5aq7b sold_condition_code
	rename			a5aq7c sold_unit_code

* merge conversion for sold products
	merge m:1 cropid sold_unit_code sold_condition_code using "`conv'/soldcropconversion.dta" 	

* sold produce
	gen 	soldprod = 1 if a5aq7a > 0
	label var 		soldprod "=1 if farmer reported a positive amount sold"
	tab 			soldprod
	*** 7414 had soldprod greater than 0
	
	drop 			if _merge == 2

* some observations are missing ucaconversion but have medconversion, we can recover those observations
	replace 		sold_ucaconversion = sold_medconversion if sold_ucaconversion == . & soldprod == 1
	*** 860 changes made
	
* at the least we ensure kg's get converted, some condition states were not in the conversion file but it shouldnt matter if the product was always in kg's
	replace 		sold_ucaconversion = 1 if sold_unit_code == 1 & soldprod > 0
	* 118 changes made
	
	mdesc 			sold_ucaconversion if soldprod == 1
	*** 4567 out of 7414 observations that sold are missing a conversion factor
	
* convert quantity sold into kg
	gen 			harvkgsold = a5aq7a*sold_ucaconversion if soldprod == 1
	lab	var			harvkgsold "quantity harvested and sold, in kilograms"

	tab 			harvkgsold
	mdesc 			harvkgsold if soldprod == 1
	*** 73.19% are missing, 5426 missing
	
	sum				harvkgsold, detail
	*** min 0.15, mean 368.81, max 60000

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
	merge m:1 hhid using "`export'/2010_GSEC1"
	*** 0 unmatched from master
	drop 		if _merge != 3
	
* encode district for the imputation
	encode 		district, gen (districtdstrng)
	encode		county, gen (countydstrng)
	encode		subcounty, gen (subcountydstrng)
	
	
* **********************************************************************
* 7 - impute harvqtykg
* **********************************************************************

* replace observations 3 std deviation from the mean and impute missing
	*** 3 std dev from mean is 
	sum 			harvqtykg, detail
	replace			harvqtykg = . if harvqtykg > `r(p50)'+ (3*`r(sd)')
	*** 143 changed to missing

* impute missing harvqtykg
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously

* impute harvqtykg	
	mi register			imputed harvqtykg // identify harvqty variable to be imputed
	sort				hhid prcid pltid cropid, stable // sort to ensure reproducability of results
	mi impute 			pmm harvqtykg i.region cropid, add(1) rseed(245780) ///
								noisily dots force knn(5) bootstrap					
	mi 				unset	
	
* inspect imputation 
	sum 				harvqtykg_1_, detail
	*** mean 282.65, min 0, max 4532.5
	*** looks better

* replace the imputated variable
	replace 			harvqtykg = harvqtykg_1_ 
	*** 143 changes
	
	drop 				harvqtykg_1_ mi_miss
	
* ***********************************************************************
* 8 - impute cropvl
* ***********************************************************************	

* replace cropvl with missing if over 3 std dev from the mean
	sum 			cropvl, detail
	replace			cropvl = . if cropvl > `r(p50)'+ (3*`r(sd)')
	*** 101 changes
	
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
	*** min 0, mean 11.852, max 364.02, not a lot of variation
	replace 		cropvl = cropvl_1_
	*** 101 changes
	
	drop 			cropvl_1_ mi_miss
* do harvest value and harvest quantity contradict?
	tab		cropvl if harvqty ==0
	*** yes, 6 observations have a positive value of harvest despite not having harvested
	replace 		cropvl = 0 if cropvl != 0 & harvqty == 0
	*** 6 changes
	
* ************************************************************************
* 9 - impute harvkgsold
* ************************************************************************	
	
* replace any +3 s.d. away from median as missing, by cropid
	sort 			cropid
	sum				harvkgsold, detail 
	by 				cropid: replace	harvkgsold = . if harvkgsold > `r(p50)'+ (3*`r(sd)')
	sum				harvkgsold, detail
	*** replaced 49 values
	
* impute missing values
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed harvkgsold // identify harvkgsold as the variable being imputed
	sort			hhid prcid pltid cropid, stable // sort to ensure reproducability of results
	mi impute 		pmm harvkgsold i.districtdstrng i.cropid, add(1) rseed(245780) ///
						noisily dots force knn(5) bootstrap
	mi 				unset	

* how did the imputation go?
	tab				mi_miss
	tabstat			harvkgsold harvkgsold_1_, by(mi_miss) ///
						statistics(n mean min max) columns(statistics) ///
						longstub format(%9.3g) 
	replace			harvkgsold = harvkgsold_1_
	*** 49 changes
	lab var			harvkgsold "kg of harvest sold, imputed (only if produce was sold)"
	sum 			harvkgsold
	drop			harvkgsold_1_ mi_miss
	*** imputed observations changed 45 observations for people who sold 
	*** mean 37.32 , max 2125
	
* ********************************************************************
* 10 - make cropvalue variable and impute it
* ********************************************************************	
	
* check out amount sold
* currently reported in Ugandan shilling
	tab 			harvvlush 
	replace 		harvvlush = . if harvvlush == 9999999 
	*** 0 changed to missing

* gen price per kg
	sort 			cropid
	by 				cropid: gen cropprice = cropvl / harvkgsold 
	sum 			cropprice, detail
	*** mean = 0.67, max = 98.58, min = 0
	*** will do some imputations later

* encode parish
	encode parish, gen(parishdstrng)
	
* make datasets with crop price information
	preserve
	collapse 		(p50) p_parish=cropprice (count) n_parish=cropprice, by(cropid region districtdstrng countydstrng subcountydstrng parishdstrng)
	save 			"`export'/2010_agsec5a_p1.dta", replace 
	restore
	
	preserve
	collapse 		(p50) p_subcounty=cropprice (count) n_subcounty=cropprice, by(cropid region districtdstrng countydstrng subcountydstrng)
	save 			"`export'/2010_agsec5a_p2.dta", replace 	
	restore
	
	preserve
	collapse 		(p50) p_county=cropprice (count) n_county=cropprice, by(cropid region districtdstrng countydstrng)
	save 			"`export'/2010_agsec5a_p3.dta", replace 	
	restore
	
	preserve
	collapse 		(p50) p_dist=cropprice (count) n_district=cropprice, by(cropid region districtdstrng)
	save 			"`export'/2010_agsec5a_p4.dta", replace 
	restore
	
	preserve
	collapse 		(p50) p_reg=cropprice (count) n_reg=cropprice, by(cropid region)
	save 			"`export'/2010_agsec5a_p5.dta", replace 
	restore
	
	preserve
	collapse 		(p50) p_crop=cropprice (count) n_crop=cropprice, by(cropid)
	save 			"`export'/2010_agsec5a_p6.dta", replace 	
	restore
	
* merge the price datasets back in
	merge m:1 cropid region districtdstrng countydstrng subcountydstrng parishdstrng	        using "`export'/2010_agsec5a_p1.dta", gen(p1)
	*** all observations matched
	
	merge m:1 cropid region districtdstrng countydstrng subcountydstrng 	        using "`export'/2010_agsec5a_p2.dta", gen(p2)
	*** all observations matched

	merge m:1 cropid region districtdstrng countydstrng 			        using "`export'/2010_agsec5a_p3.dta", gen(p3)
	*** all observations matched
	
	merge m:1 cropid region districtdstrng 						using "`export'/2010_agsec5a_p4.dta", gen(p4)
	*** all observations matched
	
	merge m:1 cropid region						        using "`export'/2010_agsec5a_p5.dta", gen(p5)
	*** all observations matched
	
	merge m:1 cropid 						        using "`export'/2010_agsec5a_p6.dta", gen(p6)
	*** all observatinos matched

* erase price files
	erase			"`export'/2010_agsec5a_p1.dta"
	erase			"`export'/2010_agsec5a_p2.dta"
	erase			"`export'/2010_agsec5a_p3.dta"
	erase			"`export'/2010_agsec5a_p4.dta"
	erase			"`export'/2010_agsec5a_p5.dta"
	erase			"`export'/2010_agsec5a_p6.dta"

	
	drop p1 p2 p3 p4 p5 p6

* check to see if we have prices for all crops
	tabstat 		p_parish n_parish p_subcounty n_subcounty p_county n_county p_dist n_district p_reg n_reg p_crop n_crop, ///
						by(cropid) longstub statistics(n min p50 max) columns(statistics) format(%9.3g) 
	*** no prices for wheat, fallow fields, bush and trees were also included but have no prices
	
* drop if we are missing prices
	drop			if p_crop == .
	*** dropped 982 observations
	
* make imputed price, using median price where we have at least 10 observations
* this code generlaly files parts of malawi ag_i
* but this differs from Malawi - seems like their code ignores prices 
	gene	 		croppricei = .
	*** 10969 missing values generated
	
	bys cropid (region districtdstrng countydstrng subcountydstrng parishdstrng hhid prcid pltid): replace croppricei = p_parish if n_parish>=10 & missing(croppricei)
	*** 146 replaced
	bys cropid (region districtdstrng countydstrng subcountydstrng parishdstrng hhid prcid pltid): replace croppricei = p_subcounty if p_subcounty>=10 & missing(croppricei)
	*** 10 replaced
	bys cropid (region districtdstrng countydstrng subcountydstrng parishdstrng hhid prcid pltid): replace croppricei = p_county if n_county>=10 & missing(croppricei)
	*** 823 replaced 
	bys cropid (region districtdstrng countydstrng subcountydstrng parishdstrng hhid prcid pltid): replace croppricei = p_dist if n_district>=10 & missing(croppricei)
	*** 450 replaced
	bys cropid (region districtdstrng countydstrng subcountydstrng parishdstrng hhid prcid pltid): replace croppricei = p_reg if n_reg>=10 & missing(croppricei)
	*** 6763 replaced 
	bys cropid (region districtdstrng countydstrng subcountydstrng parishdstrng hhid prcid pltid): replace croppricei = p_crop if missing(croppricei)
	*** 2777 changes
	lab	var			croppricei	"implied unit value of crop"

* verify that prices exist for all crops
	mdesc 			croppricei
	*** no missing
	
	sum 			cropprice croppricei
	*** mean = 0.235, max = 44.36
	
* generate value of harvest 
	gen				cropvalue = harvqtykg * croppricei
	label 			variable cropvalue	"implied value of crops" 
	
* replace cropvalue with cropvl if cropvl is not missing and crop value is missing
	replace 		cropvalue = cropvl if cropvalue == . & cropvl != .
	*** 0 change
	
* verify that we have crop value for all observations
	mdesc 			cropvalue
	*** 0 missing
	
* replace any +3 s.d. away from median as missing, by cropid
	sum 			cropvalue, detail
	*** mean 42.82, max 51752.66
	replace			cropvalue = . if cropvalue > `r(p50)'+ (3*`r(sd)')
	sum				cropvalue, detail
	*** replaced 10 values
	*** reduces mean to 35.48, max to 1478
	
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
	*** mean is 35.49, max is 1478.65 min is 0
	*** imputed 10
	
* **********************************************************************
* 11 - end matter, clean up to save
* **********************************************************************

	keep hhid prcid pltid cropvalue harvqtykg region district county subcounty parish cropid hh_status2010 spitoff09_10 spitoff10_11 wgt10

	compress
	describe
	summarize

* save file
		customsave , idvar(hhid) filename("2010_AGSEC5A.dta") ///
			path("`export'/`folder'") dofile(2010_AGSEC5A) user($user)

* close the log
	log	close

/* END */
