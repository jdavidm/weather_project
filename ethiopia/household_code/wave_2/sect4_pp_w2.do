clear all

*attempting to clean Ethiopia household variables
global user "themacfreezie"

**********************************************************************************
**	ESS Wave 2 - Post Planting Section 4
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_raw\Wave2_2013"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_refined\Wave2_2013"

use "`root'/sect4_pp_w2.dta", clear

*	Renaming and dropping duplicates
duplicates drop

*	Unique identifier can only be generated including crop code as some fields are mixed (pp_s4q02)
describe
sort holder_id parcel_id field_id crop_code
isid holder_id parcel_id field_id crop_code, missok

* Drop observations with a missing field_id/crop_code
summarize if missing(parcel_id,field_id,crop_code)
drop if missing(parcel_id,field_id,crop_code)
isid holder_id parcel_id field_id crop_code

*	Accounting for mixed use fields - creates a multiplier
generate field_prop = 1 if pp_s4q02 == 1
replace field_prop = pp_s4q03*.01 if pp_s4q02 ==2

*	Looking at crop damage prevention measures
generate pesticide_any = pp_s4q05 if pp_s4q05 >= 1
generate herbicide_any = pp_s4q06 if pp_s4q06 >= 1
replace herbicide_any = pp_s4q07 if pp_s4q06 != 1 & pp_s4q07 >= 1

*	pp_s4q12_a and pp_s4q12_b give month and year seeds were planted. The years for some reason mostly say 2005. 
*	I don't think this is of interest to us anyway.

rename household_id hhid
rename household_id2 hhid2
rename saq01 district
rename saq02 region
rename saq03 ward
rename crop_code main_crop

*	Restrict to variables of interest
keep  holder_id- pp_s4q01_b pesticide_any herbicide_any field_prop
order holder_id- saq05

*	Prepare for export
compress
describe
summarize 
sort holder_id parcel_id field_id
save "`export'/sect4_pp_w2", replace
