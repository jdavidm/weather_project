* Project: WB Weather
* Created on: Aug 2020
* Created by: ek
* Stata v.16

* does
	* makes wave 3 mz_vl for Talip


* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths	
	loc     root 		= 		"$data/household_data/uganda/wave_3/refined"
	loc     export 		= 		"$data/household_data/uganda/wave_3/refined"


* **********************************************************************
* 1 - import data and rename variables
* **********************************************************************

* import wave 3 season 1
	use "`root'/2011_AGSEC5A.dta", clear

	keep hhid cropvalue cropid 
	
	keep if cropid == 130
	
	rename cropvalue mz_vl
	
* save file
		customsave , idvar(hhid) filename("2011_AGSEC5A_cropvalue.dta") ///
			path("`export'/`folder'") dofile(2011_AGSEC5A_cropvalue) user($user)

/* END */