* Project: WB Weather
* Created on: September 2020
* Created by: alj
* Edited by: alj
* Last edit: 28 September 2020 
* Stata v.16.1 

* does
	* reads in lsms data set
	* makes visualziations of summary statistics  

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
	global	root 	= 	"$data/regression_data"
	global	xtab 	= 	"$data/results_data/tables"
	global	xfig    =   "$data/results_data/figures"
	global	logout 	= 	"$data/results_data/logs"

* open log	
	cap log close
	log 	using 		"$logout/summaryvis", append

		
* **********************************************************************
* 1 - load and process data
* **********************************************************************

* load data 
	use 			"$root/lsms_panel", clear

* replace missing values as zeros for rainfall variables 1-9
	forval j = 1/9 {
	    forval i = 1/6 {
		    forval k = 0/9 {
				qui: replace		v0`j'_rf`i'_x`k' = 0 if v0`j'_rf`i'_x`k' == .    
			}
		}
	}

* replace missing values as zeros for rainfall variables 10-14
	forval j = 10/14 {
	    forval i = 1/6 {
		    forval k = 0/9 {
				qui: replace		v`j'_rf`i'_x`k' = 0 if v`j'_rf`i'_x`k' == .    
			}
		}
	}

* replace missing values as zeros for temperature variables 15-22
	forval j = 15/22 {
	    forval i = 1/3 {
		    forval k = 0/9 {
				qui: replace		v`j'_tp`i'_x`k' = 0 if v`j'_tp`i'_x`k' == .    
			}
		}
	}


* **********************************************************************
* 2 - generate summary variables
* **********************************************************************

* generate averages across extractions for rainfall variables 1-9
	forval j = 1/9 {
	    forval i = 1/6 {
				egen 		v0`j'_rf`i' = rowmean(v0`j'_rf`i'_x0 ///
								v0`j'_rf`i'_x1 v0`j'_rf`i'_x2 v0`j'_rf`i'_x3 ///
								v0`j'_rf`i'_x4 v0`j'_rf`i'_x5 v0`j'_rf`i'_x6 ///
								v0`j'_rf`i'_x7 v0`j'_rf`i'_x8 v0`j'_rf`i'_x9)  
		}
	}
	
* generate averages across extractions for rainfall variables 10-14
	forval j = 10/14 {
	    forval i = 1/6 {
				egen 		v`j'_rf`i' = rowmean(v`j'_rf`i'_x0 ///
								v`j'_rf`i'_x1 v`j'_rf`i'_x2 v`j'_rf`i'_x3 ///
								v`j'_rf`i'_x4 v`j'_rf`i'_x5 v`j'_rf`i'_x6 ///
								v`j'_rf`i'_x7 v`j'_rf`i'_x8 v`j'_rf`i'_x9)  
		}
	}

