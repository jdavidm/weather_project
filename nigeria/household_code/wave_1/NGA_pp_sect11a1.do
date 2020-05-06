* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 1 - POST PLANTING NIGERIA, SECT 11A1 AG
	* determines primary and secondary crops, cleans plot size (SR & GPS)
	* converts to hectares, as appropriate
	* maybe more who knows
	* outputs clean data file ready for combination with wave 1 hh data

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
	loc root = "G:/My Drive/weather_project/household_data/nigeria/wave_1/raw"
	loc export = "G:/My Drive/weather_project/household_data/nigeria/wave_1/refined"
	loc logout = "G:/My Drive/weather_project/household_data/nigeria/logs"

* close log (in case still open)
	*log close
	
* open log	
	log using "`logout'/pp_sect11a1", append

* **********************************************************************
* 1 - general clean up, renaming, etc. 
* **********************************************************************

* import the first relevant data file: secta1_harvestw1
		use "`root'/sect11a1_plantingw1", clear 	

describe
sort hhid plotid
isid hhid plotid, missok
*need plot id to uniquely identify

generate plot_size_SR = s11aq4a
label variable plot_size_SR "What is the area of plot? Self-reported"

generate plot_unit = s11aq4b
label variable plot_unit "unit used in plot measurement"

generate plot_other_unit = s11aq4c
label variable plot_other_unit "other unit used in plot measurement"

generate plot_size_GPS = s11aq4d
label variable plot_size_GPS "GPS plot size in sq. meters"

generate plot_label = s11aq5c 

* **********************************************************************
* 2 - conversions
* **********************************************************************

* define new paths for conversions	
	loc root = "G:/My Drive/weather_project/household_data/nigeria/conversion_files/"
  

merge m:1 zone using "`root'/land-conversion"

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

tab plot_unit
tab plot_other_unit
***take a look at these plot_other_units? There is 61 of them and they look kind of like mistakes? 61/5900
*ALJ - agree these are mistakes + can be dropped
label variable plot_size_hec "SR plot size converted to hectares"

*convert gps report to hectares
gen plot_size_2 = .
replace plot_size_2 = plot_size_GPS*sqmcon
label variable plot_size_2 "GPS measured area of plot in hectares"
***about 600 missing values from gps measurement area

* **********************************************************************
* 3 - end matter, clean up to save
* **********************************************************************

keep zone ///
state ///
lga ///
hhid ///
ea ///
plotid ///
plot_size_SR ///
plot_size_GPS ///
plot_label ///
plot_unit ///
plot_other_unit ///
plot_size_hec ///
plot_size_2 ///
ridgecon ///
heapcon ///
plotcon ///
acrecon ///
sqmcon ///

compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("ph_sect11a1.dta") ///
			path("`export'/`folder'") dofile(ph_sect11a1) user($user)
*note on customsave issue - 2547 observation(s) are missing the ID variable hhid 

* close the log
	log	close

/* END */