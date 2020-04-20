*converting temperature .csv to .dta*

cd "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\weather_datasets\MWI_IHS4"


*IHS4_t1_x1

import delimited "IHS4_t1/IHS4_x1_t1_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t1/IHS4_x1_t1_daily.dta", replace

*IHS4_t1_x2

import delimited "IHS4_t1/IHS4_x2_t1_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t1/IHS4_x2_t1_daily.dta", replace

*IHS4_t1_x3

import delimited "IHS4_t1/IHS4_x3_t1_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t1/IHS4_x3_t1_daily.dta", replace

*IHS4_t1_x4

import delimited "IHS4_t1/IHS4_x4_t1_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t1/IHS4_x4_t1_daily.dta", replace

*IHS4_t1_x5

import delimited "IHS4_t1/IHS4_x5_t1_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t1/IHS4_x5_t1_daily.dta", replace

*IHS4_t1_x6

import delimited "IHS4_t1/IHS4_x6_t1_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t1/IHS4_x6_t1_daily.dta", replace

*IHS4_t1_x7

import delimited "IHS4_t1/IHS4_x7_t1_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t1/IHS4_x7_t1_daily.dta", replace

*IHS4_t1_x8

import delimited "IHS4_t1/IHS4_x8_t1_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t1/IHS4_x8_t1_daily.dta", replace

*IHS4_t1_x9

import delimited "IHS4_t1/IHS4_x9_t1_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t1/IHS4_x9_t1_daily.dta", replace

*IHS4_t1_x10

import delimited "IHS4_t1/IHS4_x10_t1_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t1/IHS4_x10_t1_daily.dta", replace

*IHS4_t2_x1

import delimited "IHS4_t2/IHS4_x1_t2_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t2/IHS4_x1_t2_daily.dta", replace

*IHS4_t2_x2

import delimited "IHS4_t2/IHS4_x2_t2_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t2/IHS4_x2_t2_daily.dta", replace

*IHS4_t2_x3

import delimited "IHS4_t2/IHS4_x3_t2_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t2/IHS4_x3_t2_daily.dta", replace

*IHS4_t2_x4

import delimited "IHS4_t2/IHS4_x4_t2_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t2/IHS4_x4_t2_daily.dta", replace

*IHS4_t2_x5

import delimited "IHS4_t2/IHS4_x5_t2_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t2/IHS4_x5_t2_daily.dta", replace

*IHS4_t2_x6

import delimited "IHS4_t2/IHS4_x6_t2_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t2/IHS4_x6_t2_daily.dta", replace

*IHS4_t2_x7

import delimited "IHS4_t2/IHS4_x7_t2_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t2/IHS4_x7_t2_daily.dta", replace

*IHS4_t2_x8

import delimited "IHS4_t2/IHS4_x8_t2_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t2/IHS4_x8_t2_daily.dta", replace

*IHS4_t2_x9

import delimited "IHS4_t2/IHS4_x9_t2_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t2/IHS4_x9_t2_daily.dta", replace

*IHS4_t2_x10

import delimited "IHS4_t2/IHS4_x10_t2_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t2/IHS4_x10_t2_daily.dta", replace

*IHS4_t3_x1

import delimited "IHS4_t3/IHS4_x1_t3_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t3/IHS4_x1_t3_daily.dta", replace

*IHS4_t3_x2

import delimited "IHS4_t3/IHS4_x2_t3_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t3/IHS4_x2_t3_daily.dta", replace

*IHS4_t3_x3

import delimited "IHS4_t3/IHS4_x3_t3_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t3/IHS4_x3_t3_daily.dta", replace

*IHS4_t3_x4

import delimited "IHS4_t3/IHS4_x4_t3_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t3/IHS4_x4_t3_daily.dta", replace

*IHS4_t3_x5

import delimited "IHS4_t3/IHS4_x5_t3_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t3/IHS4_x5_t3_daily.dta", replace

*IHS4_t3_x6

import delimited "IHS4_t3/IHS4_x6_t3_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t3/IHS4_x6_t3_daily.dta", replace

*IHS4_t3_x7

import delimited "IHS4_t3/IHS4_x7_t3_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t3/IHS4_x7_t3_daily.dta", replace

*IHS4_t3_x8

import delimited "IHS4_t3/IHS4_x8_t3_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t3/IHS4_x8_t3_daily.dta", replace

*IHS4_t3_x9

import delimited "IHS4_t3/IHS4_x9_t3_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t3/IHS4_x9_t3_daily.dta", replace

*IHS4_t3_x10

import delimited "IHS4_t3/IHS4_x10_t3_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t3/IHS4_x10_t3_daily.dta", replace

*IHS4_t1mx_x1

import delimited "IHS4_t1mx/IHS4_x1_t1mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t1mx/IHS4_x1_t1mx_daily.dta", replace

*IHS4_t1mx_x2

import delimited "IHS4_t1mx/IHS4_x2_t1mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t1mx/IHS4_x2_t1mx_daily.dta", replace

*IHS4_t1mx_x3

import delimited "IHS4_t1mx/IHS4_x3_t1mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t1mx/IHS4_x3_t1mx_daily.dta", replace

*IHS4_t1mx_x4

import delimited "IHS4_t1mx/IHS4_x4_t1mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t1mx/IHS4_x4_t1mx_daily.dta", replace

*IHS4_t1mx_x5

import delimited "IHS4_t1mx/IHS4_x5_t1mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t1mx/IHS4_x5_t1mx_daily.dta", replace

