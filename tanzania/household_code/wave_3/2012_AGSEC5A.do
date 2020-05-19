* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.16

* does
	* cleans Tanzania household variables, wave 3 Ag sec5a
	* crop sales data, long rainy season
	* generates weight sold, value sold, price
	
* assumes
	* customsave.ado

* TO DO:
	* completed

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* set user
*	global user "themacfreezie"

* define paths
	loc root = "G:/My Drive/weather_project/household_data/tanzania/wave_3/raw"
	loc export = "G:/My Drive/weather_project/household_data/tanzania/wave_3/refined"
	loc logout = "G:/My Drive/weather_project/household_data/tanzania/logs"

* open log
	log using "`logout'/wv3_AGSEC5A", append

	
* ***********************************************************************
* 1 - TZA 2012 (Wave 3) - Agriculture Section 5A 
* *********************1*************************************************

* load data
	use 		"`root'/AG_SEC_5A", clear

* rename variables of interest
	rename 		y3_hhid hhid
	rename 		zaocode crop_code

* generate unique ob id
	tostring 			crop_code, generate(crop_num)
	gen str20 			crop_id = hhid + " " + crop_num
	duplicates report	crop_id
* five duplicates
*	duplicates drop 	crop_id, force
*	isid 				crop_id
* crop_id not unique, observations look different

* renaming sales variables
	rename 		ag5a_02 wgt_sold
	label 		variable wgt_sold "What was the quanitity sold? (kg)"
	rename 		ag5a_03 value_sold
	label 		variable value_sold "What was the total value of the sales? (T-shillings)"
	generate 	price = value_sold/wgt_sold
	label 		variable price "Price per kg"

* keep what we want, get rid of what we don't
	keep 		hhid crop_code wgt_sold value_sold crop_id price

* prepare for export
compress
describe
summarize 
sort crop_id
customsave , idvar(crop_id) filename(AG_SEC5A.dta) path("`export'") dofile(2012_AGSEC5A) user($user)

* close the log
	log	close

/* END */