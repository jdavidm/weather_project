* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 1 (2010-2011), POST HARVEST, NGA SECTA3 AG 
	* determines primary crop & cleans harvest
	* converts to kilograms
	* produces value of harvest (Naria) - need to include conversion to Naria 
	* outputs clean data file ready for combination with wave 1 hh data

* assumes
	* customsave.ado
	* harvconv.dta conversion file
	
* TO DO:
	* convert Naira to USD
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths	
	loc root 		= 		"$data/household_data/nigeria/wave_1/raw"
	loc cnvrt 		=		"$data/household_data/nigeria/conversion_files"
	loc export 		= 		"$data/household_data/nigeria/wave_1/refined"
	loc logout 		= 		"$data/household_data/nigeria/logs"

* close log 
	*log close
	
* open log	
	log using "`logout'/wave_1_ph_secta3", append
		

* **********************************************************************
* 1 - harvest information
* **********************************************************************

* import the first relevant data file
		use 				"`root'/secta3_harvestw1", clear 	

		rename 				sa3q2 cropcode
		tab 				cropcode
	*** main crop is "cassava old" 
	*** cassava is continuous cropping, so not using that as a main crop
	*** going to use maize, which is second most cultivated crop
	
		drop				if cropcode == . 
	***33 observations deleted
		rename 				sa3q1 cropname
	
	*find out who is not harvesting
	tab sa3q3
	
	* drop observations in which it was not harvest season or nothing was planted that season
	tab sa3q4
	drop if sa3q4==9
	***2,115 observations deleted
	
	drop if sa3q4b== "DID NOT PLANT IT" | sa3q4b=="FALLOW"  |   sa3q4b=="DRY SEASON PLANTING" 
	***2 observations deleted
	
	* convert missing harvest data to zero if harvest was lost to event
	replace			sa3q6a = 0 if sa3q6a == . & sa3q4b!= "DID NOT PLANT IT" 
	***795 real changes made
	replace			sa3q6a = 0 if sa3q6a == . & sa3q4b!="FALLOW"  
	replace			sa3q6a = 0 if sa3q6a == . & sa3q4b!="DRY SEASON PLANTING"
	***0 changes made
	
*value of harvest was not recorded in this wave.

*missing values for quantity of harvest
mdesc sa3q6a
*** no missing values


		describe
		sort 				hhid plotid cropid cropcode
		isid 				hhid plotid cropid cropcode, missok

		gen 				crop_area = sa3q5a
		label 				variable crop_area "what was the land area of crop harvested since the last interview? not using standardized unit"
		rename 				sa3q5b area_unit

* **********************************************************************
* 2 - conversion to kilograms
* **********************************************************************

* create quantity harvested variable
	gen 			harvestq = sa3q6a
	lab	var			harvestq "quantity harvested, not in standardized unit"

* units of harvest
	rename 			sa3q6b harv_unit
	tab				harv_unit, nolabel
	rename 			sa3q3 cultivated

	* create value variable
	gen 			crop_value = sa3q18
	rename 			crop_value vl_hrv

* convert 2013 Naria to constant 2010 USD
	replace			vl_hrv = vl_hrv/190.4143545
	lab var			vl_hrv 	"total value of harvest in 2010 USD"
	*** value comes from World Bank: world_bank_exchange_rates.xlxs

		merge m:1 cropcode harv_unit using "`cnvrt'/harvconv_wave_1"
	*** 1000 did not match from master
	
	tab cropname if conversion==.
	
	*** drop these unmatched - either not producing, no unit collected, or coming from merge conversion file 
	
	* drop unmerged using
	drop if			_merge == 2
	* dropped 2105

* check into 306 unmatched from master
	mdesc			harv_unit if _merge == 1
	tab 			harv_unit if _merge == 1
	drop if harv_unit==5
	***11 observations deleted
	***observations that did not match and were not missing the harv_unit were already in standard units.
	
	*dropping observations with missing harv_unit
	drop if harv_unit==.
	***1007 deleted
	
drop _merge

* make sure no missing values in conversion
	mdesc			conversion
	tab 			harv_unit if conversion == .
	*** missing observations were missing because their cropcode did not have a unit conversion for their units because their units were already standard

* replace missing conversion factors with 1 (for kg)
	replace			conversion = 1 if harv_unit == 1 & conversion==.
	***the above is the conversion for kgs
	replace 		conversion = 1 if harv_unit == 3 & conversion==.
	*** the above is the conversion for litres
	replace 		conversion = 1000 if harv_unit == 2 & conversion==.
	*** the above is the conversion for grams
	mdesc			conversion
	*** no more missing
	
	
*converting harvest quantities to kgs
gen harv_kg = harvestq*conversion
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
* 3 - end matter, collapse, clean up to save
* **********************************************************************


	isid			hhid plotid
	
* create unique household-plot identifier
	sort			hhid plotid
	egen			plot_id = group(hhid plotid)
	lab var			plot_id "unique plot identifier"
	
	compress
	describe
	summarize
	
	***there are obviously overestimates because the highest earning from maize is reported to be 400,000USD
	

* save file
		customsave , idvar(hhid) filename("ph_secta3.dta") ///
			path("`export'/`folder'") dofile(ph_secta3) user($user)
						
* close the log
	log	close

/* END */