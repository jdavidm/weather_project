* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Edited by: erk
* Stata v.16

* does
	* reads in Nigeria, WAVE 1 (2010-2011) POST PLANTING, NIGERIA SECT 11C
	* determines herbicide and pesticide use 
	* maybe more who knows
	* outputs clean data file ready for combination with wave 1 hh data

* assumes
	* customsave.ado
	
* other notes: 
	* still includes some notes from Alison Conley's work in spring 2020
	
* TO DO:
	* unsure - incomplete, runs but maybe not right? 
	* clarify "does" section

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
	log using "`logout'/pp_sect11c", append

* **********************************************************************
* 1 - determine pesticide and herbicide use 
* **********************************************************************
		
* import the first relevant data file
		use "`root'/sect11c_plantingw1", clear 	

describe
sort hhid plotid
isid hhid plotid, missok


* binary for pesticide use
	rename			s11cq1 pest_any
	lab var			pest_any "=1 if any pesticide was used"

* binary for herbicide use
	rename			s11cq10 herb_any
	lab var			herb_any "=1 if any herbicide was used"

* check if any missing values
	mdesc			pest_any herb_any
	*** pest_any missing 6 and herb_any missing 26, change these to "no"
	
* convert missing values to "no"
	replace			pest_any = 2 if pest_any == .
	replace			herb_any = 2 if herb_any == .
	

* **********************************************************************
* 2 - end matter, clean up to save
* **********************************************************************

	keep 			hhid zone state lga sector hhid ea plotid ///
					pest_any herb_any
	
* create unique household-plot identifier
	sort			hhid plotid
	egen			plot_id = group(hhid plotid)
	lab var			plot_id "unique plot identifier"

	
compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("pp_sect11c.dta") ///
			path("`export'/`folder'") dofile(pp_sect11c) user($user)
*note on customsave issue - 2547 observation(s) are missing the ID variable hhid 

* close the log
	log	close

/* END */