* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 1 POST HARVEST, NGA SECTA1 AG
	* determines primary and secondary crops, cleans production (quantity, hecatres)
	* converts to hectares and kilograms, as appropriate
	* maybe more who knows
	* outputs clean data file ready for combination with wave 1 hh data

* assumes
	* customsave.ado
	* harvconv_wave1_secta1.dta conversion file
	* land_conversion.dta conversion file 
	
* other notes: 
	* still includes some notes from Alison Conley's work in spring 2020
	
* TO DO:
	* unsure - incomplete, runs but maybe not right? 
	* clarify "does" section

* **********************************************************************
* 0 - setup
* **********************************************************************

* set global user
	global user "aljosephson"
	
* define paths	
	loc root = "G:/My Drive/weather_project/household_data/nigeria/wave_1/raw"
	loc export = "G:/My Drive/weather_project/household_data/nigeria/wave_1/refined"
	loc logout = "G:/My Drive/weather_project/household_data/nigeria/logs"

* close log (in case still open)
	*log close
	
* open log	
	log using "`logout'/ph_secta1", append

* **********************************************************************
* 1 - general clean up, renaming, etc. 
* **********************************************************************
		
* import the first relevant data file
		use "`root'/secta1_harvestw1", clear 	

		* it looks like over 6000 reported that they planted crops on the plot ... 
		* but we only have areas and crop info for about 460 observations

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

gen plot_size_GPS = sa1q9d
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

gen cropcode = main_crop

gen crop1_area = sa1q28a
label variable crop1_area "what was the total area planted on this plot with the main crop during the dry season since the previous interview?"

rename sa1q28b crop1_area_unit

rename sa1q30 plant_month
label variable plant_month "what month did you plant seeds for the main crop during the dry season on this plot since last interview?"

*harvest quantity for main crop
rename sa1q31a harvestq_1

*first unit given for main crop 
generate harv1_unit = sa1q31b

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


* **********************************************************************
* 2 - converting harvest quantities & crop areas to hects & kilograms 
* **********************************************************************

* define new paths for conversions	
	loc root = "G:/My Drive/weather_project/household_data/nigeria/conversion_files/"
  
merge m:1 cropcode harv1_unit using "`root'/harvconv_wave1_secta1"
tab _merge 
* it looks like that went well, non-matched appear to be ones that didn't harvest or didn't have a harvest unit

drop _merge

merge m:1 cropcode harv2_unit using  "`root'/harvconv_wave1_secta1"
tab _merge 
*it looks like that also went well

drop _merge

* **********************************************************************
* 2a - converting harvest quantities to kilograms 
* **********************************************************************

gen harv_kg1 =.
replace harv_kg1 = harvestq_1*harv_conversion
replace harv_kg1 = 0 if harv_kg1 ==. 
*421/456 observations converted
label variable harv_kg1 "main crop harvest quantity in kilograms"

gen harv_kg2 =.
replace harv_kg2 = harvestq_2*harv_conversion2
replace harv_kg2 = 0 if harv_kg2 ==. 
*144/146 observations converted
label variable harv_kg2 "second crop harvest quantity in kilograms"


* **********************************************************************
* 2bi - converting crop areas to hectares - primary crop
* **********************************************************************

tab crop1_area_unit
merge m:1 zone using "`root'/land-conversion"

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
replace crop1_area_hec = plot_size_SR*ridgecon if crop1_area_unit == 2 & crop1_area_hec > 50 & crop1_area_hec < 100000
replace crop1_area_hec = crop1_area*ridgecon if crop1_area_unit == 2
replace crop1_area_hec = plot_size_SR*ridgecon if crop1_area_unit == 2 & crop1_area_hec > 50 & crop1_area_hec < 100000

*convert stands
replace crop1_area_hec = crop1_area*standcon if crop1_area_unit == 3 

*convert plots
replace crop1_area_hec = crop1_area*plotcon if crop1_area_unit == 4

*convert acre
replace crop1_area_hec = crop1_area*acrecon if crop1_area_unit == 5

