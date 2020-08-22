* Project: WB Weather
* Created on: Aug 2020
* Created by: themacfreezie
* Edited by: ek
* Stata v.16

* does
	* household Location data (2010_GSEC1) for the 1st season

* assumes
	* customsave.ado
	* mdesc.ado

* TO DO:
	* done

* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths	
	loc 	root 		= 		"$data/household_data/uganda/wave_2/raw"  
	loc     export 		= 		"$data/household_data/uganda/wave_2/refined"
	loc 	logout 		= 		"$data/household_data/uganda/logs"
	
* open log	
	cap log close
	log using "`logout'/2010_GSEC1", append

* **********************************************************************
* 1 - UNPS 2009 (Wave 2) - General(?) Section 1 
* **********************************************************************

* import wave 2 season 1
	use "`root'/GSEC1", clear

isid HHID
rename HHID hhid

rename h1aq1 district
rename h1aq2b county
rename h1aq3b subcounty
rename h1aq4b parish

tab region, missing

keep hhid region district county subcounty parish

*	Prepare for export
compress
describe
summarize 
sort region
save "`export'/2010_GSEC1", replace
