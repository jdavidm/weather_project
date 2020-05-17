* Project: WB Weather
* Created on: April 2020
* Created by: McG
* Stata v.15

* does
	* cleans Tanzania household variables, wave 2 Ag sec2b
    * looks like a parcel roster, short rainy season

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
	global root = "G:/My Drive/weather_project/household_data/tanzania/wave_2/raw"
	global export = "G:/My Drive/weather_project/household_data/tanzania/wave_2/refined"
	global logout = "C:/Users/$user/git/weather_project/tanzania/household_code/logs"

*Open log
	log using "$logout/wv2_AGSEC2B", append


**********************************************************************************
**	TZA 2010 (Wave 2) - Agriculture Section 2B 
**********************************************************************************

* load data
	use 		"$root/AG_SEC2B", clear

* rename variables of interest
	rename 		y2_hhid hhid
	rename 		ag2b_15 plotsize_self_ac
	rename 		ag2b_20 plotsize_gps_ac
	
* convert from acres to hectares
	generate	plotsize_self = plotsize_self_ac * 0.404686
	label		var plotsize_self "Self-reported Area (Hectares)"
	generate	plotsize_gps = plotsize_gps_ac * 0.404686
	label		var plotsize_gps "GPS Measured Area (Hectares)"
	drop		plotsize_gps_ac plotsize_self_ac

* generate unique ob id
	generate 	plot_id = hhid + " " + plotnum
	isid 		plot_id	
	
* must merge in regional identifiers from 2008_HHSECA to impute
	merge		m:1 hhid using "$export/HH_SECA"
	tab			_merge
 *** all obs in master are matched
	drop		if _merge == 2
	drop		_merge
* interrogating regional identifiers
	sort 		region
	by region: 	distinct district
 *** 21 distinct districts
* unique district id
	tostring	region, generate(reg_num) 
	tostring	district, generate(dist_num)
	generate	uq_dist = reg_num + dist_num
	distinct	uq_dist
	sort 		region district
	destring	uq_dist, replace
 *** 21 once again, good deal
	drop 		reg_num dist_num
	
* interrogating plotsize variables
	count 		if plotsize_gps != . & plotsize_self != .
 *** 16 not mising, out of 38
	pwcorr 		plotsize_gps plotsize_self
 *** decently high correlation (0.6565)
* inverstingating the high and low end of gps measurments
	* high end
		tab			plotsize_gps
		*histogram	plotsize_gps if plotsize_gps > 2
		sum			plotsize_gps, detail
	 *** mean = 1.8
	 *** 3 obs > 1.1
		sort		plotsize_gps
		sum 		plotsize_gps if plotsize_gps>1.1
		list		plotsize_gps plotsize_self if plotsize_gps>1.1 & !missing(plotsize_gps), sep(0)
		pwcorr		plotsize_gps plotsize_self if plotsize_gps>1.1 & !missing(plotsize_gps)
	 *** corr = 0.0.2385 (not great)
	 *** corr above is chiefly low due to the top 2 observations (when sorted by plotsize_gps)
	 *** should these be dropped? that would leave only 14 obs w/ plotsize_gps
*-->	replace 	plotsize_gps = . if plotsize_gps >= 7.7	
		list		plotsize_gps plotsize_self if plotsize_gps<7 & !missing(plotsize_gps), sep(0)
		pwcorr		plotsize_gps plotsize_self if plotsize_gps<7 & !missing(plotsize_gps)
	 *** corr = 0.6645 when those top two obs are omitted
	* the high end seems mostly okay, except for the last 2 obs
	///////////////////////////////////////////////////////////////////////////
	* low end
		tab			plotsize_gps
		*histogram	plotsize_gps if plotsize_gps < 0.5
		sum			plotsize_gps, detail
	 *** mean = 1.8
	 *** 3 obs < 0.22
		sum 		plotsize_gps if plotsize_gps<0.22
		list		plotsize_gps plotsize_self if plotsize_gps<0.22 & !missing(plotsize_gps), sep(0)
		pwcorr		plotsize_gps plotsize_self if plotsize_gps<0.22 & !missing(plotsize_gps)
	 *** corr = 0.9998 (whoa! no problem here I guess)
	 * for robustness, although no zero values in this set
		replace 	plotsize_gps = . if plotsize_gps == 0
		
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

*	Prepare for export
compress
describe
summarize 
sort plot_id
customsave , idvar(plot_id) filename(AG_SEC2B.dta) path("$export") dofile(2010_AGSEC2B) user($user)

* close the log
	log	close

/* END */