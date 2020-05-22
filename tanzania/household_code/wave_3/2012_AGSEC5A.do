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

* define paths
	loc root = "$data/household_data/tanzania/wave_3/raw"
	loc export = "$data/household_data/tanzania/wave_3/refined"
	loc logout = "$data/household_data/tanzania/logs"

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
	
* create a variable for price/kg
	generate 	price = value_sold/wgt_sold
	label 		variable price "Price per kg"
	
* merging in regional identifiers
	merge		m:1 hhid using "`export'/HH_SECA"
	tab			_merge
	drop		_merge

* generate unique set of regional unique ids
	sort		region
	egen 		region_id = group(region)
	sort		region district
	egen		district_id = group(region district)
	sort		region district ward 
	egen		ward_id = group(region district ward)
	sort		region district ward village
	egen		village_id = group(region district ward village)
	distinct	region_id district_id ward_id village_id

* collapse to district level to generate region average prices
* tried generating dist-evel averages, not enough observations for each crop type
* make datasets with crop price information
	preserve
	collapse 	(p50) p_v = price (count) n_v = price, by(crop_code region_id district_id ward_id village_id)
	save 		"`export'/ag_i2.dta", replace 
	restore
	preserve
	collapse 	(p50) p_w = price (count) n_w = price, by(crop_code region_id district_id ward_id)
	save 		"`export'/ag_i3.dta", replace 
	restore
	preserve
	collapse 	(p50) p_d = price (count) n_d = price, by(crop_code region_id district_id)
	save 		"`export'/ag_i4.dta", replace 
	restore
	preserve
	collapse 	(p50) p_r = price (count) n_r = price, by(crop_code region_id)
	save 		"`export'/ag_i5.dta", replace 
	restore
	preserve
	collapse 	(p50) p_c = price (count) n_crop = price, by(crop_code)
	save 		"`export'/ag_i6.dta", replace 
	restore

* drop variables to create village-crop panel
	keep		crop_code crop_num region- ward village ///
					region_id district_id ward_id village_id
	duplicates 	drop
	*** drops 2,740 duplicate observations
	
* drop observations with missing crop codes or crop code as "other"
	drop		if crop_code == . | crop_code == 998
	*** drops 1,585 observations


* merge price data back into dataset
	merge 		m:1 crop_code region_id district_id ward_id village_id ///
				using "`export'/ag_i2.dta"
	drop		if _merge != 3
	drop		_merge
	merge 		m:1 crop_code region_id district_id ward_id ///
				using "`export'/ag_i3.dta"
	drop		if _merge != 3
	drop		_merge
	merge 		m:1 crop_code region_id district_id ///
				using "`export'/ag_i4.dta"
	drop		if _merge != 3
	drop		_merge
	merge 		m:1 crop_code region_id ///
				using "`export'/ag_i5.dta"
	drop		if _merge != 3
	drop		_merge
	merge 		m:1 crop_code ///
				using "`export'/ag_i6.dta"
	drop		if _merge != 3
	drop		_merge
	*** this builds a data set where we have the following prices
	*** price for crops at village-crop level (p_v): 2,362 missing
	*** price for crops at ward-crop level (p_w): 1,828 missing
	*** price for crops at district-crop level (p_d): 835 missing
	*** price for crops at region-crop level (p_r): 264 missing
	*** price for crops at country-crop level (p_c): 0 missing

* no missing values to drop
	drop		if p_c == .
	*** this is now a crop by village level data set
	*** we can now merge this into 4A at the crop-village level
	
* prepare for export
	compress
	describe
	summarize 
	sort crop_code

	customsave , idvar(crop_code) filename(AG_SEC5A.dta) ///
		path("`export'") dofile(2012_AGSEC5A) user($user)

* close the log
	log	close

/* END */