*WAVE 2 POST PLANTING, NIGERIA AG SECT11C2

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2012_GHSP-W2_v02_M_STATA/Post Planting Wave 2/Agriculture/sect11c2_plantingw2.dta", clear
 
describe
sort hhid plotid 
isid hhid plotid, missok

rename s11c2q1 pesticide_any
*binary for pesticide use since the new year

gen pesticideq = s11c2q2a
label variable pesticideq "what was the quantity of pesticide used on plot since the new year? no standard unit"

rename s11c2q2b pest_unit
tab pest_unit
*HELP: 99% of units used are either grams, kg, centiliters, or liters - we don't 
*have a conversion for the weight of pesticide - can we throw out the 11 observations? 
*even if we can throw out those weird ones we still need to know the conversion factor
*for pesticide weights so we can standardize them to kg/hectare if we want pesticide application rate

rename s11c2q10 herbicide_any
*binary for herbicide use since the new year

gen herbicideq = s11c2q11a
label variable herbicideq "what was the quantity of herbicide used on plot since the new year? no standard unit"

rename s11c2q11b herb_unit
tab herb_unit
*HELP: same situation here except we would lose about 2.5% of observations if we 
*decide to drop the weird measurement units, but we still need a weight conversion factor for app rate

keep zone ///
state ///
lga ///
sector ///
ea ///
hhid ///
plotid ///
tracked_obs ///
pesticideq ///
pest_unit ///
pesticide_any ///
herbicide_any ///
herbicideq ///
herb_unit ///

compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_clean/data/wave_2/pp_sect11c2.dta", replace
