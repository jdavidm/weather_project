* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.16

* does
	* cleans Tanzania household variables, wave 4 hh secA
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
	global root = "G:/My Drive/weather_project/household_data/tanzania/wave_4/raw"
	global export = "G:/My Drive/weather_project/household_data/tanzania/wave_4/refined"
	global logout = "G:/My Drive/weather_project/household_data/tanzania/logs"

* open log
	log using "$logout/wv4_HHSECA", append

* ***********************************************************************
* 1 - TZA 2014 (Wave 4) - Household Section A
* *********************1*************************************************

* load data
	use 		"$root/hh_sec_a", clear

* keep variables of interest
	keep 			occ- hh_a12_1

* renaming some variables
	rename		y4_hhid hhid
	rename		hh_a01_1 region
	rename		hh_a02_1 district
	rename		hh_a03_1 ward
	rename		hh_a04_1 village

* prepare for export
	compress
	describe
	summarize
	sort hhid
	customsave , idvar(hhid) filename(HH_SECA.dta) ///
		path("$export") dofile(2014_HHSECA) user($user)

* close the log
	log	close

/* END */
