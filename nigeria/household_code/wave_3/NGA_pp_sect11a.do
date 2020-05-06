*WAVE 3 POST PLANTING, NIGERIA AG SECT11A
**wave 3 does not have the tracked_obs variable that was present in wave 2 - may not be a problem but worth noting (looks like we may have a key)

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2015_GHSP-W3_v02_M_Stata/Post Planting Wave 3/sect11a_plantingw3.dta", clear

describe
sort hhid 
isid hhid, missok

rename s11aq1 cultivated
label variable cultivated "since the beginning of the agricultural season, did anyone cultivate any land?"

keep zone ///
state ///
lga ///
sector ///
ea ///
hhid ///
cultivated ///

compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_clean/data/wave_3/ph_sect11a.dta", replace
