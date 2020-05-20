* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 2 POST PLANTING, NIGERIA AG SECTA1
	* determines something about cultivation pp - must be used for other pp information
	* maybe more who knows
	* outputs clean data file ready for combination with wave 2 hh data

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
	global user "aljosephson"
	
* define paths	
	loc root = "G:/My Drive/weather_project/household_data/nigeria/wave_2/raw"
	loc export = "G:/My Drive/weather_project/household_data/nigeria/wave_2/refined"
	loc logout = "G:/My Drive/weather_project/household_data/nigeria/logs"

* close log (in case still open)
	*log close
	
* open log	
	log using "`logout'/pp_sect11a", append

* **********************************************************************
* 1 - determine cultivate_pp 
* **********************************************************************
		
* import the first relevant data file
		use "`root'/sect11a_plantingw2", clear 	

describe
sort hhid 
isid hhid, missok

rename s11aq1 cultivate_pp


* **********************************************************************
* 2 - end matter, clean up to save
* **********************************************************************

keep hhid /// 
cultivate_pp ///
zone ///
state ///
lga ///
sector ///
ea ///
tracked_obs ///

compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("pp_sect11a.dta") ///
			path("`export'/`folder'") dofile(pp_sect11a) user($user)

* close the log
	log	close

/* END */