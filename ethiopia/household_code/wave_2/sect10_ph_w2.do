clear all

*attempting to clean Ethiopia household variables
global user "themacfreezie"

**********************************************************************************
**	ESS Wave 2 - Post Harvest Section 10
**********************************************************************************
*	Seems to roughly correspong to Malawi ag-modD and ag-modK

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_raw\Wave2_2013"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_refined\Wave2_2013"

use "`root'/sect10_ph_w2.dta", clear

*	Dropping duplicates
duplicates drop

*	Unique identifier can only be generated including crop code as some fields are mixed
describe
sort holder_id parcel_id field_id crop_code
isid holder_id parcel_id field_id crop_code, missok

* Drop observations with a missing field_id
summarize if missing(parcel_id,field_id,crop_code)
drop if missing(parcel_id,field_id,crop_code)
isid holder_id parcel_id field_id crop_code

*creating unique region identifier
egen region_id = group( saq01 saq02)
label var region_id "Unique region identifier"

*	Totaling hired labor/free labor
generate hired_labor_m = ph_s10q01_a * ph_s10q01_b
generate hired_labor_f = ph_s10q01_d * ph_s10q01_e
generate hired_labor_c = ph_s10q01_g * ph_s10q01_h
generate hired_labor = hired_labor_m + hired_labor_f + hired_labor_c
drop hired_labor_m hired_labor_f hired_labor_c

generate free_labor_m = ph_s10q03_a * ph_s10q03_b
generate free_labor_f = ph_s10q03_c * ph_s10q03_d
generate free_labor_c = ph_s10q03_e * ph_s10q03_f
generate free_labor = free_labor_m + free_labor_f + free_labor_c
drop free_labor_m free_labor_f free_labor_c

generate non_hh_labor = hired_labor + free_labor
drop hired_labor free_labor

*	Totaling household labor
generate hh_member_1 = ph_s10q02_b * ph_s10q02_c
generate hh_member_2 = ph_s10q02_f * ph_s10q02_g
generate hh_member_3 = ph_s10q02_j * ph_s10q02_k
generate hh_member_4 = ph_s10q02_n * ph_s10q02_o
generate hh_member_5 = ph_s10q02_r * ph_s10q02_s
generate hh_member_6 = ph_s10q02_v * ph_s10q02_w
generate hh_member_7 = ph_s10q02_z * ph_s10q02_ka
generate hh_member_8 = ph_s10q02_na * ph_s10q02_oa
generate hh_labor = hh_member_1 + hh_member_2 + hh_member_3 + hh_member_4 + hh_member_5 + hh_member_6 + hh_member_7 + hh_member_8
drop hh_member_1 hh_member_2 hh_member_3 hh_member_4 hh_member_5 hh_member_6 hh_member_7 hh_member_8

*	Total labor
generate labordays_harv = hh_labor + non_hh_labor
drop hh_labor non_hh_labor
label var labordays_harv "Total Days of Harvest Labor - Household and Hired"

rename household_id hhid
rename household_id2 hhid2
rename saq01 district
rename saq02 region
rename saq03 ward
rename crop_code main_crop

*	Restrict to variables of interest
keep  holder_id- main_crop labordays_harv
order holder_id- main_crop

*	Prepare for export
compress
describe
summarize 
sort holder_id ea_id
save "`export'/sect10_ph_w2", replace
