* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.16

* does
	* cleans Tanzania household variables, wave 3 hh secA
	* pulls regional identifiers

* assumes
	* customsave.ado

* TO DO:
	* completed


* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root = "$data/household_data/tanzania/wave_3/raw"
	loc export = "$data/household_data/tanzania/wave_3/refined"
	loc logout = "$data/household_data/tanzania/logs"

* open log
	log using "`logout'/wv3_HHSECA", append

* ***********************************************************************
* 1 - TZA 2012 (Wave 3) - Household Section A
* *********************1*************************************************

* load data
	use 			"`root'/HH_SEC_A", clear

* keep variables of interest
	keep 			occ- hh_a12_1

* renaming some variables
	rename		y3_hhid hhid
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
		path("`export'") dofile(2012_HHSECA) user($user)

* close the log
	log	close

/* END */