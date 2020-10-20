clear all

*attempting to clean Uganda household variables
global user "themacfreezie"

**********************************************************************************
**	UNPS 2009 (Wave 1) - Agriculture Section 3B
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2009"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2009"

use "`root'/2009_AGSEC3B", clear

*	has to do with fertilizers, pest/herbicides, labor. 2nd visit

*	Unique identifier can only be generated with parcel and plot
describe
sort HHID a3bq1 a3bq3
isid HHID a3bq1 a3bq3, missok

*	Create unique parcel/plot identifier
generate parcel_id = HHID + " " + string(a3bq1)
generate plot_id = HHID + " " + string(a3bq1) + " " + string(a3bq3)
isid plot_id

*some housekeeping, including fertilizer use
rename HHID hhid
rename a3bq4 org_fert_any
rename a3bq14 fert_any
rename a3bq5 org_kilo_fert
rename a3bq16 kilo_fert

*pesticide/herbicide
generate pesticide_any = 1 if a3bq27 == 2
replace pesticide_any = 1 if a3bq27 == 6
replace pesticide_any = 1 if a3bq27 == 5
generate insecticide_any = 1 if a3bq27 == 1
generate fungicide_any = 1 if a3bq27 == 3
generate herbicide_any = 1 if a3bq27 == 4
replace herbicide_any = 1 if a3bq27 == 96

*labor days
replace a3bq39 = 0 if a3bq39 == .
replace a3bq42a = 0 if a3bq42a == .
replace a3bq42b = 0 if a3bq42b == .
replace a3bq42c = 0 if a3bq42c == .
generate labor_days = a3bq39 + a3bq42a + a3bq42b + a3bq42c
*not sure if this is for planting or harvest or all of the above
*it says first visit at the top of the section...

*which visit?
generate visit = 2

keep hhid parcel_id plot_id org_fert_any fert_any org_kilo_fert kilo_fert pesticide_any insecticide_any fungicide_any labor_days visit

*	Prepare for export
compress
describe
summarize 
sort plot_id
save "`export'/2009_AGSEC3B", replace
