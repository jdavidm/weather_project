clear all

*attempting to clean Ethiopia household variables
global user "themacfreezie"

**********************************************************************************
**	ESS Wave 2 - Post Planting Section 3 
**********************************************************************************
*	Seems to correspond to Malawi ag-modC and ag-modJ

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_raw\Wave3_2015"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Ethiopia\analysis_datasets\Ethiopia_refined\Wave3_2015"

*	Build conversion id into conversion dataset
use "`root'/ET_local_area_unit_conversion.dta"
generate conv_id = string(region) + " " + string(zone) + " " + string(woreda) + " " + string(local_unit)
save "`root'/ET_local_area_unit_conversion_use.dta", replace
clear

use "`root'/sect3_pp_w3.dta", clear

*	Dropping duplicates
duplicates drop

*	Investigate unique identifier
describe
sort holder_id ea_id parcel_id field_id
isid holder_id parcel_id field_id, missok

*creating unique region identifier
egen region_id = group( saq01 saq02)
label var region_id "Unique region identifier"

*Field status check
rename pp_s3q03 status

* Drop observations with a missing field_id
summarize if missing(parcel_id,field_id)
drop if missing(parcel_id,field_id)
isid holder_id parcel_id field_id

* Create conversion key 
generate conv_id = string(saq01) + " " + string(saq02) + " " + string(saq03) + " " + string(pp_s3q02_c)
merge m:1 conv_id using "`root'/ET_local_area_unit_conversion_use.dta"

drop region zonename zone woredaname woreda
replace local_unit = pp_s3q02_c if local_unit == .
summarize local_unit

*infer local units from district, region, or country means
egen avg_dis = mean(conversion), by(saq01 saq02 pp_s3q02_c)
egen avg_reg = mean(conversion), by(saq01 pp_s3q02_c)
egen avg_eth = mean(conversion), by(pp_s3q02_c)

replace conversion  = avg_dis if conversion == .
replace conversion  = avg_reg if conversion == .
replace conversion  = avg_eth if conversion == .
replace conversion = . if local_unit == .
*Do not drop observations that lack local units since they may have gps values

drop if _merge == 2
drop _merge avg_dis avg_reg avg_eth

* Generate self-reported land area of plot w/ conversions
tabulate pp_s3q02_c, missing // Unit of land area, self-reported
generate cfactor = 10000 if pp_s3q02_c==1
replace cfactor = 1 if pp_s3q02_c==2
replace cfactor = conversion if pp_s3q02_c==local_unit & pp_s3q02_c!=1 & pp_s3q02_c!=2
* Problem! There are over 12,000 obs with units of measure not included in the conversion file
summarize pp_s3q02_c, detail // Quantity of land units, self-reported
generate selfreport_sqm = cfactor * pp_s3q02_a if pp_s3q02_c!=0
summarize selfreport_sqm, detail // resulting land area (sq. meters)
generate selfreport_ha = selfreport_sqm * 0.0001
summarize selfreport_ha, detail // resulting land area (hectares)

* To check the work above the following command is helpful
* order(conv_id saq01 region saq02 zone saq03 woreda pp_s3q02_c local_unit conversion cfactor pp_s3q02_d selfreport_sqm selfreport_ha)

* Generate GPS & rope-and-compass land area of plot in hectares 
* As a starting point, we expect both to be more accurate than self-report 
summarize pp_s3q04 pp_s3q08_a
generate gps = pp_s3q05_a * 0.0001 if pp_s3q04 == 1
generate rap = pp_s3q08_b * 0.0001 if pp_s3q08_a == 1
summarize gps rap, detail

