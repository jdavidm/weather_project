* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 2 POST PLANTING, NGA AG SECT11F - SEED
	* determines planted area and cropped method
	* converts to hectares, as appropriate
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
	log using "`logout'/pp_sect11f", append

* **********************************************************************
* 1 - determine planting area, conversion to hectares 
* **********************************************************************
		
* import the first relevant data file
		use "`root'/sect11f_plantingw2", clear 	

describe
sort hhid plotid cropid
isid hhid plotid cropid, missok

gen area_planted = s11fq1a 
label variable area_planted "what was the total area planted on this plot with the crop since the beginning of the year?"
rename s11fq1b area_planted_unit
label variable area_planted_unit "unit of measurement reported"

* define new paths for conversions	
	loc root = "G:/My Drive/weather_project/household_data/nigeria/conversion_files/"

merge m:1 zone using "`root'/land-conversion"

tab area_planted_unit, nolabel
tab area_planted_unit

gen planted_area_hec = .
*heaps conversion
replace planted_area_hec = area_planted*heapcon if area_planted_unit == 1
*ridges conversion
replace planted_area_hec = area_planted*ridgecon if area_planted_unit == 2
*stands conv
replace planted_area_hec = area_planted*standcon if area_planted_unit == 3
*plots conv
replace planted_area_hec = area_planted*plotcon if area_planted_unit ==4
*acre conv
replace planted_area_hec = area_planted*acrecon if area_planted_unit == 5
*sqm conv
replace planted_area_hec = area_planted*sqmcon if area_planted_unit == 7
*hec
replace planted_area_hec = area_planted if area_planted_unit == 6
**note: we lose 61 observations out of 10500 when we cut out the "other" units
		*from ALJ this seems okay...
***HELP when I converted, I wasn't able to get all the observations that were illustrated for each unit in the tab of area_planted_unit - not sure why?
***HELP there is also a few really large numbers compared that seem to be extreme values
		*from ALJ: need to figure out how this number differs from other plot area calculations???

label variable planted_area_hec "SR total area planted on this plot with the crop since the beginning of the year converted to hectares"

* **********************************************************************
* 2 - determine crop method and planting year
* **********************************************************************


*do we need to know the method of cropping used? we are only concerned with their main crop, so do we need to report
*if the crop was mono-cropped or inter-cropped? Because with inter-cropping part of the harvest could be the main crop?
rename s11fq2 crop_method

rename s11fq3a plant_month 
rename s11fq3b plant_yr
tab plant_yr

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
area_planted ///
area_planted_unit ///
crop_method ///
plant_month ///
plant_yr ///
tracked_obs ///
planted_area_hec ///
heapcon ///
ridgecon ///
standcon ///
plotcon ///
acrecon ///
sqmcon ///


compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("pp_sect11f.dta") ///
			path("`export'/`folder'") dofile(pp_sect11f) user($user)

* close the log
	log	close

/* END */