* generate averages across extractions for temperature variables 15-22
	forval j = 15/22 {
	    forval i = 1/3 {
				egen 		v`j'_tp`i' = rowmean(v`j'_tp`i'_x0 ///
								v`j'_tp`i'_x1 v`j'_tp`i'_x2 v`j'_tp`i'_x3 ///
								v`j'_tp`i'_x4 v`j'_tp`i'_x5 v`j'_tp`i'_x6 ///
								v`j'_tp`i'_x7 v`j'_tp`i'_x8 v`j'_tp`i'_x9)  
		}
	}		
/*		
* generate averages across country and year for rainfall variables 1-9
	forval j = 1/9 {
	    forval i = 1/6 {
				egen 		avg_v0`j'_rf`i' = mean(v0`j'_rf`i'), by(country year)
		}
	}	

* generate averages across extractions for rainfall variables 10-14
	forval j = 10/14 {
	    forval i = 1/6 {
				egen 		avg_v`j'_rf`i' = mean(v`j'_rf`i'), by(country year) 
		}
	}

* generate averages across extractions for temperature variables 15-22
	forval j = 15/22 {
	    forval i = 1/3 {
				egen 		avg_v`j'_tp`i' = mean(v`j'_tp`i'), by(country year)
		}
	}		
*/

* **********************************************************************
* 3 - generate total season distribution graphs by country
* **********************************************************************
/*
* total season rainfall - Ethiopia		
	twoway  (kdensity v05_rf1 if country == 1, color(gray%30) recast(area)) ///
			(kdensity v05_rf2 if country == 1, color(vermillion%30) recast(area)) ///
			(kdensity v05_rf3 if country == 1, color(sea%30) recast(area)) ///
			(kdensity v05_rf4 if country == 1, color(turquoise%30) recast(area)) ///
			(kdensity v05_rf5 if country == 1, color(reddish%30) recast(area)) ///
			(kdensity v05_rf6 if country == 1, color(ananas%30) recast(area) ///
			xtitle("Total Season Rainfall (mm)") xscale(r(0(1000)5000)) title("Ethiopia") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(2 "Rainfall 2") ///
			label(3 "Rainfall 3") label(4 "Rainfall 4") label(5 "Rainfall 5") ///
			label(6 "Rainfall 6")) saving("$xfig/eth_density_rf", replace)

* total season rainfall - Malawi		
	twoway  (kdensity v05_rf1 if country == 2, color(gray%30) recast(area)) ///
			(kdensity v05_rf2 if country == 2, color(vermillion%30) recast(area)) ///
			(kdensity v05_rf3 if country == 2, color(sea%30) recast(area)) ///
			(kdensity v05_rf4 if country == 2, color(turquoise%30) recast(area)) ///
			(kdensity v05_rf5 if country == 2, color(reddish%30) recast(area)) ///
			(kdensity v05_rf6 if country == 2, color(ananas%30) recast(area) ///
			xtitle("Total Season Rainfall (mm)") xscale(r(0(500)2500)) title("Malawi") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(2 "Rainfall 2") ///
			label(3 "Rainfall 3") label(4 "Rainfall 4") label(5 "Rainfall 5") ///
			label(6 "Rainfall 6")) saving("$xfig/mwi_density_rf", replace)

* total season rainfall - Niger		
	twoway  (kdensity v05_rf1 if country == 4, color(gray%30) recast(area)) ///
			(kdensity v05_rf2 if country == 4, color(vermillion%30) recast(area)) ///
			(kdensity v05_rf3 if country == 4, color(sea%30) recast(area)) ///
			(kdensity v05_rf4 if country == 4, color(turquoise%30) recast(area)) ///
			(kdensity v05_rf5 if country == 4, color(reddish%30) recast(area)) ///
			(kdensity v05_rf6 if country == 4, color(ananas%30) recast(area) ///
			xtitle("Total Season Rainfall (mm)") xscale(r(0(100)800)) title("Niger") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(2 "Rainfall 2") ///
			label(3 "Rainfall 3") label(4 "Rainfall 4") label(5 "Rainfall 5") ///
			label(6 "Rainfall 6")) saving("$xfig/ngr_density_rf", replace)
			
* total season rainfall - Nigeria		
	twoway  (kdensity v05_rf1 if country == 5, color(gray%30) recast(area)) ///
			(kdensity v05_rf2 if country == 5, color(vermillion%30) recast(area)) ///
			(kdensity v05_rf3 if country == 5, color(sea%30) recast(area)) ///
			(kdensity v05_rf4 if country == 5, color(turquoise%30) recast(area)) ///
			(kdensity v05_rf5 if country == 5, color(reddish%30) recast(area)) ///
			(kdensity v05_rf6 if country == 5, color(ananas%30) recast(area) ///
			xtitle("Total Season Rainfall (mm)") xscale(r(0(500)2500)) title("Nigeria") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(2 "Rainfall 2") ///
			label(3 "Rainfall 3") label(4 "Rainfall 4") label(5 "Rainfall 5") ///
			label(6 "Rainfall 6")) saving("$xfig/nga_density_rf", replace)

* total season rainfall - Tanzania		
	twoway  (kdensity v05_rf1 if country == 6, color(gray%30) recast(area)) ///
			(kdensity v05_rf2 if country == 6, color(vermillion%30) recast(area)) ///
			(kdensity v05_rf3 if country == 6, color(sea%30) recast(area)) ///
			(kdensity v05_rf4 if country == 6, color(turquoise%30) recast(area)) ///
			(kdensity v05_rf5 if country == 6, color(reddish%30) recast(area)) ///
			(kdensity v05_rf6 if country == 6, color(ananas%30) recast(area) ///
			xtitle("Total Season Rainfall (mm)") xscale(r(0(1000)7000)) title("Tanzania") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(2 "Rainfall 2") ///
			label(3 "Rainfall 3") label(4 "Rainfall 4") label(5 "Rainfall 5") ///
			label(6 "Rainfall 6")) saving("$xfig/tza_density_rf", replace)

* total season rainfall - Uganda		
	twoway  (kdensity v05_rf1 if country == 7, color(gray%30) recast(area)) ///
			(kdensity v05_rf2 if country == 7, color(vermillion%30) recast(area)) ///
			(kdensity v05_rf3 if country == 7, color(sea%30) recast(area)) ///
			(kdensity v05_rf4 if country == 7, color(turquoise%30) recast(area)) ///
			(kdensity v05_rf5 if country == 7, color(reddish%30) recast(area)) ///
			(kdensity v05_rf6 if country == 7, color(ananas%30) recast(area) ///
			xtitle("Total Season Rainfall (mm)") xscale(r(0(500)4000)) title("Uganda") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(2 "Rainfall 2") ///
			label(3 "Rainfall 3") label(4 "Rainfall 4") label(5 "Rainfall 5") ///
			label(6 "Rainfall 6")) saving("$xfig/uga_density_rf", replace)
			
	grc1leg2 		"$xfig/eth_density_rf.gph" "$xfig/mwi_density_rf.gph" ///
						"$xfig/ngr_density_rf.gph" "$xfig/nga_density_rf.gph" ///
						"$xfig/tza_density_rf.gph" "$xfig/uga_density_rf.gph", ///
						col(2) iscale(.5) commonscheme imargin(0 0 0 0)
						
	graph export "$xfig\density_rf.pdf", as(pdf) replace
	
	
* **********************************************************************
* 4 - generate mean temperature distribution graphs
* **********************************************************************

* mean temp - Ethiopia
	twoway	(kdensity v15_tp1 if country == 1, color(gray%30) recast(area)) ///
			(kdensity v15_tp2 if country == 1, color(vermillion%30) recast(area)) ///
			(kdensity v15_tp3 if country == 1, color(sea%30) recast(area) ///
			xtitle("Mean Seasonal Temperature (C)") xscale(r(10(5)35)) title("Ethiopia") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(2 "Temperature 2") ///
			label(3 "Temperature 3")) saving("$xfig/eth_density_tp", replace)
		
*Mean Temp - Malawi	
	twoway 	(kdensity v15_tp1 if country == 2, color(gray%30) recast(area)) ///
			(kdensity v15_tp2 if country == 2, color(vermillion%30) recast(area)) ///
			(kdensity v15_tp3 if country == 2, color(sea%30) recast(area) ///
			xtitle("Mean Seasonal Temperature (C)") xscale(r(10(5)35)) title("Malawi") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(2 "Temperature 2") ///
			label(3 "Temperature 3")) saving("$xfig/mwi_density_tp", replace)
		
*Mean Temp - Nigeria
	twoway 	(kdensity v15_tp1 if country == 5, color(gray%30) recast(area)) ///
			(kdensity v15_tp2 if country == 5, color(vermillion%30) recast(area)) ///
			(kdensity v15_tp3 if country == 5, color(sea%30) recast(area) ///
			xtitle("Mean Seasonal Temperature (C)") xscale(r(10(5)35)) title("Nigeria") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(2 "Temperature 2") ///
			label(3 "Temperature 3")) saving("$xfig/nga_density_tp", replace)

*Mean Temp - Tanzania
	twoway 	(kdensity v15_tp1 if country == 6, color(gray%30) recast(area)) ///
			(kdensity v15_tp2 if country == 6, color(vermillion%30) recast(area)) ///
			(kdensity v15_tp3 if country == 6, color(sea%30) recast(area) ///
			xtitle("Mean Seasonal Temperature (C)") xscale(r(10(5)35)) title("Tanzania") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(2 "Temperature 2") ///
			label(3 "Temperature 3")) saving("$xfig/tza_density_tp", replace)
		

	grc1leg2 		"$xfig/eth_density_tp.gph" "$xfig/mwi_density_tp.gph" ///
						"$xfig/nga_density_tp.gph" "$xfig/tza_density_tp.gph", ///
						col(2) iscale(.5) commonscheme imargin(0 0 0 0)
						
	graph export "$xfig\density_tp.pdf", as(pdf) replace	
*/	

* **********************************************************************
* 5 - generate total season distribution graphs by aez
* **********************************************************************

* total season rainfall - Tropic-warm/semiarid	
	twoway  (kdensity v05_rf1 if aez == 312, color(gray%30) recast(area)) ///
			(kdensity v05_rf2 if aez == 312, color(vermillion%30) recast(area)) ///
			(kdensity v05_rf3 if aez == 312, color(sea%30) recast(area)) ///
			(kdensity v05_rf4 if aez == 312, color(turquoise%30) recast(area)) ///
			(kdensity v05_rf5 if aez == 312, color(reddish%30) recast(area)) ///
			(kdensity v05_rf6 if aez == 312, color(ananas%30) recast(area) ///
			xtitle("") xscale(r(0(500)2000)) title("Tropic-warm/semiarid (n = 9,095)") ///
			ytitle("Density") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(2 "Rainfall 2") ///
			label(3 "Rainfall 3") label(4 "Rainfall 4") label(5 "Rainfall 5") ///
			label(6 "Rainfall 6")) saving("$xfig/twsa_density_rf", replace)

* total season rainfall - Tropic-warm/subhumid		
	twoway  (kdensity v05_rf1 if aez == 313, color(gray%30) recast(area)) ///
			(kdensity v05_rf2 if aez == 313, color(vermillion%30) recast(area)) ///
			(kdensity v05_rf3 if aez == 313, color(sea%30) recast(area)) ///
			(kdensity v05_rf4 if aez == 313, color(turquoise%30) recast(area)) ///
			(kdensity v05_rf5 if aez == 313, color(reddish%30) recast(area)) ///
			(kdensity v05_rf6 if aez == 313, color(ananas%30) recast(area) ///
			xtitle("") xscale(r(0(1000)4000)) title("Tropic-warm/subhumid (n = 9,009)") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(2 "Rainfall 2") ///
			label(3 "Rainfall 3") label(4 "Rainfall 4") label(5 "Rainfall 5") ///
			label(6 "Rainfall 6")) saving("$xfig/twsh_density_rf", replace)

* total season rainfall - Tropic-warm/humid		
	twoway  (kdensity v05_rf1 if aez == 314, color(gray%30) recast(area)) ///
			(kdensity v05_rf2 if aez == 314, color(vermillion%30) recast(area)) ///
			(kdensity v05_rf3 if aez == 314, color(sea%30) recast(area)) ///
			(kdensity v05_rf4 if aez == 314, color(turquoise%30) recast(area)) ///
			(kdensity v05_rf5 if aez == 314, color(reddish%30) recast(area)) ///
			(kdensity v05_rf6 if aez == 314, color(ananas%30) recast(area) ///
			xtitle("") xscale(r(0(1000)4000)) title("Tropic-warm/humid (n = 3,280)") ///
			ytitle("Density") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(2 "Rainfall 2") ///
			label(3 "Rainfall 3") label(4 "Rainfall 4") label(5 "Rainfall 5") ///
			label(6 "Rainfall 6")) saving("$xfig/twh_density_rf", replace)

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
			label(6 "Rainfall 6")) saving("$xfig/tcsa_density_rf", replace)

* total season rainfall - Tropic-cool/subhumid		
	twoway  (kdensity v05_rf1 if aez == 323, color(gray%30) recast(area)) ///
			(kdensity v05_rf2 if aez == 323, color(vermillion%30) recast(area)) ///
			(kdensity v05_rf3 if aez == 323, color(sea%30) recast(area)) ///
			(kdensity v05_rf4 if aez == 323, color(turquoise%30) recast(area)) ///
			(kdensity v05_rf5 if aez == 323, color(reddish%30) recast(area)) ///
			(kdensity v05_rf6 if aez == 323, color(ananas%30) recast(area) ///
			xtitle("Total Season Rainfall (mm)") xscale(r(0(1000)7000)) ///
			title("Tropic-cool/subhumid (n = 5,886)") ///
			ytitle("Density") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(2 "Rainfall 2") ///
			label(3 "Rainfall 3") label(4 "Rainfall 4") label(5 "Rainfall 5") ///
			label(6 "Rainfall 6")) saving("$xfig/tcsh_density_rf", replace)

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
			label(6 "Rainfall 6")) saving("$xfig/tch_density_rf", replace)			
			
	grc1leg2 		"$xfig/twsa_density_rf.gph" "$xfig/twsh_density_rf.gph" ///
						"$xfig/twh_density_rf.gph" "$xfig/tcsa_density_rf.gph" ///
						"$xfig/tcsh_density_rf.gph" "$xfig/tch_density_rf.gph", ///
						col(2) iscale(.5) commonscheme
						
	graph export "$xfig\density_aez_rf.pdf", as(pdf) replace

	
