*WAVE 2, POST HARVEST, NIGERIA AG SECTA1

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2012_GHSP-W2_v02_M_STATA/Post Harvest Wave 2/Agriculture/secta1_harvestw2.dta", clear

describe
sort hhid plotid
isid hhid plotid, missok

gen plot_mgr = sa1q2
label variable plot_mgr "who manages this plot?"

rename sa1q3 new_plot
label variable new_plot "is this a new plot?"

gen plot_size_SR = sa1q9a
label variable plot_size_SR "self-reported"
rename sa1q9b plot_unit

gen plot_size_GPS = sa1q9c
label variable plot_size_GPS "GPS measure in square meters"

gen plot_label = sa1q10c
label variable plot_label "save plot label as household number and plotid"

gen plot_owner = sa1q14
label variable plot_owner "who is the owner of this plot? hhid"

rename sa1q23 transfer_mgr
label variable transfer_mgr "has the manager of this plot changed since the last interview?"

rename sa1q26 planted
label variable planted "did you plant any crops on this plot during the dry season (since the last interview)?"

rename sa1q27 main_crop
label variable main_crop "what crop did you mainly plant on this plot during the dry season?"
tab main_crop
*main crop is cassava

gen crop1_area = sa1q28a
label variable crop1_area "what was the total area planted on this plot with the main crop during the dry season since the previous interview?"

rename sa1q28b crop1_area_unit

rename sa1q30 plant_month
label variable plant_month "what month did you plant seeds for the main crop during the dry season on this plot since last interview?"

rename harvestq_1

*the secondary crop harvested
rename sa1q33 secondcrop

*crop area used for secondary crop, non-standardized unit
rename sa1q34a crop2_area

*first unit given for secondary crop
rename sa1q34b crop2_area_unit

*secondary crop quantity
rename sa1q37a harvestq_2

*secondary crop plant month
rename sa1q36 plant_month2

*secondary crop quantity unit. note: the survey asked for another unit, however there were no observations listed for it so I didn't record it here
generate harv2_unit = sa1q37b 

*** CONVERTING HARVEST QUANTITIES TO KGS


merge m:1 cropcode harv1_unit using "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/conversion_files/wave_2/harvconv_wave2_ph_secta1.dta"
*

drop _merge

merge m:1 cropcode harv2_unit using "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/conversion_files/wave_2/harvconv_wave2_ph_secta1.dta"
tab _merge harvestq_2
*



drop _merge

gen harv_kg1 =.
replace harv_kg1 = harvestq_1*harv_conversion
replace harv_kg1 = 0 if harv_kg1 ==. 
* observations converted

gen harv_kg2 =.
replace harv_kg2 = harvestq_2*harv_conversion2
replace harv_kg2 = 0 if harv_kg2 ==. 
* observations converted


****CONVERTING CROP AREAS
tab crop1_area_unit
merge m:1 zone using "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/conversion_files/land-conversion.dta"
tab _merge
drop _merge


tab crop1_area_unit
tab crop1_area_unit, nolabel

gen crop1_area_hec = .

*convert heaps
replace crop1_area_hec = crop1_area*heapcon if crop1_area_unit == 1

*convert ridges
replace crop1_area_hec = crop1_area*ridgecon if crop1_area_unit == 2

*fixing 1 extreme value with suspected data entry error
replace crop1_area_hec = crop1_area*ridgecon if crop1_area_unit == 2

*convert stands
replace crop1_area_hec = crop1_area*standcon if crop1_area_unit == 3 


*convert plots
replace crop1_area_hec = crop1_area*plotcon if crop1_area_unit == 4

*convert acre
replace crop1_area_hec = crop1_area*acrecon if crop1_area_unit == 5

*convert sq meters
replace crop1_area_hec = crop1_area*sqmcon if crop1_area_unit == 7

*hec 
replace crop1_area_hec = crop1_area if crop1_area_unit == 6

label variable crop1_area_hec "SR crop area converted to hectares"

tab plot_unit

***CONVERTING PLOT SIZES to hectares
*ridges
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
*hec
replace plot_size_hec = plot_size_SR if plot_unit == 6
*sqm
replace plot_size_hec = plot_size_SR*sqmcon if plot_unit == 7
label variable plot_size_hec "SR plot size converted to hectares"


*convert gps report to hectares
gen plot_size_2 = .
replace plot_size_2 = plot_size_GPS*sqmcon
label variable plot_size_2 "GPS measured area of plot in hectares"


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
plot_label ///
plot_owner ///
transfer_mgr ///
planted ///
main_crop ///
crop1_area ///
crop1_area_unit ///
plant_month ///
tracked_obs ///
plot_size_2 ///
plot_size_hec ///
heapcon ///
ridgecon ///
standcon ///
acrecon ///
sqmcon ///
plotcon ///

compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_clean/data/wave_2/ph_secta1.dta", replace
