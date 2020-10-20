clear all

*attempting to clean Uganda household variables
global user "themacfreezie"

**********************************************************************************
**	UNPS 2015 (Wave 5) - Agriculture Section 2B 
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2015"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2015"

use "`root'/2015_AGSEC2B", clear

*	also looks like a parcel roster. this time for lands the house doesn't own but has access to

*	Unique identifier can only be generated using parcel id
describe
sort HHID parcelID
isid HHID parcelID, missok

*	Create unique parcel identifier
generate parcel_id = HHID + " " + string(parcelID)
isid parcel_id

*	Housekeeping
rename HHID hhid
rename a2bq4 plotsize_gps
rename a2bq5 plotsize_self
rename a2bq12a primary_use1
rename a2bq12b primary_use2

*	Relying on GPS plot size unless missing, then resorting to self report
*	Check correlation
pwcorr plotsize_gps plotsize_self
*	Correlation is high (0.84)
summarize plotsize_gps plotsize_self
pwcorr plotsize_gps plotsize_self if inrange(plotsize_gps,0,3.71) & inrange(plotsize_self,0,3.71)
*	Correlation is about the same. A little lowr actually (0.83)

generate parc_size2 = plotsize_gps
replace parc_size2 = plotsize_self if parc_size2 == .
tabulate plotsize_self, missing
tabulate parc_size2, missing
*	parc_size2 missing no observations
drop if parc_size2 == .
rename parc_size2 parc_size
generate parc_size2 = parc_size * 0.404686
drop parc_size

*	Do we need to account for fallowed fields?
generate fallow = 1 if primary_use1 == 5
replace fallow = 1 if primary_use2 == 5

*	Checking irrigation
generate irrigated = 1 if a2bq16 == 1

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
save "`export'/2015_AGSEC2B", replace
