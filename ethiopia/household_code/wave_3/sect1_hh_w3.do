* Project: WB Weather
* Created on: June 2020
* Created by: McG
* Stata v.16

* does
	* cleans Ethiopia household variables, wave 3 HH sec1
	* gives location identifiers for participants
	* seems to very roughly correspond to Malawi ag-modI and ag-modO
	
* assumes
	* customsave.ado
	* distinct.ado

* TO DO:
	* the only isid variable i found is individual_id2
	* where is the isid for wave 3?

	
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
**	1 - ESS 2015/16 (Wave 3) - Household Section 1 
**********************************************************************************

* load data
	use 		"`root'/sect1_hh_w3.dta", clear

* dropping duplicates
	duplicates 	drop

* individual_id2 is unique identifier 
	describe
	sort 		household_id2 individual_id2
	isid 		individual_id2, missok

* creating unique region identifier
	egen 		region_id = group( saq01 saq02)
	label var 	region_id "Unique region identifier"
	distinct	saq01 saq02, joint
	*** 84 distinct regions

* renaming some variables of interest
	rename 		household_id hhid
	rename 		household_id2 hhid2
	rename 		saq01 district
	rename 		saq02 region
	rename 		saq03 woreda
	rename		saq07 ea


* ***********************************************************************
* 2 - cleaning and keeping
* *********************1*************************************************

* restrict to variables of interest
	keep  		hhid- saq08 region_id
	order 		hhid- saq08
	
* prepare for export
	isid		individual_id2
	compress
	describe
	summarize 
	sort hhid ea_id
	customsave , idvar(hhid) filename(HH_SEC1.dta) path("`export'") ///
		dofile(HH_SEC1) user($user)

* close the log
	log	close

/* END */
