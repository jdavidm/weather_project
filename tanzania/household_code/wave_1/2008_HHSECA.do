* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.16

* does
	* cleans Tanzania household variables, wave 1 hh secA
	* pulls regional identifiers
	
* assumes
	* customsave.ado

* TO DO:
	* completed

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root = "$data/household_data/tanzania/wave_1/raw"
	loc export = "$data/household_data/tanzania/wave_1/refined"
	loc logout = "$data/household_data/tanzania/logs"

* open log
	log using "`logout'/wv1_HHSECA", append

* ***********************************************************************
* 1 - TZA 2008 (Wave 1) - Household Section A
* *********************1*************************************************

* load data
	use 		"`root'/SEC_A_T", clear

* keep variables of interest
	keep 		hhid region district ward locality ea
	order		hhid region district ward locality ea
	
* prepare for export
	compress
	describe
	summarize 
	sort hhid
	customsave , idvar(hhid) filename(HH_SECA.dta) ///
		path("`export'") dofile(2008_HHSECA) user($user)

* close the log
	log	close

/* END */