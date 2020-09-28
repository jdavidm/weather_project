clear all

*attempting to clean Ethiopia household variables
global user "themacfreezie"

**********************************************************************************
**	ESS Wave 1 - Post Harvest Section 9 
**********************************************************************************
*	Seems to very roughly correspond to Malawi ag-modG and ag-modM

* 	For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_raw\Wave1_2011"
* 	To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_refined\Wave1_2011"

use "`root'/sect9_ph_w1.dta", clear

*	Unique identifier can only be generated including crop code as some fields are mixed (pp_s4q02)
describe
sort holder_id parcel_id field_id crop_code
isid holder_id parcel_id field_id crop_code, missok

*	creating unique district identifier
egen region_id = group( saq01 saq02)
label var region_id "Unique region identifier"

*	Address missing crop codes - There are only 4
*	There are a lot more crop names missing than crop codes
*	Crop codes and crop names do not always match
*	When there's a mismatch we assume crop code is correct
*	If crop code is missing we use crop name
*	If both are missing we'll drop the observation
replace crop_code = 2 if crop_name == "MAIZE" & crop_code == . 
replace crop_code = 17 if crop_name == "GIBTO" & crop_code == . 
replace crop_code = 26 if crop_name == "RAPE SEED" & crop_code == . 

duplicates drop holder_id parcel_id field_id crop_code, force

*	Look at this please
isid holder_id parcel_id field_id crop_code
*	These five variables don't uniquely identify an obsevation. 


*	Creating harvest (kg) based on self reported values
*	If self reported values are missing, we will attempt to replace with dried cutting weight
*	Will require data merging from another section (I believe sect3_pp_w1)
replace ph_s9q12_a = 0 if ph_s9q12_a == . & ph_s9q12_b != .
replace ph_s9q12_b = 0 if ph_s9q12_b == . & ph_s9q12_a != .
generate harv = ph_s9q12_a + 0.001*ph_s9q12_b
bysort holder_id parcel_id field_id crop_code : egen harvest = sum(harv)

*	Dry weight (kg) based on crop-cut values
replace ph_s9q05_a = 0 if ph_s9q05_a == . & ph_s9q05_b != .
replace ph_s9q05_b = 0 if ph_s9q05_b == . & ph_s9q05_a != .
generate dry_wgt = ph_s9q05_a + 0.001*ph_s9q05_b

*	merging in data from sect3_pp_w1
*	First we need to create a merge variable
generate field_ident = holder_id + " " + string(parcel_id) + " " + string(field_id)
merge m:1 field_ident using "`export'/sect3_pp_w1.dta"

*	Weird results! Sect9 apparently has fewer obs than sect3 =\
*	Look at this
sort field_ident _merge
order field_ident _merge status crop_code

save "`export'/sect9_ph_w1v2", replace
