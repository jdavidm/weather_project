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

* percentage of days with rain
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

* max daily temperature
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
* 3 - generate serrbar graphs by metric
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
* 3a - generate serrbar graphs by rainfall variable and country
* **********************************************************************

*** mean daily rainfall ***

* ethiopia
preserve
	keep			if country == 1 & varname == 1
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(edkblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Ethiopia") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v01_eth", replace)
restore

* malawi
preserve
	keep			if country == 2 & varname == 1
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(edkblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Malawi") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v01_mwi", replace)
restore

* niger
preserve
	keep			if country == 4 & varname == 1
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(edkblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Niger") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v01_ngr", replace)
restore

* nigeria
preserve
	keep			if country == 5 & varname == 1
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(edkblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Nigeria") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v01_nga", replace)
restore

* tanzania
preserve
	keep			if country == 6 & varname == 1
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(edkblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Tanzania") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v01_tza", replace)
restore

* uganda
preserve
	keep			if country == 7 & varname == 1
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(edkblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Uganda") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v01_uga", replace)
restore

	
* combine mean daily rain
	gr combine 		"$sfig/v01_eth.gph" "$sfig/v01_mwi.gph" "$sfig/v01_ngr.gph" ///
						"$sfig/v01_nga.gph" "$sfig/v01_tza.gph" "$sfig/v01_uga.gph", ///
						col(2) iscale(.5) commonscheme title("Mean Daily Rainfall")
						
	graph export 	"$xfig\v01_cty.png", as(png) replace

	
*** median daily rainfall ***

* ethiopia
preserve
	keep			if country == 1 & varname == 2
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emidblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emidblue%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Ethiopia") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v02_eth", replace)
restore

* malawi
preserve
	keep			if country == 2 & varname == 2
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emidblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emidblue%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Malawi") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v02_mwi", replace)
restore

* niger
preserve
	keep			if country == 4 & varname == 2
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emidblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emidblue%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Niger") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v02_ngr", replace)
restore

* nigeria
preserve
	keep			if country == 5 & varname == 2
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emidblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emidblue%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Nigeria") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v02_nga", replace)
restore

* tanzania
preserve
	keep			if country == 6 & varname == 2
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emidblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emidblue%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Tanzania") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v02_tza", replace)
restore

* uganda
preserve
	keep			if country == 7 & varname == 2
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emidblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emidblue%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Uganda") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v02_uga", replace)
restore

	
* combine median daily rain
	gr combine 		"$sfig/v02_eth.gph" "$sfig/v02_mwi.gph" "$sfig/v02_ngr.gph" ///
						"$sfig/v02_nga.gph" "$sfig/v02_tza.gph" "$sfig/v02_uga.gph", ///
						col(2) iscale(.5) commonscheme title("Median Daily Rainfall")
						
	graph export 	"$xfig\v02_cty.png", as(png) replace

	
*** variance daily rainfall ***

* ethiopia
preserve
	keep			if country == 1 & varname == 3
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(eltblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(eltblue%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Ethiopia") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v03_eth", replace)
restore

* malawi
preserve
	keep			if country == 2 & varname == 3
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(eltblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(eltblue%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Malawi") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v03_mwi", replace)
restore

* niger
preserve
	keep			if country == 4 & varname == 3
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(eltblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(eltblue%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Niger") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v03_ngr", replace)
restore

* nigeria
preserve
	keep			if country == 5 & varname == 3
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(eltblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(eltblue%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Nigeria") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v03_nga", replace)
restore

* tanzania
preserve
	keep			if country == 6 & varname == 3
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(eltblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(eltblue%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Tanzania") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v03_tza", replace)
restore

* uganda
preserve
	keep			if country == 7 & varname == 3
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(eltblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(eltblue%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Uganda") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v03_uga", replace)
restore

	
* combine variance daily rain
	gr combine 		"$sfig/v03_eth.gph" "$sfig/v03_mwi.gph" "$sfig/v03_ngr.gph" ///
						"$sfig/v03_nga.gph" "$sfig/v03_tza.gph" "$sfig/v03_uga.gph", ///
						col(2) iscale(.5) commonscheme title("Variance of Daily Rainfall")
						
	graph export 	"$xfig\v03_cty.png", as(png) replace
		
	
*** skew daily rainfall ***

* ethiopia
preserve
	keep			if country == 1 & varname == 4
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emerald%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emerald%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Ethiopia") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v04_eth", replace)
restore

* malawi
preserve
	keep			if country == 2 & varname == 4
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emerald%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emerald%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Malawi") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v04_mwi", replace)
restore

* niger
preserve
	keep			if country == 4 & varname == 4
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emerald%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emerald%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Niger") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v04_ngr", replace)
restore

* nigeria
preserve
	keep			if country == 5 & varname == 4
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emerald%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emerald%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Nigeria") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v04_nga", replace)
restore

* tanzania
preserve
	keep			if country == 6 & varname == 4
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emerald%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emerald%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Tanzania") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v04_tza", replace)
restore

* uganda
preserve
	keep			if country == 7 & varname == 4
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emerald%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emerald%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Uganda") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v04_uga", replace)
restore

	
* combine skew daily rain
	gr combine 		"$sfig/v04_eth.gph" "$sfig/v04_mwi.gph" "$sfig/v04_ngr.gph" ///
						"$sfig/v04_nga.gph" "$sfig/v04_tza.gph" "$sfig/v04_uga.gph", ///
						col(2) iscale(.5) commonscheme title("Skew of Daily Rainfall")
						
	graph export 	"$xfig\v04_cty.png", as(png) replace
			
		
