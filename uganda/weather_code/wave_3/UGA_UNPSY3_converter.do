*converting files from .csv to .dta
*note, there are currently no csv files in root folder
*would need to be extracted again from folders in data> Uganda> weather_datasets> Compressed_files_UNPSY3

clear all

global user "jdmichler"

loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\weather_datasets\UGA_UNPSY3"
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\weather_datasets\UGA_UNPSY3"

local folderList : dir "`root'" dirs "UNPSY3_rf*"
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

local folderList : dir "`root'" dirs "UNPSY3_t*"
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
