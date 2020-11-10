* Project: WB Weather
* Created on: September 2019
* Created by: jdm
* Edited by: alj
* Last edit: 28 September 2020 
* Stata v.16.1 

* does
	* reads in results data set
	* makes visualziations of results 

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
	global	root 	= 	"$data/results_data"
	global	xtab 	= 	"$data/results_data/tables"
	global 	xfig    =   "$data/results_data/figures"
	global	logout 	= 	"$data/results_data/logs"

* open log	
	cap log close
	log 	using 		"$logout/aez_resultsvis", append

		
* **********************************************************************
* 1 - load data
* **********************************************************************

* load data 
	use 			"$root/lsms_aez_results", clear

*Generate p-values
	gen 			p99 = 1 if pval <= 0.01
	replace 		p99 = 0 if pval > 0.01
	gen 			p95 = 1 if pval <= 0.05
	replace 		p95 = 0 if pval > 0.05
	gen 			p90 = 1 if pval <= 0.10
	replace 		p90 = 0 if pval > 0.10
	
	
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
						saving("$xfig/pval_varname_rf", replace)
						
* p-value graph of temperature by varname
	graph bar 		(mean) p90 p95 p99 if varname > 14, over(varname, label(angle(45) ///
						labsize(vsmall))) yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, ///
						labsize(small)) title("Temperature") bar(1, color(maroon*1.5)) ///
						bar(2, color(lavender*1.5)) bar(3, color(brown*1.5)) ///
						ytitle("Share of Significant Point Estimates") ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$xfig/pval_varname_tp", replace)

	grc1leg2 		"$xfig/pval_varname_rf.gph" "$xfig/pval_varname_tp.gph", ///
						col(1) iscale(.5) commonscheme imargin(0 0 0 0)
						
	graph export "$xfig\pval_varname.pdf", as(pdf) replace							

	
*** satellite ***
	
* p-value graph of rainfall by satellite
	graph bar 		(mean) p90 p95 p99 if varname < 15, over(sat, label(angle(45) ///
						labsize(vsmall))) yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, ///
						labsize(small)) title("Rainfall") bar(1, color(emerald*1.5)) ///
						bar(2, color(eltblue*1.5)) bar(3, color(khaki*1.5)) ///
						ytitle("Share of Significant Point Estimates") ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$xfig/pval_sat_rf", replace)
						

* p-value graph of temperature by satellite
	graph bar 		(mean) p90 p95 p99 if varname > 14, over(sat, label(angle(45) ///
						labsize(vsmall))) yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, ///
						labsize(small)) title("Temperature") bar(1, color(maroon*1.5)) ///
						bar(2, color(lavender*1.5)) bar(3, color(brown*1.5)) ///
						ytitle("Share of Significant Point Estimates") ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$xfig/pval_sat_tp", replace)
						

	grc1leg2 		"$xfig/pval_sat_rf.gph" "$xfig/pval_sat_tp.gph", ///
						col(1) iscale(.5) commonscheme imargin(0 0 0 0)
						
	graph export "$xfig\pval_sat.pdf", as(pdf) replace							

	
*** extraction method ***
	
* p-value graph of rainfall by extraction
	graph bar 		(mean) p90 p95 p99 if varname < 15, over(ext, label(angle(45) ///
						labsize(vsmall))) yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, ///
						labsize(small)) title("Rainfall") bar(1, color(emerald*1.5)) ///
						bar(2, color(eltblue*1.5)) bar(3, color(khaki*1.5)) ///
						ytitle("Share of Significant Point Estimates") ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$xfig/pval_ext_rf", replace)

* p-value graph of temperature by extraction
	graph bar 		(mean) p90 p95 p99 if varname > 14, over(ext, label(angle(45) ///
						labsize(vsmall))) yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, ///
						labsize(small)) title("Temperature") bar(1, color(maroon*1.5)) ///
						bar(2, color(lavender*1.5)) bar(3, color(brown*1.5)) ///
						ytitle("Share of Significant Point Estimates") ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$xfig/pval_ext_tp", replace)
						

	grc1leg2 		"$xfig/pval_ext_rf.gph" "$xfig/pval_ext_tp.gph", ///
						col(1) iscale(.5) commonscheme imargin(0 0 0 0)
						
	graph export "$xfig\pval_ext.pdf", as(pdf) replace							
	

*** dependant variable ***
	
* p-value graph of rainfall by dependant variable
	graph bar 		(mean) p90 p95 p99 if varname < 15, over(depvar, label(angle(45) ///
						labsize(vsmall))) yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, ///
						labsize(small)) title("Rainfall") bar(1, color(emerald*1.5)) ///
						bar(2, color(eltblue*1.5)) bar(3, color(khaki*1.5)) ///
						ytitle("Share of Significant Point Estimates") ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$xfig/pval_depvar_rf", replace)

