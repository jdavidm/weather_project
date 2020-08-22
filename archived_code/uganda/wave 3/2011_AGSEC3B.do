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

use "`root'/2011_AGSEC3B", clear

*	has to do with fertilizers, pest/herbicides, labor. 2nd visit

*	Unique identifier can only be generated with parcel and plot
describe
sort HHID parcelID plotID
*	isid HHID parcelID plotID, missok
*	the above is not unique, let's see...
duplicates report HHID parcelID plotID
* 	3 sets of duplicates - why??
*	6164 & 6165, 6166 & 6167, 6168 & 6169 - weird!
* 	this makes me think maybe something is in error
* 	will proceed

tostring HHID, generate(hhid) format(%016.0f) force
duplicates report hhid parcelID plotID
* 	same 3 duplicates as above

*	Create unique parcel identifier
generate parcel_id = hhid + " " + string(parcelID)
generate plot_id = hhid + " " + string(parcelID) + " " + string(plotID)
duplicates report plot_id
*	same 3 duplicates as above

*some housekeeping, including fertilizer use
rename a3bq4 org_fert_any
rename a3bq13 fert_any
rename a3bq5 org_kilo_fert
rename a3bq15 kilo_fert

*pesticide/herbicide
generate pesticide_any = 1 if a3bq23 == 2
replace pesticide_any = 1 if a3bq23 == 6
replace pesticide_any = 1 if a3bq23 == 5
generate insecticide_any = 1 if a3bq23 == 1
generate fungicide_any = 1 if a3bq23 == 3
generate herbicide_any = 1 if a3bq23 == 4
replace herbicide_any = 1 if a3bq23 == 96

*labor days
generate labor_days = a3bq32 + a3bq35a + a3bq35b + a3bq35c
*	not sure if this is for planting or harvest or all of the above
*	it says first visit at the top of the section...

*which visit?
generate visit = 2

keep hhid parcel_id plot_id org_fert_any fert_any org_kilo_fert kilo_fert pesticide_any insecticide_any fungicide_any labor_days visit

*	Prepare for export
compress
describe
summarize 
sort plot_id
save "`export'/2011_AGSEC3B", replace
