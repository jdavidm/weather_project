* Project: WB Weather
* Created on: July 2020
* Created by: mcg
* Stata v.16

* does
	* merges individual cleaned plot datasets together
	* imputes values for continuous variables
	* collapses wave 3 plot level data to household level for combination with other waves

* assumes
	* previously cleaned household datasets
	* customsave.ado

* TO DO:
	* everything


* **********************************************************************
* 0 - setup
* **********************************************************************

* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root = "$data/household_data/ethiopia/wave_3/refined"
	loc export = "$data/household_data/ethiopia/wave_3/refined"
	loc logout = "$data/household_data/ethiopia/logs"

* open log
	cap log close
	log using "`logout'/ess3_merge", append


* **********************************************************************
* 1 - merging data sets
* **********************************************************************	
	
* **********************************************************************
* 1a - merge crop level data sets together
* **********************************************************************

* start by loading harvest quantity and value, since this is our limiting factor
	use 			"`root'/PH_SEC9", clear

	isid			holder_id parcel field crop_code
	
* merge in crop labor data
	merge 			1:1 holder_id parcel field crop_code using "`root'/PH_SEC10", generate(_10A)
	*** all unmerged obs coming from using data w/ labor values = 0
	
	drop 			if _10A == 2
	
* merge in crop labor data
	merge 			1:1 holder_id parcel field crop_code using "`root'/PP_SEC4", generate(_4A)
	*** 3 obs not matched from master
	
	keep			if _4A == 3
	
	
* ***********************************************************************
* 1b - pulling in fruit/root/nut harvest quantities
* ***********************************************************************	

* merge in fruit and nut trees (no field or parcel data provided)

* first let's see what we hve so far
	summarize
	
* append fruit/root data
	append		using "`export'/PH_SEC12.dta"
	

* ***********************************************************************
* 1b - pulling in prices fom price datasets
* ***********************************************************************	

* merging in sec 11 price data
* merging in ea level price data	
	merge 		m:1 crop_code region zone woreda ea using "`export'/w3_sect11_pea.dta"

	drop 		if _merge == 2
	drop 		_merge	
	
* merging in woreda level price data	
	merge 		m:1 crop_code region zone woreda using "`export'/w3_sect11_pworeda.dta"
	
	drop 		if _merge == 2
	drop 		_merge	
	
* merging in zone level price data	
	merge 		m:1 crop_code region zone using "`export'/w3_sect11_pzone.dta"
	
	drop 		if _merge == 2
	drop 		_merge	
	
* merging in region level price data	
	merge 		m:1 crop_code region using "`export'/w3_sect11_pregion.dta"
	
	drop 		if _merge == 2
	drop 		_merge	
	
* merging in crop level price data	
	merge 		m:1 crop_code using "`export'/w3_sect11_pcrop.dta"
	
	drop 		if _merge == 2
	drop 		_merge	
	
* generating implied crop values, using sec 11 median price whee we have 10+ obs
	gen			croppricei = .
	
	replace 	croppricei = p_ea if n_ea>=10 & missing(croppricei)
	*** 0 replaced
	
	replace 	croppricei = p_woreda if n_woreda>=10 & missing(croppricei)
	*** 0 replaced
	
	replace 	croppricei = p_zone if n_zone>=10 & missing(croppricei)
	*** 1 replaced 
	
	replace 	croppricei = p_region if n_region>=10 & missing(croppricei)
	*** 3 replaced
	
	replace 	croppricei = p_crop if missing(croppricei)
	*** 1,106 replaced 

* examine the results
	sum			hvst_qty croppricei
	*** still missing prices for 1,116 obs
	*** assuming these missing prices all come from the same group of crops
	
	tab crop_code if croppricei != .
	tab crop_code if croppricei == .
	*** fennel, cardamon*, chilies*, ginger*, RED PEPPER*, tumeric*, BEER ROOT*,
	*** carrot*, kale*, lettuce, pumpkin*, spinach*, coriander*, TIMEZ KIMEM
	*** none of these crops appear when price isn't missing
	*** those w/ asterisks have price info in section 12

* merging in sec 12 price data	
	drop 		p_ea- n_crop
	
* merging in ea level price data	
	merge 		m:1 crop_code region zone woreda ea using "`export'/w3_sect12_pea.dta"

	drop 		if _merge == 2
	drop 		_merge	
	
* merging in woreda level price data	
	merge 		m:1 crop_code region zone woreda using "`export'/w3_sect12_pworeda.dta"
	
	drop 		if _merge == 2
	drop 		_merge	
	
* merging in zone level price data	
	merge 		m:1 crop_code region zone using "`export'/w3_sect12_pzone.dta"
	
	drop 		if _merge == 2
	drop 		_merge	
	
* merging in region level price data	
	merge 		m:1 crop_code region using "`export'/w3_sect12_pregion.dta"

	drop 		if _merge == 2
	drop 		_merge	
	
* merging in crop level price data	
	merge 		m:1 crop_code using "`export'/w3_sect12_pcrop.dta"	
	
	drop 		if _merge == 2
	drop 		_merge	
	
* generating implied crop values, using sec 12 median price whee we have 10+ obs	
	replace 	croppricei = p_ea if n_ea>=10 & missing(croppricei)
	*** 22 replaced
	
	replace 	croppricei = p_woreda if n_woreda>=10 & missing(croppricei)
	*** 15 replaced
	
	replace 	croppricei = p_zone if n_zone>=10 & missing(croppricei)
	*** 44 replaced 
	
	replace 	croppricei = p_region if n_region>=10 & missing(croppricei)
	*** 632 replaced
	
	replace 	croppricei = p_crop if missing(croppricei)
	*** 395 replaced 
	
* checking results
	sum			hvst_qty croppricei
	*** still missing prices for over 1,788
	*** assuming these missing prices all come from the same group of crops
	
	tab 		crop_code if croppricei != .
	tab 		crop_code if croppricei == .
	*** still missing prices for fennel, lettuce, timiz kenem
	*** 8 obs total - no prices in either sec 11 or 12
	*** will drop
	
	drop		if croppricei == .
	drop		p_ea- n_crop
		
	
* ***********************************************************************
* 1c - finding harvest values
* ***********************************************************************	
	
	summarize
	
* creating harvest values
	generate			hvst_value = hvst_qty*croppricei 

* currency conversion
	replace				hvst_value = hvst_value/26.67018592
	lab var				hvst_value "Value of Harvest (2010 USD)"
	

* **********************************************************************
* 1d - merging in plot level input data
* **********************************************************************

* merge in crop labor data
	merge 			m:1 holder_id parcel field using "`root'/PP_SEC3", generate(_3A)
	*** 315 obs not matched from master
	
	keep			if _3A == 3