* Project: WB Weather
* Created on: May 2020
* Created by: ek
* Stata v.16

* does
	* reads in Nigeria, WAVE 2 POST PLANTING, NIGERIA AG SECT11A1
	* determines primary and secondary crops, cleans plot size (hecatres)
	* maybe more who knows
	* outputs clean data file ready for combination with wave 2 hh data

* assumes
	* customsave.ado
	* land_conversion.dta conversion file 
	
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
	log using "`logout'/pp_sect11a1", append

* **********************************************************************
* 1 - describing plot size, etc.
* **********************************************************************
		
* import the first relevant data file
		use "`root'/sect11a1_plantingw2", clear 	
		
describe
sort hhid plotid
isid hhid plotid, missok

gen plot_size_SR = s11aq4a
rename s11aq4b plot_unit
label variable plot_size_SR "self reported size of plot, not standardized"
label variable plot_unit "self reported unit of measure, 1=heaps, 2=ridges, 3=stands, 4=plots, 5=acres, 6=hectares, 7=sq meters, 8=other"

gen plot_size_GPS = s11aq4c
label variable plot_size_GPS "in sq. meters"

gen mgr_id = s11aq6a
label variable mgr_id "who in this household manages this plot?"

* **********************************************************************
* 2 - conversions
* **********************************************************************

* define new paths for conversions	
	loc root = "G:/My Drive/weather_project/household_data/nigeria/conversion_files/"
	
merge m:1 zone using "`root'/land-conversion"

tab plot_unit

gen plot_size_hec = .
replace plot_size_hec = plot_size_SR*ridgecon if plot_unit == 2
*heaps
replace plot_size_hec = plot_size_SR*heapcon if plot_unit == 1
*stands
replace plot_size_hec = plot_size_SR*standcon if plot_unit ==3
*plots
replace plot_size_hec = plot_size_SR*plotcon if plot_unit == 4
*acre
replace plot_size_hec = plot_size_SR*acrecon if plot_unit == 5
*sqm
replace plot_size_hec = plot_size_SR*sqmcon if plot_unit == 7
*hec 
replace plot_size_hec = plot_size_SR if plot_unit == 6

*only losing 2 observations by not including "other" units
label variable plot_size_hec "SR plot size converted to hectares"

*convert gps report to hectares
gen plot_size_2 = .
replace plot_size_2 = plot_size_GPS*sqmcon
label variable plot_size_2 "GPS measured area of plot in hectares"
***about 600 missing values from gps measurement area

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
plot_unit ///
tracked_obs ///
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
		customsave , idvar(hhid) filename("pp_sect11a1.dta") ///
			path("`export'/`folder'") dofile(pp_sect11a1) user($user)

* close the log
	log	close

/* END */