clear all

*attempting to clean Ethiopia household variables
global user "themacfreezie"

**********************************************************************************
**	ESS Wave 2 - Post Harvest Section 11
**********************************************************************************
*	Seems to roughly correspong to Malawi ag-modI and ag-modO

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_raw\Wave3_2015"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_refined\Wave3_2015"

*	Build conversion id into conversion dataset
use "`root'/Crop_CF_Wave3.dta"
generate conv_id = string(crop_code) + " " + string(unit_cd)
duplicates report
duplicates drop
duplicates report conv_id
*look at obs 67 & 68 - yet another weird problem =\
save "`root'/Crop_CF_Wave3_use.dta", replace
clear

use "`root'/sect11_ph_w3.dta", clear

*	Dropping duplicates
duplicates drop

*	Attempting to generate unique identifier
describe
sort holder_id crop_code
*	isid holder_id crop_code, missok

* Create conversion key 
generate conv_id = string(crop_code) + " " + string(ph_s11q03_b)
merge m:1 conv_id using "`root'/Crop_CF_Wave3_use.dta"

