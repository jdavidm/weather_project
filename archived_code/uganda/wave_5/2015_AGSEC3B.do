clear all

*attempting to clean Uganda household variables
global user "themacfreezie"

**********************************************************************************
**	UNPS 2015 (Wave 5) - Agriculture Section 3B 
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2015"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2015"

use "`root'/2015_AGSEC3B", clear

*	has to do with fertilizers, pest/herbicides, labor. 2nd visit

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
rename a3bq4 org_fert_any
rename a3bq13 fert_any
rename a3bq5 org_kilo_fert
rename a3bq15 kilo_fert
rename a3bq23 pest

*pesticide/herbicide
generate pesticide_any = 1 if pest == 2
replace pesticide_any = 1 if pest == 6
replace pesticide_any = 1 if pest == 5
generate insecticide_any = 1 if pest == 1
generate fungicide_any = 1 if pest == 3
generate herbicide_any = 1 if pest == 4
replace herbicide_any = 1 if pest == 96

*labor days
replace a3bq33a_1 = 0 if a3bq33a_1 == .
replace a3bq33b_1 = 0 if a3bq33b_1 == .
replace a3bq33c_1 = 0 if a3bq33c_1 == .
replace a3bq33d_1 = 0 if a3bq33d_1 == .
replace a3bq33e_1 = 0 if a3bq33e_1 == .
replace a3bq35a = 0 if a3bq35a == .
replace a3bq35b = 0 if a3bq35b == .
replace a3bq35c = 0 if a3bq35c == .
generate labor_days = a3bq33a_1 + a3bq33b_1 + a3bq33c_1 + a3bq33d_1 + a3bq33e_1 + a3bq35a + a3bq35b + a3bq35c
*	not sure if this is for planting or harvest or all of the above

keep hhid parcel_id plot_id org_fert_any fert_any org_kilo_fert kilo_fert pesticide_any insecticide_any fungicide_any labor_days

*	Prepare for export
compress
describe
summarize 
sort plot_id
save "`export'/2015_AGSEC3B", replace
