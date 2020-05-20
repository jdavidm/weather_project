clear all

*attempting to clean Ethiopia household variables
global user "themacfreezie"

**********************************************************************************
**	ESS Wave 2 - Post Harvest Section 9
**********************************************************************************
*	Seems to roughly correspong to Malawi ag-modG and ag-modM

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

use "`root'/sect9_ph_w2.dta", clear

*	Dropping duplicates
duplicates drop

*	Attempting to generate unique identifier
describe
sort holder_id parcel_id field_id crop_code
isid holder_id parcel_id field_id crop_code, missok
*	Including  ph_s9q04_b_cf, 605 duplicates out of 30,180 obs
* 	See obs 584 & 585 - seem to be completely identical

*	creating unique district identifier
egen region_id = group( saq01 saq02)
label var region_id "Unique region identifier"

*	No missing crop codes in this wave =]

* Create conversion key 
generate conv_id = string(crop_code) + " " + string(ph_s9q04_b_cf)
merge m:1 conv_id using "`root'/Crop_CF_Wave2_use.dta"

