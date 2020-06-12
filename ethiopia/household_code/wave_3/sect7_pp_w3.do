* Project: WB Weather
* Created on: June 2020
* Created by: McG
* Stata v.16

* does
	* cleans Ethiopia household variables, wave 3 PP sec7
	* seems to roughly correspong to Malawi ag-modF and ag-modL
	* post planting fertilizer info and lots of misc info
	* hierarchy: holder > parcel > field > crop

* assumes
	* customsave.ado

* TO DO:
	* make sure this isn't the fertilizer info that we need
	
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root = "$data/household_data/ethiopia/wave_3/raw"
	loc export = "$data/household_data/ethiopia/wave_3/refined"
	loc logout = "$data/household_data/ethiopia/logs"

* open log
	log using "`logout'/wv3_PPSEC7", append


* **********************************************************************
* 1 - preparing ESS (Wave 3) - Post Planting Section 7
* **********************************************************************

* load data
	use 		"`root'/sect7_pp_w3.dta", clear

* dropping duplicates
	duplicates drop

* check unique identifier
	describe
	sort 		holder_id ea_id
	isid 		holder_id ea_id, missok
	isid		holder_id

* drop observations with a missing holer_id/ea_id
	summarize 	if missing(holder_id,ea_id)
	drop 		if missing(holder_id,ea_id)
	*** 0 obs dropped
	
	isid 		holder_id

* i'm not really seeing much in this module of use to us.
* it's mostly about specific fertilizer use and other miscellaneous items 
* such as oxen use, credit, crop insurance, extension programs


* ***********************************************************************
* 2 - cleaning and keeping
* ***********************************************************************

* renaming some variables of interest
	rename 		household_id hhid
	rename 		household_id2 hhid2
	rename 		saq01 region
	rename 		saq02 district
	label var 	district "District Code"
	rename 		saq03 ward	

* restrict to variables of interest
	keep  		holder_id- pp_saq07
	order 		holder_id- pp_saq07

* final preparations to export
	isid 		holder_id
	compress
	describe
	summarize 
	sort 		holder_id
	customsave , idvar(holder_id) filename(PP_SEC7.dta) path("`export'") ///
		dofile(PP_SEC7) user($user)

* close the log
	log	close