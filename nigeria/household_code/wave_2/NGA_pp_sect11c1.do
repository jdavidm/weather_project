* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 2 POST PLANTING, NIGERIA AG SECT11C1 - PLANTING LABOR
	* determines primary and secondary crops, cleans production (quantity, hecatres)
	* converts to hectares and kilograms, as appropriate
	* maybe more who knows
	* outputs clean data file ready for combination with wave 2 hh data

* assumes
	* customsave.ado
	* harvconv_wave2_ph_secta1.dta conversion file
	* land_conversion.dta conversion file 
	
* other notes: 
	* still includes some notes from Alison Conley's work in spring 2020
	
* TO DO:
	* from Alison: in wave 1, there was no survey collection of data regarding labor used in the planting process, only in the harvest process - so do we want this data?" - alj inclination == no
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
	log using "`logout'/pp_sect11c1", append

* **********************************************************************
* 1 - labor 
* **********************************************************************
		
* import the first relevant data file
		use "`root'/sect11c1_plantingw2", clear 	

describe
sort hhid plotid
isid hhid plotid, missok

*household labor (# of weeks * # of days/wk = days of labor) for up to 4 members of hh
gen hh_1 = (s11c1q1a2 * s11c1q1a3)
replace hh_1 = 0 if hh_1 == .
gen hh_2 = (s11c1q1b2 * s11c1q1b3)
replace hh_2 = 0 if hh_2 == .
gen hh_3 = (s11c1q1c2 * s11c1q1c3)
replace hh_3 = 0 if hh_3 == .
gen hh_4 = (s11c1q1d2 * s11c1q1d3)
replace hh_4 = 0 if hh_4 == .

*hired labor (# of weeks * 3 of  days/wk = days) 
gen men_days = (s11c1q2 * s11c1q3)
replace men_days = 0 if men_days == .
gen women_days = (s11c1q5 * s11c1q6)
replace women_days = 0 if women_days == .
gen child_days = (s11c1q8 * s11c1q9)
replace child_days = 0 if child_days == . 

*total labor in days (the survey didn't ask for unpaid/exchange labor)
gen pp_labor = hh_1 + hh_2 + hh_3 + hh_4 + men_days + women_days + child_days
label variable pp_labor "total labor in days for planting process"


* **********************************************************************
* 2 - end matter, clean up to save
* **********************************************************************

keep hhid ///
zone ///
state ///
lga ///
sector ///
ea ///
hhid ///
plotid ///
tracked_obs ///
pp_labor ///

compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("pp_sect11c1.dta") ///
			path("`export'/`folder'") dofile(pp_sect11c1) user($user)

* close the log
	log	close

/* END */