* Project: WB Weather
* Created on: September 2020
* Created by: alj
* Edited by: alj
* Last edit: 9 November 2020 
* Stata v.16.1 

* does
	* reads in lsms data set
	* makes visualziations of summary statistics  

* assumes
	* you have results file 
	* customsave.ado
	* grc1leg2.ado

* TO DO:
	* complete

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	global	root 	= 	"$data/regression_data/eawp_sandbox"
	global	stab 	= 	"$data/results_data/tables/eawp_tables"
	global	xtab 	= 	"$data/output/paper/tables/eawp_tables"
	global	sfig	= 	"$data/results_data/figures/eawp_figures"	
	global 	xfig    =   "$data/output/paper/figures/eawp_figures"
	global	logout 	= 	"$data/results_data/logs"


* open log	
	cap log close
	log 	using 		"$logout/eawp_summaryvis", append

		
* **********************************************************************
* 1 - load and process data
* **********************************************************************

* load data 
	use 			"$root/eafrica_aez_panel.dta", clear

* replace missing values as zeros for rainfall variables 1-9
	forval j = 1/9 {
	    forval i = 1/6 {
				qui: replace		v0`j'_rf`i'_x1 = 0 if v0`j'_rf`i'_x1 == .    
		}
	}

* replace missing values as zeros for rainfall variables 10-14
	forval j = 10/14 {
	    forval i = 1/6 {
				qui: replace		v`j'_rf`i'_x`k' = 0 if v`j'_rf`i'_x`k' == .    
		}
	}

* replace missing values as zeros for temperature variables 15-22
	forval j = 15/22 {
	    forval i = 1/3 {
				qui: replace		v`j'_tp`i'_x`k' = 0 if v`j'_tp`i'_x`k' == .    
		}
	}


* **********************************************************************
* 2 - generate summary variables
* **********************************************************************

* generate averages across extractions for rainfall variables 1-9
	forval j = 1/9 {
	    forval i = 1/6 {
				egen 		v0`j'_rf`i' = rowmean(v0`j'_rf`i'_x1)  
		}
	}
	
* generate averages across extractions for rainfall variables 10-14
	forval j = 10/14 {
	    forval i = 1/6 {
				egen 		v`j'_rf`i' = rowmean(v`j'_rf`i'_x1)
		}
	}

* generate averages across extractions for temperature variables 15-22
	forval j = 15/22 {
	    forval i = 1/3 {
				egen 		v`j'_tp`i' = rowmean(v`j'_tp`i'_x1)
		}
	}		

* **********************************************************************
* 3 - generate total season distribution graphs by aez
* **********************************************************************

* total season rainfall - Tropic-warm/semiarid	
	twoway  (kdensity v05_rf1 if aez == 312, color(gray%30) recast(area)) ///
			(kdensity v05_rf2 if aez == 312, color(vermillion%30) recast(area)) ///
			(kdensity v05_rf3 if aez == 312, color(sea%30) recast(area)) ///
			(kdensity v05_rf4 if aez == 312, color(turquoise%30) recast(area)) ///
			(kdensity v05_rf5 if aez == 312, color(reddish%30) recast(area)) ///
			(kdensity v05_rf6 if aez == 312, color(ananas%30) recast(area) ///
			xtitle("") xscale(r(0(500)2000)) title("Tropic-warm/semiarid (n = 2,471)") ///
			ytitle("Density") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(2 "Rainfall 2") ///
			label(3 "Rainfall 3") label(4 "Rainfall 4") label(5 "Rainfall 5") ///
			label(6 "Rainfall 6")) saving("$sfig/twsa_density_rf", replace)

* total season rainfall - Tropic-warm/subhumid		
	twoway  (kdensity v05_rf1 if aez == 313, color(gray%30) recast(area)) ///
			(kdensity v05_rf2 if aez == 313, color(vermillion%30) recast(area)) ///
			(kdensity v05_rf3 if aez == 313, color(sea%30) recast(area)) ///
			(kdensity v05_rf4 if aez == 313, color(turquoise%30) recast(area)) ///
			(kdensity v05_rf5 if aez == 313, color(reddish%30) recast(area)) ///
			(kdensity v05_rf6 if aez == 313, color(ananas%30) recast(area) ///
			xtitle("") xscale(r(0(1000)4000)) title("Tropic-warm/subhumid (n = 4,626)") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(2 "Rainfall 2") ///
			label(3 "Rainfall 3") label(4 "Rainfall 4") label(5 "Rainfall 5") ///
			label(6 "Rainfall 6")) saving("$sfig/twsh_density_rf", replace)

* total season rainfall - Tropic-warm/humid		
	twoway  (kdensity v05_rf1 if aez == 314, color(gray%30) recast(area)) ///
			(kdensity v05_rf2 if aez == 314, color(vermillion%30) recast(area)) ///
			(kdensity v05_rf3 if aez == 314, color(sea%30) recast(area)) ///
			(kdensity v05_rf4 if aez == 314, color(turquoise%30) recast(area)) ///
			(kdensity v05_rf5 if aez == 314, color(reddish%30) recast(area)) ///
			(kdensity v05_rf6 if aez == 314, color(ananas%30) recast(area) ///
			xtitle("") xscale(r(0(1000)4000)) title("Tropic-warm/humid (n = 2,725)") ///
			ytitle("Density") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(2 "Rainfall 2") ///
			label(3 "Rainfall 3") label(4 "Rainfall 4") label(5 "Rainfall 5") ///
			label(6 "Rainfall 6")) saving("$sfig/twh_density_rf", replace)

* total season rainfall - Tropic-cool/semiarid	
	twoway  (kdensity v05_rf1 if aez == 322, color(gray%30) recast(area)) ///
			(kdensity v05_rf2 if aez == 322, color(vermillion%30) recast(area)) ///
			(kdensity v05_rf3 if aez == 322, color(sea%30) recast(area)) ///
			(kdensity v05_rf4 if aez == 322, color(turquoise%30) recast(area)) ///
			(kdensity v05_rf5 if aez == 322, color(reddish%30) recast(area)) ///
			(kdensity v05_rf6 if aez == 322, color(ananas%30) recast(area) ///
			xtitle("") xscale(r(0(500)2500)) title("Tropic-cool/semiarid (n = 2,840)") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(2 "Rainfall 2") ///
			label(3 "Rainfall 3") label(4 "Rainfall 4") label(5 "Rainfall 5") ///
			label(6 "Rainfall 6")) saving("$sfig/tcsa_density_rf", replace)

* total season rainfall - Tropic-cool/subhumid		
	twoway  (kdensity v05_rf1 if aez == 323, color(gray%30) recast(area)) ///
			(kdensity v05_rf2 if aez == 323, color(vermillion%30) recast(area)) ///
			(kdensity v05_rf3 if aez == 323, color(sea%30) recast(area)) ///
			(kdensity v05_rf4 if aez == 323, color(turquoise%30) recast(area)) ///
			(kdensity v05_rf5 if aez == 323, color(reddish%30) recast(area)) ///
			(kdensity v05_rf6 if aez == 323, color(ananas%30) recast(area) ///
			xtitle("Total Season Rainfall (mm)") xscale(r(0(1000)7000)) ///
			title("Tropic-cool/subhumid (n = 5,798)") ///
			ytitle("Density") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(2 "Rainfall 2") ///
			label(3 "Rainfall 3") label(4 "Rainfall 4") label(5 "Rainfall 5") ///
			label(6 "Rainfall 6")) saving("$sfig/tcsh_density_rf", replace)

* total season rainfall - Tropic-cool/humid		
	twoway  (kdensity v05_rf1 if aez == 324, color(gray%30) recast(area)) ///
			(kdensity v05_rf2 if aez == 324, color(vermillion%30) recast(area)) ///
			(kdensity v05_rf3 if aez == 324, color(sea%30) recast(area)) ///
			(kdensity v05_rf4 if aez == 324, color(turquoise%30) recast(area)) ///
			(kdensity v05_rf5 if aez == 324, color(reddish%30) recast(area)) ///
			(kdensity v05_rf6 if aez == 324, color(ananas%30) recast(area) ///
			xtitle("Total Season Rainfall (mm)") xscale(r(0(1000)4000)) ///
			title("Tropic-cool/humid (n = 2,960)") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(2 "Rainfall 2") ///
			label(3 "Rainfall 3") label(4 "Rainfall 4") label(5 "Rainfall 5") ///
			label(6 "Rainfall 6")) saving("$sfig/tch_density_rf", replace)			
			
	grc1leg2 		"$sfig/twsa_density_rf.gph" "$sfig/twsh_density_rf.gph" ///
						"$sfig/twh_density_rf.gph" "$sfig/tcsa_density_rf.gph" ///
						"$sfig/tcsh_density_rf.gph" "$sfig/tch_density_rf.gph", ///
						col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig\density_aez_rf.png", width(1400) replace

	
* **********************************************************************
* 4 - generate mean temperature distribution graphs
* **********************************************************************

* mean temp - Tropic-warm/semiarid
	twoway	(kdensity v15_tp1 if aez == 312, color(gray%30) recast(area)) ///
			(kdensity v15_tp2 if aez == 312, color(vermillion%30) recast(area)) ///
			(kdensity v15_tp3 if aez == 312, color(sea%30) recast(area) ///
			xtitle("") xscale(r(20(5)32)) title("Tropic-warm/semiarid (n = 2,471)") ///
			ytitle("Density") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(2 "Temperature 2") ///
			label(3 "Temperature 3")) saving("$sfig/twsa_density_tp", replace)

* mean temp - Tropic-warm/subhumid
	twoway	(kdensity v15_tp1 if aez == 313, color(gray%30) recast(area)) ///
			(kdensity v15_tp2 if aez == 313, color(vermillion%30) recast(area)) ///
			(kdensity v15_tp3 if aez == 313, color(sea%30) recast(area) ///
			xtitle("") xscale(r(15(5)30)) title("Tropic-warm/subhumid (n = 4,626)") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(2 "Temperature 2") ///
			label(3 "Temperature 3")) saving("$sfig/twsh_density_tp", replace)

* mean temp - Tropic-warm/humid
	twoway	(kdensity v15_tp1 if aez == 314, color(gray%30) recast(area)) ///
			(kdensity v15_tp2 if aez == 314, color(vermillion%30) recast(area)) ///
			(kdensity v15_tp3 if aez == 314, color(sea%30) recast(area) ///
			xtitle("") xscale(r(20(5)30)) title("Tropic-warm/humid (n = 2,725)") ///
			ytitle("Density") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(2 "Temperature 2") ///
			label(3 "Temperature 3")) saving("$sfig/twh_density_tp", replace)		

* mean temp - Tropic-cool/semiarid
	twoway	(kdensity v15_tp1 if aez == 322, color(gray%30) recast(area)) ///
			(kdensity v15_tp2 if aez == 322, color(vermillion%30) recast(area)) ///
			(kdensity v15_tp3 if aez == 322, color(sea%30) recast(area) ///
			xtitle("") xscale(r(15(5)30)) title("Tropic-cool/semiarid (n = 2,840)") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(2 "Temperature 2") ///
			label(3 "Temperature 3")) saving("$sfig/tcsa_density_tp", replace)

* mean temp - Tropic-cool/subhumid
	twoway	(kdensity v15_tp1 if aez == 323, color(gray%30) recast(area)) ///
			(kdensity v15_tp2 if aez == 323, color(vermillion%30) recast(area)) ///
			(kdensity v15_tp3 if aez == 323, color(sea%30) recast(area) ///
			xtitle("Mean Seasonal Temperature (C)") xscale(r(10(5)30)) ///
			title("Tropic-warm/subhumid (n = 5,798)") ///
			ytitle("Density") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(2 "Temperature 2") ///
			label(3 "Temperature 3")) saving("$sfig/tcsh_density_tp", replace)

* mean temp - Tropic-cool/humid
	twoway	(kdensity v15_tp1 if aez == 324, color(gray%30) recast(area)) ///
			(kdensity v15_tp2 if aez == 324, color(vermillion%30) recast(area)) ///
			(kdensity v15_tp3 if aez == 324, color(sea%30) recast(area) ///
			xtitle("Mean Seasonal Temperature (C)") xscale(r(16(2)26)) ///
			title("Tropic-warm/humid (n = 2,960)") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(2 "Temperature 2") ///
			label(3 "Temperature 3")) saving("$sfig/tch_density_tp", replace)				
		
		
	grc1leg2 		"$sfig/twsa_density_tp.gph" "$sfig/twsh_density_tp.gph" ///
						"$sfig/twh_density_tp.gph" "$sfig/tcsa_density_tp.gph" ///
						"$sfig/tcsh_density_tp.gph" "$sfig/tch_density_tp.gph", ///
						col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig\density_aez_tp.png", width(1400) replace
	

* **********************************************************************
* 5 - generate days without rain line graphs by aez
* **********************************************************************

* days without rain - Tropic-warm/semiarid	
	twoway  (fpfitci v10_rf1 year if aez == 312, color(gray%30) ) ///
			(fpfitci v10_rf2 year if aez == 312, color(vermillion%30) ) ///
			(fpfitci v10_rf3 year if aez == 312, color(sea%30) ) ///
			(fpfitci v10_rf4 year if aez == 312, color(turquoise%30) ) ///
			(fpfitci v10_rf5 year if aez == 312, color(reddish%30) ) ///
			(fpfitci v10_rf6 year if aez == 312, color(ananas%30)  ///
			xtitle("") xscale(r(2008(1)2015)) title("Tropic-warm/semiarid (n = 2,471)") ///
			ytitle("Days without Rain") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(3 "Rainfall 2") ///
			label(5 "Rainfall 3") label(7 "Rainfall 4") label(9 "Rainfall 5") ///
			label(11 "Rainfall 6") order(1 3 5 7 9 11)) saving("$sfig/twsa_norain_rf", replace)

* days without rain - Tropic-warm/subhumid	
	twoway  (fpfitci v10_rf1 year if aez == 313, color(gray%30) ) ///
			(fpfitci v10_rf2 year if aez == 313, color(vermillion%30) ) ///
			(fpfitci v10_rf3 year if aez == 313, color(sea%30) ) ///
			(fpfitci v10_rf4 year if aez == 313, color(turquoise%30) ) ///
			(fpfitci v10_rf5 year if aez == 313, color(reddish%30) ) ///
			(fpfitci v10_rf6 year if aez == 313, color(ananas%30)  ///
			xtitle("") xscale(r(2008(1)2015)) title("Tropic-warm/subhumid (n = 4,626)") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(3 "Rainfall 2") ///
			label(5 "Rainfall 3") label(7 "Rainfall 4") label(9 "Rainfall 5") ///
			label(11 "Rainfall 6") order(1 3 5 7 9 11)) saving("$sfig/twsh_norain_rf", replace)
			
* days without rain - Tropic-warm/humid	
	twoway  (fpfitci v10_rf1 year if aez == 314, color(gray%30) ) ///
			(fpfitci v10_rf2 year if aez == 314, color(vermillion%30) ) ///
			(fpfitci v10_rf3 year if aez == 314, color(sea%30) ) ///
			(fpfitci v10_rf4 year if aez == 314, color(turquoise%30) ) ///
			(fpfitci v10_rf5 year if aez == 314, color(reddish%30) ) ///
			(fpfitci v10_rf6 year if aez == 314, color(ananas%30)  ///
			xtitle("") xscale(r(2008(1)2015)) title("Tropic-warm/humid (n = 2,725)") ///
			ytitle("Days without Rain") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(3 "Rainfall 2") ///
			label(5 "Rainfall 3") label(7 "Rainfall 4") label(9 "Rainfall 5") ///
			label(11 "Rainfall 6") order(1 3 5 7 9 11)) saving("$sfig/twh_norain_rf", replace)

* days without rain - Tropic-cool/semiarid	
	twoway  (fpfitci v10_rf1 year if aez == 322, color(gray%30) ) ///
			(fpfitci v10_rf2 year if aez == 322, color(vermillion%30) ) ///
			(fpfitci v10_rf3 year if aez == 322, color(sea%30) ) ///
			(fpfitci v10_rf4 year if aez == 322, color(turquoise%30) ) ///
			(fpfitci v10_rf5 year if aez == 322, color(reddish%30) ) ///
			(fpfitci v10_rf6 year if aez == 322, color(ananas%30)  ///
			xtitle("") xscale(r(2008(1)2015)) title("Tropic-cool/semiarid (n = 2,840)") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(3 "Rainfall 2") ///
			label(5 "Rainfall 3") label(7 "Rainfall 4") label(9 "Rainfall 5") ///
			label(11 "Rainfall 6") order(1 3 5 7 9 11)) saving("$sfig/tcsa_norain_rf", replace)

* days without rain - Tropic-cool/subhumid	
	twoway  (fpfitci v10_rf1 year if aez == 323, color(gray%30) ) ///
			(fpfitci v10_rf2 year if aez == 323, color(vermillion%30) ) ///
			(fpfitci v10_rf3 year if aez == 323, color(sea%30) ) ///
			(fpfitci v10_rf4 year if aez == 323, color(turquoise%30) ) ///
			(fpfitci v10_rf5 year if aez == 323, color(reddish%30) ) ///
			(fpfitci v10_rf6 year if aez == 323, color(ananas%30)  ///
			xtitle("Year") xscale(r(2008(1)2015)) title("Tropic-cool/subhumid (n = 5,798)") ///
			ytitle("Days without Rain") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(3 "Rainfall 2") ///
			label(5 "Rainfall 3") label(7 "Rainfall 4") label(9 "Rainfall 5") ///
			label(11 "Rainfall 6") order(1 3 5 7 9 11)) saving("$sfig/tcsh_norain_rf", replace)
			
* days without rain - Tropic-cool/humid	
	twoway  (fpfitci v10_rf1 year if aez == 324, color(gray%30) ) ///
			(fpfitci v10_rf2 year if aez == 324, color(vermillion%30) ) ///
			(fpfitci v10_rf3 year if aez == 324, color(sea%30) ) ///
			(fpfitci v10_rf4 year if aez == 324, color(turquoise%30) ) ///
			(fpfitci v10_rf5 year if aez == 324, color(reddish%30) ) ///
			(fpfitci v10_rf6 year if aez == 324, color(ananas%30)  ///
			xtitle("Year") xscale(r(2008(1)2015)) title("Tropic-cool/humid (n = 2,960)") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(3 "Rainfall 2") ///
			label(5 "Rainfall 3") label(7 "Rainfall 4") label(9 "Rainfall 5") ///
			label(11 "Rainfall 6") order(1 3 5 7 9 11)) saving("$sfig/tch_norain_rf", replace)				
		
		
	grc1leg2 		"$sfig/twsa_norain_rf.gph" "$sfig/twsh_norain_rf.gph" ///
						"$sfig/twh_norain_rf.gph" "$sfig/tcsa_norain_rf.gph" ///
						"$sfig/tcsh_norain_rf.gph" "$sfig/tch_norain_rf.gph", ///
						col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig\norain_aez_rf.png", width(1400) replace	
			

* **********************************************************************
* 6 - generate GDD line graphs by aez
* **********************************************************************

* growing degree days - Tropic-warm/semiarid
	twoway	(fpfitci v19_tp1 year if aez == 312, color(gray%30) ) ///
			(fpfitci v19_tp2 year if aez == 312, color(vermillion%30) ) ///
			(fpfitci v19_tp3 year if aez == 312, color(sea%30)  ///
			xtitle("") xscale(r(2008(1)2015)) title("Tropic-warm/semiarid (n = 2,471)") ///
			ytitle("Growing degree days") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(3 "Temperature 2") ///
			label(5 "Temperature 3") order(1 3 5)) saving("$sfig/twsa_gdd_tp", replace)

* growing degree days - Tropic-warm/subhumid
	twoway	(fpfitci v19_tp1 year if aez == 313, color(gray%30) ) ///
			(fpfitci v19_tp2 year if aez == 313, color(vermillion%30) ) ///
			(fpfitci v19_tp3 year if aez == 313, color(sea%30)  ///
			xtitle("") xscale(r(2008(1)2015)) title("Tropic-warm/subhumid (n = 4,626)") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(3 "Temperature 2") ///
			label(5 "Temperature 3") order(1 3 5)) saving("$sfig/twsh_gdd_tp", replace)

* growing degree days - Tropic-warm/humid
	twoway	(fpfitci v19_tp1 year if aez == 314, color(gray%30) ) ///
			(fpfitci v19_tp2 year if aez == 314, color(vermillion%30) ) ///
			(fpfitci v19_tp3 year if aez == 314, color(sea%30) ///
			xtitle("") xscale(r(2008(1)2015)) title("Tropic-warm/humid (n = 2,725)") ///
			ytitle("Growing degree days") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(3 "Temperature 2") ///
			label(5 "Temperature 3") order(1 3 5)) saving("$sfig/twh_gdd_tp", replace)		

* growing degree days - Tropic-cool/semiarid
	twoway	(fpfitci v19_tp1 year if aez == 322, color(gray%30) ) ///
			(fpfitci v19_tp2 year if aez == 322, color(vermillion%30) ) ///
			(fpfitci v19_tp3 year if aez == 322, color(sea%30)  ///
			xtitle("") xscale(r(2008(1)2015)) title("Tropic-cool/semiarid (n = 2,840)") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(3 "Temperature 2") ///
			label(5 "Temperature 3") order(1 3 5)) saving("$sfig/tcsa_gdd_tp", replace)

* growing degree days - Tropic-cool/subhumid
	twoway	(fpfitci v19_tp1 year if aez == 323, color(gray%30) ) ///
			(fpfitci v19_tp2 year if aez == 323, color(vermillion%30) ) ///
			(fpfitci v19_tp3 year if aez == 323, color(sea%30)  ///
			xtitle("Year") xscale(r(2008(1)2015)) title("Tropic-cool/subhumid (n = 5,798)") ///
			ytitle("Gorwing degree days") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(3 "Temperature 2") ///
			label(5 "Temperature 3") order(1 3 5)) saving("$sfig/tcsh_gdd_tp", replace)

* growing degree days - Tropic-cool/humid
	twoway	(fpfitci v19_tp1 year if aez == 324, color(gray%30) ) ///
			(fpfitci v19_tp2 year if aez == 324, color(vermillion%30) ) ///
			(fpfitci v19_tp3 year if aez == 324, color(sea%30)  ///
			xtitle("Year") xscale(r(2008(1)2015)) title("Tropic-cool/humid (n = 2,960)") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(3 "Temperature 2") ///
			label(5 "Temperature 3") order(1 3 5)) saving("$sfig/tch_gdd_tp", replace)				
			
	grc1leg2 		"$sfig/twsa_gdd_tp.gph" "$sfig/twsh_gdd_tp.gph" ///
						"$sfig/twh_gdd_tp.gph" "$sfig/tcsa_gdd_tp.gph" ///
						"$sfig/tcsh_gdd_tp.gph" "$sfig/tch_gdd_tp.gph", ///
						col(2) iscale(.5) commonscheme
						
	graph export 	"$xfig\gdd_aez_tp.png", width(1400) replace			
			
			
* **********************************************************************
* 7 - end matter
* **********************************************************************

* close the log
	log	close

/* END */