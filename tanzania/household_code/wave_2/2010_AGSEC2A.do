* Project: WB Weather
* Created on: April 2020
* Created by: McG
* Stata v.16

* does
	* cleans Tanzania household variables, wave 2 Ag sec2a
  * looks like a parcel roster, long rainy season

* assumes
	* customsave.ado
	* distinct.ado

* TO DO:
	* completed


* **********************************************************************
* 0 - setup
*
* set user
	*global	user		"jdmichler" // global managed by masterdo, turn on to run single file

* define paths
	loc 	root 		= 	"G:/My Drive/weather_project/household_data/tanzania/wave_2/raw"
	loc 	export 	= 	"G:/My Drive/weather_project/household_data/tanzania/wave_2/refined"
	loc 	logout 	= 	"G:/My Drive/weather_project/household_data/tanzania/logs"

* open log
	log 	using 			"`logout'/wv2_AGSEC2A", append


* **********************************************************************
* 1 - TZA 2010 (Wave 2) - Agriculture Section 2A
* **********************************************************************

* load data
	use 					"`root'/AG_SEC2A", clear

* rename variables of interest
	rename 				y2_hhid hhid
	rename 				ag2a_04 plotsize_self_ac
	rename 				ag2a_09 plotsize_gps_ac

* convert from acres to hectares
	gen						plotsize_self = plotsize_self_ac * 0.404686
	lab	var 			plotsize_self "Self-reported Area (Hectares)"
	gen						plotsize_gps = plotsize_gps_ac * 0.404686
	lab var 			plotsize_gps "GPS Measured Area (Hectares)"
	drop					plotsize_gps_ac plotsize_self_ac

* generate unique ob id
	gen			 			plot_id = hhid + " " + plotnum
	isid 					plot_id

* must merge in regional identifiers from 2008_HHSECA to impute
	merge					m:1 hhid using "`export'/HH_SECA"
	tab						_merge
 *** all obs in master are matched

	drop					if _merge == 2
	drop					_merge

* interrogating regional identifiers
	sort 					region
	by 						region: 	distinct district
 *** 129 distinct districts

* unique district id
	tostring			region, generate(reg_num)
	tostring			district, generate(dist_num)
	gen						uq_dist = reg_num + dist_num
	distinct			uq_dist
	sort 					region district
	destring			uq_dist, replace
 *** 129 once again, good deal

	drop 					reg_num dist_num

* interrogating plotsize variables
	count 				if plotsize_gps != . & plotsize_self != .
 *** 4,723 not mising, out of 6,038

	pwcorr 				plotsize_gps plotsize_self
 *** high correlation (0.7742)

* investigating the high and low end of gps measurments
	* high end
		tab					plotsize_gps
		hist				plotsize_gps if plotsize_gps > 2
		sum					plotsize_gps, detail
	 *** mean = 1.095
	 *** 90% of obs < 2.44

		sort				plotsize_gps
		sum 				plotsize_gps if plotsize_gps > 2.4
	 *** 483 obs > 2.4

		list				plotsize_gps plotsize_self if plotsize_gps > 2.4 ///
									& !missing(plotsize_gps), sep(0)
		pwcorr			plotsize_gps plotsize_self if plotsize_gps > 2.4 ///
									& !missing(plotsize_gps)
	 *** corr = 0.6864 (not terrible)

		sum 				plotsize_gps if plotsize_gps > 3.958
	 *** 236 obs > 3.958

		list				plotsize_gps plotsize_self if plotsize_gps > 3.95 ///
									& !missing(plotsize_gps), sep(0)
		pwcorr			plotsize_gps plotsize_self if plotsize_gps > 3.95 ///
									& !missing(plotsize_gps)
	 *** corr = 0.6637 (still not terrible)

	 	sum 				plotsize_gps if plotsize_gps > 20
	 *** 13 obs > 20

		list				plotsize_gps plotsize_self if plotsize_gps > 20 ///
									& !missing(plotsize_gps), sep(0)
		pwcorr			plotsize_gps plotsize_self if plotsize_gps > 20 ///
									& !missing(plotsize_gps)
	 	*** corr = 0.6791(still not terrible)
		*** the high end seems okay
	 	*** 13 obs plotsize_gps 20+, should these be dropped?
		*	replace 	plotsize_gps = . if plotsize_gps >= 20

	* low end
		tab					plotsize_gps
		hist				plotsize_gps if plotsize_gps < 0.5
		sum					plotsize_gps, detail
	 	*** mean = 1.095
	 	*** 10% of obs < 0.089

		sum 				plotsize_gps if plotsize_gps < 0.089
	 	*** 460 obs < 0.089

		list				plotsize_gps plotsize_self if plotsize_gps < 0.09 ///
									& !missing(plotsize_gps), sep(0)
		pwcorr			plotsize_gps plotsize_self if plotsize_gps < 0.09 ///
									& !missing(plotsize_gps)
	 	*** corr = 0.0394 (very very low correlation)

		sum 				plotsize_gps if plotsize_gps < 0.053
	 	*** 238 obs < 0.05

		list				plotsize_gps plotsize_self if plotsize_gps < 0.053 ///
									& !missing(plotsize_gps), sep(0)
		pwcorr			plotsize_gps plotsize_self if plotsize_gps < 0.053 ///
									& !missing(plotsize_gps)
	 	*** corr = -0.0078 (negative and still very very low)

		tab					plotsize_gps if plotsize_gps < 0.053
	 	*** 27 obs w/ plotsize_gps < 0.01 (including four zero values)

		list				plotsize_gps plotsize_self if plotsize_gps < 0.01 ///
									& !missing(plotsize_gps), sep(0)
		pwcorr			plotsize_gps plotsize_self if plotsize_gps < 0.01 ///
										& !missing(plotsize_gps)
	 	*** these all take values of 0, 0.0040469, or 0.0080937
		*** (meaning pre-conversion values of 0, 0.01, or 0.02)

	* will drop the '0' values, to be imputed later
		replace 		plotsize_gps = . if plotsize_gps == 0

* impute missing + irregular plot sizes using predictive mean matching
	mi set 				wide 	// declare the data to be wide.
	mi xtset			, clear 	// this is a precautinary step to clear any existing xtset
	mi register		imputed plotsize_gps // identify plotsize_GPS as the variable being imputed
	mi impute 		pmm plotsize_gps plotsize_self i.uq_dist, ///
									add(1) rseed(245780) noisily dots force knn(5) bootstrap
	mi 						unset

* how did the imputation go?
	tab						mi_miss
	pwcorr 				plotsize_gps plotsize_gps_1_ if plotsize_gps != .
	tabstat 			plotsize_gps plotsize_self plotsize_gps_1_, by(mi_miss) ///
									statistics(n mean min max) columns(statistics) ///
									longstub format(%9.3g)
	rename				plotsize_gps_1_ plotsize

* generate seasonal variable
	gen					 	season = 0

* keep what we want, get rid of the rest
	keep 					hhid plot_id plotsize season

*	Prepare for export
	compress
	describe
	summarize
	sort plot_id
	customsave , idvar(plot_id) filename(AG_SEC2A.dta) ///
		path("`export'") dofile(2010_AGSEC2A) user($user)

* close the log
	log	close

/* END */
