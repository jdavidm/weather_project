* Project: WB Weather
* Created on: June 2020
* Created by: ek
* Stata v.16

* does
	* reads in Niger, WAVE 1 (2011),POST PLANTING (first passage), ecvmaas1_p1_en
	* cleans plot size (hecatres)
	* outputs clean data file ready for combination with wave 1 plot data

* assumes
	* customsave.ado

* TO DO:
	* 	*** cant find "extension" variable like they have in wave 2. This is a problem because in wave 2 we make a unique id based on clusterid, hhnumber, extension, order, field, and parcel to uniquely identify
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		root	=		"$data/household_data/niger/wave_1/raw"
	loc		export	=		"$data/household_data/niger/wave_1/refined"
	loc		logout	= 		"$data/household_data/niger/logs"

* open log
	log 	using	"`logout'/2011_as1_p1", append

* **********************************************************************
* 1 - describing plot size - self-reported and GPS
* **********************************************************************
	
* import the first relevant data file
	use				"`root'/ecvmaas1_p1_en", clear
	
	rename 			passage visit
	label 			var visit "number of visit - wave number"
	rename			grappe clusterid
	label 			var clusterid "cluster number"
	rename			menage hh_num
	label 			var hh_num "household number - not unique id"
	rename 			as01qa ord 
	label 			var ord "number of order"
	*** note that ord is the id number
	rename 			as01q03 field 
	label 			var field "field number"
	rename 			as01q05 parcel 
	label 			var parcel "parcel number"
	*** cant find "extension" variable like they have in wave 2. This is a problem because in wave 2 we make a unique id based on clusterid, hhnumber, extension, order, field, and parcel to uniquely identify
	
* need to include clusterid, hhnumber, order, field, and parcel to uniquely identify
	describe
	sort 			clusterid hh_num ord field parcel
	isid 			clusterid hh_num ord field parcel
	
* determine cultivated plot
	rename 			as01q40 cultivated
	label 			var cultivated "plot cultivated"

* drop if not cultivated
	keep 			if cultivated == 1
	*** 220 observations dropped
	*** as01q42 asks about fallow specifically rather than did you cultivate 
	
* determine self reported plotsize
	gen 			plot_size_SR = as01q08
	lab	var			plot_size_SR "self reported size of plot, in square meters"
	*** all plots measured in metre carre - square meters

	replace			plot_size_SR = . if plot_size_SR > 999997
	*** 110 changed to missing 

* determine GPS plotsize
	gen 			plot_size_GPS = as01q09
	lab var			plot_size_GPS 	"GPS plot size in sq. meters"
	*** all plots measured in metre carre - square meters
	*** 999999 seems to be a code used to designate missing values
	
	replace			plot_size_GPS = . if plot_size_GPS > 999997
	***  changed to missing 
	
* drop if SR and GPS both equal to 0
	drop	 		if plot_size_GPS == 0 & plot_size_SR == 0
	*** 31 values dropped  

* assume 0 GPS reading should be . values 
	replace 		plot_size_GPS = . if plot_size_GPS < 5 
	*** will replace 1758 values to missing
	*** in other countries, when plot not measured with GPS coded with . - in Niger seems to be coded as 0

* **********************************************************************
* 2 - conversion to hectares
* **********************************************************************

	gen 			plot_size_hec_SR = . 

* plots measures in square meters 
* create conversion variable 
	gen 			sqmcon = 0.0001
	
* convert to SR hectares
	replace 		plot_size_hec_SR = plot_size_SR*sqmcon
	lab	var			plot_size_hec_SR "SR area of plot in hectares"

* count missing values
	count			if plot_size_SR == . 
	count 			if plot_size_hec_SR !=.
	count			if plot_size_hec_SR == . 
	*** 110 missing plot_size_SR
	*** 110 missing plot_size_hec_SR
	*** 6303 have plot_size_hec_SR
	
* convert gps report to hectares
	count 			if plot_size_GPS == . 
	*** 3262 have no gps value
	gen 			plot_size_2 = .
	replace 		plot_size_2 = plot_size_GPS*sqmcon
	rename 			plot_size_2 plot_size_hec_GPS
	lab	var			plot_size_hec_GPS "GPS measured area of plot in hectares"

	count 			if plot_size_hec_GPS !=.
	count			if plot_size_hec_GPS == . 
	*** 3151 have GPS
	*** 3262 do not have GPS
	
	count	 		if plot_size_hec_SR != . & plot_size_hec_GPS != .
	*** 3068 observations have both self reported and GPS plot size in hectares

	pwcorr 			plot_size_hec_SR plot_size_hec_GPS
	*** relatively low correlation = 0.2403 between selfreported plot size and GPS

