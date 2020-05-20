* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 2 POST PLANTING, NIGERIA AG SECT11C2
	* determines pesticide and herbicide use
	* maybe more who knows
	* outputs clean data file ready for combination with wave 2 hh data

* assumes
	* customsave.ado
	
* other notes: 
	* still includes some notes from Alison Conley's work in spring 2020
	
* TO DO:
	* some issues with conversion units, detailed by Alison below
		*alj incliniation - binary only keep suffix "_any"
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
	log using "`logout'/pp_sect11c2", append

* **********************************************************************
* 1 - determines pesticide and herbicide use 
* **********************************************************************
		
* import the first relevant data file
		use "`root'/sect11c2_plantingw2", clear 	

describe
sort hhid plotid 
isid hhid plotid, missok

rename s11c2q1 pesticide_any
*binary for pesticide use since the new year

gen pesticideq = s11c2q2a
label variable pesticideq "what was the quantity of pesticide used on plot since the new year? no standard unit"

rename s11c2q2b pest_unit
tab pest_unit
*HELP: 99% of units used are either grams, kg, centiliters, or liters - we don't 
*have a conversion for the weight of pesticide - can we throw out the 11 observations? 
*even if we can throw out those weird ones we still need to know the conversion factor
*for pesticide weights so we can standardize them to kg/hectare if we want pesticide application rate

rename s11c2q10 herbicide_any
*binary for herbicide use since the new year

gen herbicideq = s11c2q11a
label variable herbicideq "what was the quantity of herbicide used on plot since the new year? no standard unit"

rename s11c2q11b herb_unit
tab herb_unit
*HELP: same situation here except we would lose about 2.5% of observations if we 
*decide to drop the weird measurement units, but we still need a weight conversion factor for app rate


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
tracked_obs ///
pesticideq ///
pest_unit ///
pesticide_any ///
herbicide_any ///
herbicideq ///
herb_unit ///

compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("pp_sect11c2.dta") ///
			path("`export'/`folder'") dofile(pp_sect11c2) user($user)

* close the log
	log	close

/* END */