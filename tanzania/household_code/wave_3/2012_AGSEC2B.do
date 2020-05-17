* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.16

* does
	* cleans Tanzania household variables, wave 3 Ag sec2b
	* looks like a parcel roster, "all plots anyone in your household owned or 
	* cultivated during the short rainy season"
	
* assumes
	* customsave.ado

* TO DO:
	* completed

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* set user
	global user "themacfreezie"

* define paths
	global root = "G:/My Drive/weather_project/household_data/tanzania/wave_3/raw"
	global export = "G:/My Drive/weather_project/household_data/tanzania/wave_3/refined"
	global logout = "G:/My Drive/weather_project/household_data/tanzania/logs"

* open log
	log using "$logout/wv3_AGSEC2B", append

* ***********************************************************************
* 1 - TZA 2012 (Wave 3) - Agriculture Section 2B 
* *********************1*************************************************

* load data
	use 		"$root/AG_SEC_2B", clear

* renaming variables of interest
	rename 		y3_hhid hhid
	rename 		ag2b_15 plotsize_self_ac
	rename 		ag2b_20 plotsize_gps_ac

* generating unique observation id for each ob
	generate 	plot_id = hhid + " " + plotnum
	isid 		plot_id
	
* convert from acres to hectares
	generate	plotsize_self = plotsize_self_ac * 0.404686
	label		var plotsize_self "Self-reported Area (Hectares)"
	generate	plotsize_gps = plotsize_gps_ac * 0.404686
	label		var plotsize_gps "GPS Measured Area (Hectares)"
	drop		plotsize_gps_ac plotsize_self_ac
	
* must merge in regional identifiers from 2008_HHSECA to impute
	merge		m:1 hhid using "$export/HH_SECA"
	tab			_merge
 *** all obs in master are matched (no 1s or 2s, kinda weird?)
	drop		if _merge == 2
	drop		_merge
* interrogating regional identifiers
	sort 		region
	by region: 	distinct district
 *** 132 distinct districts
* unique district id
	tostring	region, generate(reg_num) 
	tostring	district, generate(dist_num)
	generate	uq_dist = reg_num + dist_num
	distinct	uq_dist
	sort 		region district
	destring	uq_dist, replace
 *** 132 once again, good deal
	drop 		reg_num dist_num
	
* interrogating plotsize variables
	count 		if plotsize_gps != . & plotsize_self != .
 *** only 9 not mising, out of 5,013!
* let's investigate this a little more
	tab 		plotsize_gps, missing
 *** 9 obs
	tab 		plotsize_self, missing
 *** 27 obs
	count 		if plotsize_self == . & plotsize_gps == .
 *** 4,986 missing both variables, these must be dropped
	drop 		if plotsize_self == . & plotsize_gps == .
	pwcorr 		plotsize_gps plotsize_self
 *** high correlation (0.8426)
* inverstingating the high and low end of gps measurments
	* high end
		tab			plotsize_gps
		*histogram	plotsize_gps if plotsize_gps > 2
		sum			plotsize_gps, detail
	 *** mean = 0.421
	 *** 3 obs > 0.61
		sort		plotsize_gps
		sum 		plotsize_gps if plotsize_gps>0.61
		list		plotsize_gps plotsize_self if plotsize_gps>0.61 & !missing(plotsize_gps), sep(0)
		pwcorr		plotsize_gps plotsize_self if plotsize_gps>0.61 & !missing(plotsize_gps)
	 *** corr = -0.8963(inverse, but very high)
	* the high end seems okay, not dropping anything here
	///////////////////////////////////////////////////////////////////////////
	* low end
		tab			plotsize_gps
		*histogram	plotsize_gps if plotsize_gps < 0.5
		sum			plotsize_gps, detail
	 *** mean = 0.421
	 *** 3 obs < 0.17
		sum 		plotsize_gps if plotsize_gps<0.17
		list		plotsize_gps plotsize_self if plotsize_gps<0.17 & !missing(plotsize_gps), sep(0)
		pwcorr		plotsize_gps plotsize_self if plotsize_gps<0.17 & !missing(plotsize_gps)
	 *** corr = 0.9997 (excellent)
	* dropping any '0' values, to be imputed later
		replace 	plotsize_gps = . if plotsize_gps == 0
	 *** 0 changes made
	* Not dropping any values on the low end

* impute missing + irregular plot sizes using predictive mean matching
	mi set 		wide 	// declare the data to be wide.
	mi xtset, clear 	// this is a precautinary step to clear any xtset that the analyst may have had in place previously
	mi register	imputed plotsize_gps // identify plotsize_GPS as the variable being imputed
	mi impute 	pmm plotsize_gps plotsize_self i.uq_dist, add(1) rseed(245780) noisily dots force knn(5) bootstrap
	mi 			unset
	
* how did the imputation go?
	tab			mi_miss
	pwcorr 		plotsize_gps plotsize_gps_1_ if plotsize_gps != .
	tabstat 	plotsize_gps plotsize_self plotsize_gps_1_, by(mi_miss) statistics(n mean min max) columns(statistics) longstub format(%9.3g) 
	rename		plotsize_gps_1_ plotsize

* generate seasonal variable
	generate 	season = 1
	
* keep what we want, get rid of the rest
	keep 		hhid plot_id plotsize season

* prepare for export
compress
describe
summarize 
sort plot_id
customsave , idvar(plot_id) filename(AG_SEC2B.dta) path("$export") dofile(2012_AGSEC2B) user($user)

* close the log
	log	close

/* END */
