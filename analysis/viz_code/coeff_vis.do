* Project: WB Weather - UGA
* Created on: September 2019
* Created by: jdm
* Edited by: jdm
* Last edit: 17 November 2023
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
/*
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
*/
* real HH bilinear extraction was 1 so we go with that
	keep			if ext == 1
	
* we also only want uga for this analysis
	keep			if country == 7
		
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

	
* **********************************************************************
* 3a - generate serrbar graphs by rainfall variable and satellite
* **********************************************************************
/*
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
						xlabel(0 "0" 36 "CHIRPS" 72 "72" 108 "CPC" ///
						144 "144" 180 "MERRA-2" 216 "216" 252 "ARC2" ///
						288 "288" 324 "ERA5" 360 "360" 396 "TAMSAT" ///
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
						xlabel(0 "0" 36 "CHIRPS" 72 "72" 108 "CPC" ///
						144 "144" 180 "MERRA-2" 216 "216" 252 "ARC2" ///
						288 "288" 324 "ERA5" 360 "360" 396 "TAMSAT" ///
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
						xlabel(0 "0" 36 "CHIRPS" 72 "72" 108 "CPC" ///
						144 "144" 180 "MERRA-2" 216 "216" 252 "ARC2" ///
						288 "288" 324 "ERA5" 360 "360" 396 "TAMSAT" ///
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
						xlabel(0 "0" 36 "CHIRPS" 72 "72" 108 "CPC" ///
						144 "144" 180 "MERRA-2" 216 "216" 252 "ARC2" ///
						288 "288" 324 "ERA5" 360 "360" 396 "TAMSAT" ///
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
						xlabel(0 "0" 36 "CHIRPS" 72 "72" 108 "CPC" ///
						144 "144" 180 "MERRA-2" 216 "216" 252 "ARC2" ///
						288 "288" 324 "ERA5" 360 "360" 396 "TAMSAT" ///
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
						xlabel(0 "0" 36 "CHIRPS" 72 "72" 108 "CPC" ///
						144 "144" 180 "MERRA-2" 216 "216" 252 "ARC2" ///
						288 "288" 324 "ERA5" 360 "360" 396 "TAMSAT" ///
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
						xlabel(0 "0" 36 "CHIRPS" 72 "72" 108 "CPC" ///
						144 "144" 180 "MERRA-2" 216 "216" 252 "ARC2" ///
						288 "288" 324 "ERA5" 360 "360" 396 "TAMSAT" ///
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
						xlabel(0 "0" 36 "CHIRPS" 72 "72" 108 "CPC" ///
						144 "144" 180 "MERRA-2" 216 "216" 252 "ARC2" ///
						288 "288" 324 "ERA5" 360 "360" 396 "TAMSAT" ///
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
						xlabel(0 "0" 36 "CHIRPS" 72 "72" 108 "CPC" ///
						144 "144" 180 "MERRA-2" 216 "216" 252 "ARC2" ///
						288 "288" 324 "ERA5" 360 "360" 396 "TAMSAT" ///
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
						xlabel(0 "0" 36 "CHIRPS" 72 "72" 108 "CPC" ///
						144 "144" 180 "MERRA-2" 216 "216" 252 "ARC2" ///
						288 "288" 324 "ERA5" 360 "360" 396 "TAMSAT" ///
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
						xlabel(0 "0" 36 "CHIRPS" 72 "72" 108 "CPC" ///
						144 "144" 180 "MERRA-2" 216 "216" 252 "ARC2" ///
						288 "288" 324 "ERA5" 360 "360" 396 "TAMSAT" ///
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
						xlabel(0 "0" 36 "CHIRPS" 72 "72" 108 "CPC" ///
						144 "144" 180 "MERRA-2" 216 "216" 252 "ARC2" ///
						288 "288" 324 "ERA5" 360 "360" 396 "TAMSAT" ///
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
						xlabel(0 "0" 36 "CHIRPS" 72 "72" 108 "CPC" ///
						144 "144" 180 "MERRA-2" 216 "216" 252 "ARC2" ///
						288 "288" 324 "ERA5" 360 "360" 396 "TAMSAT" ///
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
						xlabel(0 "0" 36 "CHIRPS" 72 "72" 108 "CPC" ///
						144 "144" 180 "MERRA-2" 216 "216" 252 "ARC2" ///
						288 "288" 324 "ERA5" 360 "360" 396 "TAMSAT" ///
						432 "432", alt) xtitle("") ), legend(pos(12) col(2) ///
						order(1 2))  saving("$sfig/v14_sat", replace)
restore

* combine moments graphs
	gr combine 		"$sfig/v01_sat.gph" "$sfig/v02_sat.gph" "$sfig/v03_sat.gph" ///
						"$sfig/v04_sat.gph", col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig\sat_moment_rf.pdf", as(pdf) replace
	
* combine total graphs
	gr combine 		"$sfig/v05_sat.gph" "$sfig/v06_sat.gph" "$sfig/v07_sat.gph", ///
						col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig\sat_total_rf.pdf", as(pdf) replace
	
* combine rainy days
	gr combine 		"$sfig/v08_sat.gph" "$sfig/v09_sat.gph" "$sfig/v12_sat.gph" ///
						"$sfig/v13_sat.gph", col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig\sat_rain_rf.pdf", as(pdf) replace
	
* combine total graphs
	gr combine 		"$sfig/v10_sat.gph" "$sfig/v11_sat.gph" "$sfig/v14_sat.gph", ///
						col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig\sat_none_rf.pdf", as(pdf) replace
	

* **********************************************************************
* 3b - generate serrbar graphs by temperature variable and satellite
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
						
	graph export 	"$xfig\sat_moment_tp.pdf", as(pdf) replace
	
* combine total graphs
	gr combine 		"$sfig/v19_sat.gph" "$sfig/v20_sat.gph" "$sfig/v21_sat.gph" ///
						"$sfig/v22_sat.gph", col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig\sat_total_tp.pdf", as(pdf) replace
	
* **********************************************************************
* 3c - generate table of significant values
* **********************************************************************

* redefine var lab for LaTeX
	lab def		varname 	1 "Mean Daily Rainfall" ///
							2 "Median Daily Rainfall" ///
							3 "Variance of Daily Rainfall" ///
							4 "Skew of Daily Rainfall" ///
							5 "Total Rainfall" ///
							6 "Deviation in Total Rainfall" ///
							7 "Z-Score of Total Rainfall" ///
							8 "Rainy Days" ///
							9 "Deviation in Rainy Days" ///
							10 "No Rain Days" ///
							11 "Deviation in No Rain Days" ///
							12 "\% Rainy Days" ///
							13 "Deviation in \% Rainy Days" ///
							14 "Longest Dry Spell" ///
							15 "Mean Daily Temperature" ///
							16 "Median Daily Temperature" ///
							17 "Variance of Daily Temperature" ///
							18 "Skew of Daily Temperature" ///
							19 "Growing Degree Days (GDD)" ///
							20 "Deviation in GDD" ///
							21 "Z-Score of GDD" ///
							22 "Maximum Daily Temperature", replace

* create tables for rainfall
preserve

	keep if			varname < 15
	
* define loop through levels of countries	
	levelsof 	country		, local(lc)
	foreach c of local lc {
	    
	* define loop through levels of countries	
		levelsof 	sat		, local(ls)
		foreach s of local ls {
			estpost 		tabstat sig if country == `c' & sat == `s', by(varname) nototal ///
								statistics(mean) columns(statistics) listwise
			est 			store sig_`c'_`s'
		}
	}

			
* output table - rainfall ethiopia
	esttab 				sig_1* ///
							using "$xtab/var_sig_eth_rf.tex", ///
							main(mean) cells(mean(fmt(2))) label ///
							mtitle("CHIRPS" "CPC" "MERRA-2" ///
							"ARC2" "ERA5" "TAMSAT") ///
							nonum collabels(none) booktabs f replace
							
* output table - rainfall malawi
	esttab 				sig_2* ///
							using "$xtab/var_sig_mwi_rf.tex", ///
							main(mean) cells(mean(fmt(2))) label ///
							mtitle("CHIRPS" "CPC" "MERRA-2" ///
							"ARC2" "ERA5" "TAMSAT") ///
							nonum collabels(none) booktabs f replace
							
* output table - rainfall niger
	esttab 				sig_4* ///
							using "$xtab/var_sig_ngr_rf.tex", ///
							main(mean) cells(mean(fmt(2))) label ///
							mtitle("CHIRPS" "CPC" "MERRA-2" ///
							"ARC2" "ERA5" "TAMSAT") ///
							nonum collabels(none) booktabs f replace
							
* output table - rainfall nigeria
	esttab 				sig_5* ///
							using "$xtab/var_sig_nga_rf.tex", ///
							main(mean) cells(mean(fmt(2))) label ///
							mtitle("CHIRPS" "CPC" "MERRA-2" ///
							"ARC2" "ERA5" "TAMSAT") ///
							nonum collabels(none) booktabs f replace
							
* output table - rainfall tanzania
	esttab 				sig_6* ///
							using "$xtab/var_sig_tza_rf.tex", ///
							main(mean) cells(mean(fmt(2))) label ///
							mtitle("CHIRPS" "CPC" "MERRA-2" ///
							"ARC2" "ERA5" "TAMSAT") ///
							nonum collabels(none) booktabs f replace
							
* output table - rainfall uganda
	esttab 				sig_7* ///
							using "$xtab/var_sig_uga_rf.tex", ///
							main(mean) cells(mean(fmt(2))) label ///
							mtitle("CHIRPS" "CPC" "MERRA-2" ///
							"ARC2" "ERA5" "TAMSAT") ///
							nonum collabels(none) booktabs f replace
restore

est clear

* create tables for temperature
preserve

	keep if			varname > 14
	
* define loop through levels of countries	
	levelsof 	country		, local(lc)
	foreach c of local lc {
	    
	* define loop through levels of countries	
		levelsof 	sat		, local(ls)
		foreach s of local ls {
			estpost 		tabstat sig if country == `c' & sat == `s', by(varname) nototal ///
								statistics(mean) columns(statistics) listwise
			est 			store sig_`c'_`s'
		}
	}

			
* output table - temperature ethiopia
	esttab 				sig_1* ///
							using "$xtab/var_sig_eth_tp.tex", ///
							main(mean) cells(mean(fmt(2))) label ///
							mtitle("Temperature 1" "Temperature 2" ///
							"Temperature 3") nonum collabels(none) ///
							booktabs f replace
							
* output table - temperature malawi
	esttab 				sig_2* ///
							using "$xtab/var_sig_mwi_tp.tex", ///
							main(mean) cells(mean(fmt(2))) label ///
							mtitle("Temperature 1" "Temperature 2" ///
							"Temperature 3") nonum collabels(none) ///
							booktabs f replace
							
* output table - temperature niger
	esttab 				sig_4* ///
							using "$xtab/var_sig_ngr_tp.tex", ///
							main(mean) cells(mean(fmt(2))) label ///
							mtitle("Temperature 1" "Temperature 2" ///
							"Temperature 3") nonum collabels(none) ///
							booktabs f replace
							
* output table - temperature nigeria
	esttab 				sig_5* ///
							using "$xtab/var_sig_nga_tp.tex", ///
							main(mean) cells(mean(fmt(2))) label ///
							mtitle("Temperature 1" "Temperature 2" ///
							"Temperature 3") nonum collabels(none) ///
							booktabs f replace
							
* output table - temperature tanzania
	esttab 				sig_6* ///
							using "$xtab/var_sig_tza_tp.tex", ///
							main(mean) cells(mean(fmt(2))) label ///
							mtitle("Temperature 1" "Temperature 2" ///
							"Temperature 3") nonum collabels(none) ///
							booktabs f replace
							
* output table - temperature uganda
	esttab 				sig_7* ///
							using "$xtab/var_sig_uga_tp.tex", ///
							main(mean) cells(mean(fmt(2))) label ///
							mtitle("Temperature 1" "Temperature 2" ///
							"Temperature 3") nonum collabels(none) ///
							booktabs f replace
restore	

*/

