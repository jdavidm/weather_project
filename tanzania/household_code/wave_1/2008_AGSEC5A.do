* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.16

* does
	* cleans Tanzania household variables, wave 1 Ag sec5a
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
	loc root = "$data/household_data/tanzania/wave_1/raw"
	loc export = "$data/household_data/tanzania/wave_1/refined"
	loc logout = "$data/household_data/tanzania/logs"

* open log
	log using "`logout'/wv1_AGSEC5A", append


* **********************************************************************
* 1 - TZA 2008 (Wave 1) - Agriculture Section 5A 
* **********************************************************************

* load data
	use 		"`root'/SEC_5A", clear

* rename variables of interest
	rename 		zaocode crop_code

* generate unique ob id
	tostring 			crop_code, generate(crop_num)
 *** small issue, this is doing that weird thing again with stringing the crop code
 *** not doing it in 5b and the code looks exactly the same! what's with that?
	gen str20 			crop_id = hhid + " " + crop_num
	duplicates report	crop_id
* no duplicates
	isid 				crop_id

* renaming sales variables
	rename 		s5aq2 wgt_sold
	label 		variable wgt_sold "What was the quanitity sold? (kg)"
	rename 		s5aq3 value_sold
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
customsave , idvar(crop_id) filename(AG_SEC5A.dta) path("`export'") dofile(2008_AGSEC5A) user($user)

* close the log
	log	close

/* END */