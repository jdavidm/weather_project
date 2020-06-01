* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.16

* does
	* cleans Tanzania household variables, wave 4 Ag sec4a
	* kind of a crop roster, with harvest weights, long rainy season
	* generates weight harvested, harvest month, percentage of plot planted with given crop, value of seed purchases
	
* assumes
	* customsave.ado
	* mdesc.ado

* TO DO:
	* completed

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root = "$data/household_data/tanzania/wave_4/raw"
	loc export = "$data/household_data/tanzania/wave_4/refined"
	loc logout = "$data/household_data/tanzania/logs"

* open log
	log using "`logout'/wv4_AGSEC4A", append


* ***********************************************************************
* 1 - TZA 2014 (Wave 4) - Agriculture Section 4A 
* *********************1*************************************************

* load data
	use 		"`root'/ag_sec_4a", clear

* rename variables of interest
	rename 		y4_hhid hhid
	rename 		zaocode crop_code
	
* check for missing values
	mdesc 				crop_code ag4a_28
	*** 1,541 obs missing crop code
	*** 1,721 obs missing harvest weight
	
* drop if crop code is missing
	drop				if crop_code == .
	*** 1,541 observations dropped

* drop if no harvest occured during long rainy season
	drop				if ag4a_19 != 1
	*** 181 obs dropped
	
* replace missing weight 
	replace 			ag4a_28 = 0 if ag4a_28 == .
	*** 0 changes made

* generate unique identifier
	generate 			plot_id = hhid + " " + plotnum
	tostring 			crop_code, generate(crop_num)
	gen str23 			crop_id = hhid + " " + plotnum + " " + crop_num
	duplicates report 	crop_id
	*** six duplicate crop_ids

* other variables of interest
	rename 				ag4a_28 wgt_hvsted
	rename				ag4a_29 hvst_value
	tab					hvst_value, missing
	*** hvst_value missing no observations
	
* currency conversion
	replace				hvst_value = hvst_value/2012.06173
	*** Value comes from World Bank: world_bank_exchange_rates.xlxs
	
* generate new varaible for measuring mize harvest
	gen					mz_hrv = wgt_hvsted if crop_code == 11
	gen					mz_damaged = 1 if crop_code == 11 & mz_hrv == 0
	tab					mz_damaged, missing
	*** no obs with damaged maize harvest leading to zero harvested
		
* collapse crop level data to plot level
	collapse (sum)		mz_hrv hvst_value mz_damaged, by(hhid plotnum plot_id)
	lab var				hvst_value "Value of harvest (2010 USD)"
	lab var				mz_hrv "Quantity of maize harvested (kg)"
	
* replace non-maize harvest values as missing
	tab					mz_damaged, missing
	replace				mz_hrv = . if mz_damaged == 0 & mz_hrv == 0
	drop 				mz_damaged
	*** 1,083 changes made
	
* keep what we want, get rid of what we don't
	keep 				hhid plotnum plot_id mz_hrv hvst_value

	isid				plot_id

* prepare for export
	compress
	describe
	summarize 
	sort plot_id
	customsave , idvar(plot_id) filename(AG_SEC4A.dta) path("`export'") ///
		dofile(2014_AGSEC4A) user($user)

* close the log
	log	close

/* END */