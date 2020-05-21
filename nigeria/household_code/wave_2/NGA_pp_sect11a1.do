* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Edited by: ek
* Stata v.16

* does
	* reads in Nigeria, WAVE 2 POST PLANTING, NIGERIA AG SECT11A1
	* cleans plot size and converts to hecatres
	* imputes plot size values 
	* outputs clean data file ready for combination with wave 2 hh data

* assumes
	* customsave.ado
	* land_conversion.dta conversion file

* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
		loc		root		=		"$data/household_data/nigeria/wave_2/raw"
		loc		cnvrt		=		"$data/household_data/nigeria/conversion_files"
		loc		export		=		"$data/household_data/nigeria/wave_2/refined"
		loc		logout		= 		"$data/household_data/nigeria/logs"

* close log if open
		*log 	close 
		
* open log
		log 	using	 			"`logout'/wave_2_pp_sect11a1", append

* **********************************************************************
* 1 - describing plot size - self-reported and GPS 
* **********************************************************************

* import the first relevant data file
		use 					"`root'/sect11a1_plantingw2", clear

* need plot id to uniquely identify
		describe
		sort 					hhid plotid
		isid 					hhid plotid, missok

* determine self reported plotsize
		gen 					plot_size_SR = s11aq4a
		rename 					s11aq4b plot_unit
		lab	var					plot_size_SR "self reported size of plot, not standardized"
		lab var					plot_unit "self reported unit of measure"

* determine GPS plotsize
		gen 					plot_size_GPS = s11aq4c
		lab var					plot_size_GPS 	"GPS plot size in sq. meters"

* **********************************************************************
* 2 - conversion to hectares
* **********************************************************************

* merge in conversion file
		merge 				m:1 	zone using 	"`cnvrt'/land-conversion"
	*** all observations matched

		keep 				if 		_merge == 3
		drop 						_merge

		tab 						plot_unit

* convert to hectares
	*** 29 observations have no value (=.) for plot_size_SR
* from ridges 
		gen 				plot_size_hec = .
		replace 			plot_size_hec = plot_size_SR*ridgecon	if plot_unit == 2
* from heaps
		replace 			plot_size_hec = plot_size_SR*heapcon	if plot_unit == 1
* from stands
		replace 			plot_size_hec = plot_size_SR*standcon	if plot_unit == 3
* from plots
		replace 			plot_size_hec = plot_size_SR*plotcon	if plot_unit == 4
* from acre
		replace 			plot_size_hec = plot_size_SR*acrecon	if plot_unit == 5
* from sqm
		replace 			plot_size_hec = plot_size_SR*sqmcon		if plot_unit == 7
* from hec
		replace 			plot_size_hec = plot_size_SR			if plot_unit == 6
	*** 60 observations have no value (=.) after conversion to plot_size_hec
	*** only losing 2 observations by not including "other" units 
	*** remaining 58 observations have no plot_unit identified 
	
		rename 				plot_size_hec plot_size_hec_SR
		lab var				plot_size_hec_SR 	"SR plot size converted to hectares"

* convert gps report to hectares
		gen 				plot_size_hec2 = .
		replace 			plot_size_hec2 = plot_size_GPS*sqmcon
		rename 				plot_size_hec2 plot_size_hec_GPS
		lab		var			plot_size_hec_GPS "GPS measured area of plot in hectares"

		count 				if plot_size_hec_SR ==.
	*** 60 observations do not have plot_size_hec_SR 
		count 				if plot_size_hec_SR !=.
	*** which means that 5833 have plot_size_hec_SR 
		count 				if plot_size_hec_GPS ==.
	*** 738 observations do not have plot_size_hec_GPS - same number as plot_size_GPS
		count 				if plot_size_hec_GPS !=.
	*** which means that 5155 have plot_size_hec_GPS
		count	 			if plot_size_hec_SR != . & plot_size_hec_GPS != .
	*** 5125 observations have both SR and GPS
		count	 			if plot_size_hec_SR == . & plot_size_hec_GPS == .
	*** 30 observations are missing both
		
		pwcorr 				plot_size_hec_SR plot_size_hec_GPS
	*** relatively low correlation, 0.13 between SR  and GPS

