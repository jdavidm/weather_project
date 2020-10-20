clear all

*attempting to clean Uganda household variables
global user "themacfreezie"

**********************************************************************************
**	UNPS 2010 (Wave 2) - Agriculture Section 2B 
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2010"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2010"

use "`root'/2010_AGSEC2B", clear

*	also looks like a parcel roster. this time for lands the house doesn't own but has access to

*	Unique identifier can only be generated using parcel id
describe
sort HHID prcid
isid HHID prcid, missok

*	Create unique parcel identifier
generate parcel_id = HHID + " " + string(prcid)
isid parcel_id

*	Housekeeping
rename HHID hhid
rename a2bq4 plotsize_gps
rename a2bq5 plotsize_self
rename a2bq15a primary_use1
rename a2bq15b primary_use2

*	Relying on GPS plot size unless missing, then resorting to self report
*	Check correlation
pwcorr plotsize_gps plotsize_self
*	Overall corelation is higher than in other sections (0.49)
*	Looking ~within +/- 3 sd
summarize plotsize_gps plotsize_self
pwcorr plotsize_gps plotsize_self if inrange(plotsize_gps,0,8.8) & inrange(plotsize_self,0,8.8)
*	Correlation is very very high within this range (0.86)

generate parc_size2 = plotsize_gps
replace parc_size2 = plotsize_self if parc_size2 == . & inrange(plotsize_self, 0, 8.8)
tabulate parc_size2, missing
*	Missing 20 (~1.9%) observations
tabulate plotsize_self, missing
*	Plotsize_self missing 14 observations
*	Therefore low correlation b/w gps and self on remaining six
*	Will drop 20 obs missing parc_size2
drop if parc_size2 == .
rename parc_size2 parc_size
generate parc_size2 = parc_size * 0.404686
drop parc_size

*	Should I attempt to impute missing plotsizes?
/*
*	Impute missing plot sizes using predictive mean matching 
mi set wide 					//	declare the data to be wide. 
mi xtset, clear					//	this is a precautinary step to clear any xtset that the analyst may have had in place previously
mi register imputed parc_size2	//	identify parc_size2 as the variable being imputed 
mi impute pmm parc_size2 , add(1) rseed(245780) noisily dots /* not sure what are the best variables to impute against?
*/ force knn(5) bootstrap 
mi unset

*Alternatively, we can not include self reported values at all
generate parc_size2 = plotsize_gps
mi set wide 					//	declare the data to be wide. 
mi xtset, clear					//	this is a precautinary step to clear any xtset that the analyst may have had in place previously
mi register imputed parc_size2	//	identify plotsize_GPS as the variable being imputed 
mi impute pmm parc_size2 , add(1) rseed(245780) noisily dots /* again, would love advice on imputing variables
*/	force knn(5) bootstrap 
mi unset
*/

*	Do we need to account for fallowed fields?
generate fallow = 1 if primary_use1 == 5
replace fallow = 1 if primary_use2 == 5

generate irrigated = 1 if a2bq19 == 1

*	Use rights variable
generate use_rights = 1

keep hhid parcel_id parc_size2 fallow irrigated use_rights
*	Important note! Plot sizes above are actually parcel sizes
*	Parcels are larger than plots in this hierarchy
*	Kept the term plotsize to maintain consistent naming conventions with other countries
*	This could get confusing though?

*	Prepare for export
compress
describe
summarize 
sort parcel_id
save "`export'/2010_AGSEC2B", replace
