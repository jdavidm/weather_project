/*===========================================================================
project:      Weather Statistics 
Author:       Anna Josephson & Jeffrey D. Michler
---------------------------------------------------------------------------
Creation Date:      July  16, 2017 
Adapted Date:		August 29, 2019
===========================================================================*/

clear all
set more off
set maxvar 120000

discard

/*=========================================================================
                         0: Program Setup
===========================================================================*/

*-----0.1: Set up directories 

global user "jdmichler"

* For data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\weather_datasets\ETH_ESSY3"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\weather_datasets\ETH_ESSY3"
* Command location
loc command = "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\weather_datasets"

*-----0.2: Load command in memory

do "`command'/weather.do"


/*=========================================================================
                         1: Run command for rain datasets
===========================================================================*/

local folderList : dir "`root'" dirs "ESSY3_rf*"

*Create data sets for Ethiopia
foreach folder of local folderList {
	local fileList : dir "`root'/`folder'" files "*daily.dta"
	foreach file in `fileList' {
		use `root'/`folder'/`file', clear
		loc dat = substr("`file'", 1, 5)
		loc ext = substr("`file'", 7, 2)
		loc sat = substr("`file'", 10, 3)
		weather rf_ , rain_data ini_month(3) fin_month(12) day_month(1) keep(household_id) save("`root'/`folder'/`dat'_`ext'_`sat'.dta")
	}
}

/*=========================================================================
                         2: Run command for temperature datasets
===========================================================================*/

local folderList : dir "`root'" dirs "ESSY3_t*"

*Create data sets for Ethiopia
foreach folder of local folderList {
	local fileList : dir "`root'/`folder'" files "*daily.dta"
	foreach file in `fileList' {
		use `root'/`folder'/`file', clear
		loc dat = substr("`file'", 1, 5)
		loc ext = substr("`file'", 7, 2)
		loc sat = substr("`file'", 10, 2)
		weather tmp_ , temperature_data growbase_low(10) growbase_high(30) ini_month(3) fin_month(12) day_month(1) keep(household_id) save("`root'/`folder'/`dat'_`ext'_`sat'.dta")
		}
}

