
*need to include grams, litres (=kg), whatever 5 is??

use "/Users/aljosephson/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2010_GHSP-W1_v03_M_STATA/w1agnsconversion.dta", clear
rename agcropid cropcode
rename nscode harv_unit
rename conversion harv_conversion

sort harv_unit
tab harv_unit, missing
replace harv_unit = 1 if harv_unit == .
replace harv_conversion = 1 if harv_conversion == .

save "/Users/aljosephson/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2010_GHSP-W1_v03_M_STATA/w1agnsconversion.dta", replace
