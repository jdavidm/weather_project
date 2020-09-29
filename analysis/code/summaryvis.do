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
* 3 - generate total season distribution graphs
* **********************************************************************

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
			xtitle("Total Season Rainfall (mm)") xscale(r(0(1000)8000)) title("Tanzania") ///
			ytitle("") ylabel(, nogrid labsize(small)) xlabel(, nogrid labsize(small))), ///
			legend(pos(6) col(3) label(1 "Rainfall 1") label(2 "Rainfall 2") ///
			label(3 "Rainfall 3") label(4 "Rainfall 4") label(5 "Rainfall 5") ///
			label(6 "Rainfall 6")) saving("$xfig/tza_density_rf", replace)

	grc1leg2 		"$xfig/eth_density_rf.gph" "$xfig/mwi_density_rf.gph" ///
						"$xfig/nga_density_rf.gph" "$xfig/tza_density_rf.gph", ///
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
		
/*	
*No Rain - Ethiopia
twoway 	(line avg_norain year if sat == 1 & country == 1, color(gray) lpattern(solid)) ///
		(line avg_norain year if sat == 2 & country == 1, color(vermillion) lpattern(solid)) ///
		(line avg_norain year if sat == 3 & country == 1, color(sea) lpattern(solid)) ///
		(line avg_norain year if sat == 4 & country == 1, color(turquoise) lpattern(solid)) ///
		(line avg_norain year if sat == 5 & country == 1, color(reddish)lpattern(solid)) ///
		(line avg_norain year if sat == 6 & country == 1, color(ananas%30) lpattern(solid) ///
		xtitle("Year") xscale(r(1983(2)2016)) ///
		ytitle("Days") ylabel(, nogrid labsize(small)) ///
		xlabel(, nogrid labsize(small))), title("Days without Rain in Ethiopia by Satellite") ///
		legend(pos(6) col(3) label(1 "Rainfall 1") label(2 "Rainfall 2") label(3 "Rainfall 3") ///
		label(4 "Rainfall 4") label(5 "Rainfall 5") label(6 "Rainfall 6"))

		graph export "`all'/eth_norain.eps", as(eps) replace
		
*No Rain - Malawi
twoway 	(line avg_norain year if sat == 1 & country == 2, color(gray) lpattern(solid)) ///
		(line avg_norain year if sat == 2 & country == 2, color(vermillion) lpattern(solid)) ///
		(line avg_norain year if sat == 3 & country == 2, color(sea) lpattern(solid)) ///
		(line avg_norain year if sat == 4 & country == 2, color(turquoise) lpattern(solid)) ///
		(line avg_norain year if sat == 5 & country == 2, color(reddish)lpattern(solid)) ///
		(line avg_norain year if sat == 6 & country == 2, color(ananas%30) lpattern(solid) ///
		xtitle("Year") xscale(r(1983(2)2016)) ///
		ytitle("Days") ylabel(, nogrid labsize(small)) ///
		xlabel(, nogrid labsize(small))), title("Days without Rain in Malawi by Satellite") ///
		legend(pos(6) col(3) label(1 "Rainfall 1") label(2 "Rainfall 2") label(3 "Rainfall 3") ///
		label(4 "Rainfall 4") label(5 "Rainfall 5") label(6 "Rainfall 6"))

		graph export "`all'/mwi_norain.eps", as(eps) replace
		
*No Rain - Nigeria
twoway 	(line avg_norain year if sat == 1 & country == 5, color(gray) lpattern(solid)) ///
		(line avg_norain year if sat == 2 & country == 5, color(vermillion) lpattern(solid)) ///
		(line avg_norain year if sat == 3 & country == 5, color(sea) lpattern(solid)) ///
		(line avg_norain year if sat == 4 & country == 5, color(turquoise) lpattern(solid)) ///
		(line avg_norain year if sat == 5 & country == 5, color(reddish)lpattern(solid)) ///
		(line avg_norain year if sat == 6 & country == 5, color(ananas%30) lpattern(solid) ///
		xtitle("Year") xscale(r(1983(2)2016)) ///
		ytitle("Days") ylabel(, nogrid labsize(small)) ///
		xlabel(, nogrid labsize(small))), title("Days without Rain in Nigeria by Satellite") ///
		legend(pos(6) col(3) label(1 "Rainfall 1") label(2 "Rainfall 2") label(3 "Rainfall 3") ///
		label(4 "Rainfall 4") label(5 "Rainfall 5") label(6 "Rainfall 6"))

		graph export "`all'/nga_norain.eps", as(eps) replace

*No Rain - Tanzania
twoway 	(line avg_norain year if sat == 1 & country == 6, color(gray) lpattern(solid)) ///
		(line avg_norain year if sat == 2 & country == 6, color(vermillion) lpattern(solid)) ///
		(line avg_norain year if sat == 3 & country == 6, color(sea) lpattern(solid)) ///
		(line avg_norain year if sat == 4 & country == 6, color(turquoise) lpattern(solid)) ///
		(line avg_norain year if sat == 5 & country == 6, color(reddish)lpattern(solid)) ///
		(line avg_norain year if sat == 6 & country == 6, color(ananas%30) lpattern(solid) ///
		xtitle("Year") xscale(r(1983(2)2016)) ///
		ytitle("Days") ylabel(, nogrid labsize(small)) ///
		xlabel(, nogrid labsize(small))), title("Days without Rain in Tanzania by Satellite") ///
		legend(pos(6) col(3) label(1 "Rainfall 1") label(2 "Rainfall 2") label(3 "Rainfall 3") ///
		label(4 "Rainfall 4") label(5 "Rainfall 5") label(6 "Rainfall 6"))

		graph export "`all'/tza_norain.eps", as(eps) replace
	
* **********************************************************************
* 3 - end matter
* **********************************************************************

* close the log
	log	close

/* END */