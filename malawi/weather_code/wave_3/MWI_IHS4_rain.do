 *converting .csv to .dta*

cd "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\weather_datasets\MWI_IHS4"

*IHS4_rf1_x1
/*
import delimited "IHS4_rf1/IHS4_x1_rf1_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf1/IHS4_x1_rf1_daily.dta", replace
*/
*IHS4_rf1_x2

import delimited "IHS4_rf1/IHS4_x2_rf1_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf1/IHS4_x2_rf1_daily.dta", replace

*IHS4_rf1_x3

import delimited "IHS4_rf1/IHS4_x3_rf1_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf1/IHS4_x3_rf1_daily.dta", replace

*IHS4_rf1_x4

import delimited "IHS4_rf1/IHS4_x4_rf1_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf1/IHS4_x4_rf1_daily.dta", replace

*IHS4_rf1_x5

import delimited "IHS4_rf1/IHS4_x5_rf1_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf1/IHS4_x5_rf1_daily.dta", replace

*IHS4_rf1_x6

import delimited "IHS4_rf1/IHS4_x6_rf1_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf1/IHS4_x6_rf1_daily.dta", replace

*IHS4_rf1_x7

import delimited "IHS4_rf1/IHS4_x7_rf1_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf1/IHS4_x7_rf1_daily.dta", replace

*IHS4_rf1_x8

import delimited "IHS4_rf1/IHS4_x8_rf1_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf1/IHS4_x8_rf1_daily.dta", replace

*IHS4_rf1_x9

import delimited "IHS4_rf1/IHS4_x9_rf1_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf1/IHS4_x9_rf1_daily.dta", replace

*IHS4_rf1_x10

import delimited "IHS4_rf1/IHS4_x10_rf1_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf1/IHS4_x10_rf1_daily.dta", replace

*IHS4_rf2_x1

import delimited "IHS4_rf2/IHS4_x1_rf2_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf2/IHS4_x1_rf2_daily.dta", replace

*IHS4_rf2_x2

import delimited "IHS4_rf2/IHS4_x2_rf2_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf2/IHS4_x2_rf2_daily.dta", replace

*IHS4_rf2_x3

import delimited "IHS4_rf2/IHS4_x3_rf2_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf2/IHS4_x3_rf2_daily.dta", replace

*IHS4_rf2_x4

import delimited "IHS4_rf2/IHS4_x4_rf2_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf2/IHS4_x4_rf2_daily.dta", replace

*IHS4_rf2_x5

import delimited "IHS4_rf2/IHS4_x5_rf2_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf2/IHS4_x5_rf2_daily.dta", replace

*IHS4_rf2_x6

import delimited "IHS4_rf2/IHS4_x6_rf2_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf2/IHS4_x6_rf2_daily.dta", replace

*IHS4_rf2_x7

import delimited "IHS4_rf2/IHS4_x7_rf2_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf2/IHS4_x7_rf2_daily.dta", replace

*IHS4_rf2_x8

import delimited "IHS4_rf2/IHS4_x8_rf2_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf2/IHS4_x8_rf2_daily.dta", replace

*IHS4_rf2_x9

import delimited "IHS4_rf2/IHS4_x9_rf2_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf2/IHS4_x9_rf2_daily.dta", replace

*IHS4_rf2_x10

import delimited "IHS4_rf2/IHS4_x10_rf2_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf2/IHS4_x10_rf2_daily.dta", replace

*IHS4_rf3_x1

import delimited "IHS4_rf3/IHS4_x1_rf3_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf3/IHS4_x1_rf3_daily.dta", replace

*IHS4_rf3_x2

import delimited "IHS4_rf3/IHS4_x2_rf3_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf3/IHS4_x2_rf3_daily.dta", replace

*IHS4_rf3_x3

import delimited "IHS4_rf3/IHS4_x3_rf3_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf3/IHS4_x3_rf3_daily.dta", replace

*IHS4_rf3_x4

import delimited "IHS4_rf3/IHS4_x4_rf3_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf3/IHS4_x4_rf3_daily.dta", replace

*IHS4_rf3_x5

import delimited "IHS4_rf3/IHS4_x5_rf3_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf3/IHS4_x5_rf3_daily.dta", replace

*IHS4_rf3_x6

import delimited "IHS4_rf3/IHS4_x6_rf3_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf3/IHS4_x6_rf3_daily.dta", replace

*IHS4_rf3_x7

import delimited "IHS4_rf3/IHS4_x7_rf3_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf3/IHS4_x7_rf3_daily.dta", replace

*IHS4_rf3_x8

import delimited "IHS4_rf3/IHS4_x8_rf3_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf3/IHS4_x8_rf3_daily.dta", replace

*IHS4_rf3_x9

import delimited "IHS4_rf3/IHS4_x9_rf3_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf3/IHS4_x9_rf3_daily.dta", replace

*IHS4_rf3_x10

import delimited "IHS4_rf3/IHS4_x10_rf3_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf3/IHS4_x10_rf3_daily.dta", replace

*IHS4_rf4_x1

import delimited "IHS4_rf4/IHS4_x1_rf4_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf4/IHS4_x1_rf4_daily.dta", replace

*IHS4_rf4_x2