* **********************************************************************
* 6 - generate mean temperature distribution graphs
* **********************************************************************

* mean temp - Tropic-warm/semiarid
	twoway	(kdensity v15_tp1 if aez == 312, color(gray%30) recast(area)) ///
			(kdensity v15_tp2 if aez == 312, color(vermillion%30) recast(area)) ///
			(kdensity v15_tp3 if aez == 312, color(sea%30) recast(area) ///
			xtitle("") xscale(r(20(5)32)) title("Tropic-warm/semiarid (n = 9,095)") ///
			ytitle("Density") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(2 "Temperature 2") ///
			label(3 "Temperature 3")) saving("$xfig/twsa_density_tp", replace)

* mean temp - Tropic-warm/subhumid
	twoway	(kdensity v15_tp1 if aez == 313, color(gray%30) recast(area)) ///
			(kdensity v15_tp2 if aez == 313, color(vermillion%30) recast(area)) ///
			(kdensity v15_tp3 if aez == 313, color(sea%30) recast(area) ///
			xtitle("") xscale(r(15(5)30)) title("Tropic-warm/subhumid (n = 9,009)") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(2 "Temperature 2") ///
			label(3 "Temperature 3")) saving("$xfig/twsh_density_tp", replace)

* mean temp - Tropic-warm/humid
	twoway	(kdensity v15_tp1 if aez == 314, color(gray%30) recast(area)) ///
			(kdensity v15_tp2 if aez == 314, color(vermillion%30) recast(area)) ///
			(kdensity v15_tp3 if aez == 314, color(sea%30) recast(area) ///
			xtitle("") xscale(r(20(5)30)) title("Tropic-warm/humid (n = 3,280)") ///
			ytitle("Density") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(2 "Temperature 2") ///
			label(3 "Temperature 3")) saving("$xfig/twh_density_tp", replace)		

