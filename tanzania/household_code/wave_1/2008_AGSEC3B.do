* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.16

* does
	* cleans Tanzania household variables, wave 1 Ag sec3b
	* plot details, inputs, 2008 short rainy season

* assumes
	* customsave.ado

* TO DO:
	* completed

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* set user
	global user "themacfreezie"

* define paths
	global root = "G:/My Drive/weather_project/household_data/tanzania/wave_1/raw"
	global export = "G:/My Drive/weather_project/household_data/tanzania/wave_1/refined"
	global logout = "G:/My Drive/weather_project/household_data/tanzania/logs"

*Open log
	log using "$logout/wv1_AGSEC3B", append


**********************************************************************************
**	TZA 2008 (Wave 1) - Agriculture Section 3B 
**********************************************************************************

* load dat
	use 		"$root/SEC_3B", clear

* renaming variables of interest
	generate 	plot_id = hhid + " " + plotnum
	isid 		plot_id

* renaming inputs
	rename 		s3bq3 status
	rename 		s3bq5 crop_code
	rename 		s3bq15 irrigated 
	rename 		s3bq43 fert_any
	rename 		s3bq45 kilo_fert
	rename 		s3bq49 pesticide_any
	label 		define pesticide_anyl 1 "Yes" 2 "No"
	label 		values pesticide_any pesticide_anyl

*labor inputs
	egen 		hh_labor_days = rsum(s3bq61_1 s3bq61_2 s3bq61_3 s3bq61_4 ///
				s3bq61_5 s3bq61_6 s3bq61_7 s3bq61_8 s3bq61_9 s3bq61_10 ///
				s3bq61_11 s3bq61_12 s3bq61_13 s3bq61_14 s3bq61_15 s3bq61_16 ///
				s3bq61_17  s3bq61_18 s3bq61_19 s3bq61_20 s3bq61_21 s3bq61_22 ///
				s3bq61_23 s3bq61_24 s3bq61_25 s3bq61_26 s3bq61_27 s3bq61_28 ///
				s3bq61_29 s3bq61_30 s3bq61_31 s3bq61_32 s3bq61_33 s3bq61_34 ///
				s3bq61_35 s3bq61_36)

	egen 		hired_labor_days = rsum(s3bq63_1 s3bq63_2 s3bq63_4 s3bq63_5 s3bq63_7 s3bq63_8)
 
	generate 	labor_days = hh_labor_days + hired_labor_days

* generate seasonal variable
	generate 	season = 1	

* keep waht we want, get rid of the rest
	keep 		hhid plot_id status crop_code irrigated fert_any kilo_fert ///
				pesticide_any labor_days season plotnum

* prepare for export
	compress
	describe
	summarize 
	sort plot_id
	customsave , idvar(plot_id) filename(AG_SEC3B.dta) ///
	path("$export") dofile(2008_AGSEC3B) user($user)

* close the log
	log	close

/* END */
