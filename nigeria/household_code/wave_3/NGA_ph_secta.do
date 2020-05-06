*WAVE 3 POST HARVEST, NIGERIA AG SECTA
**Note: this data file has information regarding the responders previous interviews and
**the tracked observations - I don't know if this will be information that we will need 
**but I figured it's better to have it and we don't have to merge it if it's not needed,
**I believe this info was also present in wave 2 secta

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2015_GHSP-W3_v02_M_Stata/Post Harvest Wave 3/secta_harvestw3.dta", clear

describe
sort hhid
isid hhid, missok

keep tracked_obs ///
hhid ///
zone ///
state ///
lga ///
sector ///
ea ///
saq7 /// **household number
phonly_hh ///


compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_clean/data/wave_3/ph_secta.dta", replace
