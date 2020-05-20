*building what we want
*10 July 2019
*17 July 2019

global user "jdmichler"

loc root = "C:\Users/$user\Dropbox\Weather_Project\results"
loc export = "C:\Users/$user\Dropbox\Weather_Project\results\MW_combo"

*start generating data to create graphs
use "`root'/appended_lp_rf.dta", clear

append using "`root'/appended_lp_tp.dta"
append using "`root'/appended_lp_combo.dta"

*Generate p-values
gen p99s = 1 if pval <= 0.01
	replace p99s = 0 if pval > 0.01
	replace p99s = . if pval == .
gen p95s = 1 if pval <= 0.05
	replace p95s = 0 if pval > 0.05
	replace p95s = . if pval == .
gen p90s = 1 if pval <= 0.10
	replace p90s = 0 if pval > 0.10
	replace p90s = . if pval == .

forvalues i=1/3 {
	gen p99`i'rain = 1 if pval`i'rain <= 0.01
		replace p99`i'rain = 0 if pval`i'rain > 0.01
		replace p99`i'rain = . if pval`i'rain == .
	gen p95`i'rain = 1 if pval`i'rain <= 0.05
		replace p95`i'rain = 0 if pval`i'rain > 0.05
		replace p95`i'rain = . if pval`i'rain == .
	gen p90`i'rain = 1 if pval`i'rain <= 0.10
		replace p90`i'rain = 0 if pval`i'rain > 0.10
		replace p90`i'rain = . if pval`i'rain == .
	
	gen p99`i'temp = 1 if pval`i'temp <= 0.01
		replace p99`i'temp = 0 if pval`i'temp > 0.01
		replace p99`i'temp = . if pval`i'temp == .
	gen p95`i'temp = 1 if pval`i'temp <= 0.05
		replace p95`i'temp = 0 if pval`i'temp > 0.05
		replace p95`i'temp = . if pval`i'temp == .
	gen p90`i'temp = 1 if pval`i'temp <= 0.10
		replace p90`i'temp = 0 if pval`i'temp > 0.10
		replace p90`i'temp = . if pval`i'temp == .
	}
		
egen p99 = rowtotal(p99*)
egen p95 = rowtotal(p95*)
egen p90 = rowtotal(p90*)

replace p99 = p99/2 if varname == 23 | varname == 26 | varname == 27 | varname == 28
replace p99 = p99/4 if varname == 24
replace p99 = p99/6 if varname == 25

replace p95 = p95/2 if varname == 23 | varname == 26 | varname == 27 | varname == 28
replace p95 = p95/4 if varname == 24
replace p95 = p95/6 if varname == 25

replace p90 = p90/2 if varname == 23 | varname == 26 | varname == 27 | varname == 28
replace p90 = p90/4 if varname == 24
replace p90 = p90/6 if varname == 25

graph bar (mean) p90 p95 p99 if varname > 22, ///
	over(varname, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("p-Values by Weather Metric (k=1,080; n=6,116)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`export'/pval_varname_combo.png", as(png) replace

graph bar (mean) p90 p95 p99 if varname == 1 | varname == 15 | varname == 23, ///
	over(varname, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("p-Values by Weather Metric (k=720; 360; 1,080; n=6,116)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`export'/pval_mean_combo.png", as(png) replace

graph bar (mean) p90 p95 p99 if varname == 2 | varname == 16 | varname == 26, ///
	over(varname, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("p-Values by Weather Metric (k=720; 360; 1,080; n=6,116)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`export'/pval_median_combo.png", as(png) replace

graph bar (mean) p90 p95 p99 if varname == 5 | varname == 19 | varname == 27, ///
	over(varname, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("p-Values by Weather Metric (k=720; 360; 1,080; n=6,116)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`export'/pval_total_combo.png", as(png) replace

graph bar (mean) p90 p95 p99 if varname == 7 | varname == 21 | varname == 28, ///
	over(varname, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("p-Values by Weather Metric (k=720; 360; 1,080; n=6,116)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`export'/pval_zscore_combo.png", as(png) replace
		
graph bar (mean) p90 p95 p99, over(sat1, label(angle(45) labsize(vsmall))) over(sat2, label(labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("p-Values by Satellite (k=1,080; n=6,116)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`export'/pval_sat_combo.png", as(png) replace
