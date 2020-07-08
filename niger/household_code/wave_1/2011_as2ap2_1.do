* Project: WB Weather
* Created on: June 2020
* Created by: ek
* Stata v.16

* does
	* reads in Niger, WAVE 1 (2011), POST PLANTING (first passage), ecvmaas1_p2_en
	* cleans labor post planting - planting labor 
	* outputs clean data file ready for combination with wave 1 plot data

* assumes
	* customsave.ado

* TO DO:
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
	log 	using	"`logout'/2011_as2ap2_1", append

* **********************************************************************
* 1 - set up and organization 
* **********************************************************************

* import the first relevant data file
	use				"`root'/ecvmaas1_p2_en", clear

* need to rename for English
	rename 			passage visit
	label 			var visit "number of visit"
	rename			grappe clusterid
	label 			var clusterid "cluster number"
	rename			menage hh_num
	label 			var hh_num "household number - not unique id"
	*** will need to do these in every file
	rename 			as01qa ord 
	label 			var ord "number of order"
	rename 			as01q03 field 
	label 			var field "field number"
	rename 			as01q05 parcel 
	label 			var parcel "parcel number"


* drop households that did not use field during the rainy season
	drop 	if 	as02aq04 == 2
	*** 460 observations dropped
	*** This variable most closely resembles the variable that asks if fields were cultivated
	*** We dropped observations if fields were not cultivated in wave 2

	
* drop the households missing field, parcel, ord to create the id variable. 
	drop	if field==.
	*** dropped 1630 observations
	
* need to include clusterid, hhnumber, order, field, and parcel to uniquely identify
	describe
	sort 			clusterid hh_num ord field parcel
	isid 			clusterid hh_num ord field parcel



* **********************************************************************
* 2 - determine planting labor allocation 
* **********************************************************************

* per Palacios-Lopez et al. (2017) in Food Policy, we cap labor per activity
* 7 days * 13 weeks = 91 days for land prep and planting
* 7 days * 26 weeks = 182 days for weeding and other non-harvest activities
* 7 days * 13 weeks = 91 days for harvesting
* we will also exclude child labor_days
* will not disaggregate gender / age - pool together, as with other rounds 
* in line with others, will deal with each activity seperately

* create household member labor 
* as02aq28**a identified HH ID of laborer 
* as02aq28**b identifies number of days that person worked 

	gen				hh_1 = as02aq28b
	replace			hh_1 = 0 if hh_1 == .
	
	gen				hh_2 = as02aq29b
	replace			hh_2 = 0 if hh_2 == .
	
	gen				hh_3 = as02aq30b
	replace			hh_3 = 0 if hh_3 == .
	
	gen				hh_4 = as02aq31b
	replace			hh_4 = 0 if hh_4 == .
	
	gen				hh_5 = as02aq32b
	replace			hh_5 = 0 if hh_5 == .
	
	gen				hh_6 = as02aq33b
	replace			hh_6 = 0 if hh_6 == .
	
	*** this calculation is for up to 6 members of the household that were laborers
	*** per the survey, these are laborers from the main rainy season
	*** includes labor for various planting activities - 182 day max 
	*** does not include harvest labor or prep labor 
	
* hired labor days   
* language is different than in P1, in this case refers to "other"
* i think that pooling all three together will be the most appropriate method 
* that is, including hired, mutual, and family labor 

	tab 			as02aq35a
	*** 1237 hired "other" labor, 4965  did not
	
	gen				hired_men = .
	replace			hired_men = as02aq35b if as02aq35a == 1
	replace			hired_men = 0 if as02aq35a == 2
	replace			hired_men = 0 if as02aq35a == .
	replace 		hired_men = 0 if hired_men == .  

	gen				hired_women = .
	replace			hired_women = as02aq35c if as02aq35a == 1
	replace			hired_women = 0 if as02aq35a == 2
	replace			hired_women = 0 if as02aq35a == .
	replace 		hired_women = 0 if hired_women == .  
	
	*** we do not include child labor days
	
