clear all

*attempting to clean Ethiopia household variables
global user "themacfreezie"

**********************************************************************************
**	ESS Wave 1 - Post Planting Section 7 
**********************************************************************************
*	Seems to very roughly correspond to Malawi ag-modF and ag-modL

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_raw\Wave1_2011"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_refined\Wave1_2011"

use "`root'/sect7_pp_w1.dta", clear

*	Unique identifier
describe
sort holder_id ea_id
isid holder_id ea_id, missok

* Drop observations with a missing holder_id/ea_id
summarize if missing(holder_id,ea_id)
drop if missing(holder_id,ea_id)
isid holder_id ea_id

*	I'm not really seeing much in this module of use to us.
*	It's mostly about specific fertilizer use and other miscellaneous items (oxen use, credit, extension programs)

rename household_id hhid
rename saq01 district
rename saq02 region
rename saq03 ward

*	Restrict to variables of interest
keep  holder_id- pp_saq07
order holder_id- pp_saq07

*	Prepare for export
compress
describe
summarize 
sort holder_id ea_id
save "`export'/sect7_pp_w1", replace
