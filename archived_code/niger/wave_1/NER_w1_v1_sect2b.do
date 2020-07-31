*NIGER, VISIT 1, WAVE 1, SECT2B (start p18 of survey) - rainy season info

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Niger/analysis_datasets/Niger_raw/NER_2011_ECVMA_v01_M_Stata8/ecvmaas2b_p1_en.dta", clear

describe
sort hid hhid passage id fieldid parcelid
isid hid hhid passage id fieldid parcelid, missok

rename as02bq04 worked_rs
label variable worked "was this parcel worked during this rainy season by the household?"

rename as02bq06 cropcode_rs
label variable cropcode "what type of crop was cultivated on this parcel?"

rename as02bq08 crop_area_rs

rename as02bq11 plant_month_rs

keep hid ///
hhid ///
passage ///
id ///
fieldid ///
parcelid ///
worked_rs ///
cropcode_rs ///
crop_area_rs ///
plant_month_rs ///
grappe ///

compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Niger/analysis_datasets/Niger_clean/data/wave_1/NER_w1_v1_sect2b.dta", replace



