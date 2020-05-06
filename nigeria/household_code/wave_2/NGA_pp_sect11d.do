*WAVE 2 POST PLANTING, NGA AG SECT 11D - FERTILIZER

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2012_GHSP-W2_v02_M_STATA/Post Planting Wave 2/Agriculture/sect11d_plantingw2.dta", clear

describe
sort hhid plotid 
isid hhid plotid, missok

rename s11dq1 fertilizer_any
*binary for fert use

*the survey divides the fertilizer into left over, received for free, and purchased so here I combine them
*the quantity is giving in kgs so no conversion is needed
generate leftover_fert_kg = s11dq4
replace leftover_fert_kg = 0 if leftover_fert_kg ==.
gen free_fert_kg = s11dq8
replace free_fert_kg = 0 if free_fert_kg ==. 
gen purchased_fert_kg1 = s11dq16
replace purchased_fert_kg1 = 0 if purchased_fert_kg1 ==. 
gen purchased_fert_kg2 = s11dq28
replace purchased_fert_kg2 = 0 if purchased_fert_kg2 ==. 

generate fert_used_kg = leftover_fert_kg + free_fert_kg + purchased_fert_kg1 + purchased_fert_kg2
label variable fert_used_kg "kilograms of fertilizer used from all sources since the beginning of the new year"

keep zone ///
state ///
lga ///
hhid ///
ea ///
plotid ///
fertilizer_any ///
leftover_fert_kg ///
free_fert_kg ///
purchased_fert_kg1 ///
purchased_fert_kg2 ///
fert_used_kg ///
tracked_obs ///

compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_clean/data/wave_2/pp_sect11d.dta", replace
