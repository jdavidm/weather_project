* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Niger, WAVE 2 (2014), POST PLANTING, AG AS2AP1
	* creates binaries for pesticide and herbicide use
	* outputs clean data file ready for combination with wave 2 plot data

* assumes
	* customsave.ado
	* mdesc.ado
	
* TO DO:
	* complete
	* later:
		*** combine with as2ap1_2 and as2ap1_3 so that files are file based not variable based
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		root	=	"$data/household_data/niger/wave_2/raw"
	loc		export	=	"$data/household_data/niger/wave_2/refined"
	loc		logout	=	"$data/household_data/niger/logs"

* open log	
	log 	using 	"`logout'/2014_pp_as2ap1", append
	
* **********************************************************************
* 1 - determine pesticide and herbicide use 
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
	label 			var cultivated "plot (parcel) cultivated"
* drop if not cultivated
	keep 			if cultivated == 1
	*** 301 observations dropped

* **********************************************************************
* 2 - determine pesticide and herbicide use - binaries 
* **********************************************************************

* binary for pesticide use
	rename			AS02AQ13A pest_any
	lab var			pest_any "=1 if any pesticide was used"
	replace			pest_any = 0 if pest_any == 2
	replace 		pest_any = . if pest_any == 9
	tab				pest_any
	*** 341 - 6.64 percent use pesticide 
	*** pesticide == insecticide
	*** question asked about insecticide - in dta file downloaded, designated at pesticide
	*** wondering if there is another pesticide question - have not yet found 

* binary for herbicide / fungicide - label as herbicide use
	generate		herb_any = . 
	replace			herb_any = 1 if AS02AQ14A == 1
	replace			herb_any = 0 if AS02AQ14A == 2
	replace			herb_any = 1 if AS02AQ15A == 1
	replace			herb_any = 0 if AS02AQ15A == 2
	lab var			herb_any "=1 if any herbicide was used"
	tab 			herb_any 
	*** includes both question about herbicide (AS02AQ15A) and fungicide (AS02AQ14A) 
	
* check if any missing values
	count			if pest_any == . 
	count			if herb_any == .
	*** 5 pest and 5 herb missing, change these to "no"
	
* convert missing values to "no"
	replace			pest_any = 0 if pest_any == .
	replace			herb_any = 0 if herb_any == .
	
* **********************************************************************
* 3 - end matter, clean up to save
* **********************************************************************

	keep 			clusterid hh_num extension ord field parcel pest_any herb_any 
	
* create unique household-plot identifier
	isid				clusterid hh_num extension ord field parcel
	sort				clusterid hh_num extension ord field parcel
	egen				plot_id = group(clusterid hh_num extension ord field parcel)
	lab var				plot_id "unique field and parcel identifier"

	compress
	describe
	summarize

* save file
		customsave , idvar(plot_id) filename("2014_pp_as2ap1.dta") ///
			path("`export'") dofile(2014_AS2AP1_1) user($user)

* close the log
	log	close

/* END */