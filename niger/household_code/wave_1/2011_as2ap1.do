* Project: WB Weather
* Created on: August 2020
* Created by: ek
* Stata v.16

* does
	* reads in Niger, WAVE 1 (2011),POST PLANTING (first passage), ecvmaas1_p1_en
	* creates binaries for pesticide and herbicide use
	* creates binaries and kg for fertilizer use
	* cleans labor post planting - prep labor 
	* combines all labor files in Niger for combination with wave 1 plot data (harvest, planting)
	* outputs clean data file ready for combination with wave 1 plot data

* assumes
	* cleaned planting and harvest labor in 2011_as2ap2
	* customsave.ado
	* mdesc.ado
	
* TO DO:
	* complete
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		root	=		"$data/household_data/niger/wave_1/raw"
	loc		export	=		"$data/household_data/niger/wave_1/refined"
	loc		logout	= 		"$data/household_data/niger/logs"

* open log
	cap 	log 	close
	log 	using	"`logout'/2011_as2ap1_1", append

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
	rename 			as02aq04 cultivated
	label 			var cultivated "plot cultivated"

* drop if not cultivated
	keep 			if cultivated == 1
	*** 490 observations deleted
	
* **********************************************************************
* 2 - determine pesticide and herbicide use - binaries 
* **********************************************************************

* binary for pesticide use
	rename			as02aq15 pest_any
	lab var			pest_any "=1 if any pesticide was used"
	replace			pest_any = 0 if pest_any == 2
	replace 		pest_any = 1 if pest_any == 1
	tab				pest_any
	*** 6 percent use pesticide 
	*** pesticide == insecticide
	*** question asked about insecticide - in dta file downloaded, designated at pesticide
	*** There is another pesticide question in wave 1 that asks if pesticide was used at the crop level


* binary for herbicide / fungicide - label as herbicide use
	generate		herb_any = . 
	replace			herb_any = 1 if as02aq17a > 0 & as02aq17a!= 99
	replace			herb_any = 0 if as02aq17a == . | as02aq17a == 99
	replace			herb_any = 1 if as02aq18a > 0 & as02aq18a != 99
	replace			herb_any = 0 if as02aq18a == . | as02aq18a == 99
	lab var			herb_any "=1 if any herbicide was used"
	tab 			herb_any 
	*** includes both question about herbicide (as02aq18a) and fungicide (as02aq17a) 
	
* check if any missing values
	count			if pest_any == . 
	count			if herb_any == .
	*** 0 pest and 106 herb missing, change these to "no"
	
* convert missing values to "no"
	replace			pest_any = 0 if pest_any == .
	replace			herb_any = 0 if herb_any == .
	
* **********************************************************************
* 3 - determine fertilizer use - binary and kg 
* **********************************************************************

* create fertilizer binary value
	egen 			fert_any = rsum(as02aq11a as02aq12a as02aq13a as02aq14a)
	replace			fert_any = 1 if fert_any > 0 
	tab 			fert_any, missing
	lab var			fert_any "=1 if any fertilizer was used"
	*** 805 use some sort of fertilizer (13.04%), none missing
	
* create conversion units - kgs, tiya
	gen 			kgconv = 1 
	gen 			tiyaconv = 3
	
* create amount of fertilizer value (kg)
	*** Units are measured in kilogram bags of various sizes, will convert to kg's where appropriate
	*** 99 appears to reflect a null or missing value
** UREA 
	replace as02aq11a = . if as02aq11a == 99 
	rename as02aq11b ureaunits
	rename as02aq11a ureaquant
	tab ureaunits
	gen kgurea = ureaquant*kgconv if ureaunits == 1
	replace kgurea = ureaquant*tiyaconv if ureaunits == 6
	replace kgurea = ureaquant*5 if ureaunits == 2
	replace kgurea = ureaquant*10 if ureaunits == 3
	replace kgurea = ureaquant*25 if ureaunits == 4
	replace kgurea = ureaquant*50 if ureaunits == 5
	replace kgurea = . if ureaunits == 8
	replace kgurea = . if ureaunits == 7
	tab kgurea 
