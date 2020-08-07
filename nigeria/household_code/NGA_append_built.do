* Project: WB Weather
* Created on: July 2020
* Created by: ek
* Stata v.16

* does
	* reads in merged data sets
	* appends all three to form complete data set (W1-W3)
	* outputs Nigeria data sets for analysis

* assumes
	* all Nigeria data has been cleaned and merged with rainfall
	* customsave.ado

* TO DO:
	* complete
	
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		root 	= 	"$data/merged_data/nigeria"
	loc		export 	= 	"$data/regression_data/nigeria"
	loc		logout 	= 	"$data/merged_data/nigeria/logs"

* open log	
	cap 	log 	close 
	log 	using 	"`logout'/nga_append_built", append

	
* **********************************************************************
* 1 - merge first three waves of Nigeria household data
* **********************************************************************

* using merge rather than append
* import wave 1 nigeria
	
	use 			"`root'/wave_1/ghsy1_merged", clear
	*** at the moment I believe that all three waves of nigeria identify hh's the same
	
* append wave 2 file
	append			using "`root'/wave_2/ghsy2_merged", force	
	
* append wave 3 file 
	append			using "`root'/wave_3/ghsy3_merged", force	
	
* check the number of observations again
	count
	*** 8384 observations 
	count if 		year == 2010
	*** wave 1 has 2833
	count if 		year == 2012
	*** wave 2 has 2768
	count if 		year == 2015
	*** wave 3 has 2783
	
	gen				pl_id = hhid
	lab var			pl_id "panel household id/hhid"

	gen				country = "nigeria"
	lab var			country "Country"

	gen				dtype = "lp"
	lab var			dtype "Data type"
	
	isid			hhid year
	
* order variables
	order			country dtype zone state lga sector ea ///
						 year
				
* label household variables	
	lab var			sector  "Sector"
	lab var			zone "Zone"	
	lab var			state "State"
	lab var 		lga "Local government area"
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
	customsave 	, idvarname(uid) filename("nga_complete.dta") ///
		path("`export'") dofile(nga_append_built) user($user)

* close the log
	log	close

/* END */

