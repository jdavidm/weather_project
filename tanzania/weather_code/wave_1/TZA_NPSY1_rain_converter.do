clear all

*The growing season that we care about is defined on the FAO website: http://www.fao.org/giews/countrybrief/country.jsp?code=TZA
*We will measure rainfall during the months that the FAO defines as sowing and growing
*Tanzania has unimodal and bimodal regions. 70% of crop production occurs in regions that are unimodal, so we focus on those
*We define the relevant months as Nov 1 - April 30.
*To make our weather program work, we need to run the code on data that starts on Nov 1 and ends on May 1
*Because of this, we will keep rainfall data for the months Nov through May and use the weather command to get rid of May
*This means we only want to drop data from the months Jun, Jul, Aug, Sep, Oct

*Also, Alison, I changed this file back to importing .csv but all the others can import .dta
*Sorry for any confusion.

global user "jdmichler"

loc root = "C:/Users/$user/Dropbox/Weather_Project/Data/Tanzania/weather_datasets/TZA_NPSY1"
loc export = "C:/Users/$user/Dropbox/Weather_Project/Data/Tanzania/weather_datasets/TZA_NPSY1"

local folderList : dir "`root'" dirs "NPSY1_rf*"
foreach folder of local folderList {
	local fileList : dir "`root'/`folder'" files "*.csv"
	foreach file in `fileList' {
		import delimited `root'/`folder'/`file', varnames (1) clear

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