* mean temp - Tropic-cool/semiarid
	twoway	(kdensity v15_tp1 if aez == 322, color(gray%30) recast(area)) ///
			(kdensity v15_tp2 if aez == 322, color(vermillion%30) recast(area)) ///
			(kdensity v15_tp3 if aez == 322, color(sea%30) recast(area) ///
			xtitle("") xscale(r(15(5)30)) title("Tropic-cool/semiarid (n = 2,840)") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(2 "Temperature 2") ///
			label(3 "Temperature 3")) saving("$xfig/tcsa_density_tp", replace)

* mean temp - Tropic-cool/subhumid
	twoway	(kdensity v15_tp1 if aez == 323, color(gray%30) recast(area)) ///
			(kdensity v15_tp2 if aez == 323, color(vermillion%30) recast(area)) ///
			(kdensity v15_tp3 if aez == 323, color(sea%30) recast(area) ///
			xtitle("Mean Seasonal Temperature (C)") xscale(r(10(5)30)) ///
			title("Tropic-cool/subhumid (n = 5,886)") ///
			ytitle("Density") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(2 "Temperature 2") ///
			label(3 "Temperature 3")) saving("$xfig/tcsh_density_tp", replace)

* mean temp - Tropic-cool/humid
	twoway	(kdensity v15_tp1 if aez == 324, color(gray%30) recast(area)) ///
			(kdensity v15_tp2 if aez == 324, color(vermillion%30) recast(area)) ///
			(kdensity v15_tp3 if aez == 324, color(sea%30) recast(area) ///
			xtitle("Mean Seasonal Temperature (C)") xscale(r(16(2)26)) ///
			title("Tropic-cool/humid (n = 2,960)") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(2 "Temperature 2") ///
			label(3 "Temperature 3")) saving("$xfig/tch_density_tp", replace)				
		
		
	grc1leg2 		"$xfig/twsa_density_tp.gph" "$xfig/twsh_density_tp.gph" ///
						"$xfig/twh_density_tp.gph" "$xfig/tcsa_density_tp.gph" ///
						"$xfig/tcsh_density_tp.gph" "$xfig/tch_density_tp.gph", ///
						col(2) iscale(.5) commonscheme
						
	graph export "$xfig\density_aez_tp.pdf", as(pdf) replace
	

