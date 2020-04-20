clear all

global user "jdmichler"

loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Tanzania\weather_datasets\TZA_NPSY3"
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Tanzania\weather_datasets\TZA_NPSY3"

local folderList : dir "`root'" dirs "NPSY3_t*"
foreach folder of local folderList {
	local fileList : dir "`root'/`folder'" files "*.dta"
	foreach file in `fileList' {
		use `root'/`folder'/`file', clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier (June-Oct)
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
	if substr("`var'", 9, 2) == "10" drop `var'
	}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 11 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+2
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+2
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+2
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+2
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+2
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-10
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-10
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

		loc dat = substr("`file'", 1, 5)
		loc ext = substr("`file'", 7, 2)
		loc sat = substr("`file'", 10, 2)
		
		
		
		save "`export'/`folder'/`dat'_`ext'_`sat'_daily.dta", replace
		}
		}