*IHS4_t1mx_x6

import delimited "IHS4_t1mx/IHS4_x6_t1mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t1mx/IHS4_x6_t1mx_daily.dta", replace

*IHS4_t1mx_x7

import delimited "IHS4_t1mx/IHS4_x7_t1mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t1mx/IHS4_x7_t1mx_daily.dta", replace

*IHS4_t1mx_x8

import delimited "IHS4_t1mx/IHS4_x8_t1mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t1mx/IHS4_x8_t1mx_daily.dta", replace

*IHS4_t1mx_x9

import delimited "IHS4_t1mx/IHS4_x9_t1mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t1mx/IHS4_x9_t1mx_daily.dta", replace

*IHS4_t1mx_x10

import delimited "IHS4_t1mx/IHS4_x10_t1mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t1mx/IHS4_x10_t1mx_daily.dta", replace

*IHS4_t2mx_x1

import delimited "IHS4_t2mx/IHS4_x1_t2mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t2mx/IHS4_x1_t2mx_daily.dta", replace

*IHS4_t2mx_x2

import delimited "IHS4_t2mx/IHS4_x2_t2mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t2mx/IHS4_x2_t2mx_daily.dta", replace

*IHS4_t2mx_x3

import delimited "IHS4_t2mx/IHS4_x3_t2mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t2mx/IHS4_x3_t2mx_daily.dta", replace

*IHS4_t2mx_x4

import delimited "IHS4_t2mx/IHS4_x4_t2mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t2mx/IHS4_x4_t2mx_daily.dta", replace

*IHS4_t2mx_x5

import delimited "IHS4_t2mx/IHS4_x5_t2mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t2mx/IHS4_x5_t2mx_daily.dta", replace

*IHS4_t2mx_x6

import delimited "IHS4_t2mx/IHS4_x6_t2mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t2mx/IHS4_x6_t2mx_daily.dta", replace

*IHS4_t2mx_x7

import delimited "IHS4_t2mx/IHS4_x7_t2mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t2mx/IHS4_x7_t2mx_daily.dta", replace

*IHS4_t2mx_x8

import delimited "IHS4_t2mx/IHS4_x8_t2mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t2mx/IHS4_x8_t2mx_daily.dta", replace

*IHS4_t2mx_x9

import delimited "IHS4_t2mx/IHS4_x9_t2mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t2mx/IHS4_x9_t2mx_daily.dta", replace

*IHS4_t2mx_x10

import delimited "IHS4_t2mx/IHS4_x10_t2mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t2mx/IHS4_x10_t2mx_daily.dta", replace

*IHS4_t3mx_x1

import delimited "IHS4_t3mx/IHS4_x1_t3mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t3mx/IHS4_x1_t3mx_daily.dta", replace

*IHS4_t3mx_x2

import delimited "IHS4_t3mx/IHS4_x2_t3mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t3mx/IHS4_x2_t3mx_daily.dta", replace

*IHS4_t3mx_x3

import delimited "IHS4_t3mx/IHS4_x3_t3mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t3mx/IHS4_x3_t3mx_daily.dta", replace

*IHS4_t3mx_x4

import delimited "IHS4_t3mx/IHS4_x4_t3mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t3mx/IHS4_x4_t3mx_daily.dta", replace

*IHS4_t3mx_x5

import delimited "IHS4_t3mx/IHS4_x5_t3mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t3mx/IHS4_x5_t3mx_daily.dta", replace

*IHS4_t3mx_x6

import delimited "IHS4_t3mx/IHS4_x6_t3mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t3mx/IHS4_x6_t3mx_daily.dta", replace

*IHS4_t3mx_x7

import delimited "IHS4_t3mx/IHS4_x7_t3mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t3mx/IHS4_x7_t3mx_daily.dta", replace

*IHS4_t3mx_x8

import delimited "IHS4_t3mx/IHS4_x8_t3mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t3mx/IHS4_x8_t3mx_daily.dta", replace

*IHS4_t3mx_x9

import delimited "IHS4_t3mx/IHS4_x9_t3mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t3mx/IHS4_x9_t3mx_daily.dta", replace

*IHS4_t3mx_x10

import delimited "IHS4_t3mx/IHS4_x10_t3mx_daily.csv", varnames (1) clear

drop 	tmp_19830101-tmp_19830930 ///
		tmp_20170601-tmp_20171231

*Drop unnecessary months, this will make renaming variables easier
foreach var of varlist tmp_* {
   	if substr("`var'", 9, 2) == "06" drop `var'
   	if substr("`var'", 9, 2) == "07" drop `var'
   	if substr("`var'", 9, 2) == "08" drop `var'
   	if substr("`var'", 9, 2) == "09" drop `var'
}
*Shift early month variables one year forward
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc cyear = `year'-1
		if `month' < 10 rename `var' tmp_`cyear'`month'`day'
}
*Rename early month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 05 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 04 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 03 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 02 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'+3
		if `month' == 01 rename `var' tmp_`year'0`nmonth'`day'
}
*Rename later month variables			
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 10 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 11 rename `var' tmp_`year'0`nmonth'`day'
}
	foreach var of varlist tmp_* {
		loc year = substr("`var'", 5, 4)
		loc month = substr("`var'", 9, 2)
		loc day = substr("`var'", 11, 2)
		loc nmonth = `month'-9
		if `month' == 12 rename `var' tmp_`year'0`nmonth'`day'
}

save "IHS4_t3mx/IHS4_x10_t3mx_daily.dta", replace
