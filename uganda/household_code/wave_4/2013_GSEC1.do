clear all

*attempting to clean Uganda household variables
global user "themacfreezie"

**********************************************************************************
**	UNPS 2013 (Wave 4) - General(?) Section 1 
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2013"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2013"

use "`root'/GSEC1", clear

isid HHID
rename HHID hhid

rename h1aq1a district
rename h1aq3a county_subcounty
rename h1aq4a parish

tab region, missing

keep hhid region district county_subcounty parish

*	Prepare for export
compress
describe
summarize 
sort region
save "`export'/2013_GSEC1", replace
