* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* identifies regional elements, for use in price data contruction 

* assumes
	* customsave.ado

* TO DO:
	* done 

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc 	root	= 	"$data/household_data/niger/wave_2/raw"
	loc 	export	= 	"$data/household_data/niger/wave_2/refined"
	loc 	logout	= 	"$data/household_data/niger/logs"

* open log
	cap		log 	close
	log 	using 	"`logout'/2014_MS00P1", append

	
* **********************************************************************
* 1 - rename and identify regional variables
* **********************************************************************

* import the first relevant data file
	use				"`root'/ECVMA2_MS00P1", clear
	
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
	
* identify and rename region specific variables 
	rename			MS00Q10 region
	label 			var region "region"
	rename 			MS00Q11 dept
	label 			var dept "department"
	rename 			MS00Q12 canton
	label 			var canton "canton/commune"
	rename 		    MS00Q14 zd 
	label 			var zd "zd number" 

	
* **********************************************************************
* 2 - end matter, clean up to save
* **********************************************************************

	keep 			clusterid hh_num extension region dept canton zd 
	isid 			clusterid hh_num extension 
	
	sort			clusterid hh_num extension
	egen			idvar = group(clusterid hh_num extension)
	lab var			idvar "unique identifier"
	
	compress
	describe
	summarize

* save file
	customsave , idvar(idvar) filename("2014_ms00p1.dta") ///
		path("`export'") dofile(2014_ms00p1) user($user)

* close the log
	log		close

/* END */
