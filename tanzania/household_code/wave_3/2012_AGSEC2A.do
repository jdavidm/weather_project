* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.16

* does
	* cleans Tanzania household variables, wave 3 Ag sec2a
	* looks like a parcel roster, long rainy season
	* generates imputed plot sizes
	
* assumes
	* customsave.ado
	* distinct.ado

* TO DO:
	* completed

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root = "$data/household_data/tanzania/wave_3/raw"
	loc export = "$data/household_data/tanzania/wave_3/refined"
	loc logout = "$data/household_data/tanzania/logs"

* open log
	log using "`logout'/wv3_AGSEC2A", append

	
* ***********************************************************************
* 1 - TZA 2012 (Wave 3) - Agriculture Section 2A 
* *********************1*************************************************

* load data
	use 		"`root'/AG_SEC_2A", clear

* renaming variables of interest
	rename 		y3_hhid hhid
	rename 		ag2a_04 plotsize_self_ac
	rename 		ag2a_09 plotsize_gps_ac
	
* check for uniquie identifiers
	drop		if plotnum == ""
	isid		hhid plotnum
	*** 1,710 obs dropped

* generating unique ob id
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
	*** only 5,396 not mising, out of 9,157
	
	pwcorr 		plotsize_gps plotsize_self
	*** high correlation (0.8600)

* inverstingating the high and low end of gps measurments
	* high end
		tab			plotsize_gps
		histogram	plotsize_gps if plotsize_gps > 2
		sum			plotsize_gps, detail
		*** mean = 1.248
		*** 90% of obs < 2.658
		
		sort		plotsize_gps
		sum 		plotsize_gps if plotsize_gps>2.65
		*** 541 obs > 2.65
		
		list		plotsize_gps plotsize_self if plotsize_gps>2.65 & ///
						!missing(plotsize_gps), sep(0)
		pwcorr		plotsize_gps plotsize_self if plotsize_gps>2.65 & ///
						!missing(plotsize_gps)
		*** corr = 0.8087 (very good)
		
		sum 		plotsize_gps if plotsize_gps>4.3
		*** 270 obs > 4.3
		
		list		plotsize_gps plotsize_self if plotsize_gps>4.3 & ///
						!missing(plotsize_gps), sep(0)
		pwcorr		plotsize_gps plotsize_self if plotsize_gps>4.3 & ///
						!missing(plotsize_gps)
		*** corr = 0.7794(still real high)
		
		count 		if plotsize_gps > 20 & plotsize_gps != .
		*** 26 obs >= 20
		
		list		plotsize_gps plotsize_self if plotsize_gps>20 & ///
						!missing(plotsize_gps), sep(0)
		sum			plotsize_gps plotsize_self if plotsize_gps>20 & ///
						plotsize_gps != .
		*** 26 observations
		
		pwcorr		plotsize_gps plotsize_self if plotsize_gps>20 & ///
						!missing(plotsize_gps)
		*** corr still at 0.57 even w/ plotsize_gps > 20
		*** the high end seems very high, but the correlation still seems pretty good
		*** not dropping anything here
	
	* low end
		tab			plotsize_gps
		histogram	plotsize_gps if plotsize_gps < 0.5
		sum			plotsize_gps, detail
		*** mean = 1.248
		*** 10% of obs < 0.081
		
		sum 		plotsize_gps if plotsize_gps<0.081
		*** 544 obs < 0.081
		
		list		plotsize_gps plotsize_self if plotsize_gps<0.081 & ///
						!missing(plotsize_gps), sep(0)
		pwcorr		plotsize_gps plotsize_self if plotsize_gps<0.081 & ///
						!missing(plotsize_gps)
		*** corr = 0.0794 (pretty poor)
		
		sum 		plotsize_gps if plotsize_gps<0.049
		*** 290 obs < 0.049
		
		list		plotsize_gps plotsize_self if plotsize_gps<0.049 & ///
						!missing(plotsize_gps), sep(0)
		pwcorr		plotsize_gps plotsize_self if plotsize_gps<0.049 & ///
						!missing(plotsize_gps)
		*** corr = 0.0347 (even more poor correlation)
		
	* dropping any '0' values, to be imputed later
		replace 	plotsize_gps = . if plotsize_gps == 0
		*** 14 changes made
		
		pwcorr		plotsize_gps plotsize_self if plotsize_gps<0.049 & ///
						!missing(plotsize_gps)
		*** this correlation improves to 0.0844 once zeros are dropped, still very low
		
		count		if plotsize_gps < 0.01 & plotsize_gps != .
		*** 38 obs < 0.01
		*** again I see values of 0, 0.0040469, or 0.0080937 many times (meaning pre-conversion values of 0, 0.01, or 0.02)
		*** I will not drop any low end values at this time

* impute missing + irregular plot sizes using predictive mean matching
* imputing 2,065 observations (out of 7,447) - 27.73% 
* including plotsize_self as control
	mi set 		wide 	// declare the data to be wide.
	mi xtset, clear 	// this is a precautinary step to clear any xtset that the analyst may have had in place previously
	mi register	imputed plotsize_gps // identify plotsize_GPS as the variable being imputed
	sort		hhid plotnum, stable // sort to ensure reproducability of results
	mi impute 	pmm plotsize_gps plotsize_self i.uq_dist, add(1) rseed(245780) ///
					noisily dots force knn(5) bootstrap
	mi 			unset
	
* how did the imputation go?
	tab			mi_miss
	pwcorr 		plotsize_gps plotsize_gps_1_ if plotsize_gps != .
	tabstat 	plotsize_gps plotsize_self plotsize_gps_1_, by(mi_miss) ///
					statistics(n mean min max) columns(statistics) longstub ///
					format(%9.3g) 
	rename		plotsize_gps_1_ plotsize
	*** only 7,447 total obs for plotsize after imputation, why?
	
	sum			plotsize_self
	*** looks like there were only ever 7,447 obs for plotsize_self
	*** these also contain no plotnum, will be dropped
	
	drop		if plotsize == . & plotsize_self ==.
	
* keep what we want, get rid of the rest
	keep 		hhid plotnum plot_id plotsize region district ward village

* prepare for export
	isid		hhid plotnum
	compress
	describe
	summarize 
	sort plot_id
	customsave , idvar(plot_id) filename(AG_SEC2A.dta) path("`export'") ///
		dofile(2012_AGSEC2A) user($user)

* close the log
	log	close

/* END */