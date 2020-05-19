* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Edited by: ek
* Stata v.16

* does
	* reads in Nigeria, WAVE 2 POST PLANTING, NIGERIA AG SECT11A1
	* determines primary and secondary crops, cleans plot size (hecatres)
	* maybe more who knows
	* outputs clean data file ready for combination with wave 2 hh data

* assumes
	* customsave.ado
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
		global		 user 		"emilk"
	
	* define paths	
	loc root	= "G:/My Drive/weather_project/household_data/nigeria/wave_2/raw"
	loc export 	= "G:/My Drive/weather_project/household_data/nigeria/wave_2/refined"
	loc logout	= "G:/My Drive/weather_project/household_data/nigeria/logs"

	* close log (in case still open)
	*log close
	
	* open log	
		log 	using	 "`logout'/pp_sect11a1", append

* **********************************************************************
* 1 - describing plot size, etc.
* **********************************************************************
		
	* import the first relevant data file
		use "`root'/sect11a1_plantingw2", clear 	

	*need plot id to uniquely identify
		describe
		sort 	hhid plotid
		isid 	hhid plotid, missok

	*determine self reported plotsize
		gen 	plot_size_SR = s11aq4a
		rename 	s11aq4b plot_unit
		label 	variable plot_size_SR "self reported size of plot, not standardized"
		label 	variable plot_unit "self reported unit of measure, 1=heaps, 2=ridges, 3=stands, 4=plots, 5=acres, 6=hectares, 7=sq meters, 8=other"

	*determine GPS plotsize
		gen 	plot_size_GPS = s11aq4c
		label 	variable plot_size_GPS 	"GPS plot size in sq. meters"

	*does not appear in model code - will delete if it is not used further on
		gen 	mgr_id = s11aq6a
		label 	variable mgr_id 	"who in this household manages this plot?"


* **********************************************************************
* 2 - conversions
* **********************************************************************

	* define new paths for conversions	
	loc root = "G:/My Drive/weather_project/household_data/nigeria/conversion_files/"

	*merge in conversion file
		merge 	m:1 	zone using 	"`root'/land-conversion"

		tab plot_unit

	*convert to hectares
		gen plot_size_hec = .
		replace plot_size_hec = plot_size_SR*ridgecon 	if plot_unit == 2
		*heaps
		replace plot_size_hec = plot_size_SR*heapcon 	if plot_unit == 1
		*stands
		replace plot_size_hec = plot_size_SR*standcon 	if plot_unit ==3
		*plots
		replace plot_size_hec = plot_size_SR*plotcon 	if plot_unit == 4
		*acre
		replace plot_size_hec = plot_size_SR*acrecon 	if plot_unit == 5
		*sqm
		replace plot_size_hec = plot_size_SR*sqmcon 	if plot_unit == 7
		*hec 
		replace plot_size_hec = plot_size_SR 			if plot_unit == 6

	*only losing 2 observations by not including "other" units
		rename 		plot_size_hec plot_size_hec_SR
		label 		variable plot_size_hec_SR 	"SR plot size converted to hectares"

	*convert gps report to hectares
		gen 		plot_size_2 = .
		replace 	plot_size_2 = plot_size_GPS*sqmcon
		rename 		plot_size_2 plot_size_hec_GPS
		label 		variable plot_size_hec_GPS "GPS measured area of plot in hectares"
		***about 600 missing values from gps measurement area

	count	 if 	plot_size_hec_SR !=. & plot_size_hec_GPS !=.
		***768 obersvations missing both plot size selfreported and plot size GPS measure

	pwcorr 			plot_size_hec_SR plot_size_hec_GPS  
		***low correlation, 0.12 between selfreported plot size and GPS

	*check correlation within +/- 3sd of mean (GPS)
		sum 		plot_size_hec_GPS, detail
		pwcorr 		plot_size_hec_SR plot_size_hec_GPS 	if 	inrange(plot_size_hec_GPS,`r(p50)'-(3*`r(sd)'),`r(p50)'+(3*`r(sd)'))
		***correlation of points with +/- 3sd is low 0.07

	*check correlation within +/- 3sd of mean (GPS and SR)
		sum 		plot_size_hec_GPS, detail
		sum 		plot_size_hec_SR, detail
		pwcorr 		plot_size_hec_SR plot_size_hec_GPS 	if 	inrange(plot_size_hec_GPS,`r(p50)'-(3*`r(sd)'),`r(p50)'+(3*`r(sd)')) & inrange(plot_size_hec_SR,`r(p50)'-(3*`r(sd)'),`r(p50)'+(3*`r(sd)'))
		***correlation between self reported and GPS for values within +/- 3 sd's of GPS and SR is still low 0.0697

	*correlation low - impute 
		tabulate 	plot_size_hec_GPS 	if 	plot_size_hec_GPS>2 
		***198 GPS which are greater than 2 

	*correlation at higher plot sizes
		list 		plot_size_hec_GPS plot_size_hec_SR 	if 	plot_size_hec_GPS>3 & !missing(plot_size_hec_GPS), sep(0)
		pwcorr 		plot_size_hec_GPS plot_size_hec_SR 	if 	plot_size_hec_GPS>3 & !missing(plot_size_hec_GPS)
		***correlation at higher plot sizes is higher 0.1157

		sum 	plot_size_hec_GPS
		sum 	plot_size_hec_SR
		***GPS tending to be smaller than self-reported

		tabulate 	plot_size_hec_GPS 	if 	plot_size_hec_GPS<0.1	
		***1,344  below 0.1
		list 		plot_size_hec_GPS plot_size_hec_SR 	if 	plot_size_hec_GPS<0.01, sep(0)
		pwcorr 		plot_size_hec_GPS plot_size_hec_SR 	if plot_size_hec_GPS<0.01	
		***Very small relationship between GPS and SR plotsize, correlation = 0.02 
 
		***GPS small - sometimes unreasonably so 
		histogram 	plot_size_hec_GPS 	if 	plot_size_hec_GPS < 0.3


	*make GPS values missing if below 0.05 for impute
		replace 	plot_size_hec_GPS = . 	if 	plot_size_hec_GPS <0.05
		***714 changed to missing 
		replace 	plot_size_hec_GPS = . 	if 	plot_size_hec_GPS > 20
		***no changes made
 
	*impute missing + irregular plot sizes using predictive mean matching
		mi set 	wide // declare the data to be wide.
		mi xtset, clear // this is a precautinary step to clear any xtset that the analyst may have had in place previously
		mi 	register imputed plot_size_hec_GPS // identify plotsize_GPS as the variable being imputed
		mi 	impute 	pmm plot_size_hec_GPS i.lga, add(1) rseed(245780) noisily dots /*
		*/ force knn(5) bootstrap
		mi unset

	*look at the data 
		tabulate 	mi_miss
		tabstat 	plot_size_hec_GPS plot_size_hec_SR plot_size_hec_GPS_1_, by(mi_miss) statistics(n mean min max) columns(statistics) longstub format(%9.3g) 

	*drop if anything else is still missing 
		list 	plot_size_hec_GPS plot_size_hec_SR 	if 	missing(plot_size_hec_GPS_1_), sep(0)
		drop 	if 		missing(plot_size_hec_GPS_1_)
		***0 observations deleted

* **********************************************************************
* 3 - end matter, clean up to save
* **********************************************************************

	rename 		plot_size_hec_GPS_1_ plotsize 
	label 		variable plotsize	"plot size (ha)"

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