* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.15

* does
	*cleans Tanzania household variables, wave 1 Ag sec3a

* assumes


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
	global logout = "C:/Users/$user/git/weather_project/tanzania/household_code/logs"

*Open log
*	log using "$logout/wv1_AGSEC3A"
*clear all

**********************************************************************************
**	TZA 2008 (Wave 1) - Agriculture Section 3A 
**********************************************************************************

use "$root/SEC_3A", clear

*	plot details, inputs, 2008 long rainy season

generate plot_id = hhid + " " + plotnum
isid plot_id

*	inputs
rename s3aq3 status
rename s3aq5code crop_code
rename s3aq15 irrigated 
rename s3aq43 fert_any
rename s3aq45 kilo_fert
rename s3aq49 pesticide_any

*	labor inputs
egen hh_labor_days = rsum(s3aq61_1 s3aq61_2 s3aq61_3 s3aq61_4 s3aq61_5 s3aq61_6 s3aq61_7 ///
 s3aq61_8 s3aq61_9 s3aq61_10 s3aq61_11 s3aq61_12 s3aq61_13 s3aq61_14 s3aq61_15 s3aq61_16 ///
 s3aq61_17  s3aq61_18 s3aq61_19 s3aq61_20 s3aq61_21 s3aq61_22 s3aq61_23 s3aq61_24 s3aq61_25 ///
 s3aq61_26 s3aq61_27 s3aq61_28 s3aq61_29 s3aq61_30 s3aq61_31 s3aq61_32 s3aq61_33 s3aq61_34 ///
 s3aq61_35 s3aq61_36)

egen hired_labor_days = rsum(s3aq63_1 s3aq63_2 s3aq63_4 s3aq63_5 s3aq63_7 s3aq63_8)
 
generate labor_days = hh_labor_days + hired_labor_days

keep hhid plot_id status crop_code irrigated fert_any kilo_fert pesticide_any labor_days 

*	Prepare for export
compress
describe
summarize 
sort plot_id
save "$export/AG_SEC3A", replace

* close the log
*	log	close

/* END */
