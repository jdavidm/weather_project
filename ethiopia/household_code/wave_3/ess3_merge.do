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
	use 			"`root'/PP_SEC9", clear

	isid			holder_id parcel field crop_code
	
* merge in crop labor data
	merge 			1:1 holder_id parcel field crop_code using "`root'/PP_SEC10", generate(_10A)
	*** all unmerged obs coming from using data w/ labor values = 0
	
	drop 			if _10A == 2
	
* merge in crop labor data
	merge 			1:1 holder_id parcel field crop_code using "`root'/PP_SEC4", generate(_4A)
	*** 3 obs not matched from master
	
	keep			if _4A == 3
	

* **********************************************************************
* 1b - merging in plot level input data
* **********************************************************************

* merge in crop labor data
	merge 			m:1 holder_id parcel field using "`root'/PP_SEC3", generate(_3A)
	*** 315 obs not matched from master
	
	keep			if _3A == 3