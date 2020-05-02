clear all

*attempting to clean Ethiopia household variables
global user "themacfreezie"

**********************************************************************************
**	ESS Wave 1 - Post Harvest Section 9 
**********************************************************************************
*	Seems to very roughly correspond to Malawi ag-modG and ag-modM

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_raw\Wave1_2011"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_refined\Wave1_2011"

use "`root'/sect9_ph_w1.dta", clear

*	Unique identifier can only be generated including crop code as some fields are mixed (pp_s4q02)
describe
sort holder_id household_id parcel_id field_id crop_code
isid holder_id household_id parcel_id field_id crop_code, missok

* Drop observations with a missing field_id
summarize if missing(parcel_id,field_id,crop_code)
drop if missing(parcel_id,field_id,crop_code)
isid holder_id household_id parcel_id field_id crop_code

*creating unique district identifier
egen district = group( saq01 saq02)

*	Date of harvest
generate year = 2012 	// I'm making an assumption here because all the months are in the early part of the year
gen edate = mdy(ph_s9q02_b, ph_s9q02_a, year)
format edate %d
drop year
rename edate harvest_date
label variable harvest_date "Date crop was harvested"

*	Fresh weight and dry weight, not sure what we're interested in...
replace ph_s9q03_a = 0 if ph_s9q03_a == . & ph_s9q03_b != .
replace ph_s9q03_b = 0 if ph_s9q03_b == . & ph_s9q03_a != .
generate fresh_wgt = ph_s9q03_a + 0.001*ph_s9q03_b

*	CONSIDER MISSING VALUES - must keep a & b as nulls if BOTH are missing
*	Must fill in a zero for a if b is equal to something and vice versa

*	Do we care about this?
*	Date of dry weighing
generate year = 2012 	// I'm making an assumption here because all the months are in the early part of the year
gen edate = mdy(ph_s9q04_b, ph_s9q04_a, year)
format edate %d
drop year
rename edate drywgh_date
label variable drywgh_date "Date of dry weighing of crop"

*	Dry weight
replace ph_s9q05_a = 0 if ph_s9q05_a == . & ph_s9q05_b != .
replace ph_s9q05_b = 0 if ph_s9q05_b == . & ph_s9q05_a != .
generate dry_wgt = ph_s9q05_a + 0.001*ph_s9q05_b

*	Fresh_wgt and dry_wgt contain lots of missing values. Will attempt to impute
*	Impute missing values using predictive mean matching 
mi set wide 					//	declare the data to be wide. 
mi xtset, clear					//	this is a precautinary step to clear any xtset that the analyst may have had in place previously
mi register imputed fresh_wgt	//	identify fresh_wgt as the variable being imputed 
mi impute pmm fresh_wgt crop_code i.district, add(1) rseed(245780) noisily dots /*
*/	force knn(5) bootstrap 
drop fresh_wgt
rename _1_fresh_wgt fresh_wgt
mi unset
label variable fresh_wgt "Fresh weight of cut crop (kg) 2m x 2m"
drop fresh_wgt_1_

*	Impute missing plot sizes using predictive mean matching 
mi set wide 					//	declare the data to be wide. 
mi xtset, clear					//	this is a precautinary step to clear any xtset that the analyst may have had in place previously
mi register imputed dry_wgt	//	identify dry_wgt as the variable being imputed 
mi impute pmm dry_wgt crop_code i.district, add(1) rseed(245780) noisily dots /*
*/	force knn(5) bootstrap 
drop dry_wgt
rename _1_dry_wgt dry_wgt
mi unset
label variable dry_wgt "Dry weight of cut crop (kg) 2m x 2m"

drop mi_miss mi_miss1

*	Also, this 2m X 2m thing is weird. I guess we'll have to convert these measures to hectares
*	This would mean multiplying each variable by 2500 to get total weight harvested (10000 sq m to a hectare) -> (2500 4sq m to a hectare)
*	I can do this easily if we want

*	I don't believe any other variables are important to us
*	PLease see post-harvest survey pg 15 to double check me here

*	Restrict to variables of interest
keep  holder_id- crop_code harvest_date fresh_wgt drywgh_date dry_wgt
order holder_id- crop_code

*	Prepare for export
compress
describe
summarize 
sort holder_id household_id ea_id
save "`export'/sect9_ph_w1", replace
