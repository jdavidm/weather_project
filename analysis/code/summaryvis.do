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
	* xfill.ado

* TO DO:
	* all of it

* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		root 	= 	"$data/regression_data"
	loc		xtab 	= 	"$data/results_data/tables"
	loc 	xfig    =   "$data/results_data/figures"
	loc		logout 	= 	"$data/results_data/logs"

* open log	
	cap log close
	log 	using 		"`logout'/summaryvis", append

		
* **********************************************************************
* 1 - load data
* **********************************************************************

* load data 
	use 			"`root'/lsms_panel", clear

* **********************************************************************
* 2 
* **********************************************************************
replace mean_season = . if mean_season == 0

sort country sat year
egen avg_mean = mean(mean_season), by(country sat year)
egen avg_median = mean(median_season), by(country sat year)
egen avg_sd = mean(sd_season), by(country sat year)
egen avg_total = mean(total_season), by(country sat year)
egen avg_skew = mean(skew_season), by(country sat year)
egen avg_norain = mean(norain), by(country sat year)
egen avg_raindays = mean(raindays), by(country sat year)
egen avg_raindays_p = mean(raindays_percent), by(country sat year)
egen avg_dry = mean(dry), by(country sat year)

by country sat, sort: sum total_season

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
/*
*Total Season Rainfall - Ethiopia	
twoway (kdensity total_season if sat == 1 & country == 1, color(gray%30) recast(area)) ///
		(kdensity total_season if sat == 2 & country == 1, color(vermillion%30) recast(area)) ///
		(kdensity total_season if sat == 3 & country == 1, color(sea%30) recast(area)) ///
		(kdensity total_season if sat == 4 & country == 1, color(turquoise%30) recast(area)) ///
		(kdensity total_season if sat == 5 & country == 1, color(reddish%30) recast(area)) ///
		(kdensity total_season if sat == 6 & country == 1, color(ananas%30) recast(area) ///
		xtitle("Total Season Rainfall (mm)") xscale(r(0(1000)6000)) ytitle("") ylabel(, nogrid labsize(small)) ///
		xlabel(, nogrid labsize(small))), title("Distribution of Rainfall in Ethiopia by Satellite") ///
		legend(pos(6) col(3) label(1 "Rainfall 1") label(2 "Rainfall 2") label(3 "Rainfall 3") ///
		label(4 "Rainfall 4") label(5 "Rainfall 5") label(6 "Rainfall 6"))

		graph export "`all'\eth_density_rf.pdf", as(pdf) replace

*Total Season Rainfall - Malawi
twoway (kdensity total_season if sat == 1 & country == 2, color(gray%30) recast(area)) ///
		(kdensity total_season if sat == 2 & country == 2, color(vermillion%30) recast(area)) ///
		(kdensity total_season if sat == 3 & country == 2, color(sea%30) recast(area)) ///
		(kdensity total_season if sat == 4 & country == 2, color(turquoise%30) recast(area)) ///
		(kdensity total_season if sat == 5 & country == 2, color(reddish%30) recast(area)) ///
		(kdensity total_season if sat == 6 & country == 2, color(ananas%30) recast(area) ///
		xtitle("Total Season Rainfall (mm)") xscale(r(0(1000)6000)) ytitle("") ylabel(, nogrid labsize(small)) ///
		xlabel(, nogrid labsize(small))), title("Distribution of Rainfall in Malawi by Satellite") ///
		legend(pos(6) col(3) label(1 "Rainfall 1") label(2 "Rainfall 2") label(3 "Rainfall 3") ///
		label(4 "Rainfall 4") label(5 "Rainfall 5") label(6 "Rainfall 6"))

		graph export "`all'\mwi_density_rf.pdf", as(pdf) replace

*Total Season Rainfall - Nigeria
twoway (kdensity total_season if sat == 1 & country == 5, color(gray%30) recast(area)) ///
		(kdensity total_season if sat == 2 & country == 5, color(vermillion%30) recast(area)) ///
		(kdensity total_season if sat == 3 & country == 5, color(sea%30) recast(area)) ///
		(kdensity total_season if sat == 4 & country == 5, color(turquoise%30) recast(area)) ///
		(kdensity total_season if sat == 5 & country == 5, color(reddish%30) recast(area)) ///
		(kdensity total_season if sat == 6 & country == 5, color(ananas%30) recast(area) ///
		xtitle("Total Season Rainfall (mm)") xscale(r(0(1000)6000)) ytitle("") ylabel(, nogrid labsize(small)) ///
		xlabel(, nogrid labsize(small))), title("Distribution of Rainfall in Nigeria by Satellite") ///
		legend(pos(6) col(3) label(1 "Rainfall 1") label(2 "Rainfall 2") label(3 "Rainfall 3") ///
		label(4 "Rainfall 4") label(5 "Rainfall 5") label(6 "Rainfall 6"))

		graph export "`all'\nga_density_rf.pdf", as(pdf) replace
*/
*Total Season Rainfall - Tanzania
twoway (kdensity total_season if sat == 1 & country == 6, color(gray%30) recast(area)) ///
		(kdensity total_season if sat == 2 & country == 6, color(vermillion%30) recast(area)) ///
		(kdensity total_season if sat == 3 & country == 6, color(sea%30) recast(area)) ///
		(kdensity total_season if sat == 4 & country == 6, color(turquoise%30) recast(area)) ///
		(kdensity total_season if sat == 5 & country == 6, color(reddish%30) recast(area)) ///
		(kdensity total_season if sat == 6 & country == 6, color(ananas%30) recast(area) ///
		xtitle("Total Season Rainfall (mm)") xscale(r(0(1000)6000)) ytitle("") ylabel(, nogrid labsize(small)) ///
		xlabel(, nogrid labsize(small))), title("Distribution of Rainfall in Tanzania by Satellite") ///
		legend(pos(6) col(3) label(1 "Rainfall 1") label(2 "Rainfall 2") label(3 "Rainfall 3") ///
		label(4 "Rainfall 4") label(5 "Rainfall 5") label(6 "Rainfall 6"))

		graph export "`all'\tza_density_rf.pdf", as(pdf) replace
		
* **********************************************************************
* 3 - end matter
* **********************************************************************

* close the log
	log	close

/* END */