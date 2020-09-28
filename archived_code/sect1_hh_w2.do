clear all

*attempting to clean Ethiopia household variables
global user "themacfreezie"

**********************************************************************************
**	ESS Wave 2 - Household Section 1 
**********************************************************************************
*	Seems to very roughly correspond to Malawi ag-modI and ag-modO

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_raw\Wave2_2013"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_refined\Wave2_2013"

use "`root'/sect1_hh_w2.dta", clear

*	Dropping duplicates
duplicates drop

*	Individual_id2 is unique identifier 
describe
sort household_id2 individual_id2
isid individual_id2, missok

*creating unique region identifier
egen region_id = group( saq01 saq02)
label var region_id "Unique region identifier"

*	Restrict to variables of interest
keep  household_id- saq08 region_id
order household_id- saq08

*	I am uncertain about how to handle the above! Please advise! 
rename household_id hhid
rename household_id2 hhid2
rename saq01 district
rename saq02 region
rename saq03 ward

*	Prepare for export
compress
describe
summarize 
sort hhid ea_id
save "`export'/sect1_hh_w2", replace