* check correlation within +/- 3sd of mean (GPS)
		sum 				plot_size_hec_GPS, detail
		pwcorr 				plot_size_hec_SR plot_size_hec_GPS if ///
							inrange(plot_size_hec_GPS,`r(p50)'-(3*`r(sd)'),`r(p50)'+(3*`r(sd)'))
	*** correlation of points with +/- 3sd is lower = 0.071

* check correlation within +/- 3sd of mean (GPS and SR)
		sum 				plot_size_hec_GPS, detail
		sum 				plot_size_hec_SR, detail
		pwcorr 				plot_size_hec_SR plot_size_hec_GPS if ///
								inrange(plot_size_hec_GPS,`r(p50)'-(3*`r(sd)'),`r(p50)'+(3*`r(sd)')) & ///
								inrange(plot_size_hec_SR,`r(p50)'-(3*`r(sd)'),`r(p50)'+(3*`r(sd)'))
	*** correlation between self reported and GPS for values within +/- 3 sd's of GPS and SR is still lower = 0.0697

* correlation low - impute
		tab					plot_size_hec_GPS 	if 	plot_size_hec_GPS > 2
	*** 198 GPS which are greater than 2

* correlation at higher plot sizes
		list 				plot_size_hec_GPS plot_size_hec_SR 	if ///
								plot_size_hec_GPS > 3 & !missing(plot_size_hec_GPS), sep(0)
		pwcorr 				plot_size_hec_GPS plot_size_hec_SR 	if 	///
								plot_size_hec_GPS > 3 & !missing(plot_size_hec_GPS)
	*** correlation at higher plot sizes is slightly higher but still not for whole sample = 0.1157

		sum 				plot_size_hec_GPS
		sum 				plot_size_hec_SR
	*** GPS tending to be smaller than self-reported
	*** mean SR = 2.47 with sd of 58.37
	*** mean GPS = 0.51, with sd of 0.85
	*** SR seems unreliable, given outliers on both ends

		tab					plot_size_hec_GPS 	if 	plot_size_hec_GPS < 0.1
		*** 1,344 observations of GPS below 0.1

		list 				plot_size_hec_GPS plot_size_hec_SR 	if 	///
								plot_size_hec_GPS < 0.01, sep(0)
		pwcorr 				plot_size_hec_GPS plot_size_hec_SR 	if ///
								plot_size_hec_GPS < 0.01
	*** very low relationship between GPS and SR plotsize below 0.01, correlation = 0.021

		histogram 			plot_size_hec_GPS 	if 	plot_size_hec_GPS < 0.3
		histogram 			plot_size_hec_GPS 	if 	plot_size_hec_GPS < 0.2
		histogram 			plot_size_hec_GPS 	if 	plot_size_hec_GPS < 0.1
	*** does not seem to have extreme pooling - differs from Y1 
	*** outliers do not seem unrealisitic - no reason to doubt GPS values 
	*** based on consideration of outliers - not going to drop any before imputation 

* impute missing plot sizes using predictive mean matching
* impute only based on GPS 
		mi set wide // declare the data to be wide.
		mi xtset, clear // this is a precautinary step to clear any existing xtset
		mi register imputed plot_size_hec_GPS // identify plotsize_GPS as the variable being imputed
		mi impute pmm plot_size_hec_GPS i.lga, add(1) rseed(245780) noisily dots ///
			force knn(5) bootstrap
		mi unset

* look at the data
		tab					mi_miss
		tabstat 			plot_size_hec_GPS plot_size_hec_SR plot_size_hec_GPS_1_, ///
								by(mi_miss) statistics(n mean min max) columns(statistics) ///
								longstub format(%9.3g)

* drop if anything else is still missing
		list					plot_size_hec_GPS plot_size_hec_SR 	if 	///
									missing(plot_size_hec_GPS_1_), sep(0)
		drop 					if missing(plot_size_hec_GPS_1_)
		*** 0 observations deleted

* **********************************************************************
* 3 - end matter, clean up to save
* **********************************************************************

		rename				plot_size_hec_GPS_1_ plotsize
		lab	var				plotsize	"plot size (ha)"

		keep 				hhid zone state lga ea plotid plotsize	

		compress
		describe
		summarize

* save file
		customsave , idvar(hhid) filename("pp_sect11a1.dta") ///
			path("`export'") dofile(pp_sect11a1) user($user)

* close the log
	log	close

/* END */
