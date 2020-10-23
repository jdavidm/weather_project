* Project: WB Weather
* Created on: July 2020
* Created by: ek
* Stata v.16

* does
	* reads in merged data sets
	* appends both complete data set (W1-W2)
	* outputs Niger data sets for analysis

* assumes
	* all Niger data has been cleaned and merged with rainfall
	* customsave.ado

* TO DO:
	* complete
	
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		root 	= 	"$data/merged_data/niger"
	loc		export 	= 	"$data/regression_data/niger"
	loc		logout 	= 	"$data/merged_data/niger/logs"

* open log	
	cap 	log 	close 
	log 	using 	"`logout'/ngr_append_built", append

	
* **********************************************************************
* 1 - merge first three waves of Niger household data
* **********************************************************************

* using merge rather than append
* import wave 1 niger
	use 			"`root'/wave_1/ecvmay1_merged", clear
	
* append wave 2 file
	append			using "`root'/wave_2/ecvmay2_merged", force	
		
	
* check the number of observations again
	count
	*** 3,952 observations 
	count if 		year == 2011
	*** wave 1 has 2,233
	count if 		year == 2014
	*** wave 2 has  1,729

* create household panel id
	sort			hid year
	egen			ngr_id = group(hid)
	lab var			ngr_id "Niger panel household id"
	
	drop			if extension == "1" | extension == "2"
	*** 39 observations deleted

	gen				country = "niger"
	lab var			country "Country"

	gen				dtype = "lp"
	lab var			dtype "Data type"
	
	isid			ngr_id year
	
* order variables
	drop			extension region dept canton enumeration clusterid
	
	order			country dtype hhid pw aez year 
	
	
* **********************************************************************
* 4 - End matter
* **********************************************************************

* create household, country, and data identifiers
	sort			ngr_id year
	egen			uid = seq()
	lab var			uid "unique id"
	
* order variables
	order			uid ngr_id
	
* save file
	qui: compress
	customsave 	, idvarname(ngr_id) filename("ngr_complete.dta") ///
		path("`export'") dofile(ngr_append_built) user($user)

* close the log
	log	close

/* END */

