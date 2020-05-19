* Project: WB Weather
* Created on: April 2020
* Created by: McG
* Stata v.16

* does
	* cleans Tanzania household variables, wave 2 Ag sec5a
	* crop sales data, long rainy season
	* generates weight sold, value sold, price
	
* assumes
	* customsave.ado

* TO DO:
	* completed

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root = "$data/household_data/tanzania/wave_2/raw"
	loc export = "$data/household_data/tanzania/wave_2/refined"
	loc logout = "$data/household_data/tanzania/logs"

* open log
	log using "`logout'/wv2_AGSEC5A", append

	
* ***********************************************************************
* 1 - TZA 2010 (Wave 2) - Agriculture Section 5A
* *********************1*************************************************

* load data
	use 		"`root'/AG_SEC5A", clear

* rename variables of interest
	rename 		y2_hhid hhid
	rename 		zaocode crop_code

* generate unique ob id
	tostring 			crop_code, generate(crop_num)
	gen str20 			crop_id = hhid + " " + crop_num
	duplicates report	crop_id
* no duplicates
*	duplicates drop 	crop_id, force
	isid 				crop_id

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
sort hhid
customsave , idvar(crop_id) filename(AG_SEC5A.dta) path("`export'") dofile(2010_AGSEC5A) user($user)

* close the log
	log	close

/* END */