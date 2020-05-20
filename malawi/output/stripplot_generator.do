clear all
set more off
set maxvar 20000

discard

global user "themacfreezie"

loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\Results"

loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\Results\Boxplot_test"

local fileList : dir "`root'" files "appended_cx_rf.dta"
	foreach file in `fileList' {
		use `root'/`file'

loc variables depvar regname sat ext varname

label variable depvar "Dependent Variable"
label variable regname "Regression Type"
label variable sat "Satellite System"
label variable ext "Extraction Method"
label variable varname "Rainfall Variable"

foreach var in `variables' {

local lbl `:var label `var''

stripplot betarain, over(`var') box(barw(0.1)) pct(0.1) boffset(-0.15)  vertical stack height(0.4)

}
}
