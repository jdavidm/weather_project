*WAVE 2 POST PLANTING, NIGERIA AG SECT11A1

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2012_GHSP-W2_v02_M_STATA/Post Planting Wave 2/Agriculture/sect11a1_plantingw2.dta", clear

describe
sort hhid plotid
isid hhid plotid, missok

gen plot_size_SR = s11aq4a
rename s11aq4b plot_unit
label variable plot_size_SR "self reported size of plot, not standardized"
label variable plot_unit "self reported unit of measure, 1=heaps, 2=ridges, 3=stands, 4=plots, 5=acres, 6=hectares, 7=sq meters, 8=other"

gen plot_size_GPS = s11aq4c
label variable plot_size_GPS "in sq. meters"

gen mgr_id = s11aq6a
label variable mgr_id "who in this household manages this plot?"

merge m:1 zone using "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/conversion_files/land-conversion.dta"

tab plot_unit

gen plot_size_hec = .
replace plot_size_hec = plot_size_SR*ridgecon if plot_unit == 2
*heaps
replace plot_size_hec = plot_size_SR*heapcon if plot_unit == 1
*stands
replace plot_size_hec = plot_size_SR*standcon if plot_unit ==3
*plots
replace plot_size_hec = plot_size_SR*plotcon if plot_unit == 4
*acre
replace plot_size_hec = plot_size_SR*acrecon if plot_unit == 5
*sqm
replace plot_size_hec = plot_size_SR*sqmcon if plot_unit == 7
*hec 
replace plot_size_hec = plot_size_SR if plot_unit == 6


*only losing 2 observations by not including "other" units
label variable plot_size_hec "SR plot size converted to hectares"

*convert gps report to hectares
gen plot_size_2 = .
replace plot_size_2 = plot_size_GPS*sqmcon
label variable plot_size_2 "GPS measured area of plot in hectares"
***about 600 missing values from gps measurement area

keep zone ///
state ///
lga ///
sector ///
ea ///
hhid ///
plotid ///
plot_unit ///
tracked_obs ///
plot_size_SR ///
plot_size_GPS ///
mgr_id ///
plot_size_hec ///
plot_size_2 ///
ridgecon ///
heapcon ///
standcon ///
plotcon ///
acrecon ///
sqmcon ///

compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_clean/data/wave_2/pp_sect11a1.dta", replace
