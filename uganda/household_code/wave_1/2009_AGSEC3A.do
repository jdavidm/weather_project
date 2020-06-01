clear all

*attempting to clean Uganda household variables
global user "themacfreezie"

**********************************************************************************
**	UNPS 2009 (Wave 1) - Agriculture Section 3A
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2009"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2009"

use "`root'/2009_AGSEC3A", clear

*	has to do with fertilizers, pest/herbicides, labor. 1st visit

*	Unique identifier can only be generated with parcel and plot
describe
sort Hhid A3aq1 A3aq3
isid Hhid A3aq1 A3aq3, missok

*	Create unique parcel/plot identifier
generate parcel_id = Hhid + " " + string(A3aq1)
generate plot_id = Hhid + " " + string(A3aq1) + " " + string(A3aq3)
isid plot_id

*some housekeeping, including fertilizer use
rename Hhid hhid
rename A3aq4 org_fert_any
rename A3aq14 fert_any
rename A3aq5 org_kilo_fert
rename A3aq16 kilo_fert

*pesticide/herbicide
generate pesticide_any = 1 if A3aq27 == 2
replace pesticide_any = 1 if A3aq27 == 6
generate insecticide_any = 1 if A3aq27 == 1
generate fungicide_any = 1 if A3aq27 == 3
generate herbicide_any = 1 if A3aq27 == 4
replace herbicide_any = 1 if A3aq27 == 96

*labor days
replace A3aq39 = 0 if A3aq39 == .
replace A3aq42a = 0 if A3aq42a == .
replace A3aq42b = 0 if A3aq42b == .
replace A3aq42c = 0 if A3aq42c == .
generate labor_days = A3aq39 + A3aq42a + A3aq42b + A3aq42c
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
save "`export'/2009_AGSEC3A", replace
