*WAVE 2 POST PLANTING, NGA AG SECT11E - SEED
***NEED HELP WITH CONVERSION

use "/Users/aljosephson/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2012_GHSP-W2_v02_M_STATA/Post Planting Wave 2/Agriculture/sect11e_plantingw2.dta", clear

describe
sort hhid plotid cropid
isid hhid plotid cropid, missok

rename s11eq3 seed_use
*binary for seed use

*the survey divides the seed into free, leftover, and purchased - but they
*have variable units so they can't be added together until the units are standardized

gen leftover_q = s11eq6a
label variable leftover_q "quantity of last year's seed used"
rename s11eq6b leftover_unit
label variable leftover_unit "unit of last year's seed used"
tab leftover_unit
*look at all these units! How do I account for these? 

gen freeseed_q = s11eq10a
label variable freeseed_q "quantity of free seed used"
rename s11eq10b freeseed_unit
label variable freeseed_unit "unit of free seed used"
tab freeseed_unit

gen purchased_qa = s11eq18a
label variable purchased_qa "quantity of purchased seed used from first source"
rename s11eq18b purchased_unit_a
label variable purchased_unit_a "unit of purchased seed used from first source"
tab purchased_unit_a

gen purchased_qb = s11eq30a
label variable purchased_qb "quantity of purchased seed used from second source"
rename s11eq30b purchased_unit_b
label variable purchased_unit_b "unit of purchased seed used from second source"
tab purchased_unit_b


*look at all the different variables used - how do we count these?

keep zone ///
state ///
lga ///
hhid ///
ea ///
plotid ///
cropid ///
leftover_q ///
leftover_unit ///
freeseed_q ///
freeseed_unit ///
purchased_qa ///
purchased_unit_a ///
purchased_qb ///
purchased_unit_b ///
seed_use ///
tracked_obs ///

*omitting several oil pam obs - alj

compress
describe
summarize 

save "/Users/aljosephson/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_clean/data/wave_2/pp_sect11e.dta", replace

