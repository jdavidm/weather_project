* Project: WB Weather
* Created on: June 2020
* Created by: ek
* Stata v.16

* does
	* reads in Niger, WAVE 1 (2011),POST PLANTING (first passage), ecvmaas1_p1_en
	* cleans pesticide and herbicide use
	* outputs clean data file ready for combination with wave 1 plot data

* assumes
	* customsave.ado

* TO DO:
	*done
	
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
	rename 			as01q40 cultivated
	label 			var cultivated "plot cultivated"

* drop if not cultivated
	keep 			if cultivated == 1
	*** 220 observations deleted
	
* **********************************************************************
* 2 - determine pesticide and herbicide use - binaries 
* **********************************************************************

* binary for pesticide use
	rename			as02aq15 pest_any
	lab var			pest_any "=1 if any pesticide was used"
	replace			pest_any = 0 if pest_any == 2
	tab				pest_any
	*** 376 - 5.90 percent use pesticide 
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
	*** 70 pest and 107 herb missing, change these to "no"
	
* convert missing values to "no"
	replace			pest_any = 0 if pest_any == .
	replace			herb_any = 0 if herb_any == .
	
* **********************************************************************
* 3 - end matter, clean up to save
* **********************************************************************

	keep 			clusterid hh_num ord field parcel pest_any herb_any 
	
* create unique household-plot identifier
	isid				clusterid hh_num ord field parcel
	sort				clusterid hh_num ord field parcel
	egen				plot_id = group(clusterid hh_num ord field parcel)
	lab var				plot_id "unique field and parcel identifier"

	compress
	describe
	summarize

* save file
		customsave , idvar(plot_id) filename("2011_pp_as2ap1.dta") ///
			path("`export'") dofile(2011_as2ap1_1) user($user)

* close the log
	log	close

/* END */