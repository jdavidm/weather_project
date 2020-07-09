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
	* all of it

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		root  	= 	"$data/merged_data/tanzania"
	loc		key		=	"$data/household_data/tanzania/wave_3/refined"
	loc		export 	= 	"$data/regression_data/tanzania"
	loc		logout 	= 	"$data/merged_data/tanzania/logs"

* open log	
	*log 	using 		"`logout'/tza_append_built", append

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

	drop if mover2010 == 1
	*** 713 observations dropped
	drop if mover2012 == 1
	*** 760 observations 
	
	count
	*** 5790 observations 
	
	
order y1_hhid y2_hhid y3_hhid year
sort y1_hhid y2_hhid y3_hhid
sort y1_hhid year
egen hhid = group (y1_hhid y2_hhid y3_hhid)
distinct
count
duplicates drop
drop if tf_hrv == .

replace y1_hhid = "0" if y1_hhid == ""
replace y2_hhid = "0" if y2_hhid == ""
replace y3_hhid = "0" if y3_hhid == ""
egen hhid = group (y1_hhid y2_hhid y3_hhid)
distinct hhid
duplicates drop
drop dup
duplicates tag hhid, generate(dup)
tab dup

* order variables
	order		country dtype region district urban ta strata cluster ///
				ea_id lpid lp_id case_id y2_hhid y3_hhid hhweight
	
* save file
	qui: compress
	customsave 	, idvarname(case_id) filename("mwi_lp.dta") ///
		path("`export'") dofile(mwi_append_built) user($user)

* **********************************************************************
* 4 - append all Malawi data
* **********************************************************************
	
* import the cross section file
	use 		"`export'/mwi_cx.dta", clear

* append the two panel files
	append		using "`export'/mwi_sp.dta", force	
	append		using "`export'/mwi_lp.dta", force	

* order variables
	order		country dtype region district urban ta strata cluster ///
				ea_id case_id spid- y3_hhid hhweight	
* save file
	qui: compress
	customsave 	, idvarname(case_id) filename("mwi_complete.dta") ///
		path("`export'") dofile(mwi_append_built) user($user)

* close the log
	log	close

/* END */