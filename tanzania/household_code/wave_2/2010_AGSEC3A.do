* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.15

* does
	* cleans Tanzania household variables, wave 2 Ag sec3a
	* plot details, inputs, 2010 long rainy season

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
	global root = "G:/My Drive/weather_project/household_data/tanzania/wave_2/raw"
	global export = "G:/My Drive/weather_project/household_data/tanzania/wave_2/refined"
	global logout = "C:/Users/$user/git/weather_project/tanzania/household_code/logs"

*Open log
	log using "$logout/wv2_AGSEC3A", append


**********************************************************************************
**	TZA 2010 (Wave 2) - Agriculture Section 3A 
**********************************************************************************

* load data
	use 		"$root/AG_SEC3A", clear

* renaming variables of interest
	rename 		y2_hhid hhid
	generate 	plot_id = hhid + " " + plotnum
	isid 	plot_id

* renaming inputs
	rename 		ag3a_03 status
	rename 		zaocode crop_code
	rename 		ag3a_17 irrigated 
	rename 		ag3a_45 fert_any
	rename 		ag3a_47 kilo_fert
	rename 		ag3a_58 pesticide_any
	label 		define pesticide_anyl 1 "Yes" 2 "No"
	label 		values pesticide_any pesticide_anyl

* labor inputs
	egen 		hh_labor_days = rsum(ag3a_70_1 ag3a_70_2 ag3a_70_3 ag3a_70_4 ag3a_70_5 ag3a_70_6 ag3a_70_13 ag3a_70_14 ///
				ag3a_70_15 ag3a_70_16 ag3a_70_17 ag3a_70_18 ag3a_70_37 ag3a_70_38 ag3a_70_39 ag3a_70_40 ag3a_70_41 ag3a_70_42 ///
				ag3a_70_25 ag3a_70_26 ag3a_70_27 ag3a_70_28 ag3a_70_29 ag3a_70_30)

	egen 		hired_labor_days = rsum(ag3a_72_1 ag3a_72_2 ag3a_72_21 ag3a_72_4 ag3a_72_5 ag3a_72_51 ///
				ag3a_72_61  ag3a_72_62 ag3a_72_63 ag3a_72_7 ag3a_72_8 ag3a_72_81)
 
	generate 	labor_days = hh_labor_days + hired_labor_days

* generate seasonal variable
	generate 	season = 0	

* keep what we want, get rid of the rest
	keep 		hhid plot_id status crop_code irrigated fert_any kilo_fert pesticide_any labor_days season plotnum

*	Prepare for export
compress
describe
summarize 
sort plot_id
customsave , idvar(plot_id) filename(AG_SEC3A.dta) path("$export") dofile(2010_AGSEC3A) user($user)

* close the log
	log	close

/* END */
