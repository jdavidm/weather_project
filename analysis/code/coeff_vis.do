* Project: WB Weather
* Created on: September 2019
* Created by: jdm
* Edited by: alj
* Last edit: 28 September 2020 
* Stata v.16.1 

* does
	* reads in results data set
	* makes visualziations of results 

* assumes
	* you have results file 
	* customsave.ado
	* grc1leg2.ado

* TO DO:
	* all of it

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	global	root 	= 	"$data/results_data"
	global	xtab 	= 	"$data/results_data/tables"
	global 	xfig    =   "$data/results_data/figures"
	global	logout 	= 	"$data/results_data/logs"

* open log	
	cap log close
	log 	using 		"$logout/resultsvis", append

* load data 
	use 			"$root/lsms_complete_results", clear

	
* **********************************************************************
* 1 - generate serrbar graphs by satellite
* **********************************************************************

	
* **********************************************************************
* 1a - generate serrbar graphs by rainfall variable and satellite
* **********************************************************************

* mean daily rainfall
preserve
	keep			if varname == 1
	sort 			varname sat beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(edkblue%10) ///
						mvopts(recast(scatter) mcolor(edkblue%5) ///
						mfcolor(edkblue%5) mlcolor(edkblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Mean Daily Rainfall") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Rainfall 1" 720 "720" 1080 "Rainfall 2" ///
						1440 "1,440" 1800 "Rainfall 3" 2160 "2,160" 2520 "Rainfall 4" ///
						2880 "2,880" 3240 "Rainfall 5" 3600 "3,600" 3960 "Rainfall 6" ///
						4320 "4,320", alt) xtitle("") saving("$xfig/v01_sat", replace)
restore

* median daily rainfall
preserve
	keep			if varname == 2
	sort 			varname sat beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(emidblue%10) ///
						mvopts(recast(scatter) mcolor(emidblue%5) ///
						mfcolor(emidblue%5) mlcolor(emidblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Median Daily Rainfall") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Rainfall 1" 720 "720" 1080 "Rainfall 2" ///
						1440 "1440" 1800 "Rainfall 3" 2160 "2160" 2520 "Rainfall 4" ///
						2880 "2880" 3240 "Rainfall 5" 3600 "3600" 3960 "Rainfall 6" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v02_sat", replace)
restore	

* variance of daily rainfall
preserve
	keep			if varname == 3
	sort 			varname sat beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(eltblue%10) ///
						mvopts(recast(scatter) mcolor(eltblue%5) ///
						mfcolor(eltblue%5) mlcolor(eltblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Variance of Daily Rainfall") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Rainfall 1" 720 "720" 1080 "Rainfall 2" ///
						1440 "1440" 1800 "Rainfall 3" 2160 "2160" 2520 "Rainfall 4" ///
						2880 "2880" 3240 "Rainfall 5" 3600 "3600" 3960 "Rainfall 6" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v03_sat", replace)
restore
	
* skew of daily rainfall
preserve
	keep			if varname == 4
	sort 			varname sat beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(emerald%10) ///
						mvopts(recast(scatter) mcolor(emerald%5) ///
						mfcolor(emerald%5) mlcolor(emerald%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Skew of Daily Rainfall") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Rainfall 1" 720 "720" 1080 "Rainfall 2" ///
						1440 "1440" 1800 "Rainfall 3" 2160 "2160" 2520 "Rainfall 4" ///
						2880 "2880" 3240 "Rainfall 5" 3600 "3600" 3960 "Rainfall 6" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v04_sat", replace)
restore

* total seasonal rainfall
preserve
	keep			if varname == 5
	sort 			varname sat beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(erose%10) ///
						mvopts(recast(scatter) mcolor(erose%5) ///
						mfcolor(erose%5) mlcolor(erose%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Total Seasonal Rainfall") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Rainfall 1" 720 "720" 1080 "Rainfall 2" ///
						1440 "1440" 1800 "Rainfall 3" 2160 "2160" 2520 "Rainfall 4" ///
						2880 "2880" 3240 "Rainfall 5" 3600 "3600" 3960 "Rainfall 6" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v05_sat", replace)
restore

* deviation in total rainfall
preserve
	keep			if varname == 6
	sort 			varname sat beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(ebblue%10) ///
						mvopts(recast(scatter) mcolor(ebblue%5) ///
						mfcolor(ebblue%5) mlcolor(ebblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Deviation in Total Seasonal Rainfall") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Rainfall 1" 720 "720" 1080 "Rainfall 2" ///
						1440 "1440" 1800 "Rainfall 3" 2160 "2160" 2520 "Rainfall 4" ///
						2880 "2880" 3240 "Rainfall 5" 3600 "3600" 3960 "Rainfall 6" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v06_sat", replace)
restore

* z-score of total rainfall
preserve
	keep			if varname == 7
	sort 			varname sat beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(eltgreen%10) ///
						mvopts(recast(scatter) mcolor(eltgreen%5) ///
						mfcolor(eltgreen%5) mlcolor(eltgreen%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("z-Score of Total Seasonal Rainfall") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Rainfall 1" 720 "720" 1080 "Rainfall 2" ///
						1440 "1440" 1800 "Rainfall 3" 2160 "2160" 2520 "Rainfall 4" ///
						2880 "2880" 3240 "Rainfall 5" 3600 "3600" 3960 "Rainfall 6" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v07_sat", replace)
restore

* number of days with rain
preserve
	keep			if varname == 8
	sort 			varname sat beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(stone%10) ///
						mvopts(recast(scatter) mcolor(stone%5) ///
						mfcolor(stone%5) mlcolor(stone%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Number of Days with Rain") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Rainfall 1" 720 "720" 1080 "Rainfall 2" ///
						1440 "1440" 1800 "Rainfall 3" 2160 "2160" 2520 "Rainfall 4" ///
						2880 "2880" 3240 "Rainfall 5" 3600 "3600" 3960 "Rainfall 6" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v08_sat", replace)
restore

* deviation in rainy days
preserve
	keep			if varname == 9
	sort 			varname sat beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(navy%10) ///
						mvopts(recast(scatter) mcolor(navy%5) ///
						mfcolor(navy%5) mlcolor(navy%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Deviation in Number of Days with Rain") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Rainfall 1" 720 "720" 1080 "Rainfall 2" ///
						1440 "1440" 1800 "Rainfall 3" 2160 "2160" 2520 "Rainfall 4" ///
						2880 "2880" 3240 "Rainfall 5" 3600 "3600" 3960 "Rainfall 6" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v09_sat", replace)
restore

* number of days without rain
preserve
	keep			if varname == 10
	sort 			varname sat beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(brown%10) ///
						mvopts(recast(scatter) mcolor(brown%5) ///
						mfcolor(brown%5) mlcolor(brown%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Number of Days without Rain") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Rainfall 1" 720 "720" 1080 "Rainfall 2" ///
						1440 "1440" 1800 "Rainfall 3" 2160 "2160" 2520 "Rainfall 4" ///
						2880 "2880" 3240 "Rainfall 5" 3600 "3600" 3960 "Rainfall 6" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v10_sat", replace)
restore

* deviation in no rain days
preserve
	keep			if varname == 11
	sort 			varname sat beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(lavender%10) ///
						mvopts(recast(scatter) mcolor(lavender%5) ///
						mfcolor(lavender%5) mlcolor(lavender%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Deviation in Number of Days without Rain") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Rainfall 1" 720 "720" 1080 "Rainfall 2" ///
						1440 "1440" 1800 "Rainfall 3" 2160 "2160" 2520 "Rainfall 4" ///
						2880 "2880" 3240 "Rainfall 5" 3600 "3600" 3960 "Rainfall 6" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v11_sat", replace)
restore

* Percentage of days with rain
preserve
	keep			if varname == 12
	sort 			varname sat beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(teal%10) ///
						mvopts(recast(scatter) mcolor(teal%5) ///
						mfcolor(teal%5) mlcolor(teal%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Percentage of Days with Rain") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Rainfall 1" 720 "720" 1080 "Rainfall 2" ///
						1440 "1440" 1800 "Rainfall 3" 2160 "2160" 2520 "Rainfall 4" ///
						2880 "2880" 3240 "Rainfall 5" 3600 "3600" 3960 "Rainfall 6" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v12_sat", replace)
restore

* deviation in % rainy days
preserve
	keep			if varname == 13
	sort 			varname sat beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(cranberry%10) ///
						mvopts(recast(scatter) mcolor(cranberry%5) ///
						mfcolor(cranberry%5) mlcolor(cranberry%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Deviation in Percentage of Days with Rain") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Rainfall 1" 720 "720" 1080 "Rainfall 2" ///
						1440 "1440" 1800 "Rainfall 3" 2160 "2160" 2520 "Rainfall 4" ///
						2880 "2880" 3240 "Rainfall 5" 3600 "3600" 3960 "Rainfall 6" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v13_sat", replace)
restore

* longest dry spell
preserve
	keep			if varname == 14
	sort 			varname sat beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(khaki%10) ///
						mvopts(recast(scatter) mcolor(khaki%5) ///
						mfcolor(khaki%5) mlcolor(khaki%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Longest Dry Spell") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Rainfall 1" 720 "720" 1080 "Rainfall 2" ///
						1440 "1440" 1800 "Rainfall 3" 2160 "2160" 2520 "Rainfall 4" ///
						2880 "2880" 3240 "Rainfall 5" 3600 "3600" 3960 "Rainfall 6" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v14_sat", replace)
restore

* combine moments graphs
	gr combine 		"$xfig/v01_sat.gph" "$xfig/v02_sat.gph" "$xfig/v03_sat.gph" ///
						"$xfig/v04_sat.gph", col(2) iscale(.5) commonscheme
						
	graph export "$xfig\sat_moment_rf.pdf", as(pdf) replace
	
* combine total graphs
	gr combine 		"$xfig/v05_sat.gph" "$xfig/v06_sat.gph" "$xfig/v07_sat.gph", ///
						col(2) iscale(.5) commonscheme
						
	graph export "$xfig\sat_total_rf.pdf", as(pdf) replace
	
* combine rainy days
	gr combine 		"$xfig/v08_sat.gph" "$xfig/v09_sat.gph" "$xfig/v12_sat.gph" ///
						"$xfig/v13_sat.gph", col(2) iscale(.5) commonscheme
						
	graph export "$xfig\sat_rain_rf.pdf", as(pdf) replace
	
* combine total graphs
	gr combine 		"$xfig/v10_sat.gph" "$xfig/v11_sat.gph" "$xfig/v14_sat.gph", ///
						col(2) iscale(.5) commonscheme
						
	graph export "$xfig\sat_none_rf.pdf", as(pdf) replace
	

* **********************************************************************
* 1b - generate serrbar graphs by temperature variable and satellite
* **********************************************************************

* mean daily temperature
preserve
	keep			if varname == 15
	sort 			varname sat beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(edkblue%10) ///
						mvopts(recast(scatter) mcolor(edkblue%5) ///
						mfcolor(edkblue%5) mlcolor(edkblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Mean Daily Temperature") ///
						xline(720 1440) xmtick(360(720)2160)  ///
						xlabel(0 "0" 360 "Temperature 1" 720 "720" 1080 "Temperature 2" ///
						1440 "1,440" 1800 "Temperature 3" 2160 "2,160", alt) ///
						xtitle("") saving("$xfig/v15_sat", replace)
restore

* median daily temperature
preserve
	keep			if varname == 16
	sort 			varname sat beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(emidblue%10) ///
						mvopts(recast(scatter) mcolor(emidblue%5) ///
						mfcolor(emidblue%5) mlcolor(emidblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Median Daily Temperature") ///
						xline(720 1440) xmtick(360(720)2160)  ///
						xlabel(0 "0" 360 "Temperature 1" 720 "720" 1080 "Temperature 2" ///
						1440 "1,440" 1800 "Temperature 3" 2160 "2,160", alt) ///
						xtitle("") saving("$xfig/v16_sat", replace)
restore

* variance of daily temperature
preserve
	keep			if varname == 17
	sort 			varname sat beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(eltblue%10) ///
						mvopts(recast(scatter) mcolor(eltblue%5) ///
						mfcolor(eltblue%5) mlcolor(eltblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Variance of Daily Temperature") ///
						xline(720 1440) xmtick(360(720)2160)  ///
						xlabel(0 "0" 360 "Temperature 1" 720 "720" 1080 "Temperature 2" ///
						1440 "1,440" 1800 "Temperature 3" 2160 "2,160", alt) ///
						xtitle("") saving("$xfig/v17_sat", replace)
restore

* skew of daily temperature
preserve
	keep			if varname == 18
	sort 			varname sat beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(emerald%10) ///
						mvopts(recast(scatter) mcolor(emerald%5) ///
						mfcolor(emerald%5) mlcolor(emerald%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Skew of Daily Temperature") ///
						xline(720 1440) xmtick(360(720)2160)  ///
						xlabel(0 "0" 360 "Temperature 1" 720 "720" 1080 "Temperature 2" ///
						1440 "1,440" 1800 "Temperature 3" 2160 "2,160", alt) ///
						xtitle("") saving("$xfig/v18_sat", replace)
restore

* growing degree days (gdd)
preserve
	keep			if varname == 19
	sort 			varname sat beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(erose%10) ///
						mvopts(recast(scatter) mcolor(erose%5) ///
						mfcolor(erose%5) mlcolor(erose%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Growing Degree Days (GDD)") ///
						xline(720 1440) xmtick(360(720)2160)  ///
						xlabel(0 "0" 360 "Temperature 1" 720 "720" 1080 "Temperature 2" ///
						1440 "1,440" 1800 "Temperature 3" 2160 "2,160", alt) ///
						xtitle("") saving("$xfig/v19_sat", replace)
restore

* deviation in gdd
preserve
	keep			if varname == 20
	sort 			varname sat beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(ebblue%10) ///
						mvopts(recast(scatter) mcolor(ebblue%5) ///
						mfcolor(ebblue%5) mlcolor(ebblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Deviation in Growing Degree Days (GDD)") ///
						xline(720 1440) xmtick(360(720)2160)  ///
						xlabel(0 "0" 360 "Temperature 1" 720 "720" 1080 "Temperature 2" ///
						1440 "1,440" 1800 "Temperature 3" 2160 "2,160", alt) ///
						xtitle("") saving("$xfig/v20_sat", replace)
restore

* z-score of gdd
preserve
	keep			if varname == 21
	sort 			varname sat beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(eltgreen%10) ///
						mvopts(recast(scatter) mcolor(eltgreen%5) ///
						mfcolor(eltgreen%5) mlcolor(eltgreen%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("z-Score of Growing Degree Days (GDD)") ///
						xline(720 1440) xmtick(360(720)2160)  ///
						xlabel(0 "0" 360 "Temperature 1" 720 "720" 1080 "Temperature 2" ///
						1440 "1,440" 1800 "Temperature 3" 2160 "2,160", alt) ///
						xtitle("") saving("$xfig/v21_sat", replace)
restore

* max daily temperaturegdd
preserve
	keep			if varname == 22
	sort 			varname sat beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(stone%10) ///
						mvopts(recast(scatter) mcolor(stone%5) ///
						mfcolor(stone%5) mlcolor(stone%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Maximum Daily Temperature") ///
						xline(720 1440) xmtick(360(720)2160)  ///
						xlabel(0 "0" 360 "Temperature 1" 720 "720" 1080 "Temperature 2" ///
						1440 "1,440" 1800 "Temperature 3" 2160 "2,160", alt) ///
						xtitle("") saving("$xfig/v22_sat", replace)
restore

* combine moments graphs
	gr combine 		"$xfig/v15_sat.gph" "$xfig/v16_sat.gph" "$xfig/v17_sat.gph" ///
						"$xfig/v18_sat.gph", col(2) iscale(.5) commonscheme
						
	graph export "$xfig\sat_moment_tp.pdf", as(pdf) replace
	
* combine total graphs
	gr combine 		"$xfig/v19_sat.gph" "$xfig/v20_sat.gph" "$xfig/v21_sat.gph" ///
						"$xfig/v22_sat.gph", col(2) iscale(.5) commonscheme
						
	graph export "$xfig\sat_total_tp.pdf", as(pdf) replace
	
	
* **********************************************************************
* 2 - generate serrbar graphs by country
* **********************************************************************

	
* **********************************************************************
* 2a - generate serrbar graphs by rainfall variable and country
* **********************************************************************

* mean daily rainfall
preserve
	keep			if varname == 1
	sort 			varname country beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(edkblue%10) ///
						mvopts(recast(scatter) mcolor(edkblue%5) ///
						mfcolor(edkblue%5) mlcolor(edkblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Mean Daily Rainfall") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1,440" 1800 "Niger" 2160 "2,160" 2520 "Nigeria" ///
						2880 "2,880" 3240 "Tanzania" 3600 "3,600" 3960 "Uganda" ///
						4320 "4,320", alt) xtitle("") saving("$xfig/v01_cty", replace)
restore

* median daily rainfall
preserve
	keep			if varname == 2
	sort 			varname country beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(emidblue%10) ///
						mvopts(recast(scatter) mcolor(emidblue%5) ///
						mfcolor(emidblue%5) mlcolor(emidblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Median Daily Rainfall") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1440" 1800 "Niger" 2160 "2160" 2520 "Nigeria" ///
						2880 "2880" 3240 "Tanzania" 3600 "3600" 3960 "Uganda" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v02_cty", replace)
restore	

* variance of daily rainfall
preserve
	keep			if varname == 3
	sort 			varname country beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(eltblue%10) ///
						mvopts(recast(scatter) mcolor(eltblue%5) ///
						mfcolor(eltblue%5) mlcolor(eltblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Variance of Daily Rainfall") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1440" 1800 "Niger" 2160 "2160" 2520 "Nigeria" ///
						2880 "2880" 3240 "Tanzania" 3600 "3600" 3960 "Uganda" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v03_cty", replace)
restore
	
* skew of daily rainfall
preserve
	keep			if varname == 4
	sort 			varname country beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(emerald%10) ///
						mvopts(recast(scatter) mcolor(emerald%5) ///
						mfcolor(emerald%5) mlcolor(emerald%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Skew of Daily Rainfall") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1440" 1800 "Niger" 2160 "2160" 2520 "Nigeria" ///
						2880 "2880" 3240 "Tanzania" 3600 "3600" 3960 "Uganda" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v04_cty", replace)
restore

* total seasonal rainfall
preserve
	keep			if varname == 5
	sort 			varname country beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(erose%10) ///
						mvopts(recast(scatter) mcolor(erose%5) ///
						mfcolor(erose%5) mlcolor(erose%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Total Seasonal Rainfall") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1440" 1800 "Niger" 2160 "2160" 2520 "Nigeria" ///
						2880 "2880" 3240 "Tanzania" 3600 "3600" 3960 "Uganda" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v05_cty", replace)
restore

* deviation in total rainfall
preserve
	keep			if varname == 6
	sort 			varname country beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(ebblue%10) ///
						mvopts(recast(scatter) mcolor(ebblue%5) ///
						mfcolor(ebblue%5) mlcolor(ebblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Deviation in Total Seasonal Rainfall") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1440" 1800 "Niger" 2160 "2160" 2520 "Nigeria" ///
						2880 "2880" 3240 "Tanzania" 3600 "3600" 3960 "Uganda" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v06_cty", replace)
restore

* z-score of total rainfall
preserve
	keep			if varname == 7
	sort 			varname country beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(eltgreen%10) ///
						mvopts(recast(scatter) mcolor(eltgreen%5) ///
						mfcolor(eltgreen%5) mlcolor(eltgreen%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("z-Score of Total Seasonal Rainfall") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1440" 1800 "Niger" 2160 "2160" 2520 "Nigeria" ///
						2880 "2880" 3240 "Tanzania" 3600 "3600" 3960 "Uganda" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v07_cty", replace)
restore

* number of days with rain
preserve
	keep			if varname == 8
	sort 			varname country beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(stone%10) ///
						mvopts(recast(scatter) mcolor(stone%5) ///
						mfcolor(stone%5) mlcolor(stone%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Number of Days with Rain") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1440" 1800 "Niger" 2160 "2160" 2520 "Nigeria" ///
						2880 "2880" 3240 "Tanzania" 3600 "3600" 3960 "Uganda" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v08_cty", replace)
restore

* deviation in rainy days
preserve
	keep			if varname == 9
	sort 			varname country beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(navy%10) ///
						mvopts(recast(scatter) mcolor(navy%5) ///
						mfcolor(navy%5) mlcolor(navy%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Deviation in Number of Days with Rain") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1440" 1800 "Niger" 2160 "2160" 2520 "Nigeria" ///
						2880 "2880" 3240 "Tanzania" 3600 "3600" 3960 "Uganda" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v09_cty", replace)
restore

* number of days without rain
preserve
	keep			if varname == 10
	sort 			varname country beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(brown%10) ///
						mvopts(recast(scatter) mcolor(brown%5) ///
						mfcolor(brown%5) mlcolor(brown%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Number of Days without Rain") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1440" 1800 "Niger" 2160 "2160" 2520 "Nigeria" ///
						2880 "2880" 3240 "Tanzania" 3600 "3600" 3960 "Uganda" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v10_cty", replace)
restore

* deviation in no rain days
preserve
	keep			if varname == 11
	sort 			varname country beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(lavender%10) ///
						mvopts(recast(scatter) mcolor(lavender%5) ///
						mfcolor(lavender%5) mlcolor(lavender%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Deviation in Number of Days without Rain") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1440" 1800 "Niger" 2160 "2160" 2520 "Nigeria" ///
						2880 "2880" 3240 "Tanzania" 3600 "3600" 3960 "Uganda" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v11_cty", replace)
restore

* Percentage of days with rain
preserve
	keep			if varname == 12
	sort 			varname country beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(teal%10) ///
						mvopts(recast(scatter) mcolor(teal%5) ///
						mfcolor(teal%5) mlcolor(teal%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Percentage of Days with Rain") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1440" 1800 "Niger" 2160 "2160" 2520 "Nigeria" ///
						2880 "2880" 3240 "Tanzania" 3600 "3600" 3960 "Uganda" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v12_cty", replace)
restore

* deviation in % rainy days
preserve
	keep			if varname == 13
	sort 			varname country beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(cranberry%10) ///
						mvopts(recast(scatter) mcolor(cranberry%5) ///
						mfcolor(cranberry%5) mlcolor(cranberry%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Deviation in Percentage of Days with Rain") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1440" 1800 "Niger" 2160 "2160" 2520 "Nigeria" ///
						2880 "2880" 3240 "Tanzania" 3600 "3600" 3960 "Uganda" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v13_cty", replace)
restore

* longest dry spell
preserve
	keep			if varname == 14
	sort 			varname country beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(khaki%10) ///
						mvopts(recast(scatter) mcolor(khaki%5) ///
						mfcolor(khaki%5) mlcolor(khaki%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Longest Dry Spell") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1440" 1800 "Niger" 2160 "2160" 2520 "Nigeria" ///
						2880 "2880" 3240 "Tanzania" 3600 "3600" 3960 "Uganda" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v14_cty", replace)
restore

* combine moments graphs
	gr combine 		"$xfig/v01_cty.gph" "$xfig/v02_cty.gph" "$xfig/v03_cty.gph" ///
						"$xfig/v04_cty.gph", col(2) iscale(.5) commonscheme
						
	graph export "$xfig\cty_moment_rf.pdf", as(pdf) replace
	
* combine total graphs
	gr combine 		"$xfig/v05_cty.gph" "$xfig/v06_cty.gph" "$xfig/v07_cty.gph", ///
						col(2) iscale(.5) commonscheme
						
	graph export "$xfig\cty_total_rf.pdf", as(pdf) replace
	
* combine rainy days
	gr combine 		"$xfig/v08_cty.gph" "$xfig/v09_cty.gph" "$xfig/v12_cty.gph" ///
						"$xfig/v13_cty.gph", col(2) iscale(.5) commonscheme
						
	graph export "$xfig\cty_rain_rf.pdf", as(pdf) replace
	
* combine total graphs
	gr combine 		"$xfig/v10_cty.gph" "$xfig/v11_cty.gph" "$xfig/v14_cty.gph", ///
						col(2) iscale(.5) commonscheme
						
	graph export "$xfig\cty_none_rf.pdf", as(pdf) replace
	

* **********************************************************************
* 2b - generate serrbar graphs by temperature variable and satellite
* **********************************************************************

* mean daily temperature
preserve
	keep			if varname == 15
	sort 			varname country beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(edkblue%10) ///
						mvopts(recast(scatter) mcolor(edkblue%5) ///
						mfcolor(edkblue%5) mlcolor(edkblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Mean Daily Temperature") ///
						xline(360 720 1080 1440 1800) xmtick(180(360)1980)  ///
						xlabel(0 "0" 180 "Ethiopia" 360 "360" 540 "Malawi" ///
						720 "720" 900 "Niger" 1080 "1080" 1260 "Nigeria" ///
						1440 "1440" 1620 "Tanzania" 1800 "1800" 1980 "Uganda" ///
						2160 "2160", alt) xtitle("") saving("$xfig/var15_cty", replace)
restore

* median daily temperature
preserve
	keep			if varname == 16
	sort 			varname country beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(emidblue%10) ///
						mvopts(recast(scatter) mcolor(emidblue%5) ///
						mfcolor(emidblue%5) mlcolor(emidblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Median Daily Temperature") ///
						xline(360 720 1080 1440 1800) xmtick(180(360)1980)  ///
						xlabel(0 "0" 180 "Ethiopia" 360 "360" 540 "Malawi" ///
						720 "720" 900 "Niger" 1080 "1080" 1260 "Nigeria" ///
						1440 "1440" 1620 "Tanzania" 1800 "1800" 1980 "Uganda" ///
						2160 "2160", alt) xtitle("") saving("$xfig/var16_cty", replace)
restore

* variance of daily temperature
preserve
	keep			if varname == 17
	sort 			varname country beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(eltblue%10) ///
						mvopts(recast(scatter) mcolor(eltblue%5) ///
						mfcolor(eltblue%5) mlcolor(eltblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Variance of Daily Temperature") ///
						xline(360 720 1080 1440 1800) xmtick(180(360)1980)  ///
						xlabel(0 "0" 180 "Ethiopia" 360 "360" 540 "Malawi" ///
						720 "720" 900 "Niger" 1080 "1080" 1260 "Nigeria" ///
						1440 "1440" 1620 "Tanzania" 1800 "1800" 1980 "Uganda" ///
						2160 "2160", alt) xtitle("") saving("$xfig/var17_cty", replace)
restore

* skew of daily temperature
preserve
	keep			if varname == 18
	sort 			varname country beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(emerald%10) ///
						mvopts(recast(scatter) mcolor(emerald%5) ///
						mfcolor(emerald%5) mlcolor(emerald%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Skew of Daily Temperature") ///
						xline(360 720 1080 1440 1800) xmtick(180(360)1980)  ///
						xlabel(0 "0" 180 "Ethiopia" 360 "360" 540 "Malawi" ///
						720 "720" 900 "Niger" 1080 "1080" 1260 "Nigeria" ///
						1440 "1440" 1620 "Tanzania" 1800 "1800" 1980 "Uganda" ///
						2160 "2160", alt) xtitle("") saving("$xfig/var18_cty", replace)
restore

* growing degree days (gdd)
preserve
	keep			if varname == 19
	sort 			varname country beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(erose%10) ///
						mvopts(recast(scatter) mcolor(erose%5) ///
						mfcolor(erose%5) mlcolor(erose%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Growing Degree Days (GDD)") ///
						xline(360 720 1080 1440 1800) xmtick(180(360)1980)  ///
						xlabel(0 "0" 180 "Ethiopia" 360 "360" 540 "Malawi" ///
						720 "720" 900 "Niger" 1080 "1080" 1260 "Nigeria" ///
						1440 "1440" 1620 "Tanzania" 1800 "1800" 1980 "Uganda" ///
						2160 "2160", alt) xtitle("") saving("$xfig/var19_cty", replace)
restore

* deviation in gdd
preserve
	keep			if varname == 20
	sort 			varname country beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(ebblue%10) ///
						mvopts(recast(scatter) mcolor(ebblue%5) ///
						mfcolor(ebblue%5) mlcolor(ebblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Deviation in Growing Degree Days (GDD)") ///
						xline(360 720 1080 1440 1800) xmtick(180(360)1980)  ///
						xlabel(0 "0" 180 "Ethiopia" 360 "360" 540 "Malawi" ///
						720 "720" 900 "Niger" 1080 "1080" 1260 "Nigeria" ///
						1440 "1440" 1620 "Tanzania" 1800 "1800" 1980 "Uganda" ///
						2160 "2160", alt) xtitle("") saving("$xfig/var20_cty", replace)
restore

* z-score of gdd
preserve
	keep			if varname == 21
	sort 			varname country beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(eltgreen%10) ///
						mvopts(recast(scatter) mcolor(eltgreen%5) ///
						mfcolor(eltgreen%5) mlcolor(eltgreen%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("z-Score of Growing Degree Days (GDD)") ///
						xline(360 720 1080 1440 1800) xmtick(180(360)1980)  ///
						xlabel(0 "0" 180 "Ethiopia" 360 "360" 540 "Malawi" ///
						720 "720" 900 "Niger" 1080 "1080" 1260 "Nigeria" ///
						1440 "1440" 1620 "Tanzania" 1800 "1800" 1980 "Uganda" ///
						2160 "2160", alt) xtitle("") saving("$xfig/var21_cty", replace)
restore

* max daily temperaturegdd
preserve
	keep			if varname == 22
	sort 			varname country beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(stone%10) ///
						mvopts(recast(scatter) mcolor(stone%5) ///
						mfcolor(stone%5) mlcolor(stone%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Maximum Daily Temperature") ///
						xline(360 720 1080 1440 1800) xmtick(180(360)1980)  ///
						xlabel(0 "0" 180 "Ethiopia" 360 "360" 540 "Malawi" ///
						720 "720" 900 "Niger" 1080 "1080" 1260 "Nigeria" ///
						1440 "1440" 1620 "Tanzania" 1800 "1800" 1980 "Uganda" ///
						2160 "2160", alt) xtitle("") saving("$xfig/var22_cty", replace)
restore

* combine moments graphs
	gr combine 		"$xfig/var15_cty.gph" "$xfig/var16_cty.gph" "$xfig/var17_cty.gph" ///
						"$xfig/var18_cty.gph", col(2) iscale(.5) commonscheme
						
	graph export "$xfig\cty_moment_tp.pdf", as(pdf) replace
	
* combine total graphs
	gr combine 		"$xfig/var19_cty.gph" "$xfig/var20_cty.gph" "$xfig/var21_cty.gph" ///
						"$xfig/var22_cty.gph", col(2) iscale(.5) commonscheme
						
	graph export "$xfig\cty_total_tp.pdf", as(pdf) replace
	
/*
* **********************************************************************
* 3 - generate serrbar graphs by extraction
* **********************************************************************

	
* **********************************************************************
* 3a - generate serrbar graphs by rainfall variable and extraction
* **********************************************************************

* mean daily rainfall
preserve
	keep			if varname == 1
	sort 			varname extraction beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(edkblue%10) ///
						mvopts(recast(scatter) mcolor(edkblue%5) ///
						mfcolor(edkblue%5) mlcolor(edkblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Mean Daily Rainfall") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1,440" 1800 "Niger" 2160 "2,160" 2520 "Nigeria" ///
						2880 "2,880" 3240 "Tanzania" 3600 "3,600" 3960 "Uganda" ///
						4320 "4,320", alt) xtitle("") saving("$xfig/v01_ext", replace)
restore

* median daily rainfall
preserve
	keep			if varname == 2
	sort 			varname extraction beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(emidblue%10) ///
						mvopts(recast(scatter) mcolor(emidblue%5) ///
						mfcolor(emidblue%5) mlcolor(emidblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Median Daily Rainfall") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1440" 1800 "Niger" 2160 "2160" 2520 "Nigeria" ///
						2880 "2880" 3240 "Tanzania" 3600 "3600" 3960 "Uganda" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v02_ext", replace)
restore	

* variance of daily rainfall
preserve
	keep			if varname == 3
	sort 			varname extraction beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(eltblue%10) ///
						mvopts(recast(scatter) mcolor(eltblue%5) ///
						mfcolor(eltblue%5) mlcolor(eltblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Variance of Daily Rainfall") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1440" 1800 "Niger" 2160 "2160" 2520 "Nigeria" ///
						2880 "2880" 3240 "Tanzania" 3600 "3600" 3960 "Uganda" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v03_ext", replace)
restore
	
* skew of daily rainfall
preserve
	keep			if varname == 4
	sort 			varname extraction beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(emerald%10) ///
						mvopts(recast(scatter) mcolor(emerald%5) ///
						mfcolor(emerald%5) mlcolor(emerald%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Skew of Daily Rainfall") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1440" 1800 "Niger" 2160 "2160" 2520 "Nigeria" ///
						2880 "2880" 3240 "Tanzania" 3600 "3600" 3960 "Uganda" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v04_ext", replace)
restore

* total seasonal rainfall
preserve
	keep			if varname == 5
	sort 			varname extraction beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(erose%10) ///
						mvopts(recast(scatter) mcolor(erose%5) ///
						mfcolor(erose%5) mlcolor(erose%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Total Seasonal Rainfall") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1440" 1800 "Niger" 2160 "2160" 2520 "Nigeria" ///
						2880 "2880" 3240 "Tanzania" 3600 "3600" 3960 "Uganda" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v05_ext", replace)
restore

* deviation in total rainfall
preserve
	keep			if varname == 6
	sort 			varname extraction beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(ebblue%10) ///
						mvopts(recast(scatter) mcolor(ebblue%5) ///
						mfcolor(ebblue%5) mlcolor(ebblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Deviation in Total Seasonal Rainfall") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1440" 1800 "Niger" 2160 "2160" 2520 "Nigeria" ///
						2880 "2880" 3240 "Tanzania" 3600 "3600" 3960 "Uganda" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v06_ext", replace)
restore

* z-score of total rainfall
preserve
	keep			if varname == 7
	sort 			varname extraction beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(eltgreen%10) ///
						mvopts(recast(scatter) mcolor(eltgreen%5) ///
						mfcolor(eltgreen%5) mlcolor(eltgreen%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("z-Score of Total Seasonal Rainfall") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1440" 1800 "Niger" 2160 "2160" 2520 "Nigeria" ///
						2880 "2880" 3240 "Tanzania" 3600 "3600" 3960 "Uganda" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v07_ext", replace)
restore

* number of days with rain
preserve
	keep			if varname == 8
	sort 			varname extraction beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(stone%10) ///
						mvopts(recast(scatter) mcolor(stone%5) ///
						mfcolor(stone%5) mlcolor(stone%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Number of Days with Rain") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1440" 1800 "Niger" 2160 "2160" 2520 "Nigeria" ///
						2880 "2880" 3240 "Tanzania" 3600 "3600" 3960 "Uganda" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v08_ext", replace)
restore

* deviation in rainy days
preserve
	keep			if varname == 9
	sort 			varname extraction beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(navy%10) ///
						mvopts(recast(scatter) mcolor(navy%5) ///
						mfcolor(navy%5) mlcolor(navy%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Deviation in Number of Days with Rain") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1440" 1800 "Niger" 2160 "2160" 2520 "Nigeria" ///
						2880 "2880" 3240 "Tanzania" 3600 "3600" 3960 "Uganda" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v09_ext", replace)
restore

* number of days without rain
preserve
	keep			if varname == 10
	sort 			varname extraction beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(brown%10) ///
						mvopts(recast(scatter) mcolor(brown%5) ///
						mfcolor(brown%5) mlcolor(brown%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Number of Days without Rain") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1440" 1800 "Niger" 2160 "2160" 2520 "Nigeria" ///
						2880 "2880" 3240 "Tanzania" 3600 "3600" 3960 "Uganda" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v10_ext", replace)
restore

* deviation in no rain days
preserve
	keep			if varname == 11
	sort 			varname extraction beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(lavender%10) ///
						mvopts(recast(scatter) mcolor(lavender%5) ///
						mfcolor(lavender%5) mlcolor(lavender%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Deviation in Number of Days without Rain") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1440" 1800 "Niger" 2160 "2160" 2520 "Nigeria" ///
						2880 "2880" 3240 "Tanzania" 3600 "3600" 3960 "Uganda" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v11_ext", replace)
restore

* Percentage of days with rain
preserve
	keep			if varname == 12
	sort 			varname extraction beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(teal%10) ///
						mvopts(recast(scatter) mcolor(teal%5) ///
						mfcolor(teal%5) mlcolor(teal%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Percentage of Days with Rain") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1440" 1800 "Niger" 2160 "2160" 2520 "Nigeria" ///
						2880 "2880" 3240 "Tanzania" 3600 "3600" 3960 "Uganda" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v12_ext", replace)
restore

* deviation in % rainy days
preserve
	keep			if varname == 13
	sort 			varname extraction beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(cranberry%10) ///
						mvopts(recast(scatter) mcolor(cranberry%5) ///
						mfcolor(cranberry%5) mlcolor(cranberry%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Deviation in Percentage of Days with Rain") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1440" 1800 "Niger" 2160 "2160" 2520 "Nigeria" ///
						2880 "2880" 3240 "Tanzania" 3600 "3600" 3960 "Uganda" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v13_ext", replace)
restore

* longest dry spell
preserve
	keep			if varname == 14
	sort 			varname extraction beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(khaki%10) ///
						mvopts(recast(scatter) mcolor(khaki%5) ///
						mfcolor(khaki%5) mlcolor(khaki%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Longest Dry Spell") ///
						xline(720 1440 2160 2880 3600 4320) xmtick(360(720)3960)  ///
						xlabel(0 "0" 360 "Ethiopia" 720 "720" 1080 "Malawi" ///
						1440 "1440" 1800 "Niger" 2160 "2160" 2520 "Nigeria" ///
						2880 "2880" 3240 "Tanzania" 3600 "3600" 3960 "Uganda" ///
						4320 "4320", alt) xtitle("") saving("$xfig/v14_ext", replace)
restore

* combine moments graphs
	gr combine 		"$xfig/v01_ext.gph" "$xfig/v02_ext.gph" "$xfig/v03_ext.gph" ///
						"$xfig/v04_ext.gph", col(2) iscale(.5) commonscheme
						
	graph export "$xfig\ext_moment_rf.pdf", as(pdf) replace
	
* combine total graphs
	gr combine 		"$xfig/v05_ext.gph" "$xfig/v06_ext.gph" "$xfig/v07_ext.gph", ///
						col(2) iscale(.5) commonscheme
						
	graph export "$xfig\ext_total_rf.pdf", as(pdf) replace
	
* combine rainy days
	gr combine 		"$xfig/v08_ext.gph" "$xfig/v09_ext.gph" "$xfig/v12_ext.gph" ///
						"$xfig/v13_ext.gph", col(2) iscale(.5) commonscheme
						
	graph export "$xfig\ext_rain_rf.pdf", as(pdf) replace
	
* combine total graphs
	gr combine 		"$xfig/v10_ext.gph" "$xfig/v11_ext.gph" "$xfig/v14_ext.gph", ///
						col(2) iscale(.5) commonscheme
						
	graph export "$xfig\ext_none_rf.pdf", as(pdf) replace
	

* **********************************************************************
* 3b - generate serrbar graphs by temperature variable and extraction
* **********************************************************************

* mean daily temperature
preserve
	keep			if varname == 15
	sort 			varname extraction beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(edkblue%10) ///
						mvopts(recast(scatter) mcolor(edkblue%5) ///
						mfcolor(edkblue%5) mlcolor(edkblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Mean Daily Temperature") ///
						xline(360 720 1080 1440 1800) xmtick(180(360)1980)  ///
						xlabel(0 "0" 180 "Ethiopia" 360 "360" 540 "Malawi" ///
						720 "720" 900 "Niger" 1080 "1080" 1260 "Nigeria" ///
						1440 "1440" 1620 "Tanzania" 1800 "1800" 1980 "Uganda" ///
						2160 "2160", alt) xtitle("") saving("$xfig/var15_ext", replace)
restore

* median daily temperature
preserve
	keep			if varname == 16
	sort 			varname extraction beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(emidblue%10) ///
						mvopts(recast(scatter) mcolor(emidblue%5) ///
						mfcolor(emidblue%5) mlcolor(emidblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Median Daily Temperature") ///
						xline(360 720 1080 1440 1800) xmtick(180(360)1980)  ///
						xlabel(0 "0" 180 "Ethiopia" 360 "360" 540 "Malawi" ///
						720 "720" 900 "Niger" 1080 "1080" 1260 "Nigeria" ///
						1440 "1440" 1620 "Tanzania" 1800 "1800" 1980 "Uganda" ///
						2160 "2160", alt) xtitle("") saving("$xfig/var16_ext", replace)
restore

* variance of daily temperature
preserve
	keep			if varname == 17
	sort 			varname extraction beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(eltblue%10) ///
						mvopts(recast(scatter) mcolor(eltblue%5) ///
						mfcolor(eltblue%5) mlcolor(eltblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Variance of Daily Temperature") ///
						xline(360 720 1080 1440 1800) xmtick(180(360)1980)  ///
						xlabel(0 "0" 180 "Ethiopia" 360 "360" 540 "Malawi" ///
						720 "720" 900 "Niger" 1080 "1080" 1260 "Nigeria" ///
						1440 "1440" 1620 "Tanzania" 1800 "1800" 1980 "Uganda" ///
						2160 "2160", alt) xtitle("") saving("$xfig/var17_ext", replace)
restore

* skew of daily temperature
preserve
	keep			if varname == 18
	sort 			varname extraction beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(emerald%10) ///
						mvopts(recast(scatter) mcolor(emerald%5) ///
						mfcolor(emerald%5) mlcolor(emerald%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Skew of Daily Temperature") ///
						xline(360 720 1080 1440 1800) xmtick(180(360)1980)  ///
						xlabel(0 "0" 180 "Ethiopia" 360 "360" 540 "Malawi" ///
						720 "720" 900 "Niger" 1080 "1080" 1260 "Nigeria" ///
						1440 "1440" 1620 "Tanzania" 1800 "1800" 1980 "Uganda" ///
						2160 "2160", alt) xtitle("") saving("$xfig/var18_ext", replace)
restore

* growing degree days (gdd)
preserve
	keep			if varname == 19
	sort 			varname extraction beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(erose%10) ///
						mvopts(recast(scatter) mcolor(erose%5) ///
						mfcolor(erose%5) mlcolor(erose%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Growing Degree Days (GDD)") ///
						xline(360 720 1080 1440 1800) xmtick(180(360)1980)  ///
						xlabel(0 "0" 180 "Ethiopia" 360 "360" 540 "Malawi" ///
						720 "720" 900 "Niger" 1080 "1080" 1260 "Nigeria" ///
						1440 "1440" 1620 "Tanzania" 1800 "1800" 1980 "Uganda" ///
						2160 "2160", alt) xtitle("") saving("$xfig/var19_ext", replace)
restore

* deviation in gdd
preserve
	keep			if varname == 20
	sort 			varname extraction beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(ebblue%10) ///
						mvopts(recast(scatter) mcolor(ebblue%5) ///
						mfcolor(ebblue%5) mlcolor(ebblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Deviation in Growing Degree Days (GDD)") ///
						xline(360 720 1080 1440 1800) xmtick(180(360)1980)  ///
						xlabel(0 "0" 180 "Ethiopia" 360 "360" 540 "Malawi" ///
						720 "720" 900 "Niger" 1080 "1080" 1260 "Nigeria" ///
						1440 "1440" 1620 "Tanzania" 1800 "1800" 1980 "Uganda" ///
						2160 "2160", alt) xtitle("") saving("$xfig/var20_ext", replace)
restore

* z-score of gdd
preserve
	keep			if varname == 21
	sort 			varname extraction beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(eltgreen%10) ///
						mvopts(recast(scatter) mcolor(eltgreen%5) ///
						mfcolor(eltgreen%5) mlcolor(eltgreen%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("z-Score of Growing Degree Days (GDD)") ///
						xline(360 720 1080 1440 1800) xmtick(180(360)1980)  ///
						xlabel(0 "0" 180 "Ethiopia" 360 "360" 540 "Malawi" ///
						720 "720" 900 "Niger" 1080 "1080" 1260 "Nigeria" ///
						1440 "1440" 1620 "Tanzania" 1800 "1800" 1980 "Uganda" ///
						2160 "2160", alt) xtitle("") saving("$xfig/var21_ext", replace)
restore

* max daily temperaturegdd
preserve
	keep			if varname == 22
	sort 			varname extraction beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(stone%10) ///
						mvopts(recast(scatter) mcolor(stone%5) ///
						mfcolor(stone%5) mlcolor(stone%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Maximum Daily Temperature") ///
						xline(360 720 1080 1440 1800) xmtick(180(360)1980)  ///
						xlabel(0 "0" 180 "Ethiopia" 360 "360" 540 "Malawi" ///
						720 "720" 900 "Niger" 1080 "1080" 1260 "Nigeria" ///
						1440 "1440" 1620 "Tanzania" 1800 "1800" 1980 "Uganda" ///
						2160 "2160", alt) xtitle("") saving("$xfig/var22_ext", replace)
restore

* combine moments graphs
	gr combine 		"$xfig/var15_ext.gph" "$xfig/var16_ext.gph" "$xfig/var17_ext.gph" ///
						"$xfig/var18_ext.gph", col(2) iscale(.5) commonscheme
						
	graph export "$xfig\ext_moment_tp.pdf", as(pdf) replace
	
* combine total graphs
	gr combine 		"$xfig/var19_ext.gph" "$xfig/var20_ext.gph" "$xfig/var21_ext.gph" ///
						"$xfig/var22_ext.gph", col(2) iscale(.5) commonscheme
						
	graph export "$xfig\ext_total_tp.pdf", as(pdf) replace
	
	
* **********************************************************************
* 4 - end matter
* **********************************************************************


* close the log
	log	close

/* END */		