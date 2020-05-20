*building what we want
*10 July 2019

clear all
global user "jdmichler"

*Establish location of regression data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\results"

*Establish location of individual regression results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\results\MW_rain"

*start generating data to create graphs
use "`root'/appended_cx_rf.dta", clear

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
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("Malawi p-Values by Weather Metric (k=720; n=22,845)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`export'/mwi_pval_varname_rf_cx.png", as(png) replace

graph bar (mean) p90 p95 p99, over(sat, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("Malawi p-Values by Satellite (k=1,680; n=22,845)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`export'/mwi_pval_sat_rf_cx.png", as(png) replace

graph bar (mean) p90 p95 p99, over(ext, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("Malawi p-Values by Extraction Method (k=1,008; n=22,845)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`export'/mwi_pval_ext_rf_cx.png", as(png) replace

graph bar (mean) p90 p95 p99, over(depvar, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("Malawi p-Values by Dependant Variable (k=5,040; n=22,845)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`export'/mwi_pval_depvar_rf_cx.png", as(png) replace

graph bar (mean) p90 p95 p99, over(regname, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("Malawi p-Values by Specification (k=1,680; n=22,845)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`export'/mwi_pval_regname_rf_cx.png", as(png) replace

/*Generate CDFs of weighted betas
by varname: cumul b_var, gen(cum)

sort varname cum
levelsof varname, local(levels) 
foreach l of local levels {
	local v : label (varname) `l'
	twoway (line cum b_var if varname == `l', ///
	xline(0, lpattern(solid) lcolor(maroon) lwidth(medium)) ///
	ylab(, grid) ytitle("CDF") xlab(, grid) xtitle("Weighted Point Estimates") title("`v'")) ///
	(rarea avg_ci_lo avg_ci_up cum if varname == `l', hor sort color(gray%30) lwidth(none)), ///
	legend(off) plotregion(margin(zero))
	graph export "`export'/cdf_rain_`l'_cx.png", as(png) replace
}

*Generate density plots of betas
levelsof varname, local(levels) 
foreach l of local levels {
	local v : label (varname) `l'
	twoway (kdensity betarain if varname == `l'), ///
	xline(0, lpattern(solid) lcolor(maroon) lwidth(medium)) ///
	ylab(, grid) ytitle("Density") xlab(, grid) xtitle("Point Estimates") title("`v'")
	graph export "`export'/den_rain_`l'_cx.png", as(png) replace
}

