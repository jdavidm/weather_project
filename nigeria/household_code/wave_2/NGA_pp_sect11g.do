* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 2 POST PLANTING, NIGERIA SECT11G
	* determines harvest (quantity)
	* converts to kilograms, as appropriate
	* maybe more who knows
	* outputs clean data file ready for combination with wave 2 hh data

* assumes
	* customsave.ado
	* harvconv.dta conversion file 
	
* other notes: 
	* still includes some notes from Alison Conley's work in spring 2020
	
* TO DO:
	* some issues with conversion to kilograms
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
	log using "`logout'/pp_sect11g", append

* **********************************************************************
* 1 - determine harvest quantities 
* **********************************************************************
		
* import the first relevant data file
		use "`root'/sect11g_plantingw2", clear 	
 
describe
sort hhid plotid cropid
isid hhid plotid cropid, missok

gen harvestq = s11gq8a
label variable harvestq "How much (tree/perm crop) did you harvest since the new year? post planting survey"
rename s11gq8b harv_unit
*these are the units of measurement

* **********************************************************************
* 2 - converting harvest quantities to kilograms 
* **********************************************************************

* define new paths for conversions	
	loc root = "G:/My Drive/weather_project/household_data/nigeria/conversion_files/"

merge m:1 cropcode harv_unit using "`root'/harvconv"
*merged 649, not matched from master = 830

tab harvestq
tab harv_unit
tab harv_unit, nolabel
*so it looks like maybe there should only be 699 observations that get converted? based on the harvestq tab (954 - 255 = 699) in this case 649 isn't so bad but its not ideal. I may be able to manually change it to make it better.

tab _merge harv_unit

*trying to remedy some of the conversion problems
*congo for cashew and cocoa - this values taken from shared material on LSMS website 
replace harv_conversion =  1.5 if harv_unit == 7 & harv_conversion == .

*medium bunch for soybeans and maize
replace harv_conversion = 8 if harv_unit == 42 & harv_conversion == .

*small bunches for yam and agbora
replace harv_conversion = 5 if harv_unit == 41 & harv_conversion == .

*tiyas for ginger
replace harv_conversion = 2.27 if harv_unit == 14 & harv_conversion ==.

*mudu for agboro and cashew nut
replace harv_conversion = 1.3 if harv_unit == 5 & harv_conversion ==.

*this process was able to add 17 observations
 
generate harv_kg = harvestq*harv_conversion

* **********************************************************************
* 3 - end matter, clean up to save
* **********************************************************************

keep hhid ///
zone ///
state ///
lga ///
sector ///
hhid ///
ea ///
plotid ///
cropid ///
cropcode ///
harvestq ///
harv_unit ///
_merge ///
harv_kg ///
harv_conversion ///


compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("pp_sect11g.dta") ///
			path("`export'/`folder'") dofile(pp_sect11g) user($user)

* close the log
	log	close

/* END */