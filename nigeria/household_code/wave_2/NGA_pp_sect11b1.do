* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 2 POST PLANTING, NIGERIA AG SECT 11B1
	* determine irrigation 
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
	log using "`logout'/ph_sect11b1", append

* **********************************************************************
* 1 - describe plots and irrigation status
* **********************************************************************
		
* import the first relevant data file
		use "`root'/sect11b1_plantingw2", clear 	

describe
sort hhid plotid
isid hhid plotid, missok

*owner(s) of plots
gen owner1 = s11b1q6a
gen owner2 = s11b1q6b

*alison kept decision-maker - alj dropped

*is this plot irrigated?
rename s11b1q39 irrigated

* **********************************************************************
* 2 - end matter, clean up to save
* **********************************************************************

keep hhid /// 
zone ///
state ///
lga ///
sector ///
ea ///
hhid ///
plotid ///
owner1 ///
owner2 ///
tracked_obs ///
irrigated ///

compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("pp_sect11b1.dta") ///
			path("`export'/`folder'") dofile(pp_sect11b1) user($user)

* close the log
	log	close

/* END */