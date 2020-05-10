* Project: WB Weather
* Created on: April 2020
* Created by: McG
* Stata v.16

* does
	* cleans Tanzania household variables, wave 2 Ag sec4a
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
	global root = "G:/My Drive/weather_project/household_data/tanzania/wave_2/raw"
	global export = "G:/My Drive/weather_project/household_data/tanzania/wave_2/refined"
	global logout = "G:/My Drive/weather_project/household_data/tanzania/logs"

* open log
	log using "$logout/wv2_AGSE4A", append

* ***********************************************************************
* 1 - TZA 2010 (Wave 2) - Agriculture Section 4A
* *********************1*************************************************

* load data
	use "$root/AG_SEC4A", clear

* rename variables of interest
	rename 		y2_hhid hhid
	rename 		zaocode crop_code

* generate unique identifier
	generate 			plot_id = hhid + " " + plotnum
	tostring 			crop_code, generate(crop_num)
	gen str23 			crop_id = hhid + " " + plotnum + " " + crop_num
	duplicates report 	crop_id
* no duplicates!
	isid 				crop_id

* generating mixed crop variable
	rename 		ag4a_01 purestand
	generate 	mixedcrop_pct = .
	replace 	mixedcrop_pct = 100 if purestand == 1
	replace 	mixedcrop_pct = 75 if ag4a_02 == 3
	replace 	mixedcrop_pct = 50 if ag4a_02 == 2
	replace 	mixedcrop_pct = 25 if ag4a_02 == 1
* there are 4,951 missing obs here
	tab 		mixedcrop_pct crop_code, missing
* all of these are also missing crop codes
* assuming these fields are fallow
	sort 		crop_code
* should they be dropped? All these obs seem to have no other info
* probably so
	drop 		if crop_code == . 

* other variables of interest
	rename 		ag4a_11_1 harvest_month
	rename 		ag4a_15 wgt_hvsted
	label 		variable wgt_hvsted "What was the quanitity harvested? (kg)"
	rename 		ag4a_21 value_seed_purch
	generate 	season = 1
* see if you can find quantity purchased and quantity of old seeds used to derive total value seeds used

* keep what we want, get rid of what we don't
	keep 		hhid plotnum plot_id crop_id crop_code mixedcrop_pct harvest_month ///
				wgt_hvsted value_seed_purch season

* prepare for export
compress
describe
summarize 
sort crop_id
customsave , idvar(crop_id) filename(AG_SEC4A.dta) path("$export") dofile(2010_AGSEC4A) user($user)

* close the log
	log	close
	
/* END */