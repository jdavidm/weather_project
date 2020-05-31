* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.15

* does
	* cleans Tanzania household variables, wave 2 Ag sec3a
	* plot details, inputs, 2010 long rainy season
	* generates irrigation and pesticide dummies, fertilizer variables, and labor variables 

* assumes
	* customsave.ado

* TO DO:
	* completed

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root = "$data/household_data/tanzania/wave_2/raw"
	loc export = "$data/household_data/tanzania/wave_2/refined"
	loc logout = "$data/household_data/tanzania/logs"

* open log
	log using "`logout'/wv2_AGSEC3A", append


* **********************************************************************
* 1 - TZA 2010 (Wave 2) - Agriculture Section 3A 
* **********************************************************************

* load data
	use 		"`root'/AG_SEC3A", clear

* renaming variables of interest
	rename 		y2_hhid hhid
	generate 	plot_id = hhid + " " + plotnum
	isid 		plot_id

* renaming inputs
	rename 		ag3a_03 status
	rename 		zaocode crop_code
	rename 		ag3a_17 irrigated 
	
* constructing fertilizer variables
	rename 		ag3a_45 fert_any
	replace		ag3a_47 = 0 if ag3a_47 == .
	replace		ag3a_54 = 0 if ag3a_54 == .
	gen			kilo_fert = ag3a_47 + ag3a_54
	replace		kilo_fert = . if fert_any == . 

* constructing pesticide/herbicide variables
	gen			pesticide_any = 2
	gen			herbicide_any = 2
	replace 	pesticide_any = 1 if ag3a_59 == 1 | ag3a_59 == 4
	replace 	herbicide_any = 1 if ag3a_59 == 2 | ag3a_59 == 3
	label 		define pesticide_any 1 "Yes" 2 "No"
	label 		values pesticide_any pesticide_any
	label 		values herbicide_any pesticide_any

* labor inputs
	egen 		hh_labor_days = rsum(ag3a_70_1 ag3a_70_2 ag3a_70_3 ag3a_70_4 ///
					ag3a_70_5 ag3a_70_6 ag3a_70_13 ag3a_70_14 ag3a_70_15 ///
					ag3a_70_16 ag3a_70_17 ag3a_70_18 ag3a_70_37 ag3a_70_38 ///
					ag3a_70_39 ag3a_70_40 ag3a_70_41 ag3a_70_42 ag3a_70_25 ///
					ag3a_70_26 ag3a_70_27 ag3a_70_28 ag3a_70_29 ag3a_70_30)

	egen 		hired_labor_days = rsum(ag3a_72_1 ag3a_72_2 ag3a_72_21 ///
					ag3a_72_4 ag3a_72_5 ag3a_72_51 ag3a_72_61  ag3a_72_62 ///
					ag3a_72_63 ag3a_72_7 ag3a_72_8 ag3a_72_81)
 
	generate 	labor_days = hh_labor_days + hired_labor_days

* keep what we want, get rid of the rest
	keep 		hhid plot_id status crop_code irrigated fert_any kilo_fert ///
					pesticide_any herbicide_any labor_days plotnum

* prepare for export
	compress
	describe
	summarize 
	sort plot_id
	customsave , idvar(plot_id) filename(AG_SEC3A.dta) path("`export'") ///
		dofile(2010_AGSEC3A) user($user)
	
* close the log
	log	close

/* END */
