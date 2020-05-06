*WAVE 3 POST HARVEST, NIGERIA AG SECTA1
**about: ownership & mgmt

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2015_GHSP-W3_v02_M_Stata/Post Harvest Wave 3/secta1_harvestw3.dta", clear

describe
sort hhid plotid
isid hhid plotid, missok

gen plot_mgr = sa1q2
label variable plot_mgr "who manages this plot?"
***HELP: there is another survey question that asks this and is called "sa1q11" but they 
***are not exactly the same and q11 only has about 150 observations whereas sa1q2 
***has over 5000 - do we need this?

rename sa1q3 new_plot
label variable new_plot "is this a new plot?"

gen plot_size_SR = sa1q9a
label variable plot_size_SR "self-reported"
rename sa1q9b plot_unit

tab plot_unit, nolabel
tab plot_unit

merge m:1 zone using "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/conversion_files/land-conversion.dta"

***converting plot_size_SR to hectares
gen plot_size_hec = . 
replace plot_size_hec = plot_size_SR*heapcon if plot_unit == 1
replace plot_size_hec = plot_size_SR*standcon if plot_unit == 3
replace plot_size_hec = plot_size_SR*ridgecon if plot_unit == 2
replace plot_size_hec = plot_size_SR*plotcon if plot_unit == 4
replace plot_size_hec = plot_size_SR*acrecon if plot_unit == 5
label variable plot_size_hec "SR plot size converted to hectares"

gen plot_size_GPS = sa1q9c
label variable plot_size_GPS "GPS measure in square meters"

***converting plot_size_GPS to hectares
gen plot_size_2 = .
replace plot_size_2 = plot_size_GPS*sqmcon
label variable plot_size_2 "GPS measured area of plot in hectares"


rename sa1q1a w2_gps
label variable w2_gps "binary for if the plot was previously measured in wave 2"
**not sure if we need this, but may be a good reference if we have missing gps measurements
**because they could have only recorded it in wave 2?

gen plot_owner = sa1q14
label variable plot_owner "who is the owner of this plot? hhid"
**they also provide a second owner (in all waves) but I didn't record it because I didn't think we needed it, 
**but we do have that info

rename sa1q23 transfer_mgr
label variable transfer_mgr "has the manager of this plot changed since the last interview? binary"
**on the survey, they give sa1q24 gives the hhids of up to 4 of the current plot managers - may want this?


keep zone ///
state ///
lga ///
sector ///
hhid ///
ea ///
plotid ///
plot_mgr ///
plot_size_SR ///
plot_unit ///
plot_size_GPS ///
plot_owner ///
transfer_mgr ///
plot_size_2 ///
w2_gps ///
plot_size_hec ///

compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_clean/data/wave_3/ph_secta1.dta", replace
