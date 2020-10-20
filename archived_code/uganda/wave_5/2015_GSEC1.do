clear all

*attempting to clean Uganda household variables
global user "themacfreezie"

**********************************************************************************
**	UNPS 2015 (Wave 5) - General(?) Section 1 
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2015"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2015"

use "`root'/GSEC1", clear

isid HHID
rename HHID hhid

rename subcounty_name subcounty
rename parish_name parish

tab region, missing

keep hhid region district subcounty parish

*	Prepare for export
compress
describe
summarize 
sort region
save "`export'/2015_GSEC1", replace
