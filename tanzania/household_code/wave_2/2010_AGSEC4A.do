* Project: WB Weather
* Created on: April 2020
* Created by: McG
* Stata v.16

* does
	* cleans Tanzania household variables, wave 2 Ag sec4a
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
	loc root = "$data/household_data/tanzania/wave_2/raw"
	loc export = "$data/household_data/tanzania/wave_2/refined"
	loc logout = "$data/household_data/tanzania/logs"

* open log
	log using "`logout'/wv2_AGSEC4A", append

	
* ***********************************************************************
* 1 - TZA 2010 (Wave 2) - Agriculture Section 4A
* ***********************************************************************

* load data
	use "`root'/AG_SEC4A", clear

* rename variables of interest
	rename 			y2_hhid hhid
	rename 			zaocode crop_code
	
* check for missing values
	mdesc 				crop_code ag4a_15
	*** 2,205 obs missing crop code
	*** 2,528 obs missing harvest weight
	
* drop if crop code is missing
	drop				if crop_code == .
	*** 2,205 observations dropped

* drop if no harvest occured during long rainy season
	drop				if ag4a_06 != 1
	*** 322 obs dropped
	
* replace missing weight 
	replace 			ag4a_15 = 0 if ag4a_15 == .
	*** one change made

* generate unique identifier
	generate 			plot_id = hhid + " " + plotnum
	tostring 			crop_code, generate(crop_num)
	gen str23 			crop_id = hhid + " " + plotnum + " " + crop_num
	duplicates report 	crop_id
	*** no duplicate crop_ids
	
	isid				crop_id

* other variables of interest
	rename 				ag4a_15 wgt_hvsted
	rename				ag4a_16 hvst_value
	tab					hvst_value, missing
	*** hvst_value missing one observations
	
	tab					wgt_hvsted if hvst_value == . , missing
	*** when hvst_value = . , wgt_hvsted = 0
	*** if no weight is harvested, I'm comfortable setting harvest value to 0

	tab					crop_code if hvst_value == .
	*** just checking for fun, crop is tomatoes	
	
	replace				hvst_value = 0 if wgt_hvsted == 0 & hvst_value == .
	*** 1 change made

*currency conversion
	replace				hvst_value = hvst_value/1395.6249
	*** Value comes from World Bank: world_bank_exchange_rates.xlxs
	
* generate new varaible for measuring mize harvest
	gen					mz_hrv = wgt_hvsted if crop_code == 11
	gen					mz_damaged = 1 if crop_code == 11 & mz_hrv == 0
	tab					mz_damaged, missing
	*** one observation with damaged maize harvest leading to zero harvested
		
* collapse crop level data to plot level
	collapse (sum)		mz_hrv hvst_value mz_damaged, by(hhid plotnum plot_id)
	lab var				hvst_value "Value of harvest (2010 USD)"
	lab var				mz_hrv "Quantity of maize harvested (kg)"
	
* replace non-maize harvest values as missing
	tab					mz_damaged, missing
	replace				mz_hrv = . if mz_damaged == 0 & mz_hrv == 0
	drop 				mz_damaged
	*** 1,422 changes made
	
* keep what we want, get rid of what we don't
	keep 				hhid plotnum plot_id mz_hrv hvst_value

	isid				plot_id

* prepare for export
	compress
	describe
	summarize 
	sort plot_id
	customsave , idvar(plot_id) filename(AG_SEC4A.dta) path("`export'") ///
		dofile(2010_AGSEC4A) user($user)

* close the log
	log	close

/* END */