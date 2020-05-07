* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.16

* does
	* merges individual cleaned long rainy season household datasets together
	* wave 4 - tza
	
* assumes
	* previously cleaned household datasets
	* customsave.ado

* TO DO:
	* everything

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* set user
	global user "themacfreezie"

* define paths
	global root = "G:/My Drive/weather_project/household_data/tanzania/wave_4/refined"
	global export = "G:/My Drive/weather_project/household_data/tanzania/wave_4/refined"
	global logout = "G:/My Drive/weather_project/household_data/tanzania/logs"

* open log
	log using "$logout/NPSY4_A_MERGE", append
	
* **********************************************************************
* 1 - merging sections 2A and 3A and 4A
* **********************************************************************

* load data
	use 		"$root/AG_SEC4A", clear

* merging in section 3A & 2A
	merge		m:1 plot_id using "$root/AG_SEC3A"
* 70% of obs matched, most unmatched are missing values, fruits, or continuous crops
	tab			_merge
* dropping anything that didn't merged
* dropping any obs lacking harvest data
	drop		if wgt_hvsted == .
	drop		if _merge != 3
	drop		_merge
	merge		m:1 plot_id using "$root/AG_SEC2A"
	tab			_merge
	drop		if _merge != 3
	drop 		_merge

	drop		status mixedcrop_pct

* saving production dataset
	customsave , idvar(crop_id) filename(INT_PROD_A.dta) path("$export") dofile(NPSY4_A_MERGE) 	user($user) description(Intermediate file containing production data to be deleted later.)
	
* **********************************************************************
* 2 - collapsing section 5A to merge with INT_PROD_A
* **********************************************************************

* load data
	use 		"$root/AG_SEC5A", clear

* merging in regional identifiers
	merge		m:1 hhid using "$root/HH_SECA"
	tab			_merge
	drop		_merge
	
* drop anything that has a missing value for price
	tab			price, missing
	drop		if price == .
	
* generate unique district id
	sort		hh_a02_2
	egen		district_id = group(hh_a02_2)
	replace		district = district_id
	drop		district_id
	
* collapse to district level to generate region average prices
* tried generating dist-evel averages, not enough observations for each crop type
	collapse (mean)		price, by(region crop_code)
	
* generate country average prices
	egen				tza_price = mean(price), by(crop_code)
	
* saving production dataset
	customsave , idvar(region) filename(INT_PRICE_A.dta) path("$export") dofile(NPSY4_A_MERGE) 	user($user) description(Intermediate file containing country/regional average price data to be deleted later.)
	
* close the log
	log	close
	
/* END */

* some commentary:
* 2A and 2B are same variables but in different seasons
* merge all the As first, merge all the Bs first
* load int_prod_data and merge m:1 with regional price data (INT_PRICE_A)
* then append A big dataset with B big dataset
