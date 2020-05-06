*WAVE 1 - POST PLANTING NIGERIA, SECTION 11A AG

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2010_GHSP-W1_v03_M_STATA/Post Planting Wave 1/Agriculture/sect11a_plantingw1.dta", clear
describe
sort hhid
isid hhid, missok
*uniquely identifies

**cultivated = 1 means they did cultivate
generate cultivated = s11aq1 
label variable cultivated "since the beginning of year did you or any member of hh cultivate any land?"
tab cultivated

keep zone ///
state ///
lga ///
hhid ///
cultivated ///
ea ///

compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_clean/data/wave_1/pp_sect11a.dta", replace
