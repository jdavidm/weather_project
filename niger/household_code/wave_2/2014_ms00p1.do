* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Edited by: jdm
* Last edit: 22 October 2020 
* Stata v.16

* does
	* identifies regional elements, for use in price data contruction 
	* merges in household sampling weights
	* outputs clean data file ready for combination with wave 2 data

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
	log 	using 	"`logout'/2014_ms00p1", append

	
* **********************************************************************
* 1 - load data and merge in household weights
* **********************************************************************

* import the first relevant data file
	use				"`root'/ECVMA2_MS00P1", clear

	merge			1:1 GRAPPE MENAGE EXTENSION using "`root'/ECVMA2014_P1P2_ConsoMen"
	*** all matched
	
* rename variables
	rename			zae aez
	lab var			aez "Agro-ecological zone"
	rename			hhweight pw
	lab var			pw "Household weight"
	
	drop			_merge	
	
	
* **********************************************************************
* 2 - rename and identify regional variables
* **********************************************************************

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
	rename 			MS00Q11 dept
	label 			var dept "department"
	rename 			MS00Q12 canton
	label 			var canton "canton/commune"
	rename 		    MS00Q14 zd 
	label 			var zd "zd number" 

		
* **********************************************************************
* 3 - end matter, clean up to save
* **********************************************************************

	keep 			hhid_y2 hid clusterid hh_num hh_num1 extension ///
						region dept canton zd aez pw
	isid 			hhid_y2
	
	sort			hhid_y2 clusterid hh_num extension	
	
	label var 		hhid_y2 "unique id - match w2 with weather"
	label var		hid "unique id - match w2 with w1 (no extension)"
	label var 		hh_num1 "household id - string changed, not unique"
	
	compress
	describe
	summarize

* save file
	customsave , idvar(hhid_y2) filename("2014_ms00p1.dta") ///
		path("`export'") dofile(2014_ms00p1) user($user)

* close the log
	log		close

/* END */
