* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 1 - POST PLANTING NIGERIA, SECTION 11A AG
	* determines total and cultivated
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
	global user "aljosephson"
	
* define paths	
	loc root = "G:/My Drive/weather_project/household_data/nigeria/wave_1/raw"
	loc export = "G:/My Drive/weather_project/household_data/nigeria/wave_1/refined"
	loc logout = "G:/My Drive/weather_project/household_data/nigeria/logs"

* close log (in case still open)
	*log close
	
* open log	
	log using "`logout'/pp_sect11a", append
		
* import the first relevant data file: secta1_harvestw1
		use "`root'/sect11a_plantingw1", clear 	

* **********************************************************************
* 1 - cleaning cultivation, etc.
* **********************************************************************

* import the first relevant data file
		use "`root'/sect11a_plantingw1", clear 	

describe
sort hhid
isid hhid, missok
*uniquely identifies

**cultivated = 1 means they did cultivate
generate cultivated = s11aq1 
label variable cultivated "since the beginning of year did you or any member of hh cultivate any land?"
tab cultivated

* **********************************************************************
* 2 - end matter, clean up to save
* **********************************************************************


keep zone ///
state ///
lga ///
hhid ///
cultivated ///
ea ///

compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("pp_sect11a.dta") ///
			path("`export'/`folder'") dofile(pp_sect11a) user($user)

* close the log
	log	close

/* END */
