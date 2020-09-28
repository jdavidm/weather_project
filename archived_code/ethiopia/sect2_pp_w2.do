clear all

*attempting to clean Ethiopia household variables
global user "themacfreezie"

**********************************************************************************
**	ESS Wave 2 - Post Planting Section 2 
**********************************************************************************
*	Seems to correspond to Malawi ag-modB and ag-modI

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_raw\Wave2_2013"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_refined\Wave2_2013"

use "`root'/sect2_pp_w2.dta", clear

*	Dropping duplicates
duplicates drop

*	Investigate unique identifier
describe
sort holder_id ea_id parcel_id
isid holder_id parcel_id, missok

*creating unique region identifier
egen region_id = group( saq01 saq02)
label var region_id "Unique region identifier"

* Drop observations with a missing parcel_id
summarize if missing(holder_id,ea_id,parcel_id)
drop if missing(holder_id,ea_id,parcel_id)
isid holder_id ea_id parcel_id

rename household_id hhid
rename household_id2 hhid2
rename saq01 district
rename saq02 region
rename saq03 ward
rename pp_s2q02 number_fields

*	Restrict to variables of interest
keep  holder_id- pp_s2q01 number_fields region_id
order holder_id- pp_s2q01 number_fields region_id

*	Prepare for export
compress
describe
summarize 
sort holder_id ea_id
save "`export'/sect2_pp_w2", replace
