* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 1 POST PLANTING, NIGERIA SECT 11D AG - fertilizer
	* determines fertilizer use in kilograms 
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
	log using "`logout'/pp_sect11d", append

* **********************************************************************
* 1 - determine fertilizer use 
* **********************************************************************
		
* import the first relevant data file
		use "`root'/sect11d_plantingw1", clear 

describe
sort hhid plotid
isid hhid plotid, missok

generate fertilizer_any = s11dq1
label variable fertilizer_any "did you use fertilizer on this plot since the beginning of the new year?"

generate leftover_fert_kg = s11dq4
replace leftover_fert_kg = 0 if leftover_fert_kg ==.
gen free_fert_kg=s11dq8
replace free_fert_kg = 0 if free_fert_kg ==. 
gen purchased_fert_kg1=s11dq15
replace purchased_fert_kg1 = 0 if purchased_fert_kg1 ==. 
gen purchased_fert_kg2=s11dq26
replace purchased_fert_kg2 = 0 if purchased_fert_kg2 ==. 

generate fert_used_kg = leftover_fert_kg + free_fert_kg + purchased_fert_kg1 + purchased_fert_kg2
label variable fert_used_kg "kilograms of fertilizer used from all sources"

* **********************************************************************
* 2 - end matter, clean up to save
* **********************************************************************

keep zone ///
state ///
lga ///
hhid ///
ea ///
plotid ///
fertilizer_any ///
leftover_fert_kg ///
free_fert_kg ///
purchased_fert_kg1 ///
purchased_fert_kg2 ///
fert_used_kg ///

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