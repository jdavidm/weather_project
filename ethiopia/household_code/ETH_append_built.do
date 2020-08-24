* Project: WB Weather
* Created on: Aug 2020
* Created by: mcg
* Stata v.16

* does
	* reads in merged data sets
	* appends merged data sets
	* outputs appended ethiopia panel with all three waves


* assumes
	* all ethiopia data has been cleaned and merged with rainfall
	* customsave.ado
	* xfill.ado

* TO DO:
	* complete

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		root 	= 	"$data/merged_data/ethiopia"
	loc		export 	= 	"$data/regression_data/ethiopia"
	loc		logout 	= 	"$data/merged_data/ethiopia/logs"

* open log	
	cap log close
	log 	using 		"`logout'/eth_append_build", append
	
	
* **********************************************************************
* 1 - append data
* **********************************************************************

* import wave 1 dataset
	use 		"`root'/wave_1/essy1_merged.dta", clear

* append wave 2 dataset
	append		using "`root'/wave_2/essy2_merged.dta", force
	
* append wave 3 dataset
	append		using "`root'/wave_3/essy3_merged", force	
	
* check the number of observations again
	count
	*** 7312 observations 
	count if 		year == 2011
	*** wave 1 has 1694
	count if 		year == 2013
	*** wave 2 has 2900
	count if 		year == 2015
	*** wave 3 has 2718
	
	gen				pl_id = household_id if year == 2011
	replace			pl_id = household_id2 if year == 2013 | year == 2015
	lab var			pl_id "panel household id/hhid"
	*** important to note: pl_id is therefore not unique without the year
	*** is this the right approach?
	
	gen				country = "ethiopia"
	lab var			country "Country"

	gen				dtype = "lp"
	lab var			dtype "Data type"
	
	isid			pl_id year
	
* order variables
	order			country dtype region zone woreda ea ///
						 year
						 
* label household variables	
	lab var			region "Region"
	lab var			zone "Zone"	
	lab var			woreda "Woreda"
	lab var			ea "Enumeration area"
	
	
* **********************************************************************
* 4 - End matter
* **********************************************************************

* create household, country, and data identifiers
	egen			uid = seq()
	lab var			uid "unique id"
	
* order variables
	order			uid pl_id
	
* save file
	qui: compress
	customsave 	, idvarname(uid) filename("eth_complete.dta") ///
		path("`export'") dofile(eth_append_built) user($user)

* close the log
	log	close

/* END */