*WAVE 2 POST PLANTING, NGA AG SECT11F - SEED

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2012_GHSP-W2_v02_M_STATA/Post Planting Wave 2/Agriculture/sect11f_plantingw2.dta", clear

describe
sort hhid plotid cropid
isid hhid plotid cropid, missok

gen area_planted = s11fq1a 
label variable area_planted "what was the total area planted on this plot with the crop since the beginning of the year?"
rename s11fq1b area_planted_unit
label variable area_planted_unit "unit of measurement reported"

merge m:1 zone using "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/conversion_files/land-conversion.dta"

tab area_planted_unit, nolabel
tab area_planted_unit

gen planted_area_hec = .
*heaps conversion
replace planted_area_hec = area_planted*heapcon if area_planted_unit == 1
*ridges conversion
replace planted_area_hec = area_planted*ridgecon if area_planted_unit == 2
*stands conv
replace planted_area_hec = area_planted*standcon if area_planted_unit == 3
*plots conv
replace planted_area_hec = area_planted*plotcon if area_planted_unit ==4
*acre conv
replace planted_area_hec = area_planted*acrecon if area_planted_unit == 5
*sqm conv
replace planted_area_hec = area_planted*sqmcon if area_planted_unit == 7
*hec
replace planted_area_hec = area_planted if area_planted_unit = 6
**note: we lose 61 observations out of 10500 when we cut out the "other" units
***HELP when I converted, I wasn't able to get all the observations that were illustrated for each unit in the tab of area_planted_unit - not sure why?
***HELP there is also a few really large numbers compared that seem to be extreme values

label variable planted_area_hec "SR total area planted on this plot with the crop since the beginning of the year converted to hectares"

*do we need to know the method of cropping used? we are only concerned with their main crop, so do we need to report
*if the crop was mono-cropped or inter-cropped? Because with inter-cropping part of the harvest could be the main crop?
rename s11fq2 crop_method

rename s11fq3a plant_month 
rename s11fq3b plant_yr
tab plant_yr

keep zone ///
state ///
lga ///
sector ///
hhid ///
ea ///
plotid ///
cropid ///
cropcode ///
area_planted ///
area_planted_unit ///
crop_method ///
plant_month ///
plant_yr ///
tracked_obs ///
planted_area_hec ///
heapcon ///
ridgecon ///
standcon ///
plotcon ///
acrecon ///
sqmcon ///


compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_clean/data/wave_2/pp_sect11f.dta", replace
