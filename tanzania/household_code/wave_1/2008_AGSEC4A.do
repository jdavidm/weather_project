* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.15

* does
	* cleans Tanzania household variables, wave 1 Ag sec4a
	* kind of a crop roster, with harvest weights, long rainy season
	* generates weight harvested, harvest month, percentage of plot planted with given crop, value of seed purchases
	
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
	log using "`logout'/wv1_AGSEC4A", append

	
* **********************************************************************
* 1 - TZA 2008 (Wave 1) - Agriculture Section 4A 
* **********************************************************************

* load data
	use 		"`root'/SEC_4A", clear

* rename variables of interest
	rename 		zaocode crop_code

* generate unique identifier
	generate 			plot_id = hhid + " " + plotnum
	tostring 			crop_code, generate(crop_num)
	gen str21 			crop_id = hhid + " " + plotnum + " " + crop_num
	duplicates report 	crop_id
	*** no duplicates!
	
	isid 				crop_id

* generating mixed crop variable
	rename 		s4aq3 purestand
	generate 	mixedcrop_pct = .
	replace 	mixedcrop_pct = 100 if purestand == 1
	replace 	mixedcrop_pct = 75 if s4aq4 == 3
	replace 	mixedcrop_pct = 50 if s4aq4 == 2
	replace 	mixedcrop_pct = 25 if s4aq4 == 1
	tab			mixedcrop_pct, missing
	*** there are 519 obs missing mixedcrop_pct here
	
	tab 		mixedcrop_pct crop_code, missing
	by 			s4aq1, sort: tab mixedcrop_pct
	drop		if mixedcrop_pct == .
	*** all values missing were not harvested

* other variables of interest
	rename 		s4aq11_1 harvest_month
	rename 		s4aq15 wgt_hvsted
	label 		variable wgt_hvsted "What was the quanitity harvested? (kg)"

* keep what we want, get rid of what we don't
	keep 		hhid plotnum plot_id crop_id crop_code mixedcrop_pct harvest_month ///
				wgt_hvsted

* prepare for export
	compress
	describe
	summarize 
	sort crop_id
	customsave , idvar(crop_id) filename(AG_SEC4A.dta) path("`export'") ///
		dofile(2008_AGSEC4A) user($user)

* close the log
	log	close

/* END */