** DAP
	replace as02aq12a = . if as02aq12a == 99 
	rename as02aq12b dapunits
	rename as02aq12a dapquant
	tab dapunits
	gen kgdap = dapquant*kgconv if dapunits == 1
	replace kgdap = dapquant*tiyaconv if dapunits == 6
	replace kgdap = dapquant*5 if dapunits == 2
	replace kgdap = dapquant*10 if dapunits == 3
	replace kgdap = dapquant*25 if dapunits == 4
	replace kgdap = dapquant*50 if dapunits == 5
	replace kgdap = . if dapunits == 7
	tab kgdap 
** NPK
	replace as02aq13a = . if as02aq13a == 99 
	rename as02aq13b npkunits
	rename as02aq13a npkquant
	tab npkunits
	gen npkkg = npkquant*kgconv if npkunits == 1
	replace npkkg = npkquant*tiyaconv if npkunits == 6
	replace npkkg = npkquant*5 if npkunits == 2
	replace npkkg = npkquant*10 if npkunits == 3
	replace npkkg = npkquant*25 if npkunits == 4
	replace npkkg = npkquant*50 if npkunits == 5
	replace npkkg = . if npkunits == 7
	replace npkkg = . if npkunits == 8
	tab npkkg 
** BLEND 
	rename as02aq14b blendunits
	rename as02aq14a blendquant
	tab blendunits
	replace blendquant = . if blendquant == 99 
	gen blendkg = blendquant*kgconv if blendunits == 1
	replace blendkg = blendquant*tiyaconv if blendunits == 4
	replace blendkg = blendquant*5 if blendunits == 2
	replace blendkg = blendquant*50 if blendunits == 3
	replace blendkg = . if blendunits == 5
	tab blendkg 

*total use 
	egen fert_use = rsum(kgurea kgdap npkkg blendkg)
	count  if fert_use != . 
	count  if fert_use == . 
	
* summarize fertilizer
	sum				fert_use, detail
	*** median - 0 , mean - 9.786, max - 2750

* replace any +3 s.d. away from median as missing
	replace			fert_use = . if fert_use > `r(p50)'+(3*`r(sd)')
	*** replaced 51 values, max is now 250 
	
* impute missing values
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed fert_use // identify fert_use as the variable being imputed
	sort			clusterid hh_num ord field parcel, stable // sort to ensure reproducability of results
	mi impute 		pmm fert_use i.clusterid, add(1) rseed(245780) ///
						noisily dots force knn(5) bootstrap
	mi 				unset
	
* how did the imputation go?
	tab				mi_miss
	tabstat			fert_use fert_use_1_, by(mi_miss) ///
						statistics(n mean min max) columns(statistics) ///
						longstub format(%9.3g) 
	replace			fert_use = fert_use_1_
	lab var			fert_use "fertilizer use (kg), imputed"
	drop			fert_use_1_
	*** imputed 51 values out of 6174 total observations	
	
* check for missing values
	mdesc fert_use
	*** 6174 total values
	*** 0 missing values 	
	
* **********************************************************************
* 4 - determine labor allocation 
* **********************************************************************

* per Palacios-Lopez et al. (2017) in Food Policy, we cap labor per person per activity
* 7 days * 13 weeks = 91 days for land prep and planting
* 7 days * 26 weeks = 182 days for weeding and other non-harvest activities
* 7 days * 13 weeks = 91 days for harvesting
* we will also exclude child labor_days
* will not disaggregate gender / age - pool together, as with other rounds 
* in line with others, will deal with each activity seperately

