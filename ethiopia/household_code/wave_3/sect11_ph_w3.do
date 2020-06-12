* Project: WB Weather
* Created on: June 2020
* Created by: McG
* Stata v.16

* does
	* cleans Ethiopia household variables, wave 3 PH sec11
	* seems to roughly correspong to Malawi ag-modI and ag-modO
	* contains crop sales data
	* hierarchy: holder > parcel > field > crop

* assumes
	* customsave.ado
	
* TO DO:
	* must find a unique ob identifier
	* like in pp_sect3 & pp_sect9, many observtions from master are not being matched
	* must finish building out data cleaning - see wave 1 maybe	
	
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root = "$data/household_data/ethiopia/wave_3/raw"
	loc export = "$data/household_data/ethiopia/wave_3/refined"
	loc logout = "$data/household_data/ethiopia/logs"

* open log
	log using "`logout'/wv3_PHSEC11", append


* **********************************************************************
* 1 - preparing ESS (Wave 3) - Post Harvest Section 11
* **********************************************************************

* build conversion id into conversion dataset
	clear
	use 		"`root'/Crop_CF_Wave3.dta"
	generate 	conv_id = string(crop_code) + " " + string(unit_cd)
	duplicates 	report
	duplicates drop
	duplicates 	report conv_id
	*** look at obs 67 & 68 - yet another weird problem =\

	save 		"`root'/Crop_CF_Wave3_use.dta", replace
	clear

* load data
	use 		"`root'/sect11_ph_w3.dta", clear

* dropping duplicates
	duplicates drop

* attempting to generate unique identifier
	describe
	sort 		holder_id crop_code
*	isid 		holder_id crop_code, missok
	*** these variables do not uniquely identify observations

* create conversion key 
	generate 	conv_id = string(crop_code) + " " + string(ph_s11q03_b)
	merge 		m:1 conv_id using "`root'/Crop_CF_Wave3_use.dta"
	*** 6,273 not matched from master

	tab 		_merge
	drop		if _merge == 2
	drop		_merge


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

*	Restrict to variables of interest
	keep  		holder_id- crop_code
	order 		holder_id- crop_code

* final preparations to export
*	isid 		// don't have one yet
	compress
	describe
	summarize 
	sort 		holder_id ea_id crop_code
	customsave , idvar(holder_id) filename(PP_SEC11.dta) path("`export'") ///
		dofile(PP_SEC11) user($user)

* close the log
	log	close	
	
