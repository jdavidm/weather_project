 *WAVE 2 POST PLANTING, NIGERIA SECT11G
*CONVERT HARVEST QUANTITIES

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2012_GHSP-W2_v02_M_STATA/Post Planting Wave 2/Agriculture/sect11g_plantingw2.dta", clear

describe
sort hhid plotid cropid
isid hhid plotid cropid, missok

gen harvestq = s11gq8a
label variable harvestq "How much (tree/perm crop) did you harvest since the new year? post planting survey"
rename s11gq8b harv_unit
*these are the units of measurement


merge m:1 cropcode harv_unit using "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/conversion_files/wave_2/harvconv.dta"
*merged 649, not matched from master = 830


tab harvestq
tab harv_unit
tab harv_unit, nolabel
*so it looks like maybe there should only be 699 observations that get converted? based on the harvestq tab (954 - 255 = 699) in this case 649 isn't so bad but its not ideal. I may be able to manually change it to make it better.

tab _merge harv_unit

*trying to remedy some of the conversion problems
*congo for cashew and cocoa
replace conversion =  1.5 if harv_unit == 7 & conversion == .

*medium bunch for soybeans and maize
replace conversion = 8 if harv_unit == 42 & conversion == .

*small bunches for yam and agbora
replace conversion = 5 if harv_unit == 41 & conversion == .

*tiyas for ginger
replace conversion = 2.27 if harv_unit == 14 & conversion ==.

*mudu for agboro and cashew nut
replace conversion = 1.3 if harv_unit == 5 & conversion ==.

*this process was able to add 17 observations
 

generate harv_kg = harvestq*conversion

keep zone ///
state ///
lga ///
sector ///
hhid ///
ea ///
plotid ///
cropid ///
cropcode ///
harvestq ///
harv_unit ///
_merge ///
harv_kg ///
conversion ///


compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_clean/data/wave_2/pp_sect11g.dta", replace
