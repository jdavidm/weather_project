* Project: WB Weather
* Created on: September 2019
* Created by: jdm
* Edited by: alj
* Last edit: 13 November 2020 
* Stata v.16.1 

* does
	* reads in results data set
	* makes visualziations of results 

* assumes
	* you have results file 
	* customsave.ado
	* grc1leg2.ado
	* tabout.ado

* TO DO:
	* complete

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	global	root 	= 	"$data/results_data"
	global	stab 	= 	"$data/results_data/tables"
	global	xtab 	= 	"$data/output/paper/tables"
	global	sfig	= 	"$data/results_data/figures"	
	global 	xfig    =   "$data/output/paper/figures"
	global	logout 	= 	"$data/results_data/logs"

* open log	
	cap log close
	log 	using 	"$logout/resultsvis", append

* load data 
	use 			"$root/lsms_complete_results", clear


* **********************************************************************
* 1 - generate serrbar graphs by extraction
* **********************************************************************


* **********************************************************************
* 1a - generate serrbar graphs by rainfall variable and extraction
* **********************************************************************
/*
* mean daily rainfall
preserve
	keep			if varname == 1
	sort 			varname ext beta
	gen 			obs = _n	
	
	serrbar 		beta stdrd_err obs, lcolor(edkblue%10) ///
						mvopts(recast(scatter) mcolor(edkblue%5) ///
						mfcolor(edkblue%5) mlcolor(edkblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Mean Daily Rainfall") ///
						xline(432 864 1296 1728 2160 2592 3024 3456 3888) ///
						xmtick(216(432)4320) xlabel(0 "0" 216 "Ext 1" ///
						432 "432" 648 "Ext 2" 864 "864" 1080 "Ext 3" ///
						1296 "1,296" 1512 "Ext 4" 1728 "1,728" 1944 "Ext 5" ///
						2160 "2,160" 2376 "Ext 6" 2592 "2,592" 2808 "Ext 7" ///
						3024 "3,024" 3240 "Ext 8" 3456 "3,456" 3672 "Ext 9" ///
						3888 "3,888" 4104 "Ext 10" 4320 "4,320", alt) ///
						xtitle("") saving("$sfig/v01_ext", replace)
restore

* median daily rainfall
preserve
	keep			if varname == 2
	sort 			varname ext beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(emidblue%10) ///
						mvopts(recast(scatter) mcolor(emidblue%5) ///
						mfcolor(emidblue%5) mlcolor(emidblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Median Daily Rainfall") ///
						xline(432 864 1296 1728 2160 2592 3024 3456 3888) ///
						xmtick(216(432)4320) xlabel(0 "0" 216 "Ext 1" ///
						432 "432" 648 "Ext 2" 864 "864" 1080 "Ext 3" ///
						1296 "1,296" 1512 "Ext 4" 1728 "1,728" 1944 "Ext 5" ///
						2160 "2,160" 2376 "Ext 6" 2592 "2,592" 2808 "Ext 7" ///
						3024 "3,024" 3240 "Ext 8" 3456 "3,456" 3672 "Ext 9" ///
						3888 "3,888" 4104 "Ext 10" 4320 "4,320", alt) ///
						xtitle("") saving("$sfig/v02_ext", replace)
restore	

* variance of daily rainfall
preserve
	keep			if varname == 3
	sort 			varname ext beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(eltblue%10) ///
						mvopts(recast(scatter) mcolor(eltblue%5) ///
						mfcolor(eltblue%5) mlcolor(eltblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Variance of Daily Rainfall") ///
						xline(432 864 1296 1728 2160 2592 3024 3456 3888) ///
						xmtick(216(432)4320) xlabel(0 "0" 216 "Ext 1" ///
						432 "432" 648 "Ext 2" 864 "864" 1080 "Ext 3" ///
						1296 "1,296" 1512 "Ext 4" 1728 "1,728" 1944 "Ext 5" ///
						2160 "2,160" 2376 "Ext 6" 2592 "2,592" 2808 "Ext 7" ///
						3024 "3,024" 3240 "Ext 8" 3456 "3,456" 3672 "Ext 9" ///
						3888 "3,888" 4104 "Ext 10" 4320 "4,320", alt) ///
						xtitle("") saving("$sfig/v03_ext", replace)
restore
	
* skew of daily rainfall
preserve
	keep			if varname == 4
	sort 			varname ext beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(emerald%10) ///
						mvopts(recast(scatter) mcolor(emerald%5) ///
						mfcolor(emerald%5) mlcolor(emerald%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Skew of Daily Rainfall") ///
						xline(432 864 1296 1728 2160 2592 3024 3456 3888) ///
						xmtick(216(432)4320) xlabel(0 "0" 216 "Ext 1" ///
						432 "432" 648 "Ext 2" 864 "864" 1080 "Ext 3" ///
						1296 "1,296" 1512 "Ext 4" 1728 "1,728" 1944 "Ext 5" ///
						2160 "2,160" 2376 "Ext 6" 2592 "2,592" 2808 "Ext 7" ///
						3024 "3,024" 3240 "Ext 8" 3456 "3,456" 3672 "Ext 9" ///
						3888 "3,888" 4104 "Ext 10" 4320 "4,320", alt) ///
						xtitle("") saving("$sfig/v04_ext", replace)
restore

* total seasonal rainfall
preserve
	keep			if varname == 5
	sort 			varname ext beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(erose%10) ///
						mvopts(recast(scatter) mcolor(erose%5) ///
						mfcolor(erose%5) mlcolor(erose%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Total Seasonal Rainfall") ///
						xline(432 864 1296 1728 2160 2592 3024 3456 3888) ///
						xmtick(216(432)4320) xlabel(0 "0" 216 "Ext 1" ///
						432 "432" 648 "Ext 2" 864 "864" 1080 "Ext 3" ///
						1296 "1,296" 1512 "Ext 4" 1728 "1,728" 1944 "Ext 5" ///
						2160 "2,160" 2376 "Ext 6" 2592 "2,592" 2808 "Ext 7" ///
						3024 "3,024" 3240 "Ext 8" 3456 "3,456" 3672 "Ext 9" ///
						3888 "3,888" 4104 "Ext 10" 4320 "4,320", alt) ///
						xtitle("") saving("$sfig/v05_ext", replace)
restore

* deviation in total rainfall
preserve
	keep			if varname == 6
	sort 			varname ext beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(ebblue%10) ///
						mvopts(recast(scatter) mcolor(ebblue%5) ///
						mfcolor(ebblue%5) mlcolor(ebblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Deviation in Total Seasonal Rainfall") ///
						xline(432 864 1296 1728 2160 2592 3024 3456 3888) ///
						xmtick(216(432)4320) xlabel(0 "0" 216 "Ext 1" ///
						432 "432" 648 "Ext 2" 864 "864" 1080 "Ext 3" ///
						1296 "1,296" 1512 "Ext 4" 1728 "1,728" 1944 "Ext 5" ///
						2160 "2,160" 2376 "Ext 6" 2592 "2,592" 2808 "Ext 7" ///
						3024 "3,024" 3240 "Ext 8" 3456 "3,456" 3672 "Ext 9" ///
						3888 "3,888" 4104 "Ext 10" 4320 "4,320", alt) ///
						xtitle("") saving("$sfig/v06_ext", replace)
restore

* z-score of total rainfall
preserve
	keep			if varname == 7
	sort 			varname ext beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(eltgreen%10) ///
						mvopts(recast(scatter) mcolor(eltgreen%5) ///
						mfcolor(eltgreen%5) mlcolor(eltgreen%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("z-Score of Total Seasonal Rainfall") ///
						xline(432 864 1296 1728 2160 2592 3024 3456 3888) ///
						xmtick(216(432)4320) xlabel(0 "0" 216 "Ext 1" ///
						432 "432" 648 "Ext 2" 864 "864" 1080 "Ext 3" ///
						1296 "1,296" 1512 "Ext 4" 1728 "1,728" 1944 "Ext 5" ///
						2160 "2,160" 2376 "Ext 6" 2592 "2,592" 2808 "Ext 7" ///
						3024 "3,024" 3240 "Ext 8" 3456 "3,456" 3672 "Ext 9" ///
						3888 "3,888" 4104 "Ext 10" 4320 "4,320", alt) ///
						xtitle("") saving("$sfig/v07_ext", replace)
restore

* number of days with rain
preserve
	keep			if varname == 8
	sort 			varname ext beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(stone%10) ///
						mvopts(recast(scatter) mcolor(stone%5) ///
						mfcolor(stone%5) mlcolor(stone%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Number of Days with Rain") ///
						xline(432 864 1296 1728 2160 2592 3024 3456 3888) ///
						xmtick(216(432)4320) xlabel(0 "0" 216 "Ext 1" ///
						432 "432" 648 "Ext 2" 864 "864" 1080 "Ext 3" ///
						1296 "1,296" 1512 "Ext 4" 1728 "1,728" 1944 "Ext 5" ///
						2160 "2,160" 2376 "Ext 6" 2592 "2,592" 2808 "Ext 7" ///
						3024 "3,024" 3240 "Ext 8" 3456 "3,456" 3672 "Ext 9" ///
						3888 "3,888" 4104 "Ext 10" 4320 "4,320", alt) ///
						xtitle("") saving("$sfig/v08_ext", replace)
restore

* deviation in rainy days
preserve
	keep			if varname == 9
	sort 			varname ext beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(navy%10) ///
						mvopts(recast(scatter) mcolor(navy%5) ///
						mfcolor(navy%5) mlcolor(navy%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Deviation in Number of Days with Rain") ///
						xline(432 864 1296 1728 2160 2592 3024 3456 3888) ///
						xmtick(216(432)4320) xlabel(0 "0" 216 "Ext 1" ///
						432 "432" 648 "Ext 2" 864 "864" 1080 "Ext 3" ///
						1296 "1,296" 1512 "Ext 4" 1728 "1,728" 1944 "Ext 5" ///
						2160 "2,160" 2376 "Ext 6" 2592 "2,592" 2808 "Ext 7" ///
						3024 "3,024" 3240 "Ext 8" 3456 "3,456" 3672 "Ext 9" ///
						3888 "3,888" 4104 "Ext 10" 4320 "4,320", alt) ///
						xtitle("") saving("$sfig/v09_ext", replace)
restore

* number of days without rain
preserve
	keep			if varname == 10
	sort 			varname ext beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(brown%10) ///
						mvopts(recast(scatter) mcolor(brown%5) ///
						mfcolor(brown%5) mlcolor(brown%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Number of Days without Rain") ///
						xline(432 864 1296 1728 2160 2592 3024 3456 3888) ///
						xmtick(216(432)4320) xlabel(0 "0" 216 "Ext 1" ///
						432 "432" 648 "Ext 2" 864 "864" 1080 "Ext 3" ///
						1296 "1,296" 1512 "Ext 4" 1728 "1,728" 1944 "Ext 5" ///
						2160 "2,160" 2376 "Ext 6" 2592 "2,592" 2808 "Ext 7" ///
						3024 "3,024" 3240 "Ext 8" 3456 "3,456" 3672 "Ext 9" ///
						3888 "3,888" 4104 "Ext 10" 4320 "4,320", alt) ///
						xtitle("") saving("$sfig/v10_ext", replace)
restore

* deviation in no rain days
preserve
	keep			if varname == 11
	sort 			varname ext beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(lavender%10) ///
						mvopts(recast(scatter) mcolor(lavender%5) ///
						mfcolor(lavender%5) mlcolor(lavender%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Deviation in Number of Days without Rain") ///
						xline(432 864 1296 1728 2160 2592 3024 3456 3888) ///
						xmtick(216(432)4320) xlabel(0 "0" 216 "Ext 1" ///
						432 "432" 648 "Ext 2" 864 "864" 1080 "Ext 3" ///
						1296 "1,296" 1512 "Ext 4" 1728 "1,728" 1944 "Ext 5" ///
						2160 "2,160" 2376 "Ext 6" 2592 "2,592" 2808 "Ext 7" ///
						3024 "3,024" 3240 "Ext 8" 3456 "3,456" 3672 "Ext 9" ///
						3888 "3,888" 4104 "Ext 10" 4320 "4,320", alt) ///
						xtitle("") saving("$sfig/v11_ext", replace)
restore

* Percentage of days with rain
preserve
	keep			if varname == 12
	sort 			varname ext beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(teal%10) ///
						mvopts(recast(scatter) mcolor(teal%5) ///
						mfcolor(teal%5) mlcolor(teal%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Percentage of Days with Rain") ///
						xline(432 864 1296 1728 2160 2592 3024 3456 3888) ///
						xmtick(216(432)4320) xlabel(0 "0" 216 "Ext 1" ///
						432 "432" 648 "Ext 2" 864 "864" 1080 "Ext 3" ///
						1296 "1,296" 1512 "Ext 4" 1728 "1,728" 1944 "Ext 5" ///
						2160 "2,160" 2376 "Ext 6" 2592 "2,592" 2808 "Ext 7" ///
						3024 "3,024" 3240 "Ext 8" 3456 "3,456" 3672 "Ext 9" ///
						3888 "3,888" 4104 "Ext 10" 4320 "4,320", alt) ///
						xtitle("") saving("$sfig/v12_ext", replace)
restore

* deviation in % rainy days
preserve
	keep			if varname == 13
	sort 			varname ext beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(cranberry%10) ///
						mvopts(recast(scatter) mcolor(cranberry%5) ///
						mfcolor(cranberry%5) mlcolor(cranberry%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Deviation in Percentage of Days with Rain") ///
						xline(432 864 1296 1728 2160 2592 3024 3456 3888) ///
						xmtick(216(432)4320) xlabel(0 "0" 216 "Ext 1" ///
						432 "432" 648 "Ext 2" 864 "864" 1080 "Ext 3" ///
						1296 "1,296" 1512 "Ext 4" 1728 "1,728" 1944 "Ext 5" ///
						2160 "2,160" 2376 "Ext 6" 2592 "2,592" 2808 "Ext 7" ///
						3024 "3,024" 3240 "Ext 8" 3456 "3,456" 3672 "Ext 9" ///
						3888 "3,888" 4104 "Ext 10" 4320 "4,320", alt) ///
						xtitle("") saving("$sfig/v13_ext", replace)
restore

* longest dry spell
preserve
	keep			if varname == 14
	sort 			varname ext beta
	gen 			obs = _n
	
	serrbar 		beta stdrd_err obs, lcolor(khaki%10) ///
						mvopts(recast(scatter) mcolor(khaki%5) ///
						mfcolor(khaki%5) mlcolor(khaki%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Longest Dry Spell") ///
						xline(432 864 1296 1728 2160 2592 3024 3456 3888) ///
						xmtick(216(432)4320) xlabel(0 "0" 216 "Ext 1" ///
						432 "432" 648 "Ext 2" 864 "864" 1080 "Ext 3" ///
						1296 "1,296" 1512 "Ext 4" 1728 "1,728" 1944 "Ext 5" ///
						2160 "2,160" 2376 "Ext 6" 2592 "2,592" 2808 "Ext 7" ///
						3024 "3,024" 3240 "Ext 8" 3456 "3,456" 3672 "Ext 9" ///
						3888 "3,888" 4104 "Ext 10" 4320 "4,320", alt) ///
						xtitle("") saving("$sfig/v14_ext", replace)
restore

* combine moments graphs
	gr combine 		"$sfig/v01_ext.gph" "$sfig/v02_ext.gph" "$sfig/v03_ext.gph" ///
						"$sfig/v04_ext.gph", col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig\ext_moment_rf.png", width(1400) replace
	
* combine total graphs
	gr combine 		"$sfig/v05_ext.gph" "$sfig/v06_ext.gph" "$sfig/v07_ext.gph", ///
						col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig\ext_total_rf.png", width(1400) replace
	
* combine rainy days
	gr combine 		"$sfig/v08_ext.gph" "$sfig/v09_ext.gph" "$sfig/v12_ext.gph" ///
						"$sfig/v13_ext.gph", col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig\ext_rain_rf.png", width(1400) replace
	
* combine total graphs
	gr combine 		"$sfig/v10_ext.gph" "$sfig/v11_ext.gph" "$sfig/v14_ext.gph", ///
						col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig/ext_none_rf.png", width(1400) replace
	

* **********************************************************************
* 1b - generate serrbar graphs by temperature variable and extraction
* **********************************************************************

* mean daily temperature
preserve
	keep			if varname == 15
	sort 			varname ext beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(edkblue%10) ///
						mvopts(recast(scatter) mcolor(edkblue%5) ///
						mfcolor(edkblue%5) mlcolor(edkblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Mean Daily Temperature") ///
						xline(216 432 648 864 1080 1296 1512 1728 1944) ///
						xmtick(108(216)2160) xlabel(0 "0" 108 "Ext 1" ///
						216 "216" 324 "Ext 2" 432 "432" 540 "Ext 3" ///
						648 "648" 756 "Ext 4" 865 "864" 972 "Ext 5" ///
						1080 "1,080" 1188 "Ext 6" 1296 "1,296" 1404 "Ext 7" ///
						1512 "1,512" 1620 "Ext 8" 1728 "1,728" 1836 "Ext 9" ///
						1944 "1,944" 2052 "Ext 10" 2160 "2,160", alt) ///
						xtitle("") saving("$sfig/var15_ext", replace)
restore

* median daily temperature
preserve
	keep			if varname == 16
	sort 			varname ext beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(emidblue%10) ///
						mvopts(recast(scatter) mcolor(emidblue%5) ///
						mfcolor(emidblue%5) mlcolor(emidblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Median Daily Temperature") ///
						xline(216 432 648 864 1080 1296 1512 1728 1944) ///
						xmtick(108(216)2160) xlabel(0 "0" 108 "Ext 1" ///
						216 "216" 324 "Ext 2" 432 "432" 540 "Ext 3" ///
						648 "648" 756 "Ext 4" 865 "864" 972 "Ext 5" ///
						1080 "1,080" 1188 "Ext 6" 1296 "1,296" 1404 "Ext 7" ///
						1512 "1,512" 1620 "Ext 8" 1728 "1,728" 1836 "Ext 9" ///
						1944 "1,944" 2052 "Ext 10" 2160 "2,160", alt) ///
						xtitle("") saving("$sfig/var16_ext", replace)
restore

* variance of daily temperature
preserve
	keep			if varname == 17
	sort 			varname ext beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(eltblue%10) ///
						mvopts(recast(scatter) mcolor(eltblue%5) ///
						mfcolor(eltblue%5) mlcolor(eltblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Variance of Daily Temperature") ///
						xline(216 432 648 864 1080 1296 1512 1728 1944) ///
						xmtick(108(216)2160) xlabel(0 "0" 108 "Ext 1" ///
						216 "216" 324 "Ext 2" 432 "432" 540 "Ext 3" ///
						648 "648" 756 "Ext 4" 865 "864" 972 "Ext 5" ///
						1080 "1,080" 1188 "Ext 6" 1296 "1,296" 1404 "Ext 7" ///
						1512 "1,512" 1620 "Ext 8" 1728 "1,728" 1836 "Ext 9" ///
						1944 "1,944" 2052 "Ext 10" 2160 "2,160", alt) ///
						xtitle("") saving("$sfig/var17_ext", replace)
restore

* skew of daily temperature
preserve
	keep			if varname == 18
	sort 			varname ext beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(emerald%10) ///
						mvopts(recast(scatter) mcolor(emerald%5) ///
						mfcolor(emerald%5) mlcolor(emerald%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Skew of Daily Temperature") ///
						xline(216 432 648 864 1080 1296 1512 1728 1944) ///
						xmtick(108(216)2160) xlabel(0 "0" 108 "Ext 1" ///
						216 "216" 324 "Ext 2" 432 "432" 540 "Ext 3" ///
						648 "648" 756 "Ext 4" 865 "864" 972 "Ext 5" ///
						1080 "1,080" 1188 "Ext 6" 1296 "1,296" 1404 "Ext 7" ///
						1512 "1,512" 1620 "Ext 8" 1728 "1,728" 1836 "Ext 9" ///
						1944 "1,944" 2052 "Ext 10" 2160 "2,160", alt) ///
						xtitle("") saving("$sfig/var18_ext", replace)
restore

* growing degree days (gdd)
preserve
	keep			if varname == 19
	sort 			varname ext beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(erose%10) ///
						mvopts(recast(scatter) mcolor(erose%5) ///
						mfcolor(erose%5) mlcolor(erose%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Growing Degree Days (GDD)") ///
						xline(216 432 648 864 1080 1296 1512 1728 1944) ///
						xmtick(108(216)2160) xlabel(0 "0" 108 "Ext 1" ///
						216 "216" 324 "Ext 2" 432 "432" 540 "Ext 3" ///
						648 "648" 756 "Ext 4" 865 "864" 972 "Ext 5" ///
						1080 "1,080" 1188 "Ext 6" 1296 "1,296" 1404 "Ext 7" ///
						1512 "1,512" 1620 "Ext 8" 1728 "1,728" 1836 "Ext 9" ///
						1944 "1,944" 2052 "Ext 10" 2160 "2,160", alt) ///
						xtitle("") saving("$sfig/var19_ext", replace)
restore

* deviation in gdd
preserve
	keep			if varname == 20
	sort 			varname ext beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(ebblue%10) ///
						mvopts(recast(scatter) mcolor(ebblue%5) ///
						mfcolor(ebblue%5) mlcolor(ebblue%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Deviation in Growing Degree Days (GDD)") ///
						xline(216 432 648 864 1080 1296 1512 1728 1944) ///
						xmtick(108(216)2160) xlabel(0 "0" 108 "Ext 1" ///
						216 "216" 324 "Ext 2" 432 "432" 540 "Ext 3" ///
						648 "648" 756 "Ext 4" 865 "864" 972 "Ext 5" ///
						1080 "1,080" 1188 "Ext 6" 1296 "1,296" 1404 "Ext 7" ///
						1512 "1,512" 1620 "Ext 8" 1728 "1,728" 1836 "Ext 9" ///
						1944 "1,944" 2052 "Ext 10" 2160 "2,160", alt) ///
						xtitle("") saving("$sfig/var20_ext", replace)
restore

* z-score of gdd
preserve
	keep			if varname == 21
	sort 			varname ext beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(eltgreen%10) ///
						mvopts(recast(scatter) mcolor(eltgreen%5) ///
						mfcolor(eltgreen%5) mlcolor(eltgreen%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("z-Score of Growing Degree Days (GDD)") ///
						xline(216 432 648 864 1080 1296 1512 1728 1944) ///
						xmtick(108(216)2160) xlabel(0 "0" 108 "Ext 1" ///
						216 "216" 324 "Ext 2" 432 "432" 540 "Ext 3" ///
						648 "648" 756 "Ext 4" 865 "864" 972 "Ext 5" ///
						1080 "1,080" 1188 "Ext 6" 1296 "1,296" 1404 "Ext 7" ///
						1512 "1,512" 1620 "Ext 8" 1728 "1,728" 1836 "Ext 9" ///
						1944 "1,944" 2052 "Ext 10" 2160 "2,160", alt) ///
						xtitle("") saving("$sfig/var21_ext", replace)
restore

* max daily temperaturegdd
preserve
	keep			if varname == 22
	sort 			varname ext beta
	gen 			obs = _n	

	serrbar 		beta stdrd_err obs, lcolor(stone%10) ///
						mvopts(recast(scatter) mcolor(stone%5) ///
						mfcolor(stone%5) mlcolor(stone%5)) ///
						scale (1.96) yline(0, lcolor(maroon) lstyle(solid) ) ///
						ytitle("Coefficient") title("Maximum Daily Temperature") ///
						xline(216 432 648 864 1080 1296 1512 1728 1944) ///
						xmtick(108(216)2160) xlabel(0 "0" 108 "Ext 1" ///
						216 "216" 324 "Ext 2" 432 "432" 540 "Ext 3" ///
						648 "648" 756 "Ext 4" 865 "864" 972 "Ext 5" ///
						1080 "1,080" 1188 "Ext 6" 1296 "1,296" 1404 "Ext 7" ///
						1512 "1,512" 1620 "Ext 8" 1728 "1,728" 1836 "Ext 9" ///
						1944 "1,944" 2052 "Ext 10" 2160 "2,160", alt) ///
						xtitle("") saving("$sfig/var22_ext", replace)
restore

* combine moments graphs
	gr combine 		"$sfig/var15_ext.gph" "$sfig/var16_ext.gph" "$sfig/var17_ext.gph" ///
						"$sfig/var18_ext.gph", col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig\ext_moment_tp.png", width(1400) replace
	
* combine total graphs
	gr combine 		"$sfig/var19_ext.gph" "$sfig/var20_ext.gph" "$sfig/var21_ext.gph" ///
						"$sfig/var22_ext.gph", col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig/ext_total_tp.png", width(1400) replace
	
*/
* **********************************************************************
* 2 - generate random number to select extraction method
* **********************************************************************

