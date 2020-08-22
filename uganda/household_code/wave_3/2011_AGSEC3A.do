* Project: WB Weather
* Created on: Aug 2020
* Created by: ek
* Stata v.16

* does
	* fertilizer use
	* reads Uganda wave 3 fertilizer and pest info (2011_AGSEC3A) for the 1st season
	* 3A - 5A are questionaires for the first planting season
	* 3B - 5B are questionaires for the second planting season

* assumes
	* customsave.ado
	* mdesc.ado

* TO DO:
	* compare wave 1-3 labor to decide if it is necessary to further impute

* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths	
	loc 	root 		= 		"$data/household_data/uganda/wave_3/raw"  
	loc     export 		= 		"$data/household_data/uganda/wave_3/refined"
	loc 	logout 		= 		"$data/household_data/uganda/logs"
	
* open log	
	cap log close
	log using "`logout'/2011_agsec3a", append
	
* **********************************************************************
* 1 - import data and rename variables
* **********************************************************************

* import wave 2 season A
	use "`root'/2011_AGSEC3A.dta", clear
		
	rename 		HHID hhid
	rename		parcelID prcid
	rename		plotID pltid

	replace		prcid = 1 if prcid == .
	
	describe
	sort hhid prcid pltid
	isid hhid prcid pltid

* **********************************************************************
* 2 - merge location data
* **********************************************************************	
	
* merge the location identification
	merge m:1 hhid using "`export'/2011_GSEC1"
	*** 190 unmatched from master
	*** no means to find the missing location data at the moment
	drop 		if _merge != 3
	
* encode district for the imputation
	encode 		district, gen (districtdstrng)
	encode		county, gen (countydstrng)
	encode		subcounty, gen (subcountydstrng)
	
* **********************************************************************
* 3 - fertilizer, pesticide and herbicide
* **********************************************************************
* fertilizer use
	rename 		a3aq13 fert_any
	rename 		a3aq15 kilo_fert
		
	sum 		kilo_fert if fert_any == 1, detail
	*** 33.85, min 0.25, max 800
	*** standard deviation 86.1, 3 std devs from the median is 264
	*** impute kilo_fert which seems a bit high

* replace zero to missing, missing to zero, and outliers to mizzing
	replace			kilo_fert = . if kilo_fert > 264
	*** 3 outliers changed to missing

* impute missing values (only need to do four variables)
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously

* impute each variable in local	
	*** the finer geographical variables will proxy for soil quality which is a determinant of fertilizer use
	mi register			imputed kilo_fert // identify variable to be imputed
	sort				hhid prcid pltid, stable // sort to ensure reproducability of results
	mi impute 			pmm kilo_fert i.region i.districtdstrng i.countydstrng i.subcountydstrng fert_any, add(1) rseed(245780) ///
								noisily dots force knn(5) bootstrap					
	mi 				unset		
	
* how did impute go?	
	sum 		kilo_fert_1_ if fert_any == 1, detail
	*** max 200, mean 26.71, min 0.25
	replace		kilo_fert = kilo_fert_1_ if fert_any == 1
	*** 3 changed
	
* replace the missing fert_any with 0
	replace		fert_any = 2 if fert_any == . 
	*** 29 changes
	
	drop 		kilo_fert_1_ mi_miss	

* **********************************************************************
* 4 - pesticide & herbicide
* **********************************************************************

* pesticide & herbicide
	tab 		a3aq22
	*** 5.03 percent of the sample used pesticide or herbicide
	tab 		a3aq23
	
	gen 		pest_any = 1 if a3aq27 != . & a3aq27 != 4
	replace		pest_any = 0 if pest_any == .
	
	gen 		herb_any = 1 if a3aq27 == 4 | a3aq27 == 96
	replace		herb_any = 0 if herb_any == .

