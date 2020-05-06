*WAVE 1 POST PLANTING, NIGERIA SECT 11C

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2010_GHSP-W1_v03_M_STATA/Post Planting Wave 1/Agriculture/sect11c_plantingw1.dta", clear

describe
sort hhid plotid
isid hhid plotid, missok

generate pesticide_any=s11cq1
label variable pesticide_any "did you use pesticide on this plot?"

generate herbicide_any = s11cq10
label variable herbicide_any "did you use herbicide on this plot?"

keep zone ///
state ///
lga ///
hhid ///
ea ///
plotid ///
pesticide_any ///
herbicide_any ///

compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_clean/data/pp_sect11c.dta", replace
