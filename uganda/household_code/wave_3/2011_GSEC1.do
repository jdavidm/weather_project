clear all

*attempting to clean Uganda household variables
global user "themacfreezie"

**********************************************************************************
**	UNPS 2011 (Wave 3) - General(?) Section 1 
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2011"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2011"

use "`root'/GSEC1", clear

isid HHID
rename HHID hhid

rename h1aq1 district
rename h1aq2 county
rename h1aq3 subcounty
rename h1aq4 parish

tab region, missing

keep hhid region district county subcounty parish

*	Prepare for export
compress
describe
summarize 
sort region
save "`export'/2011_GSEC1", replace
