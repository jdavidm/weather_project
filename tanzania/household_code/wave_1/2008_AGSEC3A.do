* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.15

* does
	* cleans Tanzania household variables, wave 1 Ag sec3a
	* plot details, inputs, 2008 long rainy season
	* generates irrigation and pesticide dummies, fertilizer variables, and labor variables 

* assumes
	* customsave.ado

* TO DO:
	* completed

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root = "$data/household_data/tanzania/wave_1/raw"
	loc export = "$data/household_data/tanzania/wave_1/refined"
	loc logout = "$data/household_data/tanzania/logs"

* open log
	log using "`logout'/wv1_AGSEC3A", append


* **********************************************************************
* 1 - TZA 2008 (Wave 1) - Agriculture Section 3A 
* **********************************************************************

* load data
	use 		"`root'/SEC_3A", clear

* renaming variables of interest
	generate 	plot_id = hhid + " " + plotnum
	isid 		plot_id

* renaming inputs
	rename 		s3aq3 status
	rename 		s3aq5code crop_code
	rename 		s3aq15 irrigated 
	
* constructing fertilizer variables
	rename 		s3aq43 fert_any
	rename 		s3aq45 kilo_fert
	replace		kilo_fert = . if fert_any == . 

* constructing pesticide/herbicide variables
	gen			pesticide_any = 2
	gen			herbicide_any = 2
	replace 	pesticide_any = 1 if s3aq50 == 1 | s3aq50 == 4
	replace 	herbicide_any = 1 if s3aq50 == 2 | s3aq50 == 3
	label 		define pesticide_any 1 "Yes" 2 "No"
	label 		values pesticide_any pesticide_any
	label 		values herbicide_any pesticide_any

*	labor inputs
	egen 		hh_labor_days = rsum(s3aq61_1 s3aq61_2 s3aq61_3 s3aq61_4 ///
					s3aq61_5 s3aq61_6 s3aq61_7 s3aq61_8 s3aq61_9 s3aq61_10 ///
					s3aq61_11 s3aq61_12 s3aq61_13 s3aq61_14 s3aq61_15 s3aq61_16 ///
					s3aq61_17  s3aq61_18 s3aq61_19 s3aq61_20 s3aq61_21 ///
					s3aq61_22 s3aq61_23 s3aq61_24 s3aq61_25 s3aq61_26 s3aq61_27 ///
					s3aq61_28 s3aq61_29 s3aq61_30 s3aq61_31 s3aq61_32 s3aq61_33 ///
					s3aq61_34 s3aq61_35 s3aq61_36)

	egen 		hired_labor_days = rsum(s3aq63_1 s3aq63_2 s3aq63_4 s3aq63_5 ///
					s3aq63_7 s3aq63_8)
 
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
		dofile(2008_AGSEC3A) user($user)

* close the log
	log	close

/* END */