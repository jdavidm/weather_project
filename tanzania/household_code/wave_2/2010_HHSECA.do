* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.16

* does
	* cleans Tanzania household variables, wave 2 hh secA
	* pulls regional identifiers

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
	global logout = "G:/My Drive/weather_project/household_data/tanzania/logs"

* open log
	log using "$logout/wv2_HHSECA", append

* ***********************************************************************
* 1 - TZA 2010 (Wave 2) - Household Section A
* *********************1*************************************************

* load data
	use 		"$root/HH_SEC_A", clear

* rename variables of interest
	rename		y2_hhid hhid

* keep variables of interest
	keep 		hhid region district ward ea
	order		hhid region district ward ea

* prepare for export
	compress
	describe
	summarize
	sort hhid
	customsave , idvar(hhid) filename(HH_SECA.dta) ///
		path("$export") dofile(2010_HHSECA) user($user)

* close the log
	log	close

/* END */
