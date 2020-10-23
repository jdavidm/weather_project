*NIGER, WAVE 1, VISIT 1, SECT3C - CONTRE-SAISON

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Niger/analysis_datasets/Niger_raw/NER_2011_ECVMA_v01_M_Stata8/ecvmaas3c_p1_en.dta", clear

describe 
*isid hid passage grappe menage, missok
rename menage hhid

rename as03cq02 inputcode_cs
label variable inputcode_cs "the type of input used on the plot"
replace inputcode_cs =0 if as03cq03 == 2
*basically, here I want it to show that the inputcode is 0 if the input was not used
*so any zeros in the input codes indicate that an input was not used on the parcel
replace inputcode_cs = 0 if inputcode_cs == 1
*dropping inputs regarding organiz manure
replace inputcode_cs = 0 if inputcode_cs ==2
*dropping inputs regarding use of organic compost
*essentially I only care about the inorganic or seed use in terms of inputs so I'm marking irrelevant inputs as 0

rename as03cq04 seedtype_cs
tab seedtype_cs
*the crop code is on page 17 of the survey (w1 pp) but I'll list the most frequently used ones here for reference:
* 1 = millet, 2 = sorghum, 8 = cowpeas, 10= peanuts

rename as03cq05a inputq_cs
*input quantity during rs
rename as03cq05b inputu_cs
*input unit
*problematic units include tiya, liter, heap, bag, donkey cart, cow cart, 99 (could be input error?)
tab inputu_cs

rename as03cq08b inputvalue_cs
*value in FCFA NEEDS CONVERSION
	
**binaries for herb/fung/pest
gen fung_use_cs = 0
replace fung_use_cs = 1 if inputcode_cs == 8

gen herb_use_cs = 0
replace herb_use_cs = 1 if inputcode_cs == 9

gen pest_use_cs = 0 
replace pest_use_cs = 1 if inputcode_cs == 7

tab inputcode_cs

**fertilizer quantities
gen fertq_cs = 0
replace fertq_cs = inputq_cs if inputcode_cs == 3 
*urea
replace fertq_cs = inputq_cs if inputcode_cs == 4
*dap
replace fertq_cs = inputq_cs if inputcode_cs == 5
*npk
replace fertq_cs = inputq_cs if inputcode_cs == 6
*mixed fertilizer

tab inputcode_cs inputu_cs
*check out the distribution of units here

/*
**fertilizer quantity conversions
gen fert_kg_cs = fertq_cs*conversion

keep hid ///
hhid ///
passage ///
grappe ///
inputcode_cs ///
seedtype_cs ///
inputq_cs ///
inputu_cs ///
inputvalue_cs ///
fung_use_cs ///
herb_use_cs ///
pest_use_cs ///
*/

compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Niger/analysis_datasets/Niger_clean/data/wave_1/NER_w1_v1_sect3c.dta", replace





