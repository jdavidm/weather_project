clear all

*attempting to clean Uganda household variables
global user "themacfreezie"

**********************************************************************************
**	UNPS 2010 (Wave 2) - Agriculture Section 3A 
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2010"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2010"

use "`root'/2010_AGSEC3A", clear

*	has to do with fertilizers, pest/herbicides, labor. 1st visit

*	Unique identifier can only be generated with parcel and plot
describe
sort HHID prcid pltid
isid HHID prcid pltid, missok

*	Create unique parcel/plot identifier
generate parcel_id = HHID + " " + string(prcid)
generate plot_id = HHID + " " + string(prcid) + " " + string(pltid)
isid plot_id

*some housekeeping, including fertilizer use
rename HHID hhid
rename a3aq4 org_fert_any
rename a3aq14 fert_any
rename a3aq5 org_kilo_fert
rename a3aq16 kilo_fert

*pesticide/herbicide
generate pesticide_any = 1 if a3aq27 == 2
replace pesticide_any = 1 if a3aq27 == 6
replace pesticide_any = 1 if a3aq27 == 5
generate insecticide_any = 1 if a3aq27 == 1
generate fungicide_any = 1 if a3aq27 == 3
generate herbicide_any = 1 if a3aq27 == 4
replace herbicide_any = 1 if a3aq27 == 96

*labor days
replace a3aq39 = 0 if a3aq39 == .
replace a3aq42a = 0 if a3aq42a == .
replace a3aq42b = 0 if a3aq42b == .
replace a3aq42c = 0 if a3aq42c == .
generate labor_days = a3aq39 + a3aq42a + a3aq42b + a3aq42c
*not sure if this is for planting or harvest or all of the above
*it says first visit at the top of the section...

*which visit?
generate visit = 1

keep hhid parcel_id plot_id org_fert_any fert_any org_kilo_fert kilo_fert pesticide_any insecticide_any fungicide_any labor_days visit

*	Prepare for export
compress
describe
summarize 
sort plot_id
save "`export'/2010_AGSEC3A", replace
