*WAVE 3, POST HARVEST, NIGERIA SECTA3i 
*NOTE: this one has info regarding harvest, but the info provided is slightly different from info gathered in previous waves
*HELP: harvest conversions went very poorly - do we need to use wave 3 conversion key provided?


use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2015_GHSP-W3_v02_M_Stata/Post Harvest Wave 3/secta3i_harvestw3.dta", clear

describe
sort hhid plotid cropid
isid hhid plotid cropid, missok

rename sa3iq3 harvested
label variable harvested "in the last visit you indicated you had planted crop on plot. Did you harvest this crop on plot during this season?"

rename sa3iq4a1 harv_month

rename sa3iq4a2 harv_yr

*this is NOT plot size, this is the area that was harvested - should be used for yield?? 
*area needs to be standardized - need conversion 
gen crop_area = sa3iq5a
rename sa3iq5b area_unit
tab area_unit


merge m:1 zone using "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/conversion_files/land-conversion.dta"


**Figure out WHAT is not matching, in terms of cropcode and harv_unit - make a list 

drop _merge

tab area_unit
tab area_unit, nolabel

*converting land area
gen crop_area_hec = . 
replace crop_area_hec = crop_area*heapcon if area_unit==1
replace crop_area_hec = crop_area*ridgecon if area_unit==2
replace crop_area_hec = crop_area*standcon if area_unit==3
replace crop_area_hec = crop_area*plotcon if area_unit==4
replace crop_area_hec = crop_area*acrecon if area_unit==5
replace crop_area_hec = crop_area*sqmcon if area_unit==7
replace crop_area_hec = crop_area if area_unit == 6
label variable crop_area_hec "land area of crop harvested since last unit, converted to hectares"
***all converted appropriately (comparison of tabbed units to changes made)

*this part was not included in previous waves: survey question - percent of plot area harvested
rename sa3iq5c portion_plot
label variable portion_plot "% of plot area harvested"


*survey: how much did you harvest during this ag season?
gen harvestq = sa3iq6i
rename sa3iq6ii harv_unit

*HELP: THIS PART OF SURVEY WAS NOT IN WAVE 1 OR 2 BUT MAY BE VALUABLE?
rename sa3iq6b harv_done
rename sa3iq6c1 month_done
*we also have the year of harvest completion available if we need it

*HELP: the survey asks "how much more do you expect to harvest?" - do you want to include this for yield??? was not included in wave 1 or wave 2 so I'd assume we'd leave it out
rename sa3iq6d1 expect_q
rename sa3iq6d2 expect_unit
tab expect_unit

tab harv_unit
tab harv_unit, nolabel

merge m:1 cropcode harv_unit zone using "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/conversion_files/wave_3/ag_conv_w3_long.dta"
*identify what isn't merging

*converting harvest quantities to kgs
gen harv_kg = harvestq*conv
*missing bin/basket (10) of cassava, kolabut, cocoyam
*missing paint rubber(11) of poil palm, cashew
*missing milk cup (12) of ogbono, agbono
*missing congo small of agbono
*missing congo large of cashew nut, cocoa tree, cassava
*missing mudu (30) small of kola nut
*bowl medium (71) of cassava
*bowl large of cassava
*(82) piece large of sugar cane
*(90) small heap of plantain and agbono
*heap medium (91) of plantain, banana, palm tree
*heap medium yam, 
*small and medium bunch oil palm, small bunch palm tree
*medium stalk (111) cassava
*sack bag (130) yam, 132 of ogbono, yam, water yam, 
*mudu large (31) cassava
*132 of banana, small basket 140 of pear, oil palm
*150 basin small of kolanut
*cassava pick up (180)


order harvestq harv_unit conv harv_kg

drop _merge

merge m:1 cropcode expect_unit zone using  "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/conversion_files/wave_3/ag_conv_w3_long_2.dta"

gen expect_kg = expect_q*conv

sort expect_unit expect_q conv expect_kg
*check to see if this worked properly

***CALCULATE THESE

rename sa3iq6a crop_value

keep zone ///
state ///
lga ///
sector ///
ea ///
hhid ///
plotid ///
cropid ///
cropname ///
cropcode ///
harvested ///
harv_month ///
harv_yr ///
crop_area ///
area_unit ///
portion_plot ///
harvestq ///
harv_unit ///
harv_done ///
month_done ///
expect_q ///
expect_unit ///
crop_value ///
harv_kg ///
conv ///
expect_kg ///

compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_clean/data/wave_3/ph_secta3i.dta", replace




