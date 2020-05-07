* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.15

* does
	*cleans Tanzania household variables, wave 1 Ag sec5b

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
*	log using "$logout/wv1_AGSEC5B"
*clear all

**********************************************************************************
**	TZA 2008 (Wave 1) - Agriculture Section 5B 
**********************************************************************************

use "$root/SEC_5B", clear

*	Crop sales data, short rainy season

rename zaocode crop_code

tostring crop_code, generate(crop_num) format(%03.0g) force

generate crop_id = hhid + " " + crop_num
isid crop_id

rename s5bq2 wgt_sold
label variable wgt_sold "What was the quanitity sold? (kg)"
rename s5bq3 value_sold
label variable value_sold "What was the total value of the sales? (T-shillings)"

keep hhid crop_code wgt_sold value_sold crop_id

*	Prepare for export
compress
describe
summarize 
sort crop_id
save "$export/AG_SEC5B", replace
