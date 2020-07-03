* Project: WB Weather
* Created on: June 2020
* Created by: ek
* Stata v.16

* does
	* identifies regional elements
	* for use in price data contruction 
	* outputs clean data file ready for combination with wave 1 data

* assumes
	* customsave.ado

* TO DO:
	* done

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc 	root	= 	"$data/household_data/niger/wave_1/raw"
	loc 	export	= 	"$data/household_data/niger/wave_1/refined"
	loc 	logout	= 	"$data/household_data/niger/logs"

* open log
	cap 	log 	close
	log 	using 	"`logout'/2011_ms00p1", append

* **********************************************************************
* 1 - rename and identify regional variables
* **********************************************************************

* import the first relevant data file
	use				"`root'/ecvmasection00_p2_en", clear

* need to rename for English
	rename 			passage visit
	label 			var visit "number of visit"
	rename			grappe clusterid
	label 			var clusterid "cluster number"
	rename			menage hh_num
	label 			var hh_num "household number - not unique id"
	*** will need to do these in every file
	
* identify and rename region specific variables 
	rename			ms00q10 region
	label 			var region "region"
	rename 			ms00q11 dept
	label 			var dept "department"
	rename 			ms00q12 canton
	label 			var canton "canton/commune"
	*** have used enumeration zone instead of zd number which is not present in wave 1
	rename 		    ms00q14 enumeration
	label 			var enumeration "enumeration zone (instead of zd in wave 2)" 

* **********************************************************************
* 2 - end matter, clean up to save
* **********************************************************************

	keep 			clusterid hh_num region dept canton enumeration 
	isid 			clusterid hh_num 
	
	sort			clusterid hh_num
	egen			idvar = group(clusterid hh_num)
	lab var			idvar "unique identifier"
	
	compress
	describe
	summarize

* save file
	customsave , idvar(idvar) filename("2011_ms00p1.dta") ///
		path("`export'") dofile(2011_ms00p1) user($user)

* close the log
	log		close

/* END */
