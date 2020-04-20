/*===========================================================================
project:      Weather Statistics 
Author:       Anna Josephson & Jeffrey D. Michler
---------------------------------------------------------------------------
Creation Date:      July  16, 2017 
Adapted Date:		July  11, 2019
===========================================================================*/

clear all
set more off
set maxvar 120000

discard

/*=========================================================================
                         0: Program Setup
===========================================================================*/

*-----0.1: Set up directories 

global user "aljosephson  "

* For data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\weather_datasets\MWI_IHPS"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\weather_datasets\MWI_IHPS"
* Command location
loc command = "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\weather_datasets"

*-----0.2: Load command in memory

do "`command'/weather.do"


/*=========================================================================
                         1: Run command for rain datasets
===========================================================================*/

local folderList : dir "`root'" dirs "IHPS_rf*"

foreach folder of local folderList {
	local fileList : dir "`root'/`folder'" files "*.dta"
	foreach file in `fileList' {
		use `root'/`folder'/`file', clear
		loc dat = substr("`file'", 1, 4)
		loc ext = substr("`file'", 6, 2)
		loc sat = substr("`file'", 9, 3)
		weather rf_ , rain_data ini_month(1) fin_month(8) day_month(1) keep(y2_hhid) save("`root'/`folder'/`dat'_`ext'_`sat'.dta")
		*Note that the naming convention creates a weird file name for x10 since the other extracts are called x1 not x01, etc.
	}
}

/*=========================================================================
                         2: Run command for temperature datasets
===========================================================================*/


local folderList : dir "`root'" dirs "IHPS_t*"

foreach folder of local folderList {
	local fileList : dir "`root'/`folder'" files "*.dta"
	foreach file in `fileList' {
		use `root'/`folder'/`file', clear
		loc dat = substr("`file'", 1, 4)
		loc ext = substr("`file'", 6, 2)
		loc sat = substr("`file'", 9, 2)
		weather tmp_ , temperature_data growbase_low(10) growbase_high(30) ini_month(1) fin_month(8) day_month(1) keep(y2_hhid) save("`root'/`folder'/`dat'_`ext'_`sat'.dta")
		}
}
