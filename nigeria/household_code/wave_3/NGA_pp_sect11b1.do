* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 3 POST PLANTING, NIGERIA AG SECT11B1
	* determines irrigation and plot use
	* maybe more who knows
	* outputs clean data file ready for combination with wave 3 hh data

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
	loc root = "G:/My Drive/weather_project/household_data/nigeria/wave_3/raw"
	loc export = "G:/My Drive/weather_project/household_data/nigeria/wave_3/refined"
	loc logout = "G:/My Drive/weather_project/household_data/nigeria/logs"

* close log (in case still open)
	*log close
	
* open log	
	log using "`logout'/ph_sect11b1", append

* **********************************************************************
* 1 - determine irrigation and plot use
* **********************************************************************
		
* import the first relevant data file
		use "`root'/sect11b1_plantingw3", clear 	

describe
sort hhid plotid
isid hhid plotid, missok

*alj: drop Alison's information about ownership and manager of plots

*is this plot irrigated?
rename s11b1q39 irrigated

*binary for cultivation of plot
rename s11b1q27 cultivated

*plot use (probably won't need this one because we should be able to see whether the plot was 
*harvested or not based on other info or previously established binary)
rename s11b1q28 plot_use

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
irrigated ///
plot_use ///

compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("ph_sect11b1.dta") ///
			path("`export'/`folder'") dofile(ph_sect11b1) user($user)

* close the log
	log	close

/* END */