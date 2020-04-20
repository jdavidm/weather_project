* Project: weather
* Created: April 2020
* Stata v.16

* does
	* reads in .dta files with daily values
    * runs weather_command .ado file
	* outputs .dta file of the relevant weather variables
	* does the above for both rainfall and temperature data

* assumes
	* masterDoFile.do
	* weather_command

* TO DO:
	* completed

	
* **********************************************************************
* 0 - setup
* **********************************************************************

clear all
set more off
set maxvar 32766

discard

*-----0.1: Set up directories

global user "themacfreezie"

* For data
loc root = "G:\My Drive\weather_project\weather_data\tanzania\wave_1\daily"
* To export results
loc root = "G:\My Drive\weather_project\weather_data\tanzania\wave_1\refined"


* **********************************************************************
* 1 - run command for rainfall
* **********************************************************************

local folderList : dir "`root'" dirs "NPSY1_rf*"

foreach folder of local folderList {
	local fileList : dir "`root'/`folder'" files "*.dta"
	foreach file in `fileList' {
		use `root'/`folder'/`file', clear
		loc dat = substr("`file'", 1, 5)
		loc ext = substr("`file'", 7, 2)
		loc sat = substr("`file'", 10, 3)
		weather rf_ , rain_data ini_month(1) fin_month(7) day_month(1) keep(hhid) save("`root'/`folder'/`dat'_`ext'_`sat'.dta")
	}
}


* **********************************************************************
* 2 - run command for temperature
* **********************************************************************

local folderList : dir "`root'" dirs "NPSY1_t*"

foreach folder of local folderList {
	local fileList : dir "`root'/`folder'" files "*.dta"
	foreach file in `fileList' {
		use `root'/`folder'/`file', clear
		loc dat = substr("`file'", 1, 5)
		loc ext = substr("`file'", 7, 2)
		loc sat = substr("`file'", 10, 2)
		weather tmp_ , temperature_data growbase_low(10) growbase_high(30) ini_month(1) fin_month(7) day_month(1) keep(hhid) save("`root'/`folder'/`dat'_`ext'_`sat'.dta")
		}
}

/* END */