* p-value graph of temperature by dependant variable
	graph bar 		(mean) p90 p95 p99 if varname > 14, over(depvar, label(angle(45) ///
						labsize(vsmall))) yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, ///
						labsize(small)) title("Temperature") bar(1, color(maroon*1.5)) ///
						bar(2, color(lavender*1.5)) bar(3, color(brown*1.5)) ///
						ytitle("Share of Significant Point Estimates") ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$xfig/pval_depvar_tp", replace)
						

	grc1leg2 		"$xfig/pval_depvar_rf.gph" "$xfig/pval_depvar_tp.gph", ///
						col(1) iscale(.5) commonscheme imargin(0 0 0 0)
						
	graph export "$xfig\pval_depvar.pdf", as(pdf) replace			
	

*** regression specification ***	

* p-value graph of rainfall by regression
	graph bar 		(mean) p90 p95 p99 if varname < 15, over(regname, label(angle(45) ///
						labsize(vsmall))) yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, ///
						labsize(small)) title("Rainfall") bar(1, color(emerald*1.5)) ///
						bar(2, color(eltblue*1.5)) bar(3, color(khaki*1.5)) ///
						ytitle("Share of Significant Point Estimates") ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$xfig/pval_regname_rf", replace)

* p-value graph of temperature by regression
	graph bar 		(mean) p90 p95 p99 if varname > 14, over(regname, label(angle(45) ///
						labsize(vsmall))) yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, ///
						labsize(small)) title("Temperature") bar(1, color(maroon*1.5)) ///
						bar(2, color(lavender*1.5)) bar(3, color(brown*1.5)) ///
						ytitle("Share of Significant Point Estimates") ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$xfig/pval_regname_tp", replace)
						

	grc1leg2 		"$xfig/pval_regname_rf.gph" "$xfig/pval_regname_tp.gph", ///
						col(1) iscale(.5) commonscheme imargin(0 0 0 0)
						
	graph export "$xfig\pval_regname.pdf", as(pdf) replace							

	
*** aez ***

* p-value graph of rainfall by country
	graph bar 		(mean) p90 p95 p99 if varname < 15, over(aez, label(angle(45) ///
						labsize(vsmall))) yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, ///
						labsize(small)) title("Rainfall") bar(1, color(emerald*1.5)) ///
						bar(2, color(eltblue*1.5)) bar(3, color(khaki*1.5)) ///
						ytitle("Share of Significant Point Estimates") ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$xfig/pval_aez_rf", replace)

* p-value graph of temperature by aez
	graph bar 		(mean) p90 p95 p99 if varname > 14, over(aez, label(angle(45) ///
						labsize(vsmall))) yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, ///
						labsize(small)) title("Temperature") bar(1, color(maroon*1.5)) ///
						bar(2, color(lavender*1.5)) bar(3, color(brown*1.5)) ///
						ytitle("Share of Significant Point Estimates") ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$xfig/pval_aez_tp", replace)
						

	grc1leg2 		"$xfig/pval_aez_rf.gph" "$xfig/pval_aez_tp.gph", ///
						col(1) iscale(.5) commonscheme imargin(0 0 0 0)
						
	graph export "$xfig\pval_aez.pdf", as(pdf) replace					

	
* **********************************************************************
* 3 - generate p-value graphs for by country
* **********************************************************************

* test
	ttest p99 if country == 1 | country == 2, by(country)
	
	
* **********************************************************************
* 4 - generate p-value graphs for by country
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
						saving("$xfig/eth_pval_ext_rf", replace)


* p-value graph of temperature by extraction method
	graph bar 		(mean) p90 p95 p99 if country == 1 & varname > 14, ///
						over(ext, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(maroon*1.5)) bar(2, color(lavender*1.5)) ///
						bar(3, color(brown*1.5)) title("Ethiopia") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$xfig/eth_pval_ext_tp", replace)

* p-value graph of rainfall by satellite
	graph bar 		(mean) p90 p95 p99 if country == 1 & varname < 15, ///
						over(sat, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(emerald*1.5)) bar(2, color(eltblue*1.5)) ///
						bar(3, color(khaki*1.5)) title("Ethiopia") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$xfig/eth_pval_sat_rf", replace)

* p-value graph of temperature by satellite
	graph bar 		(mean) p90 p95 p99 if country == 1 & varname > 14, ///
						over(sat, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(maroon*1.5)) bar(2, color(lavender*1.5)) ///
						bar(3, color(brown*1.5)) title("Ethiopia") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$xfig/eth_pval_sat_tp", replace)
	
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
						saving("$xfig/mwi_pval_ext_rf", replace)

* p-value graph of temperature by extraction method
	graph bar 		(mean) p90 p95 p99 if country == 2 & varname > 14, ///
						over(ext, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(maroon*1.5)) bar(2, color(lavender*1.5)) ///
						bar(3, color(brown*1.5)) title("Malawi") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$xfig/mwi_pval_ext_tp", replace)

