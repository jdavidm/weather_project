*WAVE 2 POST PLANTING, NIGERIA AG SECTA1

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2012_GHSP-W2_v02_M_STATA/Post Planting Wave 2/Agriculture/sect11a_plantingw2.dta", clear

describe
sort hhid 
isid hhid, missok

rename s11aq1 cultivate_pp

keep cultivate_pp ///
zone ///
state ///
lga ///
sector ///
ea ///
tracked_obs ///

compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_clean/data/wave_2/pp_sect11a.dta", replace