import delimited "IHS4_rf4/IHS4_x2_rf4_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf4/IHS4_x2_rf4_daily.dta", replace

*IHS4_rf4_x3

import delimited "IHS4_rf4/IHS4_x3_rf4_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf4/IHS4_x3_rf4_daily.dta", replace

*IHS4_rf4_x4

import delimited "IHS4_rf4/IHS4_x4_rf4_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf4/IHS4_x4_rf4_daily.dta", replace

*IHS4_rf4_x5

import delimited "IHS4_rf4/IHS4_x5_rf4_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf4/IHS4_x5_rf4_daily.dta", replace

*IHS4_rf4_x6

import delimited "IHS4_rf4/IHS4_x6_rf4_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf4/IHS4_x6_rf4_daily.dta", replace

*IHS4_rf4_x7

import delimited "IHS4_rf4/IHS4_x7_rf4_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf4/IHS4_x7_rf4_daily.dta", replace

*IHS4_rf4_x8

import delimited "IHS4_rf4/IHS4_x8_rf4_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf4/IHS4_x8_rf4_daily.dta", replace

*IHS4_rf4_x9

import delimited "IHS4_rf4/IHS4_x9_rf4_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf4/IHS4_x9_rf4_daily.dta", replace

*IHS4_rf4_x10

import delimited "IHS4_rf4/IHS4_x10_rf4_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf4/IHS4_x10_rf4_daily.dta", replace

*IHS4_rf5_x1

import delimited "IHS4_rf5/IHS4_x1_rf5_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf5/IHS4_x1_rf5_daily.dta", replace

*IHS4_rf5_x2

import delimited "IHS4_rf5/IHS4_x2_rf5_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf5/IHS4_x2_rf5_daily.dta", replace

*IHS4_rf5_x3

import delimited "IHS4_rf5/IHS4_x3_rf5_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf5/IHS4_x3_rf5_daily.dta", replace

*IHS4_rf5_x4

import delimited "IHS4_rf5/IHS4_x4_rf5_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf5/IHS4_x4_rf5_daily.dta", replace

*IHS4_rf5_x5

import delimited "IHS4_rf5/IHS4_x5_rf5_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf5/IHS4_x5_rf5_daily.dta", replace

*IHS4_rf5_x6

import delimited "IHS4_rf5/IHS4_x6_rf5_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf5/IHS4_x6_rf5_daily.dta", replace

*IHS4_rf5_x7

import delimited "IHS4_rf5/IHS4_x7_rf5_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf5/IHS4_x7_rf5_daily.dta", replace

*IHS4_rf5_x8

import delimited "IHS4_rf5/IHS4_x8_rf5_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf5/IHS4_x8_rf5_daily.dta", replace

*IHS4_rf5_x9

import delimited "IHS4_rf5/IHS4_x9_rf5_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf5/IHS4_x9_rf5_daily.dta", replace

*IHS4_rf5_x10

import delimited "IHS4_rf5/IHS4_x10_rf5_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf5/IHS4_x10_rf5_daily.dta", replace

*IHS4_rf6_x1

import delimited "IHS4_rf6/IHS4_x1_rf6_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf6/IHS4_x1_rf6_daily.dta", replace

*IHS4_rf6_x2

import delimited "IHS4_rf6/IHS4_x2_rf6_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf6/IHS4_x2_rf6_daily.dta", replace

*IHS4_rf6_x3

import delimited "IHS4_rf6/IHS4_x3_rf6_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf6/IHS4_x3_rf6_daily.dta", replace

*IHS4_rf6_x4

import delimited "IHS4_rf6/IHS4_x4_rf6_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf6/IHS4_x4_rf6_daily.dta", replace

*IHS4_rf6_x5

import delimited "IHS4_rf6/IHS4_x5_rf6_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf6/IHS4_x5_rf6_daily.dta", replace

*IHS4_rf6_x6

import delimited "IHS4_rf6/IHS4_x6_rf6_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf6/IHS4_x6_rf6_daily.dta", replace

*IHS4_rf6_x7

import delimited "IHS4_rf6/IHS4_x7_rf6_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf6/IHS4_x7_rf6_daily.dta", replace

*IHS4_rf6_x8

import delimited "IHS4_rf6/IHS4_x8_rf6_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf6/IHS4_x8_rf6_daily.dta", replace

*IHS4_rf6_x9

import delimited "IHS4_rf6/IHS4_x9_rf6_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf6/IHS4_x9_rf6_daily.dta", replace

*IHS4_rf6_x1

import delimited "IHS4_rf6/IHS4_x10_rf6_daily.csv", varnames (1) clear

drop 	rf_19830101-rf_19830930 ///
		rf_20170601-rf_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist rf_* {
   	if substr("`var'", 8, 2) == "06" drop `var'
   	if substr("`var'", 8, 2) == "07" drop `var'
   	if substr("`var'", 8, 2) == "08" drop `var'
   	if substr("`var'", 8, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' rf_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' rf_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' rf_`year'0`nmonth'`day'
}
	foreach var of varlist rf_* {
		loc year = substr("`var'", 4, 4)
		loc month = substr("`var'", 8, 2)
		loc day = substr("`var'", 10, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' rf_`year'0`nmonth'`day'
}

save "IHS4_rf6/IHS4_x10_rf6_daily.dta", replace