* **********************************************************************
* 5 - labor 
* **********************************************************************
	* per Palacios-Lopez et al. (2017) in Food Policy, we cap labor per activity
	* 7 days * 13 weeks = 91 days for land prep and planting
	* 7 days * 26 weeks = 182 days for weeding and other non-harvest activities
	* 7 days * 13 weeks = 91 days for harvesting
	* we will also exclude child labor_days
	* in this survey we can't tell gender or age of household members
	* since we can't match household members we deal with each activity seperately
	* includes all labor tasks performed on a plot during the first cropp season

* family labor
	
* make a binary if they had family work
	gen				fam = 1 if a3aq31 > 0
	
* how many household members worked on this plot?
	tab 			a3aq31
	replace			a3aq31 = 0 if a3aq31 == 25000
	*** family labor is from 0 - 12 people
	sum 			a3aq32, detail
	*** mean 32.9, min 1, max 300, std dev 19.97
	
	*replace			a3aq32 = . if a3aq32 > 90
	*** 93 changes made

* impute missing values (only need to do four variables)	
	*mi set 			wide 	// declare the data to be wide.
	*mi xtset		, clear 	// clear any xtset that may have had in place previously

* impute each variable in local		
	*mi register			imputed a3aq32 // identify variable to be imputed
	*sort				hhid prcid, stable // sort to ensure reproducability of results
	*mi impute 			pmm a3aq32 i.region i.districtdstrng i.countydstrng i.fam, add(1) rseed(245780) ///
	*							noisily dots force knn(5) bootstrap						
	*mi 				unset
		
* how did impute go?
	*sum 			a3aq32_1_
	*** mean 31.95, min 1, max 90
	*** looks good, replace
	*replace			a3aq32 = a3aq32_1_ if fam == 1
	*** 94 changes made
	
* fam lab = number of family members who worked on the farm*days they worked	
	gen 			fam_lab = a3aq31*a3aq32
	sum				fam_lab	
	*** max 3000, mean 104.22, min 0
	
* hired labor 
* hired men days
	rename	 		a3aq35a hired_men
		
* make a binary if they had hired_men
	gen 			men = 1 if hired_men != . & hired_men != 0
* hired women days
	rename			a3aq35b hired_women 
		
* make a binary if they had hired_men
	gen 			women = 1 if hired_women != . & hired_women != 0
	
* impute labor all at once
	sum 			fam_lab, detail
	sum				hired_men, detail
	sum 			hired_women, detail

* generate local for variables that contain outliers
	*loc				fam_lab hired_men hired_women

* replace zero to missing, missing to zero, and outliers to mizzing
	*foreach var of loc labor {
	 *   mvdecode 		`var', mv(0)
	*	mvencode		`var', mv(0)
	*    replace			`var' = . if `var' > 90
	*}
	*** 1,813 outliers changed to missing

* impute missing values (only need to do four variables)
	*mi set 			wide 	// declare the data to be wide.
	*mi xtset		, clear 	// clear any xtset that may have had in place previously

* impute each variable in local		
*	foreach var of loc labor {
	*	mi register			imputed `var' // identify variable to be imputed
	*	sort				hhid plotid, stable // sort to ensure reproducability of results
	*	mi impute 			pmm `var' i.state, add(1) rseed(245780) ///
	*							noisily dots force knn(5) bootstrap
	*}						
	*mi 				unset
		
* how did impute go?
	*sum 			fam_lab_1_
	
	*replace 		fam_lab		= fam_lab_1_ 		if fam == 1
	*replace			hired_men 	= hired_men_2_ 		if men == 1
	*replace			hired_women = hired_women_3_ 	if women == 1

* generate labor days as the total amount of labor used on plot in person days
	gen				labor_days = fam_lab + hired_men + hired_women
	
	sum 			labor_days
	*** mean 114.46, max 3080, min 3

* **********************************************************************
* 4 - end matter, clean up to save
* **********************************************************************

	keep hhid prcid pltid fert_any kilo_fert labor_days region ///
		district county subcounty parish pest_any herb_any

	compress
	describe
	summarize

* save file
		customsave , idvar(hhid) filename("2011_AGSEC3A.dta") ///
			path("`export'/`folder'") dofile(2011_AGSEC3A) user($user)

* close the log
	log	close

/* END */	