*building what we want
*15 July 2019

global user "jdmichler"

loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\results"
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\results\MW_temp"

*start generating data to create graphs
use "`root'/appended_cx_tp.dta", clear

*Convert loglike to positive weight
sort varname
gen llike = abs(1/loglike)
by varname, sort: egen llsum = total(llike)

gen wll = llike/llsum

gen b_var = wll*betatemp
gen ci_lo_s = wll*ci_lo
gen ci_up_s = wll*ci_up
by varname, sort: egen avg_ci_lo = mean(ci_lo_s)
by varname, sort: egen avg_ci_up = mean(ci_up_s)

*Generate CDFs of weighted betas
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
	graph export "`export'/cdf_temp_`l'_cx.png", as(png) replace
}

*Generate density plots of betas
levelsof varname, local(levels) 
foreach l of local levels {
	local v : label (varname) `l'
	twoway (kdensity betatemp if varname == `l'), ///
	xline(0, lpattern(solid) lcolor(maroon) lwidth(medium)) ///
	ylab(, grid) ytitle("Density") xlab(, grid) xtitle("Point Estimates") title("`v'")
	graph export "`export'/den_temp_`l'_cx.png", as(png) replace
}

*Generate p-values
gen p99 = 1 if pval <= 0.01
replace p99 = 0 if pval > 0.01
gen p95 = 1 if pval <= 0.05
replace p95 = 0 if pval > 0.05
gen p90 = 1 if pval <= 0.10
replace p90 = 0 if pval > 0.10

graph bar (mean) p90 p95 p99, over(varname, label(angle(45) labsize(vsmall)))yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("p-Values by Weather Metric") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`export'/pval_varname_tp_cx.png", as(png) replace

graph bar (mean) p90 p95 p99, over(sat, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("p-Values by Satellite") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`export'/pval_sat_tp_cx.png", as(png) replace

graph bar (mean) p90 p95 p99, over(ext, label(angle(45) labsize(vsmall)))yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("p-Values by Extraction Method") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`export'/pval_ext_tp_cx.png", as(png) replace

graph bar (mean) p90 p95 p99, over(depvar, label(angle(45) labsize(vsmall)))yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("p-Values by Dependant Variable") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`export'/pval_depvar_tp_cx.png", as(png) replace

graph bar (mean) p90 p95 p99, over(regname, label(angle(45) labsize(vsmall)))yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("p-Values by Specification") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`export'/pval_regname_tp_cx.png", as(png) replace

