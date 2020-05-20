clear all

*attempting to clean Ethiopia household variables
global user "themacfreezie"

**********************************************************************************
**	ESS Wave 2 - Post Harvest Section 12
**********************************************************************************
*	Seems to roughly correspong to Malawi ag-modD and ag-modK

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_raw\Wave2_2013"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_refined\Wave2_2013"

*	Build conversion id into conversion dataset
use "`root'/Crop_CF_Wave2.dta"
generate conv_id = string(crop_code) + " " + string(unit_cd)
duplicates report
duplicates drop
duplicates report conv_id
*look at obs 67 & 68 - yet another weird problem =\
save "`root'/Crop_CF_Wave2_use.dta", replace
clear

use "`root'/sect12_ph_w2.dta", clear

*	Dropping duplicates
duplicates drop

*	Attempting to generate unique identifier
describe
sort holder_id crop_code
/*isid holder_id crop_code, missok*/
*	Like in Sect9 & Sect11, isid is not working for these variables alone
*	This wasn't an issue in Wave1

*creating unique region identifier
egen region_id = group( saq01 saq02)
label var region_id "Unique region identifier"

*	Like in Sect9, no crop codes are missing

