* Project: WB Weather
* Created on: June 2020
* Created by: ek
* Stata v.16

* does
	* reads in Niger, WAVE 1 (2011),POST PLANTING (first passage), ecvmaas1_p1_en
	* cleans labor post planting - prep labor 
	* combines all labor files in Niger for combination with wave 1 plot data (harvest, planting)
	
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
	log 	using	"`logout'/2011_as2ap1_3", append

* **********************************************************************
* 1 - describing plot size - self-reported and GPS
* **********************************************************************
	
* import the first relevant data file
	use				"`root'/ecvmaas1_p1_en", clear
	
	rename 			passage visit
	label 			var visit "number of visit - wave number"
	rename			grappe clusterid
	label 			var clusterid "cluster number"
	rename			menage hh_num
	label 			var hh_num "household number - not unique id"
	rename 			as01qa ord 
	label 			var ord "number of order"
	*** note that ord is the id number
	rename 			as01q03 field 
	label 			var field "field number"
	rename 			as01q05 parcel 
	label 			var parcel "parcel number"
	*** cant find "extension" variable like they have in wave 2. This is a problem because in wave 2 we make a unique id based on clusterid, hhnumber, extension, order, field, and parcel to uniquely identify
	
* need to include clusterid, hhnumber, order, field, and parcel to uniquely identify
	describe
	sort 			clusterid hh_num ord field parcel
	isid 			clusterid hh_num ord field parcel
	
* determine cultivated plot
	rename 			as01q40 cultivated
	label 			var cultivated "plot cultivated"

* drop if not cultivated
	keep 			if cultivated == 1
	
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
* as02aq(20-25)a identified HH ID of laborer 
* as02aq(20-25)b identifies number of days that person worked 

* Land prep labor

	gen				hh_1 = as02aq20b
	replace			hh_1 = 0 if hh_1 == .
	replace			hh_1 = 0 if hh_1 == 99
	
	gen				hh_2 = as02aq21b
	replace			hh_2 = 0 if hh_2 == .
	replace			hh_2 = 0 if hh_2 == 99
	
	gen				hh_3 = as02aq22b
	replace			hh_3 = 0 if hh_3 == .
	replace			hh_3 = 0 if hh_3 == 99
	
	gen				hh_4 = as02aq23b
	replace			hh_4 = 0 if hh_4 == .
	replace			hh_4 = 0 if hh_4 == 99
	
	gen				hh_5 = as02aq24b
	replace			hh_5 = 0 if hh_5 == .
	replace			hh_5 = 0 if hh_5 == 99
	
	gen				hh_6 = as02aq25b
	replace			hh_6 = 0 if hh_6 == .
	replace			hh_6 = 0 if hh_6 == 99
	
	*** this calculation is for up to 6 members of the household that were laborers
	*** per the survey, these are laborers from the main rainy season
	*** includes labor for clearing, burning, fertilizing - would here include combination of land prep (91 day max)
	*** does not include harvest labor or planting labor 
	*** we are treating the entry 99/999 as a code for missing
	
* hired labor days   

	tab 			as02aq27a
	*** 679 hired labor, 5692 did not
	
	gen				hired_men = .
	replace			hired_men = as02aq27b if as02aq27a == 1
	replace			hired_men = 0 if as02aq27a == 2
	replace			hired_men = 0 if as02aq27a == 3 
	replace			hired_men = 0 if as02aq27b == 99
	replace			hired_men = 0 if as02aq27b == 999
	replace 		hired_men = 0 if as02aq27a == .  

	gen				hired_women = .
	replace			hired_women = as02aq27c if as02aq27a == 1
	replace			hired_women = 0 if as02aq27a == 2
	replace			hired_women = 0 if as02aq27a == 3 
	replace 		hired_women = 0 if as02aq27c == 99
	replace			hired_women = 0 if as02aq27c == 999
	replace 		hired_women = 0 if as02aq27a == .  
	
	*** we do not include child labor days
	
