clear all

*attempting to clean Uganda household variables
global user "themacfreezie"

**********************************************************************************
**	UNPS 2009 (Wave 1) - Agriculture Section 2B
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2009"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2009"

use "`root'/2009_AGSEC2B", clear

*	also looks like a parcel roster. this time for lands the house doesn't own but has access to

*	Unique identifier can only be generated using parcel id 
describe
sort Hhid A2bq2
isid Hhid A2bq2, missok

*	Create unique parcel identifier
generate parcel_id = Hhid + " " + string(A2bq2)
isid parcel_id

*	Housekeeping
rename Hhid hhid
rename A2bq4 plotsize_gps
rename A2bq5 plotsize_self
rename A2bq15a primary_use1
rename A2bq15b primary_use2

*	Relying on GPS plot size unless missing, then resorting to self report
*	Check correlation
pwcorr plotsize_gps plotsize_self
*	Overall corelation is low (0.305)
*	Looking ~within +/- 3 sd
summarize plotsize_gps plotsize_self
pwcorr plotsize_gps plotsize_self if inrange(plotsize_gps,0,9.81) & inrange(plotsize_self,0,9.81)
*	Correlation is higher within this range (0.49)
*	What about +/- 2 sd? Or +/- 1 sd?
pwcorr plotsize_gps plotsize_self if inrange(plotsize_gps,0,6.77) & inrange(plotsize_self,0,6.77)
pwcorr plotsize_gps plotsize_self if inrange(plotsize_gps,0,3.73) & inrange(plotsize_self,0,3.73)

merge m:1 hhid using "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2009\2009_GSEC1.dta"
keep if _merge == 3
drop _merge

drop if plotsize_gps == . & plotsize_self == . 
drop if plotsize_gps == 0 & plotsize_self == 0

rename plotsize_gps gps
replace gps = . if gps == 0 

* Compare GPS and self-report, and look for outliers in GPS 
summarize gps, detail 	//	same command as above to easily access r-class stored results 
list gps plotsize_self if !inrange(gps,`r(p50)'-(3*`r(sd)'),`r(p50)'+(3*`r(sd)')) & !missing(gps)	
* Look at GPS and self-reported observations that are > ±3 Std. Dev's from the median  

* Make plotsize_GPS using GPS area if it is within reasonable range
generate plotsize_gps = gps if gps>`r(p50)'-(3*`r(sd)') & gps<`r(p50)'+(3*`r(sd)')
summarize plotsize_self gps plotsize_gps, detail	//	we have some self-report information where we are missing plotsize_GPS 
summarize plotsize_self if missing(plotsize_gps), detail

*	Impute missing plot sizes using predictive mean matching 
mi set wide 					//	declare the data to be wide. 
mi xtset, clear					//	this is a precautinary step to clear any xtset that the analyst may have had in place previously
mi register imputed plotsize_gps	//	identify plotsize_GPS as the variable being imputed 
mi impute pmm plotsize_gps plotsize_self i.region_id, add(1) rseed(245780) noisily dots /*
*/	force knn(5) bootstrap 
mi unset

* Compare GPS and self-report, and look for outliers in GPS 
summarize plotsize_gps_1_, detail 	//	same command as above to easily access r-class stored results 
list plotsize_gps_1_ plotsize_self plotsize_gps if !inrange(gps,`r(p50)'-(3*`r(sd)'),`r(p50)'+(3*`r(sd)')) & !missing(gps)	
* Look at GPS and self-reported observations that are > ±3 Std. Dev's from the median  
pwcorr plotsize_gps plotsize_self plotsize_gps_1_ if inrange(plotsize_gps,0,9.81) & inrange(plotsize_self,0,9.81)
*	Correlation is higher within this range (0.49)
*	What about +/- 2 sd? Or +/- 1 sd?
pwcorr plotsize_gps plotsize_self plotsize_gps_1_ if inrange(plotsize_gps,0,6.77) & inrange(plotsize_self,0,6.77)
pwcorr plotsize_gps plotsize_self  plotsize_gps_1_ if inrange(plotsize_gps,0,3.73) & inrange(plotsize_self,0,3.73)

*BRIAN WHAT DO YOU THINK OF THIS? - from line 35 through 83

*	Do we need to account for fallowed fields?
generate fallow = 1 if primary_use1 == 5
replace fallow = 1 if primary_use2 == 5

generate irrigated = 1 if A2bq19 == 1

*	Use rights variable
generate use_rights = 1

keep hhid parcel_id plotsize_gps plotsize_self fallow irrigated use_rights
*	Important note! Plot sizes above are actually parcel sizes
*	Parcels are larger than plots in this hierarchy
*	Kept the term plotsize to maintain consistent naming conventions with other countries
*	This could get confusing though?

*	Prepare for export
compress
describe
summarize 
sort parcel_id
save "`export'/2009_AGSEC2B", replace