* **********************************************************************
* 7 - generate days without rain line graphs by aez
* **********************************************************************

* days without rain - Tropic-warm/semiarid	
	twoway  (fpfitci v10_rf1 year if aez == 312, color(gray%30) ) ///
			(fpfitci v10_rf2 year if aez == 312, color(vermillion%30) ) ///
			(fpfitci v10_rf3 year if aez == 312, color(sea%30) ) ///
			(fpfitci v10_rf4 year if aez == 312, color(turquoise%30) ) ///
			(fpfitci v10_rf5 year if aez == 312, color(reddish%30) ) ///
			(fpfitci v10_rf6 year if aez == 312, color(ananas%30)  ///
			xtitle("") xscale(r(2008(1)2015)) title("Tropic-warm/semiarid (n = 9,095)") ///
			ytitle("Days without Rain") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(3 "Rainfall 2") ///
			label(5 "Rainfall 3") label(7 "Rainfall 4") label(9 "Rainfall 5") ///
			label(11 "Rainfall 6") order(1 3 5 7 9 11)) saving("$xfig/twsa_norain_rf", replace)

* days without rain - Tropic-warm/subhumid	
	twoway  (fpfitci v10_rf1 year if aez == 313, color(gray%30) ) ///
			(fpfitci v10_rf2 year if aez == 313, color(vermillion%30) ) ///
			(fpfitci v10_rf3 year if aez == 313, color(sea%30) ) ///
			(fpfitci v10_rf4 year if aez == 313, color(turquoise%30) ) ///
			(fpfitci v10_rf5 year if aez == 313, color(reddish%30) ) ///
			(fpfitci v10_rf6 year if aez == 313, color(ananas%30)  ///
			xtitle("") xscale(r(2008(1)2015)) title("Tropic-warm/subhumid (n = 9,009)") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(3 "Rainfall 2") ///
			label(5 "Rainfall 3") label(7 "Rainfall 4") label(9 "Rainfall 5") ///
			label(11 "Rainfall 6") order(1 3 5 7 9 11)) saving("$xfig/twsh_norain_rf", replace)
			
