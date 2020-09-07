* Project: WB Weather
* Created on: Aug 2020
* Created by: ek
* Stata v.16

* does
	* makes wave 1 mz_vl for talip


* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths	
	loc     root 		= 		"$data/household_data/uganda/wave_1/refined"
	loc     export 		= 		"$data/household_data/uganda/wave_1/refined"


* **********************************************************************
* 1 - import data and rename variables
* **********************************************************************

* import wave 2 season 1
	use "`root'/2009_AGSEC5A.dta", clear

	keep hhid cropvalue cropid 
	
	keep if cropid == 130
	
	rename cropvalue mz_vl
	
	
* save file
		customsave , idvar(hhid) filename("2009_AGSEC5A_cropvalue.dta") ///
			path("`export'/`folder'") dofile(2009_AGSEC5A_cropvalue) user($user)

/* END */