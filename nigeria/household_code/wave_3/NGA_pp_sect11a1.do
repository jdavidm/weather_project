* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 3 POST PLANTING, NIGERIA AG SECTA1
	* determines plot size
	* maybe more who knows
	* outputs clean data file ready for combination with wave 3 hh data

* assumes
	* customsave.ado
	* land-conversion.dta conversion file
	
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
	log using "`logout'/ph_sect11a1", append

* **********************************************************************
* 1 - determine plot size
* **********************************************************************
		
* import the first relevant data file
		use "`root'/sect11a1_plantingw3", clear 	

describe
sort hhid plotid
isid hhid plotid, missok

gen plot_size_SR = s11aq4a
rename s11aq4b SR_unit
label variable plot_size_SR "self reported size of plot, not standardized"
label variable SR_unit "self reported unit of measure, 1=heaps, 2=ridges, 3=stands, 4=plots, 5=acres, 6=hectares, 7=sq meters, 8=other"

gen plot_size_GPS = s11aq4c
label variable plot_size_GPS "in sq. meters"

* **********************************************************************
* 2 - conversions
* **********************************************************************

* redefine paths for conversion 
	loc root = "G:/My Drive/weather_project/household_data/nigeria/conversion_files"

merge m:1 zone using "`root'/land-conversion" 

tab SR_unit, nolabel

gen plot_size_hec = .
replace plot_size_hec = plot_size_SR*ridgecon if SR_unit == 2
*heaps
replace plot_size_hec = plot_size_SR*heapcon if SR_unit == 1
*stands
replace plot_size_hec = plot_size_SR*standcon if SR_unit ==3
*plots
replace plot_size_hec = plot_size_SR*plotcon if SR_unit == 4
*acre
replace plot_size_hec = plot_size_SR*acrecon if SR_unit == 5
*sqm
replace plot_size_hec = plot_size_SR*sqmcon if SR_unit == 7
*remember to convert hectares 

*all appear to have converted properly
summ plot_size_hec 
***HELP WITH THE EXTREME VALUES

label variable plot_size_hec "SR plot size converted to hectares"

*convert gps report to hectares
gen plot_size_2 = .
replace plot_size_2 = plot_size_GPS*sqmcon
label variable plot_size_2 "GPS measured area of plot in hectares"
*tons of missing data for the gps reported size

gen mgr_id = s11aq6a
label variable mgr_id "who in this household manages this plot?"

* **********************************************************************
* 3 - end matter, clean up to save
* **********************************************************************

keep hhid ///
zone ///
state ///
lga ///
sector ///
ea ///
hhid ///
plotid ///
SR_unit ///
plot_size_SR ///
plot_size_GPS ///
mgr_id ///
plot_size_hec ///
plot_size_2 ///
ridgecon ///
heapcon ///
standcon ///
plotcon ///
acrecon ///
sqmcon ///


compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("ph_sect11a1.dta") ///
			path("`export'/`folder'") dofile(ph_sect11a1) user($user)

* close the log
	log	close

/* END */
