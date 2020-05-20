clear all

*attempting to clean Uganda household variables
global user "themacfreezie"

**********************************************************************************
**	UNPS 2011 (Wave 3) - Agriculture Section 3A 
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2011"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2011"

use "`root'/2011_AGSEC3A", clear

*	has to do with fertilizers, pest/herbicides, labor. 1st visit

*	Unique identifier can only be generated with parcel and plot
describe
sort HHID parcelID plotID
isid HHID parcelID plotID, missok

tostring HHID, generate(hhid) format(%016.0f) force
duplicates report hhid parcelID plotID
* 	no duplicates

*	Create unique parcel identifier
generate parcel_id = hhid + " " + string(parcelID)
generate plot_id = hhid + " " + string(parcelID) + " " + string(plotID)
isid plot_id

*some housekeeping, including fertilizer use
rename a3aq4 org_fert_any
rename a3aq13 fert_any
rename a3aq5 org_kilo_fert
rename a3aq15 kilo_fert

*pesticide/herbicide
generate pesticide_any = 1 if a3aq23 == 2
replace pesticide_any = 1 if a3aq23 == 6
replace pesticide_any = 1 if a3aq23 == 5
generate insecticide_any = 1 if a3aq23 == 1
generate fungicide_any = 1 if a3aq23 == 3
generate herbicide_any = 1 if a3aq23 == 4
replace herbicide_any = 1 if a3aq23 == 96

*labor days
generate labor_days = a3aq32 + a3aq35a + a3aq35b + a3aq35c
*	not sure if this is for planting or harvest or all of the above
*	it says first visit at the top of the section...

*which visit?
generate visit = 1

keep hhid parcel_id plot_id org_fert_any fert_any org_kilo_fert kilo_fert pesticide_any insecticide_any fungicide_any labor_days visit

*	Prepare for export
compress
describe
summarize 
sort plot_id
save "`export'/2011_AGSEC3A", replace
