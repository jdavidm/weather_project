* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.16

* does
	* cleans Tanzania household variables, wave 3 Ag sec4a
	* kind of a crop roster, with harvest weights, long rainy season
	
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
	log using "$logout/wv3_AGSE4A", append

* ***********************************************************************
* 1 - TZA 2012 (Wave 3) - Agriculture Section 4A 
* *********************1*************************************************

* load data
	use 				"$root/AG_SEC_4A", clear

* rename variables of interest
	rename 				y3_hhid hhid
	rename				zaocode crop_code

* generate unique identifier 
	generate 			plot_id = hhid + " " + plotnum
	tostring 			crop_code, generate(crop_num) format(%03.0g) force
	generate 			crop_id = hhid + " " + plotnum + " " + crop_num
	duplicates report	 crop_id
* crop_id not unique, 6 duplicates 
	duplicates drop 	crop_id, force
	isid 				crop_id
	
* generating mixed crop variable
	rename 				ag4a_01 purestand
	generate 			mixedcrop_pct = .
	replace 			mixedcrop_pct = 100 if purestand == 1
	replace 			mixedcrop_pct = 75 if ag4a_02 == 3
	replace 			mixedcrop_pct = 50 if ag4a_02 == 2
	replace 			mixedcrop_pct = 25 if ag4a_02 == 1
* there are 2,251 missing obs here
	tab 				mixedcrop_pct crop_code, missing
* 2,249 of these are also missing crop codes
* assuming these fields are fallow
	sort 				crop_code
	drop 				if mixedcrop_pct == .
* dropped all observations missing mixedcrop_pct, including two with crop_code

* other variables of interest
	rename 				ag4a_24_1 harvest_month
	rename 				ag4a_28 wgt_hvsted
	label 				variable wgt_hvsted "What was the quanitity harvested? (kg)"
	rename 				ag4a_12 value_seed_purch
	generate 			season = 0
* see if you can find quantity purchased and quantity of old seeds used to derive total value seeds used

* keep what we want, get rid of what we don't
	keep 				hhid plotnum crop_id crop_code mixedcrop_pct ///
						harvest_month wgt_hvsted value_seed_purch season


* prepare for export
compress
describe
summarize 
sort crop_id
customsave , idvar(crop_id) filename(AG_SEC4A.dta) path("$export") dofile(2012_AGSEC4A) user($user)

* close the log
	log	close

/* END */