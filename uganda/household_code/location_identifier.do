clear all

*attempting to clean Uganda household variables
global user "themacfreezie"

**********************************************************************************
** Location Identifier
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2010"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2010"

use "`root'\2010_AGSEC5A.dta", clear

rename a5aq6e month_5A_wv2
rename HHID hhid
keep if cropID == 130 | cropID == 141 | cropID == 150 | cropID == 210 | cropID == 310

merge m:1 hhid using "C:\Users\themacfreezie\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2010/2010_GSEC1"
drop if _merge == 2
drop _merge

gen crop = 1 if cropID == 210 | cropID == 310
replace crop = 0 if crop == .

collapse month, by(crop district region)

sort crop region

hist month if crop == 1, by(region)
graph save Graph "C:\Users\themacfreezie\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\beans_month_5A_2010.gph", replace

hist month if crop == 0, by(region)
graph save Graph "C:\Users\themacfreezie\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\cereal_month_5A_2010.gph", replace

compress
describe
summarize 
save "`export'/2010_5A_district", replace

clear

use "`root'\2010_AGSEC5B.dta", clear

rename a5bq6e month_5B_wv2
rename HHID hhid
keep if cropID == 130 | cropID == 141 | cropID == 150 | cropID == 210 | cropID == 310

merge m:1 hhid using "C:\Users\themacfreezie\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2010/2010_GSEC1"
drop if _merge == 2
drop _merge

gen crop = 1 if cropID == 210 | cropID == 310
replace crop = 0 if crop == .

collapse month, by(crop district region)

sort crop region

hist month if crop == 1, by(region)
graph save Graph "C:\Users\themacfreezie\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\beans_month_5B_2010.gph", replace

hist month if crop == 0, by(region)
graph save Graph "C:\Users\themacfreezie\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\cereal_month_5B_2010.gph", replace

compress
describe
summarize 
save "`export'/2010_5B_district", replace

clear 

global user "themacfreezie"

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2011"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2011"

use "`root'\2011_AGSEC5A.dta", clear

rename a5aq6e month_5A_wv3
tostring HHID, generate(hhid) format(%022.0g) force
keep if cropID == 130 | cropID == 141 | cropID == 150 | cropID == 210 | cropID == 310

merge m:1 hhid using "C:\Users\themacfreezie\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2011/2011_GSEC1"
drop if _merge == 2
drop if _merge == 1
drop _merge
* couldn't match 169 from master, hhs appear not to be in GSEC1

gen crop = 1 if cropID == 210 | cropID == 310
replace crop = 0 if crop == .

collapse month, by(crop district region)

sort crop region

hist month if crop == 1, by(region)
graph save Graph "C:\Users\themacfreezie\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\beans_month_5A_2011.gph", replace

hist month if crop == 0, by(region)
graph save Graph "C:\Users\themacfreezie\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\cereal_month_5A_2011.gph", replace

compress
describe
summarize 
save "`export'/2011_5A_district", replace

clear

use "`root'\2011_AGSEC5B.dta", clear

rename a5bq6e month_5B_wv3
tostring HHID, generate(hhid) format(%022.0g) force
keep if cropID == 130 | cropID == 141 | cropID == 150 | cropID == 210 | cropID == 310

merge m:1 hhid using "C:\Users\themacfreezie\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2011/2011_GSEC1"
drop if _merge == 2
drop if _merge == 1
drop _merge
* couldn't match 80 from master, hhs appear not to be in GSEC1

gen crop = 1 if cropID == 210 | cropID == 310
replace crop = 0 if crop == .

collapse month, by(crop district region)

sort crop region

hist month if crop == 1, by(region)
graph save Graph "C:\Users\themacfreezie\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\beans_month_5B_2011.gph", replace

hist month if crop == 0, by(region)
graph save Graph "C:\Users\themacfreezie\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\cereal_month_5B_2011.gph", replace
*the distributions in these histograms look less conclusive than in the other waves

compress
describe
summarize 
save "`export'/2011_5B_district", replace
