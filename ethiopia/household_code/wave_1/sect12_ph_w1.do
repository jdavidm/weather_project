clear all

*attempting to clean Ethiopia household variables
global user "themacfreezie"

**********************************************************************************
**	ESS Wave 1 - Post Harvest Section 12
**********************************************************************************
*	Seems to very roughly correspond to Malawi ag-modD and ag-modK

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_raw\Wave1_2011"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_refined\Wave1_2011"

use "`root'/sect12_ph_w1.dta", clear

*	Unique identifier can only be generated including crop code as some fields are mixed (pp_s4q02)
describe
sort holder_id crop_code
isid holder_id crop_code, missok

* Drop observations with a missing field_id
summarize if missing(crop_code)
drop if missing(crop_code)
isid holder_id crop_code

*creating unique region identifier
egen region_id = group( saq01 saq02)
label var region_id "Unique region identifier"

*	Total weight of crop harvsted and weight sold
generate wgt_hvsted = ph_s12q03										// 6329 of 6999 - no need to impute?
generate wgt_sold = ph_s12q07										// 1947 of 6999
label variable wgt_hvsted "Total weight of crop harvested(kg)"

*	Attempting to impute weight sold
*	Impute missing plot sizes using predictive mean matching 
mi set wide 					//	declare the data to be wide. 
mi xtset, clear					//	this is a precautinary step to clear any xtset that the analyst may have had in place previously
mi register imputed wgt_sold	//	identify fresh_wgt as the variable being imputed 
mi impute pmm wgt_sold crop_code i.region_id, add(1) rseed(245780) noisily dots /*
*/	force knn(5) bootstrap 
drop wgt_sold
rename _1_wgt_sold wgt_sold
mi unset
label variable wgt_sold "Total weight of crop sold (kg)"
drop wgt_sold_1_ mi_miss

*	Value of the crop sold
*	Values in Birr, will need to be converted
generate crop_value = ph_s12q08										// 1971 of 6999

*	Attempting to impute crop value
*	Impute missing plot sizes using predictive mean matching 
mi set wide 					//	declare the data to be wide. 
mi xtset, clear					//	this is a precautinary step to clear any xtset that the analyst may have had in place previously
mi register imputed crop_value	//	identify fresh_wgt as the variable being imputed 
mi impute pmm crop_value crop_code i.region_id, add(1) rseed(245780) noisily dots /*
*/	force knn(5) bootstrap 
drop crop_value
rename _1_crop_value crop_value
mi unset
label variable crop_value "Total value of all crop sales (Birr)"
drop crop_value_1_ mi_miss

rename household_id hhid
rename saq01 district
rename saq02 region
rename saq03 ward
rename crop_code main_crop

*	Restrict to variables of interest
keep  holder_id- main_crop wgt_hvsted wgt_sold crop_value
order holder_id- main_crop

*	Prepare for export
compress
describe
summarize 
sort holder_id ea_id
save "`export'/sect12_ph_w1", replace
