clear all

*attempting to clean Tanzania household variables
global user "themacfreezie"

**********************************************************************************
**	TZA 2010 (Wave 2) - Agriculture Section 3A 
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Tanzania\analysis_datasets\Tanzania_raw\TZA_2010"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Tanzania\analysis_datasets\Tanzania_refined\TZA_2010"

use "`root'/AG_SEC3A", clear

*	plot details, inputs, 2010 long rainy season

rename y2_hhid hhid
generate plot_id = hhid + " " + plotnum
isid plot_id

*	inputs
rename ag3a_03 status
rename zaocode crop_code
rename ag3a_17 irrigated 
rename ag3a_45 fert_any
rename ag3a_47 kilo_fert
rename ag3a_58 pesticide_any

*	labor inputs
egen hh_labor_days = rsum(ag3a_70_1 ag3a_70_2 ag3a_70_3 ag3a_70_4 ag3a_70_5 ag3a_70_6 ag3a_70_13 ag3a_70_14 ///
ag3a_70_15 ag3a_70_16 ag3a_70_17 ag3a_70_18 ag3a_70_37 ag3a_70_38 ag3a_70_39 ag3a_70_40 ag3a_70_41 ag3a_70_42 ///
ag3a_70_25 ag3a_70_26 ag3a_70_27 ag3a_70_28 ag3a_70_29 ag3a_70_30)

egen hired_labor_days = rsum(ag3a_72_1 ag3a_72_2 ag3a_72_21 ag3a_72_4 ag3a_72_5 ag3a_72_51 ///
 ag3a_72_61  ag3a_72_62 ag3a_72_63 ag3a_72_7 ag3a_72_8 ag3a_72_81)
 
generate labor_days = hh_labor_days + hired_labor_days

keep hhid plot_id status crop_code irrigated fert_any kilo_fert pesticide_any labor_days 

*	Prepare for export
compress
describe
summarize 
sort plot_id
save "`export'/AG_SEC3A", replace
