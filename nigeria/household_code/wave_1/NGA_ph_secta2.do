* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Edited by: ek
* Stata v.16

* notes: still includes some notes from Alison Conley's work in spring 2020
* wave 1 (2010-2011)

* does
	* reads in Nigeria, POST HARVEST, NGA SECTA2 AG - Labor
	* determines labor days from different sources
	* outputs clean data file ready for combination with wave 1 hh data

* assumes
	* customsave.ado

* other notes: 
	* still includes some notes from Alison Conley's work in spring 2020
	

* **********************************************************************
* 0 - setup
* **********************************************************************

* set global user
	global user "emilk"
	
* define paths	
	loc root = "G:/My Drive/weather_project/household_data/nigeria/wave_1/raw"
	loc export = "G:/My Drive/weather_project/household_data/nigeria/wave_1/refined"
	loc logout = "G:/My Drive/weather_project/household_data/nigeria/logs"

* close log (in case still open)
	*log close
	
* open log	
	log using "`logout'/ph_secta2", append
		
* **********************************************************************
* 1 - determine labor allocation 
* **********************************************************************

* import the first relevant data file
		use "`root'/secta2_harvestw1", clear 	

describe
sort hhid plotid
isid hhid plotid



*according to survey: these are laborers from the last rainy/harvest season (e.g. NOT the dry season harvest)
*household member labor, this calculation is (weeks x days per week) for up to 4 members of the household that were laborers

gen hh_1 = (sa2q1a2 * sa2q1a3)
replace hh_1 = 0 if hh_1 == .

gen hh_2 = (sa2q1b2 * sa2q1b3)
replace hh_2 = 0 if hh_2 == . 

gen hh_3 = (sa2q1c2 * sa2q1c3)
replace hh_3 = 0 if hh_3 == .

gen hh_4 = (sa2q1d2 * sa2q1d3)
replace hh_4 = 0 if hh_4 == . 

*dropping impossible entries that must be mistake
 sum sa2q1a3 sa2q1b3 sa2q1c3 sa2q1d3

* keep if sa2q1a3<=7  
*1,153 observations deleted

*keep if sa2q1b3<=7
*1,095 observations deleted

*  keep if sa2q1c3<=7
*1,069 observations deleted

*  keep if sa2q1d3<=7
*625 observations deleted

*sum sa2q1a2 sa2q1b2 sa2q1c2 sa2q1d2
*no one worked more weeks than there are weeks in a year

*total labor days for harvest
gen hh_days = hh_1 + hh_2 + hh_3 + hh_4

*hired labor days, this calculation is (# of people hired for harvest)(# of days they worked)

gen men_days = sa2q3
replace men_days = 0 if men_days == . 

gen women_days = sa2q6
replace women_days = 0 if women_days == .

gen child_days = sa2q9
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

keep zone ///
state ///
lga ///
sector ///
hhid ///
ea ///
plotid ///
labor_days ///

compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("ph_secta2.dta") ///
			path("`export'/`folder'") dofile(ph_secta2) user($user)
			
* close the log
	log	close

/* END */