* p-value graph of rainfall by satellite
	graph bar 		(mean) p90 p95 p99 if country == 2 & varname < 15, ///
						over(sat, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(emerald*1.5)) bar(2, color(eltblue*1.5)) ///
						bar(3, color(khaki*1.5)) title("Malawi") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$xfig/mwi_pval_sat_rf", replace)

* p-value graph of temperature by satellite
	graph bar 		(mean) p90 p95 p99 if country == 2 & varname > 14, ///
						over(sat, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(maroon*1.5)) bar(2, color(lavender*1.5)) ///
						bar(3, color(brown*1.5)) title("Malawi") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$xfig/mwi_pval_sat_tp", replace)

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
						saving("$xfig/nga_pval_ext_rf", replace)

* p-value graph of temperature by extraction method
	graph bar 		(mean) p90 p95 p99 if country == 5 & varname > 14, ///
						over(ext, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(maroon*1.5)) bar(2, color(lavender*1.5)) ///
						bar(3, color(brown*1.5)) title("Nigeria") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$xfig/nga_pval_ext_tp", replace)

* p-value graph of rainfall by satellite
	graph bar 		(mean) p90 p95 p99 if country == 5 & varname < 15, ///
						over(sat, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(emerald*1.5)) bar(2, color(eltblue*1.5)) ///
						bar(3, color(khaki*1.5)) title("Nigeria") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$xfig/nga_pval_sat_rf", replace)

* p-value graph of temperature by satellite
	graph bar 		(mean) p90 p95 p99 if country == 5 & varname > 14, ///
						over(sat, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(maroon*1.5)) bar(2, color(lavender*1.5)) ///
						bar(3, color(brown*1.5)) title("Nigeria") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$xfig/nga_pval_sat_tp", replace)
	
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
						saving("$xfig/tza_pval_ext_rf", replace)

* p-value graph of temperature by extraction method
	graph bar 		(mean) p90 p95 p99 if country == 6 & varname > 14, ///
						over(ext, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(maroon*1.5)) bar(2, color(lavender*1.5)) ///
						bar(3, color(brown*1.5)) title("Tanzania") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$xfig/tza_pval_ext_tp", replace)

* p-value graph of rainfall by satellite
	graph bar 		(mean) p90 p95 p99 if country == 6 & varname < 15, ///
						over(sat, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(emerald*1.5)) bar(2, color(eltblue*1.5)) ///
						bar(3, color(khaki*1.5)) title("Tanzania") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$xfig/tza_pval_sat_rf", replace)

* p-value graph of temperature by satellite
	graph bar 		(mean) p90 p95 p99 if country == 6 & varname > 14, ///
						over(sat, label(angle(45) labsize(vsmall))) ///
						yscale(r(0 1)) ylab(0 .2 .4 .6 .8 1, labsize(small)) ///
						bar(1, color(maroon*1.5)) bar(2, color(lavender*1.5)) ///
						bar(3, color(brown*1.5)) title("Tanzania") ///
						ytitle("Share of Significant Point Estimates")  ///
						legend(pos(12) col(3) label(1 "p>0.90") ///
						label(2 "p>0.95") label(3 "p>0.99")) ///
						saving("$xfig/tza_pval_sat_tp", replace)

						
* p-value extraction method for rainfall
	grc1leg2 		"$xfig/eth_pval_ext_rf.gph" "$xfig/mwi_pval_ext_rf.gph" ///
						"$xfig/nga_pval_ext_rf.gph" "$xfig/tza_pval_ext_rf.gph", ///
						col(2) iscale(.5) commonscheme imargin(0 0 0 0)
						
	graph export "$xfig\pval_ext_rf.pdf", as(pdf) replace					

* p-value extraction method for temperature
	grc1leg2 		"$xfig/eth_pval_ext_tp.gph" "$xfig/mwi_pval_ext_tp.gph" ///
						"$xfig/nga_pval_ext_tp.gph" "$xfig/tza_pval_ext_tp.gph", ///
						col(2) iscale(.5) commonscheme imargin(0 0 0 0)
						
	graph export "$xfig\pval_ext_tp.pdf", as(pdf) replace		
						
* p-value satellite for rainfall
	grc1leg2 		"$xfig/eth_pval_sat_rf.gph" "$xfig/mwi_pval_sat_rf.gph" ///
						"$xfig/nga_pval_sat_rf.gph" "$xfig/tza_pval_sat_rf.gph", ///
						col(2) iscale(.5) commonscheme imargin(0 0 0 0)
						
	graph export "$xfig\pval_sat_rf.pdf", as(pdf) replace					

* p-value satellite for temperature
	grc1leg2 		"$xfig/eth_pval_sat_tp.gph" "$xfig/mwi_pval_sat_tp.gph" ///
						"$xfig/nga_pval_sat_tp.gph" "$xfig/tza_pval_sat_tp.gph", ///
						col(2) iscale(.5) commonscheme imargin(0 0 0 0)
						
	graph export "$xfig\pval_sat_tp.pdf", as(pdf) replace		
	

* **********************************************************************
* 3 - end matter
* **********************************************************************


* close the log
	log	close

/* END */		