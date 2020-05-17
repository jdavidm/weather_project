* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.16

* does
	* cleans Tanzania household variables, wave 4 Ag sec5b
	* crop sales data, short rainy season
	
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
	log using "$logout/wv4_AGSEC5B", append

* ***********************************************************************
* 1 - TZA 2014 (Wave 4) - Agriculture Section 5B 
* *********************1*************************************************

* load data
	use 		"$root/ag_sec_5b", clear

* rename variables of interest
	rename 		y4_hhid hhid
	rename 		zaocode crop_code

* generate unique ob id
	tostring 			crop_code, generate(crop_num)
	gen str20 			crop_id = hhid + " " + crop_num
	duplicates report	crop_id
* one duplicate!
*	duplicates drop 	crop_id, force
*	isid 				crop_id
* crop_id not unique, observations look different

* renaming sales variables
	rename 		ag5b_02 wgt_sold
	label 		variable wgt_sold "What was the quanitity sold? (kg)"
	rename 		ag5b_03 value_sold
	label 		variable value_sold "What was the total value of the sales? (T-shillings)"
	generate 	price = value_sold/wgt_sold
	label 		variable price "Price per kg"
	
*generate seasonal variable
	generate 	season = 1

* keep what we want, get rid of what we don't
	keep 		hhid crop_code wgt_sold value_sold crop_id price season
				
* prepare for export
compress
describe
summarize 
sort crop_id
customsave , idvar(crop_id) filename(AG_SEC5B.dta) path("$export") dofile(2014_AGSEC5B) user($user)

* close the log
	log	close

/* END */