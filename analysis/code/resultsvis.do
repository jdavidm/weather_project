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
	* xfill.ado

* TO DO:
	* all of it

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		root 	= 	"$data/results_data"
	loc		xtab 	= 	"$data/results_data/tables"
	loc 	xfig    =   "$data/results_data/figures"
	loc		logout 	= 	"$data/results_data/logs"

* open log	
	cap log close
	log 	using 		"`logout'/resultsvis", append

		
* **********************************************************************
* 1 - load data
* **********************************************************************

* load data 
	use 			"`root'/lsms_complete_results", clear

* **********************************************************************
* 2 
* **********************************************************************
	
*Convert loglike to positive weight
sort varname
gen llike = abs(1/loglike)
by varname, sort: egen llsum = total(llike)

gen wll = llike/llsum

gen b_var = wll*betarain
gen ci_lo_s = wll*ci_lo
gen ci_up_s = wll*ci_up
by varname, sort: egen avg_ci_lo = mean(ci_lo_s)
by varname, sort: egen avg_ci_up = mean(ci_up_s)

*Generate p-values
gen p99 = 1 if pval <= 0.01
replace p99 = 0 if pval > 0.01
gen p95 = 1 if pval <= 0.05
replace p95 = 0 if pval > 0.05
gen p90 = 1 if pval <= 0.10
replace p90 = 0 if pval > 0.10

graph bar (mean) p90 p95 p99, over(varname, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("p-Values by Weather Metric (k=2,400; n=41,614)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`results'/pval_varname_rf.eps", as(eps) replace

graph bar (mean) p90 p95 p99, over(sat, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("p-Values by Satellite (k=5,600; n=41,614)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`results'/pval_sat_rf.eps", as(eps) replace

graph bar (mean) p90 p95 p99, over(ext, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("p-Values by Extraction Method (k=4,320; n=41,614)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`results'/pval_ext_rf.eps", as(eps) replace

graph bar (mean) p90 p95 p99, over(depvar, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("p-Values by Dependant Variable (k=21,600; n=41,614)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`results'/pval_depvar_rf.eps", as(eps) replace

graph bar (mean) p90 p95 p99, over(regname, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("p-Values by Specification (k=8,640; n=41,614)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`results'/pval_regname_rf.eps", as(eps) replace

graph bar (mean) p90 p95 p99, over(country, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("p-Values by Country (k=8,640; 12,960; n=41,614)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`results'/pval_country_rf.eps", as(eps) replace

*Country specific
graph bar (mean) p90 p95 p99 if country == 1, over(regname, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("Ethiopia p-Values by Specification (k=1,680; n=13,284)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`results'/eth_pval_regname.eps", as(eps) replace

graph bar (mean) p90 p95 p99 if country == 2, over(regname, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("Malawi p-Values by Specification (k=1,680; n=6,116)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`results'/mwi_pval_regname.eps", as(eps) replace

graph bar (mean) p90 p95 p99 if country == 5, over(regname, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("Nigeria p-Values by Specification (k=1,680; n=14,516)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`results'/nga_pval_regname.eps", as(eps) replace

graph bar (mean) p90 p95 p99 if country == 6, over(regname, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("Tanzania p-Values by Specification (k=1,680; n=7,698)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`results'/tza_pval_regname.eps", as(eps) replace
	
graph bar (mean) p90 p95 p99 if country == 1, over(sat, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("Ethiopia p-Values by Satellite (k=1,120; n=13,284)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`results'/eth_pval_sat_rf.eps", as(eps) replace

graph bar (mean) p90 p95 p99 if country == 2, over(sat, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("Malawi p-Values by Satellite (k=1,680; n=6,116)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`results'/mwi_pval_sat_rf.eps", as(eps) replace

graph bar (mean) p90 p95 p99 if country == 5, over(sat, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("Nigeria p-Values by Satellite (k=1,120; n=14,516)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`results'/nga_pval_sat_rf.eps", as(eps) replace

graph bar (mean) p90 p95 p99 if country == 6, over(sat, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("Tanzania p-Values by Satellite (k=1,680; n=7,698)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`results'/tza_pval_sat_rf.eps", as(eps) replace

* **********************************************************************
* 3 - end matter
* **********************************************************************

* close the log
	log	close

/* END */		