*WAVE 2, POST HARVEST, NIGERIA AG SECTA2

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2012_GHSP-W2_v02_M_STATA/Post Harvest Wave 2/Agriculture/secta2_harvestw2.dta", clear

describe
sort hhid plotid
isid hhid plotid, missok

*per the survey, these are laborers from the last rainy/harvest season NOT the dry season harvest
*household member labor, this calculation is (weeks x days per week) for up to 4 members of the household that were laborers
gen hh_1 = (sa2q1a2 * sa2q1a3)
replace hh_1 = 0 if hh_1 == .

gen hh_2 = (sa2q1b2 * sa2q1b3)
replace hh_2 = 0 if hh_2 == . 

gen hh_3 = (sa2q1c2 * sa2q1c3)
replace hh_3 = 0 if hh_3 == .

gen hh_4 = (sa2q1d2 * sa2q1d3)
replace hh_4 = 0 if hh_4 == . 

gen hh_days = hh_1 + hh_2 + hh_3 + hh_4

*hired labor days, this calculation is (# of people hired for harvest)(# of days they worked)
gen men_days = (sa2q2 * sa2q3)
replace men_days = 0 if men_days == . 

gen women_days = (sa2q5 * sa2q6)
replace women_days = 0 if women_days == .

gen child_days = (sa2q8 * sa2q9)
replace child_days = 0 if child_days == . 

*free labor days, from other households
replace sa2q12a = 0 if sa2q12a == .
replace sa2q12b = 0 if sa2q12b == .
replace sa2q12c = 0 if sa2q12c == .

gen free_days = (sa2q12a + sa2q12b + sa2q12c)
replace free_days = 0 if free_days == . 

*total labor days, we will need the labor rate in days/hectare but will need the plotsize from other data sets to get it
gen labor_days = (men_days + women_days + child_days + free_days + hh_days)

keep zone ///
state ///
lga ///
sector ///
hhid ///
ea ///
plotid ///
labor_days ///
tracked_obs ///

compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_clean/data/wave_2/ph_secta2.dta", replace

