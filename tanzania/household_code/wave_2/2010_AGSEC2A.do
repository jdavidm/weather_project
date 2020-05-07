* Project: WB Weather
* Created on: April 2020
* Created by: McG
* Stata v.15

* does
	*cleans Tanzania household variables, wave 2 Ag sec2a
  *looks like a parcel roster, "all plots anyone in your household owned or cultivated during the 2010 long rainy season"

* assumes


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
	log using "$logout/wv2_AGSEC2A"

*attempting to clean Tanzania household variables
global user "themacfreezie"

**********************************************************************************
**	TZA 2010 (Wave 2) - Agriculture Section 2A 
**********************************************************************************

use "$root/AG_SEC2A", clear

rename y2_hhid hhid
rename ag2a_04 plotsize_self
rename ag2a_09 plotsize_gps

generate plot_id = hhid + " " + plotnum
isid plot_id

keep hhid plot_id plotsize_self plotsize_gps

*	Prepare for export
compress
describe
summarize 
sort plot_id
save "$export/AG_SEC2A", replace

* close the log
	log	close

/* END */