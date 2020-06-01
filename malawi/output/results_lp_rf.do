*building what we want
*10 July 2019

global user "jdmichler"

loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\results"
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\results\MW_rain"

*start generating data to create graphs
use "`root'/appended_lp_rf.dta", clear

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

*Strip plot
stripplot betarain, over(sat) box(barw(0.8) blcolor(black)) msize(vtiny) mcolor(sea%30) ///
	centre cumul cumpr scheme(s1color) yla(, ang(h))


*Generate CDFs of weighted betas
by varname: cumul b_var, gen(cum)
/*
twoway	(line cum b_var if varname == 1) ///
		(line cum b_var if varname == 2) ///
		(line cum b_var if varname == 3) ///
		(line cum b_var if varname == 4) ///
		(line cum b_var if varname == 5) ///
		(line cum b_var if varname == 6) ///
		(line cum b_var if varname == 7) ///
		(line cum b_var if varname == 8) ///
		(line cum b_var if varname == 9) ///
		(line cum b_var if varname == 10) ///
		(line cum b_var if varname == 11) ///
		(line cum b_var if varname == 12) ///
		(line cum b_var if varname == 13) ///
		(line cum b_var if varname == 14, ///
	ylab(, grid) ytitle("CDF") xlab(, grid) xtitle("Weighted Point Estimates") title("")), ///
	legend(off) plotregion(margin(zero))

sort varname cum
levelsof varname, local(levels) 
foreach l of local levels {
	local v : label (varname) `l'
	twoway (line cum b_var if varname == `l', ///
	xline(0, lpattern(solid) lcolor(maroon) lwidth(medium)) ///
	ylab(, grid) ytitle("CDF") xlab(, grid) xtitle("Weighted Point Estimates") title("`v'")) ///
	(rarea avg_ci_lo avg_ci_up cum if varname == `l', hor sort color(gray%30) lwidth(none)), ///
	legend(off) plotregion(margin(zero))
	graph export "`export'/cdf_rain_`l'.png", as(png) replace
}

*Generate density plots of betas
levelsof varname, local(levels) 
foreach l of local levels {
	local v : label (varname) `l'
	twoway (kdensity betarain if varname == `l'), ///
	xline(0, lpattern(solid) lcolor(maroon) lwidth(medium)) ///
	ylab(, grid) ytitle("Density") xlab(, grid) xtitle("Point Estimates") title("`v'")
	graph export "`export'/den_rain_`l'.png", as(png) replace
}
*/
*Generate p-values
gen p99 = 1 if pval <= 0.01
replace p99 = 0 if pval > 0.01
gen p95 = 1 if pval <= 0.05
replace p95 = 0 if pval > 0.05
gen p90 = 1 if pval <= 0.10
replace p90 = 0 if pval > 0.10

graph bar (mean) p90 p95 p99, over(varname, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("Malawi p-Values by Weather Metric (k=720; n=6,116)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`export'/mwi_pval_varname_rf.png", as(png) replace

graph bar (mean) p90 p95 p99, over(sat, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("Malawi p-Values by Satellite (k=1,680; n=6,116)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`export'/mwi_pval_sat_rf.png", as(png) replace

graph bar (mean) p90 p95 p99, over(ext, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("Malawi p-Values by Extraction Method (k=1,008; n=6,116)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`export'/mwi_pval_ext_rf.png", as(png) replace

graph bar (mean) p90 p95 p99, over(depvar, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("Malawi p-Values by Dependant Variable (k=5,040; n=6,116)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`export'/mwi_pval_depvar_rf.png", as(png) replace

graph bar (mean) p90 p95 p99, over(regname, label(angle(45) labsize(vsmall))) yscale(r(0 1)) ///
	ylab(0 .2 .4 .6 .8 1, labsize(small)) ytitle("Share of Significant Point Estimates") title("Malawi p-Values by Specification (k=1,680; n=6,116)") ///
	legend(pos(12) col(3) label(1 "p>0.90") label(2 "p>0.95") label(3 "p>0.99"))
	graph export "`export'/mwi_pval_regname_rf.png", as(png) replace

