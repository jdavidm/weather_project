*prepping harvest conversion dta file for use with wave 2 NGA_ph_secta1

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/conversion_files/wave_2/harvconv.dta", clear

generate harv1_unit = harv_unit

generate harv2_unit = harv_unit

generate harv_conversion2 = conversion

generate harv_conversion = conversion

*harv_conversion will correspond to harv1_unit and harv_conversion2 will correspnd to harv2_unit

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/conversion_files/wave_2/harvconv_wave2_ph_secta1.dta", replace
