* Project: WB Weather
* Created on: June 2020
* Created by: McG
* Stata v.16

* does
	* cleans Ethiopia household variables, wave 3 PH sec12
	* seems to roughly correspong to Malawi ag-modD and ag-modK
	* contains harvest and sales info on fruit/nuts/root crops
	* hierarchy: holder > parcel > field > crop

* assumes
	* customsave.ado
	
* TO DO:
	* must find a unique ob identifier
	* like in pp_sect3, ph_sect9, & ph_sect11, many observtions from master are not being matched
	* must finish building out data cleaning - see wave 1 maybe	
	
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root = "$data/household_data/ethiopia/wave_3/raw"
	loc export = "$data/household_data/ethiopia/wave_3/refined"
	loc logout = "$data/household_data/ethiopia/logs"

* open log
	log using "`logout'/wv3_PHSEC12", append


* **********************************************************************
* 1 - preparing ESS (Wave 3) - Post Harvest Section 12
* **********************************************************************

* load data
	use "`root'/sect12_ph_w3.dta", clear

* dropping duplicates
	duplicates drop
	
* drop trees and other perennial crops
	drop if crop_code == 65 // guava, for example

* attempting to generate unique identifier
	describe
	sort holder_id crop_code
* 	isid holder_id crop_code, missok
	*** these variables do not uniquely identify observations

* creating unique region identifier
	egen 		district_id = group( saq01 saq02)
	label var 	district_id "Unique region identifier"
	distinct	saq01 saq02, joint
	*** 66 distinct districts
	*** three fewer than in pp sect2, pp sect3, & ph_sect9

* check for missing crop codes
	tab			crop_code, missing	
	*** this is supposed to be fruits and nuts 
	*** but still a few obs w/ maize and sorghum and the like
	*** like in Sect9, no crop codes are missing

* create conversion key 
	generate 	conv_id = string(crop_code) + " " + string(ph_s12q0b)
	merge 		m:1 conv_id using "`root'/Crop_CF_Wave3_use.dta"
	*** 5,146 not matched from master

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
	customsave , idvar(holder_id) filename(PP_SEC12.dta) path("`export'") ///
		dofile(PP_SEC12) user($user)

* close the log
	log	close	