* days without rain - Tropic-warm/humid	
	twoway  (fpfitci v10_rf1 year if aez == 314, color(gray%30) ) ///
			(fpfitci v10_rf2 year if aez == 314, color(vermillion%30) ) ///
			(fpfitci v10_rf3 year if aez == 314, color(sea%30) ) ///
			(fpfitci v10_rf4 year if aez == 314, color(turquoise%30) ) ///
			(fpfitci v10_rf5 year if aez == 314, color(reddish%30) ) ///
			(fpfitci v10_rf6 year if aez == 314, color(ananas%30)  ///
			xtitle("") xscale(r(2008(1)2015)) title("Tropic-warm/humid (n = 3,280)") ///
			ytitle("Days without Rain") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(3 "Rainfall 2") ///
			label(5 "Rainfall 3") label(7 "Rainfall 4") label(9 "Rainfall 5") ///
			label(11 "Rainfall 6") order(1 3 5 7 9 11)) saving("$xfig/twh_norain_rf", replace)

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
			label(11 "Rainfall 6") order(1 3 5 7 9 11)) saving("$xfig/tcsa_norain_rf", replace)

* days without rain - Tropic-cool/subhumid	
	twoway  (fpfitci v10_rf1 year if aez == 323, color(gray%30) ) ///
			(fpfitci v10_rf2 year if aez == 323, color(vermillion%30) ) ///
			(fpfitci v10_rf3 year if aez == 323, color(sea%30) ) ///
			(fpfitci v10_rf4 year if aez == 323, color(turquoise%30) ) ///
			(fpfitci v10_rf5 year if aez == 323, color(reddish%30) ) ///
			(fpfitci v10_rf6 year if aez == 323, color(ananas%30)  ///
			xtitle("Year") xscale(r(2008(1)2015)) title("Tropic-cool/subhumid (n = 5,886)") ///
			ytitle("Days without Rain") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(3 "Rainfall 2") ///
			label(5 "Rainfall 3") label(7 "Rainfall 4") label(9 "Rainfall 5") ///
			label(11 "Rainfall 6") order(1 3 5 7 9 11)) saving("$xfig/tcsh_norain_rf", replace)
			
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
			label(11 "Rainfall 6") order(1 3 5 7 9 11)) saving("$xfig/tch_norain_rf", replace)				
		
		
	grc1leg2 		"$xfig/twsa_norain_rf.gph" "$xfig/twsh_norain_rf.gph" ///
						"$xfig/twh_norain_rf.gph" "$xfig/tcsa_norain_rf.gph" ///
						"$xfig/tcsh_norain_rf.gph" "$xfig/tch_norain_rf.gph", ///
						col(2) iscale(.5) commonscheme
						
	graph export "$xfig\norain_aez_rf.pdf", as(pdf) replace	
			

