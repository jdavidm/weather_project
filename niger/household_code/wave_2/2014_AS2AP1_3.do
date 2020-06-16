* Project: WB Weather
* Created on: June 2020
* Created by: alj
* Stata v.16

* does
	* reads in Niger, WAVE 2 (2014), POST PLANTING (first passage), ECVMA2_AS2AP1
	* cleans labor post planting - prep labor 
	* combines all labor files in Niger for combination with wave 2 plot data (harvest, planting)

* assumes
	* customsave.ado

* TO DO:
	* done

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		root	=		"$data/household_data/niger/wave_2/raw"
	loc		export	=		"$data/household_data/niger/wave_2/refined"
	loc		logout	= 		"$data/household_data/niger/logs"

* open log
	log 	using	"`logout'/2014_as2ap1_3", append

* **********************************************************************
* 1 - set up and organization 
* **********************************************************************

* import the first relevant data file
	use				"`root'/ECVMA2_AS2AP1", clear
		
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
	rename 			AS02AQA ord 
	label 			var ord "number of order"
	rename 			AS01Q01 field 
	label 			var field "field number"
	rename 			AS01Q03 parcel 
	label 			var parcel "parcel number"
	
* need to include clusterid, hhnumber, extension, order, field, and parcel to uniquely identify
	describe
	sort 			clusterid hh_num extension ord field parcel
	isid 			clusterid hh_num extension ord field parcel

* determine cultivated plot
	rename 			AS02AQ04 cultivated
	label 			var cultivated "plot cultivated"
* drop if not cultivated
	keep 			if cultivated == 1
	*** 301 observations dropped
	
* **********************************************************************
* 2 - determine labor allocation 
* **********************************************************************

* per Palacios-Lopez et al. (2017) in Food Policy, we cap labor per activity
* 7 days * 13 weeks = 91 days for land prep and planting
* 7 days * 26 weeks = 182 days for weeding and other non-harvest activities
* 7 days * 13 weeks = 91 days for harvesting
* we will also exclude child labor_days
* will not disaggregate gender / age - pool together, as with other rounds 
* in line with others, will deal with each activity seperately

* create household member labor 
* AS02AQ1*A identified HH ID of laborer 
* AS02AQ1*B identifies number of days that person worked 

	gen				hh_1 = AS02AQ17B
	replace			hh_1 = 0 if hh_1 == .
	
	gen				hh_2 = AS02AQ18B
	replace			hh_2 = 0 if hh_2 == .
	
	gen				hh_3 = AS02AQ19B
	replace			hh_3 = 0 if hh_3 == .
	
	gen				hh_4 = AS02AQ20B
	replace			hh_4 = 0 if hh_4 == .
	
	gen				hh_5 = AS02AQ21B
	replace			hh_5 = 0 if hh_5 == .
	
	gen				hh_6 = AS02AQ22B
	replace			hh_6 = 0 if hh_6 == .
	
	*** this calculation is for up to 6 members of the household that were laborers
	*** per the survey, these are laborers from the main rainy season
	*** includes labor for clearing, burning, fertilizing - would here include combination of land prep (91 day max)
	*** does not include harvest labor or planting labor 
	
* hired labor days   

	tab 			AS02AQ24A
	*** 647 hired labor, 4487 did not
	
	gen				hired_men = .
	replace			hired_men = AS02AQ24B if AS02AQ24A == 1
	replace			hired_men = 0 if AS02AQ24A == 2
	replace			hired_men = 0 if AS02AQ24A == 9 
	replace			hired_men = 0 if AS02AQ24B == 999
	replace 		hired_men = 0 if hired_men == .  

	gen				hired_women = .
	replace			hired_women = AS02AQ24C if AS02AQ24A == 1
	replace			hired_women = 0 if AS02AQ24A == 2
	replace			hired_women = 0 if AS02AQ24A == 9 
	replace			hired_women = 0 if AS02AQ24C == 999
	replace 		hired_women = 0 if hired_women == .  
	
	*** we do not include child labor days
	
* mutual labor days from other households

	tab 			AS02AQ23A
	*** 417 received mutual labor, 4718 did not
	
	gen 			mutual_men = .
	replace			mutual_men = AS02AQ23B if AS02AQ23A == 1
	replace			mutual_men = 0 if AS02AQ23A == 2
	replace			mutual_men = 0 if AS02AQ23A == 9 
	replace			mutual_men = 0 if AS02AQ23B == 999
	replace 		mutual_men = 0 if mutual_men == . 

	gen 			mutual_women = .
	replace			mutual_women = AS02AQ23C if AS02AQ23A == 1
	replace			mutual_women = 0 if AS02AQ23A == 2
	replace			mutual_women = 0 if AS02AQ23A == 9 
	replace			mutual_women = 0 if AS02AQ23C == 999 
	replace			mutual_women = 0 if mutual_women == . 

	*** we do not include child labor days
	