* **********************************************************************
* 4 - select weather metrics to investigate
* **********************************************************************

* based on above analysis we will proceed with following rainfall metrics
	* mean rainfall (varname == 1)
	* total rainfall (varname == 5)
	* rainy days or % rainy days (choose one of these two) (varname == 8)

* based on above analysis we will proceed with following temperature metrics
	* mean temperature (varname == 15)
	* median temperature (varname == 16)


* **********************************************************************
* 3a - specification curves for ethiopia
* **********************************************************************
/*
* mean daily rainfall
preserve
	keep			if varname == 1 & country == 1
	sort 			beta
	gen 			obs = _n

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	depvar + 6 + 2
	gen				k3		=	sat + 6 + 2 + 2 + 2
	
* label new variables	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Dependant Variable"
	lab 			var k3 "Weather Product"

	sum			 	ci_up
	global			bmax = r(max)
	
	sum			 	ci_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	28
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
			
	twoway 			scatter k1 k2 k3 obs, xlab(0(4)72) xsize(10) ysize(6) msize(small small small)  ///
						title("Mean Daily Rainfall") ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Quantity" 10 "Value" 11 "*{bf:Dependant Variable}*" ///
						13 "CHIRPS" 14 "CPC" 15 "MERRA-2" ///
						16 "ARC2" 17 "ERA5" 18 "TAMSAT" ///
						19 "*{bf:Rainfall Product}*" 28 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter b_ns obs, yaxis(2) mcolor(black%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(scatter b_sig obs, yaxis(2) mcolor(edkblue%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) yaxis(2) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) yaxis(2)  ///
						yline(0, lcolor(maroon) axis(2) lstyle(solid) ) ), ///
						legend(order(4 5) cols(2) size(small) rowgap(.5) pos(12)) ///
						saving("$sfig/eth_v01_sat", replace)						
restore
	
* total seasonal rainfall
preserve
	keep			if varname == 5 & country == 1
	sort 			beta
	gen 			obs = _n

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	depvar + 6 + 2
	gen				k3		=	sat + 6 + 2 + 2 + 2
	
* label new variables	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Dependant Variable"
	lab 			var k3 "Weather Product"

	sum			 	ci_up
	global			bmax = r(max)
	
	sum			 	ci_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	28
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
			
	twoway 			scatter k1 k2 k3 obs, xlab(0(4)72) xsize(10) ysize(6) msize(small small small)  ///
						title("Total Seasonal Rainfall") ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Quantity" 10 "Value" 11 "*{bf:Dependant Variable}*" ///
						13 "CHIRPS" 14 "CPC" 15 "MERRA-2" ///
						16 "ARC2" 17 "ERA5" 18 "TAMSAT" ///
						19 "*{bf:Rainfall Product}*" 28 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter b_ns obs, yaxis(2) mcolor(black%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(scatter b_sig obs, yaxis(2) mcolor(edkblue%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) yaxis(2) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) yaxis(2)  ///
						yline(0, lcolor(maroon) axis(2) lstyle(solid) ) ), ///
						legend(order(4 5) cols(2) size(small) rowgap(.5) pos(12)) ///
						saving("$sfig/eth_v05_sat", replace)						
restore

* rainy days rainfall
preserve
	keep			if varname == 8 & country == 1
	sort 			beta
	gen 			obs = _n

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	depvar + 6 + 2
	gen				k3		=	sat + 6 + 2 + 2 + 2
	
* label new variables	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Dependant Variable"
	lab 			var k3 "Weather Product"

	sum			 	ci_up
	global			bmax = r(max)
	
	sum			 	ci_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	28
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
			
	twoway 			scatter k1 k2 k3 obs, xlab(0(4)72) xsize(10) ysize(6) msize(small small small)  ///
						title("Number of Rainy Days") ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Quantity" 10 "Value" 11 "*{bf:Dependant Variable}*" ///
						13 "CHIRPS" 14 "CPC" 15 "MERRA-2" ///
						16 "ARC2" 17 "ERA5" 18 "TAMSAT" ///
						19 "*{bf:Rainfall Product}*" 28 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter b_ns obs, yaxis(2) mcolor(black%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(scatter b_sig obs, yaxis(2) mcolor(edkblue%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) yaxis(2) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) yaxis(2)  ///
						yline(0, lcolor(maroon) axis(2) lstyle(solid) ) ), ///
						legend(order(4 5) cols(2) size(small) rowgap(.5) pos(12)) ///
						saving("$sfig/eth_v08_sat", replace)						
restore	

* combine varname specification curves
	grc1leg2 		"$sfig/eth_v01_sat.gph" "$sfig/eth_v05_sat.gph"  ///
						"$sfig/eth_v08_sat.gph", col(2) iscale(.5) ///
						ring(0) pos(5) holes(4) commonscheme
						
	graph export 	"$xfig\eth_rain_sat.pdf", as(pdf) replace


* **********************************************************************
* 3b - specification curves for malawi
* **********************************************************************

* mean daily rainfall
preserve
	keep			if varname == 1 & country == 2
	sort 			beta
	gen 			obs = _n

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	depvar + 6 + 2
	gen				k3		=	sat + 6 + 2 + 2 + 2
	
* label new variables	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Dependant Variable"
	lab 			var k3 "Weather Product"

	sum			 	ci_up
	global			bmax = r(max)
	
	sum			 	ci_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	28
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
			
	twoway 			scatter k1 k2 k3 obs, xlab(0(4)72) xsize(10) ysize(6) msize(small small small)  ///
						title("Mean Daily Rainfall") ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Quantity" 10 "Value" 11 "*{bf:Dependant Variable}*" ///
						13 "CHIRPS" 14 "CPC" 15 "MERRA-2" ///
						16 "ARC2" 17 "ERA5" 18 "TAMSAT" ///
						19 "*{bf:Rainfall Product}*" 28 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter b_ns obs, yaxis(2) mcolor(black%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(scatter b_sig obs, yaxis(2) mcolor(edkblue%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) yaxis(2) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) yaxis(2)  ///
						yline(0, lcolor(maroon) axis(2) lstyle(solid) ) ), ///
						legend(order(4 5) cols(2) size(small) rowgap(.5) pos(12)) ///
						saving("$sfig/mwi_v01_sat", replace)						
restore
	
* total seasonal rainfall
preserve
	keep			if varname == 5 & country == 2
	sort 			beta
	gen 			obs = _n

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	depvar + 6 + 2
	gen				k3		=	sat + 6 + 2 + 2 + 2
	
* label new variables	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Dependant Variable"
	lab 			var k3 "Weather Product"

	sum			 	ci_up
	global			bmax = r(max)
	
	sum			 	ci_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	28
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
			
	twoway 			scatter k1 k2 k3 obs, xlab(0(4)72) xsize(10) ysize(6) msize(small small small)  ///
						title("Total Seasonal Rainfall") ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Quantity" 10 "Value" 11 "*{bf:Dependant Variable}*" ///
						13 "CHIRPS" 14 "CPC" 15 "MERRA-2" ///
						16 "ARC2" 17 "ERA5" 18 "TAMSAT" ///
						19 "*{bf:Rainfall Product}*" 28 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter b_ns obs, yaxis(2) mcolor(black%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(scatter b_sig obs, yaxis(2) mcolor(edkblue%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) yaxis(2) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) yaxis(2)  ///
						yline(0, lcolor(maroon) axis(2) lstyle(solid) ) ), ///
						legend(order(4 5) cols(2) size(small) rowgap(.5) pos(12)) ///
						saving("$sfig/mwi_v05_sat", replace)						
restore

* rainy days rainfall
preserve
	keep			if varname == 8 & country == 2
	sort 			beta
	gen 			obs = _n

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	depvar + 6 + 2
	gen				k3		=	sat + 6 + 2 + 2 + 2
	
* label new variables	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Dependant Variable"
	lab 			var k3 "Weather Product"

	sum			 	ci_up
	global			bmax = r(max)
	
	sum			 	ci_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	28
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight	
		
	twoway 			scatter k1 k2 k3 obs, xlab(0(4)72) xsize(10) ysize(6) msize(small small small)  ///
						title("Number of Rainy Days") ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Quantity" 10 "Value" 11 "*{bf:Dependant Variable}*" ///
						13 "CHIRPS" 14 "CPC" 15 "MERRA-2" ///
						16 "ARC2" 17 "ERA5" 18 "TAMSAT" ///
						19 "*{bf:Rainfall Product}*" 28 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter b_ns obs, yaxis(2) mcolor(black%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(scatter b_sig obs, yaxis(2) mcolor(edkblue%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) yaxis(2) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) yaxis(2)  ///
						yline(0, lcolor(maroon) axis(2) lstyle(solid) ) ), ///
						legend(order(4 5) cols(2) size(small) rowgap(.5) pos(12)) ///
						saving("$sfig/mwi_v08_sat", replace)						
restore
	
* combine varname specification curves
	grc1leg2 		"$sfig/mwi_v01_sat.gph" "$sfig/mwi_v05_sat.gph"  ///
						"$sfig/mwi_v08_sat.gph", col(2) iscale(.5) ///
						ring(0) pos(5) holes(4) commonscheme
						
	graph export 	"$xfig\mwi_rain_sat.pdf", as(pdf) replace


* **********************************************************************
* 3c - specification curves for niger
* **********************************************************************

* mean daily rainfall
preserve
	keep			if varname == 1 & country == 4
	sort 			beta
	gen 			obs = _n

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	depvar + 6 + 2
	gen				k3		=	sat + 6 + 2 + 2 + 2
	
* label new variables	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Dependant Variable"
	lab 			var k3 "Weather Product"

	sum			 	ci_up
	global			bmax = r(max)
	
	sum			 	ci_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	28
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
			
	twoway 			scatter k1 k2 k3 obs, xlab(0(4)72) xsize(10) ysize(6) msize(small small small)  ///
						title("Mean Daily Rainfall") ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Quantity" 10 "Value" 11 "*{bf:Dependant Variable}*" ///
						13 "CHIRPS" 14 "CPC" 15 "MERRA-2" ///
						16 "ARC2" 17 "ERA5" 18 "TAMSAT" ///
						19 "*{bf:Rainfall Product}*" 28 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter b_ns obs, yaxis(2) mcolor(black%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(scatter b_sig obs, yaxis(2) mcolor(edkblue%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) yaxis(2) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) yaxis(2)  ///
						yline(0, lcolor(maroon) axis(2) lstyle(solid) ) ), ///
						legend(order(4 5) cols(2) size(small) rowgap(.5) pos(12)) ///
						saving("$sfig/ngr_v01_sat", replace)						
restore
	
* total seasonal rainfall
preserve
	keep			if varname == 5 & country == 4
	sort 			beta
	gen 			obs = _n

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	depvar + 6 + 2
	gen				k3		=	sat + 6 + 2 + 2 + 2
	
* label new variables	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Dependant Variable"
	lab 			var k3 "Weather Product"

	sum			 	ci_up
	global			bmax = r(max)
	
	sum			 	ci_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	28
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight	
		
	twoway 			scatter k1 k2 k3 obs, xlab(0(4)72) xsize(10) ysize(6) msize(small small small)  ///
						title("Total Seasonal Rainfall") ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Quantity" 10 "Value" 11 "*{bf:Dependant Variable}*" ///
						13 "CHIRPS" 14 "CPC" 15 "MERRA-2" ///
						16 "ARC2" 17 "ERA5" 18 "TAMSAT" ///
						19 "*{bf:Rainfall Product}*" 28 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter b_ns obs, yaxis(2) mcolor(black%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(scatter b_sig obs, yaxis(2) mcolor(edkblue%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) yaxis(2) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) yaxis(2)  ///
						yline(0, lcolor(maroon) axis(2) lstyle(solid) ) ), ///
						legend(order(4 5) cols(2) size(small) rowgap(.5) pos(12)) ///
						saving("$sfig/ngr_v05_sat", replace)						
restore

* rainy days rainfall
preserve
	keep			if varname == 8 & country == 4
	sort 			beta
	gen 			obs = _n

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	depvar + 6 + 2
	gen				k3		=	sat + 6 + 2 + 2 + 2
	
* label new variables	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Dependant Variable"
	lab 			var k3 "Weather Product"

	sum			 	ci_up
	global			bmax = r(max)
	
	sum			 	ci_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	28
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight	
		
	twoway 			scatter k1 k2 k3 obs, xlab(0(4)72) xsize(10) ysize(6) msize(small small small)  ///
						title("Number of Rainy Days") ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Quantity" 10 "Value" 11 "*{bf:Dependant Variable}*" ///
						13 "CHIRPS" 14 "CPC" 15 "MERRA-2" ///
						16 "ARC2" 17 "ERA5" 18 "TAMSAT" ///
						19 "*{bf:Rainfall Product}*" 28 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter b_ns obs, yaxis(2) mcolor(black%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(scatter b_sig obs, yaxis(2) mcolor(edkblue%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) yaxis(2) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) yaxis(2)  ///
						yline(0, lcolor(maroon) axis(2) lstyle(solid) ) ), ///
						legend(order(4 5) cols(2) size(small) rowgap(.5) pos(12)) ///
						saving("$sfig/ngr_v08_sat", replace)						
restore
	
* combine varname specification curves
	grc1leg2 		"$sfig/ngr_v01_sat.gph" "$sfig/ngr_v05_sat.gph"  ///
						"$sfig/ngr_v08_sat.gph", col(2) iscale(.5) ///
						ring(0) pos(5) holes(4) commonscheme
						
	graph export 	"$xfig\ngr_rain_sat.pdf", as(pdf) replace

	
* **********************************************************************
* 3d - specification curves for nigeria
* **********************************************************************

* mean daily rainfall
preserve
	keep			if varname == 1 & country == 5
	sort 			beta
	gen 			obs = _n

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	depvar + 6 + 2
	gen				k3		=	sat + 6 + 2 + 2 + 2
	
* label new variables	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Dependant Variable"
	lab 			var k3 "Weather Product"

	sum			 	ci_up
	global			bmax = r(max)
	
	sum			 	ci_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	28
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight

	twoway 			scatter k1 k2 k3 obs, xlab(0(4)72) xsize(10) ysize(6) msize(small small small)  ///
						title("Mean Daily Rainfall") ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Quantity" 10 "Value" 11 "*{bf:Dependant Variable}*" ///
						13 "CHIRPS" 14 "CPC" 15 "MERRA-2" ///
						16 "ARC2" 17 "ERA5" 18 "TAMSAT" ///
						19 "*{bf:Rainfall Product}*" 28 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter b_ns obs, yaxis(2) mcolor(black%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(scatter b_sig obs, yaxis(2) mcolor(edkblue%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) yaxis(2) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) yaxis(2)  ///
						yline(0, lcolor(maroon) axis(2) lstyle(solid) ) ), ///
						legend(order(4 5) cols(2) size(small) rowgap(.5) pos(12)) ///
						saving("$sfig/nga_v01_sat", replace)						
restore
	
* total seasonal rainfall
preserve
	keep			if varname == 5 & country == 5
	sort 			beta
	gen 			obs = _n

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	depvar + 6 + 2
	gen				k3		=	sat + 6 + 2 + 2 + 2
	
* label new variables	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Dependant Variable"
	lab 			var k3 "Weather Product"

	sum			 	ci_up
	global			bmax = r(max)
	
	sum			 	ci_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	28
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight	
		
	twoway 			scatter k1 k2 k3 obs, xlab(0(4)72) xsize(10) ysize(6) msize(small small small)  ///
						title("Total Seasonal Rainfall") ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Quantity" 10 "Value" 11 "*{bf:Dependant Variable}*" ///
						13 "CHIRPS" 14 "CPC" 15 "MERRA-2" ///
						16 "ARC2" 17 "ERA5" 18 "TAMSAT" ///
						19 "*{bf:Rainfall Product}*" 28 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter b_ns obs, yaxis(2) mcolor(black%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(scatter b_sig obs, yaxis(2) mcolor(edkblue%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) yaxis(2) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) yaxis(2)  ///
						yline(0, lcolor(maroon) axis(2) lstyle(solid) ) ), ///
						legend(order(4 5) cols(2) size(small) rowgap(.5) pos(12)) ///
						saving("$sfig/nga_v05_sat", replace)						
restore

* rainy days rainfall
preserve
	keep			if varname == 8 & country == 5
	sort 			beta
	gen 			obs = _n

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	depvar + 6 + 2
	gen				k3		=	sat + 6 + 2 + 2 + 2
	
* label new variables	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Dependant Variable"
	lab 			var k3 "Weather Product"

	sum			 	ci_up
	global			bmax = r(max)
	
	sum			 	ci_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	28
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
		
	twoway 			scatter k1 k2 k3 obs, xlab(0(4)72) xsize(10) ysize(6) msize(small small small)  ///
						title("Number of Rainy Days") ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Quantity" 10 "Value" 11 "*{bf:Dependant Variable}*" ///
						13 "CHIRPS" 14 "CPC" 15 "MERRA-2" ///
						16 "ARC2" 17 "ERA5" 18 "TAMSAT" ///
						19 "*{bf:Rainfall Product}*" 28 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter b_ns obs, yaxis(2) mcolor(black%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(scatter b_sig obs, yaxis(2) mcolor(edkblue%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) yaxis(2) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) yaxis(2)  ///
						yline(0, lcolor(maroon) axis(2) lstyle(solid) ) ), ///
						legend(order(4 5) cols(2) size(small) rowgap(.5) pos(12)) ///
						saving("$sfig/nga_v08_sat", replace)						
restore

* combine varname specification curves
	grc1leg2 		"$sfig/nga_v01_sat.gph" "$sfig/nga_v05_sat.gph"  ///
						"$sfig/nga_v08_sat.gph", col(2) iscale(.5) ///
						ring(0) pos(5) holes(4) commonscheme
						
	graph export 	"$xfig\nga_rain_sat.pdf", as(pdf) replace

	
* **********************************************************************
* 3e - specification curves for tanzania
* **********************************************************************

* mean daily rainfall
preserve
	keep			if varname == 1 & country == 6
	sort 			beta
	gen 			obs = _n

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	depvar + 6 + 2
	gen				k3		=	sat + 6 + 2 + 2 + 2
	
* label new variables	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Dependant Variable"
	lab 			var k3 "Weather Product"

	sum			 	ci_up
	global			bmax = r(max)
	
	sum			 	ci_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	28
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
			
	twoway 			scatter k1 k2 k3 obs, xlab(0(4)72) xsize(10) ysize(6) msize(small small small)  ///
						title("Mean Daily Rainfall") ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Quantity" 10 "Value" 11 "*{bf:Dependant Variable}*" ///
						13 "CHIRPS" 14 "CPC" 15 "MERRA-2" ///
						16 "ARC2" 17 "ERA5" 18 "TAMSAT" ///
						19 "*{bf:Rainfall Product}*" 28 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter b_ns obs, yaxis(2) mcolor(black%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(scatter b_sig obs, yaxis(2) mcolor(edkblue%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) yaxis(2) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) yaxis(2)  ///
						yline(0, lcolor(maroon) axis(2) lstyle(solid) ) ), ///
						legend(order(4 5) cols(2) size(small) rowgap(.5) pos(12)) ///
						saving("$sfig/tza_v01_sat", replace)						
restore
	
* total seasonal rainfall
preserve
	keep			if varname == 5 & country == 6
	sort 			beta
	gen 			obs = _n

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	depvar + 6 + 2
	gen				k3		=	sat + 6 + 2 + 2 + 2
	
* label new variables	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Dependant Variable"
	lab 			var k3 "Weather Product"

	sum			 	ci_up
	global			bmax = r(max)
	
	sum			 	ci_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	28
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
			
	twoway 			scatter k1 k2 k3 obs, xlab(0(4)72) xsize(10) ysize(6) msize(small small small)  ///
						title("Total Seasonal Rainfall") ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Quantity" 10 "Value" 11 "*{bf:Dependant Variable}*" ///
						13 "CHIRPS" 14 "CPC" 15 "MERRA-2" ///
						16 "ARC2" 17 "ERA5" 18 "TAMSAT" ///
						19 "*{bf:Rainfall Product}*" 28 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter b_ns obs, yaxis(2) mcolor(black%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(scatter b_sig obs, yaxis(2) mcolor(edkblue%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) yaxis(2) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) yaxis(2)  ///
						yline(0, lcolor(maroon) axis(2) lstyle(solid) ) ), ///
						legend(order(4 5) cols(2) size(small) rowgap(.5) pos(12)) ///
						saving("$sfig/tza_v05_sat", replace)						
restore

* rainy days rainfall
preserve
	keep			if varname == 8 & country == 6
	sort 			beta
	gen 			obs = _n

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	depvar + 6 + 2
	gen				k3		=	sat + 6 + 2 + 2 + 2
	
* label new variables	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Dependant Variable"
	lab 			var k3 "Weather Product"

	sum			 	ci_up
	global			bmax = r(max)
	
	sum			 	ci_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	28
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
			
	twoway 			scatter k1 k2 k3 obs, xlab(0(4)72) xsize(10) ysize(6) msize(small small small)  ///
						title("Number of Rainy Days") ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Quantity" 10 "Value" 11 "*{bf:Dependant Variable}*" ///
						13 "CHIRPS" 14 "CPC" 15 "MERRA-2" ///
						16 "ARC2" 17 "ERA5" 18 "TAMSAT" ///
						19 "*{bf:Rainfall Product}*" 28 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter b_ns obs, yaxis(2) mcolor(black%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(scatter b_sig obs, yaxis(2) mcolor(edkblue%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) yaxis(2) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) yaxis(2)  ///
						yline(0, lcolor(maroon) axis(2) lstyle(solid) ) ), ///
						legend(order(4 5) cols(2) size(small) rowgap(.5) pos(12)) ///
						saving("$sfig/tza_v08_sat", replace)						
restore
	
* combine varname specification curves
	grc1leg2 		"$sfig/tza_v01_sat.gph" "$sfig/tza_v05_sat.gph"  ///
						"$sfig/tza_v08_sat.gph", col(2) iscale(.5) ///
						ring(0) pos(5) holes(4) commonscheme
						
	graph export 	"$xfig\tza_rain_sat.pdf", as(pdf) replace			

*/
* **********************************************************************
* 3f - specification curves for uganda
* **********************************************************************

