* Project: WB Weather
* Created on: June 2020
* Created by: McG
* Stata v.16

* does
	* cleans Ethiopia household variables, wave 3 PP sec5
	* seems to roughly correspong to Malawi ag-modH and ag-modN
	* contains seed info by crop by holder, no parcel/field info
	* hierarchy: holder > parcel > field > crop

* assumes
	* customsave.ado

* TO DO:
	* develop a unique id
	* seed values missing a lot of obs, must impute
	
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root = "$data/household_data/ethiopia/wave_3/raw"
	loc export = "$data/household_data/ethiopia/wave_3/refined"
	loc logout = "$data/household_data/ethiopia/logs"

* open log
	log using "`logout'/wv3_PPSEC5", append


* **********************************************************************
* 1 - preparing ESS (Wave 3) - Post Planting Section 5
* **********************************************************************

* load data
	use 		"`root'/sect5_pp_w3.dta", clear

* dropping duplicates
	duplicates drop
	
* creating district identifier
	egen 		district_id = group( saq01 saq02)
	lab var 	district_id "Unique district identifier"
	distinct	saq01 saq02, joint
	*** 69 distinct district
	*** same as pp sect2, sect3 & sect4, good

* attempting to generate unique identifier
	describe
	sort 		holder_id crop_code
* 	isid 		holder_id crop_code pp_s5q01, missok */
	*** not providing a unique identifier - must investigate 
	
	tostring	crop_code, generate(crop_codeS)
	tostring	pp_s5q01, generate(seed_typeS)
	generate 	seed_id = holder_id + " " + crop_codeS + " " + seed_typeS
*	isid		seed_id
	** as expected, not a unique id
	
	drop		crop_codeS seed_typeS

* field_id and parcel_id are not present - present in Wave1, isid works with these

* check for duplicates in terms of holder, crop, and seed type
	duplicates 	tag holder_id crop_code pp_s5q01, generate (dupe)
	tab			dupe	
	duplicates	report seed_id
	*** 124 surplus observations

* maybe look into 'collapse' command? (THIS IS OLD LANGUAGE - NOT SURE WHAT WE MEANT)

* drop observations with a missing crop_code
	summarize 	if missing(crop_code)
	drop 		if missing(crop_code)
	*** 0 obs dropped 

*	isid 		holder_id crop_code pp_s5q01, missok

* no unique identifier is easily found
* there are weird differences in rows that are otherwise completely identical

	duplicates 	list holder_id crop_code pp_s5q01
	*** the above command is useful for looking at differences

* investigate crop mix
	tabulate 	crop_code, plot
	

* ***********************************************************************
* 2 - seed use
* ***********************************************************************

* seed info
* pp_sect4 also has seed weight...
	generate	seed_wgt = pp_s5q19_a + (0.001*pp_s5q19_b)
	label var 	seed_wgt "Total amount of seed used (kg)"
	rename		pp_s5q08 seed_value
	sum 		seed_wgt seed_value
		
* imputing missing seed values using predictive mean matching 
	mi set 		wide //	declare the data to be wide. 
	mi xtset, 	clear //	this is a precautinary step to clear any xtset that the analyst may have had in place previously
	mi register imputed seed_value //	identify seed_value as the variable being imputed 
	mi impute 	pmm seed_value crop_code seed_wgt i.district_id, add(1) rseed(245780) ///
					noisily dots force knn(5) bootstrap 
	*** including crop type and seed_wgt control variables - seems logical
	
	mi 			unset
	
* summarize results of imputation
	tabulate 	mi_miss	//	this binary = 1 for the full set of observations where plotsize_GPS is missing
	tabstat 	seed_value seed_value_1_, by(mi_miss) ///
					statistics(n mean min max) columns(statistics) longstub ///
					format(%9.3g) 
	*** 9,691 values imputed
					
	drop		mi_miss
	drop		seed_value
	rename		seed_value_1_ seed_value


* ***********************************************************************
* 3 - cleaning and keeping
* ***********************************************************************

* renaming some variables of interest
	rename 		household_id hhid
	rename 		household_id2 hhid2
	rename 		saq01 region
	rename 		saq02 district
	label var 	district "District Code"
	rename 		saq03 ward	
	rename		pp_s5q01 seed_type
	
* restrict to variables of interest
	keep  		holder_id- crop_code seed_type seed_wgt seed_value seed_id
	order 		holder_id crop_code seed_id
	
* final preparations to export
*	isid 		holder_id crop_code seed_type
	compress
	describe
	summarize 
	sort 		holder_id crop_code seed_type
	customsave , idvar(seed_id) filename(PP_SEC5.dta) path("`export'") ///
		dofile(PP_SEC5) user($user)

* close the log
	log	close