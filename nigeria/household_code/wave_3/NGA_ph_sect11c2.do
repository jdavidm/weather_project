* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 3, POST HARVEST, AG SECT11C2 - Pesticide & Herbicide
	* determines pesticide, herbicide (quantity and binary)
	* converts to kilograms, as appropriate
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
	* WAVE 3 is significantly different from wave 1 and 2: survey asked for pest, herb, fert
	* use in sect11c2 and sect11d of post harvest - they essentially put the 11c2 and 11d section
	* from previous post planting surveys into the wave 3 post harvest survey
	* no tracked_obs variable in this portion of the survey for wave 3
	* the survey in wave 3 divides agrochem use into general and free, but it appears that the free quantities are included in the general - so we shouldn't have to sum them together and we can just use the general use numbers

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
	log using "`logout'/ph_sect11c2", append

* **********************************************************************
* 1 - determine pesticide, herbicide, etc.
* **********************************************************************
		
* import the first relevant data file
		use "`root'/secta11c2_harvestw3", clear 	

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
*ALJ : yes 
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

*inclination - use only binarys, not weights

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