* mutual labor days from other households. The label of the mutual labor variable has been translated as "Did you use any manual labor on the parcel" but a direct translation in google translate gives a translation of mutual labor.


	tab 			as02aq26a
	***  received mutual labor,  did not
	
	gen 			mutual_men = .
	replace			mutual_men = as02aq26b if as02aq26a == 1
	replace			mutual_men = 0 if as02aq26a == 2
	replace			mutual_men = 0 if as02aq26a == 3
	replace			mutual_men = 0 if as02aq26b == 99
	replace			mutual_men = 0 if as02aq26b == 999
	replace 		mutual_men = 0 if as02aq26a == . 

	gen 			mutual_women = .
	replace			mutual_women = as02aq26c if as02aq26a == 1
	replace			mutual_women = 0 if as02aq26a == 2
	replace			mutual_women = 0 if as02aq26a == 3
	replace			mutual_women = 0 if as02aq26c == 99
	replace			mutual_women = 0 if as02aq26c == 999
	replace			mutual_women = 0 if as02aq26a == . 

	*** we do not include child labor days
	
* **********************************************************************
* 3 - impute labor outliers
* **********************************************************************
	
* summarize household individual labor for land prep to look for outliers
	sum				hh_1 hh_2 hh_3 hh_4 hh_5 hh_6 hired_men hired_women mutual_men mutual_women
	*** hh_1, hh_2, hh_3, hh_4, hh_5, hh_6, mutual_men, mutual_women, hired_women are all less than the minimum (91 days)
	*** only hired_men (124) is larger than the minimum
	
* generate local for variables that contain outliers
	loc				labor hired_men

* replace zero to missing, missing to zero, and outliers to missing
	foreach var of loc labor {
	    mvdecode 		`var', mv(0)
		mvencode		`var', mv(0)
	    replace			`var' = . if `var' > 90
	}
	*** 3 outliers changed to missing

* impute missing values (only need to do one variable - set new local)
	loc 			laborimp hired_men
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously


* impute each variable in local		
	foreach var of loc laborimp {
		mi register			imputed `var' // identify variable to be imputed
		sort				clusterid hh_num ord field parcel, stable 
		// sort to ensure reproducability of results
		mi impute 			pmm `var' i.clusterid, add(1) rseed(245780) ///
								noisily dots force knn(5) bootstrap
	}						
	mi 				unset	
	
* summarize imputed variables
	sum				hired_men_1_
	
	replace 		hired_men = hired_men_1_ 

* total labor days for prep
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
	*** with free labor: average = 11.4, max = 540
	*** without free labor: average = 11.1, max = 540
	
* **********************************************************************
* 3 - combine planting and harvest labor 
* **********************************************************************

	keep 			clusterid hh_num ord field parcel prep_labor prep_labor_all ///
					hh_prep_labor hired_prep_labor mutual_prep_labor 
	
	* create unique household-plot identifier
	isid				clusterid hh_num ord field parcel
	sort				clusterid hh_num ord field parcel, stable 
	egen				plot_id = group(clusterid hh_num ord field parcel)
	lab var				plot_id "unique field and parcel identifier"
					
* merging in plant labor data
	merge		m:1 plot_id using "`export'/2011_as2ap2_1", generate(_as2ap12)
	*** 242 missing in master, 0 not matched from using 
	*** total of 6202 matched 
	*** we will impute the missing values later

	drop _as2ap12
	
* merging in harvest labor data
	merge		m:1 plot_id using "`export'/2011_as2ap2_2", generate(_as2ap13)
	*** 242 missing in master, 0 not matched from using 
	*** presumably those which did not match will have issues matching will full file, also 
	*** total of 6202 matched 
	*** we will impute the missing values later

	drop _as2ap13 
	
* **********************************************************************
* 4 - end matter, clean up to save
* **********************************************************************


	compress
	describe
	summarize

* save file
		customsave , idvar(plot_id) filename("2011_as2ap1_f") ///
			path("`export'") dofile(2011_AS2AP1_3) user($user)

* close the log
	log	close

/* END */