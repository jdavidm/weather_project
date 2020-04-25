*NIGER, VISIT 1, WAVE 1 (2010-2011): section 1&2 agriculture - access to land
*HELP (irrigated_cs & irrigated_rs)
*HELP need to convert fertilizer to standard unit in order to find the sum to create the fert app rate
*lots of rainy season info here

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Niger/analysis_datasets/Niger_raw/NER_2011_ECVMA_v01_M_Stata8/ecvmaas1_p1_en.dta", clear

rename menage hhid
*menage/hhid is the houshold id

describe
sort hid hhid passage as01qa as01q03 
isid hid hhid passage as01qa as01q03, missok

*hid is household identifier, hhid is household id - not sure what the difference is but it gives us both

*took a lot to uniquely identify! needed field number but not parcel number

rename as01qa id
rename as01q03 fieldid
rename as01q05 parcelid

rename as01q08 parcel_area_SR
rename as01q09 parcel_area_GPS
*all areas in sq. meters

rename as01q17 parcel_owner

rename as01q47 parcel_mgr
*id of person who works plot

rename as01q48 parcel_szn_use
*season(s) that the parcel was used

rename as02aq04 rs_use

rename as01q34a irrigate_source_cs
*during contre-saison
gen irrigated_cs = 1 if as01q35b >= 1
replace irrigated_cs = 0 if as01q35b == 0 
replace irrigated_cs = 0 if as01q35b ==.
*this variable as01q35b is the number of times that the parcel was irrigated during 
*the last contre-saison so I'm assuming if its greater than or equal to 1 then it was irrigated
*HELP: I replaced the missing values with 0 - is that okay?

tab irrigated_cs as01q35b

tab as01q39
gen irrigated_rs = 1 if as01q39 != 5 
replace irrigated_rs = 0 if as01q39 !=.
replace irrigated_rs = 1 if as01q39 == 1 
*waterway irrigation
replace irrigated_rs = 1 if as01q39 == 2
*well
replace irrigated_rs = 1 if as01q39 == 3
*drilling
replace irrigated_rs = 1 if as01q39 == 4
*dam, water retention
replace irrigated_rs = 1 if as01q39 == 6
replace irrigated_rs = 0 if as01q39 == 7
*HELP: 6 is "other"^ can we assume that other means irrigation? I'm pretty sure that I basically told it to count any other watering
*method as irrigation that isn't rainwater??

order irrigated_rs as01q39
tab irrigated_rs as01q39

rename as02aq05 rs_area
*area worked during rainy season in square meters

*FERTILIZER
rename as02aq10 fert_use_rs
*binary for fertilizer/chemical use

*UREA fertilizer
rename as02aq11a urea_q
rename as02aq11b urea_u
*unit for urea
tab urea_u

*DAP fertilizer
rename as02aq12a dap_q
rename as02aq12b dap_u
*unit for dap
tab dap_u

*NPK fertilizer
rename as02aq13a npk_q
rename as02aq13b npk_u

*mixed fertilizer
rename as02aq14a mix_q
rename as02aq14b mix_u
tab mix_u

*NEED TO FIND SUM FOR FERT APP RATE POST CONVERSION
*HELP: fert units that are weird and used are tas and tiyas 
*also, they used a code "9" but there is no code 9 included, it happened relatively frequently if you look at tabs
*could possibly be a 6 inputed incorrectly??

*PESTICIDE/HERBICIDE/FUNGICIDE BINARIES
gen pest_use_rs = 1 if as02aq16a > 0
replace pest_use_rs = 0 if as02aq16a ==0

gen herb_use_rs = 1 if as02aq18a > 0
replace herb_use_rs = 0 if as02aq18a ==0

gen fung_use_rs = 1 if as02aq17a > 0 
replace fung_use_rs = 0 if as02aq17a == 0
*_rs means during rainy season

*LABOR DAYS
*household days - survey question "each household member who worked on the parcel and the total number of days worked during the period of the preparation of the soil and before planting"
gen hh_1 = as02aq20b
replace hh_1 = 0 if hh_1 ==.
gen hh_2 = as02aq21b 
replace hh_2 = 0 if hh_2 ==.
gen hh_3 = as02aq22b
replace hh_3 = 0 if hh_3 ==.
gen hh_4 = as02aq23b
replace hh_4 = 0 if hh_4 ==.
gen hh_5 = as02aq24b
replace hh_5 = 0 if hh_5 ==. 
gen hh_6 = as02aq25b
replace hh_6 = 0 if hh_6 ==.

*non-family labor involved in soil preparation
*gayya or bogou
gen gb_men = as02aq26b
replace gb_men = 0 if gb_men==.
gen gb_women = as02aq26c
replace gb_women = 0 if gb_women==.
gen gb_child = as02aq26d
replace gb_child = 0 if gb_child==.

*non-family labor involved in soil prep (other - not gayya or bogou)
gen men = as02aq27b
replace men = 0 if men==.
gen women = as02aq27c
replace women = 0 if women==.
gen child = as02aq27d
replace child = 0 if child==.

gen labor_days_rs = hh_1+hh_2+hh_3+hh_4+hh_5+hh_6+gb_men+gb_women+gb_child+men+women+child

keep hid ///
hhid ///
passage ///
id ///
fieldid ///
parcelid ///
parcel_area_SR ///
parcel_area_GPS ///
parcel_owner ///
parcel_szn_use ///
rs_use ///
irrigate_source_cs ///
irrigated_cs ///
irrigated_rs ///
rs_area ///
fert_use_rs ///
urea_q ///
urea_u ///
dap_q ///
dap_u ///
npk_q ///
npk_u ///
mix_q ///
mix_u ///
pest_use_rs ///
herb_use_rs ///
fung_use_rs ///
labor_days_rs ///
hh_1 ///
hh_2 ///
hh_3 ///
hh_4 ///
hh_5 ///
hh_6 ///
gb_men ///
gb_women ///
gb_child ///
men ///
women ///
child ///
parcel_mgr ///



compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Niger/analysis_datasets/Niger_clean/data/wave_1/NER_w1_v1_sect1.dta", replace