* **********************************************************************
* 8 - generate GDD line graphs by aez
* **********************************************************************

* growing degree days - Tropic-warm/semiarid
	twoway	(fpfitci v19_tp1 year if aez == 312, color(gray%30) ) ///
			(fpfitci v19_tp2 year if aez == 312, color(vermillion%30) ) ///
			(fpfitci v19_tp3 year if aez == 312, color(sea%30)  ///
			xtitle("") xscale(r(2008(1)2015)) title("Tropic-warm/semiarid (n = 9,095)") ///
			ytitle("Growing degree days") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(3 "Temperature 2") ///
			label(5 "Temperature 3") order(1 3 5)) saving("$xfig/twsa_gdd_tp", replace)

* growing degree days - Tropic-warm/subhumid
	twoway	(fpfitci v19_tp1 year if aez == 313, color(gray%30) ) ///
			(fpfitci v19_tp2 year if aez == 313, color(vermillion%30) ) ///
			(fpfitci v19_tp3 year if aez == 313, color(sea%30)  ///
			xtitle("") xscale(r(2008(1)2015)) title("Tropic-warm/subhumid (n = 9,009)") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(3 "Temperature 2") ///
			label(5 "Temperature 3") order(1 3 5)) saving("$xfig/twsh_gdd_tp", replace)

