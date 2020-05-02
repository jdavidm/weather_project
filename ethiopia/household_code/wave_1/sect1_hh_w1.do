clear all

*attempting to clean Ethiopia household variables
global user "themacfreezie"

**********************************************************************************
**	ESS Wave 1 - Household Section 1 
**********************************************************************************
*	Seems to very roughly correspond to Malawi ag-modI and ag-modO

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_raw\Wave1_2011"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_refined\Wave1_2011"

use "`root'/sect1_hh_w1.dta", clear

describe
sort household_id individual_id
isid individual_id, missok

/*
* Drop observations with a missing field_id
summarize if missing()
drop if missing()
isid household_id individual_id
*/

*creating unique region identifier
egen region_id = group( saq01 saq02)
label var region_id "Unique region identifier"

*	Restrict to variables of interest
keep  household_id- saq08 region_id
order household_id- saq08

rename household_id hhid
rename individual_id indiv_id
rename saq01 district
rename saq02 region
rename saq03 ward

*	Prepare for export
compress
describe
summarize 
sort hhid ea_id
save "`export'/sect1_hh_w1", replace
