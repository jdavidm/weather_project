* Project: WB Weather
* Created on: September 2019
* Created by: jdm
* Edited by: jdm
* Last edit: 29 November 2020 
* Stata v.16.1 

* does
	* reads in results data set
	* makes visualziations of results 

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
	global	root 	= 	"$data/results_data"
	global	stab 	= 	"$data/results_data/tables"
	global	xtab 	= 	"$data/output/paper/tables"
	global	sfig	= 	"$data/results_data/figures"	
	global 	xfig    =   "$data/output/paper/figures"
	global	logout 	= 	"$data/results_data/logs"

* open log	
	cap log close
	log 	using 		"$logout/pval_vis", append

		
* **********************************************************************
* 1 - load data
* **********************************************************************

* load data 
	use 			"$root/lsms_complete_results", clear

* generate p-values
	gen 			p99 = 1 if pval <= 0.01
	replace 		p99 = 0 if pval > 0.01
	gen 			p95 = 1 if pval <= 0.05
	replace 		p95 = 0 if pval > 0.05
	gen 			p90 = 1 if pval <= 0.10
	replace 		p90 = 0 if pval > 0.10

	
* **********************************************************************
* 2 - generate p-value graphs by extraction
* **********************************************************************
						
* **********************************************************************
* 2a - generate p-value graphs by extraction across countries
* **********************************************************************