* growing degree days - Tropic-warm/humid
	twoway	(fpfitci v19_tp1 year if aez == 314, color(gray%30) ) ///
			(fpfitci v19_tp2 year if aez == 314, color(vermillion%30) ) ///
			(fpfitci v19_tp3 year if aez == 314, color(sea%30) ///
			xtitle("") xscale(r(2008(1)2015)) title("Tropic-warm/humid (n = 3,280)") ///
			ytitle("Growing degree days") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(3 "Temperature 2") ///
			label(5 "Temperature 3") order(1 3 5)) saving("$xfig/twh_gdd_tp", replace)		

* growing degree days - Tropic-cool/semiarid
	twoway	(fpfitci v19_tp1 year if aez == 322, color(gray%30) ) ///
			(fpfitci v19_tp2 year if aez == 322, color(vermillion%30) ) ///
			(fpfitci v19_tp3 year if aez == 322, color(sea%30)  ///
			xtitle("") xscale(r(2008(1)2015)) title("Tropic-cool/semiarid (n = 2,840)") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(3 "Temperature 2") ///
			label(5 "Temperature 3") order(1 3 5)) saving("$xfig/tcsa_gdd_tp", replace)

* growing degree days - Tropic-cool/subhumid
	twoway	(fpfitci v19_tp1 year if aez == 323, color(gray%30) ) ///
			(fpfitci v19_tp2 year if aez == 323, color(vermillion%30) ) ///
			(fpfitci v19_tp3 year if aez == 323, color(sea%30)  ///
			xtitle("Year") xscale(r(2008(1)2015)) title("Tropic-cool/subhumid (n = 5,886)") ///
			ytitle("Gorwing degree days") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(3 "Temperature 2") ///
			label(5 "Temperature 3") order(1 3 5)) saving("$xfig/tcsh_gdd_tp", replace)

* growing degree days - Tropic-cool/humid
	twoway	(fpfitci v19_tp1 year if aez == 324, color(gray%30) ) ///
			(fpfitci v19_tp2 year if aez == 324, color(vermillion%30) ) ///
			(fpfitci v19_tp3 year if aez == 324, color(sea%30)  ///
			xtitle("Year") xscale(r(2008(1)2015)) title("Tropic-cool/humid (n = 2,960)") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Temperature 1") label(3 "Temperature 2") ///
			label(5 "Temperature 3") order(1 3 5)) saving("$xfig/tch_gdd_tp", replace)				
			
	grc1leg2 		"$xfig/twsa_gdd_tp.gph" "$xfig/twsh_gdd_tp.gph" ///
						"$xfig/twh_gdd_tp.gph" "$xfig/tcsa_gdd_tp.gph" ///
						"$xfig/tcsh_gdd_tp.gph" "$xfig/tch_gdd_tp.gph", ///
						col(2) iscale(.5) commonscheme
						
	graph export "$xfig\gdd_aez_tp.pdf", as(pdf) replace			
			
			
* **********************************************************************
* 9 - end matter
* **********************************************************************

* close the log
	log	close

/* END */