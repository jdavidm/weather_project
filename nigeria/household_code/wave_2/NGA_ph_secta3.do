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

* find out who is not harvesting and why
	tab				sa3q3
	tab				sa3q4
	tab				sa3q4b
	
* drop observations in which it was not harvest season
	drop if 		sa3q4 == 9 | sa3q4 == 10 | sa3q4 == 11
	*** drops 2517 observations

* convert missing harvest data to zero if harvest was lost to event
	replace			sa3q6a1 = 0 if sa3q6a1 == . & sa3q4 < 9
	replace			sa3q18  = 0 if sa3q18  == . & sa3q4 < 9
	*** 443 missing changed to 0

* drop if missing both quantity and values
	drop			if sa3q6a1 == . & sa3q18 == .
	*** dropped 49 observations

* replace missing quantity if value is not missing
	replace			sa3q6a1 = 0 if sa3q6a1 == . & sa3q18 != .
	*** 21 missing changed to zero
	
* replace missing value if quantity is not missing
	replace			sa3q18 = 0 if sa3q18 == . & sa3q6a1 != .
	*** 79 missing changed to zero
	
* check to see if there are missing observations for quantity and value
	mdesc 			sa3q6a1 sa3q18
	*** no missing values
	
	describe
	sort 			hhid plotid cropid
	isid 			hhid plotid cropid

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
	rename 			crop_value vl_hrv

* convert 2013 Naria to constant 2010 USD
	replace			vl_hrv = vl_hrv/190.4143545
	lab var			vl_hrv 	"total value of harvest in 2010 USD"
	*** value comes from World Bank: world_bank_exchange_rates.xlxs

* merge harvest conversion file
	merge 			m:1 cropcode harv_unit using "`cnvrt'/harvconv.dta"
	*** matched 9633 but didn't match 2799 (from master 749 and using 2050)
	*** okay with mismatch in using - not every crop and unit are used in the master 
		
* drop unmerged using
	drop if			_merge == 2
	* dropped 2050

* check into 306 unmatched from master
	mdesc			harv_unit if _merge == 1
	tab 			harv_unit if _merge == 1
	*** 465 unmatched missing harv_unit, all but one are zeros (assume other is kg)
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
	*** no missing

* generate new variable that measures maize (1080) harvest
	gen 			mz_hrv = harv_kg 	if 	cropcode > 1079 & cropcode < 1084
	replace			mz_hrv = 0 			if	mz_hrv == .
	*** replaces non-maize crop quantity with zero to allow for collapsing
	
* collapse crop level data to plot level
	collapse (sum) 	mz_hrv vl_hrv, by(zone state lga sector ea hhid plotid)
	*** sum up cp_hrv and tf_hrv to the plot level, keeping spatial variables

* relabel variables
	lab var			vl_hrv 	"total value of harvest (2010 USD)"
	lab var			mz_hrv	"quantity of maize harvested (kg)"
	
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
