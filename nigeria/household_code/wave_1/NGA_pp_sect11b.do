*WAVE 1 POST PLANTING, NIGERIA SECT 11B AG

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2010_GHSP-W1_v03_M_STATA/Post Planting Wave 1/Agriculture/sect11b_plantingw1.dta", clear

describe
sort hhid plotid
isid hhid plotid, missok

generate cultivated_plot = s11bq16
label variable cultivated_plot "since beginning of year did anyone in hh cultivated plot?"

generate irrigated = s11bq24
label variable irrigated "is this plot irrigated?"

keep zone ///
state ///
lga ///
ea ///
hhid ///
plotid ///
cultivated_plot ///
irrigated ///

compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_clean/data/wave_1/pp_sect11b.dta", replace
