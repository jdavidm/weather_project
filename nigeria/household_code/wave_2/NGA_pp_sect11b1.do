*WAVE 2 POST PLANTING, NIGERIA AG SECT 11B1

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2012_GHSP-W2_v02_M_STATA/Post Planting Wave 2/Agriculture/sect11b1_plantingw2.dta", clear

describe
sort hhid plotid
isid hhid plotid, missok

*owner(s) of plots
gen owner1 = s11b1q6a
gen owner2 = s11b1q6b

*do we need to record all of the decision makers of the plot? if so here are their hhids:
gen mgr1 = s11b1q12a
gen mgr2 = s11b1q12b
gen mgr3 = s11b1q12c
gen mgr4 = s11b1q12d

*is this plot irrigated?
rename s11b1q39 irrigated

keep zone ///
state ///
lga ///
sector ///
ea ///
hhid ///
plotid ///
owner1 ///
owner2 ///
mgr1 ///
mgr2 ///
mgr3 ///
mgr4 ///
tracked_obs ///
irrigated ///

compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_clean/data/wave_2/pp_sect11b1.dta", replace
