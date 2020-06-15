* Project: WB Weather
* Created on: June 2020
* Created by: McG
* Stata v.16

* does
	* cleans Ethiopia household variables, wave 3 PP sec2
	* looks like a parcel roster
	* hierarchy: holder > parcel > field > crop
	* seems to correspond to Malawi ag-modB and ag-modI
	
* assumes
	* customsave.ado
	* distinct.ado

* TO DO: 
	* what is 'obs' variable?

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root = "$data/household_data/ethiopia/wave_3/raw"
	loc export = "$data/household_data/ethiopia/wave_3/refined"
	loc logout = "$data/household_data/ethiopia/logs"

* open log
*	log using "`logout'/wv3_PPSEC2", append

	
* **********************************************************************
* 1 - preparing ESS 2015/16 (Wave 3) - Post Planting Section 2 
* **********************************************************************

* load data
	use 		"`root'/sect2_pp_w3.dta", clear

* dropping duplicates
	duplicates	drop

* investigate unique identifier
	describe
	sort 		holder_id ea_id parcel_id
	isid 		holder_id parcel_id

* creating district identifier
	egen 		district_id = group( saq01 saq02)
	label var 	district_id "Unique district identifier"
	distinct	saq01 saq02, joint
	*** 69 distinct district
	
* creating unique parcel identifier
	rename		parcel_id parcel
	tostring	parcel, replace
	generate 	parcel_id = holder_id + " " + parcel
	isid 		parcel_id

* drop observations with a missing parcel_id
	summarize 	if missing(holder_id,ea_id,parcel_id)
	drop 		if missing(holder_id,ea_id,parcel_id)
	*** no obs dropped 

* drop obs where the holder no longer owns or rents this parcel
	drop		if pp_s2q01b == 2
	
* address missing value for pp_saq07 (holder id)
	replace		pp_saq07 = 1 if pp_saq07 == .
	*** one change made
	*** it seems to be the only obs for that hh, so I assume it should be = 1
	
	isid 		holder_id ea_id parcel_id
	
	
* ***********************************************************************
* 2 - cleaning and keeping
* *********************1*************************************************

* renaming some variables of interest	
	rename 		household_id hhid
	rename 		household_id2 hhid2
	rename 		saq01 region
	rename 		saq02 district
	label var 	district "District Code"
	rename 		saq03 ward
	rename 		pp_s2q02 number_fields

* restrict to variables of interest
	keep  		holder_id- pp_s2q01 number_fields district_id parcel_id
	order 		holder_id- pp_s2q01 number_fields district_id parcel_id

* prepare for export
	isid		holder_id ea_id parcel
	isid		parcel_id
	compress
	describe
	*** a number of obs are missing number_fields...
	
	summarize 
	sort 		holder_id ea_id
	customsave , idvar(parcel_id) filename(PP_SEC2.dta) path("`export'") ///
		dofile(PP_SEC2) user($user)

* close the log
	log	close

/* END */