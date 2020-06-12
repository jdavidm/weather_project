* Project: WB Weather
* Created on: June 2020
* Created by: McG
* Stata v.16

* does
	* cleans Ethiopia household variables, wave 3 PH sec9
	* seems to roughly correspong to Malawi ag-modG and ag-modM
	* contains harvest weights and other info (dates, etc.)
	* hierarchy: holder > parcel > field > crop

* assumes
	* customsave.ado
	* distinct.ado
	
* TO DO:
	* like in pp_sect3, many observtions from master are not being matched
	* must finish building out data cleaning - see wave 1 maybe
	
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root = "$data/household_data/ethiopia/wave_3/raw"
	loc export = "$data/household_data/ethiopia/wave_3/refined"
	loc logout = "$data/household_data/ethiopia/logs"

* open log
	log using "`logout'/wv3_PHSEC9", append


* **********************************************************************
* 1 - preparing ESS (Wave 3) - Post Harvest Section 9
* **********************************************************************

* build conversion id into conversion dataset
	clear
	use 		"`root'/Crop_CF_Wave3.dta"
	generate 	conv_id = string(crop_code) + " " + string(unit_cd)
	duplicates 	report
	duplicates drop
	duplicates 	report conv_id
	save 		"`root'/Crop_CF_Wave3_use.dta", replace
	clear

* load data
	use 		"`root'/sect9_ph_w3.dta", clear

* dropping duplicates
	duplicates drop

* attempting to generate unique identifier
	describe
	sort 		holder_id parcel_id field_id crop_code
	isid 		holder_id parcel_id field_id crop_code, missok
	
* creating parcel identifier
	rename		parcel_id parcel
	tostring	parcel, replace
	generate 	parcel_id = holder_id + " " + ea_id + " " + parcel
	
* creating field identifier
	rename		field_id field
	tostring	field, replace
	generate 	field_id = holder_id + " " + ea_id + " " + parcel + " " + field
	
* creating unique crop identifier
	tostring	crop_code, generate(crop_codeS)
	generate 	crop_id = holder_id + " " + ea_id + " " + parcel + " " ///
					+ field + " " + crop_codeS
	isid		crop_id
	drop		crop_codeS

* creating district identifier
	egen 		district_id = group( saq01 saq02)
	label var 	district_id "Unique district identifier"
	distinct	saq01 saq02, joint
	*** 69 distinct districts
	*** same as pp sect2 & pp sect3, good
	
* check for missing crop codes
	tab			crop_code, missing
	** no missing crop codes in this wave =]

* create conversion key 
	generate 	conv_id = string(crop_code) + " " + string(ph_s9q04_b)
	merge 		m:1 conv_id using "`root'/Crop_CF_Wave3_use.dta"
	*** 7,127 obs not matched from master data
	*** why is this...
	
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
	keep  		holder_id- crop_code crop_id
	order 		holder_id- crop_code

* final preparations to export
	isid 		crop_id
	compress
	describe
	summarize 
	sort 		holder_id ea_id parcel field crop_code
	customsave , idvar(crop_id) filename(PP_SEC9.dta) path("`export'") ///
		dofile(PP_SEC9) user($user)

* close the log
	log	close