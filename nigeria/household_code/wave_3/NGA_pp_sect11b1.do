*WAVE 3 POST PLANTING, NIGERIA AG SECT11B1

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2015_GHSP-W3_v02_M_Stata/Post Planting Wave 3/sect11b1_plantingw3.dta", clear

describe
sort hhid plotid
isid hhid plotid, missok

*owner(s) of plots, I don't think we will need this, it's only for plots that people hold a title too
gen owner1 = s11b1q6a
gen owner2 = s11b1q6b

*do we need to record all of the decision makers of the plot? this is for plots that are owned if so here are their hhids:
gen mgr1 = s11b1q12a
gen mgr2 = s11b1q12b
gen mgr3 = s11b1q12c
gen mgr4 = s11b1q12d

*is this plot irrigated?
rename s11b1q39 irrigated

*primary decision makers for rented plots
rename s11b1q16b1 rent_mgr1
rename s11b1q16b2 rent_mgr2

*binary for cultivation of plot
rename s11b1q27 cultivated

*plot use (probably won't need this one because we should be able to see whether the plot was 
*harvested or not based on other info or previously established binary)
rename s11b1q28 plot_use


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
irrigated ///
rent_mgr1 ///
rent_mgr2 ///
plot_use ///



compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_clean/data/wave_3/pp_sect11b1.dta", replace
