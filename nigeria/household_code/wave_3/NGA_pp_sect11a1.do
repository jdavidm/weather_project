*WAVE 3 POST PLANTING, NIGERIA AG SECTA1
**wave 3 does not have the tracked_obs variable that was present in wave 2 - may not be a problem (looks like we may have a key) but worth noting

use "/Users/aljosephson/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2015_GHSP-W3_v02_M_Stata/Post Planting Wave 3/sect11a1_plantingw3.dta", clear

describe
sort hhid plotid
isid hhid plotid, missok

gen plot_size_SR = s11aq4a
rename s11aq4b SR_unit
label variable plot_size_SR "self reported size of plot, not standardized"
label variable SR_unit "self reported unit of measure, 1=heaps, 2=ridges, 3=stands, 4=plots, 5=acres, 6=hectares, 7=sq meters, 8=other"

gen plot_size_GPS = s11aq4c
label variable plot_size_GPS "in sq. meters"

merge m:1 zone using "/Users/aljosephson/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/conversion_files/land-conversion.dta"

tab SR_unit, nolabel

gen plot_size_hec = .
replace plot_size_hec = plot_size_SR*ridgecon if SR_unit == 2
*heaps
replace plot_size_hec = plot_size_SR*heapcon if SR_unit == 1
*stands
replace plot_size_hec = plot_size_SR*standcon if SR_unit ==3
*plots
replace plot_size_hec = plot_size_SR*plotcon if SR_unit == 4
*acre
replace plot_size_hec = plot_size_SR*acrecon if SR_unit == 5
*sqm
replace plot_size_hec = plot_size_SR*sqmcon if SR_unit == 7
*remember to convert hectares 

*all appear to have converted properly
summ plot_size_hec 
***HELP WITH THE EXTREME VALUES

label variable plot_size_hec "SR plot size converted to hectares"

*convert gps report to hectares
gen plot_size_2 = .
replace plot_size_2 = plot_size_GPS*sqmcon
label variable plot_size_2 "GPS measured area of plot in hectares"
*tons of missing data for the gps reported size

gen mgr_id = s11aq6a
label variable mgr_id "who in this household manages this plot?"

keep zone ///
state ///
lga ///
sector ///
ea ///
hhid ///
plotid ///
SR_unit ///
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

save "/Users/aljosephson/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_clean/data/wave_3/pp_sect11a1.dta", replace

