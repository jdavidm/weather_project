clear all

*attempting to clean Uganda household variables
global user "themacfreezie"

**********************************************************************************
**	UNPS 2009 (Wave 1) - Agriculture Section 4A
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2009"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2009"

use "`root'/2009_AGSEC4A", clear

*	crop names and seed types. 1st visit

*	Unique identifier can only be generated with parcel, plot, and crop
describe
sort Hhid A4aq2 A4aq4 A4aq6
isid Hhid A4aq2 A4aq4 A4aq6, missok

*	Create unique parcel identifier
generate crop_id = Hhid + " " + string(A4aq2) + " " + string(A4aq4) + " " + string(A4aq6) 
isid crop_id

*	housekeeping
rename Hhid hhid
rename A4aq2 parcel_id
rename A4aq4 plot_id
rename A4aq5 crop_name
rename A4aq6 crop_code
rename A4aq7 crop_sys 		// Purestand or mixed
tabulate crop_sys, missing 	// Some obs are missing
*	take a look at A4aq8 (total area of plot planted). it's weird
*	seems to be in hectares I guess? I don't think we need it
*	still, I wonder how it differs from the total area of the plots
rename A4aq8 plntd_area		// Total planted area of plot
tabulate plntd_area, missing
*	missing 1,786 obs. not great
sort plntd_area				// Lots of obs missing plntd_area also have no crop code
drop A4aq10 A4aq12 A4aq13 A4aq14
generate bonk = 1 if plntd_area == . & crop_code != .
tabulate bonk, missing		// 293 obs w/ no planted area given and a crop code provided
sort bonk					// Not seeing any commonalities..
*drop if bonk == 1
*	Should I do this? It's like 290 obs, well under 3% of 13,987
rename A4aq9 mixedcrop_pct	// Pct of intercropped area under given crop
replace mixedcrop_pct = 100 if crop_sys == 1 & plntd_area != .
rename A4aq11 seed_value	// If seed was purchased, what was paid?
drop bonk

*	Are there observations missing cropping system and not missing the total area planted?
generate derp = 1 if crop_sys == . & plntd_area != .
tabulate derp, missing
*	9, so not many
sort derp
*	Can I assume these are all purestand?
replace mixedcrop_pct = 100 if derp == 1
replace crop_sys = 1 if derp == 1
drop derp

generate mixedcrop_dec = mixedcrop_pct * 0.01
generate crop_area = plntd_area * mixedcrop_dec * 0.404686

*which visit?
generate visit = 1

keep hhid parcel_id plot_id crop_id crop_name crop_code crop_sys crop_area seed_value visit

*	Prepare for export
compress
describe
summarize 
sort crop_code
save "`export'/2009_AGSEC4A", replace
