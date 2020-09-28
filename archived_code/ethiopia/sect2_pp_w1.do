clear all

*attempting to clean Ethiopia household variables
global user "themacfreezie"

**********************************************************************************
**	ESS Wave 1 - Post Planting Section 2 
**********************************************************************************
*	Seems to correspond to Malawi ag-modB and ag-modI

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_raw\Wave1_2011"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_refined\Wave1_2011"

use "`root'/sect2_pp_w1.dta", clear

*	Unique identifier can only be generated including crop code as some fields are mixed (pp_s4q02)
describe
sort holder_id ea_id parcel_id
isid holder_id ea_id parcel_id, missok

* Drop observations with a missing field_id
summarize if missing(holder_id,household_id,ea_id,parcel_id)
drop if missing(holder_id,household_id,ea_id,parcel_id)
isid holder_id household_id ea_id parcel_id

*creating unique region identifier
egen region_id = group( saq01 saq02)
label var region_id "Unique region identifier"

rename household_id hhid
rename saq01 district
rename saq02 region
rename saq03 ward
rename pp_s2q02 number_fields

*	Restrict to variables of interest
keep  holder_id- number_fields region_id
order holder_id- number_fields region_id

*	Prepare for export
compress
describe
summarize 
sort holder_id ea_id
save "`export'/sect2_pp_w1", replace
