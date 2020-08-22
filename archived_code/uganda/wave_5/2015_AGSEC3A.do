clear all

*attempting to clean Uganda household variables
global user "themacfreezie"

**********************************************************************************
**	UNPS 2015 (Wave 5) - Agriculture Section 3A 
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2015"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2015"

use "`root'/2015_AGSEC3A", clear

*	has to do with fertilizers, pest/herbicides, labor. 1st visit

*	Unique identifier can only be generated with parcel and plot
describe
sort HHID parcelID plotID
isid HHID parcelID plotID, missok

*	Create unique parcel identifier
generate parcel_id = HHID + " " + string(parcelID)
generate plot_id = HHID + " " + string(parcelID) + " " + string(plotID)
isid plot_id

*some housekeeping, including fertilizer use
rename HHID hhid
rename a3aq4 org_fert_any
rename a3aq13 fert_any
rename a3aq5 org_kilo_fert
rename a3aq15 kilo_fert
rename a3aq23 pest

*pesticide/herbicide
generate pesticide_any = 1 if pest == 2
replace pesticide_any = 1 if pest == 6
replace pesticide_any = 1 if pest == 5
generate insecticide_any = 1 if pest == 1
generate fungicide_any = 1 if pest == 3
generate herbicide_any = 1 if pest == 4
replace herbicide_any = 1 if pest == 96

*labor days
replace a3aq33a_1 = 0 if a3aq33a_1 == .
replace a3aq33b_1 = 0 if a3aq33b_1 == .
replace a3aq33c_1 = 0 if a3aq33c_1 == .
replace a3aq33d_1 = 0 if a3aq33d_1 == .
replace a3aq33e_1 = 0 if a3aq33e_1 == .
replace a3aq35a = 0 if a3aq35a == .
replace a3aq35b = 0 if a3aq35b == .
replace a3aq35c = 0 if a3aq35c == .
generate labor_days = a3aq33a_1 + a3aq33b_1 + a3aq33c_1 + a3aq33d_1 + a3aq33e_1 + a3aq35a + a3aq35b + a3aq35c
*	not sure if this is for planting or harvest or all of the above
*	it says first visit at the top of the section...

keep hhid parcel_id plot_id org_fert_any fert_any org_kilo_fert kilo_fert pesticide_any insecticide_any fungicide_any labor_days

*	Prepare for export
compress
describe
summarize 
sort plot_id
save "`export'/2015_AGSEC3A", replace
