* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 3 POST HARVEST, NIGERIA AG SECTA
	* determines previous interview information
	* outputs clean data file ready for combination with wave 3 hh data

* assumes
	* customsave.ado

* **********************************************************************
* 0 - setup
* **********************************************************************
	
* define paths	
	loc root = "$data/household_data/nigeria/wave_3/raw"
	loc export = "$data/household_data/nigeria/wave_3/refined"
	loc logout = "$data/household_data/nigeria/logs"

* close log (in case still open)
	*log close
	
* open log	
	log using "`logout'/ph_secta", append

* **********************************************************************
* 1 - set up, clean up, etc.
* **********************************************************************
		
* import the first relevant data file
		use "`root'/secta_harvestw3", clear 	

describe
sort hhid
isid hhid, missok

* **********************************************************************
* 2 - end matter, clean up to save
* **********************************************************************

keep hhid ///
tracked_obs ///
hhid ///
zone ///
state ///
lga ///
sector ///
ea ///
saq7 /// **household number
phonly_hh ///


compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("ph_secta.dta") ///
			path("`export'/`folder'") dofile(ph_secta) user($user)

* close the log
	log	close

/* END */