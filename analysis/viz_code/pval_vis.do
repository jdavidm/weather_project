* Project: WB Weather
* Created on: September 2019
* Created by: jdm
* Edited by: alj
* Last edit: 9 November 2020 
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
						ylab(0 .2 .4 .6 .8 1, labsize(small)) title("Rainfall") ///
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
						ylab(0 .2 .4 .6 .8 1, labsize(small)) title("Temperature") ///
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
* 3 - generate p-value graphs by extraction and country
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
						ylab(0 .2 .4 .6 .8 1, labsize(small)) title("Ethiopia") ///
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
						ylab(0 .2 .4 .6 .8 1, labsize(small)) title("Malawi") ///
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
						ylab(0 .2 .4 .6 .8 1, labsize(small)) title("Niger") ///
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
						ylab(0 .2 .4 .6 .8 1, labsize(small)) title("Nigeria") ///
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
						ylab(0 .2 .4 .6 .8 1, labsize(small)) title("Tanzania") ///
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
						ylab(0 .2 .4 .6 .8 1, labsize(small)) title("Uganda") ///
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
						ylab(0 .2 .4 .6 .8 1, labsize(small)) title("Ethiopia") ///
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
						ylab(0 .2 .4 .6 .8 1, labsize(small)) title("Malawi") ///
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
						ylab(0 .2 .4 .6 .8 1, labsize(small)) title("Niger") ///
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
						ylab(0 .2 .4 .6 .8 1, labsize(small)) title("Nigeria") ///
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
						ylab(0 .2 .4 .6 .8 1, labsize(small)) title("Tanzania") ///
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
						ylab(0 .2 .4 .6 .8 1, labsize(small)) title("Uganda") ///
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