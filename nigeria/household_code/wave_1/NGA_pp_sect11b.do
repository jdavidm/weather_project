* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 1 POST PLANTING, NIGERIA SECT 11B AG
	* determines if plot is cultivated
	* determines if plot is irrigated
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
	log using "`logout'/ph_sect11b", append

* **********************************************************************
* 1 - determine cultivated plot + irrigation 
* **********************************************************************
		
* import the first relevant data file
		use "`root'/sect11b_plantingw1", clear 	

describe
sort hhid plotid
isid hhid plotid, missok

generate cultivated_plot = s11bq16
label variable cultivated_plot "since beginning of year did anyone in hh cultivated plot?"

generate irrigated = s11bq24
label variable irrigated "is this plot irrigated?"

* **********************************************************************
* 2 - end matter, clean up to save
* **********************************************************************


keep zone ///
state ///
lga ///
ea ///
hhid ///
plotid ///
cultivated_plot ///
irrigated ///

compress
describe
summarize 


* save file
		customsave , idvar(hhid) filename("ph_sect11b.dta") ///
			path("`export'/`folder'") dofile(ph_sect11b) user($user)
*note on customsave issue - 2547 observation(s) are missing the ID variable hhid 

* close the log
	log	close

/* END */