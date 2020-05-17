* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.16

* does
	* cleans Tanzania household variables, wave 4 Ag sec3b
	* plot details, inputs, 2014 short rainy season
	
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
	log using "$logout/wv4_AGSEC3B", append

* ***********************************************************************
* 1 - TZA 2014 (Wave 4) - Agriculture Section 3B 
* *********************1*************************************************

* load data
	use 		"$root/ag_sec_3b", clear

* renaming variables of interest
	rename 		y4_hhid hhid
	generate 	plot_id = hhid + " " + plotnum
	isid 		plot_id

* renaming inputs
	rename 		ag3b_03 status
	rename 		ag3b_07_2 crop_code
	rename 		ag3b_18 irrigated 
	rename 		ag3b_47 fert_any
	rename 		ag3b_49 kilo_fert

* pesticide variable
	generate	pesticide_any = .
	replace 	pesticide_any = ag3b_60 if ag3b_60 == 1
	replace		pesticide_any = ag3b_65a if pesticide_any == . & ag3b_65a == 1
	replace		pesticide_any = 2 if ag3b_60 == 2 & ag3b_65a == 2 & pesticide_any == .
	label 		define pesticide_anyl 1 "Yes" 2 "No"
	label 		values pesticide_any pesticide_anyl

* compiling labor inputs
	egen 		hh_labor_days = rsum(ag3b_72_1 ag3b_72_2 ag3b_72_3 ag3b_72_4 ///
				ag3b_72_5 ag3b_72_6 ag3b_72_7 ag3b_72_8 ag3b_72_9 ag3b_72_10 ///
				ag3b_72_11 ag3b_72_12 ag3b_72_13 ag3b_72_14 ag3b_72_15 ///
				ag3b_72_16 ag3b_72_17 ag3b_72_18)

	egen 		hired_labor_days = rsum(ag3b_74_1 ag3b_74_2 ag3b_74_3 ag3b_74_5 ///
				ag3b_74_6 ag3b_74_7 ag3b_74_9 ag3b_74_10 ag3b_74_11 ag3b_74_13 ///
				ag3b_74_14 ag3b_74_15)
	
	generate 	labor_days = hh_labor_days + hired_labor_days
	
* generate seasonal variable
	generate 	season = 1

* keep what we want, get rid of the rest
	keep 		hhid plot_id status crop_code irrigated fert_any kilo_fert ///
				pesticide_any labor_days plotnum season

* prepare for export
compress
describe
summarize 
sort plot_id
customsave , idvar(plot_id) filename(AG_SEC3B.dta) path("$export") dofile(2014_AGSEC3B) user($user)

* close the log
	log	close

/* END */