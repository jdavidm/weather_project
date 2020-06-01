*attempting to add a expect_unit to the conversion file for wave 3 conversions - do-file NGA_ph_secta3i

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/conversion_files/wave_3/ag_conv_w3_long.dta", clear

rename harv_unit expect_unit



save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/conversion_files/wave_3/ag_conv_w3_long_2.dta", replace
