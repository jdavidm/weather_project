* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 2, POST HARVEST, NIGERIA AG SECTA3
	* determines primary and secondary crops, cleans harvest (quantity, hecatres)
	* converts to hectares and kilograms, as appropriate
	* maybe more who knows
	* outputs clean data file ready for combination with wave 2 hh data

* assumes
	* customsave.ado
	* harvconv.dta conversion file
	* land_conversion.dta conversion file 
	
* other notes: 
	* still includes some notes from Alison Conley's work in spring 2020
	
* TO DO:
	* need to convert Naira to USD
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
	log using "`logout'/ph_secta3", append

* **********************************************************************
* 1 - general clean up, renaming, etc. 
* **********************************************************************
		
* import the first relevant data file
		use "`root'/secta3_harvestw2", clear 	

tab cropcode
*main crop is "cassava old"

describe
sort hhid plotid cropid cropcode
isid hhid plotid cropid cropcode, missok

* **********************************************************************
* 2 - harvested amount, land area, conversions, etc.
* **********************************************************************
	
*need the conversion key in order to get the crop area in hectares
*this should be the variable we use to get yield for the main crop 
gen crop_area = sa3q5a
label variable crop_area "what was the land area of crop harvested since the last interview? not using standardized unit"
rename sa3q5b area_unit

*we will also use this measure to get yield
gen harvestq = sa3q6a1
label variable harvestq "quantity harvested since last interview, not in standardized unit"
*units of harvest

rename sa3q3 cultivated

* Naria needs to be converted to USD
gen crop_value = sa3q18
label variable crop_value "if you had sold all crop harvested since the last visit, what would be the total value in Naira?"


* define new paths for conversions	
	loc root = "G:/My Drive/weather_project/household_data/nigeria/conversion_files/"

merge m:1 zone using "`root'/land-conversion"
drop _merge

tab area_unit
tab area_unit, nolabel

*converting land area
gen crop_area_hec = . 
replace crop_area_hec = crop_area*heapcon if area_unit==1
replace crop_area_hec = crop_area*ridgecon if area_unit==2
replace crop_area_hec = crop_area*standcon if area_unit==3
replace crop_area_hec = crop_area*plotcon if area_unit==4
replace crop_area_hec = crop_area*acrecon if area_unit==5
replace crop_area_hec = crop_area*sqmcon if area_unit==7
replace crop_area_hec = crop_area if area_unit == 6
label variable crop_area_hec "land area of crop harvested since last unit, converted to hectares"

*units of harvest
rename sa3q6a2 harv_unit
tab harv_unit
tab harv_unit, nolabel

merge m:1 cropcode harv_unit using "`root'/harvconv"
*matched 8673 but didn't match 6399 (from master 4275 and using 2124)

*converting harvest quantities to kgs
gen harv_kg = harvestq*harv_conversion

order harvestq harv_unit harv_conversion harv_kg

tab cultivated
*yes = 9960 no = 2962 - could explain some of the data that didnt match ^^^

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
crop_area ///
area_unit ///
harvestq ///
harv_unit ///
cultivated ///
crop_value ///
tracked_obs ///
harv_kg ///
harv_conversion ///
crop_area_hec ///


compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("ph_secta3.dta") ///
			path("`export'/`folder'") dofile(ph_secta3) user($user)

* close the log
	log	close

/* END */