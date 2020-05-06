* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 1 POST PLANTING, NIGERIA SECT 11C
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
	global user "aljosephson"
	
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
		
* import the first relevant data file: secta1_harvestw1
		use "`root'/sect11c_plantingw1", clear 	

describe
sort hhid plotid
isid hhid plotid, missok

generate pesticide_any=s11cq1
label variable pesticide_any "did you use pesticide on this plot?"

generate herbicide_any = s11cq10
label variable herbicide_any "did you use herbicide on this plot?"

* **********************************************************************
* 2 - end matter, clean up to save
* **********************************************************************

keep zone ///
state ///
lga ///
hhid ///
ea ///
plotid ///
pesticide_any ///
herbicide_any ///

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