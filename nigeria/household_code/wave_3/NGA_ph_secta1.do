* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 3 POST HARVEST, NIGERIA AG SECTA1
	* determines plot ownership and management
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
	log using "`logout'/ph_secta1", append

* **********************************************************************
* 1 - determine plot size
* **********************************************************************
		
* import the first relevant data file
		use "`root'/secta1_harvestw3", clear 	

describe
sort hhid plotid
isid hhid plotid, missok

*cut information from Alison on plot manager 

rename sa1q3 new_plot
label variable new_plot "is this a new plot?"

gen plot_size_SR = sa1q9a
label variable plot_size_SR "self-reported"
rename sa1q9b plot_unit

tab plot_unit, nolabel
tab plot_unit

* **********************************************************************
* 2 - conversions to hectares 
* **********************************************************************

* redefine paths for conversion 
	loc root = "G:/My Drive/weather_project/household_data/nigeria/conversion_files"

merge m:1 zone using "`root'/land-conversion" 

***converting plot_size_SR to hectares
gen plot_size_hec = . 
replace plot_size_hec = plot_size_SR*heapcon if plot_unit == 1
replace plot_size_hec = plot_size_SR*standcon if plot_unit == 3
replace plot_size_hec = plot_size_SR*ridgecon if plot_unit == 2
replace plot_size_hec = plot_size_SR*plotcon if plot_unit == 4
replace plot_size_hec = plot_size_SR*acrecon if plot_unit == 5
label variable plot_size_hec "SR plot size converted to hectares"

gen plot_size_GPS = sa1q9c
label variable plot_size_GPS "GPS measure in square meters"

***converting plot_size_GPS to hectares
gen plot_size_2 = .
replace plot_size_2 = plot_size_GPS*sqmcon
label variable plot_size_2 "GPS measured area of plot in hectares"


rename sa1q1a w2_gps
label variable w2_gps "binary for if the plot was previously measured in wave 2"
**not sure if we need this, but may be a good reference if we have missing gps measurements
**because they could have only recorded it in wave 2?

gen plot_owner = sa1q14
label variable plot_owner "who is the owner of this plot? hhid"
**they also provide a second owner (in all waves) but I didn't record it because I didn't think we needed it, 
**but we do have that info

rename sa1q23 transfer_mgr
label variable transfer_mgr "has the manager of this plot changed since the last interview? binary"
**on the survey, they give sa1q24 gives the hhids of up to 4 of the current plot managers - may want this?

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
plot_size_SR ///
plot_unit ///
plot_size_GPS ///
plot_owner ///
transfer_mgr ///
plot_size_2 ///
w2_gps ///
plot_size_hec ///

compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("ph_secta1.dta") ///
			path("`export'/`folder'") dofile(ph_secta1) user($user)

* close the log
	log	close

/* END */