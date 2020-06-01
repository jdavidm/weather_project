* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Edited by: erk
* Stata v.16

* does
	* reads in Nigeria, WAVE 1 (2010-2011) POST PLANTING, NIGERIA SECT 11D AG - fertilizer
	* measures fertilizer use in kgs
	* outputs clean data file ready for combination with wave 1 hh data

* assumes
	* customsave.ado
	
* other notes: 
	* still includes some notes from Alison Conley's work in spring 2020

* **********************************************************************
* 0 - setup
* **********************************************************************

* set global user
	global user "emilk"
	
* define paths	
	loc root = "G:/My Drive/weather_project/household_data/nigeria/wave_1/raw"
	loc export = "G:/My Drive/weather_project/household_data/nigeria/wave_1/refined"
	loc logout = "G:/My Drive/weather_project/household_data/nigeria/logs"

* close log (in case still open)
	*log close
	
* open log	
	log using "`logout'/pp_sect11d", append

* **********************************************************************
* 1 - determine fertilizer use 
* **********************************************************************
		
* import the first relevant data file
		use "`root'/sect11d_plantingw1", clear 

describe
sort hhid plotid
isid hhid plotid

rename s11dq1 fert_any 
label variable fert_any "=1 if any fertilizer was used"

* quantity of fertilizer from different sources
	*** the quantity is giving in kgs so no conversion is needed
	
generate leftover_fert_kg = s11dq4
replace leftover_fert_kg = 0 if leftover_fert_kg ==.

gen free_fert_kg=s11dq8
replace free_fert_kg = 0 if free_fert_kg ==. 

gen purchased_fert_kg1=s11dq15
replace purchased_fert_kg1 = 0 if purchased_fert_kg1 ==. 

gen purchased_fert_kg2=s11dq26
replace purchased_fert_kg2 = 0 if purchased_fert_kg2 ==. 

	* Combine all fertilizer sources
generate fert_used_kg = leftover_fert_kg + free_fert_kg + purchased_fert_kg1 + purchased_fert_kg2
label variable fert_used_kg "kilograms of fertilizer used from all sources"

* check for missing values
	mdesc			fert_any fert_use	
	*** no missing observations
	
* convert missing values to "no"
	replace			fert_any = 2 if fert_any == .

* **********************************************************************
* 2 - end matter, clean up to save
* **********************************************************************

	keep 			hhid zone state lga sector hhid ea plotid ///
					fert_any fert_use
	
* create unique household-plot identifier
	sort				hhid plotid
	egen				plot_id = group(hhid plotid)
	lab var				plot_id "unique plot identifier"
	
	compress
	describe
	summarize 
	
* save file
		customsave , idvar(hhid) filename("pp_sect11d.dta") ///
			path("`export'/`folder'") dofile(pp_sect11d) user($user)
*note on customsave issue - 2547 observation(s) are missing the ID variable hhid 

* close the log
	log	close

/* END */