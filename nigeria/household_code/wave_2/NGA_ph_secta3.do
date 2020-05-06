*WAVE 2, POST HARVEST, NIGERIA AG SECTA3

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2012_GHSP-W2_v02_M_STATA/Post Harvest Wave 2/Agriculture/secta3_harvestw2.dta", clear

tab cropcode
*main crop is "cassava old"

describe
sort hhid plotid cropid cropcode
isid hhid plotid cropid cropcode, missok

*need the conversion key in order to get the crop area in hectares, I believe
*this should be the variable we use to get yield for the main crop 
gen crop_area = sa3q5a
label variable crop_area "what was the land area of crop harvested since the last interview? not using standardized unit"
rename sa3q5b area_unit

*we will also use this measure to get yield
gen harvestq = sa3q6a1
label variable harvestq "quantity harvested since last interview, not in standardized unit"
*units of harvest

rename sa3q3 cultivated

gen crop_value = sa3q18
label variable crop_value "if you had sold all crop harvested since the last visit, what would be the total value in Naira?"
*HELP needs to be converted to usd

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
rename sa3q6a2 harv_unit
tab harv_unit
tab harv_unit, nolabel

merge m:1 cropcode harv_unit using "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/conversion_files/harvconv.dta"
*matched 8673 but didn't match 6399 (from master 4275 and using 2124)

*converting harvest quantities to kgs
gen harv_kg = harvestq*harv_conversion

order harvestq harv_unit harv_conversion harv_kg

tab cultivated
*yes = 9960 no = 2962 - could explain some of the data that didnt match ^^^

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
tracked_obs ///
harv_kg ///
harv_conversion ///
crop_area_hec ///


compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_clean/data/wave_2/ph_secta3.dta", replace


