* Project: WB Weather
* Created on: Aug 2020
* Created by: ek
* Stata v.16

* does
	* reads in merged data sets
	* appends all three to form complete data set (W1-W3)
	* outputs Uganda data sets for analysis

* assumes
	* all Uganda data has been cleaned and merged with rainfall
	* customsave.ado

* TO DO:
	* complete
	
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		root 	= 	"$data/merged_data/uganda"
	loc		export 	= 	"$data/regression_data/uganda"
	loc		logout 	= 	"$data/merged_data/uganda/logs"

* open log	
	cap 	log 	close 
	log 	using 	"`logout'/uga_append_built", append

	
* **********************************************************************
* 1 - append first three waves of Uganda household data
* **********************************************************************

* import wave 1 Uganda
	
	use 			"`root'/wave_1/unps1_merged", clear
	*** at the moment I believe that all three waves of nigeria identify hh's the same
	
* append wave 2 file
	append			using "`root'/wave_2/unps2_merged", force	
	
* append wave 3 file 
	append			using "`root'/wave_3/unps3_merged", force	
	
* check the number of observations again
	count
	*** 5252 observations 
	count if 		year == 2009
	*** wave 1 has 1704
	count if 		year == 2010
	*** wave 2 has 1741
	count if 		year == 2011
	*** wave 3 has 1807

* generate country and data types	
	gen				country = "uganda"
	lab var			country "Country"

	gen				dtype = "lp"
	lab var			dtype "Data type"

	isid			hhid year

* generate one variable for sampling weight
	gen				pw = wgt09wosplits  
	
	replace			pw = wgt10 if pw == .
	replace			pw = wgt11 if pw == .
	tab 			pw, missing
	drop			if pw == .
	lab var			pw "Household Sample Weight"

* drop variables
	drop			region district county subcounty parish ///
						wgt09wosplits season wgt10 wgt11
	
	order			country dtype hhid year aez pw
				
	
* **********************************************************************
* 4 - End matter
* **********************************************************************

* order variables
	order			hhid
	
* save file
	qui: compress
	customsave 	, idvarname(hhid) filename("uga_complete.dta") ///
		path("`export'") dofile(uga_append_built) user($user)

* close the log
	log	close

/* END */

