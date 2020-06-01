clear all

*attempting to clean Uganda household variables
global user "themacfreezie"

**********************************************************************************
**	UNPS 2010 (Wave 2) - General(?) Section 1 
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2010"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2010"

use "`root'/GSEC1", clear

isid HHID
rename HHID hhid

rename h1aq1 district
rename h1aq2b county
rename h1aq3b subcounty
rename h1aq4b parish

tab region, missing

keep hhid region district county subcounty parish

*	Prepare for export
compress
describe
summarize 
sort region
save "`export'/2010_GSEC1", replace
