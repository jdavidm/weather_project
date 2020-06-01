clear all
set more off
set maxvar 20000

discard

global user "jdmichler"

loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\Results"

loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\Results\Boxplot_test"

local fileList : dir "`root'" files "appended_lp_rf.dta"
	foreach file in `fileList' {
		use `root'/`file'

local tpe = "Cross-sectional" 
if substr("`file'", 10, 1) == "l" local tpe = "Malawi"
		
loc variables depvar regname sat ext varname

label variable depvar "Dependent Variable"
label variable regname "Regression Type"
label variable sat "Satellite System"
label variable ext "Extraction Method"
label variable varname "Temperature Variable"

foreach var in `variables' {

local lbl `:var label `var''

	graph hbox betarain, over (`var') nooutside ///
		ytitle (Point Estimates) ///
		title("Point Estimates by `lbl' (`tpe')", alignment(middle)) ///
		box(1, fcolor(reddish%50) lcolor(reddish)) 
	loc name = substr("`file'", 10, 5)
	graph export "`export'\Boxplots/mwi_`name'_`var'_boxplot.eps", as(eps) replace
	
	}	
	}
	
clear all 

local fileList : dir "`root'" files "appended_lp_tp.dta"
	foreach file in `fileList' {
		use `root'/`file'

local tpe = "Cross-sectional" 
if substr("`file'", 10, 1) == "l" local tpe = "Malawi"

loc variables depvar regname sat ext varname

label variable depvar "Dependent Variable"
label variable regname "Regression Type"
label variable sat "Satellite System"
label variable ext "Extraction Method"
label variable varname "Temperature Variable"

foreach var in `variables' {

local lbl `:var label `var''

	graph hbox betatemp, over (`var') nooutside ///
		ytitle (Point Estimates) ///
		title("Point Estimates by `lbl' (`tpe')", alignment(middle)) ///
		box(1, fcolor(reddish%50) lcolor(reddish)) 
	
	loc name = substr("`file'", 10, 5)
	graph export "`export'\Boxplots/mwi_`name'_`var'_boxplot.eps", as(eps) replace
	
	}	
	}
