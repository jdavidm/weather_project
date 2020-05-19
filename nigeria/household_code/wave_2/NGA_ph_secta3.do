 * Project: WB Weather
* Created on: May 2020
* Created by: alj
* Edited by: ek
* Stata v.16

* does
	* reads in Nigeria, WAVE 2, POST HARVEST, NIGERIA AG SECTA3
	* determines primary and secondary crops, cleans harvest (quantity, hecatres)
	* converts to hectares and kilograms, as appropriate
	* maybe more who knows
	* outputs clean data file ready for combination with wave 2 hh data
	* casava is continuous cropping we wont use that instead we will use maize

* assumes
	* customsave.ado
	* harvconv.dta conversion file
	* land_conversion.dta conversion file 
	
* other notes: 
	* still includes some notes from Alison Conley's work in spring 2020
	
* TO DO:
	* need to convert Naira to USD
	* clarify "does" section

* **********************************************************************
* 0 - setup
* **********************************************************************

	* set global user
		global 		user 	"emilk"
	
	* define paths	
		loc 	root 	= 	"G:/My Drive/weather_project/household_data/nigeria/wave_2/raw"
		loc 	export 	= 	"G:/My Drive/weather_project/household_data/nigeria/wave_2/refined"
		loc 	logout 	= 	"G:/My Drive/weather_project/household_data/nigeria/logs"

	
	* open log	
		log 	using 	"`logout'/ph_secta3", append

* **********************************************************************
* 1 - general clean up, renaming, etc. 
* **********************************************************************
		
	* import the first relevant data file
		use 		"G:\My Drive\weather_project\household_data\nigeria\wave_2\raw\secta3_harvestw2.dta" , clear 	

		tab 		cropcode
	***main crop is "cassava old"
	*not going to use cassava instead we use maize

		describe
		sort 		hhid plotid cropid cropcode
		isid 		hhid plotid cropid cropcode, missok

* **********************************************************************
* 2 - harvested amount, land area, conversions, etc.
* **********************************************************************
	

	*we will also use this measure to get yield
		gen 		harvestq = sa3q6a1
		label 		variable harvestq "quantity harvested since last interview, not in standardized unit"

	*units of harvest
		rename 		sa3q6a2 harv_unit
		tab			harv_unit, nolabel
		rename 		sa3q3 cultivated

	* Naria needs to be converted to USD
		gen 		crop_value = sa3q18
		label 		variable crop_value 	"if you had sold all crop harvested since the last visit, what would be the total value in Naira?"
		rename 		crop_value tf_hrv 


	* define new paths for conversions	
		loc 	root = 	"G:/My Drive/weather_project/household_data/nigeria/conversion_files/"
		merge m:1 cropcode harv_unit using "`root'/harvconv"
		*matched 8673 but didn't match 6399 (from master 4275 and using 2124)

		keep 		if	 	_merge==3
		drop 				_merge

	*converting harvest quantities to kgs
		gen 		harv_kg = harvestq*harv_conversion
		order 		harvestq harv_unit harv_conversion harv_kg
		tab 		harv_kg, missing
		*6407 missing

		tab 		cultivated
		*yes = 9960 no = 2962 - could explain some of the data that didnt match ^^^

		gen 		cp_hrv = harv_kg	 if 	cropcode == 1080 

* **********************************************************************
* 3 - end matter, clean up to save
* **********************************************************************

	keep hhid ///
		zone ///
		state ///
		lga ///
		sector ///
		hhid ///
		ea ///
		plotid ///
		cropid ///
		cropcode ///
		cp_hrv ///
		tf_hrv ///


	compress
	describe
	summarize 

	* save file
		customsave , idvar(hhid) filename("ph_secta3.dta") ///
			path("`export'/`folder'") dofile(ph_secta3) user($user)

	* close the log
		log		close

/* END */