* mean daily rainfall
preserve
	keep			if varname == 1 & country == 7
	sort 			beta
	gen 			obs = _n

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	depvar + 6 + 2
	gen				k3		=	sat + 6 + 2 + 2 + 2
	
* label new variables	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Dependant Variable"
	lab 			var k3 "Weather Product"

	sum			 	ci_up
	global			bmax = r(max)
	
	sum			 	ci_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	28
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
		
	twoway 			scatter k1 k2 k3 obs, xlab(0(4)72) xsize(10) ysize(6) msize(small small small)  ///
						title("Mean Daily Rainfall") ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Quantity" 10 "Value" 11 "*{bf:Dependant Variable}*" ///
						13 "CHIRPS" 14 "CPC" 15 "MERRA-2" ///
						16 "ARC2" 17 "ERA5" 18 "TAMSAT" ///
						19 "*{bf:Rainfall Product}*" 28 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter b_ns obs, yaxis(2) mcolor(black%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(scatter b_sig obs, yaxis(2) mcolor(edkblue%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) yaxis(2) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) yaxis(2)  ///
						yline(0, lcolor(maroon) axis(2) lstyle(solid) ) ), ///
						legend(order(4 5) cols(2) size(small) rowgap(.5) pos(12)) ///
						saving("$sfig/uga_v01_sat", replace)						
