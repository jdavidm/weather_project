* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Edited by: ek
* Stata v.16

* does
	* reads in Nigeria, WAVE 2, POST HARVEST, NIGERIA AG SECTA3
	* determines primary and secondary crops, cleans harvest (quantity and value)
	* converts to kilograms and constant 2010 USD
	* outputs clean data file ready for combination with wave 2 hh data

* assumes
	* customsave.ado
	* harvconv.dta conversion file

* TO DO:
	* need to convert Naira to USD
	* collapse to plot level

* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
		loc 	root		= 	"$data/household_data/nigeria/wave_2/raw"
		loc		cnvrt		=		"$data/household_data/nigeria/conversion_files"
		loc 	export	= 	"$data/household_data/nigeria/wave_2/refined"
		loc 	logout	= 	"$data/household_data/nigeria/logs"

* open log
		log 	using 	"`logout'/ph_secta3", append

* **********************************************************************
* 1 - general clean up, renaming, etc.
* **********************************************************************

* import the first relevant data file
		use 					"`root'\secta3_harvestw2.dta" , clear

		tab 					cropcode
	*** main crop is "cassava old"
	*** not going to use cassava instead we use maize

		describe
		sort 					hhid plotid cropid cropcode
		isid 					hhid plotid cropid cropcode, missok

* **********************************************************************
* 2 - harvested amount and conversions
* **********************************************************************

* create quantity harvested variable
		gen 					harvestq = sa3q6a1
		lab	var				harvestq "quantity harvested, not in standardized unit"

* units of harvest
		rename 				sa3q6a2 harv_unit
		tab						harv_unit, nolabel
		rename 				sa3q3 cultivated

* create value variable
		gen 					crop_value = sa3q18
		lab var				crop_value 	"if you had sold all crop harvested, what would be the total value in Naira?"
		rename 				crop_value tf_hrv
		*** Naria needs to be converted to USD

* merge harvest conversion file
		merge 				m:1 cropcode harv_unit using "`cnvrt'/harvconv.dta"
		*** matched 8673 but didn't match 6399 (from master 4275 and using 2124)
		*** why didn't these merge? Is dropping the right thing to do?

		keep 					if _merge == 3
		drop 					_merge

* converting harvest quantities to kgs
		gen 					harv_kg = harvestq*harv_conversion
		order 				harvestq harv_unit harv_conversion harv_kg
		tab 					harv_kg, missing
		*** 6407 missing
		*** are any of these maize?

		tab 					cultivated
		*** yes = 9960 no = 2962 - could explain some of the data that didnt match ^^^

* generate new variable that measures maize (1080) harvest
		gen 					cp_hrv = harv_kg	 if 	cropcode == 1080

* collpapsecrop level data to plot level...

* **********************************************************************
* 3 - end matter, clean up to save
* **********************************************************************

		keep 					hhid zone state lga sector hhid ea plotid cropid ///
									cropcode cp_hrv tf_hrv

		compress
		describe
		summarize

* save file
		customsave , idvar(hhid) filename("ph_secta3.dta") ///
			path("`export'/`folder'") dofile(ph_secta3) user($user)

* close the log
		log		close

/* END */
