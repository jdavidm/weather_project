* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Niger, WAVE 2 (2014), POST PLANTING, AG AS2BP1
	* examines seed use - will not use as appropriate question not asked
	* outputs clean data file ready for combination with wave 2 plot data

* assumes
	* customsave.ado
	
* TO DO:
	* done
	* do not use this file in compilation - not necessary 
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		root	=	"$data/household_data/niger/wave_2/raw"
	loc		export	=	"$data/household_data/niger/wave_2/refined"
	loc		logout	=	"$data/household_data/niger/logs"

* open log	
	log 	using 	"`logout'/2014_pp_as2bp1", append
	
* **********************************************************************
* 1 - determine pesticide and herbicide use 
* **********************************************************************
		
* import the first relevant data file
	use				"`root'/ECVMA2_AS2BP1", clear 	
	
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
	rename 			AS01BQ00 ord 
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
	rename 			AS02BQ04 cultivated
	label 			var cultivated "plot (parcel) cultivated"
* drop if not cultivated
	keep 			if cultivated == 1
	*** 197 observations dropped

* **********************************************************************
* 2 - determine seed use
* **********************************************************************

* will not be able to determine seed use - based on questions asked
* two questions asked about seed :
	* (1) what type of seed did you use?
	* (2) how did you get the seed? 
	
* examine (1) and (2) 
* (1) type of seed use
	tab  			AS02BQ09 
	rename 			AS02BQ09 seedtype
	*** 88.75 percent is local
	*** 5.56 percent is unspecified
	*** 1.94 percent is improved
	*** 3.72 is mixed 
	tab 			AS02BQ10
	rename 			AS02BQ10 seedsource
	*** mix across sources for seed
	*** largest is own production 65.31 percent, followed by local market 23.40 percent

* **********************************************************************
* 3 - end matter, clean up to save
* **********************************************************************

	keep 			clusterid hh_num extension ord field parcel seedtype seedsource 

	
* create unique household-plot identifier
	isid				clusterid hh_num extension ord field parcel
	sort				clusterid hh_num extension ord field parcel
	egen				plot_id = group(clusterid hh_num extension ord field parcel)
	lab var				plot_id "unique field and parcel identifier"

	compress
	describe
	summarize

* save file
		customsave , idvar(plot_id) filename("2014_pp_as2bp1.dta") ///
			path("`export'") dofile(2014_AS2BP1) user($user)

* close the log
	log	close

/* END */