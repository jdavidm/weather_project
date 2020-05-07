clear all

*attempting to clean Ethiopia household variables
global user "themacfreezie"

**********************************************************************************
**	ESS Wave 2 - Post Planting Section 5
**********************************************************************************
*	Seems to roughly correspong to Malawi ag-modH and ag-modN

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_raw\Wave3_2015"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_refined\Wave3_2015"

use "`root'/sect5_pp_w3.dta", clear

*	Dropping duplicates
duplicates drop

*	Unique identifier can only be generated including crop code as some fields are mixed (pp_s4q02)
describe
sort holder_id crop_code
/* isid holder_id crop_code pp_s5q01, missok */
*	Not providing a unique identifier - must investigate 
*	Field_id and parcel_id are not present - present in Wave1, isid works with these
*	Try this -  Duplicates tag holder_id crop_code pp_s5q01, generate (dupe)
*	Maybe look into 'collapse' command

* Drop observations with a missing field_id
summarize if missing(crop_code)
drop if missing(crop_code)
/* 	isid holder_id crop_code pp_s5q01, missok
	No unique identifier is easily found, there are weird differences in rows
	that are otehrwise completely identical
	duplicates list holder_id crop_code pp_s5q01
	the above command is useful for looking at this */

*investigate crop mix
tabulate crop_code, plot

* do we need any of this seed info?

rename household_id hhid
rename household_id2 hhid2
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
sort holder_id main_crop
save "`export'/sect5_pp_w3", replace
