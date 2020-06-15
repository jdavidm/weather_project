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
	* pesticide_any and herbicide_any are well short of the other variables
	* can we impute a binary variable?
	
	
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
	
* creating district identifier
	egen 		district_id = group( saq01 saq02)
	lab var 	district_id "Unique district identifier"
	distinct	saq01 saq02, joint
	*** 69 distinct district
	*** same as pp sect2 & sect3, good
	
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
	

* ***********************************************************************
* 2 - variables of interest
* ***********************************************************************

* ***********************************************************************
* 2a - percent field use
* ***********************************************************************

* accounting for mixed use fields - creates a multiplier
	generate 	field_prop = 1 if pp_s4q02 == 1
	replace 	field_prop = pp_s4q03*.01 if pp_s4q02 ==2
	label var	field_prop "Percent field planted with crop"
	
	
* ***********************************************************************
* 2b - damage and damage preventation
* ***********************************************************************

* looking at crop damage
	rename		pp_s4q08 damaged
	sum 		damaged
	*** info for all observations
	
* percent crop damaged
	rename		pp_s4q10 damaged_pct
	replace		damaged_pct = 0 if damaged == 2
	sum			damaged_pct
	*** info for all obs

* looking at crop damage prevention measures
	generate 	pesticide_any = pp_s4q05 if pp_s4q05 >= 1
	generate 	herbicide_any = pp_s4q06 if pp_s4q06 >= 1
	replace 	herbicide_any = pp_s4q07 if pp_s4q06 != 1 & pp_s4q07 >= 1
	*** the same 3,740 obs have both pesticde & herbicide information
	*** all other obs are blank
	*** should these be considered as 'no's? seems like a big assumption
	
*	replace		pesticide_any = 2 if pesticide_any == .
*	replace		herbicide_any = 2 if herbicide_any == .
	*** should these be considered as 'no's? seems like a big assumption

* should (can) we impute a binary variable? - NO!
* jeff sez "if it's missing, call it a no"

* pp_s4q12_a and pp_s4q12_b give month and year seeds were planted
* the years for some reason mostly say 2005. 
* i don't think this is of interest to us anyway.


* ***********************************************************************
* 2c - seed use
* ***********************************************************************

* no info on seed value in this dataset

* looking at seed use
	generate	seed_wgt = pp_s4q11b_a + (0.001 * pp_s4q11b_b)
	summarize	seed_wgt
	*** 15,791 values for seed weight
	
* imputing missing seed values using predictive mean matching 
	mi set 		wide //	declare the data to be wide. 
	mi xtset, 	clear //	this is a precautinary step to clear any xtset that the analyst may have had in place previously
	mi register imputed seed_wgt //	identify seed_wgt as the variable being imputed 
	mi impute 	pmm seed_wgt pp_s4q01_b i.district_id, add(1) rseed(245780) ///
					noisily dots force knn(5) bootstrap 
	*** including crop type as a control variable - seems logical
	
	mi 			unset
	
* summarize results of imputation
	tabulate 	mi_miss	//	this binary = 1 for the full set of observations where plotsize_GPS is missing
	tabstat 	seed_wgt seed_wgt_1_, by(mi_miss) ///
					statistics(n mean min max) columns(statistics) longstub ///
					format(%9.3g) 
	*** 14,550 values imputed
					
	drop		mi_miss
	drop		seed_wgt
	rename		seed_wgt_1_ seed_wgt


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
	
* restrict to variables of interest
	keep  		holder_id- pp_s4q01_b pesticide_any herbicide_any field_prop ///
					damaged damaged_pct seed_wgt parcel_id field_id crop_id
	order 		holder_id- saq05

* Final preparations to export
	isid 		holder_id parcel field crop_code
	isid		crop_id
	compress
	describe
	summarize 
	sort 		holder_id parcel field crop_code
	customsave , idvar(crop_id) filename(PP_SEC4.dta) path("`export'") ///
		dofile(PP_SEC4) user($user)

* close the log
	log	close