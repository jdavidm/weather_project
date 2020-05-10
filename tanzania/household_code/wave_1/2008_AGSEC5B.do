* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.16

* does
	* cleans Tanzania household variables, wave 1 Ag sec5b
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
	global root = "G:/My Drive/weather_project/household_data/tanzania/wave_1/raw"
	global export = "G:/My Drive/weather_project/household_data/tanzania/wave_1/refined"
	global logout = "C:/Users/$user/git/weather_project/tanzania/household_code/logs"

* open log
	log using "$logout/wv1_AGSEC5B", append


**********************************************************************************
**	TZA 2008 (Wave 1) - Agriculture Section 5B 
**********************************************************************************

* load data
	use 		"$root/SEC_5B", clear

* rename variables of interest
	rename 		zaocode crop_code

* generate unique ob id
	tostring 			crop_code, generate(crop_num)
	gen str20 			crop_id = hhid + " " + crop_num
	duplicates report	crop_id
* no duplicates
*	duplicates drop 	crop_id, force
	isid 				crop_id

* renaming sales variables
	rename 		s5bq2 wgt_sold
	label 		variable wgt_sold "What was the quanitity sold? (kg)"
	rename 		s5bq3 value_sold
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
customsave , idvar(crop_id) filename(AG_SEC5B.dta) path("$export") dofile(2008_AGSEC5B) user($user)

* close the log
	log	close

/* END */
