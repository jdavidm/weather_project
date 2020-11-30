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
/*
	
* **********************************************************************
* 2 - generate p-value graphs by extraction
* **********************************************************************
						
* **********************************************************************
* 2a - generate p-value graphs by extraction
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
	
	twoway			(bar mu obs if p == 90, color(emerald*1.5)) || ///
						(bar mu obs if p == 95, color(eltblue*1.5)) || ///
						(bar mu obs if p == 99, color(khaki*1.5)) || ///
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
	
	twoway			(bar mu obs if p == 90, color(maroon*1.5)) || ///
						(bar mu obs if p == 95, color(lavender*1.5)) || ///
						(bar mu obs if p == 99, color(brown*1.5)) || ///
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
						
	graph export 	"$xfig\pval_ext.png", width(1400) replace		
				
				
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

	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	replace			obs = 1 + obs if obs > 23
	replace			obs = 1 + obs if obs > 27
	replace			obs = 1 + obs if obs > 31
	replace			obs = 1 + obs if obs > 35

* ethiopia
	twoway			(bar mu obs if p == 90 & country == 1, color(emerald*1.5)) || ///
						(bar mu obs if p == 95 & country == 1, color(eltblue*1.5)) || ///
						(bar mu obs if p == 99 & country == 1, color(khaki*1.5)) || ///
						(rcap hi lo obs if country == 1, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Ethiopia") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 40) ex) ///
						xlabel(2 "Extraction 1 " 6 "Extraction 2 " 10 "Extraction 3 " ///
						14 "Extraction 4 " 18 "Extraction 5 " 22 "Extraction 6 " ///
						26 "Extraction 7 " 30 "Extraction 8 " 34 "Extraction 9 " ///
						38 "Extraction 10 ", angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I.")) ///
						saving("$sfig/eth_pval_ext_rf", replace)

* malawi
	twoway			(bar mu obs if p == 90 & country == 2, color(emerald*1.5)) || ///
						(bar mu obs if p == 95 & country == 2, color(eltblue*1.5)) || ///
						(bar mu obs if p == 99 & country == 2, color(khaki*1.5)) || ///
						(rcap hi lo obs if country == 2, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Malawi") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 40) ex) ///
						xlabel(2 "Extraction 1 " 6 "Extraction 2 " 10 "Extraction 3 " ///
						14 "Extraction 4 " 18 "Extraction 5 " 22 "Extraction 6 " ///
						26 "Extraction 7 " 30 "Extraction 8 " 34 "Extraction 9 " ///
						38 "Extraction 10 ", angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I.")) ///
						saving("$sfig/mwi_pval_ext_rf", replace)

* niger
	twoway			(bar mu obs if p == 90 & country == 4, color(emerald*1.5)) || ///
						(bar mu obs if p == 95 & country == 4, color(eltblue*1.5)) || ///
						(bar mu obs if p == 99 & country == 4, color(khaki*1.5)) || ///
						(rcap hi lo obs if country == 4, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Niger") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 40) ex) ///
						xlabel(2 "Extraction 1 " 6 "Extraction 2 " 10 "Extraction 3 " ///
						14 "Extraction 4 " 18 "Extraction 5 " 22 "Extraction 6 " ///
						26 "Extraction 7 " 30 "Extraction 8 " 34 "Extraction 9 " ///
						38 "Extraction 10 ", angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I.")) ///
						saving("$sfig/ngr_pval_ext_rf", replace)

* nigeria
	twoway			(bar mu obs if p == 90 & country == 5, color(emerald*1.5)) || ///
						(bar mu obs if p == 95 & country == 5, color(eltblue*1.5)) || ///
						(bar mu obs if p == 99 & country == 5, color(khaki*1.5)) || ///
						(rcap hi lo obs if country == 5, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Nigeria") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 40) ex) ///
						xlabel(2 "Extraction 1 " 6 "Extraction 2 " 10 "Extraction 3 " ///
						14 "Extraction 4 " 18 "Extraction 5 " 22 "Extraction 6 " ///
						26 "Extraction 7 " 30 "Extraction 8 " 34 "Extraction 9 " ///
						38 "Extraction 10 ", angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I.")) ///
						saving("$sfig/nga_pval_ext_rf", replace)
						
* tanzania
	twoway			(bar mu obs if p == 90 & country == 6, color(emerald*1.5)) || ///
						(bar mu obs if p == 95 & country == 6, color(eltblue*1.5)) || ///
						(bar mu obs if p == 99 & country == 6, color(khaki*1.5)) || ///
						(rcap hi lo obs if country == 6, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Tanzania") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 40) ex) ///
						xlabel(2 "Extraction 1 " 6 "Extraction 2 " 10 "Extraction 3 " ///
						14 "Extraction 4 " 18 "Extraction 5 " 22 "Extraction 6 " ///
						26 "Extraction 7 " 30 "Extraction 8 " 34 "Extraction 9 " ///
						38 "Extraction 10 ", angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I.")) ///
						saving("$sfig/tza_pval_ext_rf", replace)
						
* uganda
	twoway			(bar mu obs if p == 90 & country == 7, color(emerald*1.5)) || ///
						(bar mu obs if p == 95 & country == 7, color(eltblue*1.5)) || ///
						(bar mu obs if p == 99 & country == 7, color(khaki*1.5)) || ///
						(rcap hi lo obs if country == 7, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Uganda") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 40) ex) ///
						xlabel(2 "Extraction 1 " 6 "Extraction 2 " 10 "Extraction 3 " ///
						14 "Extraction 4 " 18 "Extraction 5 " 22 "Extraction 6 " ///
						26 "Extraction 7 " 30 "Extraction 8 " 34 "Extraction 9 " ///
						38 "Extraction 10 ", angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I.")) ///
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

	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	replace			obs = 1 + obs if obs > 23
	replace			obs = 1 + obs if obs > 27
	replace			obs = 1 + obs if obs > 31
	replace			obs = 1 + obs if obs > 35

* ethiopia
	twoway			(bar mu obs if p == 90 & country == 1, color(maroon*1.5)) || ///
						(bar mu obs if p == 95 & country == 1, color(lavender*1.5)) || ///
						(bar mu obs if p == 99 & country == 1, color(brown*1.5)) || ///
						(rcap hi lo obs if country == 1, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Ethiopia") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 40) ex) ///
						xlabel(2 "Extraction 1 " 6 "Extraction 2 " 10 "Extraction 3 " ///
						14 "Extraction 4 " 18 "Extraction 5 " 22 "Extraction 6 " ///
						26 "Extraction 7 " 30 "Extraction 8 " 34 "Extraction 9 " ///
						38 "Extraction 10 ", angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I.")) ///
						saving("$sfig/eth_pval_ext_tp", replace)

* malawi
	twoway			(bar mu obs if p == 90 & country == 2, color(maroon*1.5)) || ///
						(bar mu obs if p == 95 & country == 2, color(lavender*1.5)) || ///
						(bar mu obs if p == 99 & country == 2, color(brown*1.5)) || ///
						(rcap hi lo obs if country == 2, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Malawi") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 40) ex) ///
						xlabel(2 "Extraction 1 " 6 "Extraction 2 " 10 "Extraction 3 " ///
						14 "Extraction 4 " 18 "Extraction 5 " 22 "Extraction 6 " ///
						26 "Extraction 7 " 30 "Extraction 8 " 34 "Extraction 9 " ///
						38 "Extraction 10 ", angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I.")) ///
						saving("$sfig/mwi_pval_ext_tp", replace)

* niger
	twoway			(bar mu obs if p == 90 & country == 4, color(maroon*1.5)) || ///
						(bar mu obs if p == 95 & country == 4, color(lavender*1.5)) || ///
						(bar mu obs if p == 99 & country == 4, color(brown*1.5)) || ///
						(rcap hi lo obs if country == 4, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Niger") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 40) ex) ///
						xlabel(2 "Extraction 1 " 6 "Extraction 2 " 10 "Extraction 3 " ///
						14 "Extraction 4 " 18 "Extraction 5 " 22 "Extraction 6 " ///
						26 "Extraction 7 " 30 "Extraction 8 " 34 "Extraction 9 " ///
						38 "Extraction 10 ", angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I.")) ///
						saving("$sfig/ngr_pval_ext_tp", replace)

* nigeria
	twoway			(bar mu obs if p == 90 & country == 5, color(maroon*1.5)) || ///
						(bar mu obs if p == 95 & country == 5, color(lavender*1.5)) || ///
						(bar mu obs if p == 99 & country == 5, color(brown*1.5)) || ///
						(rcap hi lo obs if country == 5, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Nigeria") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 40) ex) ///
						xlabel(2 "Extraction 1 " 6 "Extraction 2 " 10 "Extraction 3 " ///
						14 "Extraction 4 " 18 "Extraction 5 " 22 "Extraction 6 " ///
						26 "Extraction 7 " 30 "Extraction 8 " 34 "Extraction 9 " ///
						38 "Extraction 10 ", angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I.")) ///
						saving("$sfig/nga_pval_ext_tp", replace)
						
* tanzania
	twoway			(bar mu obs if p == 90 & country == 6, color(maroon*1.5)) || ///
						(bar mu obs if p == 95 & country == 6, color(lavender*1.5)) || ///
						(bar mu obs if p == 99 & country == 6, color(brown*1.5)) || ///
						(rcap hi lo obs if country == 6, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Tanzania") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 40) ex) ///
						xlabel(2 "Extraction 1 " 6 "Extraction 2 " 10 "Extraction 3 " ///
						14 "Extraction 4 " 18 "Extraction 5 " 22 "Extraction 6 " ///
						26 "Extraction 7 " 30 "Extraction 8 " 34 "Extraction 9 " ///
						38 "Extraction 10 ", angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I.")) ///
						saving("$sfig/tza_pval_ext_tp", replace)
						
* uganda
	twoway			(bar mu obs if p == 90 & country == 7, color(maroon*1.5)) || ///
						(bar mu obs if p == 95 & country == 7, color(lavender*1.5)) || ///
						(bar mu obs if p == 99 & country == 7, color(brown*1.5)) || ///
						(rcap hi lo obs if country == 7, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Uganda") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 40) ex) ///
						xlabel(2 "Extraction 1 " 6 "Extraction 2 " 10 "Extraction 3 " ///
						14 "Extraction 4 " 18 "Extraction 5 " 22 "Extraction 6 " ///
						26 "Extraction 7 " 30 "Extraction 8 " 34 "Extraction 9 " ///
						38 "Extraction 10 ", angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I.")) ///
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
*/
	

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
* 4 - generate p-value graphs by weather metrics
* **********************************************************************
		
