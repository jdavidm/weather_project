clear all

global user "jdmichler"

loc root = "C:/Users/$user/Dropbox/Weather_Project/Data/Tanzania/weather_datasets/TZA_NPSY3"
loc export = "C:/Users/$user/Dropbox/Weather_Project/Data/Tanzania/weather_datasets/TZA_NPSY3"

local folderList : dir "`root'" dirs "NPSY3_rf*"
foreach folder of local folderList {
	local fileList : dir "`root'/`folder'" files "*.dta"
	foreach file in `fileList' {
		use `root'/`folder'/`file', clear

drop 	rf_19830101-rf_19831031 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
	if substr("`var'", 8, 2) == "10" drop `var'
	
}
*Shift early month variables one year forward, year refers to start of season
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 11 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+2
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+2
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+2
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+2
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+2
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-10
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-10
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

		loc dat = substr("`file'", 1, 5)
		loc ext = substr("`file'", 7, 2)
		loc sat = substr("`file'", 10, 3)
			
		save "`export'/`folder'/`dat'_`ext'_`sat'_daily.dta", replace
		}
}
		
