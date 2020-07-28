*NIGER, WAVE 1, VISIT 1, SECT3B - contre-saison

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Niger/analysis_datasets/Niger_raw/NER_2011_ECVMA_v01_M_Stata8/ecvmaas3b_p1_en.dta", clear

describe
isid hid passage grappe menage as03bqa as03bq01 as03bq03, missok

rename as03bqa orderid
rename as03bq01 fieldid
rename as03bq03 parcelid
rename as03bq05 subparcelid

rename as03bq04 worked_cs
rename as03bq07 cropcode
*codes identified on p17 of survey
label variable cropcode "what type of crop was cultivated during the contre-saison?"



keep hid ///
passage ///
menage ///
grappe ///
orderid ///
fieldid ///
parcelid ///
subparcelid ///
worked_cs ///
cropcode ///

compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Niger/analysis_datasets/Niger_clean/data/wave_1/NER_w1_v1_sect3b.dta", replace






