*WAVE 1 POST PLANTING, NIGERIA SECT 11D AG - fertilizer (in kgs)

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2010_GHSP-W1_v03_M_STATA/Post Planting Wave 1/Agriculture/sect11d_plantingw1.dta", clear

describe
sort hhid plotid
isid hhid plotid, missok

generate fertilizer_any = s11dq1
label variable fertilizer_any "did you use fertilizer on this plot since the beginning of the new year?"

generate leftover_fert_kg = s11dq4
replace leftover_fert_kg = 0 if leftover_fert_kg ==.
gen free_fert_kg=s11dq8
replace free_fert_kg = 0 if free_fert_kg ==. 
gen purchased_fert_kg1=s11dq15
replace purchased_fert_kg1 = 0 if purchased_fert_kg1 ==. 
gen purchased_fert_kg2=s11dq26
replace purchased_fert_kg2 = 0 if purchased_fert_kg2 ==. 

generate fert_used_kg = leftover_fert_kg + free_fert_kg + purchased_fert_kg1 + purchased_fert_kg2
label variable fert_used_kg "kilograms of fertilizer used from all sources"

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

compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_clean/data/wave_1/pp_sect11d.dta", replace



