* Project: WB Weather
* Created on: June 2020
* Created by: jdm
* Edited by: alj
* Stata v.16

* does
	* reads in merged data sets
	* merges merged data sets (W1-W3)
	* appends merged data set (W4)
	* outputs Tanzania data sets for analysis

* assumes
	* all Tanzania data has been cleaned and merged with rainfall
	* customsave.ado
	* xfill.ado

* TO DO:
	* complete 
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		root  	= 	"$data/merged_data/tanzania"
	loc		key		=	"$data/household_data/tanzania/wave_3/refined"
	loc		export 	= 	"$data/regression_data/tanzania"
	loc		logout 	= 	"$data/merged_data/tanzania/logs"

* open log	
	log 	using 		"`logout'/tza_append_built", append

* **********************************************************************
* 1 - merge first three waves of Tanzania data
* **********************************************************************

* using merge rather than append
* households were differently designated in each year 
* need to merge households together into panel key and then reshape 

* import the panel key file
	use 		"`key'/panel_key", clear
	
* merge in wave 1 
* matching on y1_hhid - which identifies wave 1 respondents

	merge 		m:1 y1_hhid using "`root'/wave_1/npsy1_merged"
	*** 2101 matched
	*** 2909 not matched from master - for households in w2 and w3
	*** 104 not matched from using - only appear in w1 
	
	rename 		_merge _merge2008
	
* merge in wave 2
* matching on y2_hhid which identifies wave 2 respondents 

	merge 		m:1 y2_hhid using "`root'/wave_2/npsy2_merged"
	*** 2341 matched
	*** 2773 not matched from master - for households in w1 or w3
	*** 59 not matched from using - only appear in w2 
	
	rename 		_merge _merge2010 
	
* merge in wave 3
* matching on y3_hhid which identifies wave 2 respondents 

	merge 		m:1 y3_hhid using "`root'/wave_3/npsy3_merged"
	*** 2658 matched
	*** 2515 not matched from master - for households in w1 or w2
	*** 0 not matched from using - no households only in w3
	
	rename 		_merge _merge2012 
	
* **********************************************************************
* 2 - reshape and format 
* **********************************************************************

* per https://www.stata.com/support/faqs/data-management/problems-with-reshape/ 
* create local which will contain all variable names that you want to reshape 
	unab 		vars : *2008 
	local		stubs: subinstr local vars "2008" "", all
	
	reshape 	long `stubs', i(y1_hhid y2_hhid y3_hhid region district ward ea clusterid strataid) j(year)
	*** takes 90 seconds to run
	*** some issues with weight variable - because no observations for weight 2008 - clean up at end 
	
* need to do clean up
* drop duplicates
* drop if no harvest - missing information
* drop if movers 	
	
	count 
	*** starting with way too many observations - 15519

	duplicates 		drop
	*** 0 dropped 
	
	drop 			if tf_hrv == .
	* 8256 dropped 

	drop 			if mover2010 == 1
	*** 713 observations dropped
	drop 			if mover2012 == 1
	*** 760 observations 
	
	count
	*** 5790 observations 
	*** wave 1 has 1875 observations 
	*** wave 2 has 2116, but 315 movers = 1801 total
	*** wave 3 has 2658 but 565 movers = 2093 total
	*** should be a total of 5769 - 21 too many
	*** no good way to figure out what these 21 observations are - so going to include for now 

					
* **********************************************************************
* 4 - append wave 4 Tanzania 
* **********************************************************************
	
* wave 4 is all new households 
* append to bottom of waves 1 - 3 once reshaped 

	append		using "`root'/wave_4/npsy4_merged", force	


* organize and order 
	order 			y1_hhid y2_hhid y3_hhid y4_hhid year /// 
					region district ward ea clusterid strataid weight 
	drop			mover2010 mover2012

* create new unique hhid 
* need to first replace empty places - otherwise will create hhid = . 
	replace 		y1_hhid = "0" if y1_hhid == ""
	replace 		y2_hhid = "0" if y2_hhid == ""
	replace 		y3_hhid = "0" if y3_hhid == ""
	replace			y4_hhid = "0" if y4_hhid == ""
	egen hhid = group (y1_hhid y2_hhid y3_hhid y4_hhid)
	distinct hhid
	*** 7578 total observations, 4412 distinct 
	
* examine data 
	duplicates 		drop
	*** 0 dropped
	duplicates tag hhid, generate(dup)
	tab dup	
	*** nothing repeated more than 3 times - which would be appearing in wave 1, 2, 3
	*** 2504 appear only once, 1300 appear twice, 3774 appear three times 
	
* save file
	qui: compress
	customsave 	, idvarname(hhid) filename("tza_complete.dta") ///
		path("`export'") dofile(TZA_append_built) user($user)

* close the log
	log	close

/* END */