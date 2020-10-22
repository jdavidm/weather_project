* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Edited by: alj
* Last edit: 21 October 2020 
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

* build household identifier
* need to rename for English
	rename 			PASSAGE visit
	label 			var visit "number of visit"
	rename			GRAPPE clusterid
	label 			var clusterid "cluster number"
	rename			MENAGE hh_num
	label 			var hh_num "household number - not unique id"
	rename 			EXTENSION extension 
	label 			var extension "extension of household"
	
* create new household id for merging with weather 
	tostring		clusterid, replace 
	gen str2 		hh_num1 = string(hh_num,"%02.0f")
	tostring		extension, replace
	egen			hhid_y2 = concat( clusterid hh_num1 extension  )
	destring		hhid_y2, replace
	order			hhid_y2 clusterid hh_num hh_num1 extension 
	
* create new household id for merging with year 1 
	egen			hid = concat( clusterid hh_num1  )
	destring		hid, replace
	order			hhid_y2 hid clusterid hh_num hh_num1 

* need to destring cluster again for matching with other files 	
	destring 		clusterid, replace
	
* identify and rename region specific variables 
	rename			MS00Q10 region
	label 			var region "region"
	rename 			MS00Q11 dept
	label 			var dept "department"
	rename 			MS00Q12 canton
	label 			var canton "canton/commune"
	rename 		    MS00Q14 zd 
	label 			var zd "zd number" 

	*destring 		grappe, gen(clusterid) float
	*destring		ext, gen(extension) float
	*destring		menage, gen(hh_num) float
	
* **********************************************************************
* 2 - end matter, clean up to save
* **********************************************************************

	keep 			hhid_y2 hid clusterid hh_num hh_num1 extension region dept canton zd 
	isid 			hhid_y2
	
	sort			hhid_y2 clusterid hh_num extension
	lab var			hhid_y2 "unique identifier"
	
	compress
	describe
	summarize

* save file
	customsave , idvar(hhid_y2) filename("2014_ms00p1.dta") ///
		path("`export'") dofile(2014_ms00p1) user($user)

* close the log
	log		close

/* END */
