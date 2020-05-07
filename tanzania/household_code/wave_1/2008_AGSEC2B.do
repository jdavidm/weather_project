* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.15

* does
	*cleans Tanzania household variables, wave 1 Ag sec2b

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
*	log using "$logout/wv1_AGSEC2B"
*clear all

**********************************************************************************
**	TZA 2008 (Wave 1) - Agriculture Section 2B 
**********************************************************************************

use "$root/SEC_2B", clear

*	looks like a parcel roster, "additional plots owned or cultivated by anyone in your household during the short rainy season (2008)"

rename hhid hhid
rename s2bq9 plotsize_self
rename area plotsize_gps

generate plot_id = hhid + " " + plotnum
isid plot_id

keep hhid plot_id plotsize_self plotsize_gps

*	Prepare for export
compress
describe
summarize 
sort plot_id
save "$export/AG_SEC2B", replace

* close the log
*	log	close
