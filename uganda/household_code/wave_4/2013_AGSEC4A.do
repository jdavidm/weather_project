clear all

*attempting to clean Uganda household variables
global user "themacfreezie"

**********************************************************************************
**	UNPS 2013 (Wave 4) - Agriculture Section 4A
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2013"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2013"

use "`root'/2013_AGSEC4A", clear

*	crop names and seed types. 1st visit

*	Unique identifier can only be generated with parcel and plot
describe
sort HHID parcelID plotID cropID
isid HHID parcelID plotID cropID, missok

*	stringing household IDs
tostring HHID, generate(hhid) format(%016.0f) force
duplicates report hhid parcelID plotID cropID

*	Create unique parcel identifier
generate parcel_id = hhid + " " + string(parcelID)
generate plot_id = hhid + " " + string(parcelID) + " " + string(plotID)
generate crop_id = hhid + " " + string(parcelID) + " " + string(plotID) + " " + string(cropID)
duplicates report crop_id

rename cropID crop_code
rename a4aq8 crop_sys 		// Purestand or mixed
tabulate crop_sys, missing 	// 0 obs are missing
rename a4aq9 mixedcrop_pct	// Pct of intercropped area under given crop
rename a4aq15 seed_value	// If seed was purchased, what was paid?

keep hhid parcel_id plot_id crop_id crop_code crop_sys mixedcrop_pct seed_value

*	Prepare for export
compress
describe
summarize 
sort crop_id
save "`export'/2013_AGSEC4A", replace
