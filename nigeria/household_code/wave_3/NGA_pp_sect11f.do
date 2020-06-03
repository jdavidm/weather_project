* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Edited by: ek
* Stata v.16

* does
	* reads in Nigeria, WAVE 3 (2015-2016) POST PLANTING, NIGERIA AG SECT11F
	* determines planting month and year

* assumes
	* customsave.ado
	* land-conversion.dta conversion file
	
* other notes: 
	* still includes some notes from Alison Conley's work in spring 2020
	
* TO DO:
	* some issues with conversion to kgs
	* unsure - incomplete, runs but maybe not right? 
	* clarify "does" section
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* set global user
	global user "emilk"
	
* define paths	
	loc root = "G:/My Drive/weather_project/household_data/nigeria/wave_3/raw"
	loc export = "G:/My Drive/weather_project/household_data/nigeria/wave_3/refined"
	loc logout = "G:/My Drive/weather_project/household_data/nigeria/logs"

* close log (in case still open)
	*log close
	
* open log	
	*log using "`logout'/pp_sect11f", append

* **********************************************************************
* 1 - determine plot size
* **********************************************************************
		
* import the first relevant data file
		use "`root'/sect11f_plantingw3", clear 

describe
sort hhid plotid cropid
isid hhid plotid cropid, missok


* **********************************************************************
* 2 - determine planting year and months 
* **********************************************************************

*rename month and year
rename 			s11fq3a month 
lab var			month "planting month"

rename 			s11fq3b year
lab var			year "planting year"


* check that month and year make sense
	tab				month
	*** vast majority are in March-June
	*** this aligns with FAO planting season
	*** roughly 7% are not in the FAO planting season
	tab year
	*** 97% are in 2015
* **********************************************************************
* 3 - end matter, clean up to save
* **********************************************************************


compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("pp_sect11f.dta") ///
			path("`export'/`folder'") dofile(pp_sect11f) user($user)

* close the log
	log	close

/* END */
