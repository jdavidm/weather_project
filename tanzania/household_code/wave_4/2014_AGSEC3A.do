* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.16

* does
	* cleans Tanzania household variables, wave 4 Ag sec3a
	* plot details, inputs, 2014 long rainy season

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
	global root = "G:/My Drive/weather_project/household_data/tanzania/wave_4/raw"
	global export = "G:/My Drive/weather_project/household_data/tanzania/wave_4/refined"
	global logout = "G:/My Drive/weather_project/household_data/tanzania/logs"

* open log
	log using "$logout/wv4_AGSEC3A", append

* ***********************************************************************
* 1 - TZA 2014 (Wave 4) - Agriculture Section 3A
* *********************1*************************************************

* load data
	use 					"$root/ag_sec_3a", clear

* renaming variables of interest
	rename 				y4_hhid hhid
	gen						plot_id = hhid + " " + plotnum
	isid 					plot_id

* renaming inputs
	rename 				ag3a_03 status
	rename 				ag3a_07_2 crop_code
	rename 				ag3a_18 irrigated
	rename 				ag3a_47 fert_any
	rename 				ag3a_49 kilo_fert

* pesticide variable
	gen						pesticide_any = .
	replace 			pesticide_any = ag3a_60 if ag3a_60 == 1
	replace				pesticide_any = ag3a_65a if pesticide_any == . & ag3a_65a == 1
	replace				pesticide_any = 2 if ag3a_60 == 2 & ag3a_65a == 2 & pesticide_any == .
	lab define 		pesticide_anyl 1 "Yes" 2 "No"
	lab	val		 		pesticide_any pesticide_anyl

* compiling labor inputs
	egen 					hh_labor_days = rsum(ag3a_72_1 ag3a_72_2 ag3a_72_3 ag3a_72_4 ///
									ag3a_72_5 ag3a_72_6 ag3a_72_7 ag3a_72_8 ag3a_72_9 ag3a_72_10 ///
									ag3a_72_11 ag3a_72_12 ag3a_72_13 ag3a_72_14 ag3a_72_15 ///
									ag3a_72_16 ag3a_72_17 ag3a_72_18)

	egen 					hired_labor_days = rsum(ag3a_74_1 ag3a_74_2 ag3a_74_3 ag3a_74_5 ///
									ag3a_74_6 ag3a_74_7 ag3a_74_13 ag3a_74_14 ag3a_74_15)

	gen					 	labor_days = hh_labor_days + hired_labor_days

* generate seasonal variable
	gen					 	season = 0

* keep what we want, get rid of the rest
	keep 					hhid plot_id status crop_code irrigated fert_any kilo_fert ///
									pesticide_any labor_days plotnum season

* prepare for export
	compress
	describe
	summarize
	sort plot_id
	customsave , idvar(plot_id) filename(AG_SEC3A.dta) ///
		path("$export") dofile(2014_AGSEC3A) user($user)

* close the log
	log	close

/* END */