* keep extraction 3	
	keep			if ext == 3

* **********************************************************************
* 4a - generate p-value graphs by weather metric
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
	
	twoway			(bar mu obs if p == 90, color(emerald*1.5)) || ///
						(bar mu obs if p == 95, color(eltblue*1.5)) || ///
						(bar mu obs if p == 99, color(khaki*1.5)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Rainfall") ///
						ytitle("Share of Significant Point Estimates") ///
						yline(.61860621, lcolor(maroon) lstyle(solid) ) ///
						yline(.52491236, lcolor(maroon)  lstyle(solid) ) ///
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
						
	graph export 	"$sfig/pval_varname_rf.pdf", as(pdf) replace
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
	
	twoway			(bar mu obs if p == 90, color(maroon*1.5)) || ///
						(bar mu obs if p == 95, color(lavender*1.5)) || ///
						(bar mu obs if p == 99, color(brown*1.5)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Temperature") ///
						ytitle("Share of Significant Point Estimates") ///
						yline(.68560618, lcolor(maroon) lstyle(solid) ) ///
						yline(.55513459, lcolor(maroon)  lstyle(solid) ) ///
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
						col(1) iscale(.5) commonscheme imargin(0 0 0 0)
						
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
	
	twoway			(bar mu obs if p == 90, color(emerald*1.5)) || ///
						(bar mu obs if p == 95, color(eltblue*1.5)) || ///
						(bar mu obs if p == 99, color(khaki*1.5)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Ethiopia") ///
						ytitle("Share of Significant Point Estimates") ///
						yline(.73956168, lcolor(maroon) lstyle(solid) ) ///
						yline(.51043832, lcolor(maroon)  lstyle(solid) ) ///
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
						saving("$sfig/eth_pval_varname_rf", replace)
						
	graph export 	"$sfig/eth_pval_varname_rf.pdf", as(pdf) replace
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
	
	twoway			(bar mu obs if p == 90, color(emerald*1.5)) || ///
						(bar mu obs if p == 95, color(eltblue*1.5)) || ///
						(bar mu obs if p == 99, color(khaki*1.5)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Malawi") ///
						ytitle("Share of Significant Point Estimates") ///
						yline(.77821869, lcolor(maroon) lstyle(solid) ) ///
						yline(.55511469, lcolor(maroon)  lstyle(solid) ) ///
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
						saving("$sfig/mwi_pval_varname_rf", replace)
						
	graph export 	"$sfig/mwi_pval_varname_rf.pdf", as(pdf) replace
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
	
	twoway			(bar mu obs if p == 90, color(emerald*1.5)) || ///
						(bar mu obs if p == 95, color(eltblue*1.5)) || ///
						(bar mu obs if p == 99, color(khaki*1.5)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Niger") ///
						ytitle("Share of Significant Point Estimates") ///
						yline(.72647142, lcolor(maroon) lstyle(solid) ) ///
						yline(.49575076, lcolor(maroon)  lstyle(solid) ) ///
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
						saving("$sfig/ngr_pval_varname_rf", replace)
						
	graph export 	"$sfig/ngr_pval_varname_rf.pdf", as(pdf) replace
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
	
	twoway			(bar mu obs if p == 90, color(emerald*1.5)) || ///
						(bar mu obs if p == 95, color(eltblue*1.5)) || ///
						(bar mu obs if p == 99, color(khaki*1.5)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Nigeria") ///
						ytitle("Share of Significant Point Estimates") ///
						yline(.69999719, lcolor(maroon) lstyle(solid) ) ///
						yline(.46666944, lcolor(maroon)  lstyle(solid) ) ///
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
						saving("$sfig/nga_pval_varname_rf", replace)
						
	graph export 	"$sfig/nga_pval_varname_rf.pdf", as(pdf) replace
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
	
	twoway			(bar mu obs if p == 90, color(emerald*1.5)) || ///
						(bar mu obs if p == 95, color(eltblue*1.5)) || ///
						(bar mu obs if p == 99, color(khaki*1.5)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Tanzania") ///
						ytitle("Share of Significant Point Estimates") ///
						yline(.51883829, lcolor(maroon) lstyle(solid) ) ///
						yline(.2867173, lcolor(maroon)  lstyle(solid) ) ///
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
						saving("$sfig/tza_pval_varname_rf", replace)
						
	graph export 	"$sfig/tza_pval_varname_rf.pdf", as(pdf) replace
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
	
	twoway			(bar mu obs if p == 90, color(emerald*1.5)) || ///
						(bar mu obs if p == 95, color(eltblue*1.5)) || ///
						(bar mu obs if p == 99, color(khaki*1.5)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Uganda") ///
						ytitle("Share of Significant Point Estimates") ///
						yline(.65957391, lcolor(maroon) lstyle(solid) ) ///
						yline(.42375946, lcolor(maroon)  lstyle(solid) ) ///
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
						saving("$sfig/uga_pval_varname_rf", replace)
						
	graph export 	"$sfig/uga_pval_varname_rf.pdf", as(pdf) replace
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
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	replace			obs = 1 + obs if obs > 23
	replace			obs = 1 + obs if obs > 27
	
	twoway			(bar mu obs if p == 90, color(maroon*1.5)) || ///
						(bar mu obs if p == 95, color(lavender*1.5)) || ///
						(bar mu obs if p == 99, color(brown*1.5)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Ethiopia") ///
						ytitle("Share of Significant Point Estimates") ///
						yline(.82842958, lcolor(maroon) lstyle(solid) ) ///
						yline(.50490379, lcolor(maroon)  lstyle(solid) ) ///
						xscale(r(0 24) ex) ///
						xlabel(2 "Mean Daily Temp " 6 "Median Daily Temp " ///
						10 "Variance of Daily Temp " 14 "Skew of Daily Temp " ///
						18 "Growing Degree Days " 22 "Dev. in GDD " ///
						26 "z-Score of GDD " 30 "Max Daily Temp ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I."))  ///
						saving("$sfig/eth_pval_varname_tp", replace)
						
	graph export 	"$sfig/eth_pval_varname_tp.pdf", as(pdf) replace
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
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	replace			obs = 1 + obs if obs > 23
	replace			obs = 1 + obs if obs > 27
	
	twoway			(bar mu obs if p == 90, color(maroon*1.5)) || ///
						(bar mu obs if p == 95, color(lavender*1.5)) || ///
						(bar mu obs if p == 99, color(brown*1.5)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Malawi") ///
						ytitle("Share of Significant Point Estimates") ///
						yline(.92043924, lcolor(maroon) lstyle(solid) ) ///
						yline(.63511634, lcolor(maroon)  lstyle(solid) ) ///
						xscale(r(0 24) ex) ///
						xlabel(2 "Mean Daily Temp " 6 "Median Daily Temp " ///
						10 "Variance of Daily Temp " 14 "Skew of Daily Temp " ///
						18 "Growing Degree Days " 22 "Dev. in GDD " ///
						26 "z-Score of GDD " 30 "Max Daily Temp ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I."))  ///
						saving("$sfig/mwi_pval_varname_tp", replace)
						
	graph export 	"$sfig/mwi_pval_varname_tp.pdf", as(pdf) replace
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
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	replace			obs = 1 + obs if obs > 23
	replace			obs = 1 + obs if obs > 27
	
	twoway			(bar mu obs if p == 90, color(maroon*1.5)) || ///
						(bar mu obs if p == 95, color(lavender*1.5)) || ///
						(bar mu obs if p == 99, color(brown*1.5)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Niger") ///
						ytitle("Share of Significant Point Estimates") ///
						yline(.77839649, lcolor(maroon) lstyle(solid) ) ///
						yline(.44382572, lcolor(maroon)  lstyle(solid) ) ///
						xscale(r(0 24) ex) ///
						xlabel(2 "Mean Daily Temp " 6 "Median Daily Temp " ///
						10 "Variance of Daily Temp " 14 "Skew of Daily Temp " ///
						18 "Growing Degree Days " 22 "Dev. in GDD " ///
						26 "z-Score of GDD " 30 "Max Daily Temp ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I."))  ///
						saving("$sfig/ngr_pval_varname_tp", replace)
						
	graph export 	"$sfig/ngr_pval_varname_tp.pdf", as(pdf) replace
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
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	replace			obs = 1 + obs if obs > 23
	replace			obs = 1 + obs if obs > 27
	
	twoway			(bar mu obs if p == 90, color(maroon*1.5)) || ///
						(bar mu obs if p == 95, color(lavender*1.5)) || ///
						(bar mu obs if p == 99, color(brown*1.5)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Nigeria") ///
						ytitle("Share of Significant Point Estimates") ///
						yline(.82842958, lcolor(maroon) lstyle(solid) ) ///
						yline(.50490379, lcolor(maroon)  lstyle(solid) ) ///
						xscale(r(0 24) ex) ///
						xlabel(2 "Mean Daily Temp " 6 "Median Daily Temp " ///
						10 "Variance of Daily Temp " 14 "Skew of Daily Temp " ///
						18 "Growing Degree Days " 22 "Dev. in GDD " ///
						26 "z-Score of GDD " 30 "Max Daily Temp ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I."))  ///
						saving("$sfig/nga_pval_varname_tp", replace)
						
	graph export 	"$sfig/nga_pval_varname_tp.pdf", as(pdf) replace
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
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	replace			obs = 1 + obs if obs > 23
	replace			obs = 1 + obs if obs > 27
	
	twoway			(bar mu obs if p == 90, color(maroon*1.5)) || ///
						(bar mu obs if p == 95, color(lavender*1.5)) || ///
						(bar mu obs if p == 99, color(brown*1.5)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Tanzania") ///
						ytitle("Share of Significant Point Estimates") ///
						yline(.64353263, lcolor(maroon) lstyle(solid) ) ///
						yline(.30091175, lcolor(maroon)  lstyle(solid) ) ///
						xscale(r(0 24) ex) ///
						xlabel(2 "Mean Daily Temp " 6 "Median Daily Temp " ///
						10 "Variance of Daily Temp " 14 "Skew of Daily Temp " ///
						18 "Growing Degree Days " 22 "Dev. in GDD " ///
						26 "z-Score of GDD " 30 "Max Daily Temp ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I."))  ///
						saving("$sfig/tza_pval_varname_tp", replace)
						
	graph export 	"$sfig/tza_pval_varname_tp.pdf", as(pdf) replace
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
	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19
	replace			obs = 1 + obs if obs > 23
	replace			obs = 1 + obs if obs > 27
	
	twoway			(bar mu obs if p == 90, color(maroon*1.5)) || ///
						(bar mu obs if p == 95, color(lavender*1.5)) || ///
						(bar mu obs if p == 99, color(brown*1.5)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Uganda") ///
						ytitle("Share of Significant Point Estimates") ///
						yline(.69908822, lcolor(maroon) lstyle(solid) ) ///
						yline(.35646734, lcolor(maroon)  lstyle(solid) ) ///
						xscale(r(0 24) ex) ///
						xlabel(2 "Mean Daily Temp " 6 "Median Daily Temp " ///
						10 "Variance of Daily Temp " 14 "Skew of Daily Temp " ///
						18 "Growing Degree Days " 22 "Dev. in GDD " ///
						26 "z-Score of GDD " 30 "Max Daily Temp ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I."))  ///
						saving("$sfig/uga_pval_varname_tp", replace)
						
	graph export 	"$sfig/uga_pval_varname_tp.pdf", as(pdf) replace
restore

		
* p-value varname and country for temperature
	grc1leg2 		"$sfig/eth_pval_varname_tp.gph" "$sfig/mwi_pval_varname_tp.gph" ///
						"$sfig/ngr_pval_varname_tp.gph" "$sfig/nga_pval_varname_tp.gph" ///
						"$sfig/tza_pval_varname_tp.gph" "$sfig/uga_pval_varname_tp.gph", ///
						col(3) iscale(.5) pos(12) commonscheme imargin(0 0 0 0)
						
	graph export 	"$xfig\pval_varname_tp.png", width(1400) replace


/*	
* **********************************************************************
* 5 - generate p-value graphs by varname
* **********************************************************************
	
* keep extraction 3	
	keep			if ext == 3

	
* **********************************************************************
* 5a - generate p-value graphs by satellite
* **********************************************************************
	
* p-value graph of rainfall by satellite
preserve
	drop			if varname > 14
	
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
	
	twoway			(bar mu obs if p == 90, color(emerald*1.5)) || ///
						(bar mu obs if p == 95, color(eltblue*1.5)) || ///
						(bar mu obs if p == 99, color(khaki*1.5)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Rainfall") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 24) ex) ///
						xlabel(2 "Rainfall 1 " 6 "Rainfall 2 " 10 "Rainfall 3 " ///
						14 "Rainfall 4 " 18 "Rainfall 5 " 22 "Rainfall 6 ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I."))  ///
						saving("$sfig/pval_sat_rf", replace)
restore

* p-value graph of temperature by extraction method
preserve
	drop			if varname < 15
	
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
	
	twoway			(bar mu obs if p == 90, color(maroon*1.5)) || ///
						(bar mu obs if p == 95, color(lavender*1.5)) || ///
						(bar mu obs if p == 99, color(brown*1.5)) || ///
						(rcap hi lo obs, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Temperature") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 12) ex) xlabel(2 "Temperature 1 " ///
						6 "Temperature 2 " 10 "Temperature 3 ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I."))  ///
						saving("$sfig/pval_sat_tp", replace)
restore

	grc1leg2 		"$sfig/pval_sat_rf.gph" "$sfig/pval_sat_tp.gph", ///
						col(1) iscale(.5) pos(12) commonscheme imargin(0 0 0 0)
						
	graph export 	"$xfig\pval_sat.png", width(1400) replace		
									

* **********************************************************************
* 5a - generate p-value graphs by satellite
* **********************************************************************
					
* **********************************************************************
* 5b - generate p-value graphs by satellite and country
* **********************************************************************
	
* p-value graph of rainfall by satellite
preserve
	drop			if varname > 14
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(sat country)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(country sat) j(p)	
	
	sort 			country sat p
					
* generate count variable that repeats by country	
	bys country (sat): gen obs = _n

	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7
	replace			obs = 1 + obs if obs > 11
	replace			obs = 1 + obs if obs > 15
	replace			obs = 1 + obs if obs > 19

* ethiopia
	twoway			(bar mu obs if p == 90 & country == 1, color(emerald*1.5)) || ///
						(bar mu obs if p == 95 & country == 1, color(eltblue*1.5)) || ///
						(bar mu obs if p == 99 & country == 1, color(khaki*1.5)) || ///
						(rcap hi lo obs if country == 1, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Ethiopia") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 24) ex) ///
						xlabel(2 "Rainfall 1 " 6 "Rainfall 2 " 10 "Rainfall 3 " ///
						14 "Rainfall 4 " 18 "Rainfall 5 " 22 "Rainfall 6 ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I.")) ///
						saving("$sfig/eth_pval_sat_rf", replace)

* malawi
	twoway			(bar mu obs if p == 90 & country == 2, color(emerald*1.5)) || ///
						(bar mu obs if p == 95 & country == 2, color(eltblue*1.5)) || ///
						(bar mu obs if p == 99 & country == 2, color(khaki*1.5)) || ///
						(rcap hi lo obs if country == 2, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Malawi") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 24) ex) ///
						xlabel(2 "Rainfall 1 " 6 "Rainfall 2 " 10 "Rainfall 3 " ///
						14 "Rainfall 4 " 18 "Rainfall 5 " 22 "Rainfall 6 ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I.")) ///
						saving("$sfig/mwi_pval_sat_rf", replace)

* niger
	twoway			(bar mu obs if p == 90 & country == 4, color(emerald*1.5)) || ///
						(bar mu obs if p == 95 & country == 4, color(eltblue*1.5)) || ///
						(bar mu obs if p == 99 & country == 4, color(khaki*1.5)) || ///
						(rcap hi lo obs if country == 4, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Niger") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 24) ex) ///
						xlabel(2 "Rainfall 1 " 6 "Rainfall 2 " 10 "Rainfall 3 " ///
						14 "Rainfall 4 " 18 "Rainfall 5 " 22 "Rainfall 6 ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I.")) ///
						saving("$sfig/ngr_pval_sat_rf", replace)

* nigeria
	twoway			(bar mu obs if p == 90 & country == 5, color(emerald*1.5)) || ///
						(bar mu obs if p == 95 & country == 5, color(eltblue*1.5)) || ///
						(bar mu obs if p == 99 & country == 5, color(khaki*1.5)) || ///
						(rcap hi lo obs if country == 5, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Nigeria") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 24) ex) ///
						xlabel(2 "Rainfall 1 " 6 "Rainfall 2 " 10 "Rainfall 3 " ///
						14 "Rainfall 4 " 18 "Rainfall 5 " 22 "Rainfall 6 ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I.")) ///
						saving("$sfig/nga_pval_sat_rf", replace)
						
* tanzania
	twoway			(bar mu obs if p == 90 & country == 6, color(emerald*1.5)) || ///
						(bar mu obs if p == 95 & country == 6, color(eltblue*1.5)) || ///
						(bar mu obs if p == 99 & country == 6, color(khaki*1.5)) || ///
						(rcap hi lo obs if country == 6, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Tanzania") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 24) ex) ///
						xlabel(2 "Rainfall 1 " 6 "Rainfall 2 " 10 "Rainfall 3 " ///
						14 "Rainfall 4 " 18 "Rainfall 5 " 22 "Rainfall 6 ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I.")) ///
						saving("$sfig/tza_pval_sat_rf", replace)
						
* uganda
	twoway			(bar mu obs if p == 90 & country == 7, color(emerald*1.5)) || ///
						(bar mu obs if p == 95 & country == 7, color(eltblue*1.5)) || ///
						(bar mu obs if p == 99 & country == 7, color(khaki*1.5)) || ///
						(rcap hi lo obs if country == 7, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Uganda") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 24) ex) ///
						xlabel(2 "Rainfall 1 " 6 "Rainfall 2 " 10 "Rainfall 3 " ///
						14 "Rainfall 4 " 18 "Rainfall 5 " 22 "Rainfall 6 ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I.")) ///
						saving("$sfig/uga_pval_sat_rf", replace)
restore


* p-value graph of temperature by extraction method
preserve
	drop			if varname < 15
	
	collapse 		(mean) mu99 = p99 mu95 = p95 mu90 = p90 ///
						(sd) sd99 = p99 sd95 = p95 sd90 = p90 ///
						(count) n99 = p99 n95 = p95 n90 = p90, by(sat country)
	
	gen 			hi99 = mu99 + invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	gen				lo99 = mu99 - invttail(n99-1,0.025)*(sd99 / sqrt(n99))
	
	gen 			hi95 = mu95 + invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	gen				lo95 = mu95 - invttail(n95-1,0.025)*(sd95 / sqrt(n95))
	
	gen 			hi90 = mu90 + invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	gen				lo90 = mu90 - invttail(n90-1,0.025)*(sd90 / sqrt(n90))
	
	reshape 		long mu sd n hi lo, i(country sat) j(p)	
	
	sort 			country sat p
					
* generate count variable that repeats by country	
	bys country (sat): gen obs = _n

	replace			obs = 1 + obs if obs > 3
	replace			obs = 1 + obs if obs > 7

* ethiopia
	twoway			(bar mu obs if p == 90 & country == 1, color(maroon*1.5)) || ///
						(bar mu obs if p == 95 & country == 1, color(lavender*1.5)) || ///
						(bar mu obs if p == 99 & country == 1, color(brown*1.5)) || ///
						(rcap hi lo obs if country == 1, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Ethiopia") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 12) ex) xlabel(2 "Temperature 1 " ///
						6 "Temperature 2 " 10 "Temperature 3 ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I.")) ///
						saving("$sfig/eth_pval_sat_tp", replace)

* malawi
	twoway			(bar mu obs if p == 90 & country == 2, color(maroon*1.5)) || ///
						(bar mu obs if p == 95 & country == 2, color(lavender*1.5)) || ///
						(bar mu obs if p == 99 & country == 2, color(brown*1.5)) || ///
						(rcap hi lo obs if country == 2, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Malawi") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 12) ex) xlabel(2 "Temperature 1 " ///
						6 "Temperature 2 " 10 "Temperature 3 ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I.")) ///
						saving("$sfig/mwi_pval_sat_tp", replace)

* niger
	twoway			(bar mu obs if p == 90 & country == 4, color(maroon*1.5)) || ///
						(bar mu obs if p == 95 & country == 4, color(lavender*1.5)) || ///
						(bar mu obs if p == 99 & country == 4, color(brown*1.5)) || ///
						(rcap hi lo obs if country == 4, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Niger") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 12) ex) xlabel(2 "Temperature 1 " ///
						6 "Temperature 2 " 10 "Temperature 3 ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I.")) ///
						saving("$sfig/ngr_pval_sat_tp", replace)

* nigeria
	twoway			(bar mu obs if p == 90 & country == 5, color(maroon*1.5)) || ///
						(bar mu obs if p == 95 & country == 5, color(lavender*1.5)) || ///
						(bar mu obs if p == 99 & country == 5, color(brown*1.5)) || ///
						(rcap hi lo obs if country == 5, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Nigeria") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 12) ex) xlabel(2 "Temperature 1 " ///
						6 "Temperature 2 " 10 "Temperature 3 ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I.")) ///
						saving("$sfig/nga_pval_sat_tp", replace)
						
* tanzania
	twoway			(bar mu obs if p == 90 & country == 6, color(maroon*1.5)) || ///
						(bar mu obs if p == 95 & country == 6, color(lavender*1.5)) || ///
						(bar mu obs if p == 99 & country == 6, color(brown*1.5)) || ///
						(rcap hi lo obs if country == 6, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Tanzania") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 12) ex) xlabel(2 "Temperature 1 " ///
						6 "Temperature 2 " 10 "Temperature 3 ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I.")) ///
						saving("$sfig/tza_pval_sat_tp", replace)
						
* uganda
	twoway			(bar mu obs if p == 90 & country == 7, color(maroon*1.5)) || ///
						(bar mu obs if p == 95 & country == 7, color(lavender*1.5)) || ///
						(bar mu obs if p == 99 & country == 7, color(brown*1.5)) || ///
						(rcap hi lo obs if country == 7, yscale(r(0 1)) ///
						ylab(0(.1)1, labsize(small)) title("Uganda") ///
						ytitle("Share of Significant Point Estimates") ///
						xscale(r(0 12) ex) xlabel(2 "Temperature 1 " ///
						6 "Temperature 2 " 10 "Temperature 3 ", ///
						angle(45) notick) xtitle("")), ///
						legend(pos(12) col(5) order(1 2 3 4) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99") label(4 "95% C.I.")) ///
						saving("$sfig/uga_pval_sat_tp", replace)
restore
							
* p-value extraction method for rainfall
	grc1leg2 		"$sfig/eth_pval_sat_rf.gph" "$sfig/mwi_pval_sat_rf.gph" ///
						"$sfig/ngr_pval_sat_rf.gph" "$sfig/nga_pval_sat_rf.gph" ///
						"$sfig/tza_pval_sat_rf.gph" "$sfig/uga_pval_sat_rf.gph", ///
						col(3) iscale(.5) pos(12) commonscheme imargin(0 0 0 0)
						
	graph export 	"$xfig\pval_sat_rf.png", width(1400) replace
	
* p-value extraction method for temperature
	grc1leg2 		"$sfig/eth_pval_sat_tp.gph" "$sfig/mwi_pval_sat_tp.gph" ///
						"$sfig/ngr_pval_sat_tp.gph" "$sfig/nga_pval_sat_tp.gph" ///
						"$sfig/tza_pval_sat_tp.gph" "$sfig/uga_pval_sat_tp.gph", ///
						col(3) iscale(.5) pos(12) commonscheme imargin(0 0 0 0)
						
	graph export 	"$xfig\pval_sat_tp.png", width(1400) replace					
		
				
				
				
				
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
* **********************************************************************
* 2 - generate p-value graphs for all countries
* **********************************************************************


*** varname ***

* p-value graph of rainfall by varname
	graph bar 		(mean) p90 p95 p99 if varname < 15, over(varname, label(angle(45) ///
						labsize(vsmall))) yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, ///
						labsize(small)) title("Rainfall") bar(1, color(emerald*1.5)) ///
						bar(2, color(eltblue*1.5)) bar(3, color(khaki*1.5)) ///
						ytitle("Share of Significant Point Estimates") ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/pval_varname_rf", replace)
						
* p-value graph of temperature by varname
	graph bar 		(mean) p90 p95 p99 if varname > 14, over(varname, label(angle(45) ///
						labsize(vsmall))) yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, ///
						labsize(small)) title("Temperature") bar(1, color(maroon*1.5)) ///
						bar(2, color(lavender*1.5)) bar(3, color(brown*1.5)) ///
						ytitle("Share of Significant Point Estimates") ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/pval_varname_tp", replace)

	grc1leg2 		"$sfig/pval_varname_rf.gph" "$sfig/pval_varname_tp.gph", ///
						col(1) iscale(.5) commonscheme imargin(0 0 0 0)
						
	graph export 	"$xfig\pval_varname.png", width(1400) replace							

	
*** satellite ***
	
* p-value graph of rainfall by satellite
	graph bar 		(mean) p90 p95 p99 if varname < 15, over(sat, label(angle(45) ///
						labsize(vsmall))) yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, ///
						labsize(small)) title("Rainfall") bar(1, color(emerald*1.5)) ///
						bar(2, color(eltblue*1.5)) bar(3, color(khaki*1.5)) ///
						ytitle("Share of Significant Point Estimates") ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/pval_sat_rf", replace)
						

* p-value graph of temperature by satellite
	graph bar 		(mean) p90 p95 p99 if varname > 14, over(sat, label(angle(45) ///
						labsize(vsmall))) yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, ///
						labsize(small)) title("Temperature") bar(1, color(maroon*1.5)) ///
						bar(2, color(lavender*1.5)) bar(3, color(brown*1.5)) ///
						ytitle("Share of Significant Point Estimates") ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/pval_sat_tp", replace)
						

	grc1leg2 		"$sfig/pval_sat_rf.gph" "$sfig/pval_sat_tp.gph", ///
						col(1) iscale(.5) commonscheme imargin(0 0 0 0)
						
	graph export 	"$xfig\pval_sat.png", width(1400) replace							

	
*** extraction method ***
	
* p-value graph of rainfall by extraction
	graph bar 		(mean) p90 p95 p99 if varname < 15, over(ext, label(angle(45) ///
						labsize(vsmall))) yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, ///
						labsize(small)) title("Rainfall") bar(1, color(emerald*1.5)) ///
						bar(2, color(eltblue*1.5)) bar(3, color(khaki*1.5)) ///
						ytitle("Share of Significant Point Estimates") ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/pval_ext_rf", replace)

* p-value graph of temperature by extraction
	graph bar 		(mean) p90 p95 p99 if varname > 14, over(ext, label(angle(45) ///
						labsize(vsmall))) yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, ///
						labsize(small)) title("Temperature") bar(1, color(maroon*1.5)) ///
						bar(2, color(lavender*1.5)) bar(3, color(brown*1.5)) ///
						ytitle("Share of Significant Point Estimates") ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/pval_ext_tp", replace)
						

	grc1leg2 		"$sfig/pval_ext_rf.gph" "$sfig/pval_ext_tp.gph", ///
						col(1) iscale(.5) commonscheme imargin(0 0 0 0)
						
	graph export 	"$xfig\pval_ext.png", width(1400) replace							
	

*** dependant variable ***
	
* p-value graph of rainfall by dependant variable
	graph bar 		(mean) p90 p95 p99 if varname < 15, over(depvar, label(angle(45) ///
						labsize(vsmall))) yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, ///
						labsize(small)) title("Rainfall") bar(1, color(emerald*1.5)) ///
						bar(2, color(eltblue*1.5)) bar(3, color(khaki*1.5)) ///
						ytitle("Share of Significant Point Estimates") ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/pval_depvar_rf", replace)

* p-value graph of temperature by dependant variable
	graph bar 		(mean) p90 p95 p99 if varname > 14, over(depvar, label(angle(45) ///
						labsize(vsmall))) yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, ///
						labsize(small)) title("Temperature") bar(1, color(maroon*1.5)) ///
						bar(2, color(lavender*1.5)) bar(3, color(brown*1.5)) ///
						ytitle("Share of Significant Point Estimates") ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/pval_depvar_tp", replace)
						

	grc1leg2 		"$sfig/pval_depvar_rf.gph" "$sfig/pval_depvar_tp.gph", ///
						col(1) iscale(.5) commonscheme imargin(0 0 0 0)
						
	graph export 	"$xfig\pval_depvar.png", width(1400) replace			
	

*** regression specification ***	

* p-value graph of rainfall by regression
	graph bar 		(mean) p90 p95 p99 if varname < 15, over(regname, label(angle(45) ///
						labsize(vsmall))) yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, ///
						labsize(small)) title("Rainfall") bar(1, color(emerald*1.5)) ///
						bar(2, color(eltblue*1.5)) bar(3, color(khaki*1.5)) ///
						ytitle("Share of Significant Point Estimates") ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/pval_regname_rf", replace)

* p-value graph of temperature by regression
	graph bar 		(mean) p90 p95 p99 if varname > 14, over(regname, label(angle(45) ///
						labsize(vsmall))) yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, ///
						labsize(small)) title("Temperature") bar(1, color(maroon*1.5)) ///
						bar(2, color(lavender*1.5)) bar(3, color(brown*1.5)) ///
						ytitle("Share of Significant Point Estimates") ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/pval_regname_tp", replace)
						

	grc1leg2 		"$sfig/pval_regname_rf.gph" "$sfig/pval_regname_tp.gph", ///
						col(1) iscale(.5) commonscheme imargin(0 0 0 0)
						
	graph export 	"$xfig\pval_regname.png", width(1400) replace							

	
*** country ***

* p-value graph of rainfall by country
	graph bar 		(mean) p90 p95 p99 if varname < 15, over(country, label(angle(45) ///
						labsize(vsmall))) yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, ///
						labsize(small)) title("Rainfall") bar(1, color(emerald*1.5)) ///
						bar(2, color(eltblue*1.5)) bar(3, color(khaki*1.5)) ///
						ytitle("Share of Significant Point Estimates") ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/pval_country_rf", replace)

* p-value graph of temperature by country
	graph bar 		(mean) p90 p95 p99 if varname > 14, over(country, label(angle(45) ///
						labsize(vsmall))) yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, ///
						labsize(small)) title("Temperature") bar(1, color(maroon*1.5)) ///
						bar(2, color(lavender*1.5)) bar(3, color(brown*1.5)) ///
						ytitle("Share of Significant Point Estimates") ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/pval_country_tp", replace)
						

	grc1leg2 		"$sfig/pval_country_rf.gph" "$sfig/pval_country_tp.gph", ///
						col(1) iscale(.5) commonscheme imargin(0 0 0 0)
						
	graph export 	"$xfig\pval_country.png", width(1400) replace					

	
* **********************************************************************
* 3 - generate p-value graphs for by country
* **********************************************************************

*** ethiopia ***

* p-value graph of rainfall by extraction method
	graph bar 		(mean) p90 p95 p99 if country == 1 & varname < 15, ///
						over(ext, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(emerald*1.5)) bar(2, color(eltblue*1.5)) ///
						bar(3, color(khaki*1.5)) title("Ethiopia") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/eth_pval_ext_rf", replace)


* p-value graph of temperature by extraction method
	graph bar 		(mean) p90 p95 p99 if country == 1 & varname > 14, ///
						over(ext, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(maroon*1.5)) bar(2, color(lavender*1.5)) ///
						bar(3, color(brown*1.5)) title("Ethiopia") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/eth_pval_ext_tp", replace)

* p-value graph of rainfall by satellite
	graph bar 		(mean) p90 p95 p99 if country == 1 & varname < 15, ///
						over(sat, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(emerald*1.5)) bar(2, color(eltblue*1.5)) ///
						bar(3, color(khaki*1.5)) title("Ethiopia") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/eth_pval_sat_rf", replace)

* p-value graph of temperature by satellite
	graph bar 		(mean) p90 p95 p99 if country == 1 & varname > 14, ///
						over(sat, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(maroon*1.5)) bar(2, color(lavender*1.5)) ///
						bar(3, color(brown*1.5)) title("Ethiopia") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/eth_pval_sat_tp", replace)
	
*** malawi ***

* p-value graph of rainfall by extraction method
	graph bar 		(mean) p90 p95 p99 if country == 2 & varname < 15, ///
						over(ext, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(emerald*1.5)) bar(2, color(eltblue*1.5)) ///
						bar(3, color(khaki*1.5)) title("Malawi") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/mwi_pval_ext_rf", replace)

* p-value graph of temperature by extraction method
	graph bar 		(mean) p90 p95 p99 if country == 2 & varname > 14, ///
						over(ext, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(maroon*1.5)) bar(2, color(lavender*1.5)) ///
						bar(3, color(brown*1.5)) title("Malawi") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/mwi_pval_ext_tp", replace)

* p-value graph of rainfall by satellite
	graph bar 		(mean) p90 p95 p99 if country == 2 & varname < 15, ///
						over(sat, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(emerald*1.5)) bar(2, color(eltblue*1.5)) ///
						bar(3, color(khaki*1.5)) title("Malawi") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/mwi_pval_sat_rf", replace)

* p-value graph of temperature by satellite
	graph bar 		(mean) p90 p95 p99 if country == 2 & varname > 14, ///
						over(sat, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(maroon*1.5)) bar(2, color(lavender*1.5)) ///
						bar(3, color(brown*1.5)) title("Malawi") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/mwi_pval_sat_tp", replace)

*** niger ***

* p-value graph of rainfall by extraction method
	graph bar 		(mean) p90 p95 p99 if country == 4 & varname < 15, ///
						over(ext, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(emerald*1.5)) bar(2, color(eltblue*1.5)) ///
						bar(3, color(khaki*1.5)) title("Niger") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/ngr_pval_ext_rf", replace)

* p-value graph of temperature by extraction method
	graph bar 		(mean) p90 p95 p99 if country == 4 & varname > 14, ///
						over(ext, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(maroon*1.5)) bar(2, color(lavender*1.5)) ///
						bar(3, color(brown*1.5)) title("Niger") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/ngr_pval_ext_tp", replace)

* p-value graph of rainfall by satellite
	graph bar 		(mean) p90 p95 p99 if country == 4 & varname < 15, ///
						over(sat, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(emerald*1.5)) bar(2, color(eltblue*1.5)) ///
						bar(3, color(khaki*1.5)) title("Niger") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/ngr_pval_sat_rf", replace)

* p-value graph of temperature by satellite
	graph bar 		(mean) p90 p95 p99 if country == 4 & varname > 14, ///
						over(sat, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(maroon*1.5)) bar(2, color(lavender*1.5)) ///
						bar(3, color(brown*1.5)) title("Niger") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/ngr_pval_sat_tp", replace)
	
*** nigeria ***

* p-value graph of rainfall by extraction method
	graph bar 		(mean) p90 p95 p99 if country == 5 & varname < 15, ///
						over(ext, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(emerald*1.5)) bar(2, color(eltblue*1.5)) ///
						bar(3, color(khaki*1.5)) title("Nigeria") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/nga_pval_ext_rf", replace)

* p-value graph of temperature by extraction method
	graph bar 		(mean) p90 p95 p99 if country == 5 & varname > 14, ///
						over(ext, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(maroon*1.5)) bar(2, color(lavender*1.5)) ///
						bar(3, color(brown*1.5)) title("Nigeria") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/nga_pval_ext_tp", replace)

* p-value graph of rainfall by satellite
	graph bar 		(mean) p90 p95 p99 if country == 5 & varname < 15, ///
						over(sat, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(emerald*1.5)) bar(2, color(eltblue*1.5)) ///
						bar(3, color(khaki*1.5)) title("Nigeria") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/nga_pval_sat_rf", replace)

* p-value graph of temperature by satellite
	graph bar 		(mean) p90 p95 p99 if country == 5 & varname > 14, ///
						over(sat, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(maroon*1.5)) bar(2, color(lavender*1.5)) ///
						bar(3, color(brown*1.5)) title("Nigeria") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/nga_pval_sat_tp", replace)
	
*** tanzania ***

* p-value graph of rainfall by extraction method
	graph bar 		(mean) p90 p95 p99 if country == 6 & varname < 15, ///
						over(ext, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(emerald*1.5)) bar(2, color(eltblue*1.5)) ///
						bar(3, color(khaki*1.5)) title("Tanzania") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/tza_pval_ext_rf", replace)

* p-value graph of temperature by extraction method
	graph bar 		(mean) p90 p95 p99 if country == 6 & varname > 14, ///
						over(ext, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(maroon*1.5)) bar(2, color(lavender*1.5)) ///
						bar(3, color(brown*1.5)) title("Tanzania") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/tza_pval_ext_tp", replace)

* p-value graph of rainfall by satellite
	graph bar 		(mean) p90 p95 p99 if country == 6 & varname < 15, ///
						over(sat, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(emerald*1.5)) bar(2, color(eltblue*1.5)) ///
						bar(3, color(khaki*1.5)) title("Tanzania") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/tza_pval_sat_rf", replace)

* p-value graph of temperature by satellite
	graph bar 		(mean) p90 p95 p99 if country == 6 & varname > 14, ///
						over(sat, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(maroon*1.5)) bar(2, color(lavender*1.5)) ///
						bar(3, color(brown*1.5)) title("Tanzania") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/tza_pval_sat_tp", replace)

*** uganda ***

* p-value graph of rainfall by extraction method
	graph bar 		(mean) p90 p95 p99 if country == 7 & varname < 15, ///
						over(ext, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(emerald*1.5)) bar(2, color(eltblue*1.5)) ///
						bar(3, color(khaki*1.5)) title("Uganda") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/uga_pval_ext_rf", replace)

* p-value graph of temperature by extraction method
	graph bar 		(mean) p90 p95 p99 if country == 7 & varname > 14, ///
						over(ext, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(maroon*1.5)) bar(2, color(lavender*1.5)) ///
						bar(3, color(brown*1.5)) title("Uganda") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/uga_pval_ext_tp", replace)

* p-value graph of rainfall by satellite
	graph bar 		(mean) p90 p95 p99 if country == 7 & varname < 15, ///
						over(sat, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(emerald*1.5)) bar(2, color(eltblue*1.5)) ///
						bar(3, color(khaki*1.5)) title("Uganda") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/uga_pval_sat_rf", replace)

* p-value graph of temperature by satellite
	graph bar 		(mean) p90 p95 p99 if country == 7 & varname > 14, ///
						over(sat, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(maroon*1.5)) bar(2, color(lavender*1.5)) ///
						bar(3, color(brown*1.5)) title("Uganda") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$sfig/uga_pval_sat_tp", replace)

						
* p-value extraction method for rainfall
	grc1leg2 		"$sfig/eth_pval_ext_rf.gph" "$sfig/mwi_pval_ext_rf.gph" ///
						"$sfig/ngr_pval_ext_rf.gph" "$sfig/nga_pval_ext_rf.gph" ///
						"$sfig/tza_pval_ext_rf.gph" "$sfig/uga_pval_ext_rf.gph", ///
						col(3) iscale(.5) commonscheme imargin(0 0 0 0)
						
	graph export 	"$xfig\pval_ext_rf.png", width(1400) replace					

* p-value extraction method for temperature
	grc1leg2 		"$sfig/eth_pval_ext_tp.gph" "$sfig/mwi_pval_ext_tp.gph" ///
						"$sfig/ngr_pval_ext_tp.gph" "$sfig/nga_pval_ext_tp.gph" ///
						"$sfig/tza_pval_ext_tp.gph" "$sfig/uga_pval_ext_tp.gph", ///
						col(3) iscale(.5) commonscheme imargin(0 0 0 0)
						
	graph export 	"$xfig\pval_ext_tp.png", width(1400) replace		
						
* p-value satellite for rainfall
	grc1leg2 		"$sfig/eth_pval_sat_rf.gph" "$sfig/mwi_pval_sat_rf.gph" ///
						"$sfig/ngr_pval_sat_rf.gph" "$sfig/nga_pval_sat_rf.gph" ///
						"$sfig/tza_pval_sat_rf.gph" "$sfig/uga_pval_sat_rf.gph", ///
						col(3) iscale(.5) commonscheme imargin(0 0 0 0)
						
	graph export 	"$xfig\pval_sat_rf.png", width(1400) replace					

* p-value satellite for temperature
	grc1leg2 		"$sfig/eth_pval_sat_tp.gph" "$sfig/mwi_pval_sat_tp.gph" ///
						"$sfig/ngr_pval_sat_tp.gph" "$sfig/nga_pval_sat_tp.gph" ///
						"$sfig/tza_pval_sat_tp.gph" "$sfig/uga_pval_sat_tp.gph", ///
						col(3) iscale(.5) commonscheme imargin(0 0 0 0)
						
	graph export 	"$xfig\pval_sat_tp.png", width(1400) replace		
	
	
* **********************************************************************
* 4 - end matter
* **********************************************************************


* close the log
	log	close

/* END */		