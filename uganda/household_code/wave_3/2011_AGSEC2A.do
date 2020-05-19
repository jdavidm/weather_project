clear all

*attempting to clean Uganda household variables
global user "themacfreezie"

**********************************************************************************
**	UNPS 2011 (Wave 3) - Agriculture Section 2A 
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2011"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2011"

use "`root'/2011_AGSEC2A", clear

*	looks like a parcel roster. so is the next section. this is distinguished by land holdings

*	Unique identifier can only be generated using parcel id
describe
sort HHID parcelID
isid HHID parcelID, missok

*	Create unique parcel identifier
generate parcel_id = string(HHID) + " " + string(parcelID)
*	isid parcel_id
*	for some reason the above is not uniquely identifying observations
*	even though isid HHID parcelID worked...
duplicates report parcel_id
*	lots of duplicates, I think the stringed HHID is rounding off
drop parcel_id

*	attempting to string HHID seperately
*	tostring HHID, replace force
*	isid HHID parcelID, missok
*	the above is still not unique
*	duplicates report HHID parcelID
*	still around 270 duplicates

*	trying something different
tostring HHID, generate(hhid) format(%012.0f) force
duplicates report hhid parcelID
*	now only 61 duplicates but still not 100%

tabulate HHID
*	some HHIDs seem to be as long as 16 digits!

drop hhid
tostring HHID, generate(hhid) format(%016.0f) force
duplicates report hhid parcelID
* 	no duplicates!

*	Create unique parcel identifier
generate parcel_id = hhid + " " + string(parcelID)
isid parcel_id
*	unique!!

rename a2aq4 plotsize_gps
rename a2aq5 plotsize_self
rename a2aq11a primary_use1
rename a2aq11b primary_use2

*	Relying on GPS plot size unless missing, then resorting to self report
*	Check correlation
pwcorr plotsize_gps plotsize_self
*	Overall corelation is high! (0.83)
*	Looking ~within +/- 3 sd
summarize plotsize_gps plotsize_self
pwcorr plotsize_gps plotsize_self if inrange(plotsize_gps,0,16.45) & inrange(plotsize_self,0,16.45)
*	Correlation is slightly higher within this range (0.87)
*	Seems almost negligible?

generate parc_size2 = plotsize_gps
replace parc_size2 = plotsize_self if parc_size2 == .
tabulate parc_size2, missing
*	No missing observations!
rename parc_size2 parc_size
generate parc_size2 = parc_size * 0.404686
drop parc_size

/* or!
generate parc_size2 = plotsize_gps
replace parc_size2 = plotsize_self if parc_size2 == . & inrange(plotsize_self, 0, 16.45)
tabulate parc_size2, missing
*	Missing 36 (~1%) observations 

*	Should I attempt to impute missing plotsizes?
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

generate irrigated = 1 if a2aq18 == 1
*	it looks like two wires got crossed here
*	labelled the same as a2aq16
*	i think the underlying coding is correct (i.e. 1 = irrigated)
* 	gonna proceed under this assumption

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
save "`export'/2011_AGSEC2A", replace