*** total seasonal rainfall ***

* ethiopia
preserve
	keep			if country == 1 & varname == 5
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(erose%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(erose%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Ethiopia") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v05_eth", replace)
restore

* malawi
preserve
	keep			if country == 2 & varname == 5
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(erose%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(erose%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Malawi") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v05_mwi", replace)
restore

* niger
preserve
	keep			if country == 4 & varname == 5
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(erose%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(erose%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Niger") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v05_ngr", replace)
restore

* nigeria
preserve
	keep			if country == 5 & varname == 5
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(erose%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(erose%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Nigeria") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v05_nga", replace)
restore

* tanzania
preserve
	keep			if country == 6 & varname == 5
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(erose%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(erose%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Tanzania") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v05_tza", replace)
restore

* uganda
preserve
	keep			if country == 7 & varname == 5
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(erose%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(erose%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Uganda") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v05_uga", replace)
restore

	
* combine total seasonal rain
	gr combine 		"$sfig/v05_eth.gph" "$sfig/v05_mwi.gph" "$sfig/v05_ngr.gph" ///
						"$sfig/v05_nga.gph" "$sfig/v05_tza.gph" "$sfig/v05_uga.gph", ///
						col(2) iscale(.5) commonscheme title("Total Seasonal Rainfall")
						
	graph export 	"$xfig\v05_cty.png", as(png) replace
			
		
*** deviation in total seasonal rainfall ***

* ethiopia
preserve
	keep			if country == 1 & varname == 6
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(ebblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(ebblue%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Ethiopia") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v06_eth", replace)
restore

* malawi
preserve
	keep			if country == 2 & varname == 6
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(ebblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(ebblue%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Malawi") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v06_mwi", replace)
restore

* niger
preserve
	keep			if country == 4 & varname == 6
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(ebblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(ebblue%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Niger") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v06_ngr", replace)
restore

* nigeria
preserve
	keep			if country == 5 & varname == 6
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(ebblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(ebblue%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Nigeria") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v06_nga", replace)
restore

* tanzania
preserve
	keep			if country == 6 & varname == 6
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(ebblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(ebblue%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Tanzania") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v06_tza", replace)
restore

* uganda
preserve
	keep			if country == 7 & varname == 6
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(ebblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(ebblue%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Uganda") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v06_uga", replace)
restore

	
* combine deviation in total seasonal rain
	gr combine 		"$sfig/v06_eth.gph" "$sfig/v06_mwi.gph" "$sfig/v06_ngr.gph" ///
						"$sfig/v06_nga.gph" "$sfig/v06_tza.gph" "$sfig/v06_uga.gph", ///
						col(2) iscale(.5) commonscheme title("Deviation in Total Seasonal Rainfall")
						
	graph export 	"$xfig\v06_cty.png", as(png) replace
		
			
*** z-score total seasonal rainfall ***

* ethiopia
preserve
	keep			if country == 1 & varname == 7
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(eltgreen%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(eltgreen%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Ethiopia") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v07_eth", replace)
restore

* malawi
preserve
	keep			if country == 2 & varname == 7
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(eltgreen%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(eltgreen%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Malawi") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v07_mwi", replace)
restore

* niger
preserve
	keep			if country == 4 & varname == 7
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(eltgreen%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(eltgreen%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Niger") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v07_ngr", replace)
restore

* nigeria
preserve
	keep			if country == 5 & varname == 7
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(eltgreen%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(eltgreen%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Nigeria") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v07_nga", replace)
restore

* tanzania
preserve
	keep			if country == 6 & varname == 7
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(eltgreen%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(eltgreen%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Tanzania") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v07_tza", replace)
restore

* uganda
preserve
	keep			if country == 7 & varname == 7
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(eltgreen%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(eltgreen%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Uganda") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v07_uga", replace)
restore

	
* combine z-score of total seasonal rain
	gr combine 		"$sfig/v07_eth.gph" "$sfig/v07_mwi.gph" "$sfig/v07_ngr.gph" ///
						"$sfig/v07_nga.gph" "$sfig/v07_tza.gph" "$sfig/v07_uga.gph", ///
						col(2) iscale(.5) commonscheme title("z-Score of Total Seasonal Rainfall")
						
	graph export 	"$xfig\v07_cty.png", as(png) replace

			
*** number of days with rain ***

* ethiopia
preserve
	keep			if country == 1 & varname == 8
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(stone%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(stone%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Ethiopia") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v08_eth", replace)
restore

* malawi
preserve
	keep			if country == 2 & varname == 8
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(stone%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(stone%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Malawi") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v08_mwi", replace)
restore

* niger
preserve
	keep			if country == 4 & varname == 8
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(stone%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(stone%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Niger") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v08_ngr", replace)
restore

* nigeria
preserve
	keep			if country == 5 & varname == 8
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(stone%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(stone%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Nigeria") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v08_nga", replace)
restore

* tanzania
preserve
	keep			if country == 6 & varname == 8
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(stone%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(stone%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Tanzania") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v08_tza", replace)
restore

* uganda
preserve
	keep			if country == 7 & varname == 8
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(stone%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(stone%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Uganda") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v08_uga", replace)
restore

	
* combine number of days with rain
	gr combine 		"$sfig/v08_eth.gph" "$sfig/v08_mwi.gph" "$sfig/v08_ngr.gph" ///
						"$sfig/v08_nga.gph" "$sfig/v08_tza.gph" "$sfig/v08_uga.gph", ///
						col(2) iscale(.5) commonscheme title("Number of Days with Rain")
						
	graph export 	"$xfig\v08_cty.png", as(png) replace
		
		
*** deviation in number of days with rain ***

* ethiopia
preserve
	keep			if country == 1 & varname == 9
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(navy%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(navy%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Ethiopia") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v09_eth", replace)
restore

* malawi
preserve
	keep			if country == 2 & varname == 9
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(navy%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(navy%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Malawi") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v09_mwi", replace)
restore

* niger
preserve
	keep			if country == 4 & varname == 9
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(navy%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(navy%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Niger") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v09_ngr", replace)
restore

* nigeria
preserve
	keep			if country == 5 & varname == 9
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(navy%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(navy%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Nigeria") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v09_nga", replace)
restore

* tanzania
preserve
	keep			if country == 6 & varname == 9
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(navy%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(navy%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Tanzania") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v09_tza", replace)
restore

* uganda
preserve
	keep			if country == 7 & varname == 9
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(navy%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(navy%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Uganda") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v09_uga", replace)
restore

	
* combine deviation in number of days with rain
	gr combine 		"$sfig/v09_eth.gph" "$sfig/v09_mwi.gph" "$sfig/v09_ngr.gph" ///
						"$sfig/v09_nga.gph" "$sfig/v09_tza.gph" "$sfig/v09_uga.gph", ///
						col(2) iscale(.5) commonscheme title("Deviation in Number of Days with Rain")
						
	graph export 	"$xfig\v09_cty.png", as(png) replace

	
*** number of days without rain ***

* ethiopia
preserve
	keep			if country == 1 & varname == 10
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(brown%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(brown%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Ethiopia") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v10_eth", replace)
restore

* malawi
preserve
	keep			if country == 2 & varname == 10
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(brown%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(brown%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Malawi") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v10_mwi", replace)
restore

* niger
preserve
	keep			if country == 4 & varname == 10
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(brown%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(brown%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Niger") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v10_ngr", replace)
restore

* nigeria
preserve
	keep			if country == 5 & varname == 10
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(brown%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(brown%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Nigeria") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v10_nga", replace)
restore

* tanzania
preserve
	keep			if country == 6 & varname == 10
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(brown%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(brown%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Tanzania") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v10_tza", replace)
restore

* uganda
preserve
	keep			if country == 7 & varname == 10
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(brown%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(brown%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Uganda") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v10_uga", replace)
restore

	
* combine number of days without rain
	gr combine 		"$sfig/v10_eth.gph" "$sfig/v10_mwi.gph" "$sfig/v10_ngr.gph" ///
						"$sfig/v10_nga.gph" "$sfig/v10_tza.gph" "$sfig/v10_uga.gph", ///
						col(2) iscale(.5) commonscheme title("Number of Days without Rain")
						
	graph export 	"$xfig\v10_cty.png", as(png) replace

	
*** deviation in no rain days ***

* ethiopia
preserve
	keep			if country == 1 & varname == 11
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(lavender%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(lavender%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Ethiopia") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v11_eth", replace)
restore

* malawi
preserve
	keep			if country == 2 & varname == 11
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(lavender%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(lavender%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Malawi") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v11_mwi", replace)
restore

* niger
preserve
	keep			if country == 4 & varname == 11
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(lavender%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(lavender%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Niger") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v11_ngr", replace)
restore

* nigeria
preserve
	keep			if country == 5 & varname == 11
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(lavender%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(lavender%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Nigeria") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v11_nga", replace)
restore

* tanzania
preserve
	keep			if country == 6 & varname == 11
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(lavender%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(lavender%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Tanzania") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v11_tza", replace)
restore

* uganda
preserve
	keep			if country == 7 & varname == 11
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(lavender%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(lavender%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Uganda") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v11_uga", replace)
restore

	
* combine deviation in no rain days
	gr combine 		"$sfig/v11_eth.gph" "$sfig/v11_mwi.gph" "$sfig/v11_ngr.gph" ///
						"$sfig/v11_nga.gph" "$sfig/v11_tza.gph" "$sfig/v11_uga.gph", ///
						col(2) iscale(.5) commonscheme title("Deviation in No Rain Days")
						
	graph export 	"$xfig\v11_cty.png", as(png) replace
				
	
*** percentage of days with rain ***

* ethiopia
preserve
	keep			if country == 1 & varname == 12
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(teal%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(teal%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Ethiopia") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v12_eth", replace)
restore

* malawi
preserve
	keep			if country == 2 & varname == 12
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(teal%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(teal%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Malawi") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v12_mwi", replace)
restore

* niger
preserve
	keep			if country == 4 & varname == 12
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(teal%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(teal%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Niger") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v12_ngr", replace)
restore

* nigeria
preserve
	keep			if country == 5 & varname == 12
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(teal%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(teal%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Nigeria") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v12_nga", replace)
restore

* tanzania
preserve
	keep			if country == 6 & varname == 12
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(teal%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(teal%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Tanzania") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v12_tza", replace)
restore

* uganda
preserve
	keep			if country == 7 & varname == 12
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(teal%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(teal%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Uganda") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v12_uga", replace)
restore

	
* combine percentage of days with rain
	gr combine 		"$sfig/v12_eth.gph" "$sfig/v12_mwi.gph" "$sfig/v12_ngr.gph" ///
						"$sfig/v12_nga.gph" "$sfig/v12_tza.gph" "$sfig/v12_uga.gph", ///
						col(2) iscale(.5) commonscheme title("Percentage of Days with Rain")
						
	graph export 	"$xfig\v12_cty.png", as(png) replace
				
	
*** deviation in % of days with rain ***

* ethiopia
preserve
	keep			if country == 1 & varname == 13
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(cranberry%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(cranberry%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Ethiopia") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v13_eth", replace)
restore

* malawi
preserve
	keep			if country == 2 & varname == 13
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(cranberry%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(cranberry%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Malawi") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v13_mwi", replace)
restore

* niger
preserve
	keep			if country == 4 & varname == 13
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(cranberry%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(cranberry%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Niger") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v13_ngr", replace)
restore

* nigeria
preserve
	keep			if country == 5 & varname == 13
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(cranberry%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(cranberry%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Nigeria") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v13_nga", replace)
restore

* tanzania
preserve
	keep			if country == 6 & varname == 13
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(cranberry%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(cranberry%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Tanzania") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v13_tza", replace)
restore

* uganda
preserve
	keep			if country == 7 & varname == 13
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(cranberry%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(cranberry%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Uganda") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v13_uga", replace)
restore

	
* combine deviation in percentage of days with rain
	gr combine 		"$sfig/v13_eth.gph" "$sfig/v13_mwi.gph" "$sfig/v13_ngr.gph" ///
						"$sfig/v13_nga.gph" "$sfig/v13_tza.gph" "$sfig/v13_uga.gph", ///
						col(2) iscale(.5) commonscheme title("Deviation in Percentage of Days with Rain")
						
	graph export 	"$xfig\v13_cty.png", as(png) replace
				
	
*** longest dry spell ***

* ethiopia
preserve
	keep			if country == 1 & varname == 14
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(khaki%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(khaki%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Ethiopia") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v14_eth", replace)
restore

* malawi
preserve
	keep			if country == 2 & varname == 14
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(khaki%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(khaki%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Malawi") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v14_mwi", replace)
restore

* niger
preserve
	keep			if country == 4 & varname == 14
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(khaki%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(khaki%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Niger") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v14_ngr", replace)
restore

* nigeria
preserve
	keep			if country == 5 & varname == 14
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(khaki%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(khaki%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Nigeria") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v14_nga", replace)
restore

* tanzania
preserve
	keep			if country == 6 & varname == 14
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(khaki%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(khaki%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Tanzania") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v14_tza", replace)
restore

* uganda
preserve
	keep			if country == 7 & varname == 14
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(khaki%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(khaki%50) xscale(r(0 72)) ///
						yline(0, lcolor(maroon) ) xlabel(0(12)72) ///
						ytitle("Coefficient") title("Uganda") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v14_uga", replace)
restore

	
* combine longest dry spell
	gr combine 		"$sfig/v14_eth.gph" "$sfig/v14_mwi.gph" "$sfig/v14_ngr.gph" ///
						"$sfig/v14_nga.gph" "$sfig/v14_tza.gph" "$sfig/v14_uga.gph", ///
						col(2) iscale(.5) commonscheme title("Longest Dry Spell")
						
	graph export 	"$xfig\v14_cty.png", as(png) replace
	

* **********************************************************************
* 3b - generate serrbar graphs by temperature variable and country
* **********************************************************************

*** mean daily temperature ***		

* ethiopia
preserve
	keep			if country == 1 & varname == 15
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(edkblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Ethiopia") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v15_eth", replace)
restore

* malawi
preserve
	keep			if country == 2 & varname == 15
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(edkblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Malawi") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v15_mwi", replace)
restore

* niger
preserve
	keep			if country == 4 & varname == 15
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(edkblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Niger") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v15_ngr", replace)
restore

* nigeria
preserve
	keep			if country == 5 & varname == 15
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(edkblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Nigeria") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v15_nga", replace)
restore

* tanzania
preserve
	keep			if country == 6 & varname == 15
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(edkblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Tanzania") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v15_tza", replace)
restore

* uganda
preserve
	keep			if country == 7 & varname == 15
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(edkblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(edkblue%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Uganda") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v15_uga", replace)
restore

	
* combine mean daily temperature
	gr combine 		"$sfig/v15_eth.gph" "$sfig/v15_mwi.gph" "$sfig/v15_ngr.gph" ///
						"$sfig/v15_nga.gph" "$sfig/v15_tza.gph" "$sfig/v15_uga.gph", ///
						col(2) iscale(.5) commonscheme title("Mean Daily Temperature")
						
	graph export 	"$xfig\v15_cty.png", as(png) replace

	
*** median daily temperature ***		

* ethiopia
preserve
	keep			if country == 1 & varname == 16
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emidblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emidblue%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Ethiopia") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v16_eth", replace)
restore

* malawi
preserve
	keep			if country == 2 & varname == 16
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emidblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emidblue%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Malawi") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v16_mwi", replace)
restore

* niger
preserve
	keep			if country == 4 & varname == 16
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emidblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emidblue%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Niger") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v16_ngr", replace)
restore

* nigeria
preserve
	keep			if country == 5 & varname == 16
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emidblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emidblue%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Nigeria") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v16_nga", replace)
restore

* tanzania
preserve
	keep			if country == 6 & varname == 16
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emidblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emidblue%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Tanzania") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v16_tza", replace)
restore

* uganda
preserve
	keep			if country == 7 & varname == 16
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emidblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emidblue%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Uganda") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v16_uga", replace)
restore

	
* combine median daily temperature
	gr combine 		"$sfig/v16_eth.gph" "$sfig/v16_mwi.gph" "$sfig/v16_ngr.gph" ///
						"$sfig/v16_nga.gph" "$sfig/v16_tza.gph" "$sfig/v16_uga.gph", ///
						col(2) iscale(.5) commonscheme title("Median Daily Temperature")
						
	graph export 	"$xfig\v16_cty.png", as(png) replace
	
	
*** variance of daily temperature ***		

* ethiopia
preserve
	keep			if country == 1 & varname == 17
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(eltblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(eltblue%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Ethiopia") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v17_eth", replace)
restore

* malawi
preserve
	keep			if country == 2 & varname == 17
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(eltblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(eltblue%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Malawi") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v17_mwi", replace)
restore

* niger
preserve
	keep			if country == 4 & varname == 17
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(eltblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(eltblue%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Niger") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v17_ngr", replace)
restore

* nigeria
preserve
	keep			if country == 5 & varname == 17
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(eltblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(eltblue%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Nigeria") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v17_nga", replace)
restore

* tanzania
preserve
	keep			if country == 6 & varname == 17
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(eltblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(eltblue%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Tanzania") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v17_tza", replace)
restore

* uganda
preserve
	keep			if country == 7 & varname == 17
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(eltblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(eltblue%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Uganda") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v17_uga", replace)
restore

	
* combine variance of daily temperature
	gr combine 		"$sfig/v17_eth.gph" "$sfig/v17_mwi.gph" "$sfig/v17_ngr.gph" ///
						"$sfig/v17_nga.gph" "$sfig/v17_tza.gph" "$sfig/v17_uga.gph", ///
						col(2) iscale(.5) commonscheme title("Variance of Daily Temperature")
						
	graph export 	"$xfig\v17_cty.png", as(png) replace
	
	
*** skew of daily temperature ***		

* ethiopia
preserve
	keep			if country == 1 & varname == 18
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emerald%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emerald%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Ethiopia") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v18_eth", replace)
restore

* malawi
preserve
	keep			if country == 2 & varname == 18
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emerald%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emerald%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Malawi") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v18_mwi", replace)
restore

* niger
preserve
	keep			if country == 4 & varname == 18
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emerald%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emerald%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Niger") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v18_ngr", replace)
restore

* nigeria
preserve
	keep			if country == 5 & varname == 18
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emerald%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emerald%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Nigeria") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v18_nga", replace)
restore

* tanzania
preserve
	keep			if country == 6 & varname == 18
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emerald%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emerald%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Tanzania") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v18_tza", replace)
restore

* uganda
preserve
	keep			if country == 7 & varname == 18
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(emerald%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(emerald%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Uganda") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v18_uga", replace)
restore

	
* combine skew of daily temperature
	gr combine 		"$sfig/v18_eth.gph" "$sfig/v18_mwi.gph" "$sfig/v18_ngr.gph" ///
						"$sfig/v18_nga.gph" "$sfig/v18_tza.gph" "$sfig/v18_uga.gph", ///
						col(2) iscale(.5) commonscheme title("Skew of Daily Temperature")
						
	graph export 	"$xfig\v18_cty.png", as(png) replace

	
*** growing degree days (gdd) ***		

* ethiopia
preserve
	keep			if country == 1 & varname == 19
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(erose%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(erose%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Ethiopia") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v19_eth", replace)
restore

* malawi
preserve
	keep			if country == 2 & varname == 19
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(erose%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(erose%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Malawi") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v19_mwi", replace)
restore

* niger
preserve
	keep			if country == 4 & varname == 19
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(erose%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(erose%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Niger") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v19_ngr", replace)
restore

* nigeria
preserve
	keep			if country == 5 & varname == 19
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(erose%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(erose%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Nigeria") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v19_nga", replace)
restore

* tanzania
preserve
	keep			if country == 6 & varname == 19
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(erose%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(erose%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Tanzania") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v19_tza", replace)
restore

* uganda
preserve
	keep			if country == 7 & varname == 19
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(erose%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(erose%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Uganda") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v19_uga", replace)
restore

	
* combine growing degree days (gdd)
	gr combine 		"$sfig/v19_eth.gph" "$sfig/v19_mwi.gph" "$sfig/v19_ngr.gph" ///
						"$sfig/v19_nga.gph" "$sfig/v19_tza.gph" "$sfig/v19_uga.gph", ///
						col(2) iscale(.5) commonscheme title("Growing Degree Days (GDD)")
						
	graph export 	"$xfig\v19_cty.png", as(png) replace

	
*** deviation in growing degree days (gdd) ***		

* ethiopia
preserve
	keep			if country == 1 & varname == 20
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(ebblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(ebblue%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Ethiopia") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v20_eth", replace)
restore

* malawi
preserve
	keep			if country == 2 & varname == 20
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(ebblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(ebblue%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Malawi") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v20_mwi", replace)
restore

* niger
preserve
	keep			if country == 4 & varname == 20
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(ebblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(ebblue%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Niger") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v20_ngr", replace)
restore

* nigeria
preserve
	keep			if country == 5 & varname == 20
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(ebblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(ebblue%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Nigeria") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v20_nga", replace)
restore

* tanzania
preserve
	keep			if country == 6 & varname == 20
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(ebblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(ebblue%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Tanzania") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v20_tza", replace)
restore

* uganda
preserve
	keep			if country == 7 & varname == 20
	sort 			country beta
	gen 			obs = _n

	twoway			(scatter b_ns obs, mcolor(black%75) ) || ///
						(scatter b_sig obs, mcolor(ebblue%75) ) || ///
						(rbar ci_lo ci_up obs if b_sig == ., ///
						barwidth(.2) color(black%50) ) || ///
						(rbar ci_lo ci_up obs if b_sig != ., ///
						barwidth(.2) color(ebblue%50) xscale(r(0 36)) ///
						yline(0, lcolor(maroon) ) xlabel(0(6)36) ///
						ytitle("Coefficient") title("Uganda") ///
						xtitle("") ), legend(pos(12) col(2) ///
						order(1 2)) saving("$sfig/v20_uga", replace)
restore

	
* combine deviation in growing degree days (gdd)
	gr combine 		"$sfig/v20_eth.gph" "$sfig/v20_mwi.gph" "$sfig/v20_ngr.gph" ///
						"$sfig/v20_nga.gph" "$sfig/v20_tza.gph" "$sfig/v20_uga.gph", ///
						col(2) iscale(.5) commonscheme title("Deviation in Growing Degree Days (GDD)")
						
	graph export 	"$xfig\v20_cty.png", as(png) replace
						
		
* **********************************************************************
* 4 - generate serrbar graphs by satellite
* **********************************************************************


* **********************************************************************
* 4a - generate serrbar graphs by rainfall variable and satellite
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
* 4b - generate serrbar graphs by temperature variable and satellite
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
* 4c - generate table of significant values
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
							mtitle("Rainfall 1" "Rainfall 2" "Rainfall 3" ///
							"Rainfall 4" "Rainfall 5" "Rainfall 6") ///
							nonum collabels(none) booktabs f replace
							
* output table - rainfall malawi
	esttab 				sig_2* ///
							using "$xtab/var_sig_mwi_rf.tex", ///
							main(mean) cells(mean(fmt(2))) label ///
							mtitle("Rainfall 1" "Rainfall 2" "Rainfall 3" ///
							"Rainfall 4" "Rainfall 5" "Rainfall 6") ///
							nonum collabels(none) booktabs f replace
							
* output table - rainfall niger
	esttab 				sig_4* ///
							using "$xtab/var_sig_ngr_rf.tex", ///
							main(mean) cells(mean(fmt(2))) label ///
							mtitle("Rainfall 1" "Rainfall 2" "Rainfall 3" ///
							"Rainfall 4" "Rainfall 5" "Rainfall 6") ///
							nonum collabels(none) booktabs f replace
							
* output table - rainfall nigeria
	esttab 				sig_5* ///
							using "$xtab/var_sig_nga_rf.tex", ///
							main(mean) cells(mean(fmt(2))) label ///
							mtitle("Rainfall 1" "Rainfall 2" "Rainfall 3" ///
							"Rainfall 4" "Rainfall 5" "Rainfall 6") ///
							nonum collabels(none) booktabs f replace
							
* output table - rainfall tanzania
	esttab 				sig_6* ///
							using "$xtab/var_sig_tza_rf.tex", ///
							main(mean) cells(mean(fmt(2))) label ///
							mtitle("Rainfall 1" "Rainfall 2" "Rainfall 3" ///
							"Rainfall 4" "Rainfall 5" "Rainfall 6") ///
							nonum collabels(none) booktabs f replace
							
* output table - rainfall uganda
	esttab 				sig_7* ///
							using "$xtab/var_sig_uga_rf.tex", ///
							main(mean) cells(mean(fmt(2))) label ///
							mtitle("Rainfall 1" "Rainfall 2" "Rainfall 3" ///
							"Rainfall 4" "Rainfall 5" "Rainfall 6") ///
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


* **********************************************************************
* 5 - select weather metrics to investigate
* **********************************************************************

* based on above analysis we will proceed with following rainfall metrics
	* mean rainfall (varname == 1)
	* total rainfall (varname == 5)
	* rainy days or % rainy days (choose one of these two) (varname == 8)

* based on above analysis we will proceed with following temperature metrics
	* mean temperature (varname == 15)
	* median temperature (varname == 16)


* **********************************************************************
* 5a - specification curves for ethiopia
* **********************************************************************

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
						13 "Rainfall 1" 14 "Rainfall 2" 15 "Rainfall 3" ///
						16 "Rainfall 4" 17 "Rainfall 5" 18 "Rainfall 6" ///
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
						13 "Rainfall 1" 14 "Rainfall 2" 15 "Rainfall 3" ///
						16 "Rainfall 4" 17 "Rainfall 5" 18 "Rainfall 6" ///
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
						13 "Rainfall 1" 14 "Rainfall 2" 15 "Rainfall 3" ///
						16 "Rainfall 4" 17 "Rainfall 5" 18 "Rainfall 6" ///
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
* 5b - specification curves for malawi
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
						13 "Rainfall 1" 14 "Rainfall 2" 15 "Rainfall 3" ///
						16 "Rainfall 4" 17 "Rainfall 5" 18 "Rainfall 6" ///
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
						13 "Rainfall 1" 14 "Rainfall 2" 15 "Rainfall 3" ///
						16 "Rainfall 4" 17 "Rainfall 5" 18 "Rainfall 6" ///
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
						13 "Rainfall 1" 14 "Rainfall 2" 15 "Rainfall 3" ///
						16 "Rainfall 4" 17 "Rainfall 5" 18 "Rainfall 6" ///
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
* 5c - specification curves for niger
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
						13 "Rainfall 1" 14 "Rainfall 2" 15 "Rainfall 3" ///
						16 "Rainfall 4" 17 "Rainfall 5" 18 "Rainfall 6" ///
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
						13 "Rainfall 1" 14 "Rainfall 2" 15 "Rainfall 3" ///
						16 "Rainfall 4" 17 "Rainfall 5" 18 "Rainfall 6" ///
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
						13 "Rainfall 1" 14 "Rainfall 2" 15 "Rainfall 3" ///
						16 "Rainfall 4" 17 "Rainfall 5" 18 "Rainfall 6" ///
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
* 5d - specification curves for nigeria
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
						13 "Rainfall 1" 14 "Rainfall 2" 15 "Rainfall 3" ///
						16 "Rainfall 4" 17 "Rainfall 5" 18 "Rainfall 6" ///
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
						13 "Rainfall 1" 14 "Rainfall 2" 15 "Rainfall 3" ///
						16 "Rainfall 4" 17 "Rainfall 5" 18 "Rainfall 6" ///
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
						13 "Rainfall 1" 14 "Rainfall 2" 15 "Rainfall 3" ///
						16 "Rainfall 4" 17 "Rainfall 5" 18 "Rainfall 6" ///
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
* 5e - specification curves for tanzania
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
						13 "Rainfall 1" 14 "Rainfall 2" 15 "Rainfall 3" ///
						16 "Rainfall 4" 17 "Rainfall 5" 18 "Rainfall 6" ///
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
						13 "Rainfall 1" 14 "Rainfall 2" 15 "Rainfall 3" ///
						16 "Rainfall 4" 17 "Rainfall 5" 18 "Rainfall 6" ///
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
						13 "Rainfall 1" 14 "Rainfall 2" 15 "Rainfall 3" ///
						16 "Rainfall 4" 17 "Rainfall 5" 18 "Rainfall 6" ///
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

	
* **********************************************************************
* 5f - specification curves for uganda
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
						13 "Rainfall 1" 14 "Rainfall 2" 15 "Rainfall 3" ///
						16 "Rainfall 4" 17 "Rainfall 5" 18 "Rainfall 6" ///
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
						13 "Rainfall 1" 14 "Rainfall 2" 15 "Rainfall 3" ///
						16 "Rainfall 4" 17 "Rainfall 5" 18 "Rainfall 6" ///
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
						13 "Rainfall 1" 14 "Rainfall 2" 15 "Rainfall 3" ///
						16 "Rainfall 4" 17 "Rainfall 5" 18 "Rainfall 6" ///
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

* combine varname specification curves
	grc1leg2 		"$sfig/uga_v01_sat.gph" "$sfig/uga_v05_sat.gph"  ///
						"$sfig/uga_v08_sat.gph", col(2) iscale(.5) ///
						ring(0) pos(5) holes(4) commonscheme
						
	graph export 	"$xfig\uga_rain_sat.pdf", as(pdf) replace
						
		
* **********************************************************************
* 6 - end matter
* **********************************************************************


* close the log
	log	close

/* END */		