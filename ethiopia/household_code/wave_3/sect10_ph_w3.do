* Project: WB Weather
* Created on: June 2020
* Created by: McG
* Stata v.16

* does
	* cleans Ethiopia household variables, wave 3 PH sec9
	* seems to roughly correspong to Malawi ag-modD and ag-modK
	* contains labor information on a crop level
	* hierarchy: holder > parcel > field > crop

* assumes
	* customsave.ado
	* distinct.ado
	
* TO DO:
	* labordays_harv is like broken, all obs are missing
	
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root = "$data/household_data/ethiopia/wave_3/raw"
	loc export = "$data/household_data/ethiopia/wave_3/refined"
	loc logout = "$data/household_data/ethiopia/logs"

* open log
	log using "`logout'/wv3_PHSEC10", append


* **********************************************************************
* 1 - preparing ESS (Wave 3) - Post Harvest Section 10
* **********************************************************************

* load data
	use 		"`root'/sect10_ph_w3.dta", clear

* dropping duplicates
	duplicates drop

* unique identifier can only be generated including crop code as some fields are mixed
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

* drop observations with a missing crop_id
	summarize 	if missing(parcel_id,field_id,crop_code)
	drop 		if missing(parcel_id,field_id,crop_code)
	*** no obs dropped
	
	isid 		holder_id parcel_id field_id crop_code

* creating district identifier
	egen 		district_id = group( saq01 saq02)
	label var 	district_id "Unique district identifier"
	distinct	saq01 saq02, joint
	*** 69 distinct districts
	*** same as pp sect2, pp sect3, and ph sect9, good

* totaling hired labor
	generate 	hired_labor_m = ph_s10q01_a * ph_s10q01_b
	generate 	hired_labor_f = ph_s10q01_d * ph_s10q01_e
	generate 	hired_labor_c = ph_s10q01_g * ph_s10q01_h
	generate 	hired_labor = hired_labor_m + hired_labor_f + hired_labor_c
	drop 		hired_labor_m hired_labor_f hired_labor_c

* totaling free labor	
	generate 	free_labor_m = ph_s10q03_a * ph_s10q03_b
	generate 	free_labor_f = ph_s10q03_c * ph_s10q03_d
	generate 	free_labor_c = ph_s10q03_e * ph_s10q03_f
	generate 	free_labor = free_labor_m + free_labor_f + free_labor_c
	drop 		free_labor_m free_labor_f free_labor_c

* total non-household labor
	generate 	non_hh_labor = hired_labor + free_labor
	drop 		hired_labor free_labor

* totaling household labor
	generate 	hh_member_1 = ph_s10q02_b * ph_s10q02_c
	generate 	hh_member_2 = ph_s10q02_f * ph_s10q02_g
	generate 	hh_member_3 = ph_s10q02_j * ph_s10q02_k
	generate 	hh_member_4 = ph_s10q02_n * ph_s10q02_o
	generate 	hh_labor = hh_member_1 + hh_member_2 + hh_member_3 + hh_member_4
	drop 		hh_member_1 hh_member_2 hh_member_3 hh_member_4

* generating total labor
	generate 	labordays_harv = hh_labor + non_hh_labor
	drop 		hh_labor non_hh_labor
	label var 	labordays_harv "Total Days of Harvest Labor - Household and Hired"

	
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
	keep  		holder_id- crop_code crop_id labordays_harv district_id
	order 		holder_id- crop_code

* final preparations to export
	isid 		crop_id
	compress
	describe
	summarize 
	sort 		holder_id ea_id parcel field crop_code
	customsave , idvar(crop_id) filename(PP_SEC10.dta) path("`export'") ///
		dofile(PP_SEC10) user($user)

* close the log
	log	close