* create household member labor 
		*** as02aq(20-25)a identified HH ID of laborer 
		*** as02aq(20-25)b identifies number of days that person worked 

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
	replace			hired_men = 0 if as02aq27a != 1
	replace			hired_men = 0 if as02aq27b == 99
	replace			hired_men = 0 if as02aq27b == 999
	replace 		hired_men = 0 if as02aq27a == .  

	gen				hired_women = .
	replace			hired_women = as02aq27c if as02aq27a == 1
	replace			hired_women = 0 if as02aq27a != 1
	replace 		hired_women = 0 if as02aq27c == 99
	replace			hired_women = 0 if as02aq27c == 999
	replace 		hired_women = 0 if as02aq27a == .  
	
	*** we do not include child labor days
	
* Mutual labor
	*** mutual labor days from other households. The label of the mutual labor variable has been translated as "Did you use any manual labor on the parcel" but a direct translation in google translate gives a translation of mutual labor.


	tab 			as02aq26a
	***  received mutual labor,  did not
	
	gen 			mutual_men = .
	replace			mutual_men = as02aq26b if as02aq26a == 1
	replace			mutual_men = 0 if as02aq26a != 1
	replace			mutual_men = 0 if as02aq26b == 99
	replace			mutual_men = 0 if as02aq26b == 999
	replace 		mutual_men = 0 if as02aq26a == . 

	gen 			mutual_women = .
	replace			mutual_women = as02aq26c if as02aq26a == 1
	replace			mutual_women = 0 if as02aq26a != 1
	replace			mutual_women = 0 if as02aq26c == 99
	replace			mutual_women = 0 if as02aq26c == 999
	replace			mutual_women = 0 if as02aq26a == . 

	*** we do not include child labor days
	
* **********************************************************************
* 5 - impute labor outliers
* **********************************************************************
	
* summarize household individual labor for land prep to look for outliers
	sum				hh_1 hh_2 hh_3 hh_4 hh_5 hh_6 hired_men hired_women mutual_men mutual_women
	*** hh_1, hh_2, hh_3, hh_4, hh_5, hh_6 are all less than the minimum (91 days)
	*** only hired_men (124) is larger than the minimum and hired men is not disaggregated into the number of people hired and our labor caps are per person so we leave this
	
	
* generate local for variables that contain outliers
	loc				labor 	hh_1 hh_2 hh_3 hh_4 hh_5 hh_6 hired_men hired_women mutual_men mutual_women

	
* replace zero to missing, missing to zero, and outliers to missing
	foreach var of loc labor {
	mvdecode 		`var', mv(0)
	mvencode		`var', mv(0)
    replace			`var' = . if `var' > 90
	}
	*** 4 outliers changed to missing

* impute missing values (only need to do one variable - set new local)
	loc 			laborimp hh_2 hired_men
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
	sum				hh_2_1_ hired_men_1_ hh_2_2_ hired_men_2_
	
	replace 		hh_2 = hh_2_1_
	replace 		hired_men = hired_men_2_ 

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
	*** without free labor: average = 11.07, max = 540
		
	
* **********************************************************************
* 6 - combine planting and harvest labor 
* **********************************************************************
 
	keep 			clusterid hh_num ord field parcel pest_any ///
					fert_any fert_use herb_any prep_labor prep_labor_all
	
* create unique household-plot identifier
	isid				clusterid hh_num ord field parcel
	sort				clusterid hh_num ord field parcel, stable 
	egen				plot_id = group(clusterid hh_num ord field parcel)
	lab var				plot_id "unique field and parcel identifier"
	
					
* merging in plant labor data
	merge		m:1 plot_id using "`export'/2011_as2ap2", generate(_as2ap2)
	*** 0 missing in master, 28 not matched from using 
	*** presumably those which did not match will have issues matching will full file, also 
	*** total of 6174 matched 
	*** we will impute the missing values later

	drop _as2ap2
	
	
* **********************************************************************
* 7 - end matter, clean up to save
* **********************************************************************
	
* create unique household-plot identifier
	isid				plot_id

	compress
	describe
	summarize

* save file
		customsave , idvar(plot_id) filename("2011_as2ap1.dta") ///
			path("`export'") dofile(2011_AS2AP1) user($user)

* close the log
	log	close

/* END */