/*
clear all

local fileList : dir "`root'" files "appended_lp_combo.dta"
	foreach file in `fileList' {
		use `root'/`file'

egen scb =concat(sat1 sat2)
	destring scb, replace
	
gen satcmb =(scb)
	
label define satcmb 11 "Rainfall 1, Temperature 1" ///
					 12 "Rainfall 1, Temperature 2" ///
					 13 "Rainfall 1, Temperature 3" ///
					 21 "Rainfall 2, Temperature 1" ///
					 22 "Rainfall 2, Temperature 2" ///
					 23 "Rainfall 2, Temperature 3" ///
					 31 "Rainfall 3, Temperature 1" ///
					 32 "Rainfall 3, Temperature 2" ///
					 33 "Rainfall 3, Temperature 3" ///
					 41 "Rainfall 4, Temperature 1" ///
					 42 "Rainfall 4, Temperature 2" ///
					 43 "Rainfall 4, Temperature 3" ///
					 51 "Rainfall 5, Temperature 1" ///
					 52 "Rainfall 5, Temperature 2" ///
					 53 "Rainfall 5, Temperature 3" ///
					 61 "Rainfall 6, Temperature 1" ///
					 62 "Rainfall 6, Temperature 2" ///
					 63 "Rainfall 6, Temperature 3"
lab values scb satcmb
drop satcmb
rename scb satcmb
		
loc variables depvar regname sat1 sat2 satcmb ext varname

label variable depvar "Dependent Variable"
label variable regname "Regression Type"
label variable sat1 "Rainfall Satellite"
label variable sat2 "Temperature Satellite"
label variable satcmb "Satellite System Combination"
label variable ext "Extraction Method"
label variable varname "Rainfall Variable"

foreach var in `variables' {

local lbl `:var label `var''

	graph hbox beta1rain, over (`var') nooutside ///
		ytitle (Betarain) ///
		title("Betarain by `lbl'", alignment(middle)) ///
		box(1, fcolor(bluishgray)) 
	graph export "`export'\Boxplots/combo_`var'_rain_boxplot.png", as(png) replace
	
		graph hbox beta1temp, over (`var') nooutside ///
		ytitle (Betatemp) ///
		title("Betatemp by `lbl'", alignment(middle)) ///
		box(1, fcolor(bluishgray)) 
	graph export "`export'\Boxplots/combo_`var'_temp_boxplot.png", as(png) replace
	
	}	
	}

clear all	
	
local fileList : dir "`root'" files "appended_*_rf.dta"
	foreach file in `fileList' {
		use `root'/`file'

local tpe = "Cross-sectional" 
if substr("`file'", 10, 1) == "l" local tpe = "Long Panel"		
		
loc variables depvar regname sat ext varname

label variable depvar "Dependent Variable"
label variable regname "Regression Type"
label variable sat "Satellite System"
label variable ext "Extraction Method"
label variable varname "Rainfall Variable"

foreach var in `variables' {

local lbl `:var label `var''

	vioplot betarain, over (`var') bwidth (2) ///
		noylabel ///
		xscale(r(-20 20)) /// *not working
		hor obs(alt) ///
		xtitle (Betarain) ///
		title("Betarain by `lbl' (`tpe')") ///
		bar(color(black)) density(color(bluishgray)) line(color(midblue)) median(color(red))
	
	loc name = substr("`file'", 10, 5)
	graph export "`export'\Vioplots/`name'_`var'_vioplot.png", as(png) replace
	
	}	
	}
	
clear all 

local fileList : dir "`root'" files "appended_*_tp.dta"
	foreach file in `fileList' {
		use `root'/`file'

local tpe = "Cross-sectional" 
if substr("`file'", 10, 1) == "l" local tpe = "Long Panel"		
		
loc variables depvar regname sat ext varname

label variable depvar "Dependent Variable"
label variable regname "Regression Type"
label variable sat "Satellite System"
label variable ext "Extraction Method"
label variable varname "Temperature Variable"

foreach var in `variables' {

local lbl `:var label `var''

	vioplot betatemp, over (`var') bwidth (2) ///
		noylabel ///
		hor obs(alt) ///
		xtitle (Betatemp) ///
		title("Betatemp by `lbl' (`tpe')") ///
		bar(color(black)) density(color(bluishgray)) line(color(midblue)) median(color(red))
	
	loc name = substr("`file'", 10, 5)
	graph export "`export'\Vioplots/`name'_`var'_vioplot.png", as(png) replace
	
	}	
	}
	
clear all

local fileList : dir "`root'" files "appended_lp_combo.dta"
	foreach file in `fileList' {
		use `root'/`file'

egen scb =concat(sat1 sat2)
	destring scb, replace
	
gen satcmb =(scb)
	
label define satcmb 11 "Rainfall 1, Temperature 1" ///
					 12 "Rainfall 1, Temperature 2" ///
					 13 "Rainfall 1, Temperature 3" ///
					 21 "Rainfall 2, Temperature 1" ///
					 22 "Rainfall 2, Temperature 2" ///
					 23 "Rainfall 2, Temperature 3" ///
					 31 "Rainfall 3, Temperature 1" ///
					 32 "Rainfall 3, Temperature 2" ///
					 33 "Rainfall 3, Temperature 3" ///
					 41 "Rainfall 4, Temperature 1" ///
					 42 "Rainfall 4, Temperature 2" ///
					 43 "Rainfall 4, Temperature 3" ///
					 51 "Rainfall 5, Temperature 1" ///
					 52 "Rainfall 5, Temperature 2" ///
					 53 "Rainfall 5, Temperature 3" ///
					 61 "Rainfall 6, Temperature 1" ///
					 62 "Rainfall 6, Temperature 2" ///
					 63 "Rainfall 6, Temperature 3"
lab values scb satcmb
drop satcmb
rename scb satcmb

loc variables depvar regname sat1 sat2 satcmb ext varname

label variable depvar "Dependent Variable"
label variable regname "Regression Type"
label variable sat1 "Rainfall Satellite"
label variable sat2 "Temperature Satellite"
label variable satcmb "Satellite System Combination"
label variable ext "Extraction Method"
label variable varname "Rainfall Variable"

foreach var in `variables' {

local lbl `:var label `var''

	vioplot beta1rain, over (`var') bwidth (2) ///
		noylabel ///
		hor obs(alt) ///
		xtitle (Betarain) ///
		title("Betarin by `lbl'") ///
		bar(color(black)) density(color(bluishgray)) line(color(midblue)) median(color(red))
	graph export "`export'\Vioplots/combo_`var'_rain_vioplot.png", as(png) replace
	
	vioplot beta1temp, over (`var') bwidth (2) ///
		noylabel ///
		hor obs(alt) ///
		xtitle (Betatemp) ///
		title("Betatemp by `lbl'") ///
		bar(color(black)) density(color(bluishgray)) line(color(midblue)) median(color(red))
	graph export "`export'\Vioplots/combo_`var'_temp_vioplot.png", as(png) replace
	
	}	
	}

clear all	

local fileList : dir "`root'" files "appended_*_rf.dta"
	foreach file in `fileList' {
		use `root'/`file'

local tpe = "Cross-sectional" 
if substr("`file'", 10, 1) == "l" local tpe = "Long Panel"		
		
loc variables depvar regname sat ext varname

label variable depvar "Dependent Variable"
label variable regname "Regression Type"
label variable sat "Satellite System"
label variable ext "Extraction Method"
label variable varname "Rainfall Variable"

foreach var in `variables' {

local lbl `:var label `var''

	stripplot betarain, over (`var') ///
		box(fcolor(bluishgray) lwidth(thin)) ///
		pctile(0) whiskers(lwidth(vthin)) ///
		mcolor(red%05) ///
		xtitle (Betarain) ///
		title("Betarain by `lbl' (`tpe')") ///
	
	loc name = substr("`file'", 10, 5)
	graph export "`export'\Stripplots/`name'_`var'_strplot.png", as(png) replace
	
	}	
	}
	
clear all 

local fileList : dir "`root'" files "appended_*_tp.dta"
	foreach file in `fileList' {
		use `root'/`file'

local tpe = "Cross-sectional" 
if substr("`file'", 10, 1) == "l" local tpe = "Long Panel"		
		
loc variables depvar regname sat ext varname

label variable depvar "Dependent Variable"
label variable regname "Regression Type"
label variable sat "Satellite System"
label variable ext "Extraction Method"
label variable varname "Temperature Variable"

foreach var in `variables' {

local lbl `:var label `var''

	stripplot betatemp, over (`var') ///
		box(fcolor(bluishgray) lwidth(thin)) ///
		pctile(0) whiskers(lwidth(vthin)) ///
		mcolor(red%05) ///
		xtitle (Betatemp) ///
		title("Betatemp by `lbl' (`tpe')") ///
	
	loc name = substr("`file'", 10, 5)
	graph export "`export'\Stripplots/`name'_`var'_strplot.png", as(png) replace
	
	}	
	}
	
clear all

local fileList : dir "`root'" files "appended_lp_combo.dta"
	foreach file in `fileList' {
		use `root'/`file'

egen scb =concat(sat1 sat2)
	destring scb, replace
	
gen satcmb =(scb)
	
label define satcmb 11 "Rainfall 1, Temperature 1" ///
					 12 "Rainfall 1, Temperature 2" ///
					 13 "Rainfall 1, Temperature 3" ///
					 21 "Rainfall 2, Temperature 1" ///
					 22 "Rainfall 2, Temperature 2" ///
					 23 "Rainfall 2, Temperature 3" ///
					 31 "Rainfall 3, Temperature 1" ///
					 32 "Rainfall 3, Temperature 2" ///
					 33 "Rainfall 3, Temperature 3" ///
					 41 "Rainfall 4, Temperature 1" ///
					 42 "Rainfall 4, Temperature 2" ///
					 43 "Rainfall 4, Temperature 3" ///
					 51 "Rainfall 5, Temperature 1" ///
					 52 "Rainfall 5, Temperature 2" ///
					 53 "Rainfall 5, Temperature 3" ///
					 61 "Rainfall 6, Temperature 1" ///
					 62 "Rainfall 6, Temperature 2" ///
					 63 "Rainfall 6, Temperature 3"
lab values scb satcmb
drop satcmb
rename scb satcmb

loc variables depvar regname sat1 sat2 satcmb ext varname

label variable depvar "Dependent Variable"
label variable regname "Regression Type"
label variable sat1 "Rainfall Satellite"
label variable sat2 "Temperature Satellite"
label variable satcmb "Satellite System Combination"
label variable ext "Extraction Method"
label variable varname "Rainfall Variable"

foreach var in `variables' {

local lbl `:var label `var''

	stripplot beta1rain, over (`var') ///
		box(fcolor(bluishgray) lwidth(thin)) ///
		pctile(0) whiskers(lwidth(vthin)) ///
		mcolor(red%05) ///
		xtitle (Betarain) ///
		title("Betarain by `lbl' (Long Panel)")
	graph export "`export'\Stripplots/combo_`var'_rain_strplot.png", as(png) replace
		
	stripplot beta1temp, over (`var') ///
		box(fcolor(bluishgray) lwidth(thin)) ///
		pctile(0) whiskers(lwidth(vthin)) ///
		mcolor(red%05) ///
		xtitle (Betatemp) ///
		title("Betatemp by `lbl' (Long Panel)")
	graph export "`export'\Stripplots/combo_`var'_temp_strplot.png", as(png) replace
	
	}	
	}
