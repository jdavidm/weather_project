clear all

*attempting to clean Uganda household variables
global user "themacfreezie"

**********************************************************************************
**	UNPS 2013 (Wave 4) - Agriculture Section 4B
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2013"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2013"

use "`root'/2013_AGSEC4B", clear

*	crop names and seed types. 2nd visit

*	Unique identifier can only be generated with parcel and plot
describe
sort HHID parcelID plotID cropID
*	isid HHID parcelID plotID cropID, missok
*	the above is not unique, let's see...
duplicates report HHID parcelID plotID cropID
* 	6 duplicates
* 	will proceed for now

*	stringing household IDs
tostring HHID, generate(hhid) format(%016.0f) force
duplicates report hhid parcelID plotID cropID

*	Create unique parcel identifier
generate parcel_id = hhid + " " + string(parcelID)
generate plot_id = hhid + " " + string(parcelID) + " " + string(plotID)
generate crop_id = hhid + " " + string(parcelID) + " " + string(plotID) + " " + string(cropID)
duplicates report crop_id

rename cropID crop_code
rename a4bq8 crop_sys 		// Purestand or mixed
tabulate crop_sys, missing 	// 36 obs are missing
rename a4bq9 mixedcrop_pct	// Pct of intercropped area under given crop
rename a4bq15 seed_value	// If seed was purchased, what was paid?

keep hhid parcel_id plot_id crop_id crop_code crop_sys mixedcrop_pct seed_value

*	Prepare for export
compress
describe
summarize 
sort crop_id
save "`export'/2013_AGSEC4B", replace