*convert sq meters
replace crop1_area_hec = crop1_area*sqmcon if crop1_area_unit == 7

*conv hect
replace crop1_area_hec = crop1_area if crop1_area_unit == 6

label variable crop1_area_hec "SR crop area converted to hectares for main crop harvested"

* **********************************************************************
* 2bii - converting crop areas to hectares - secondary crop
* **********************************************************************

gen crop2_area_hec = .

tab crop2_area_unit, nolabel

tab crop2_area_unit

*convert heaps
replace crop2_area_hec = crop2_area*heapcon if crop2_area_unit == 1

*convert ridges
replace crop2_area_hec = crop2_area*ridgecon if crop2_area_unit == 2

*convert stands
replace crop2_area_hec = crop2_area*standcon if crop2_area_unit == 3 

*convert plots
replace crop2_area_hec = crop2_area*plotcon if crop2_area_unit == 4

*convert acre
replace crop2_area_hec = crop2_area*acrecon if crop2_area_unit == 5

*convert sq meters
replace crop2_area_hec = crop2_area*sqmcon if crop2_area_unit == 7

*conv hect
replace crop2_area_hec = crop2_area if crop2_area_unit == 6

label variable crop2_area_hec "SR crop area converted to hectares for main crop harvested"


* **********************************************************************
* 2c - overall hectare conversion 
* **********************************************************************

tab plot_unit

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
*sqm
replace plot_size_hec = plot_size_SR*sqmcon if plot_unit == 7
label variable plot_size_hec "SR plot size converted to hectares"
*hect
replace plot_size_hec = plot_size_SR if plot_unit == 6

*convert gps report to hectares
gen plot_size_2 = .
replace plot_size_2 = plot_size_GPS*sqmcon
label variable plot_size_2 "GPS measured area of plot in hectares"

***only 221 observations of a gps measurement here - perhaps the rest could be in the pp survey?

pwcorr plot_size_hec plot_size_2

tab plot_size_hec
tab plot_size_2
sum plot_size_hec plot_size_2
count if plot_size_2 !=. & plot_size_hec !=.

rename plot_size_2 gps
rename plot_size_hec SR

sum gps, detail
sum SR, detail

pwcorr SR gps if inrange(gps,0,5.3467182)
*low
pwcorr SR gps if inrange(gps,0,5.3467182) & inrange(SR, 0, 21.2972777)
*a little higher but still low
*correlation is bad - impute and replace the SR values with imputed GPS values

* Impute missing plot sizes using predictive mean matching
mi set wide // declare the data to be wide.
mi xtset, clear // this is a precautinary step to clear any xtset that the analyst may have had in place previously
mi register imputed gps // identify plotsize_GPS as the variable being imputed
mi impute pmm gps SR i.lga, add(1) rseed(245780) noisily dots /*
*/ force knn(5) bootstrap
mi unset

tabstat gps SR gps_1_, by(mi_miss) statistics (n mean min max) columns(statistics) longstub format (%9.3g)

rename gps_1_ plot_size_2
label variable plot_size_2 "the imputed and reported values for GPS measure of plot in hectares"

*this was the given measure of plot sizes in GPS, without any imputations

* **********************************************************************
* 3 - end matter, clean up to save
* **********************************************************************

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
crop1_area_hec ///
crop2_area_hec ///
heapcon ///
ridgecon ///
standcon ///
plotcon ///
acrecon ///
hectarecon ///
sqmcon ///
secondcrop ///
crop2_area ///
crop2_area_unit ///
harv1_unit ///
harv2_unit ///
harvestq_1 ///
harvestq_2 ///
harv_kg1 ///
harv_kg2 ///
plant_month2 ///
plot_size_2 ///

*skip plot_size_hec \\ on original list - but omitted from here

compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("ph_secta1.dta") ///
			path("`export'/`folder'") dofile(ph_secta1) user($user)
*note on customsave issue - 2547 observation(s) are missing the ID variable hhid 

* close the log
	log	close

/* END */