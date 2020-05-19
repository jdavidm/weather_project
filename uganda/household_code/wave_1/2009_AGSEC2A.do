clear all

*attempting to clean Uganda household variables
global user "themacfreezie"

**********************************************************************************
**	UNPS 2009 (Wave 1) - Agriculture Section 2A 
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2009"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2009"

use "`root'/2009_AGSEC2A", clear

*	looks like a parcel roster. so is the next section. this is distinguished by land holdings

*	Unique identifier can only be generated using parcel id
describe
sort Hhid A2aq2
isid Hhid A2aq2, missok

*	Create unique parcel identifier
generate parcel_id = Hhid + " " + string(A2aq2)
isid parcel_id

*	Housekeeping
rename Hhid hhid
rename A2aq4 plotsize_gps
rename A2aq5 plotsize_self
rename A2aq13a primary_use1
rename A2aq13b primary_use2

*	Relying on GPS plot size unless missing, then resorting to self report
*	Check correlation
pwcorr plotsize_gps plotsize_self
*	Overall corelation is quite low (0.14)
*	Looking ~within +/- 3 sd
summarize plotsize_gps plotsize_self
pwcorr plotsize_gps plotsize_self if inrange(plotsize_gps,0,48) & inrange(plotsize_self,0,48)
*	Correlation is much much higher within this range (0.72)
generate parc_size2 = plotsize_gps
replace parc_size2 = plotsize_self if parc_size2 == . & inrange(plotsize_self, 0, 48)
tabulate parc_size2, missing
tabulate plotsize_self, missing
*	parc_size2 missing 129 (~3%) observations
*	Plotsize_self missing 120 observations
*	Therefore low correlation b/w gps and self on remaining nine
*	Will drop 129 obs missing parc_size2
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

generate irrigated = 1 if A2aq20 == 1

keep hhid parcel_id parc_size2 fallow irrigated
*	Important note! Plot sizes above are actually parcel sizes
*	Parcels are larger than plots in this hierarchy
*	Kept the term plotsize to maintain consistent naming conventions with other countries
*	This could get confusing though?

*	Prepare for export
compress
describe
summarize 
sort parcel_id
save "`export'/2009_AGSEC2A", replace
