*harvest conversions, wave 2

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/conversion_files/wave_2/harvconv.dta", clear

/**grams, 2 = grams
replace conversion = 100 if harv_unit ==2


*liters, 3 = liters
replace harv_unit = 3 if harv_unit ==. 
replace conversion = 1 if harv_unit ==3



*/
*centiliters, 4 = centiliters
replace harv_unit = 4 if harv_unit ==. 
replace conversion = 100 if harv_unit == 4

tab harv_unit
tab harv_unit, nolabel


save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/conversion_files/wave_2/harvconv.dta", replace