restore
	
* total seasonal rainfall
preserve
	keep			if varname == 5 & country == 7
	sort 			beta
	gen 			obs = _n

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	depvar + 6 + 2
	gen				k3		=	sat + 6 + 2 + 2 + 2
	
* label new variables	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Dependant Variable"
	lab 			var k3 "Weather Product"

	sum			 	ci_up
	global			bmax = r(max)
	
	sum			 	ci_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	28
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
		
	twoway 			scatter k1 k2 k3 obs, xlab(0(4)72) xsize(10) ysize(6) msize(small small small)  ///
						title("Total Seasonal Rainfall") ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Quantity" 10 "Value" 11 "*{bf:Dependant Variable}*" ///
						13 "CHIRPS" 14 "CPC" 15 "MERRA-2" ///
						16 "ARC2" 17 "ERA5" 18 "TAMSAT" ///
						19 "*{bf:Rainfall Product}*" 28 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter b_ns obs, yaxis(2) mcolor(black%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(scatter b_sig obs, yaxis(2) mcolor(edkblue%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) yaxis(2) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) yaxis(2)  ///
						yline(0, lcolor(maroon) axis(2) lstyle(solid) ) ), ///
						legend(order(4 5) cols(2) size(small) rowgap(.5) pos(12)) ///
						saving("$sfig/uga_v05_sat", replace)						