* **********************************************************************
* 3 - impute labor outliers
* **********************************************************************
	
* summarize household individual labor for land prep to look for outliers
	sum				hh_1 hh_2 hh_3 hh_4 hh_5 hh_6 hired_men hired_women mutual_men mutual_women
	*** hh_1, hh_2, hh_3, hired_men, mutual_men, mutual_women are all greater than the minimum (91 days)
	
* generate local for variables that contain outliers
	loc				labor hh_1 hh_2 hh_3 hh_4 hh_5 hh_6 hired_men hired_women mutual_men mutual_women

* replace zero to missing, missing to zero, and outliers to missing
	foreach var of loc labor {
	    mvdecode 		`var', mv(0)
		mvencode		`var', mv(0)
	    replace			`var' = . if `var' > 90
	}
	*** 18 outliers changed to missing

* impute missing values (only need to do six variables - set new local)
	loc 			laborimp hh_1 hh_2 hh_3 hired_men mutual_men mutual_women
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously


* impute each variable in local		
	foreach var of loc laborimp {
		mi register			imputed `var' // identify variable to be imputed
		sort				clusterid hh_num extension ord field parcel, stable 
		// sort to ensure reproducability of results
		mi impute 			pmm `var' i.clusterid, add(1) rseed(245780) ///
								noisily dots force knn(5) bootstrap
	}						
	mi 				unset	
	
* summarize imputed variables
	sum				hh_1_1_ hh_2_2_ hh_3_3_ hired_men_4_ mutual_men_5_ mutual_women_6_ 
	* all values seem fine
	replace			hh_1 = hh_1_1_
	replace			hh_2 = hh_2_2_	
	replace 		hh_3 = hh_3_3_
	replace 		hired_men = hired_men_4_ 
	replace			mutual_men = mutual_men_5_
	replace			mutual_women = mutual_women_6_ 

* total labor days for harvest
	egen			hh_prep_labor = rowtotal(hh_1 hh_2 hh_3 hh_4 hh_5 hh_6)
	egen			hired_prep_labor  = rowtotal(hired_men hired_women)
	egen			mutual_prep_labor = rowtotal(mutual_men mutual_women)
	egen			prep_labor = rowtotal(hh_prep_labor hired_prep_labor)
	lab var			prep_labor "total labor for prep (days) - no free labor"
	egen 			prep_labor_all = rowtotal(hh_prep_labor hired_prep_labor mutual_prep_labor)  
	lab var			prep_labor_all "total labor for prep (days) - with free labor"

* check for missing values
	mdesc			prep_labor prep_labor_all
	*** no missing values
	sum 			prep_labor prep_labor_all
	*** which is used will not make that much of a difference, except for max
	*** with free labor: average = 11.8, max = 270
	*** without free labor: average = 11.4, max = 180
	
* **********************************************************************
* 3 - combine planting and harvest labor 
* **********************************************************************

	keep 			clusterid hh_num extension ord field parcel prep_labor prep_labor_all ///
					hh_prep_labor hired_prep_labor mutual_prep_labor 
	
	* create unique household-plot identifier
	isid				clusterid hh_num extension ord field parcel
	sort				clusterid hh_num extension ord field parcel, stable 
	egen				plot_id = group(clusterid hh_num extension ord field parcel)
	lab var				plot_id "unique field and parcel identifier"
					
* merging in plant labor data
	merge		m:1 plot_id using "`export'/2014_as2ap1_2", generate(_as2ap12)
	*** 305 missing in master, 0 not matched from using 
	*** total of 4834 matched 
	*** we will impute the missing values later

	drop _as2ap12
	
* merging in harvest labor data
	merge		m:1 plot_id using "`export'/2014_as2ap1_3", generate(_as2ap13)
	*** 305 missing in master, 0 not matched from using 
	*** presumably those which did not match will have issues matching will full file, also 
	*** total of 4834 matched 
	*** we will impute the missing values later

	drop _as2ap13 
	
* **********************************************************************
* 4 - end matter, clean up to save
* **********************************************************************


	compress
	describe
	summarize

* save file
		customsave , idvar(plot_id) filename("2014_as2ap1_f") ///
			path("`export'") dofile(2014_AS2AP1_3) user($user)

* close the log
	log	close

/* END */
