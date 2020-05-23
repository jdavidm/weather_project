* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.16

* does
	* cleans Tanzania household variables, wave 4 Ag sec2a
	* looks like a parcel roster, "all plots anyone in your household owned or 
	* cultivated during the long rainy season"
	
* assumes
	* customsave.ado
	* distinct.ado

* TO DO:
	* completed

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root = "$data/household_data/tanzania/wave_4/raw"
	loc export = "$data/household_data/tanzania/wave_4/refined"
	loc logout = "$data/household_data/tanzania/logs"

* open log
	log using "`logout'/wv4_AGSEC2A", append

	
* ***********************************************************************
* 1 - TZA 2014 (Wave 4) - Agriculture Section 2A 
* *********************1*************************************************

* load data
	use 		"`root'/ag_sec_2a", clear

* renaming variables of interest
	rename 		y4_hhid hhid
	rename 		ag2a_04 plotsize_self_ac
	rename 		ag2a_09 plotsize_gps_ac

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
	merge		m:1 hhid using "`export'/HH_SECA"
	tab			_merge
	*** all obs in master are matched (no 1s or 2s, kinda weird?)
	drop		if _merge == 2
	drop		_merge
	
* interrogating regional identifiers
	sort 		region
	by region: 	distinct district
	*** 162 distinct districts
	
* unique district id
	tostring	region, generate(reg_num) 
	tostring	district, generate(dist_num)
	generate	uq_dist = reg_num + dist_num
	distinct	uq_dist
	sort 		region district
	destring	uq_dist, replace
	*** 162 once again, good deal
	drop 		reg_num dist_num
	
* interrogating plotsize variables
	count 		if plotsize_gps != . & plotsize_self != .
	*** only 2,919 not missing, out of 5,537
	pwcorr 		plotsize_gps plotsize_self
	*** medium strong corr (0.6261)
	
* inverstingating the high and low end of gps measurments
	* high end
		tab			plotsize_gps
		histogram	plotsize_gps if plotsize_gps > 2
		sum			plotsize_gps, detail
		*** mean = 1.29
		*** 90% of obs < 2.7
		sort		plotsize_gps
		sum 		plotsize_gps if plotsize_gps>2.7
		*** 301 obs > 2.65
		list		plotsize_gps plotsize_self if plotsize_gps>2.7 & !missing(plotsize_gps), sep(0)
		pwcorr		plotsize_gps plotsize_self if plotsize_gps>2.7 & !missing(plotsize_gps)
		*** corr = 0.5109 (middling correlation)
		sum 		plotsize_gps if plotsize_gps>4.43
		*** 146 obs > 4.3
		list		plotsize_gps plotsize_self if plotsize_gps>4.43 & !missing(plotsize_gps), sep(0)
		pwcorr		plotsize_gps plotsize_self if plotsize_gps>4.43 & !missing(plotsize_gps)
		*** corr = 0.4643(still acceptable)
		count 		if plotsize_gps > 20 & plotsize_gps != .
		*** 18 obs >= 20
		list		plotsize_gps plotsize_self if plotsize_gps>20 & !missing(plotsize_gps), sep(0)
		pwcorr		plotsize_gps plotsize_self if plotsize_gps>20 & !missing(plotsize_gps)
		*** corr at 0.021 even w/ plotsize_gps > 20, should these be dropped?
*-->	replace 	plotsize_gps = . if plotsize_gps >= 20	
	* the high end seems okay, not dropping anything here yet
	///////////////////////////////////////////////////////////////////////////
	* low end
		tab			plotsize_gps
		histogram	plotsize_gps if plotsize_gps < 0.5
		sum			plotsize_gps, detail
		*** mean = 1.29
		*** 10% of obs < 0.061
		sum 		plotsize_gps if plotsize_gps<0.061
		*** 297 obs < 0.061
		list		plotsize_gps plotsize_self if plotsize_gps<0.061 & !missing(plotsize_gps), sep(0)
		pwcorr		plotsize_gps plotsize_self if plotsize_gps<0.061 & !missing(plotsize_gps)
		*** corr = 0.1270 (pretty poor)
		sum 		plotsize_gps if plotsize_gps<0.037
		*** 161 obs < 0.037
		list		plotsize_gps plotsize_self if plotsize_gps<0.037 & !missing(plotsize_gps), sep(0)
		pwcorr		plotsize_gps plotsize_self if plotsize_gps<0.037 & !missing(plotsize_gps)
		*** corr = 0.201(even more poor correlation)
	* dropping any '0' values, to be imputed later
		replace 	plotsize_gps = . if plotsize_gps == 0
		*** 20 changes made
		pwcorr		plotsize_gps plotsize_self if plotsize_gps<0.037 & !missing(plotsize_gps)
		*** this correlation at -0.0301 once zeros are dropped, still very low and now negative
		count		if plotsize_gps < 0.01 & plotsize_gps != .
		list		plotsize_gps plotsize_self if plotsize_gps<0.01 & !missing(plotsize_gps), sep(0)
		*** 24 obs < 0.01
		*** all values equal 0.0040469 or 0.0080937 (meaning pre-conversion values of 0.01, or 0.02)
	* I will not drop any low end values at this time

* impute missing + irregular plot sizes using predictive mean matching
* imputing 1,376 observations (out of 4,275) - 32.19% 
* including plotsize_self as control
	mi set 		wide 	// declare the data to be wide.
	mi xtset, clear 	// this is a precautinary step to clear any xtset that the analyst may have had in place previously
	mi register	imputed plotsize_gps // identify plotsize_GPS as the variable being imputed
	mi impute 	pmm plotsize_gps plotsize_self i.uq_dist, add(1) rseed(245780) noisily dots force knn(5) bootstrap
	mi 			unset
	
* how did the imputation go?
	tab			mi_miss
	pwcorr 		plotsize_gps plotsize_gps_1_ if plotsize_gps != .
	tabstat 	plotsize_gps plotsize_self plotsize_gps_1_, by(mi_miss) ///
				statistics(n mean min max) columns(statistics) longstub format(%9.3g) 
	rename		plotsize_gps_1_ plotsize
	
* keep what we want, get rid of the rest
	keep 		hhid plot_id plotsize

* prepare for export
compress
describe
summarize 
sort plot_id
customsave , idvar(plot_id) filename(AG_SEC2A.dta) path("`export'") dofile(2014_AGSEC2A) user($user)

* close the log
	log	close

/* END */