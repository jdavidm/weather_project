clear all

*attempting to clean Ethiopia household variables
global user "themacfreezie"

**********************************************************************************
**	ESS Wave 1 - Post Planting Section 5 
**********************************************************************************
*	Seems to roughly correspong to Malawi ag-modH and ag-modN

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_raw\Wave1_2011"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_refined\Wave1_2011"

use "`root'/sect5_pp_w1.dta", clear

*	Unique identifier can only be generated including crop code as some fields are mixed 
describe
sort holder_id parcel_id field_id crop_code
isid holder_id parcel_id field_id crop_code, missok

* Drop observations with a missing field_id
summarize if missing(parcel_id,field_id,crop_code)
drop if missing(parcel_id,field_id,crop_code)
isid holder_id parcel_id field_id crop_code

*investigate crop mix
tabulate crop_name, plot

* do we need any of this seed info?

rename household_id hhid
rename saq01 district
rename saq02 region
rename saq03 ward
rename crop_code main_crop

*	Restrict to variables of interest
keep  holder_id- main_crop
order holder_id- main_crop

*	Prepare for export
compress
describe
summarize 
sort holder_id parcel_id field_id
save "`export'/sect5_pp_w1", replace
