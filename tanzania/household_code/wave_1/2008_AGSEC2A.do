* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.16

* does
	* cleans Tanzania household variables, wave 1 Ag sec2a
	* looks like a parcel roster, 2008 long rainy season

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
	global root = "G:/My Drive/weather_project/household_data/tanzania/wave_1/raw"
	global export = "G:/My Drive/weather_project/household_data/tanzania/wave_1/refined"
	global logout = "G:/My Drive/weather_project/household_data/tanzania/logs"

*Open log
	log using "$logout/wv1_AGSEC2A", append

	
**********************************************************************************
**	TZA 2008 (Wave 1) - Agriculture Section 2A 
**********************************************************************************

* load data
	use 		"$root/SEC_2A", clear

* generate unique ob id
	generate 	plot_id = hhid + " " + plotnum
	isid 		plot_id

* rename variables of interest (plotsizes)	
	rename 		s2aq4 plotsize_self_ac
	rename 		area plotsize_gps_ac

* convert from acres to hectares
	generate	plotsize_self = plotsize_self_ac * 0.404686
	label		var plotsize_self "Self-reported Area (Hectares)"
	generate	plotsize_gps = plotsize_gps_ac * 0.404686
	label		var plotsize_gps "GPS Measured Area (Hectares)"
	drop		plotsize_gps_ac plotsize_self_ac
	
* interrogating plotsize variables
	count 		if plotsize_gps != . & plotsize_self != .
	*** only 856 not mising, out of 5,128
	pwcorr 		plotsize_gps plotsize_self
	*** high correlation (0.8027)
 
* investigating the high and low end of gps measurments
	* high end
		tab			plotsize_gps
		histogram	plotsize_gps if plotsize_gps > 2
		sum			plotsize_gps, detail
		*** mean = 0.935
		*** 90% of obs < 2.18
		
		sort		plotsize_gps
		sum 		plotsize_gps if plotsize_gps>2
		*** 101 obs > 2
		
		list		plotsize_gps plotsize_self if plotsize_gps>2 & !missing(plotsize_gps), sep(0)
		pwcorr		plotsize_gps plotsize_self if plotsize_gps>2 & !missing(plotsize_gps)
		*** corr = 0.6891 (not terrible)
		
		sum 		plotsize_gps if plotsize_gps>3
		*** 54 obs > 2
		
		list		plotsize_gps plotsize_self if plotsize_gps>3 & !missing(plotsize_gps), sep(0)
		pwcorr		plotsize_gps plotsize_self if plotsize_gps>3 & !missing(plotsize_gps)
		*** corr = 0.6461 (still not terrible)
		*** the high end seems okay, maybe not dropping anything here...

	* low end
		tab			plotsize_gps
		histogram	plotsize_gps if plotsize_gps < 0.5
		sum			plotsize_gps, detail
		*** mean = 0.935
		*** 10% of obs < 0.084
		
		sum 		plotsize_gps if plotsize_gps<0.085
		*** 88 obs < 0.085
		
		list		plotsize_gps plotsize_self if plotsize_gps<0.085 & !missing(plotsize_gps), sep(0)
		pwcorr		plotsize_gps plotsize_self if plotsize_gps<0.085 & !missing(plotsize_gps)
		*** corr = -0.3194 (inverse correlation! interesting! but not completely useless)
		
		sum 		plotsize_gps if plotsize_gps<0.05
		*** 43 obs < 0.05
		
		list		plotsize_gps plotsize_self if plotsize_gps<0.05 & !missing(plotsize_gps), sep(0)
		pwcorr		plotsize_gps plotsize_self if plotsize_gps<0.05 & !missing(plotsize_gps)
		*** corr = -0.5301 (even higher inverse correlation)
		*** inverse correlation seems like it could be useful in imputing values
	 
	* will drop the lone '0' value, to be imputed later
		replace 	plotsize_gps = . if plotsize_gps == 0
	
* must merge in regional identifiers from 2008_HHSECA to impute
	merge		m:1 hhid using "$export/HH_SECA"
	tab			_merge
	*** all obs in master are matched
	
	drop		if _merge == 2
	drop		_merge
	
* interrogating regional identifiers
	sort 		region
	by region: 	distinct district
	*** 126 distinct districts
	
* unique district id
	tostring	region, generate(reg_num) 
	tostring	district, generate(dist_num)
	generate	uq_dist = reg_num + dist_num
	distinct	uq_dist
	sort 		region district
	destring	uq_dist, replace
	*** 126 once again, good deal
	
	drop 		reg_num dist_num
	
* impute missing + irregular plot sizes using predictive mean matching
* including plotsize_self as control
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
	generate 	season = 0

* keep what we want, get rid of the rest
	keep 		hhid plot_id plotsize season

* prepare for export
	compress
	describe
	summarize 
	sort plot_id
	customsave , idvar(plot_id) filename(AG_SEC2A.dta) ///
		path("$export") dofile(2008_AGSEC2A) user($user)

* close the log
	log	close

/* END */