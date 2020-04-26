clear all

*attempting to clean Tanzania household variables
global user "themacfreezie"

**********************************************************************************
**	TZA 2010 (Wave 2) - Agriculture Section 2B
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Tanzania\analysis_datasets\Tanzania_raw\TZA_2010"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Tanzania\analysis_datasets\Tanzania_refined\TZA_2010"

use "`root'/AG_SEC2B", clear

*	looks like a parcel roster, "additional plots owned or cultivated by anyone in your household during the short rainy season (2010)"

rename y2_hhid hhid
rename ag2b_15 plotsize_self
rename ag2b_20 plotsize_gps

generate plot_id = hhid + " " + plotnum
isid plot_id

keep hhid plot_id plotsize_self plotsize_gps

*	Prepare for export
compress
describe
summarize 
sort plot_id
save "`export'/AG_SEC2B", replace
