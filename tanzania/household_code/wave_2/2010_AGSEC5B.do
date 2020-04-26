clear all

*attempting to clean Tanzania household variables
global user "themacfreezie"

**********************************************************************************
**	TZA 2010 (Wave 2) - Agriculture Section 5B
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Tanzania\analysis_datasets\Tanzania_raw\TZA_2010"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Tanzania\analysis_datasets\Tanzania_refined\TZA_2010"

use "`root'/AG_SEC5B", clear

*	Crop sales data, short rainy season

rename y2_hhid hhid
rename zaocode crop_code

rename ag5b_02 wgt_sold
label variable wgt_sold "What was the quanitity sold? (kg)"
rename ag5b_03 value_sold
label variable value_sold "What was the total value of the sales? (T-shillings)"

keep hhid crop_code wgt_sold value_sold

*	Prepare for export
compress
describe
summarize 
sort hhid
save "`export'/AG_SEC5B", replace
