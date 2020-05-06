*WAVE 3 POST HARVEST, NIGERIA AG SECTA2

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2015_GHSP-W3_v02_M_Stata/Post Harvest Wave 3/secta2_harvestw3.dta", clear

describe
sort hhid plotid
isid hhid plotid, missok

*per the survey, these are laborers from the last rainy/harvest season NOT the dry season harvest
*household member labor, this calculation is (weeks x days per week) for up to 4 members of the household that were laborers
***NOTE: the survey says these were hired between planting and harvesting
gen hh_1_ph = (sa2q1b_a2 * sa2q1b_a3)
replace hh_1_ph = 0 if hh_1_ph == .

gen hh_2_ph = (sa2q1b_b2 * sa2q1b_b3)
replace hh_2_ph = 0 if hh_2_ph == . 

gen hh_3_ph = (sa2q1b_c2 * sa2q1b_c3)
replace hh_3_ph = 0 if hh_3_ph == .

gen hh_4_ph = (sa2q1b_d2 * sa2q1b_d3)
replace hh_4_ph = 0 if hh_4_ph == . 

gen hh_5_ph = (sa2q1b_e2 * sa2q1b_e3)
replace hh_5_ph = 0 if hh_5_ph == .

gen hh_6_ph = (sa2q1b_f2 * sa2q1b_f3)
replace hh_6_ph = 0 if hh_6_ph == . 

gen hh_7_ph = (sa2q1b_g2 * sa2q1b_g3)
replace hh_7_ph = 0 if hh_7_ph == .

gen hh_8_ph = (sa2q1b_h2 * sa2q1b_h3)
replace hh_8_ph = 0 if hh_8_ph == . 

gen hh_days_ph = hh_1_ph + hh_2_ph + hh_3_ph + hh_4_ph + hh_5_ph + hh_6_ph + hh_7_ph + hh_8_ph

*hired labor days, this calculation is (# of people hired for harvest)(# of days they worked) BETWEEN PLANTING AND HARVESTING
gen men_days_ph = (sa2q1c * sa2q1d)
replace men_days_ph = 0 if men_days_ph == . 

gen women_days_ph = (sa2q1f * sa2q1g)
replace women_days_ph = 0 if women_days_ph == .

gen child_days_ph = (sa2q1i * sa2q1j)
replace child_days_ph = 0 if child_days_ph == . 

*free labor days, from other households BETWEEN PLANTING AND HARVESTING
replace sa2q1n_a = 0 if sa2q1n_a == .
replace sa2q1n_b = 0 if sa2q1n_b == .
replace sa2q1n_c = 0 if sa2q1n_c == .

gen free_days_ph = (sa2q1n_a + sa2q1n_b + sa2q1n_c)
replace free_days_ph = 0 if free_days_ph == . 

*total labor days, we will need the labor rate in days/hectare but will need the plotsize from other data sets to get it
gen labor_days_ph = (men_days_ph + women_days_ph + child_days_ph + free_days_ph + hh_days_ph)

**_ph stands for the survey portion that asks about labor between planting and harvesting during the rainy season
**_ht stands for laborers that worked on this plot for harvesting and threshing - this isn't double counting I would assume??
*HELP: may want to look into this^

**Here, I sum the labor recorded for harvesting and threshing (_ht)
gen hh_1_ht = (sa2q1a2 * sa2q1a3)
replace hh_1_ht = 0 if hh_1_ht == .

gen hh_2_ht = (sa2q1b2 * sa2q1b3)
replace hh_2_ht = 0 if hh_2_ht == . 

gen hh_3_ht = (sa2q1c2 * sa2q1c3)
replace hh_3_ht = 0 if hh_3_ht == .

gen hh_4_ht = (sa2q1d2 * sa2q1d3)
replace hh_4_ht = 0 if hh_4_ht == . 

gen hh_5_ht = (sa2q1e2 * sa2q1e3)
replace hh_5_ht = 0 if hh_5_ht == .

gen hh_6_ht = (sa2q1f2 * sa2q1f3)
replace hh_6_ht = 0 if hh_6_ht == . 

gen hh_7_ht = (sa2q1g2 * sa2q1g3)
replace hh_7_ht = 0 if hh_7_ht == .

gen hh_8_ht = (sa2q1h2 * sa2q1h3)
replace hh_8_ht = 0 if hh_8_ht == . 

gen hh_days_ht = hh_1_ht + hh_2_ht + hh_3_ht + hh_4_ht + hh_5_ht + hh_6_ht + hh_7_ht + hh_8_ht

*hired labor days, this calculation is (# of people hired for harvest)(# of days they worked) HARVEST & THRESH
gen men_days_ht = (sa2q2 * sa2q3)
replace men_days_ht = 0 if men_days_ht == . 

gen women_days_ht = (sa2q5 * sa2q6)
replace women_days_ht = 0 if women_days_ht == .

gen child_days_ht = (sa2q8 * sa2q9)
replace child_days_ht = 0 if child_days_ht == . 

*free labor days, from other households, HARVEST & THRESH
replace sa2q12a = 0 if sa2q12a == .
replace sa2q12b = 0 if sa2q12b == .
replace sa2q12c = 0 if sa2q12c == .

gen free_days_ht = (sa2q12a + sa2q12b + sa2q12c)
replace free_days_ht = 0 if free_days_ht == . 

*total labor days, we will need the labor rate in days/hectare but will need the plotsize from other data sets to get it, HARVEST & THRESH
gen labor_days_ht = (men_days_ht + women_days_ht + child_days_ht + free_days_ht + hh_days_ht)

***TOTAL DAYS (SUM OF PH AND HT)
gen labor_days = labor_days_ph + labor_days_ht

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

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_clean/data/wave_3/ph_secta2.dta", replace