* check correlation within +/- 3sd of mean (GPS)
	sum 			plot_size_hec_GPS, detail
	pwcorr 			plot_size_hec_SR plot_size_hec_GPS if ///
						inrange(plot_size_hec_GPS,`r(p50)'-(3*`r(sd)'),`r(p50)'+(3*`r(sd)'))
	*** correlation of points with +/- 3sd is higher 0.3600

* check correlation within +/- 3sd of mean (GPS and SR)
	sum 			plot_size_hec_GPS, detail
	sum 			plot_size_hec_SR, detail
	pwcorr 			plot_size_hec_SR plot_size_hec_GPS if ///
						inrange(plot_size_hec_GPS,`r(p50)'-(3*`r(sd)'),`r(p50)'+(3*`r(sd)')) & ///
						inrange(plot_size_hec_SR,`r(p50)'-(3*`r(sd)'),`r(p50)'+(3*`r(sd)'))
	*** correlation between self reported and GPS for values within +/- 3 sd's of GPS and SR is higher and good - 0.5505

* examine larger plot sizes
	tab				plot_size_hec_GPS 	if 	plot_size_hec_GPS > 2
	*** 944 GPS which are greater than 2
	tab				plot_size_hec_GPS 	if 	plot_size_hec_GPS > 20
	*** 29 GPS which are greater than 20
	*** 3 are in the 90's 

* correlation at higher plot sizes
	list 			plot_size_hec_GPS plot_size_hec_SR 	if ///
						plot_size_hec_GPS > 3 & !missing(plot_size_hec_GPS), sep(0)
	pwcorr 			plot_size_hec_GPS plot_size_hec_SR 	if 	///
						plot_size_hec_GPS > 3 & !missing(plot_size_hec_GPS)
	*** correlation at higher plot sizes is low - 0.0725

* examine smaller plot sizes
	tab				plot_size_hec_GPS 	if 	plot_size_hec_GPS < 0.1
	*** 222  below 0.1
	tab				plot_size_hec_GPS 	if 	plot_size_hec_GPS < 0.05
	*** 126 below 0.5
	tab				plot_size_hec_GPS 	if 	plot_size_hec_GPS < 0.005
	*** 20 are below 0.005
	*** none are unrealistically small
	
*correlation at lower plot sizes
	list 			plot_size_hec_GPS plot_size_hec_SR 	if 	///
						plot_size_hec_GPS < 0.01, sep(0)
	pwcorr 			plot_size_hec_GPS plot_size_hec_SR 	if ///
						plot_size_hec_GPS < 0.01
	*** small relationship between GPS and SR plotsize, correlation = 0.1455
	
* compare GPS and SR
* examine GPS 
	sum 			plot_size_hec_GPS
	sum 			plot_size_hec_SR
	*** GPS tending to be larger than self-reported, mean gps 2.318 and sr 1.906
	*** per conversations with WBG will not include SR in imputation - only will include GPS 

	
* examine with histograms
	*histogram 		plot_size_hec_GPS 	if 	plot_size_hec_GPS < 0.3
	*histogram 		plot_size_hec_GPS 	if 	plot_size_hec_GPS < 0.2
	*histogram 		plot_size_hec_GPS 	if 	plot_size_hec_GPS < 0.1
	*** GPS seems okay at all sizes
	
* impute missing plot sizes using predictive mean matching
	mi set 			wide // declare the data to be wide.
	mi xtset		, clear // this is a precautinary step to clear any existing xtset
	mi register 	imputed plot_size_hec_GPS // identify plotsize_GPS as the variable being imputed
	sort			clusterid hh_num ord field parcel, stable // sort to ensure reproducability of results
	mi impute 		pmm plot_size_hec_GPS i.clusterid, add(1) rseed(245780) noisily dots ///
						force knn(5) bootstrap
	mi unset

* look at the data
	tab				mi_miss
	tabstat 		plot_size_hec_GPS plot_size_hec_SR plot_size_hec_GPS_1_, ///
						by(mi_miss) statistics(n mean min max) columns(statistics) ///
						longstub format(%9.3g)
	*** imputed values change VERY little - mean from 2.32 to 3.05
	*** good impute

* drop if anything else is still missing
	list			plot_size_hec_GPS plot_size_hec_SR 	if 	///
						missing(plot_size_hec_GPS_1_), sep(0)
	drop 			if missing(plot_size_hec_GPS_1_)
	*** 0 observations deleted
	
* **********************************************************************
* 3 - end matter, clean up to save
* **********************************************************************

	rename			plot_size_hec_GPS_1_ plotsize
	lab	var			plotsize	"plot size (ha)"

	keep 			clusterid hh_num ord field parcel plotsize

* create unique household-plot identifier
	isid				clusterid hh_num ord field parcel
	sort				clusterid hh_num ord field parcel
	egen				plot_id = group(clusterid hh_num ord field parcel)
	lab var				plot_id "unique field and parcel identifier"

	compress
	describe
	summarize

* save file
		customsave , idvar(plot_id) filename("2011_as1_p1") ///
			path("`export'") dofile(2011_as1_p1) user($user)

* close the log
	log	close

/* END */
	
	
	
	
	
	
	
	