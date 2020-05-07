clear all

*attempting to clean Ethiopia household variables
global user "themacfreezie"

**********************************************************************************
**	ESS Wave 1 - Post Harvest Section 11 
**********************************************************************************
*	Seems to very roughly correspond to Malawi ag-modI and ag-modO

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_raw\Wave1_2011"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_refined\Wave1_2011"

use "`root'/sect11_ph_w1.dta", clear

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

*	Total weight of crop sold 
*	CONSIDER MISSING VALUES - must keep a & b as nulls if BOTH are missing
*	Must fill in a zero for a if b is equal to something and vice versa
replace ph_s11q03_a = 0 if ph_s11q03_a == . & ph_s11q03_b != .
replace ph_s11q03_b = 0 if ph_s11q03_b == . & ph_s11q03_a != .
generate wgt_sold = ph_s11q03_a + 0.001*ph_s11q03_b // 1623 of 8808 values present

*	Attempting to impute weight
*	Impute missing values using predictive mean matching 
mi set wide 					//	declare the data to be wide. 
mi xtset, clear					//	this is a precautinary step to clear any xtset that the analyst may have had in place previously
mi register imputed wgt_sold	//	identify wgt_sold as the variable being imputed 
mi impute pmm wgt_sold crop_code i.region_id, add(1) rseed(245780) noisily dots /*
*/	force knn(5) bootstrap 
drop wgt_sold
rename _1_wgt_sold wgt_sold
mi unset
label variable wgt_sold "Total weight of crop sold (kg)"
drop wgt_sold_1_ mi_miss

*	Total value of crop sales
*	Values generated in Birr, will need to be converted
replace ph_s11q04_a = 0 if ph_s11q04_a == . & ph_s11q04_b != .
replace ph_s11q04_b = 0 if ph_s11q04_b == . & ph_s11q04_a != .
generate ph_s11q04_b2 = 0.1 * ph_s11q04_b
generate crop_value = ph_s11q04_a + ph_s11q04_b2
label variable crop_value "Total value of all crop sales (Birr)" // 431 of 8808 values present - is this even enough to impute with?

*	Including sales month for possible conversion purposes
generate sales_month = ph_s11q06_a

rename household_id hhid
rename saq01 district
rename saq02 region
rename saq03 ward
rename crop_code main_crop

*	Restrict to variables of interest
keep  holder_id- main_crop wgt_sold crop_value sales_month
order holder_id- main_crop

*	Prepare for export
compress
describe
summarize 
sort holder_id ea_id
save "`export'/sect11_ph_w1", replace
