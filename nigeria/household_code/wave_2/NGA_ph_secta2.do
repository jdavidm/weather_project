* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 2, POST HARVEST, NIGERIA AG SECTA2
	* determines labor
	* maybe more who knows
	* outputs clean data file ready for combination with wave 2 hh data

* assumes
	* customsave.ado
	
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
	log using "`logout'/ph_secta2", append

* **********************************************************************
* 1 - determine labor allocation
* **********************************************************************
		
* import the first relevant data file
		use "`root'/secta2_harvestw2", clear 

describe
sort hhid plotid
isid hhid plotid, missok

*per the survey, these are laborers from the last rainy/harvest season NOT the dry season harvest
*household member labor, this calculation is (weeks x days per week) for up to 4 members of the household that were laborers
gen hh_1 = (sa2q1a2 * sa2q1a3)
replace hh_1 = 0 if hh_1 == .

gen hh_2 = (sa2q1b2 * sa2q1b3)
replace hh_2 = 0 if hh_2 == . 

gen hh_3 = (sa2q1c2 * sa2q1c3)
replace hh_3 = 0 if hh_3 == .

gen hh_4 = (sa2q1d2 * sa2q1d3)
replace hh_4 = 0 if hh_4 == . 

gen hh_days = hh_1 + hh_2 + hh_3 + hh_4

*hired labor days, this calculation is (# of people hired for harvest)(# of days they worked)
gen men_days = (sa2q2 * sa2q3)
replace men_days = 0 if men_days == . 

gen women_days = (sa2q5 * sa2q6)
replace women_days = 0 if women_days == .

gen child_days = (sa2q8 * sa2q9)
replace child_days = 0 if child_days == . 

*free labor days, from other households
replace sa2q12a = 0 if sa2q12a == .
replace sa2q12b = 0 if sa2q12b == .
replace sa2q12c = 0 if sa2q12c == .

gen free_days = (sa2q12a + sa2q12b + sa2q12c)
replace free_days = 0 if free_days == . 

*total labor days, we will need the labor rate in days/hectare but will need the plotsize from other data sets to get it
gen labor_days = (men_days + women_days + child_days + free_days + hh_days)

* **********************************************************************
* 2 - end matter, clean up to save
* **********************************************************************

keep hhid ///
zone ///
state ///
lga ///
sector ///
hhid ///
ea ///
plotid ///
labor_days ///
tracked_obs ///

compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("ph_secta2.dta") ///
			path("`export'/`folder'") dofile(ph_secta2) user($user)

* close the log
	log	close

/* END */