* p-value graph of rainfall by extraction method
preserve
	drop			if varname > 14
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(ext)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(ext) j(p)	
	
	sort 			ext p
	gen 			obs = _n
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	replace			obs = 1 + obs if obs > 23
	replace			obs = 1 + obs if obs > 27
	replace			obs = 1 + obs if obs > 31
	replace			obs = 1 + obs if obs > 35
	
	twoway			(bar mu obs if p == 90, color(emerald*1.5%60)) || ///
						(bar mu obs if p == 95, color(eltblue*1.5%60)) || ///
						(bar mu obs if p == 99, color(khaki*1.5%60)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Rainfall") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 40) ex) ///
						xlabel(2 "Extraction 1 " 6 "Extraction 2 " 10 "Extraction 3 " ///
						14 "Extraction 4 " 18 "Extraction 5 " 22 "Extraction 6 " ///
						26 "Extraction 7 " 30 "Extraction 8 " 34 "Extraction 9 " ///
						38 "Extraction 10 ", angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I."))  ///
						saving("$sfig/pval_ext_rf", replace)
restore

* p-value graph of temperature by extraction method
preserve
	drop			if varname < 15
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(ext)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(ext) j(p)	
	
	sort 			ext p
	gen 			obs = _n
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	replace			obs = 1 + obs if obs > 23
	replace			obs = 1 + obs if obs > 27
	replace			obs = 1 + obs if obs > 31
	replace			obs = 1 + obs if obs > 35
	
	twoway			(bar mu obs if p == 90, color(maroon*1.5%60)) || ///
						(bar mu obs if p == 95, color(lavender*1.5%60)) || ///
						(bar mu obs if p == 99, color(brown*1.5%60)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Temperature") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 40) ex) ///
						xlabel(2 "Extraction 1 " 6 "Extraction 2 " 10 "Extraction 3 " ///
						14 "Extraction 4 " 18 "Extraction 5 " 22 "Extraction 6 " ///
						26 "Extraction 7 " 30 "Extraction 8 " 34 "Extraction 9 " ///
						38 "Extraction 10 ", angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I."))  ///
						saving("$sfig/pval_ext_tp", replace)
restore
					

	grc1leg2 		"$sfig/pval_ext_rf.gph" "$sfig/pval_ext_tp.gph", ///
						col(1) iscale(.5) pos(12) commonscheme imargin(0 0 0 0)
						
	graph export 	"$xfig/pval_ext.png", width(1400) replace		
			
				
* **********************************************************************
* 2b - generate p-value graphs by extraction and country
* **********************************************************************
	
* p-value graph of rainfall by extraction method
preserve
	drop			if varname > 14
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(ext country)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(country ext) j(p)	
	
	sort 			country ext p
					
* generate count variable that repeats by country	
	bys country (ext): gen obs = _n
/*
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	replace			obs = 1 + obs if obs > 23
	replace			obs = 1 + obs if obs > 27
	replace			obs = 1 + obs if obs > 31
	replace			obs = 1 + obs if obs > 35
*/
* ethiopia
	sum			 	hi if country == 1 & p == 95 & ext == 1
	global			bmax = r(max)
	
	sum			 	lo if country == 1 & p == 95 & ext == 1
	global			bmin = r(min)

	twoway			(bar mu obs if p == 95 & country == 1, color(eltblue*1.5%60)) || ///
						(rcap hi lo obs if country == 1 & p == 95, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Ethiopia") ///
						ytitle("Share of Significant Point Estimates") ///
						lcolor(black) xscale(r(0 30) ex) ///
						yline($bmax, lcolor(maroon) lstyle(solid) ) ///
						yline($bmin, lcolor(maroon)  lstyle(solid) ) ///
						xlabel(2 "Extraction 1 " 5 "Extraction 2 " 8 "Extraction 3 " ///
						11 "Extraction 4 " 14 "Extraction 5 " 17 "Extraction 6 " ///
						20 "Extraction 7 " 23 "Extraction 8 " 26 "Extraction 9 " ///
						29 "Extraction 10 ", angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2) label(1 "p>0.95") ///
						label(2 "95% C.I.")) ///
						saving("$sfig/eth_pval_ext_rf", replace)

* malawi
	sum			 	hi if country == 2 & p == 95 & ext == 1
	global			bmax = r(max)
	
	sum			 	lo if country == 2 & p == 95 & ext == 1
	global			bmin = r(min)
	
	twoway			(bar mu obs if p == 95 & country == 2, color(eltblue*1.5%60)) || ///
						(rcap hi lo obs if country == 2 & p == 95, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Malawi") ///
						lcolor(black) xscale(r(0 30) ex) ///
						yline($bmax, lcolor(maroon) lstyle(solid) ) ///
						yline($bmin, lcolor(maroon)  lstyle(solid) ) ///
						xlabel(2 "Extraction 1 " 5 "Extraction 2 " 8 "Extraction 3 " ///
						11 "Extraction 4 " 14 "Extraction 5 " 17 "Extraction 6 " ///
						20 "Extraction 7 " 23 "Extraction 8 " 26 "Extraction 9 " ///
						29 "Extraction 10 ", angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2) label(1 "p>0.95") ///
						label(2 "95% C.I.")) ///
						saving("$sfig/mwi_pval_ext_rf", replace)

* niger
	sum			 	hi if country == 4 & p == 95 & ext == 1
	global			bmax = r(max)
	
	sum			 	lo if country == 4 & p == 95 & ext == 1
	global			bmin = r(min)
	
	twoway			(bar mu obs if p == 95 & country == 4, color(eltblue*1.5%60)) || ///
						(rcap hi lo obs if country == 4 & p == 95, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Niger") ///
						lcolor(black) xscale(r(0 30) ex) ///
						yline($bmax, lcolor(maroon) lstyle(solid) ) ///
						yline($bmin, lcolor(maroon)  lstyle(solid) ) ///
						xlabel(2 "Extraction 1 " 5 "Extraction 2 " 8 "Extraction 3 " ///
						11 "Extraction 4 " 14 "Extraction 5 " 17 "Extraction 6 " ///
						20 "Extraction 7 " 23 "Extraction 8 " 26 "Extraction 9 " ///
						29 "Extraction 10 ", angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2) label(1 "p>0.95") ///
						label(2 "95% C.I.")) ///
						saving("$sfig/ngr_pval_ext_rf", replace)

* nigeria
	sum			 	hi if country == 5 & p == 95 & ext == 1
	global			bmax = r(max)
	
	sum			 	lo if country == 5 & p == 95 & ext == 1
	global			bmin = r(min)
	
	twoway			(bar mu obs if p == 95 & country == 5, color(eltblue*1.5%60)) || ///
						(rcap hi lo obs if country == 5 & p == 95, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Nigeria") ///
						ytitle("Share of Significant Point Estimates") ///
						lcolor(black) xscale(r(0 30) ex) ///
						yline($bmax, lcolor(maroon) lstyle(solid) ) ///
						yline($bmin, lcolor(maroon)  lstyle(solid) ) ///
						xlabel(2 "Extraction 1 " 5 "Extraction 2 " 8 "Extraction 3 " ///
						11 "Extraction 4 " 14 "Extraction 5 " 17 "Extraction 6 " ///
						20 "Extraction 7 " 23 "Extraction 8 " 26 "Extraction 9 " ///
						29 "Extraction 10 ", angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2) label(1 "p>0.95") ///
						label(2 "95% C.I.")) ///
						saving("$sfig/nga_pval_ext_rf", replace)
						
* tanzania
	sum			 	hi if country == 6 & p == 95 & ext == 1
	global			bmax = r(max)
	
	sum			 	lo if country == 6 & p == 95 & ext == 1
	global			bmin = r(min)
	
	twoway			(bar mu obs if p == 95 & country == 6, color(eltblue*1.5%60)) || ///
						(rcap hi lo obs if country == 6 & p == 95, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Tanzania") ///
						lcolor(black) xscale(r(0 30) ex) ///
						yline($bmax, lcolor(maroon) lstyle(solid) ) ///
						yline($bmin, lcolor(maroon)  lstyle(solid) ) ///
						xlabel(2 "Extraction 1 " 5 "Extraction 2 " 8 "Extraction 3 " ///
						11 "Extraction 4 " 14 "Extraction 5 " 17 "Extraction 6 " ///
						20 "Extraction 7 " 23 "Extraction 8 " 26 "Extraction 9 " ///
						29 "Extraction 10 ", angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2) label(1 "p>0.95") ///
						label(2 "95% C.I.")) ///
						saving("$sfig/tza_pval_ext_rf", replace)
						
* uganda
	sum			 	hi if country == 7 & p == 95 & ext == 1
	global			bmax = r(max)
	
	sum			 	lo if country == 7 & p == 95 & ext == 1
	global			bmin = r(min)
	
	twoway			(bar mu obs if p == 95 & country == 7, color(eltblue*1.5%60)) || ///
						(rcap hi lo obs if country == 7 & p == 95, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Uganda") ///
						lcolor(black) xscale(r(0 30) ex) ///
						yline($bmax, lcolor(maroon) lstyle(solid) ) ///
						yline($bmin, lcolor(maroon)  lstyle(solid) ) ///
						xlabel(2 "Extraction 1 " 5 "Extraction 2 " 8 "Extraction 3 " ///
						11 "Extraction 4 " 14 "Extraction 5 " 17 "Extraction 6 " ///
						20 "Extraction 7 " 23 "Extraction 8 " 26 "Extraction 9 " ///
						29 "Extraction 10 ", angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2) label(1 "p>0.95") ///
						label(2 "95% C.I.")) ///
						saving("$sfig/uga_pval_ext_rf", replace)
restore


* p-value graph of temperature by extraction method
preserve
	drop			if varname < 15
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(ext country)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(country ext) j(p)	
	
	sort 			country ext p
					
* generate count variable that repeats by country	
	bys country (ext): gen obs = _n
/*
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	replace			obs = 1 + obs if obs > 23
	replace			obs = 1 + obs if obs > 27
	replace			obs = 1 + obs if obs > 31
	replace			obs = 1 + obs if obs > 35
*/
* ethiopia
	sum			 	hi if country == 1 & p == 95 & ext == 1
	global			bmax = r(max)
	
	sum			 	lo if country == 1 & p == 95 & ext == 1
	global			bmin = r(min)
	
	twoway			(bar mu obs if p == 95 & country == 1, color(lavender*1.5%60)) || ///
						(rcap hi lo obs if country == 1 & p == 95, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Ethiopia") ///
						ytitle("Share of Significant Point Estimates") ///
						lcolor(black) xscale(r(0 30) ex) ///
						yline($bmax, lcolor(maroon) lstyle(solid) ) ///
						yline($bmin, lcolor(maroon)  lstyle(solid) ) ///
						xlabel(2 "Extraction 1 " 5 "Extraction 2 " 8 "Extraction 3 " ///
						11 "Extraction 4 " 14 "Extraction 5 " 17 "Extraction 6 " ///
						20 "Extraction 7 " 23 "Extraction 8 " 26 "Extraction 9 " ///
						29 "Extraction 10 ", angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2) label(1 "p>0.95") ///
						label(2 "95% C.I.")) ///
						saving("$sfig/eth_pval_ext_tp", replace)

* malawi
	sum			 	hi if country == 2 & p == 95 & ext == 1
	global			bmax = r(max)
	
	sum			 	lo if country == 2 & p == 95 & ext == 1
	global			bmin = r(min)
	
	twoway			(bar mu obs if p == 95 & country == 2, color(lavender*1.5%60)) || ///
						(rcap hi lo obs if country == 2 & p == 95, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Malawi") ///
						lcolor(black) xscale(r(0 30) ex) ///
						yline($bmax, lcolor(maroon) lstyle(solid) ) ///
						yline($bmin, lcolor(maroon)  lstyle(solid) ) ///
						xlabel(2 "Extraction 1 " 5 "Extraction 2 " 8 "Extraction 3 " ///
						11 "Extraction 4 " 14 "Extraction 5 " 17 "Extraction 6 " ///
						20 "Extraction 7 " 23 "Extraction 8 " 26 "Extraction 9 " ///
						29 "Extraction 10 ", angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2) label(1 "p>0.95") ///
						label(2 "95% C.I.")) ///
						saving("$sfig/mwi_pval_ext_tp", replace)

* niger
	sum			 	hi if country == 4 & p == 95 & ext == 1
	global			bmax = r(max)
	
	sum			 	lo if country == 4 & p == 95 & ext == 1
	global			bmin = r(min)
	
	twoway			(bar mu obs if p == 95 & country == 4, color(lavender*1.5%60)) || ///
						(rcap hi lo obs if country == 4 & p == 95, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Niger") ///
						lcolor(black) xscale(r(0 30) ex) ///
						yline($bmax, lcolor(maroon) lstyle(solid) ) ///
						yline($bmin, lcolor(maroon)  lstyle(solid) ) ///
						xlabel(2 "Extraction 1 " 5 "Extraction 2 " 8 "Extraction 3 " ///
						11 "Extraction 4 " 14 "Extraction 5 " 17 "Extraction 6 " ///
						20 "Extraction 7 " 23 "Extraction 8 " 26 "Extraction 9 " ///
						29 "Extraction 10 ", angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2) label(1 "p>0.95") ///
						label(2 "95% C.I.")) ///
						saving("$sfig/ngr_pval_ext_tp", replace)

* nigeria
	sum			 	hi if country == 5 & p == 95 & ext == 1
	global			bmax = r(max)
	
	sum			 	lo if country == 5 & p == 95 & ext == 1
	global			bmin = r(min)
	
	twoway			(bar mu obs if p == 95 & country == 5, color(lavender*1.5%60)) || ///
						(rcap hi lo obs if country == 5 & p == 95, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Nigeria") ///
						ytitle("Share of Significant Point Estimates") ///
						lcolor(black) xscale(r(0 30) ex) ///
						yline($bmax, lcolor(maroon) lstyle(solid) ) ///
						yline($bmin, lcolor(maroon)  lstyle(solid) ) ///
						xlabel(2 "Extraction 1 " 5 "Extraction 2 " 8 "Extraction 3 " ///
						11 "Extraction 4 " 14 "Extraction 5 " 17 "Extraction 6 " ///
						20 "Extraction 7 " 23 "Extraction 8 " 26 "Extraction 9 " ///
						29 "Extraction 10 ", angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2) label(1 "p>0.95") ///
						label(2 "95% C.I.")) ///
						saving("$sfig/nga_pval_ext_tp", replace)
						
* tanzania
	sum			 	hi if country == 6 & p == 95 & ext == 1
	global			bmax = r(max)
	
	sum			 	lo if country == 6 & p == 95 & ext == 1
	global			bmin = r(min)
	
	twoway			(bar mu obs if p == 95 & country == 6, color(lavender*1.5%60)) || ///
						(rcap hi lo obs if country == 6 & p == 95, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Tanzania") ///
						lcolor(black) xscale(r(0 30) ex) ///
						yline($bmax, lcolor(maroon) lstyle(solid) ) ///
						yline($bmin, lcolor(maroon)  lstyle(solid) ) ///
						xlabel(2 "Extraction 1 " 5 "Extraction 2 " 8 "Extraction 3 " ///
						11 "Extraction 4 " 14 "Extraction 5 " 17 "Extraction 6 " ///
						20 "Extraction 7 " 23 "Extraction 8 " 26 "Extraction 9 " ///
						29 "Extraction 10 ", angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2) label(1 "p>0.95") ///
						label(2 "95% C.I.")) ///
						saving("$sfig/tza_pval_ext_tp", replace)
						
* uganda
	sum			 	hi if country == 7 & p == 95 & ext == 1
	global			bmax = r(max)
	
	sum			 	lo if country == 7 & p == 95 & ext == 1
	global			bmin = r(min)
	
	twoway			(bar mu obs if p == 95 & country == 7, color(lavender*1.5%60)) || ///
						(rcap hi lo obs if country == 7 & p == 95, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Uganda") ///
						lcolor(black) xscale(r(0 30) ex) ///
						yline($bmax, lcolor(maroon) lstyle(solid) ) ///
						yline($bmin, lcolor(maroon)  lstyle(solid) ) ///
						xlabel(2 "Extraction 1 " 5 "Extraction 2 " 8 "Extraction 3 " ///
						11 "Extraction 4 " 14 "Extraction 5 " 17 "Extraction 6 " ///
						20 "Extraction 7 " 23 "Extraction 8 " 26 "Extraction 9 " ///
						29 "Extraction 10 ", angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2) label(1 "p>0.95") ///
						label(2 "95% C.I.")) ///
						saving("$sfig/uga_pval_ext_tp", replace)
restore
						
* p-value extraction method for rainfall
	grc1leg2 		"$sfig/eth_pval_ext_rf.gph" "$sfig/mwi_pval_ext_rf.gph" ///
						"$sfig/ngr_pval_ext_rf.gph" "$sfig/nga_pval_ext_rf.gph" ///
						"$sfig/tza_pval_ext_rf.gph" "$sfig/uga_pval_ext_rf.gph", ///
						col(3) iscale(.5) pos(12) commonscheme imargin(0 0 0 0)
						
	graph export 	"$xfig\pval_ext_rf.png", width(1400) replace
	
* p-value extraction method for temperature
	grc1leg2 		"$sfig/eth_pval_ext_tp.gph" "$sfig/mwi_pval_ext_tp.gph" ///
						"$sfig/ngr_pval_ext_tp.gph" "$sfig/nga_pval_ext_tp.gph" ///
						"$sfig/tza_pval_ext_tp.gph" "$sfig/uga_pval_ext_tp.gph", ///
						col(3) iscale(.5) pos(12) commonscheme imargin(0 0 0 0)
						
	graph export 	"$xfig\pval_ext_tp.png", width(1400) replace					



* **********************************************************************
* 3 - generate random number to select extraction method
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

	
* **********************************************************************
* 4 - generate p-value graphs by weather metric
* **********************************************************************
		
* keep extraction 3	
	keep			if ext == 3

* **********************************************************************
* 4a - generate p-value graphs by weather metric across countries
* **********************************************************************

* p-value graph of rainfall by varname
preserve
	keep			if varname < 15
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(varname)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(varname) j(p)	
	
	sort 			varname p
	gen 			obs = _n
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	replace			obs = 1 + obs if obs > 23
	replace			obs = 1 + obs if obs > 27
	replace			obs = 1 + obs if obs > 31
	replace			obs = 1 + obs if obs > 35
	replace			obs = 1 + obs if obs > 39
	replace			obs = 1 + obs if obs > 43
	replace			obs = 1 + obs if obs > 47
	replace			obs = 1 + obs if obs > 51
	
	twoway			(bar mu obs if p == 90, color(emerald*1.5%60)) || ///
						(bar mu obs if p == 95, color(eltblue*1.5%60)) || ///
						(bar mu obs if p == 99, color(khaki*1.5%60)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Rainfall") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 24) ex) ///
						xlabel(2 "Mean Daily Rain " 6 "Median Daily Rain " ///
						10 "Variance of Daily Rain " 14 "Skew of Daily Rain " ///
						18 "Total Seasonal Rain " 22 "Dev. in Total Rain " ///
						26 "z-Score of Total Rain " 30 "Rainy Days " ///
						34 "Dev. in Rainy Days " 38 "No Rain Days " ///
						42 "Dev. in No Rain Days " 46 "% Rainy Days " ///
						50 "Dev. in % Rainy Days " 54 "Longest Dry Spell ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I."))  ///
						saving("$sfig/pval_varname_rf", replace)
						
	*graph export 	"$sfig/pval_varname_rf.pdf", as(pdf) replace
restore
	
* p-value graph of temperature by varname
preserve
	keep			if varname > 14
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(varname)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(varname) j(p)	
	
	sort 			varname p
	gen 			obs = _n
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	replace			obs = 1 + obs if obs > 23
	replace			obs = 1 + obs if obs > 27
	
	twoway			(bar mu obs if p == 90, color(maroon*1.5%60)) || ///
						(bar mu obs if p == 95, color(lavender*1.5%60)) || ///
						(bar mu obs if p == 99, color(brown*1.5%60)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Temperature") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 24) ex) ///
						xlabel(2 "Mean Daily Temp " 6 "Median Daily Temp " ///
						10 "Variance of Daily Temp " 14 "Skew of Daily Temp " ///
						18 "Growing Degree Days " 22 "Dev. in GDD " ///
						26 "z-Score of GDD " 30 "Max Daily Temp ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I."))  ///
						saving("$sfig/pval_varname_tp", replace)
						
	graph export 	"$sfig/pval_varname_tp.pdf", as(pdf) replace
restore


	grc1leg2 		"$sfig/pval_varname_rf.gph" "$sfig/pval_varname_tp.gph", ///
						col(1) iscale(.5) pos(12) commonscheme imargin(0 0 0 0)
						
	graph export 	"$xfig\pval_varname.png", width(1400) replace							


* **********************************************************************
* 4b - generate p-value graphs by rainfall metric and country
* **********************************************************************

* ethiopia rainfall	
preserve
	keep			if varname < 15
	keep			if country == 1
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(varname)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(varname) j(p)	
	
	sort 			varname p
	gen 			obs = _n
/*
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	replace			obs = 1 + obs if obs > 23
	replace			obs = 1 + obs if obs > 27
	replace			obs = 1 + obs if obs > 31
	replace			obs = 1 + obs if obs > 35
	replace			obs = 1 + obs if obs > 39
	replace			obs = 1 + obs if obs > 43
	replace			obs = 1 + obs if obs > 47
	replace			obs = 1 + obs if obs > 51
*/	
	sum			 	hi if p == 95 & varname == 1
	global			bmax = r(max)
	
	sum			 	lo if p == 95 & varname == 1
	global			bmin = r(min)
	
	twoway			(bar mu obs if p == 95, color(eltblue*1.5%60)) || ///
						(rcap hi lo obs if p == 95, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Ethiopia") ///
						ytitle("Share of Significant Point Estimates") ///
						yline($bmax, lcolor(maroon) lstyle(solid) ) ///
						yline($bmin, lcolor(maroon)  lstyle(solid) ) ///
						lcolor(black) xscale(r(0 42) ex) ///
						xlabel(2 "Mean Daily Rain " 5 "Median Daily Rain " ///
						8 "Variance of Daily Rain " 11 "Skew of Daily Rain " ///
						14 "Total Seasonal Rain " 17 "Dev. in Total Rain " ///
						20 "z-Score of Total Rain " 23 "Rainy Days " ///
						26 "Dev. in Rainy Days " 29 "No Rain Days " ///
						32 "Dev. in No Rain Days " 35 "% Rainy Days " ///
						38 "Dev. in % Rainy Days " 41 "Longest Dry Spell ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2) label(1 "p>0.95") ///
						label(2 "95% C.I."))  ///
						saving("$sfig/eth_pval_varname_rf", replace)
						
	*graph export 	"$sfig/eth_pval_varname_rf.pdf", as(pdf) replace
restore	
	

* malawi rainfall	
preserve
	keep			if varname < 15
	keep			if country == 2
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(varname)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(varname) j(p)	
	
	sort 			varname p
	gen 			obs = _n
/*
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	replace			obs = 1 + obs if obs > 23
	replace			obs = 1 + obs if obs > 27
	replace			obs = 1 + obs if obs > 31
	replace			obs = 1 + obs if obs > 35
	replace			obs = 1 + obs if obs > 39
	replace			obs = 1 + obs if obs > 43
	replace			obs = 1 + obs if obs > 47
	replace			obs = 1 + obs if obs > 51
*/	
	sum			 	hi if p == 95 & varname == 1
	global			bmax = r(max)
	
	sum			 	lo if p == 95 & varname == 1
	global			bmin = r(min)
	
	twoway			(bar mu obs if p == 95, color(eltblue*1.5%60)) || ///
						(rcap hi lo obs if p == 95, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Malawi") ///
						yline($bmax, lcolor(maroon) lstyle(solid) ) ///
						yline($bmin, lcolor(maroon)  lstyle(solid) ) ///
						lcolor(black) xscale(r(0 42) ex) ///
						xlabel(2 "Mean Daily Rain " 5 "Median Daily Rain " ///
						8 "Variance of Daily Rain " 11 "Skew of Daily Rain " ///
						14 "Total Seasonal Rain " 17 "Dev. in Total Rain " ///
						20 "z-Score of Total Rain " 23 "Rainy Days " ///
						26 "Dev. in Rainy Days " 29 "No Rain Days " ///
						32 "Dev. in No Rain Days " 35 "% Rainy Days " ///
						38 "Dev. in % Rainy Days " 41 "Longest Dry Spell ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2) label(1 "p>0.95") ///
						label(2 "95% C.I."))  ///
						saving("$sfig/mwi_pval_varname_rf", replace)
						
	*graph export 	"$sfig/mwi_pval_varname_rf.pdf", as(pdf) replace
restore	
	

* niger rainfall	
preserve
	keep			if varname < 15
	keep			if country == 4
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(varname)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(varname) j(p)	
	
	sort 			varname p
	gen 			obs = _n
/*
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	replace			obs = 1 + obs if obs > 23
	replace			obs = 1 + obs if obs > 27
	replace			obs = 1 + obs if obs > 31
	replace			obs = 1 + obs if obs > 35
	replace			obs = 1 + obs if obs > 39
	replace			obs = 1 + obs if obs > 43
	replace			obs = 1 + obs if obs > 47
	replace			obs = 1 + obs if obs > 51
*/	
	sum			 	hi if p == 95 & varname == 1
	global			bmax = r(max)
	
	sum			 	lo if p == 95 & varname == 1
	global			bmin = r(min)
	
	twoway			(bar mu obs if p == 95, color(eltblue*1.5%60)) || ///
						(rcap hi lo obs if p == 95, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Niger") ///
						yline($bmax, lcolor(maroon) lstyle(solid) ) ///
						yline($bmin, lcolor(maroon)  lstyle(solid) ) ///
						lcolor(black) xscale(r(0 42) ex) ///
						xlabel(2 "Mean Daily Rain " 5 "Median Daily Rain " ///
						8 "Variance of Daily Rain " 11 "Skew of Daily Rain " ///
						14 "Total Seasonal Rain " 17 "Dev. in Total Rain " ///
						20 "z-Score of Total Rain " 23 "Rainy Days " ///
						26 "Dev. in Rainy Days " 29 "No Rain Days " ///
						32 "Dev. in No Rain Days " 35 "% Rainy Days " ///
						38 "Dev. in % Rainy Days " 41 "Longest Dry Spell ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2) label(1 "p>0.95") ///
						label(2 "95% C.I."))  ///
						saving("$sfig/ngr_pval_varname_rf", replace)
						
	*graph export 	"$sfig/ngr_pval_varname_rf.pdf", as(pdf) replace
restore	
	

* nigeria rainfall	
preserve
	keep			if varname < 15
	keep			if country == 5
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(varname)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(varname) j(p)	
	
	sort 			varname p
	gen 			obs = _n
/*
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	replace			obs = 1 + obs if obs > 23
	replace			obs = 1 + obs if obs > 27
	replace			obs = 1 + obs if obs > 31
	replace			obs = 1 + obs if obs > 35
	replace			obs = 1 + obs if obs > 39
	replace			obs = 1 + obs if obs > 43
	replace			obs = 1 + obs if obs > 47
	replace			obs = 1 + obs if obs > 51
*/	
	sum			 	hi if p == 95 & varname == 1
	global			bmax = r(max)
	
	sum			 	lo if p == 95 & varname == 1
	global			bmin = r(min)
	
	twoway			(bar mu obs if p == 95, color(eltblue*1.5%60)) || ///
						(rcap hi lo obs if p == 95, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Nigeria") ///
						ytitle("Share of Significant Point Estimates") ///
						yline($bmax, lcolor(maroon) lstyle(solid) ) ///
						yline($bmin, lcolor(maroon)  lstyle(solid) ) ///
						lcolor(black) xscale(r(0 42) ex) ///
						xlabel(2 "Mean Daily Rain " 5 "Median Daily Rain " ///
						8 "Variance of Daily Rain " 11 "Skew of Daily Rain " ///
						14 "Total Seasonal Rain " 17 "Dev. in Total Rain " ///
						20 "z-Score of Total Rain " 23 "Rainy Days " ///
						26 "Dev. in Rainy Days " 29 "No Rain Days " ///
						32 "Dev. in No Rain Days " 35 "% Rainy Days " ///
						38 "Dev. in % Rainy Days " 41 "Longest Dry Spell ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2) label(1 "p>0.95") ///
						label(2 "95% C.I."))  ///
						saving("$sfig/nga_pval_varname_rf", replace)
						
	*graph export 	"$sfig/nga_pval_varname_rf.pdf", as(pdf) replace
restore	
	

* tanzania rainfall	
preserve
	keep			if varname < 15
	keep			if country == 6
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(varname)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(varname) j(p)	
	
	sort 			varname p
	gen 			obs = _n
/*
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	replace			obs = 1 + obs if obs > 23
	replace			obs = 1 + obs if obs > 27
	replace			obs = 1 + obs if obs > 31
	replace			obs = 1 + obs if obs > 35
	replace			obs = 1 + obs if obs > 39
	replace			obs = 1 + obs if obs > 43
	replace			obs = 1 + obs if obs > 47
	replace			obs = 1 + obs if obs > 51
*/	
	sum			 	hi if p == 95 & varname == 1
	global			bmax = r(max)
	
	sum			 	lo if p == 95 & varname == 1
	global			bmin = r(min)
	
	twoway			(bar mu obs if p == 95, color(eltblue*1.5%60)) || ///
						(rcap hi lo obs if p == 95, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Tanzania") ///
						yline($bmax, lcolor(maroon) lstyle(solid) ) ///
						yline($bmin, lcolor(maroon)  lstyle(solid) ) ///
						lcolor(black) xscale(r(0 42) ex) ///
						xlabel(2 "Mean Daily Rain " 5 "Median Daily Rain " ///
						8 "Variance of Daily Rain " 11 "Skew of Daily Rain " ///
						14 "Total Seasonal Rain " 17 "Dev. in Total Rain " ///
						20 "z-Score of Total Rain " 23 "Rainy Days " ///
						26 "Dev. in Rainy Days " 29 "No Rain Days " ///
						32 "Dev. in No Rain Days " 35 "% Rainy Days " ///
						38 "Dev. in % Rainy Days " 41 "Longest Dry Spell ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2) label(1 "p>0.95") ///
						label(2 "95% C.I."))  ///
						saving("$sfig/tza_pval_varname_rf", replace)
						
	*graph export 	"$sfig/tza_pval_varname_rf.pdf", as(pdf) replace
restore	
	

* uganda rainfall	
preserve
	keep			if varname < 15
	keep			if country == 7
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(varname)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(varname) j(p)	
	
	sort 			varname p
	gen 			obs = _n
/*
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	replace			obs = 1 + obs if obs > 23
	replace			obs = 1 + obs if obs > 27
	replace			obs = 1 + obs if obs > 31
	replace			obs = 1 + obs if obs > 35
	replace			obs = 1 + obs if obs > 39
	replace			obs = 1 + obs if obs > 43
	replace			obs = 1 + obs if obs > 47
	replace			obs = 1 + obs if obs > 51
*/	
	sum			 	hi if p == 95 & varname == 1
	global			bmax = r(max)
	
	sum			 	lo if p == 95 & varname == 1
	global			bmin = r(min)
	
	twoway			(bar mu obs if p == 95, color(eltblue*1.5%60)) || ///
						(rcap hi lo obs if p == 95, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Uganda") ///
						yline($bmax, lcolor(maroon) lstyle(solid) ) ///
						yline($bmin, lcolor(maroon)  lstyle(solid) ) ///
						lcolor(black) xscale(r(0 42) ex) ///
						xlabel(2 "Mean Daily Rain " 5 "Median Daily Rain " ///
						8 "Variance of Daily Rain " 11 "Skew of Daily Rain " ///
						14 "Total Seasonal Rain " 17 "Dev. in Total Rain " ///
						20 "z-Score of Total Rain " 23 "Rainy Days " ///
						26 "Dev. in Rainy Days " 29 "No Rain Days " ///
						32 "Dev. in No Rain Days " 35 "% Rainy Days " ///
						38 "Dev. in % Rainy Days " 41 "Longest Dry Spell ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2) label(1 "p>0.95") ///
						label(2 "95% C.I."))  ///
						saving("$sfig/uga_pval_varname_rf", replace)
						
	*graph export 	"$sfig/uga_pval_varname_rf.pdf", as(pdf) replace
restore	

			
* p-value varname and country for rainfall
	grc1leg2 		"$sfig/eth_pval_varname_rf.gph" "$sfig/mwi_pval_varname_rf.gph" ///
						"$sfig/ngr_pval_varname_rf.gph" "$sfig/nga_pval_varname_rf.gph" ///
						"$sfig/tza_pval_varname_rf.gph" "$sfig/uga_pval_varname_rf.gph", ///
						col(3) iscale(.5) pos(12) commonscheme imargin(0 0 0 0)
						
	graph export 	"$xfig\pval_varname_rf.png", width(1400) replace

	
* **********************************************************************
* 4c - generate p-value graphs by temperature metric and country
* **********************************************************************

* ethiopia temperature
preserve
	keep			if varname > 14
	keep			if country == 1
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(varname)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(varname) j(p)	
	
	sort 			varname p
	gen 			obs = _n
/*
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	replace			obs = 1 + obs if obs > 23
	replace			obs = 1 + obs if obs > 27
*/	
	sum			 	hi if p == 95 & varname == 15
	global			bmax = r(max)
	
	sum			 	lo if p == 95 & varname == 15
	global			bmin = r(min)
	
	twoway			(bar mu obs if p == 95, color(lavender*1.5%60)) || ///
						(rcap hi lo obs if p == 95, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Ethiopia") ///
						ytitle("Share of Significant Point Estimates") ///
						yline($bmax, lcolor(maroon) lstyle(solid) ) ///
						yline($bmin, lcolor(maroon)  lstyle(solid) ) ///
						lcolor(black) xscale(r(0 24) ex) ///
						xlabel(2 "Mean Daily Temp " 5 "Median Daily Temp " ///
						8 "Variance of Daily Temp " 11 "Skew of Daily Temp " ///
						14 "Growing Degree Days " 17 "Dev. in GDD " ///
						20 "z-Score of GDD " 23 "Max Daily Temp ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2) label(1 "p>0.95") ///
						label(2 "95% C.I."))  ///
						saving("$sfig/eth_pval_varname_tp", replace)
						
	*graph export 	"$sfig/eth_pval_varname_tp.pdf", as(pdf) replace
restore


* malawi temperature
preserve
	keep			if varname > 14
	keep			if country == 2
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(varname)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(varname) j(p)	
	
	sort 			varname p
	gen 			obs = _n
/*
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	replace			obs = 1 + obs if obs > 23
	replace			obs = 1 + obs if obs > 27
*/	
	sum			 	hi if p == 95 & varname == 15
	global			bmax = r(max)
	
	sum			 	lo if p == 95 & varname == 15
	global			bmin = r(min)
	
	twoway			(bar mu obs if p == 95, color(lavender*1.5%60)) || ///
						(rcap hi lo obs if p == 95, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Malawi") ///
						yline($bmax, lcolor(maroon) lstyle(solid) ) ///
						yline($bmin, lcolor(maroon)  lstyle(solid) ) ///
						lcolor(black) xscale(r(0 24) ex) ///
						xlabel(2 "Mean Daily Temp " 5 "Median Daily Temp " ///
						8 "Variance of Daily Temp " 11 "Skew of Daily Temp " ///
						14 "Growing Degree Days " 17 "Dev. in GDD " ///
						20 "z-Score of GDD " 23 "Max Daily Temp ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2) label(1 "p>0.95") ///
						label(2 "95% C.I."))  ///
						saving("$sfig/mwi_pval_varname_tp", replace)
						
	*graph export 	"$sfig/mwi_pval_varname_tp.pdf", as(pdf) replace
restore


* niger temperature
preserve
	keep			if varname > 14
	keep			if country == 4
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(varname)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(varname) j(p)	
	
	sort 			varname p
	gen 			obs = _n
/*
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	replace			obs = 1 + obs if obs > 23
	replace			obs = 1 + obs if obs > 27
*/	
	sum			 	hi if p == 95 & varname == 15
	global			bmax = r(max)
	
	sum			 	lo if p == 95 & varname == 15
	global			bmin = r(min)
	
	twoway			(bar mu obs if p == 95, color(lavender*1.5%60)) || ///
						(rcap hi lo obs if p == 95, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Niger") ///
						yline($bmax, lcolor(maroon) lstyle(solid) ) ///
						yline($bmin, lcolor(maroon)  lstyle(solid) ) ///
						lcolor(black) xscale(r(0 24) ex) ///
						xlabel(2 "Mean Daily Temp " 5 "Median Daily Temp " ///
						8 "Variance of Daily Temp " 11 "Skew of Daily Temp " ///
						14 "Growing Degree Days " 17 "Dev. in GDD " ///
						20 "z-Score of GDD " 23 "Max Daily Temp ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2) label(1 "p>0.95") ///
						label(2 "95% C.I."))  ///
						saving("$sfig/ngr_pval_varname_tp", replace)
						
	*graph export 	"$sfig/ngr_pval_varname_tp.pdf", as(pdf) replace
restore


* nigeria temperature
preserve
	keep			if varname > 14
	keep			if country == 5
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(varname)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(varname) j(p)	
	
	sort 			varname p
	gen 			obs = _n
/*
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	replace			obs = 1 + obs if obs > 23
	replace			obs = 1 + obs if obs > 27
*/	
	sum			 	hi if p == 95 & varname == 15
	global			bmax = r(max)
	
	sum			 	lo if p == 95 & varname == 15
	global			bmin = r(min)
	
	twoway			(bar mu obs if p == 95, color(lavender*1.5%60)) || ///
						(rcap hi lo obs if p == 95, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Nigeria") ///
						ytitle("Share of Significant Point Estimates") ///
						yline($bmax, lcolor(maroon) lstyle(solid) ) ///
						yline($bmin, lcolor(maroon)  lstyle(solid) ) ///
						lcolor(black) xscale(r(0 24) ex) ///
						xlabel(2 "Mean Daily Temp " 5 "Median Daily Temp " ///
						8 "Variance of Daily Temp " 11 "Skew of Daily Temp " ///
						14 "Growing Degree Days " 17 "Dev. in GDD " ///
						20 "z-Score of GDD " 23 "Max Daily Temp ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2) label(1 "p>0.95") ///
						label(2 "95% C.I."))  ///
						saving("$sfig/nga_pval_varname_tp", replace)
						
	*graph export 	"$sfig/nga_pval_varname_tp.pdf", as(pdf) replace
restore


* tanzania temperature
preserve
	keep			if varname > 14
	keep			if country == 6
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(varname)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(varname) j(p)	
	
	sort 			varname p
	gen 			obs = _n
/*
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	replace			obs = 1 + obs if obs > 23
	replace			obs = 1 + obs if obs > 27
*/	
	sum			 	hi if p == 95 & varname == 15
	global			bmax = r(max)
	
	sum			 	lo if p == 95 & varname == 15
	global			bmin = r(min)
	
	twoway			(bar mu obs if p == 95, color(lavender*1.5%60)) || ///
						(rcap hi lo obs if p == 95, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Tanzania") ///
						yline($bmax, lcolor(maroon) lstyle(solid) ) ///
						yline($bmin, lcolor(maroon)  lstyle(solid) ) ///
						lcolor(black) xscale(r(0 24) ex) ///
						xlabel(2 "Mean Daily Temp " 5 "Median Daily Temp " ///
						8 "Variance of Daily Temp " 11 "Skew of Daily Temp " ///
						14 "Growing Degree Days " 17 "Dev. in GDD " ///
						20 "z-Score of GDD " 23 "Max Daily Temp ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2) label(1 "p>0.95") ///
						label(2 "95% C.I."))  ///
						saving("$sfig/tza_pval_varname_tp", replace)
						
	*graph export 	"$sfig/tza_pval_varname_tp.pdf", as(pdf) replace
restore


* uganda temperature
preserve
	keep			if varname > 14
	keep			if country == 7
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(varname)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(varname) j(p)	
	
	sort 			varname p
	gen 			obs = _n
/*
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	replace			obs = 1 + obs if obs > 23
	replace			obs = 1 + obs if obs > 27
*/	
	sum			 	hi if p == 95 & varname == 15
	global			bmax = r(max)
	
	sum			 	lo if p == 95 & varname == 15
	global			bmin = r(min)
	
	twoway			(bar mu obs if p == 95, color(lavender*1.5%60)) || ///
						(rcap hi lo obs if p == 95, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Uganda") ///
						yline($bmax, lcolor(maroon) lstyle(solid) ) ///
						yline($bmin, lcolor(maroon)  lstyle(solid) ) ///
						lcolor(black) xscale(r(0 24) ex) ///
						xlabel(2 "Mean Daily Temp " 5 "Median Daily Temp " ///
						8 "Variance of Daily Temp " 11 "Skew of Daily Temp " ///
						14 "Growing Degree Days " 17 "Dev. in GDD " ///
						20 "z-Score of GDD " 23 "Max Daily Temp ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2) label(1 "p>0.95") ///
						label(2 "95% C.I."))  ///
						saving("$sfig/uga_pval_varname_tp", replace)
						
	*graph export 	"$sfig/uga_pval_varname_tp.pdf", as(pdf) replace
restore

		
* p-value varname and country for temperature
	grc1leg2 		"$sfig/eth_pval_varname_tp.gph" "$sfig/mwi_pval_varname_tp.gph" ///
						"$sfig/ngr_pval_varname_tp.gph" "$sfig/nga_pval_varname_tp.gph" ///
						"$sfig/tza_pval_varname_tp.gph" "$sfig/uga_pval_varname_tp.gph", ///
						col(3) iscale(.5) pos(12) commonscheme imargin(0 0 0 0)
						
	graph export 	"$xfig\pval_varname_tp.png", width(1400) replace


* **********************************************************************
* 5 - select weather metrics to investigate
* **********************************************************************

* based on above analysis we will proceed with following rainfall metrics
	* mean rainfall (varname == 1)
	* total rainfall (varname == 5)
	* rainy days (varname == 8)
	* % rainy days (varname == 12)

* based on above analysis we will proceed with following temperature metrics
	* mean temperature (varname == 15)
	* median temperature (varname == 16)
	* variance temperature  (varname == 17)

	
* **********************************************************************
* 5a - generate p-value graphs by satellite
* **********************************************************************
				
* p-value graph of rainfall
preserve
	keep			if varname == 1 | varname == 5 | varname == 8 | ///
						varname == 12
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(sat)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(sat) j(p)	
	
	sort 			sat p
	gen 			obs = _n
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	
	twoway			(bar mu obs if p == 90, color(emerald*1.5%60)) || ///
						(bar mu obs if p == 95, color(eltblue*1.5%60)) || ///
						(bar mu obs if p == 99, color(khaki*1.5%60)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Rainfall") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 24) ex) ///
						xlabel(2 "Rainfall 1 " 6 "Rainfall 2 " ///
						10 "Rainfall 3 " 14 "Rainfall 4 " ///
						18 "Rainfall 5 " 22 "Rainfall 6 ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(4) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I.")) ///
						saving("$sfig/pval_rf", replace)
restore
		
			
* p-value graph of temperature
preserve
	keep			if varname == 16 | varname == 16 | varname == 17
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(sat)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(sat) j(p)	
	
	sort 			sat p
	gen 			obs = _n
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	
	twoway			(bar mu obs if p == 90, color(maroon*1.5%60)) || ///
						(bar mu obs if p == 95, color(lavender*1.5%60)) || ///
						(bar mu obs if p == 99, color(brown*1.5%60)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Temperature") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 12) ex) xlabel(2 "Temperature 1 " ///
						6 "Temperature 2 " 10 "Temperature 3 " , ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(4) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I.")) ///
						saving("$sfig/pval_tp", replace)
restore
			

* combine varname p-value graphs
	grc1leg2 		"$sfig/pval_rf.gph" "$sfig/pval_tp.gph", ///
						col(2) iscale(.5) pos(12) commonscheme
						
	graph export 	"$xfig\pval_sat.png", width(1400) replace

	
* p-value graph of mean daily rainfall
preserve
	keep			if varname == 1
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(sat)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(sat) j(p)	
	
	sort 			sat p
	gen 			obs = _n
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	
	twoway			(bar mu obs if p == 90, color(emerald*1.5%60)) || ///
						(bar mu obs if p == 95, color(eltblue*1.5%60)) || ///
						(bar mu obs if p == 99, color(khaki*1.5%60)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Mean Daily Rainfall") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 24) ex) ///
						xlabel(2 "Rainfall 1 " 6 "Rainfall 2 " ///
						10 "Rainfall 3 " 14 "Rainfall 4 " ///
						18 "Rainfall 5 " 22 "Rainfall 6 ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(4) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I."))  ///
						saving("$sfig/pval_v01", replace)
restore
							
* p-value graph of total seasonal rainfall
preserve
	keep			if varname == 5
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(sat)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(sat) j(p)	
	
	sort 			sat p
	gen 			obs = _n
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	
	twoway			(bar mu obs if p == 90, color(emerald*1.5%60)) || ///
						(bar mu obs if p == 95, color(eltblue*1.5%60)) || ///
						(bar mu obs if p == 99, color(khaki*1.5%60)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Total Seasonal Rainfall") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 24) ex) ///
						xlabel(2 "Rainfall 1 " 6 "Rainfall 2 " ///
						10 "Rainfall 3 " 14 "Rainfall 4 " ///
						18 "Rainfall 5 " 22 "Rainfall 6 ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(4) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I."))  ///
						saving("$sfig/pval_v05", replace)
restore
							
* p-value graph of number of rainy days
preserve
	keep			if varname == 8
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(sat)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(sat) j(p)	
	
	sort 			sat p
	gen 			obs = _n
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	
	twoway			(bar mu obs if p == 90, color(emerald*1.5%60)) || ///
						(bar mu obs if p == 95, color(eltblue*1.5%60)) || ///
						(bar mu obs if p == 99, color(khaki*1.5%60)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Number of Rainy Days") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 24) ex) ///
						xlabel(2 "Rainfall 1 " 6 "Rainfall 2 " ///
						10 "Rainfall 3 " 14 "Rainfall 4 " ///
						18 "Rainfall 5 " 22 "Rainfall 6 ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(4) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I."))  ///
						saving("$sfig/pval_v08", replace)
restore
						
* p-value graph of % of rainy days
preserve
	keep			if varname == 12
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(sat)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(sat) j(p)	
	
	sort 			sat p
	gen 			obs = _n
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	
	twoway			(bar mu obs if p == 90, color(emerald*1.5%60)) || ///
						(bar mu obs if p == 95, color(eltblue*1.5%60)) || ///
						(bar mu obs if p == 99, color(khaki*1.5%60)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("% Rainy Days") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 24) ex) ///
						xlabel(2 "Rainfall 1 " 6 "Rainfall 2 " ///
						10 "Rainfall 3 " 14 "Rainfall 4 " ///
						18 "Rainfall 5 " 22 "Rainfall 6 ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(4) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I."))  ///
						saving("$sfig/pval_v12", replace)
restore

* combine varname p-value graphs
	grc1leg2 		"$sfig/pval_v01.gph" "$sfig/pval_v05.gph"  ///
						"$sfig/pval_v08.gph" "$sfig/pval_v12.gph", ///
						col(2) iscale(.5) pos(12) commonscheme
						
	graph export 	"$xfig\pval_v_rf.png", width(1400) replace

						
* p-value graph of mean daily temp
preserve
	keep			if varname == 15
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(sat)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(sat) j(p)	
	
	sort 			sat p
	gen 			obs = _n
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	
	twoway			(bar mu obs if p == 90, color(maroon*1.5%60)) || ///
						(bar mu obs if p == 95, color(lavender*1.5%60)) || ///
						(bar mu obs if p == 99, color(brown*1.5%60)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Mean Daily Temperature") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 12) ex) xlabel(2 "Temperature 1 " ///
						6 "Temperature 2 " 10 "Temperature 3 " , ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(2) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I."))  ///
						saving("$sfig/pval_v15", replace)
restore
 		
* p-value graph of median daily temperature
preserve
	keep			if varname == 16
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(sat)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(sat) j(p)	
	
	sort 			sat p
	gen 			obs = _n
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	
	twoway			(bar mu obs if p == 90, color(maroon*1.5%60)) || ///
						(bar mu obs if p == 95, color(lavender*1.5%60)) || ///
						(bar mu obs if p == 99, color(brown*1.5%60)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Median Daily Temperature") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 12) ex) xlabel(2 "Temperature 1 " ///
						6 "Temperature 2 " 10 "Temperature 3 " , ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(2) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I."))  ///
						saving("$sfig/pval_v16", replace)
restore
 		
* p-value graph of variance daily temperature
preserve
	keep			if varname == 17
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(sat)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(sat) j(p)	
	
	sort 			sat p
	gen 			obs = _n
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	
	twoway			(bar mu obs if p == 90, color(maroon*1.5%60)) || ///
						(bar mu obs if p == 95, color(lavender*1.5%60)) || ///
						(bar mu obs if p == 99, color(brown*1.5%60)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Variance of Daily Temperature") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 12) ex) xlabel(2 "Temperature 1 " ///
						6 "Temperature 2 " 10 "Temperature 3 " , ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(2) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I."))  ///
						saving("$sfig/pval_v17", replace)
restore

* combine varname p-value graphs
	grc1leg2 		"$sfig/pval_v15.gph" "$sfig/pval_v16.gph" ///
						"$sfig/pval_v17.gph",  col(2) iscale(.5) ///
						ring(0) pos(5) holes(4) commonscheme
						
	graph export 	"$xfig\pval_v_tp.png", width(1400) replace
					
					
* **********************************************************************
* 5b - generate p-value graphs by satellite and country
* **********************************************************************
	
	
* **********************************************************************
* 4 - end matter
* **********************************************************************


* close the log
	log	close

/* END */		