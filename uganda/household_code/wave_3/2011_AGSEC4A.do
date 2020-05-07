clear all

*attempting to clean Uganda household variables
global user "themacfreezie"

**********************************************************************************
**	UNPS 2011 (Wave 3) - Agriculture Section 4A 
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2011"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2011"

use "`root'/2011_AGSEC4A", clear

*	crop names and seed types. 1st visit

*	Unique identifier can only be generated with parcel and plot
describe
sort HHID parcelID plotID cropID
*	isid HHID parcelID plotID cropID, missok
*	the above is not unique, let's see...
duplicates report HHID parcelID plotID cropID
* 	9 duplicates
* 	will proceed for now

tostring HHID, generate(hhid) format(%016.0f) force
duplicates report hhid parcelID plotID cropID
drop HHID
* 	same 9 duplicates

*	Create unique parcel identifier
generate crop_id = hhid + " " + string(parcelID) + " " + string(plotID) + " " + string(cropID)
duplicates report crop_id
*	same 9 duplicates

*	housekeeping
rename parcelID parcel_id
rename plotID plot_id
rename cropID crop_code
rename a4aq8 crop_sys 		// Purestand or mixed
tabulate crop_sys, missing 	// Some obs are missing
*	take a look at A4aq7 (total area of plot planted). it's weird
*	seems to be in hectares I guess? I don't think we need it
*	still, I wonder how it differs from the total area of the plots
rename a4aq7 plntd_area		// Total planted area of plot
tabulate plntd_area, missing
sort plntd_area	
drop a4aq10 a4aq6_1 a4aq3 a4aq10 a4aq11a a4aq11b a4aq12a a4aq12b a4aq13 a4aq14
generate bonk = 1 if plntd_area == . & crop_code != .
tabulate bonk, missing		
sort bonk					
*drop if bonk == 1
*	Should I do this? It's like 290 obs, well under 3% of 13,987
rename a4aq9 mixedcrop_pct	// Pct of intercropped area under given crop
replace mixedcrop_pct = 100 if crop_sys == 1 & plntd_area != .
rename a4aq15 seed_value	// If seed was purchased, what was paid?
drop bonk

*	Are there observations missing cropping system and not missing the total area planted?
generate derp = 1 if crop_sys == . & plntd_area != .
tabulate derp, missing
*	8, so not many
sort derp
*	Can I assume these are all purestand?
replace mixedcrop_pct = 100 if derp == 1
replace crop_sys = 1 if derp == 1
drop derp

generate mixedcrop_dec = mixedcrop_pct * 0.01
generate crop_area = plntd_area * mixedcrop_dec * 0.404686

*which visit?
generate visit = 1

keep hhid parcel_id plot_id crop_id crop_code crop_sys crop_area seed_value visit

*	Prepare for export
compress
describe
summarize 
sort crop_code
save "`export'/2011_AGSEC4A", replace
