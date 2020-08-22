clear all

*attempting to clean Uganda household variables
global user "themacfreezie"

**********************************************************************************
**	UNPS 2010 (Wave 2) - Agriculture Section 4B 
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2010"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2010"

use "`root'/2010_AGSEC4B", clear

*	crop names and seed types. 2nd visit

*	Unique identifier can only be generated with parcel, plot, and crop
describe
sort HHID prcid pltid cropID
*	isid HHID prcid pltid cropID, missok
*	For some reason the above does not uniquely identify observations
duplicates list HHID prcid pltid cropID
* 	Only 1 set of duplicates - 2256 & 2257

*	Create unique parcel identifier
generate crop_id = HHID + " " + string(prcid) + " " + string(pltid) + " " + string(cropID) 
*	isid crop_id // again, not unique

*	housekeeping
rename HHID hhid
rename prcid parcel_id
rename pltid plot_id
rename cropID crop_code
rename a4bq7 crop_sys 		// Purestand or mixed
tabulate crop_sys, missing 	// 22 obs are missing
*	take a look at A4aq8 (total area of plot planted). it's weird
*	seems to be in hectares I guess? I don't think we need it
*	still, I wonder how it differs from the total area of the plots
rename a4bq8 plntd_area		// Total planted area of plot
tabulate plntd_area, missing
*	missing 67 obs
sort plntd_area				// Lots of obs missing plntd_area also have no crop code
drop a4bq10 a4bq12 a4bq13 a4bq14
generate bonk = 1 if plntd_area == . & crop_code != .
tabulate bonk, missing		// 36 obs w/ no planted area given and a crop code provided
sort bonk					
*drop if bonk == 1
*	Should I do this? It's like 290 obs, well under 3% of 13,987
rename a4bq9 mixedcrop_pct	// Pct of intercropped area under given crop
replace mixedcrop_pct = 100 if crop_sys == 1 & plntd_area != .
rename a4bq11 seed_value	// If seed was purchased, what was paid?
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
generate crop_area = plntd_area * mixedcrop_dec * 0.404686	// If seed was purchased, what was paid?

*which visit?
generate visit = 2

keep hhid parcel_id plot_id crop_id crop_code crop_area crop_sys seed_value visit

*	Prepare for export
compress
describe
summarize 
sort crop_code
save "`export'/2010_AGSEC4B", replace
