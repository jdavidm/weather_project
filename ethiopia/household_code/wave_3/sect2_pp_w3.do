* Project: WB Weather
* Created on: June 2020
* Created by: McG
* Stata v.16

* does
	* cleans Ethiopia household variables, wave 3 PP sec2
	* looks like a parcel roster
	* seems to correspond to Malawi ag-modB and ag-modI
	
* assumes
	* customsave.ado
	* distinct.ado

* TO DO:
	* 

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root = "$data/household_data/ethiopia/wave_3/raw"
	loc export = "$data/household_data/ethiopia/wave_3/refined"
	loc logout = "$data/household_data/ethiopia/logs"

* open log
	log using "`logout'/wv3_HHSEC1", append

	
**********************************************************************************
**	1 - ESS 2015/16 (Wave 3) - Post Planting Section 2 
**********************************************************************************

* load data
	use 		"`root'/sect2_pp_w3.dta", clear

* dropping duplicates
	duplicates	drop

* investigate unique identifier
	describe
	sort 		holder_id ea_id parcel_id
	isid 		holder_id parcel_id, missok

* creating unique region identifier
	egen 		region_id = group( saq01 saq02)
	label var 	region_id "Unique region identifier"
	distinct	saq01 saq02, joint
	*** 69 distinct regions

* drop observations with a missing parcel_id
	summarize 	if missing(holder_id,ea_id,parcel_id)
	drop 		if missing(holder_id,ea_id,parcel_id)
	*** no obs dropped 
	
	isid 		holder_id ea_id parcel_id

* renaming some variables of interest	
	rename 		household_id hhid
	rename 		household_id2 hhid2
	rename 		saq01 district
	rename 		saq02 region
	rename 		saq03 ward
	rename 		pp_s2q02 number_fields
	
	
* ***********************************************************************
* 2 - cleaning and keeping
* *********************1*************************************************

* restrict to variables of interest
	keep  		holder_id- pp_s2q01 number_fields region_id
	order 		holder_id- pp_s2q01 number_fields region_id

* prepare for export
	isid		holder_id ea_id parcel_id
	compress
	describe
	summarize 
	sort 		holder_id ea_id
	customsave , idvar(hhid) filename(PP_SEC2.dta) path("`export'") ///
		dofile(PP_SEC2) user($user)

* close the log
	log	close

/* END */