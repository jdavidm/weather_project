clear all

*attempting to clean Uganda household variables
global user "themacfreezie"

**********************************************************************************
**	UNPS 2015 (Wave 5) - Agriculture Section 4B
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2015"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2015"

use "`root'/2015_AGSEC4B", clear

*	crop names and seed types. 1st visit

*	Unique identifier can only be generated with parcel and plot
describe
sort HHID parcelID plotID cropID
*	isid HHID parcelID plotID cropID, missok
*	the above does not provide unique id!
duplicates report HHID parcelID plotID cropID
*	5 duplicates
*	will proceed for now

*	Create unique parcel identifier
generate parcel_id = HHID + " " + string(parcelID)
generate plot_id = HHID + " " + string(parcelID) + " " + string(plotID)
generate crop_id = HHID + " " + string(parcelID) + " " + string(plotID) + " " + string(cropID)
duplicates report crop_id

*	Housekeeping
rename HHID hhid
rename cropID crop_code
rename a4bq8 crop_sys 		// Purestand or mixed
tabulate crop_sys, missing 	// 1 obs are missing
rename a4bq9 mixedcrop_pct	// Pct of intercropped area under given crop
rename a4bq15 seed_value	// If seed was purchased, what was paid?

keep hhid parcel_id plot_id crop_id crop_code crop_sys mixedcrop_pct seed_value

*	Prepare for export
compress
describe
summarize 
sort crop_id
save "`export'/2015_AGSEC4B", replace