restore

* rainy days rainfall
preserve
	keep			if varname == 8 & country == 7
	sort 			beta
	gen 			obs = _n

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	depvar + 6 + 2
	gen				k3		=	sat + 6 + 2 + 2 + 2
	
* label new variables	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Dependant Variable"
	lab 			var k3 "Weather Product"

	sum			 	ci_up
	global			bmax = r(max)
	
	sum			 	ci_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	28
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
			
	twoway 			scatter k1 k2 k3 obs, xlab(0(4)72) xsize(10) ysize(6) msize(small small small)  ///
						title("Number of Rainy Days") ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Quantity" 10 "Value" 11 "*{bf:Dependant Variable}*" ///
						13 "CHIRPS" 14 "CPC" 15 "MERRA-2" ///
						16 "ARC2" 17 "ERA5" 18 "TAMSAT" ///
						19 "*{bf:Rainfall Product}*" 28 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter b_ns obs, yaxis(2) mcolor(black%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(scatter b_sig obs, yaxis(2) mcolor(edkblue%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) yaxis(2) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) yaxis(2)  ///
						yline(0, lcolor(maroon) axis(2) lstyle(solid) ) ), ///
						legend(order(4 5) cols(2) size(small) rowgap(.5) pos(12)) ///
						saving("$sfig/uga_v08_sat", replace)						
