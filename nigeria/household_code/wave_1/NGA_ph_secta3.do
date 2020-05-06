* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* WAVE 1, POST HARVEST, NGA SECTA3 AG 

* notes: still includes some notes from Alison Conley's work in spring 2020

* to do
	*outstanding issues: convert harvest quantities (????) and Naira to USD
	
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
	log using "`logout'/secta3_harvestw1", append
		
* import the first relevant data file: secta1_harvestw1
		use "`root'/secta3_harvestw1", clear 	

* **********************************************************************
* 1 - harvest information
* **********************************************************************

rename sa3q2 cropcode
tab cropcode
*main crop is "cassava old"

rename sa3q1 cropname

rename cropid cropid

describe
sort hhid plotid cropid cropcode
isid hhid plotid cropid cropcode, missok

gen crop_area = sa3q5a
label variable crop_area "what was the land area of crop harvested since the last interview? not using standardized unit"
rename sa3q5b area_unit

* **********************************************************************
* 2 - conversion factors, etc. (hectares, kgs)
* **********************************************************************

* define new paths for conversions	
	loc root = "G:/My Drive/weather_project/household_data/nigeria/conversion_files/"

merge m:1 zone using "`root'/land-conversion"
* all matched
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
rename sa3q6b harv_unit
tab harv_unit
tab harv_unit, nolabel

merge m:1 cropcode harv_unit using "`root'/harvconv"
*matched 9,917 but didn't match 5,212 (from master 3,101 and using 2,111)
*values not matched from master usually had issue which prevented harvest e.g. lost crop

*we will also use this measure to get yield
gen harvestq = sa3q6a
label variable harvestq "quantity harvested since last interview, not in standardized unit"

*converting harvest quantities to kgs
gen harv_kg = harvestq*harv_conversion

order harvestq harv_unit harv_conversion harv_kg

*5272 missing values generated in harv_kg - looks like either missing unit or missing harvest quantity

rename sa3q3 cultivated

* **********************************************************************
* 3 - conversion factors - Naria to USD
* **********************************************************************
*STILL NEEDS TO BE CONVERTED TO USD

gen crop_value = sa3q18
label variable crop_value "if you had sold all crop harvested since the last visit, what would be the total value in Naira?"


* **********************************************************************
* 4 - end matter, clean up to save
* **********************************************************************


drop _merge

keep zone ///
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
harvestq ///
harv_conversion ///
harv_kg ///

compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("ph_secta3.dta") ///
			path("`export'/`folder'") dofile(secta3_harvestw1) user($user)
			
			*2111 observation(s) are missing the ID variable hhid. Specifying the noidok option will let you proceed, but it's not good practice.

			
* close the log
	log	close

/* END */
