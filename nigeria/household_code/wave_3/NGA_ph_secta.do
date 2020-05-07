* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 3 POST HARVEST, NIGERIA AG SECTA
	* determines previous interview information
	* maybe more who knows
	* outputs clean data file ready for combination with wave 3 hh data

* assumes
	* customsave.ado
	
* other notes: 
	* still includes some notes from Alison Conley's work in spring 2020
	
* TO DO:
	* see notes below
	* unsure - incomplete, runs but maybe not right? 
	* clarify "does" section
	
* Alison Notes: 
	* this data file has information regarding the responders previous interviews and the tracked observations - I don't know if this will be information that we will need but I figured it's better to have it and we don't have to merge it if it's not needed,
	* I believe this info was also present in wave 2 secta

* **********************************************************************
* 0 - setup
* **********************************************************************

* set global user
	global user "aljosephson"
	
* define paths	
	loc root = "G:/My Drive/weather_project/household_data/nigeria/wave_3/raw"
	loc export = "G:/My Drive/weather_project/household_data/nigeria/wave_3/refined"
	loc logout = "G:/My Drive/weather_project/household_data/nigeria/logs"

* close log (in case still open)
	*log close
	
* open log	
	log using "`logout'/ph_secta", append

* **********************************************************************
* 1 - set up, clean up, etc.
* **********************************************************************
		
* import the first relevant data file
		use "`root'/secta_harvestw3", clear 	

describe
sort hhid
isid hhid, missok

* **********************************************************************
* 2 - end matter, clean up to save
* **********************************************************************

keep hhid ///
tracked_obs ///
hhid ///
zone ///
state ///
lga ///
sector ///
ea ///
saq7 /// **household number
phonly_hh ///


compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("ph_secta.dta") ///
			path("`export'/`folder'") dofile(ph_secta) user($user)

* close the log
	log	close

/* END */