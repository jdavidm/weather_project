* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.16

* does
	* cleans Tanzania household variables, wave 4 Ag sec5a
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
	loc root = "$data/household_data/tanzania/wave_4/raw"
	loc export = "$data/household_data/tanzania/wave_4/refined"
	loc logout = "$data/household_data/tanzania/logs"

* open log
	log using "`logout'/wv4_AGSEC5A", append
	

* ***********************************************************************
* 1 - TZA 2014 (Wave 4) - Agriculture Section 5A 
* *********************1*************************************************

* load data
	use 		"`root'/ag_sec_5a", clear

* rename variables of interest
	rename 		y4_hhid hhid
	rename 		zaocode crop_code

* generate unique ob id
	tostring 			crop_code, generate(crop_num)
	gen str20 			crop_id = hhid + " " + crop_num
	duplicates report	crop_id
*	three duplicate observations
*	duplicates drop 	crop_id, force
*	isid 				crop_id
* i don't think we want these dropped, obs look different

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
	sort		region district ward hh_a03_3a 
	egen		village_id = group(region district ward hh_a03_3a)
	distinct	region_id district_id ward_id village_id
	drop		region - hh_a12_1

* collapse to district level to generate region average prices
* tried generating dist-evel averages, not enough observations for each crop type
* make datasets with crop price information
	preserve
	collapse 	(p50) p_v = price (count) n_v = price, by(crop_id region_id district_id ward_id village_id)
	save 		"`export'/ag_i2.dta", replace 
	restore
	preserve
	collapse 	(p50) p_w = price (count) n_w = price, by(crop_id region_id district_id ward_id)
	save 		"`export'/ag_i3.dta", replace 
	restore
	preserve
	collapse 	(p50) p_d = price (count) n_d = price, by(crop_id region_id district_id)
	save 		"`export'/ag_i4.dta", replace 
	restore
	preserve
	collapse 	(p50) p_r = price (count) n_r = price, by(crop_id region_id)
	save 		"`export'/ag_i5.dta", replace 
	restore
	preserve
	collapse 	(p50) p_crop = price (count) n_crop = price, by(crop_id)
	save 		"`export'/ag_i6.dta", replace 
	restore


* merge price data back into dataset
	merge 		m:1 crop_id region_id district_id ward_id village_id ///
				using "`export'/ag_i2.dta", assert(3) nogenerate
	merge 		m:1 crop_id region_id district_id ward_id ///
				using "`export'/ag_i3.dta", assert(3) nogenerate
	merge 		m:1 crop_id region_id district_id ///
				using "`export'/ag_i4.dta", assert(3) nogenerate
	merge 		m:1 crop_id region_id ///
				using "`export'/ag_i5.dta", assert(3) nogenerate
	merge 		m:1 crop_id ///
				using "`export'/ag_i6.dta", assert(3) nogenerate
				
*	make imputed price, using median price where we have at least 10 observations
	generate 	pricei = .
	replace 	pricei = p_v if n_v>=10 & missing(pricei)
	replace 	pricei = p_w if n_w>=10 & missing(pricei)
	replace 	pricei = p_d if n_d>=10 & missing(pricei)
	replace 	pricei = p_r if n_r>=10 & missing(pricei)
	replace 	pricei = p_crop if missing(pricei)
	label 		variable pricei	"Imputed unit value of crop"

* generate country average prices
	egen				tza_price = mean(price), by(crop_code)

* keep what we want, get rid of what we don't
	keep 		hhid crop_code wgt_sold value_sold crop_id price
				
* prepare for export
compress
describe
summarize 
sort crop_id
customsave , idvar(crop_id) filename(AG_SEC5A.dta) path("`export'") dofile(2014_AGSEC5A) user($user)

* close the log
	log	close

/* END */