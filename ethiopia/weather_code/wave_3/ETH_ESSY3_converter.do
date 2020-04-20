clear all

global user "jdmichler"

loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\weather_datasets\ETH_ESSY3"
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\weather_datasets\ETH_ESSY3"

local folderList : dir "`root'" dirs "ESSY3_rf*"
foreach folder of local folderList {
	local fileList : dir "`root'/`folder'" files "*.csv"
	foreach file in `fileList' {
		import delimited `root'/`folder'/`file', varnames (1) clear

		loc dat = substr("`file'", 1, 5)
		loc ext = substr("`file'", 7, 2)
		loc sat = substr("`file'", 10, 3)
		
		save "`export'/`folder'/`dat'_`ext'_`sat'_daily.dta", replace
		}
		}

local folderList : dir "`root'" dirs "ESSY3_t*"
foreach folder of local folderList {
	local fileList : dir "`root'/`folder'" files "*.csv"
	foreach file in `fileList' {
		import delimited `root'/`folder'/`file', varnames (1) clear

		loc dat = substr("`file'", 1, 5)
		loc ext = substr("`file'", 7, 2)
		loc sat = substr("`file'", 10, 2)
		
		save "`export'/`folder'/`dat'_`ext'_`sat'_daily.dta", replace
		}
		}
