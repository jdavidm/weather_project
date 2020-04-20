/*===========================================================================
project:      Weather Statistics 
Author:       Anna Josephson & Jeffrey D. Michler
---------------------------------------------------------------------------
Creation Date:      July  16, 2017 
Adapted Date:		August 20, 2019
Adapted Date:		March 20, 2020
===========================================================================*/

clear all
set more off
set maxvar 32000

discard

/*=========================================================================
                         0: Program Setup
===========================================================================*/

*-----0.1: Set up directories 

global user "jdmichler"

* For data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\weather_datasets\UGA_UNPSY1"
* Command location
loc command = "C:\Users/$user\Dropbox\Weather_Project\weather_code"

*-----0.2: Load command in memory

do "`command'/weather.do"


/*=========================================================================
                         1: Run command for rain datasets
===========================================================================*/

local folderList : dir "`root'" dirs "UNPSY1_rf*"

*Create data sets for northern Uganda
foreach folder of local folderList {
	local fileList : dir "`root'/`folder'" files "*daily.dta"
	foreach file in `fileList' {
		use `root'/`folder'/`file', clear
		loc dat = substr("`file'", 1, 6)
		loc ext = substr("`file'", 8, 2)
		loc sat = substr("`file'", 11, 3)
		weather rf_ , rain_data ini_month(4) fin_month(10) day_month(1) keep(hhid) save("`root'/`folder'/`dat'_`ext'_`sat'_n.dta")
	}
}

*Create data sets for southern Uganda
foreach folder of local folderList {
	local fileList : dir "`root'/`folder'" files "*daily.dta"
	foreach file in `fileList' {
		use `root'/`folder'/`file', clear
		loc dat = substr("`file'", 1, 6)
		loc ext = substr("`file'", 8, 2)
		loc sat = substr("`file'", 11, 3)
		weather rf_ , rain_data ini_month(2) fin_month(8) day_month(1) keep(hhid) save("`root'/`folder'/`dat'_`ext'_`sat'_s.dta")
	}
}

/*=========================================================================
                         2: Run command for temperature datasets
===========================================================================*/

local folderList : dir "`root'" dirs "UNPSY1_t*"

*Create data sets for northern Uganda
foreach folder of local folderList {
	local fileList : dir "`root'/`folder'" files "*daily.dta"
	foreach file in `fileList' {
		use `root'/`folder'/`file', clear
		loc dat = substr("`file'", 1, 6)
		loc ext = substr("`file'", 8, 2)
		loc sat = substr("`file'", 11, 2)
		weather tmp_ , temperature_data growbase_low(10) growbase_high(30) ini_month(4) fin_month(10) day_month(1) keep(hhid) save("`root'/`folder'/`dat'_`ext'_`sat'_n.dta")
		}
}

*Create data sets for southern Uganda
foreach folder of local folderList {
	local fileList : dir "`root'/`folder'" files "*daily.dta"
	foreach file in `fileList' {
		use `root'/`folder'/`file', clear
		loc dat = substr("`file'", 1, 6)
		loc ext = substr("`file'", 8, 2)
		loc sat = substr("`file'", 11, 2)
		weather tmp_ , temperature_data growbase_low(10) growbase_high(30) ini_month(2) fin_month(8) day_month(1) keep(hhid) save("`root'/`folder'/`dat'_`ext'_`sat'_s.dta")
		}
}
