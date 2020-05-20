* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 3, POST HARVEST, NIGERIA AG SECT11D - Fertilizer
	* determines fertilizer (quantity)
	* converts to kilograms, as appropriate
	* maybe more who knows
	* outputs clean data file ready for combination with wave 3 hh data
	
* assumes
	* customsave.ado
	
* other notes: 
	* still includes some notes from Alison Conley's work in spring 2020
	
* TO DO:
	* see notes below
	* unsure - incomplete, runs but maybe not right? 
	* clarify "does" section
	
* Alison Notes: 
	* this portion of the survey was previously in post planting portion of wave 1 and wave 2

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
	log using "`logout'/ph_sect11d", append

* **********************************************************************
* 1 - determine fertilizer and conversion to kgs
* **********************************************************************
		
* import the first relevant data file
		use "`root'/secta11d_harvestw3", clear 

describe
sort hhid plotid 
isid hhid plotid, missok

rename s11dq1 fertilizer_any
*binary for fert use

*the survey divides the fertilizer into left over, received for free, and purchased so here I combine them
*the quantity is giving in NOT GIVEN IN KGS in wave 3 so we need to convert these weights to kgs (label should be fert_used_kg for total)
*here is inorganic leftover fertilizer
generate leftover_iq = s11dq4a
replace leftover_iq = 0 if leftover_iq ==.
rename s11dq4b leftover_iunit
tab leftover_iunit

generate leftover = .
replace leftover = leftover_iq*100 if leftover_iunit == 2
replace leftover = leftover_iq if leftover_iunit == 1
replace leftover = leftover_iq if leftover_iunit == 3
replace leftover = 0 if leftover == .
*converting to kgs, assuming 1 liter = 1 kg

*wave 3 provides a subset of fertilizer that is about govmt ewallet subsidized inorganic fertilizer, here i count it
generate sub_iq = s11dq5c1
replace sub_iq = 0 if sub_iq==.
rename s11dq5c2 sub_unit
tab sub_unit
*all the sub units are kgs so they are ready to be added to total

*free inorganic fert
gen free_iq = sect11dq8a
replace free_iq = 0 if free_iq ==. 
rename sect11dq8b free_iunit
tab free_iunit

generate free = .
replace free = free_iq*100 if free_iunit == 2
replace free = free_iq if free_iunit == 1
replace free = 0 if free == .
*converting free units to kgs

*purchased inorganic fert, 1st source
gen purch_iq1 = s11dq16a
replace purch_iq1 = 0 if purch_iq1 ==. 
rename s11dq16b purch_unit1
tab purch_unit1

*converted to kgs
generate purch1 = .
replace purch1 = purch_iq1 if purch_unit1 ==1
replace purch1 = purch_iq1*100 if purch_unit1 ==2
replace purch1 = purch_iq1 if purch_unit1 ==3
replace purch1 = 0 if purch1 ==.

*purchased inorganic, 2nd source
gen purch_iq2 = s11dq28a
replace purch_iq2 = 0 if purch_iq2 ==. 
rename s11dq28b purch_unit2
tab purch_unit2

*converted to kgs
gen purch2 = . 
replace purch2 = purch_iq2 if purch_unit2 == 1
replace purch2 = purch_iq2*100 if purch_unit2 == 2
replace purch2 = purch_iq2 if purch_unit2 == 3
replace purch2 = 0 if purch2 ==.

*total inorganic fertilizer used
generate fert_used_kg = leftover + sub_iq + free + purch1 + purch2

label variable fert_used_kg "total inorganic fertilizer used in kgs"

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
fertilizer_any ///
leftover ///
leftover_iq ///
leftover_iunit ///
sub_iq ///
sub_unit ///
free_iq ///
free_iunit ///
free ///
purch_iq1 ///
purch_unit1 ///
purch1 ///
purch_iq2 ///
purch_unit2 ///
purch2 ///
fert_used_kg ///


compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("ph_sect11d.dta") ///
			path("`export'/`folder'") dofile(ph_sect11d) user($user)

* close the log
	log	close

/* END */