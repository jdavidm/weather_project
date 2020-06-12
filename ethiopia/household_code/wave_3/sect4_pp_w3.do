* Project: WB Weather
* Created on: June 2020
* Created by: McG
* Stata v.16

* does
	* cleans Ethiopia household variables, wave 3 PP sec4
	* looks like a crop level field roster (divides fields by crop)
	* hierarchy: holder > parcel > field > crop
	* some information on inputs

* assumes
	* customsave.ado

* TO DO:
	* results in genreal are all over the place (see summary at the end)
	
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root = "$data/household_data/ethiopia/wave_3/raw"
	loc export = "$data/household_data/ethiopia/wave_3/refined"
	loc logout = "$data/household_data/ethiopia/logs"

* open log
	log using "`logout'/wv3_PPSEC4", append


* **********************************************************************
* 1 - preparing ESS (Wave 3) - Post Planting Section 4
* **********************************************************************

* load data
	use 		"`root'/sect4_pp_w3.dta", clear

* dropping duplicates
	duplicates drop

* unique identifier can only be generated including crop code as some fields are mixed (pp_s4q02)
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

* drop observations with a missing field_id/crop_code
	summarize 	if missing(parcel_id,field_id,crop_code)
	drop 		if missing(parcel_id,field_id,crop_code)
	isid holder_id parcel_id field_id crop_code
	*** 0 observtions dropped

* accounting for mixed use fields - creates a multiplier
	generate 	field_prop = 1 if pp_s4q02 == 1
	replace 	field_prop = pp_s4q03*.01 if pp_s4q02 ==2

* looking at crop damage prevention measures
	generate 	pesticide_any = pp_s4q05 if pp_s4q05 >= 1
	generate 	herbicide_any = pp_s4q06 if pp_s4q06 >= 1
	replace 	herbicide_any = pp_s4q07 if pp_s4q06 != 1 & pp_s4q07 >= 1

* pp_s4q12_a and pp_s4q12_b give month and year seeds were planted
* the years for some reason mostly say 2005. 
* i don't think this is of interest to us anyway.


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
	keep  		holder_id- pp_s4q01_b pesticide_any herbicide_any field_prop ///
					crop_id
	order 		holder_id- saq05

* Final preparations to export
	isid 		holder_id parcel field crop_code
	isid		crop_id
	compress
	describe
	summarize 
	*** results are once again all over the place

	sort 		holder_id parcel field crop_code
	customsave , idvar(crop_id) filename(PP_SEC4.dta) path("`export'") ///
		dofile(PP_SEC4) user($user)

* close the log
	log	close