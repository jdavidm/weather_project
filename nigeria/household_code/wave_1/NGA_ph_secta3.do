*WAVE 1, POST HARVEST, NGA SECTA3 AG - 
*HELP NEED to convert harvest quantities and NAira to USD

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2010_GHSP-W1_v03_M_STATA/Post Harvest Wave 1/Agriculture/secta3_harvestw1.dta", clear

rename sa3q2 cropcode
tab cropcode
*main crop is "cassava old"

rename sa3q1 cropname

rename cropid cropid

describe
sort hhid plotid cropid cropcode
isid hhid plotid cropid cropcode, missok

gen crop_area = sa3q5a
label variable crop_area "what was the land area of crop harvested since the last interview? not using standardized unit"
rename sa3q5b area_unit

merge m:1 zone using "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/conversion_files/land-conversion.dta"

drop _merge


tab area_unit
tab area_unit, nolabel
*converting land area
gen crop_area_hec = . 
replace crop_area_hec = crop_area*heapcon if area_unit==1
replace crop_area_hec = crop_area*ridgecon if area_unit==2
replace crop_area_hec = crop_area*standcon if area_unit==3
replace crop_area_hec = crop_area*plotcon if area_unit==4
replace crop_area_hec = crop_area*acrecon if area_unit==5
replace crop_area_hec = crop_area*sqmcon if area_unit==7
replace crop_area_hec = crop_area if area_unit == 6
label variable crop_area_hec "land area of crop harvested since last unit, converted to hectares"

*units of harvest
rename sa3q6b harv_unit
tab harv_unit
tab harv_unit, nolabel

merge m:1 cropcode harv_unit using "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/conversion_files/harvconv.dta"
*matched 9,917 but didn't match 5,212 (from master 3,101 and using 2,111)


*we will also use this measure to get yield
gen harvestq = sa3q6a
label variable harvestq "quantity harvested since last interview, not in standardized unit"

*converting harvest quantities to kgs
gen harv_kg = harvestq*harv_conversion

order harvestq harv_unit harv_conversion harv_kg

*5272 missing values generated in harv_kg - looks like either missing unit or missing harvest quantity

rename sa3q3 cultivated

gen crop_value = sa3q18
label variable crop_value "if you had sold all crop harvested since the last visit, what would be the total value in Naira?"
*HELP needs to be converted to usd

drop _merge



keep zone ///
state ///
lga ///
sector ///
hhid ///
ea ///
plotid ///
cropid ///
cropcode ///
crop_area ///
area_unit ///
harvestq ///
harv_unit ///
cultivated ///
crop_value ///
harvestq ///
harv_conversion ///
harv_kg ///

compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_clean/data/wave_1/ph_secta3.dta", replace









