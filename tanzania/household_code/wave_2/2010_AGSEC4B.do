clear all

*attempting to clean Tanzania household variables
global user "themacfreezie"

**********************************************************************************
**	TZA 2010 (Wave 2) - Agriculture Section 4B 
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Tanzania\analysis_datasets\Tanzania_raw\TZA_2010"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Tanzania\analysis_datasets\Tanzania_refined\TZA_2010"

use "`root'/AG_SEC4B", clear

*	Kind of a crop roster, with harvest weights, short rainy season

rename y2_hhid hhid
rename zaocode crop_code

tostring crop_code, generate(crop_num) format(%03.0g) force

generate crop_id = hhid + " " + plotnum + " " + crop_num
isid crop_id

rename ag4b_01 purestand
generate mixedcrop_pct = .
replace mixedcrop_pct = 100 if purestand == 1
replace mixedcrop_pct = 75 if ag4b_02 == 3
replace mixedcrop_pct = 50 if ag4b_02 == 2
replace mixedcrop_pct = 25 if ag4b_02 == 1
tab purestand ag4b_02, missing
*	There are 4,951 missing obs here
tab mixedcrop_pct crop_code, missing
*	Each of these is also missing a crop code
*	Assuming these fields are fallow, that's a lot!
*	Only 1,791 obs remain. Does this make sense for short rainy season?
sort crop_code
* 	Should they be dropped? All these obs seem to have no other info
*	Probably so

rename ag4b_11_1 harvest_month
rename ag4b_15 wgt_hvsted
label variable wgt_hvsted "What was the quanitity harvested? (kg)"
rename ag4b_21 value_seed_purch

keep hhid plotnum crop_id crop_code mixedcrop_pct harvest_month wgt_hvsted value_seed_purch

*	Prepare for export
compress
describe
summarize 
sort crop_id
save "`export'/AG_SEC4B", replace