restore

* longest dry spell
preserve
	keep			if varname == 14 & country == 7
	sort 			beta
	gen 			obs = _n

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	depvar + 6 + 2
	gen				k3		=	sat + 6 + 2 + 2 + 2
	
* label new variables	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Dependant Variable"
	lab 			var k3 "Weather Product"

	sum			 	ci_up
	global			bmax = r(max)
	
	sum			 	ci_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	28
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
			
	twoway 			scatter k1 k2 k3 obs, xlab(0(4)72) xsize(10) ysize(6) msize(small small small)  ///
						title("Longest Dry Spell") ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Quantity" 10 "Value" 11 "*{bf:Dependant Variable}*" ///
						13 "CHIRPS" 14 "CPC" 15 "MERRA-2" ///
						16 "ARC2" 17 "ERA5" 18 "TAMSAT" ///
						19 "*{bf:Rainfall Product}*" 28 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter b_ns obs, yaxis(2) mcolor(black%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(scatter b_sig obs, yaxis(2) mcolor(edkblue%75) ylab(, axis(2) ///
						labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2)) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) yaxis(2) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) yaxis(2)  ///
						yline(0, lcolor(maroon) axis(2) lstyle(solid) ) ), ///
						legend(order(4 5) cols(2) size(small) rowgap(.5) pos(12)) ///
						saving("$sfig/uga_v14_sat", replace)						
restore

* combine varname specification curves
	grc1leg2 		"$sfig/uga_v01_sat.gph" "$sfig/uga_v05_sat.gph"  ///
						"$sfig/uga_v08_sat.gph" "$sfig/uga_v14_sat.gph", ///
						col(2) iscale(.5) ///
						ring(0) pos(12) commonscheme
						
	graph export 	"$xfig\uga_rain_sat.pdf", as(pdf) replace
						
		
* **********************************************************************
* 4 - end matter
* **********************************************************************


* close the log
	log	close

/* END */		