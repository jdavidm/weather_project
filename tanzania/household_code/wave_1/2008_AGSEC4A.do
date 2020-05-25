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
	* mdesc.ado

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
	
* check for missing values
	mdesc 				crop_code s4aq15
	*** 1 obs missing crop code
	*** 522 obs missing harvest weight
	
* drop if crop code is missing
	drop				if crop_code == .
	*** 1 observations dropped

* drop if no harvest occured during long rainy season
	drop				if s4aq1 != 1
	*** 513 obs dropped
	
* replace missing weight 
	replace 			s4aq15 = 0 if s4aq15 == .
	*** 8 changes made

* generate unique identifier
	generate 			plot_id = hhid + " " + plotnum
	tostring 			crop_code, generate(crop_num)
	gen str23 			crop_id = hhid + " " + plotnum + " " + crop_num
	duplicates report 	crop_id
	*** no duplicate crop_ids
	
	isid				crop_id

* other variables of interest
	rename 				s4aq15 wgt_hvsted
	rename				s4aq16 hvst_value
	tab					hvst_value, missing
	*** hvst_value missing six observations
	
	tab					wgt_hvsted if hvst_value == . , missing
	*** six of seven obs w/ hvst_value = . where wgt_hvsted = 0
	*** if no weight is harvested, I'm comfortable setting harvest value to 0

	tab					crop_code if hvst_value == .
	*** maize, paddy (2), green gram, pigeon pea, coffee, pumpkins
	
	tab					crop_code if hvst_value == . & wgt_hvsted == 0
	*** paddy (2), green gram, pigeon pea, coffee, pumpkins
	*** no maize in six obs where wgt_hvsted == 0
	
	replace				hvst_value = 0 if wgt_hvsted == 0 & hvst_value == .
	*** 6 changes made
	
	tab					wgt_hvsted if hvst_value == . , missing
	tab					crop_code if hvst_value == .
	*** 1 observation left w/ missing hvst_value and weight given
	*** wgt_hvsted = 5400, crop_cope == 11 (Maize)
	*** what to do about this?
	
* currency conversion
	replace				hvst_value = hvst_value/1169.62042
	*** Value comes from World Bank: world_bank_exchange_rates.xlxs
	
* generate new varaible for measuring mize harvest
	gen					mz_hrv = wgt_hvsted if crop_code == 11
	gen					mz_damaged = 1 if crop_code == 11 & mz_hrv == 0
	tab					mz_damaged, missing
	*** five obs with damaged maize harvest leading to zero harvested
		
* collapse crop level data to plot level
	collapse (sum)		mz_hrv hvst_value mz_damaged, by(hhid plotnum plot_id)
	lab var				hvst_value "Value of harvest (2010 USD)"
	lab var				mz_hrv "Quantity of maize harvested (kg)"
	
* replace non-maize harvest values as missing
	tab					mz_damaged, missing
	replace				mz_hrv = . if mz_damaged == 0 & mz_hrv == 0
	drop 				mz_damaged
	*** 1,492 changes made
	
* keep what we want, get rid of what we don't
	keep 				hhid plotnum plot_id mz_hrv hvst_value

	isid				plot_id

* prepare for export
	compress
	describe
	summarize 
	sort plot_id
	customsave , idvar(plot_id) filename(AG_SEC4A.dta) path("`export'") ///
		dofile(2008_AGSEC4A) user($user)

* close the log
	log	close

/* END */