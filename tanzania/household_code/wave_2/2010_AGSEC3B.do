clear all

*attempting to clean Tanzania household variables
global user "themacfreezie"

**********************************************************************************
**	TZA 2010 (Wave 2) - Agriculture Section 3B
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Tanzania\analysis_datasets\Tanzania_raw\TZA_2010"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Tanzania\analysis_datasets\Tanzania_refined\TZA_2010"

use "`root'/AG_SEC3B", clear

*	plot details, inputs, 2010 short rainy 

rename y2_hhid hhid
generate plot_id = hhid + " " + plotnum
isid plot_id

*	inputs
rename ag3b_03 status
rename zaocode crop_code
rename ag3b_17 irrigated 
rename ag3b_45 fert_any
rename ag3b_47 kilo_fert
rename ag3b_58 pesticide_any

*	labor inputs
egen hh_labor_days = rsum(ag3b_70_1 ag3b_70_2 ag3b_70_3 ag3b_70_4 ag3b_70_5 ag3b_70_6 ag3b_70_13 ag3b_70_14 ///
ag3b_70_15 ag3b_70_16 ag3b_70_17 ag3b_70_18 ag3b_70_37 ag3b_70_38 ag3b_70_39 ag3b_70_40 ag3b_70_41 ag3b_70_42 ///
ag3b_70_25 ag3b_70_26 ag3b_70_27 ag3b_70_28 ag3b_70_29 ag3b_70_30)

egen hired_labor_days = rsum(ag3b_72_1 ag3b_72_2 ag3b_72_21 ag3b_72_4 ag3b_72_5 ag3b_72_51 ///
 ag3b_72_61  ag3b_72_62 ag3b_72_63 ag3b_72_7 ag3b_72_8 ag3b_72_81)

generate labor_days = hh_labor_days + hired_labor_days

keep hhid plot_id status crop_code irrigated fert_any kilo_fert pesticide_any labor_days 

*	Prepare for export
compress
describe
summarize 
sort plot_id
save "`export'/AG_SEC3B", replace