* Compare GPS and self-report, and look for outliers in GPS 
summarize gps, detail 	//	same command as above to easily access r-class stored results 
list gps rap selfreport_ha if !inrange(gps,`r(p50)'-(3*`r(sd)'),`r(p50)'+(3*`r(sd)')) & !missing(gps)	
* Look at GPS and self-reported observations that are > ±3 Std. Dev's from the median 

* GPS on the larger side vs self-report
tabulate gps if gps>2, plot	// GPS doesn't seem outrageous. However, 22 obs > 10 ha
* In Wave 1 there were NO GPS measured fields > 10 ha. None
sort gps		
list gps rap selfreport_ha if gps>3 & !missing(gps), sep(0)	// Large gps values are sometimes way off from the self-reported

* GPS on the smaller side vs self-report 
summarize gps if gps<0.002 // ~3,000 obs
tabulate gps if gps<0.002, plot		
* Like wave 1, data distirubtion is somewhat lumpy due to the precision constraints of the technology 
* Including 430 obs that Stata recognizes as gps = 0 
sort gps					
list gps selfreport_ha if gps<0.002, sep(0)	// GPS tends to be less than self-reported size

pwcorr gps rap // 0.57 correlation - midrange
pwcorr selfreport_ha rap 	// correlation very low
pwcorr selfreport_ha gps	// correlation also very low
pwcorr selfreport_ha gps if inrange(gps,0.002,4) & inrange(selfreport_ha,0.002,4)	// 0.87 - much better if we restrict range for both
*twoway (scatter selfreport_ha gps if inrange(gps,0.002,4) & inrange(selfreport_ha,0.002,4))
pwcorr gps rap if !inrange(gps,0.002,4) // 0.93 - correlation outside of this range, surpirsingly high (unlike wave1)
pwcorr gps rap if inrange(gps,0.002,4) // 0.63 -strange! lower correlation inside this middle range than outside 

* Make plotsize_GPS using GPS area if it is within reasonable range
generate plotsize_GPS = gps /*if gps>0.002 & gps<4*/ // leaving this out due to the high correlation observed above
replace plotsize_GPS = rap if plotsize_GPS == . & rap != . // replace missing values with rap
summarize selfreport_ha gps rap plotsize_GPS, detail	//	we have some self-report information where we are missing plotsize_GPS 
summarize selfreport_ha if missing(plotsize_GPS), detail

*	Impute missing plot sizes using predictive mean matching 
mi set wide 					//	declare the data to be wide. 
mi xtset, clear					//	this is a precautinary step to clear any xtset that the analyst may have had in place previously
mi register imputed plotsize_GPS	//	identify plotsize_GPS as the variable being imputed 
mi impute pmm plotsize_GPS selfreport_ha i.region_id, add(1) rseed(245780) noisily dots /*
*/	force knn(5) bootstrap 
mi unset

*	summarize results of imputation
tabulate mi_miss	//	this binary = 1 for the full set of observations where plotsize_GPS is missing
tabstat gps rap selfreport_ha plotsize_GPS plotsize_GPS_1_, by(mi_miss) statistics(n mean min max) columns(statistics) longstub format(%9.3g) 

*	verify that there is nothing to be done to get a plot size for the observations where plotsize_GPS_1_ is missing
list gps rap selfreport_ha plotsize_GPS if missing(plotsize_GPS_1_), sep(0) // there are some missing values that we have GPS for
replace plotsize_GPS_1_ = gps if missing(plotsize_GPS_1_) & !missing(gps) // replace with existing gps values
drop if missing(plotsize_GPS_1_) // drop remaining missing values

*	Manipulate variables for export
rename (plotsize_GPS plotsize_GPS_1_)(plotsize_GPS_raw plotsize_GPS)
label variable plotsize_GPS		"Plot Size (GPS - ha)"

* Look at irrigation dummy
generate irrigated = pp_s3q12 if pp_s3q12 >= 1
label variable irrigated "Is field irrigated?"

* Look at fertilizer use
generate fert_any = pp_s3q14 if pp_s3q14 >= 1
label variable fert_any "Is fertilizer used on field?"
generate org_fert_any = pp_s3q25 if pp_s3q25 >= 1
label variable org_fert_any "Do you use any organic fertilizer on field?"
generate kilo_fert = pp_s3q16_a + pp_s3q19_a
label var kilo_fert "Kilograms of fertilizer applied (Urea and DAP only)"
*kilo_fert only captures Urea and DAP 
*no quantities are provided for compost, manure, or organic fertilizer

*Planting labor
generate laborday_plant_hh = (pp_s3q27_b * pp_s3q27_c) + (pp_s3q27_f * pp_s3q27_g) ///
+ (pp_s3q27_j * pp_s3q27_k) + (pp_s3q27_n * pp_s3q27_o) + (pp_s3q27_r * pp_s3q27_s) ///
+ (pp_s3q27_v * pp_s3q27_w) + (pp_s3q27_z * pp_s3q27_ca) + pp_s3q29_b + pp_s3q29_d + pp_s3q29_f
generate laborday_plant_hired = pp_s3q28_b + pp_s3q28_e + pp_s3q28_h
generate labordays_plant = laborday_plant_hh + laborday_plant_hired
drop laborday_plant_hh laborday_plant_hired
label var labordays_plant "Total Days of Planting Labor - Household and Hired"

* Look at crop mix
generate crop_1 = pp_s3q31_b if pp_s3q31_b >= 0
label variable crop_1 "What is the crop used for the first and second harvest? (Crop #1 Code)"
generate crop_2 = pp_s3q31_d if pp_s3q31_d >= 0
label variable crop_2 "What is the crop used for the first and second harvest? (Crop #2 Code)"

*	Creating a merge variable for sect9_ph_w2
generate field_ident = holder_id + " " + string(parcel_id) + " " + string(field_id)

rename household_id hhid
rename household_id2 hhid2
rename saq01 district
rename saq02 region
rename saq03 ward
rename plotsize_GPS plot_size2

*	Restrict to variables of interest 
*	This is how world bank has their do-file set up. If we want to keep all identifiers (i.e. region, zone, etc) we can do that easily
keep  holder_id- pp_s3q02_c status kilo_fert labordays_plant plot_size2 selfreport_ha irrigated fert_any org_fert_any crop_1 crop_2 field_ident
order holder_id- saq06 parcel_id field_id

* Final preparations to export
compress
describe
summarize 
sort holder_id parcel_id field_id
save "`export'/sect3_pp_w3", replace
