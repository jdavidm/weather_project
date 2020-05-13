* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* to do
	*outstanding issues: 
	
* does
	* reads in Nigeria, WAVE 1, POST HARVEST, NGA SECTA3 AG 
	* determines primary and secondary crops, cleans harvest (quantity, hecatres)
	* converts to hectares and kilograms, as appropriate
	* produces value of harvest (Naria) - need to include conversion to Naria 
	* renames variables to align with standardization (see OSF)
	* outputs clean data file ready for combination with wave 1 hh data

* assumes
	* customsave.ado
	* harvconv.dta conversion file
	* land_conversion.dta conversion file 
	
* TO DO:
	* convert Naira to USD
	* rename variables to be in line with standard practice in other rounds
	
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
	log using "`logout'/ph_secta3", append
		

* **********************************************************************
* 1 - harvest information
* **********************************************************************

* import the first relevant data file
		use "`root'/secta3_harvestw1", clear 	

rename sa3q2 cropcode
tab cropcode
*main crop is "cassava old" 
*cassava is continuous cropping, so not using that as a main crop
*going to use maize instead, which is second

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

*units of harvest
rename sa3q6b harv_unit
tab harv_unit
tab harv_unit, nolabel

merge m:1 cropcode harv_unit using "`root'/harvconv"
*matched 9,917 but didn't match 5,212 (from master 3,101 and using 2,111)
*drop these unmatched - either not producing or coming from merge conversion file 
*values not matched from master usually had issue which prevented harvest e.g. lost crop
keep if _merge == 3
drop _merge

*we will also use this measure to get yield
gen harvestq = sa3q6a
label variable harvestq "quantity harvested since last interview, not in standardized unit"

*converting harvest quantities to kgs
gen harv_kg = harvestq*harv_conversion

order harvestq harv_unit harv_conversion harv_kg

*5272 missing values generated in harv_kg - looks like either missing unit or missing harvest quantity

rename sa3q3 cultivated

gen cp_hrv = harv_kg if cropcode == 1080 

* **********************************************************************
* 3 - value of harvest 
* **********************************************************************
*STILL NEEDS TO BE CONVERTED TO USD

gen crop_value = sa3q18
label variable crop_value "if you had sold all crop harvested since the last visit, what would be the total value in Naira?"
rename crop_value tf_hrv 

* **********************************************************************
* 4 - end matter, collapse, clean up to save
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
cp_hrv ///
tf_hrv ///

compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("ph_secta3.dta") ///
			path("`export'/`folder'") dofile(ph_secta3) user($user)
						
* close the log
	log	close

/* END */
