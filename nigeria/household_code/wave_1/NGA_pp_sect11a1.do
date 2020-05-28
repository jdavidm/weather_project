* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 1 (2010-2011) - POST PLANTING NIGERIA, SECT 11A1 AG
	* cleans plot size (SR & GPS) for main rainy season + converts to hectares 
	* imputes values using GPS measures for plot size 
	* outputs clean data file ready for combination with wave 1 hh data

* assumes
	* customsave.ado
	* land_conversion.dta conversion file 
	
* TO DO:
	* complete 
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* set global user
	global user "emilk"
	
* define paths	
	loc root = "G:/My Drive/weather_project/household_data/nigeria/wave_1/raw"
	loc export = "G:/My Drive/weather_project/household_data/nigeria/wave_1/refined"
	loc logout = "G:/My Drive/weather_project/household_data/nigeria/logs"

* close log (in case still open)
	*log close
	
* open log	
	log using "`logout'/pp_sect11a1", append

* **********************************************************************
* 1 - general clean up, renaming, etc. 
* **********************************************************************

* import the first relevant data file
		use "`root'/sect11a1_plantingw1", clear 	

*need plot id to uniquely identify
describe
sort hhid plotid
isid hhid plotid

*determine self reported plotsize 
generate 		plot_size_SR = s11aq4a
rename 			s11aq4b  plot_unit
lab	var			plot_size_SR 			"self reported size of plot, not standardized"
lab var			plot_unit				"self reported unit of measure"

*determine GPS plotisize 
generate plot_size_GPS = s11aq4d
label variable plot_size_GPS "GPS plot size in sq. meters"

* **********************************************************************
* 2 - conversions
* **********************************************************************

* define new paths for conversions	
	loc root = "G:/My Drive/weather_project/household_data/nigeria/conversion_files/"

*merge in conversion file
merge m:1 zone using "`root'/land-conversion"
*All observations matched

*convert to hectares 
*in this case multiply to convert, but confirm in each case 
gen plot_size_hec = .
*heaps
replace plot_size_hec = plot_size_SR*heapcon if plot_unit == 1
*ridges 
replace plot_size_hec = plot_size_SR*ridgecon if plot_unit == 2
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

tab plot_unit
tab plot_unit if plot_unit==8
	***62 obs of other units that do not have a conversion - not converted to hectares 
*Do those other unit observations have a GPS measure?
tab plot_size_GPS if plot_unit==8
***yes all those observations with other units have a GPS measure

rename plot_size_hec plot_size_hec_SR 
label variable plot_size_hec_SR "SR plot size converted to hectares"
	***plot_size_hec is missing in observations where plot_unit is missing, plot_size_SR is missing
	
*convert gps report to hectares
gen plot_size_2 = .
replace plot_size_2 = plot_size_GPS*sqmcon
rename plot_size_2 plot_size_hec_GPS
label variable plot_size_hec_GPS "GPS measured area of plot in hectares"
	***about 600 missing values from gps measurement area

count if plot_size_hec_SR !=. & plot_size_hec_GPS !=.
*total of 5,205 not missing - out of 6,086 
count if plot_size_hec_SR !=. | plot_size_hec_GPS !=.
*5,933 out of 6,086 observatins have at least one measure either SR or GPS

pwcorr plot_size_hec_SR plot_size_hec_GPS  
*large differences - but checked against each other using code below
*based on this will impute missing values 

gen lngps = ln(plot_size_hec_GPS)
gen lnsr = ln(plot_size_hec_SR)
twoway (kdensity lngps) (kdensity lnsr)
*GPS tends to have a smaller variance and smaller values as compared to self-reported

sum plot_size_hec_GPS, detail
sum plot_size_hec_SR, detail

************************************************WORK THROUGH HERE 

*check correlation within +/- 3sd of mean (GPS)
sum plot_size_hec_GPS, detail
pwcorr plot_size_hec_SR plot_size_hec_GPS if inrange(plot_size_hec_GPS,`r(p50)'-(3*`r(sd)'),`r(p50)'+(3*`r(sd)'))
	***0 correlation
	
*check correlation within +/- 3sd of mean (GPS and SR)
sum plot_size_hec_GPS, detail
sum plot_size_hec_SR, detail
pwcorr plot_size_hec_SR plot_size_hec_GPS if inrange(plot_size_hec_GPS,`r(p50)'-(3*`r(sd)'),`r(p50)'+(3*`r(sd)')) & inrange(plot_size_hec_SR,`r(p50)'-(3*`r(sd)'),`r(p50)'+(3*`r(sd)'))
	***slightly higher 0.0319...
	
*correlation low - impute 
tabulate plot_size_hec_GPS if plot_size_hec_GPS>2 
	***308 GPS which are greater than 2 
list plot_size_hec_GPS plot_size_hec_SR if plot_size_hec_GPS>3 & !missing(plot_size_hec_GPS), sep(0)
pwcorr plot_size_hec_SR plot_size_hec_GPS if plot_size_hec_GPS>3
	***Negative correlation of -0.03 for GPS>3
	
*GPS on the smaller side vs self-report 
tabulate plot_size_hec_GPS if plot_size_hec_GPS<0.1	
	***1,455 below 0.1
	

list plot_size_hec_GPS plot_size_hec_SR if plot_size_hec_GPS<0.01, sep(0)		
	***little relationship between GPS and SR below .1 
	histogram 		plot_size_hec_GPS 	if 	plot_size_hec_GPS < 0.3
	***GPS small - sometimes unreasonably so
* make GPS values missing if below 0.05 for impute
	replace 		plot_size_hec_GPS = . 	if 	plot_size_hec_GPS < 0.05
	*** 1,052 changed to missing
	
replace plot_size_hec_GPS = . if plot_size_hec_GPS > 20
	***4 changed to missing 

*impute missing + irregular plot sizes using predictive mean matching
mi set wide // declare the data to be wide.
mi xtset, clear // this is a precautinary step to clear any xtset that the analyst may have had in place previously
mi register imputed plot_size_hec_GPS // identify plotsize_GPS as the variable being imputed
mi impute pmm plot_size_hec_GPS i.lga, add(1) rseed(245780) noisily dots /*
*/ force knn(5) bootstrap
mi unset

*look at the data 
tabulate mi_miss
tabstat plot_size_hec_GPS plot_size_hec_SR plot_size_hec_GPS_1_, by(mi_miss) statistics(n mean min max) columns(statistics) longstub format(%9.3g) 

*drop if anything else is still missing 
list plot_size_hec_GPS plot_size_hec_SR if missing(plot_size_hec_GPS_1_), sep(0)
drop if missing(plot_size_hec_GPS_1_)
	***0 observations dropped 

* **********************************************************************
* 3 - end matter, clean up to save
* **********************************************************************

rename plot_size_hec_GPS_1_ plotsize 
label variable plotsize	"plot size (ha)"

keep hhid ///
zone ///
state ///
lga ///
hhid ///
ea ///
plotid ///
plotsize 

compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("pp_sect11a1.dta") ///
			path("`export'/`folder'") dofile(pp_sect11a1) user($user)

* close the log
	log	close

/* END */