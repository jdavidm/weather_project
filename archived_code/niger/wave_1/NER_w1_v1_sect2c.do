* NIGER, Wave 1 (2010-2011) Vist 1, Sect2c - Rainy Season
*this goes over input use, but it's essentially binary whether it was used or not which is information that can also be found in sect1
use "/Users/alisonconley/Dropbox/Weather_Project/Data/Niger/analysis_datasets/Niger_raw/NER_2011_ECVMA_v01_M_Stata8/ecvmaas2c_p1_en.dta", clear

rename menage hhid

*describe
*isid hhid hid passage grappe, missok
***having a hard time getting it to uniquely identify

rename as02cq02 inputcode_rs
label variable inputcode_rs "the type of input used on the plot"
replace inputcode_rs =0 if as02cq03 == 2
*basically, here I want it to show that the inputcode is 0 if the input was not used
*so any zeros in the input codes indicate that an input was not used on the parcel
replace inputcode_rs = 0 if inputcode == 1
*dropping inputs regarding organiz manure
replace inputcode_rs = 0 if inputcode ==2
*dropping inputs regarding use of organic compost
*essentially I only care about the inorganic or seed use in terms of inputs so I'm marking irrelevant inputs as 0


rename as02cq04 seedtype_rs
tab seedtype_rs
*the crop code is on page 17 of the survey but I'll list the most frequently used ones here for reference:
* 1 = millet, 2 = sorghum, 8 = cowpeas, 10= peanuts

rename as02cq05a inputq_rs
*input quantity during rs
rename as02cq05b inputu_rs
*input unit
*problematic units include tiya, liter, heap, bag, donkey cart, cow cart, 99 (could be input error?)
tab inputu_rs

rename as02cq08b inputvalue_rs

keep hid ///
hhid ///
passage ///
grappe ///
inputcode_rs ///
seedtype_rs ///
inputq_rs ///
inputu_rs ///
inputvalue_rs ///

compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Niger/analysis_datasets/Niger_clean/data/wave_1/NER_w1_v1_sect2c.dta", replace

