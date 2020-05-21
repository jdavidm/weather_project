* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Edited by: ek
* Stata v.16

* does
	* reads in Nigeria, WAVE 2 (2012-2013), POST HARVEST, AG SECTA3
	* determines primary and secondary crops, cleans harvest (quantity and value)
	* converts to kilograms and constant 2010 USD
	* outputs clean data file ready for combination with wave 2 plot data

* assumes
	* customsave.ado
	* mdesc.ado
	* harvconv.dta conversion file

* TO DO:
	* complete

* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc 	root	= 	"$data/household_data/nigeria/wave_2/raw"
	loc		cnvrt	=	"$data/household_data/nigeria/conversion_files/wave_2"
	loc 	export	= 	"$data/household_data/nigeria/wave_2/refined"
	loc 	logout	= 	"$data/household_data/nigeria/logs"

* open log
	log 	using 	"`logout'/wave_2_ph_secta3", append

* **********************************************************************
* 1 - general clean up, renaming, etc.
* **********************************************************************

* import the first relevant data file
	use 			"`root'\secta3_harvestw2.dta" , clear

	tab 			cropcode
	*** main crop is "cassava old"
	*** not going to use cassava instead we use maize
	
* drop observations in which household had no harvest
	drop if 		sa3q3 == 2 | sa3q3 == . 
	*** drops 2988 observations

* check to see if there are missing observations for quantity and value
	mdesc 			sa3q6a1 sa3q18
	*** 41 missing values for quantity, 99 missing for value

* drop if missing both value and quantity
	drop if			sa3q6a1 == . & sa3q18 == .
	*** 20 observations deleted
	
	describe
	sort 			hhid plotid cropid cropcode
	isid 			hhid plotid cropid cropcode, missok

* **********************************************************************
* 2 - harvested amount and conversions
* **********************************************************************

* create quantity harvested variable
	gen 			harvestq = sa3q6a1
	lab	var			harvestq "quantity harvested, not in standardized unit"

* units of harvest
	rename 			sa3q6a2 harv_unit
	tab				harv_unit, nolabel
	rename 			sa3q3 cultivated

* create value variable
	gen 			crop_value = sa3q18
	rename 			crop_value tf_hrv

* convert 2013 Naria to constant 2010 USD
	replace			tf_hrv = tf_hrv/190.4143545
	lab var			tf_hrv 	"total value of harvest in 2010 USD"
	*** value comes from World Bank: world_bank_exchange_rates.xlxs

* merge harvest conversion file
	merge 			m:1 cropcode harv_unit using "`cnvrt'/harvconv.dta"
	*** matched 9634 but didn't match 2356 (from master 306 and using 2050)
	*** okay with mismatch in using - not every crop and unit are used in the master 
		
* drop unmerged using
	drop if			_merge == 2
	* dropped 2050

* check into 306 unmatched from master
	tab 			harv_unit if _merge == 1
	mdesc			harv_unit if _merge == 1
	*** 22 unmatched missing harv_unit
	*** 211 unmatched are already in kgs, so these are okay
	*** 73 unmatched have strange units

* dropped unmatched with missing or strange units
	drop if			_merge == 1 & harv_unit != 1
	*** dropped 95 observations (73 + 22)

	drop 			_merge

* make sure no missing values in conversion
	mdesc			conversion
	tab 			harv_unit if conversion == .
	*** there are 211 missing conversion factors
	*** all of these are kg

* replace missing conversion factors with 1 (for kg)
	replace			conversion = 1 if conversion == .
	mdesc			conversion
	*** no more missing
	
* converting harvest quantities to kgs
	gen 			harv_kg = harvestq*conversion
	mdesc 			harv_kg
	*** 7 missing

* check what the missing values have
	tab 			tf_hrv if harv_kg == .
	tab 			cropcode if harv_kg == .
	*** all have harvest value, but all are minor crops
	*** we will replace missing harv_kg with zero
	*** this allows us to collapse to plot while keeping tf_harv data

* replace missing values with zero
	replace			harv_kg = 0 if harv_kg == .
	replace			tf_hrv = 0	if tf_hrv == .
	*** replaced 7 values of kg and 72 for tf

* generate new variable that measures maize (1080) harvest
	gen 			cp_hrv = harv_kg 	if 	cropcode == 1080
	replace			cp_hrv = 0 			if	cp_hrv == .
	*** replaces non-maize crop quantity with zero to allow for collapsing
	
* collapse crop level data to plot level
	collapse (sum) 	cp_hrv tf_hrv, by(zone state lga sector ea hhid plotid)
	*** sum up cp_hrv and tf_hrv to the plot level, keeping spatial variables

* relabel variables
	lab var			tf_hrv 	"total value of harvest (2010 USD)"
	lab var			cp_hrv	"quantity of maize harvested (kg)"
	
* **********************************************************************
* 3 - end matter, clean up to save
* **********************************************************************

	isid			hhid plotid
	
* create unique household-plot identifier
	sort			hhid plotid
	egen			plot_id = group(hhid plotid)
	lab var			plot_id "unique plot identifier"
	
	compress
	describe
	summarize

* save file
	customsave , idvar(plot_id) filename("ph_secta3.dta") ///
		path("`export'") dofile(ph_secta3) user($user)

* close the log
	log		close

/* END */
