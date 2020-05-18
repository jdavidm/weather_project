* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.15

* does
	* cleans Tanzania household variables, wave 1 Ag sec2b
	* looks like a parcel roster, 2008 short rainy season

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
	log using "$logout/wv1_AGSEC2B", append


**********************************************************************************
**	TZA 2008 (Wave 1) - Agriculture Section 2B 
**********************************************************************************

* load data
	use 		"$root/SEC_2B", clear

* generate unique ob id	
	generate 	plot_id = hhid + " " + plotnum
	isid 		plot_id
	
* rename variables of interest (plotsizes)
	rename 		s2bq9 plotsize_self_ac
	rename 		area plotsize_gps_ac
	
* convert from acres to hectares
	generate	plotsize_self = plotsize_self_ac * 0.404686
	label		var plotsize_self "Self-reported Area (Hectares)"
	generate	plotsize_gps = plotsize_gps_ac * 0.404686
	label		var plotsize_gps "GPS Measured Area (Hectares)"
	drop		plotsize_gps_ac plotsize_self_ac
	
* interrogating plotsize variables
	count 		if plotsize_gps != . & plotsize_self != .
 *** 12 not mising, out of 86
	pwcorr 		plotsize_gps plotsize_self
 *** high correlation (0.7817)
* inverstingating the high and low end of gps measurments
	* high end
		tab			plotsize_gps
		sum			plotsize_gps, detail
		*histogram	plotsize_gps if plotsize_gps > .9
	 *** mean = 0.478
	 *** 90% of obs < .9
		sort		plotsize_gps
		sum 		plotsize_gps if plotsize_gps>0.9
	 *** 2 obs > 0.9
		list		plotsize_gps plotsize_self if plotsize_gps>0.9 & !missing(plotsize_gps), sep(0)
		pwcorr		plotsize_gps plotsize_self if plotsize_gps>0.9 & !missing(plotsize_gps)
	 *** corr = -1.0000 (kind of weird, is this because there are only 2 obs?)
	 	sum 		plotsize_gps if plotsize_gps>0.6
	 *** 3 obs > 0.6
		list		plotsize_gps plotsize_self if plotsize_gps>0.6 & !missing(plotsize_gps), sep(0)
		pwcorr		plotsize_gps plotsize_self if plotsize_gps>0.6 & !missing(plotsize_gps)
	 *** corr = -0.2722 (a real value!)
	 *** not going to drop anything here
	///////////////////////////////////////////////////////////////////////////
	* low end
		tab			plotsize_gps
		sum			plotsize_gps, detail
		*histogram	plotsize_gps if plotsize_gps < 0.11
	  *** mean = 0.478
	  *** 10% of obs < 0.11
		sum 		plotsize_gps if plotsize_gps<0.11
	  *** 2 obs < 0.11
		list		plotsize_gps plotsize_self if plotsize_gps<0.11 & !missing(plotsize_gps), sep(0)
		pwcorr		plotsize_gps plotsize_self if plotsize_gps<0.11 & !missing(plotsize_gps)
	  *** corr = 1.000(again, 2 obs)
		sum 		plotsize_gps if plotsize_gps<0.15
	  *** 3 < 0.15
		list		plotsize_gps plotsize_self if plotsize_gps<0.15 & !missing(plotsize_gps), sep(0)
		pwcorr		plotsize_gps plotsize_self if plotsize_gps<0.15 & !missing(plotsize_gps)
	  *** corr = 0.3633 (a real value!)
	  *** again, won't be dropping anything
	 * for robustness, although no zero values in this set
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
	generate 	season = 1

* keep what we want, get rid of the rest
	keep 		hhid plot_id plotsize season

*	Prepare for export
compress
describe
summarize 
sort plot_id
customsave , idvar(plot_id) filename(AG_SEC2B.dta) path("$export") dofile(2008_AGSEC2B) user($user)

* close the log
	log	close

/* END */