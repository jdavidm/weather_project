clear all

*attempting to clean Uganda household variables
global user "aljosephson"

**********************************************************************************
**	UNPS 2009 (Wave 1) - General(?) Section 1 
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2009"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2009"

use "`root'/2009_GSEC1", clear

isid HHID
rename HHID hhid

rename h1aq1 district
rename h1aq2b county
rename h1aq3b subcounty
rename h1aq4b parish
*	district variables not labeled in this wave, just coded

tab region, missing

keep hhid region district county subcounty parish

*creating unique region identifier
egen region_id = group( district county)
label var region_id "Unique region identifier"

*	Prepare for export
compress
describe
summarize 
sort region
save "`export'/2009_GSEC1", replace
