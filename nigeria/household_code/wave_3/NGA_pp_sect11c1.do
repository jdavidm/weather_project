*WAVE 3 POST PLANTING, NIGERIA AG SECT11C1

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2015_GHSP-W3_v02_M_Stata/Post Planting Wave 3/sect11c1_plantingw3.dta", clear

describe
sort hhid plotid
isid hhid plotid, missok

*household labor (# of weeks * # of days/wk = days of labor) for up to 4 members of hh
gen hh_1 = (s11c1q1a2 * s11c1q1a3)
replace hh_1 = 0 if hh_1 == .
gen hh_2 = (s11c1q1b2 * s11c1q1b3)
replace hh_2 = 0 if hh_2 == .
gen hh_3 = (s11c1q1c2 * s11c1q1c3)
replace hh_3 = 0 if hh_3 == .
gen hh_4 = (s11c1q1d2 * s11c1q1d3)
replace hh_4 = 0 if hh_4 == .

*hired labor (# of weeks * 3 of  days/wk = days) 
gen men_days = (s11c1q2 * s11c1q3)
replace men_days = 0 if men_days == .
gen women_days = (s11c1q5 * s11c1q6)
replace women_days = 0 if women_days == .
gen child_days = (s11c1q8 * s11c1q9)
replace child_days = 0 if child_days == . 

*total labor in days (the survey didn't ask for unpaid/exchange labor)
gen pp_labor = hh_1 + hh_2 + hh_3 + hh_4 + men_days + women_days + child_days
label variable pp_labor "total labor in days for planting process"

keep zone ///
state ///
lga ///
sector ///
ea ///
hhid ///
plotid ///
pp_labor ///

compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_clean/data/wave_3/pp_sect11c1.dta", replace