* choose one extraction method at random
preserve
	clear			all
	set obs			1
	set seed		3317230
	gen double 		u = (10-1) * runiform() + 1
	gen 			i = round(u)
	sum		 		u i 
restore	
*** random number was 3, so we proceed with extraction method 3

* keep extraction 3	
	keep			if ext == 3
		
* **********************************************************************
* 3 - generate serrbar graphs by satellite
* **********************************************************************

*generate different betas based on signficance
	gen 			b_sig = beta
	replace 		b_sig = . if pval > .05
	lab var 		b_sig "p < 0.05"
	
	gen 			b_ns = beta
	replace 		b_ns= . if p <= .05
	lab var 		b_ns "n.s."
	
* generate significance dummy
	gen				sig = 1 if b_sig != .
	replace			sig = 0 if b_ns != .
	lab	def			yesno 0 "Not Significant" 1 "Significant"
	lab val			sig yesno
	lab var			sig "Weather variable is significant"
	
				
* define loop through levels of the data type variable	

levelsof 	country		, local(lc)
	levelsof 	varname		, local(lv)
foreach c of local lc {
	foreach v of local lv {
		sum sig if country == `c' & varname == `v'
		eststo sig`l'_`c', addscalars(avg`l'_`c' r(mean))
	}
}

			
table varname, contents(mean sig) format(%9.2f) by(country)
esttab  using "$xtab/var_sig.tex", replace

sum sig if country == 1 & varname == 1
eststo, addscalars(avg r(mean))
	

esttab est2, cells("mean") noobs

* **********************************************************************
* 3a - generate serrbar graphs by rainfall variable and satellite
* **********************************************************************

* mean daily rainfall
preserve
	keep			if varname == 1
	sort 			varname sat beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(edkblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50)  ///
						yline(0, lcolor(maroon) ) ///
						ytitle("Coefficient") title("Mean Daily Rainfall") ///
						xline(72 144 216 288 360 432) xmtick(36(72)396)  ///
						xlabel(0 "0" 36 "Rainfall 1" 72 "72" 108 "Rainfall 2" ///
						144 "144" 180 "Rainfall 3" 216 "216" 252 "Rainfall 4" ///
						288 "288" 324 "Rainfall 5" 360 "360" 396 "Rainfall 6" ///
						432 "432", alt) xtitle("") ), legend(pos(12) col(2) ///
						order(1 2))  saving("$sfig/v01_sat", replace)
restore

* median daily rainfall
preserve
	keep			if varname == 2
	sort 			varname sat beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emidblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emidblue%50)  ///
						yline(0, lcolor(maroon) ) ///
						ytitle("Coefficient") title("Median Daily Rainfall") ///
						xline(72 144 216 288 360 432) xmtick(36(72)396)  ///
						xlabel(0 "0" 36 "Rainfall 1" 72 "72" 108 "Rainfall 2" ///
						144 "144" 180 "Rainfall 3" 216 "216" 252 "Rainfall 4" ///
						288 "288" 324 "Rainfall 5" 360 "360" 396 "Rainfall 6" ///
						432 "432", alt) xtitle("") ), legend(pos(12) col(2) ///
						order(1 2))  saving("$sfig/v02_sat", replace)
restore	

* variance of daily rainfall
preserve
	keep			if varname == 3
	sort 			varname sat beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(eltblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(eltblue%50)  ///
						yline(0, lcolor(maroon) ) ///
						ytitle("Coefficient") title("Variance of Daily Rainfall") ///
						xline(72 144 216 288 360 432) xmtick(36(72)396)  ///
						xlabel(0 "0" 36 "Rainfall 1" 72 "72" 108 "Rainfall 2" ///
						144 "144" 180 "Rainfall 3" 216 "216" 252 "Rainfall 4" ///
						288 "288" 324 "Rainfall 5" 360 "360" 396 "Rainfall 6" ///
						432 "432", alt) xtitle("") ), legend(pos(12) col(2) ///
						order(1 2))  saving("$sfig/v03_sat", replace)
restore
	
* skew of daily rainfall
preserve
	keep			if varname == 4
	sort 			varname sat beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emerald%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emerald%50)  ///
						yline(0, lcolor(maroon) ) ///
						ytitle("Coefficient") title("Skew of Daily Rainfall") ///
						xline(72 144 216 288 360 432) xmtick(36(72)396)  ///
						xlabel(0 "0" 36 "Rainfall 1" 72 "72" 108 "Rainfall 2" ///
						144 "144" 180 "Rainfall 3" 216 "216" 252 "Rainfall 4" ///
						288 "288" 324 "Rainfall 5" 360 "360" 396 "Rainfall 6" ///
						432 "432", alt) xtitle("") ), legend(pos(12) col(2) ///
						order(1 2))  saving("$sfig/v04_sat", replace)
restore

* total seasonal rainfall
preserve
	keep			if varname == 5
	sort 			varname sat beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(erose%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(erose%50)  ///
						yline(0, lcolor(maroon) ) ///
						ytitle("Coefficient") title("Total Seasonal Rainfall") ///
						xline(72 144 216 288 360 432) xmtick(36(72)396)  ///
						xlabel(0 "0" 36 "Rainfall 1" 72 "72" 108 "Rainfall 2" ///
						144 "144" 180 "Rainfall 3" 216 "216" 252 "Rainfall 4" ///
						288 "288" 324 "Rainfall 5" 360 "360" 396 "Rainfall 6" ///
						432 "432", alt) xtitle("") ), legend(pos(12) col(2) ///
						order(1 2))  saving("$sfig/v05_sat", replace)
restore

* deviation in total rainfall
preserve
	keep			if varname == 6
	sort 			varname sat beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(ebblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(ebblue%50)  ///
						yline(0, lcolor(maroon) ) ///
						ytitle("Coefficient") title("Deviation in Total Seasonal Rainfall") ///
						xline(72 144 216 288 360 432) xmtick(36(72)396)  ///
						xlabel(0 "0" 36 "Rainfall 1" 72 "72" 108 "Rainfall 2" ///
						144 "144" 180 "Rainfall 3" 216 "216" 252 "Rainfall 4" ///
						288 "288" 324 "Rainfall 5" 360 "360" 396 "Rainfall 6" ///
						432 "432", alt) xtitle("") ), legend(pos(12) col(2) ///
						order(1 2))  saving("$sfig/v06_sat", replace)
restore

* z-score of total rainfall
preserve
	keep			if varname == 7
	sort 			varname sat beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(eltgreen%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(eltgreen%50)  ///
						yline(0, lcolor(maroon) ) ///
						ytitle("Coefficient") title("z-Score of Total Seasonal Rainfall") ///
						xline(72 144 216 288 360 432) xmtick(36(72)396)  ///
						xlabel(0 "0" 36 "Rainfall 1" 72 "72" 108 "Rainfall 2" ///
						144 "144" 180 "Rainfall 3" 216 "216" 252 "Rainfall 4" ///
						288 "288" 324 "Rainfall 5" 360 "360" 396 "Rainfall 6" ///
						432 "432", alt) xtitle("") ), legend(pos(12) col(2) ///
						order(1 2))  saving("$sfig/v07_sat", replace)
restore

* number of days with rain
preserve
	keep			if varname == 8
	sort 			varname sat beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(stone%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(stone%50)  ///
						yline(0, lcolor(maroon) ) ///
						ytitle("Coefficient") title("Number of Days with Rain") ///
						xline(72 144 216 288 360 432) xmtick(36(72)396)  ///
						xlabel(0 "0" 36 "Rainfall 1" 72 "72" 108 "Rainfall 2" ///
						144 "144" 180 "Rainfall 3" 216 "216" 252 "Rainfall 4" ///
						288 "288" 324 "Rainfall 5" 360 "360" 396 "Rainfall 6" ///
						432 "432", alt) xtitle("") ), legend(pos(12) col(2) ///
						order(1 2))  saving("$sfig/v08_sat", replace)
restore

* deviation in rainy days
preserve
	keep			if varname == 9
	sort 			varname sat beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(navy%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(navy%50)  ///
						yline(0, lcolor(maroon) ) ///
						ytitle("Coefficient") title("Deviation in Number of Days with Rain") ///
						xline(72 144 216 288 360 432) xmtick(36(72)396)  ///
						xlabel(0 "0" 36 "Rainfall 1" 72 "72" 108 "Rainfall 2" ///
						144 "144" 180 "Rainfall 3" 216 "216" 252 "Rainfall 4" ///
						288 "288" 324 "Rainfall 5" 360 "360" 396 "Rainfall 6" ///
						432 "432", alt) xtitle("") ), legend(pos(12) col(2) ///
						order(1 2))  saving("$sfig/v09_sat", replace)
restore

* number of days without rain
preserve
	keep			if varname == 10
	sort 			varname sat beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(brown%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(brown%50)  ///
						yline(0, lcolor(maroon) ) ///
						ytitle("Coefficient") title("Number of Days without Rain") ///
						xline(72 144 216 288 360 432) xmtick(36(72)396)  ///
						xlabel(0 "0" 36 "Rainfall 1" 72 "72" 108 "Rainfall 2" ///
						144 "144" 180 "Rainfall 3" 216 "216" 252 "Rainfall 4" ///
						288 "288" 324 "Rainfall 5" 360 "360" 396 "Rainfall 6" ///
						432 "432", alt) xtitle("") ), legend(pos(12) col(2) ///
						order(1 2))  saving("$sfig/v10_sat", replace)
restore

* deviation in no rain days
preserve
	keep			if varname == 11
	sort 			varname sat beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(lavender%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(lavender%50)  ///
						yline(0, lcolor(maroon) ) ///
						ytitle("Coefficient") title("Deviation in Number of Days without Rain") ///
						xline(72 144 216 288 360 432) xmtick(36(72)396)  ///
						xlabel(0 "0" 36 "Rainfall 1" 72 "72" 108 "Rainfall 2" ///
						144 "144" 180 "Rainfall 3" 216 "216" 252 "Rainfall 4" ///
						288 "288" 324 "Rainfall 5" 360 "360" 396 "Rainfall 6" ///
						432 "432", alt) xtitle("") ), legend(pos(12) col(2) ///
						order(1 2))  saving("$sfig/v11_sat", replace)
restore

* Percentage of days with rain
preserve
	keep			if varname == 12
	sort 			varname sat beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(teal%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(teal%50)  ///
						yline(0, lcolor(maroon) ) ///
						ytitle("Coefficient") title("Percentage of Days with Rain") ///
						xline(72 144 216 288 360 432) xmtick(36(72)396)  ///
						xlabel(0 "0" 36 "Rainfall 1" 72 "72" 108 "Rainfall 2" ///
						144 "144" 180 "Rainfall 3" 216 "216" 252 "Rainfall 4" ///
						288 "288" 324 "Rainfall 5" 360 "360" 396 "Rainfall 6" ///
						432 "432", alt) xtitle("") ), legend(pos(12) col(2) ///
						order(1 2))  saving("$sfig/v12_sat", replace)
restore

* deviation in % rainy days
preserve
	keep			if varname == 13
	sort 			varname sat beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(cranberry%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(cranberry%50)  ///
						yline(0, lcolor(maroon) ) ///
						ytitle("Coefficient") title("Deviation in Percentage of Days with Rain") ///
						xline(72 144 216 288 360 432) xmtick(36(72)396)  ///
						xlabel(0 "0" 36 "Rainfall 1" 72 "72" 108 "Rainfall 2" ///
						144 "144" 180 "Rainfall 3" 216 "216" 252 "Rainfall 4" ///
						288 "288" 324 "Rainfall 5" 360 "360" 396 "Rainfall 6" ///
						432 "432", alt) xtitle("") ), legend(pos(12) col(2) ///
						order(1 2))  saving("$sfig/v13_sat", replace)
restore

* longest dry spell
preserve
	keep			if varname == 14
	sort 			varname sat beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(khaki%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(khaki%50)  ///
						yline(0, lcolor(maroon) ) ///
						ytitle("Coefficient") title("Longest Dry Spell") ///
						xline(72 144 216 288 360 432) xmtick(36(72)396)  ///
						xlabel(0 "0" 36 "Rainfall 1" 72 "72" 108 "Rainfall 2" ///
						144 "144" 180 "Rainfall 3" 216 "216" 252 "Rainfall 4" ///
						288 "288" 324 "Rainfall 5" 360 "360" 396 "Rainfall 6" ///
						432 "432", alt) xtitle("") ), legend(pos(12) col(2) ///
						order(1 2))  saving("$sfig/v14_sat", replace)
restore

* combine moments graphs
	gr combine 		"$sfig/v01_sat.gph" "$sfig/v02_sat.gph" "$sfig/v03_sat.gph" ///
						"$sfig/v04_sat.gph", col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig\sat_moment_rf.png", width(1400) replace
	
* combine total graphs
	gr combine 		"$sfig/v05_sat.gph" "$sfig/v06_sat.gph" "$sfig/v07_sat.gph", ///
						col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig\sat_total_rf.png", width(1400) replace
	
* combine rainy days
	gr combine 		"$sfig/v08_sat.gph" "$sfig/v09_sat.gph" "$sfig/v12_sat.gph" ///
						"$sfig/v13_sat.gph", col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig\sat_rain_rf.png", width(1400) replace
	
* combine total graphs
	gr combine 		"$sfig/v10_sat.gph" "$sfig/v11_sat.gph" "$sfig/v14_sat.gph", ///
						col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig\sat_none_rf.png", width(1400) replace
	

* **********************************************************************
* 1b - generate serrbar graphs by temperature variable and satellite
* **********************************************************************

* mean daily temperature
preserve
	keep			if varname == 15
	sort 			varname sat beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(edkblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50)  ///
						yline(0, lcolor(maroon) ) ///
						ytitle("Coefficient") title("Mean Daily Temperature") ///
						xline(72 144 216) xmtick(36(72)216)  ///
						xlabel(0 "0" 36 "Temperature 1" 72 "72" 108 "Temperature 2" ///
						144 "144" 180 "Temperature 3" 216 "216", alt) ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2))  saving("$sfig/v15_sat", replace)
restore

* median daily temperature
preserve
	keep			if varname == 16
	sort 			varname sat beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emidblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emidblue%50)  ///
						yline(0, lcolor(maroon) ) ///
						ytitle("Coefficient") title("Median Daily Temperature") ///
						xline(72 144 216) xmtick(36(72)216)  ///
						xlabel(0 "0" 36 "Temperature 1" 72 "72" 108 "Temperature 2" ///
						144 "144" 180 "Temperature 3" 216 "216", alt) ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2))  saving("$sfig/v16_sat", replace)
restore

* variance of daily temperature
preserve
	keep			if varname == 17
	sort 			varname sat beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(eltblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(eltblue%50)  ///
						yline(0, lcolor(maroon) ) ///
						ytitle("Coefficient") title("Variance of Daily Temperature") ///
						xline(72 144 216) xmtick(36(72)216)  ///
						xlabel(0 "0" 36 "Temperature 1" 72 "72" 108 "Temperature 2" ///
						144 "144" 180 "Temperature 3" 216 "216", alt) ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2))  saving("$sfig/v17_sat", replace)
restore

* skew of daily temperature
preserve
	keep			if varname == 18
	sort 			varname sat beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emerald%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emerald%50)  ///
						yline(0, lcolor(maroon) ) ///
						ytitle("Coefficient") title("Skew of Daily Temperature") ///
						xline(72 144 216) xmtick(36(72)216)  ///
						xlabel(0 "0" 36 "Temperature 1" 72 "72" 108 "Temperature 2" ///
						144 "144" 180 "Temperature 3" 216 "216", alt) ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2))  saving("$sfig/v18_sat", replace)
restore

* growing degree days (gdd)
preserve
	keep			if varname == 19
	sort 			varname sat beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(erose%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(erose%50)  ///
						yline(0, lcolor(maroon) ) ///
						ytitle("Coefficient") title("Growing Degree Days (GDD)") ///
						xline(72 144 216) xmtick(36(72)216)  ///
						xlabel(0 "0" 36 "Temperature 1" 72 "72" 108 "Temperature 2" ///
						144 "144" 180 "Temperature 3" 216 "216", alt) ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2))  saving("$sfig/v19_sat", replace)
restore

* deviation in gdd
preserve
	keep			if varname == 20
	sort 			varname sat beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(ebblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(ebblue%50)  ///
						yline(0, lcolor(maroon) ) ///
						ytitle("Coefficient") title("Deviation in Growing Degree Days (GDD)") ///
						xline(72 144 216) xmtick(36(72)216)  ///
						xlabel(0 "0" 36 "Temperature 1" 72 "72" 108 "Temperature 2" ///
						144 "144" 180 "Temperature 3" 216 "216", alt) ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2))  saving("$sfig/v20_sat", replace)
restore

* z-score of gdd
preserve
	keep			if varname == 21
	sort 			varname sat beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(eltgreen%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(eltgreen%50)  ///
						yline(0, lcolor(maroon) ) ///
						ytitle("Coefficient") title("z-Score of Growing Degree Days (GDD)") ///
						xline(72 144 216) xmtick(36(72)216)  ///
						xlabel(0 "0" 36 "Temperature 1" 72 "72" 108 "Temperature 2" ///
						144 "144" 180 "Temperature 3" 216 "216", alt) ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2))  saving("$sfig/v21_sat", replace)
restore

* max daily temperaturegdd
preserve
	keep			if varname == 22
	sort 			varname sat beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(stone%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(stone%50)  ///
						yline(0, lcolor(maroon) ) ///
						ytitle("Coefficient") title("Maximum Daily Temperature") ///
						xline(72 144 216) xmtick(36(72)216)  ///
						xlabel(0 "0" 36 "Temperature 1" 72 "72" 108 "Temperature 2" ///
						144 "144" 180 "Temperature 3" 216 "216", alt) ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2))  saving("$sfig/v22_sat", replace)
restore

* combine moments graphs
	gr combine 		"$sfig/v15_sat.gph" "$sfig/v16_sat.gph" "$sfig/v17_sat.gph" ///
						"$sfig/v18_sat.gph", col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig\sat_moment_tp.png", width(1400) replace
	
* combine total graphs
	gr combine 		"$sfig/v19_sat.gph" "$sfig/v20_sat.gph" "$sfig/v21_sat.gph" ///
						"$sfig/v22_sat.gph", col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig\sat_total_tp.png", width(1400) replace
	
	
* **********************************************************************
* 3 - generate serrbar graphs by country
* **********************************************************************

	
* **********************************************************************
* 3a - generate serrbar graphs by rainfall variable and country
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
						4320 "4,320", alt) xtitle("") saving("$sfig/v01_cty", replace)
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
						4320 "4320", alt) xtitle("") saving("$sfig/v02_cty", replace)
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
						4320 "4320", alt) xtitle("") saving("$sfig/v03_cty", replace)
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
						4320 "4320", alt) xtitle("") saving("$sfig/v04_cty", replace)
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
						4320 "4320", alt) xtitle("") saving("$sfig/v05_cty", replace)
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
						4320 "4320", alt) xtitle("") saving("$sfig/v06_cty", replace)
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
						4320 "4320", alt) xtitle("") saving("$sfig/v07_cty", replace)
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
						4320 "4320", alt) xtitle("") saving("$sfig/v08_cty", replace)
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
						4320 "4320", alt) xtitle("") saving("$sfig/v09_cty", replace)
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
						4320 "4320", alt) xtitle("") saving("$sfig/v10_cty", replace)
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
						4320 "4320", alt) xtitle("") saving("$sfig/v11_cty", replace)
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
						4320 "4320", alt) xtitle("") saving("$sfig/v12_cty", replace)
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
						4320 "4320", alt) xtitle("") saving("$sfig/v13_cty", replace)
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
						4320 "4320", alt) xtitle("") saving("$sfig/v14_cty", replace)
restore

* combine moments graphs
	gr combine 		"$sfig/v01_cty.gph" "$sfig/v02_cty.gph" "$sfig/v03_cty.gph" ///
						"$sfig/v04_cty.gph", col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig\cty_moment_rf.png", width(1400) replace
	
* combine total graphs
	gr combine 		"$sfig/v05_cty.gph" "$sfig/v06_cty.gph" "$sfig/v07_cty.gph", ///
						col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig\cty_total_rf.png", width(1400) replace
	
* combine rainy days
	gr combine 		"$sfig/v08_cty.gph" "$sfig/v09_cty.gph" "$sfig/v12_cty.gph" ///
						"$sfig/v13_cty.gph", col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig\cty_rain_rf.png", width(1400) replace
	
* combine total graphs
	gr combine 		"$sfig/v10_cty.gph" "$sfig/v11_cty.gph" "$sfig/v14_cty.gph", ///
						col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig\cty_none_rf.png", width(1400) replace
	

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
						2160 "2160", alt) xtitle("") saving("$sfig/var15_cty", replace)
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
						2160 "2160", alt) xtitle("") saving("$sfig/var16_cty", replace)
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
						2160 "2160", alt) xtitle("") saving("$sfig/var17_cty", replace)
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
						2160 "2160", alt) xtitle("") saving("$sfig/var18_cty", replace)
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
						2160 "2160", alt) xtitle("") saving("$sfig/var19_cty", replace)
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
						2160 "2160", alt) xtitle("") saving("$sfig/var20_cty", replace)
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
						2160 "2160", alt) xtitle("") saving("$sfig/var21_cty", replace)
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
						2160 "2160", alt) xtitle("") saving("$sfig/var22_cty", replace)
restore

* combine moments graphs
	gr combine 		"$sfig/var15_cty.gph" "$sfig/var16_cty.gph" "$sfig/var17_cty.gph" ///
						"$sfig/var18_cty.gph", col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig\cty_moment_tp.png", width(1400) replace
	
* combine total graphs
	gr combine 		"$sfig/var19_cty.gph" "$sfig/var20_cty.gph" "$sfig/var21_cty.gph" ///
						"$sfig/var22_cty.gph", col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig\cty_total_tp.png", width(1400) replace
	

* **********************************************************************
* 4 - end matter
* **********************************************************************


* close the log
	log	close

/* END */		