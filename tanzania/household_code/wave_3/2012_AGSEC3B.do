* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.16

* does
	* cleans Tanzania household variables, wave 3 Ag sec3b
	* plot details, inputs, 2012 short rainy season
	
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
	global root = "G:/My Drive/weather_project/household_data/tanzania/wave_3/raw"
	global export = "G:/My Drive/weather_project/household_data/tanzania/wave_3/refined"
	global logout = "G:/My Drive/weather_project/household_data/tanzania/logs"

* open log
	log using "$logout/wv3_AGSEC3B", replace

* ***********************************************************************
* 1 - TZA 2012 (Wave 3) - Agriculture Section 3B
* *********************1*************************************************

* load data
	use "$root/AG_SEC_3B", clear

* renaming variables of interest
	rename y3_hhid hhid
	generate plot_id = hhid + " " + plotnum
	isid plot_id

* renaming inputs
	rename ag3b_03 status
	rename ag3b_07_2 crop_code
	rename ag3b_18 irrigated 
	rename ag3b_47 fert_any
	rename ag3b_49 kilo_fert
	rename ag3b_60 pesticide_any

* compiling labor inputs
	egen hh_labor_days = rsum(ag3b_72_1 ag3b_72_2 ag3b_72_3 ag3b_72_4 ag3b_72_5 ///
	ag3b_72_6 ag3b_72_7 ag3b_72_8 ag3b_72_9 ag3b_72_10 ag3b_72_11 ag3b_72_12 ///
	ag3b_72_13 ag3b_72_14 ag3b_72_15 ag3b_72_16 ag3b_72_17 ag3b_72_18 ag3b_72_19 ///
	ag3b_72_20 ag3b_72_21 ag3b_72_22 ag3b_72_23 ag3b_72_24)

	egen hired_labor_days = rsum(ag3b_74_1 ag3b_74_2 ag3b_74_3 ag3b_74_5 ag3b_74_6 ag3b_74_7 ///
	ag3b_74_9 ag3b_74_10 ag3b_74_11 ag3b_74_13 ag3b_74_14 ag3b_74_15)
 
	generate labor_days = hh_labor_days + hired_labor_days

* keep what we want, get rid of the rest
	keep hhid plot_id status crop_code irrigated fert_any kilo_fert pesticide_any labor_days 

* prepare for export
compress
describe
summarize 
sort plot_id
customsave , idvar(plot_id) filename(AG_SEC3B.dta) path("$export") dofile(2012_AGSEC3B) user($user)

* close the log
	log	close

/* END */