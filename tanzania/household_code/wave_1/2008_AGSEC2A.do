* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.15

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
	global logout = "C:/Users/$user/git/weather_project/tanzania/household_code/logs"

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
 *** very high correlation (0.8027)
* inverstingating the high and low end of gps measurments
	tab			plotsize_gps
	histogram	plotsize_gps
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
	
* must merge in regional identifiers from 2008_HHSECA to impute
	merge		m:1 hhid using "$export/HH_SECA"
	tab			_merge
 *** all obs in master are matched
	drop		_merge
* interrogating regional identifiers
	sort region
	by region: 	distinct district
 *** 126 distinct districts
* unique district id
	tostring	region, generate(reg_num) 
	tostring	district, generate(dist_num)
	generate	uq_dist = reg_num + " " + dist_num
	distinct	uq_dist
 *** 126 once again, good deal
	drop reg_num dist_num
	
*generate seasonal variable
	generate 	season = 0

keep hhid plot_id plotsize_self plotsize_gps season

*	Prepare for export
compress
describe
summarize 
sort plot_id
customsave , idvar(plot_id) filename(AG_SEC2A.dta) path("$export") dofile(2008_AGSEC2A) user($user)

* close the log
	log	close

/* END */
