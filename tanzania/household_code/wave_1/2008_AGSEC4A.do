* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.15

* does
	*cleans Tanzania household variables, wave 1 Ag sec4a

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
*	log using "$logout/wv1_AGSEC4A"
*clear all

**********************************************************************************
**	TZA 2008 (Wave 1) - Agriculture Section 4A 
**********************************************************************************

use "$root/SEC_4A", clear

*	Kind of a crop roster, with harvest weights, long rainy season

rename zaocode crop_code

tostring crop_code, generate(crop_num) format(%03.0g) force

generate crop_id = hhid + " " + plotnum + " " + crop_num
isid crop_id

rename s4aq3 purestand
generate mixedcrop_pct = .
replace mixedcrop_pct = 100 if purestand == 1
replace mixedcrop_pct = 75 if s4aq4 == 3
replace mixedcrop_pct = 50 if s4aq4 == 2
replace mixedcrop_pct = 25 if s4aq4 == 1
*	There are 519 missing obs here
tab mixedcrop_pct crop_code, missing
*	Only one is missing a crop code
sort crop_code
* 	This is an issue

rename s4aq11_1 harvest_month
rename s4aq15 wgt_hvsted
label variable wgt_hvsted "What was the quanitity harvested? (kg)"
rename s4aq20 value_seed_purch
*	See if you can find quantity purchased and quantity of old seeds used to derive total value seeds used

keep hhid plotnum crop_id crop_code mixedcrop_pct harvest_month wgt_hvsted value_seed_purch

*	Prepare for export
compress
describe
summarize 
sort crop_id
save "$export/AG_SEC4A", replace

* close the log
*	log	close

/* END */