* mutual labor days from other households

	tab 			as02aq34a, missing
	*** 521 received mutual labor,  5681  did not
	
	gen 			mutual_men = .
	replace			mutual_men = as02aq34b if as02aq34a == 1
	replace			mutual_men = 0 if as02aq34a == 2
	replace			mutual_men = 0 if as02aq34a == . 
	replace 		mutual_men = 0 if mutual_men == . 

	gen 			mutual_women = .
	replace			mutual_women = as02aq34c if as02aq34a == 1
	replace			mutual_women = 0 if as02aq34a == 2
	replace			mutual_women = 0 if as02aq34a == .
	replace			mutual_women = 0 if mutual_women == . 

	*** we do not include child labor days
	
* **********************************************************************
* 3 - impute labor outliers
* **********************************************************************
	
* summarize household individual labor for land prep to look for outliers
	sum				hh_1 hh_2 hh_3 hh_4 hh_5 hh_6 hired_men hired_women mutual_men mutual_women
	*** hired_men, hired_women are greater than the maximum (182 days)
	
* generate local for variables that contain outliers
	loc				labor hh_1 hh_2 hh_3 hh_4 hh_5 hired_men hired_women

* replace zero to missing, missing to zero, and outliers to missing
	foreach var of loc labor {
	    mvdecode 		`var', mv(0)
		mvencode		`var', mv(0)
	    replace			`var' = . if `var' > 90
	}
	*** 36 outliers changed to missing

* impute missing values (going to impute all variables - rather than subset)
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously


* impute each variable in local		
	foreach var of loc labor {
		mi register			imputed `var' // identify variable to be imputed
		sort				clusterid hh_num ord field parcel, stable 
		// sort to ensure reproducability of results
		mi impute 			pmm `var' i.clusterid, add(1) rseed(245780) ///
								noisily dots force knn(5) bootstrap
	}						
	mi 				unset	
	
* summarize imputed variables
	sum				hh_1_1_ hh_2_2_ hh_3_3_ hh_4_4_ hh_5_5_ hired_men_6_ hired_women_7_
	* all values seem fine
	replace			hh_1 = hh_1_1_
	replace			hh_2 = hh_2_2_	
	replace 		hh_3 = hh_3_3_
	replace			hh_4 = hh_4_4_
	replace			hh_5 = hh_5_5_
	replace 		hired_men = hired_men_6_ 
	replace			hired_women = hired_women_7_ 

* total labor days for harvest
	egen			hh_plant_labor = rowtotal(hh_1 hh_2 hh_3 hh_4 hh_5 hh_6)
	egen			hired_plant_labor  = rowtotal(hired_men hired_women)
	egen			mutual_plant_labor = rowtotal(mutual_men mutual_women)
	egen			plant_labor = rowtotal(hh_plant_labor hired_plant_labor)
	lab var			plant_labor "total labor for planting (days) - no free labor"
	egen 			plant_labor_all = rowtotal(hh_plant_labor hired_plant_labor mutual_plant_labor)  
	lab var			plant_labor_all "total labor for planting (days) - with free labor"

* check for missing values
	mdesc			plant_labor plant_labor_all
	*** no missing values
	sum 			plant_labor plant_labor_all
	*** which is used will not make that much of a difference
	*** with free labor: average = 39.2, max = 554
	*** without free labor: average = 38.49, max = 554
	
* **********************************************************************
* 3 - end matter, clean up to save
* **********************************************************************

	keep 			clusterid hh_num ord field parcel plant_labor plant_labor_all ///
					hh_plant_labor hired_plant_labor mutual_plant_labor 

* create unique household-plot identifier
	isid				clusterid hh_num ord field parcel
	sort				clusterid hh_num ord field parcel, stable 
	egen				plot_id = group(clusterid hh_num ord field parcel)
	lab var				plot_id "unique field and parcel identifier"

	compress
	describe
	summarize

* save file
		customsave , idvar(plot_id) filename("2011_as2ap2_1") ///
			path("`export'") dofile(2011_as2ap2_1) user($user)

* close the log
	log	close

/* END */
	
	
	
	
	