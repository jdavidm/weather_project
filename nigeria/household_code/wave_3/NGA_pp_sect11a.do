* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 3 POST PLANTING, NIGERIA AG SECT11A
	* determines cultivated area (if area was cultivated, that is)
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
	log using "`logout'/ph_sect11a", append

* **********************************************************************
* 1 - determine plot size
* **********************************************************************
		
* import the first relevant data file
		use "`root'/sect11a_plantingw3", clear 	

describe
sort hhid 
isid hhid, missok

rename s11aq1 cultivated
label variable cultivated "since the beginning of the agricultural season, did anyone cultivate any land?"

* **********************************************************************
* 2 - end matter, clean up to save
* **********************************************************************

keep zone ///
state ///
lga ///
sector ///
ea ///
hhid ///
cultivated ///

compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("ph_sect11a.dta") ///
			path("`export'/`folder'") dofile(ph_sect11a) user($user)

* close the log
	log	close

/* END */
