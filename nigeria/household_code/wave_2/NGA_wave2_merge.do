* Project: WB Weather
* Created on: May 2020
* Created by: jdm
* Stata v.16

* does
	* merges individual cleaned plot datasets together
	* collapses to wave 2 plot level data to household level for combination with other waves

* assumes
	* previously cleaned household datasets
	* customsave.ado

* TO DO:
	* everything


* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		root	=	"$data/household_data/nigeria/wave_2/refined"
	loc 	export	=	"$data/household_data/nigeria/wave_2/refined"
	loc 	logout	=	"$data/household_data/nigeria/logs"

* open log
	*log 	using 	"`logout'/NGA_wave_2_merge", append

	
* **********************************************************************
* 1 - merge plot level data sets together
* **********************************************************************

* load plot size data
	use 			"`root'/pp_sect11a1", clear

	isid			hhid plotid
	
* merging in irrigation data
	merge			1:1 hhid plotid using "`root'/pp_sect11b1"
	*** only 17 out of 5876 not merged (0.2%)
	*** we assume these are plots without irrigation
	
	replace			irr_any = 2 if irr_any == .
	*** 17 changes made
	
	drop			plot_id _merge

* mergining in planting labor data
	merge		1:1 hhid plotid using "`root'/pp_sect11c1"
	*** 221 from master and 4 from using not matched (4%)
	*** not clear what to do with these, so we will keep them for the moment

	rename			_merge merge_pplab
	drop			plot_id

* mergining in pesticide and herbicide use
	merge		1:1 hhid plotid using "`root'/pp_sect11c2"
	*** 101 from master not merged (2%)
	*** we assume these are plots without pest or herb

	replace			pest_any = 2 if pest_any == .
	replace			herb_any = 2 if herb_any == .
	*** 101 changes made
	
	drop			plot_id _merge

* mergining in fertilizer use
	merge		1:1 hhid plotid using "`root'/pp_sect11d"
	*** 128 from master not merged (2%)
	*** as above, since a majority don't use fert, we assume missing means no fert

	replace			fert_any = 2 if fert_any == .
	replace			fert_use = 2 if fert_use == .
	*** 128 changes made
	
	drop			plot_id _merge

* mergining in harvest labor data
	merge		1:1 hhid plotid using "`root'/ph_secta2"
	*** 201 from master and 223 from using not merged (7%)
	*** like before, not clear is these are zero labor

	rename			_merge merge_hvlab
	drop			plot_id

* mergining in harvest quantity and value
	merge		1:1 hhid plotid using "`root'/ph_secta3"
	*** 1020 from master and 2 from using not merged (20%)


	
* dropping anything that didn't merged
* dropping any obs lacking harvest data
	drop		if wgt_hvsted == .
	drop		if _merge != 3
	drop		_merge
	merge		m:1 plot_id using "`root'/AG_SEC2A"
	tab			_merge
	drop		if _merge != 3
	drop 		_merge

	drop		status mixedcrop_pct

* saving production dataset
	customsave , idvar(crop_id) filename(INT_PROD.dta) path("`export'") ///
		dofile(NPSY4_MERGE) 	user($user) ///
		description(Intermediate file containing production data to be deleted later.)

* **********************************************************************
* 2 - collapsing section 5A to merge with INT_PROD
* **********************************************************************

* load data
	use 		"`root'/AG_SEC5A", clear

* merging in regional identifiers
	merge		m:1 hhid using "`root'/HH_SECA"
	tab			_merge
	drop		_merge

* drop anything that has a missing value for price
	tab			price, missing
	drop		if price == .

* generate unique district id
	sort		hh_a02_2
	egen		district_id = group(hh_a02_2)
	replace		district = district_id
	drop		district_id

* collapse to district level to generate region average prices
* tried generating dist-evel averages, not enough observations for each crop type
	collapse (p50)		price, by(region crop_code)

* generate country average prices
	egen				tza_price = mean(price), by(crop_code)

* saving production dataset
	customsave , idvar(region) filename(INT_PRICE_A.dta) path("$export") dofile(NPSY4_A_MERGE) 	user($user) description(Intermediate file containing country/regional average price data to be deleted later.)

* close the log
	log	close

/* END */

* some commentary:
* 2A and 2B are same variables but in different seasons
* merge all the As first, merge all the Bs first
* load int_prod_data and merge m:1 with regional price data (INT_PRICE_A)
* then append A big dataset with B big dataset
