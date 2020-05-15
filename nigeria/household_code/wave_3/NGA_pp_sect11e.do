* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 3 POST PLANTING, NIGERIA AG SECT11E
	* determines seed
	* maybe more who knows
	* outputs clean data file ready for combination with wave 3 hh data

* assumes
	* customsave.ado
	* land-conversion.dta conversion file
	
* other notes: 
	* still includes some notes from Alison Conley's work in spring 2020
	
* TO DO:
	* major issues with seed: from Alison: Needs conversion for weights of seeds to get application rate variable
		*alj opinion (7 May): omit seed
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
	log using "`logout'/pp_sect11e", append

* **********************************************************************
* 1 - determine seed 
* **********************************************************************
		
* import the first relevant data file
		use "`root'/sect11e_plantingw3", clear 

describe
sort hhid plotid cropid
isid hhid plotid cropid, missok

rename s11eq3 seed_use
*binary for seed use

*the survey divides the seed into free, leftover, and purchased - but they
*have variable units so they can't be added together until the units are standardized

gen leftover_q = s11eq6a
label variable leftover_q "quantity of last year's seed used"
rename s11eq6b leftover_unit
label variable leftover_unit "unit of last year's seed used"
tab leftover_unit

gen freeseed_q = s11eq10a
label variable freeseed_q "quantity of free seed used"
rename s11eq10b freeseed_unit
label variable freeseed_unit "unit of free seed used"
tab freeseed_unit

**looks like people are basically only using leftover seed
gen purchased_qa = s11eq18a
label variable purchased_qa "quantity of purchased seed used from first source"
rename s11eq18b purchased_unit_a
label variable purchased_unit_a "unit of purchased seed used from first source"
tab purchased_unit_a

gen purchased_qb = s11eq30a
label variable purchased_qb "quantity of purchased seed used from second source"
rename s11eq30b purchased_unit_b
label variable purchased_unit_b "unit of purchased seed used from second source"
tab purchased_unit_b

*major measurement issues with seed - probably omit

* **********************************************************************
* 2 - end matter, clean up to save
* **********************************************************************

keep hhid ///
zone ///
state ///
lga ///
hhid ///
ea ///
plotid ///
cropid ///
leftover_q ///
leftover_unit ///
freeseed_q ///
freeseed_unit ///
purchased_qa ///
purchased_unit_a ///
purchased_qb ///
purchased_unit_b ///
seed_use ///

compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("pp_sect11e.dta") ///
			path("`export'/`folder'") dofile(pp_sect11e) user($user)

* close the log
	log	close

/* END */