* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Edited by: ek
* Stata v.16

* does
	* reads in Nigeria, WAVE 1 (2010-2011), POST PLANTING
	* determines planting month and year
	
	* planting dates look ok, so we don't need anything from this file

* assumes
	* customsave.ado
	* mdesc.ado

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
	*log using "`logout'/pp_sect11f", append

* **********************************************************************
* 1 - general clean up, renaming, etc. 
* **********************************************************************
		
* import the first relevant data file
		use "`root'/sect11F_plantingw1", clear 	
	
	describe
	sort			hhid plotid cropid
	isid			hhid plotid cropid

* rename month and year
	rename s11fq3a month
	lab var			month "planting month"
	
	rename s11fq3b year
	lab var			year "planting year"
	
* check that month and year make sense
	tab				month
	*** vast majority are in March-July, consistent with previous years planting months

	tab				year
	***96% are the correct year and a small number have years that dont make sense.
	mdesc year
	***5% of observations are missing year
	
	*dropping thpse years that dont make sense
	keep if year==2010 | year==2011 | year==2009

* **********************************************************************
* 2 - end matter, clean up to save
* **********************************************************************

keep zone ///
state ///
lga ///
sector ///
hhid ///
ea ///
plotid ///
cropid ///
cropcode ///
area_planted ///
area_planted_unit ///
crop_method ///
plant_month ///
plant_yr ///
planted_area_hec ///
heapcon ///
standcon ///
ridgecon ///
sqmcon ////
plotcon ///
acrecon ///


compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("pp_sect11f.dta") ///
			path("`export'/`folder'") dofile(pp_sect11f) user($user)

* close the log
	log	close

/* END */