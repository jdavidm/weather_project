* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.16

* does
	* cleans Tanzania household variables, wave 3 Ag sec2b
	* looks like a parcel roster, "all plots anyone in your household owned or 
	* cultivated during the short rainy season"
	
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
	log using "$logout/wv3_AGSEC2B", append

* ***********************************************************************
* 1 - TZA 2012 (Wave 3) - Agriculture Section 2B 
* *********************1*************************************************

* load data
	use 		"$root/AG_SEC_2B", clear

* renaming variables of interest
	rename 		y3_hhid hhid
	rename 		ag2b_15 plotsize_self
	rename 		ag2b_20 plotsize_gps

* generating unique observation id for each ob
	generate 	plot_id = hhid + " " + plotnum
	isid 		plot_id
	
* generate seasonal variable
	generate 	season = 1
	
* keep what we want, get rid of the rest
	keep 		hhid plot_id plotsize_self plotsize_gps plotnum season

* prepare for export
compress
describe
summarize 
sort plot_id
customsave , idvar(plot_id) filename(AG_SEC2B.dta) path("$export") dofile(2012_AGSEC2B) user($user)

* close the log
	log	close

/* END */
