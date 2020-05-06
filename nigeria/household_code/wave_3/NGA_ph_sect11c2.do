*WAVE 3, POST HARVEST, AG SECT11C2 - Pesticide & Herbicide
**WAVE 3 is significantly different from wave 1 and 2, the survey asked for pesticide, herbicide, and fertilizer
*use in sect11c2 and sect11d of post harvest, from my understanding - they essentially put the 11c2 and 11d section
*from previous post planting surveys into the wave 3 post harvest survey
**NOTE: no tracked_obs variable in this portion of the survey for wave 3
**note: the survey in wave 3 divides agrochem use into general and free, but it appears that the free quantities are included in the general - so 
**we shouldn't have to sum them together and we can just use the general use numbers

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2015_GHSP-W3_v02_M_Stata/Post Harvest Wave 3/secta11c2_harvestw3.dta", clear

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
pesticideq ///
pest_unit ///
pesticide_any ///
herbicide_any ///
herbicideq ///
herb_unit ///

compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_clean/data/wave_3/ph_sect11c2.dta", replace
