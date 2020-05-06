*WAVE 1 POST PLANTING, NIGERIA SECT 11E AG
*NEED TO CONVERT SEED UNITS TO KGS

use "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_raw/NGA_2010_GHSP-W1_v03_M_STATA/Post Planting Wave 1/Agriculture/sect11e_plantingw1.dta", clear

describe
sort hhid plotid cropid
isid hhid plotid cropid, missok
*hhid and plotid do not uniquely identify, with cropid they do

***SEEDS
gen leftover_q = s11eq6a
label variable leftover_q "quantity of last year's seed used"
rename s11eq6b leftover_unit1 
label variable leftover_unit1 "unit of last year's seed used (1=gram, 2=kilogram)"
rename s11eq6c leftover_unit2 
label variable leftover_unit2 "other unit of last year's seed used"
tab leftover_unit2 
tab leftover_unit1
*look at all these units! How do I account for these? 

*converting leftover units to kgs (not the weird units yet)
gen leftover_kg = .
replace leftover_kg = leftover_q if leftover_unit1 == 2
replace leftover_kg = leftover_q*100 if leftover_unit1 == 1

gen freeseed_q = s11eq10a
label variable freeseed_q "quantity of free seed used"
rename s11eq10b freeseed_unit1
label variable freeseed_unit1 "unit of free seed used (1=gram, 2=kilogram)"
rename s11eq10c freeseed_unit2
label variable freeseed_unit2 "unit of free seed used (other)"
tab freeseed_unit2
tab freeseed_unit1

*converting freeseed units to kgs (not the weird units yet)
gen freeseed_kg = .
replace freeseed_kg = freeseed_q if freeseed_unit1 == 2
replace freeseed_kg = freeseed_q*100 if freeseed_unit1 == 1

gen purchased_qa = s11eq17a
label variable purchased_qa "quantity of purchased seed used from first source"
rename s11eq17b purchased_unit1_a
label variable purchased_unit1_a "unit of purchased seed used (1=gram, 2=kilogram)from first source"
rename s11eq17c purchased_unit2_a
label variable purchased_unit2_a "unit of purchased seed used (other) from first source"
tab purchased_unit2_a
tab purchased_unit1_a

*converting purchased units to kgs from first source (not the weird units yet)
gen purchaseda_kg = .
replace purchaseda_kg = purchased_qa if purchased_unit1_a == 2
replace purchaseda_kg = purchased_qa*100 if purchased_unit1_a == 1

/*dropping second source purchase because there are only 17 observations
gen purchased_qb = s11eq28a
tab purchased_qb
label variable purchased_qb "quantity of purchased seed used from second source"
rename s11eq28b purchased_unit1_b
label variable purchased_unit1_b "unit of purchased seed used (1=gram, 2=kilogram)from second source"
rename s11eq28c purchased_unit2_b
label variable purchased_unit2_b "unit of purchased seed used (other) from second source"
tab purchased_unit2_b
tab purchased_unit1_b
*look at all the different variables used - how do we count these?

*converting purchased units to kgs from second source (not the weird units yet)
gen purchasedb_kg = .
replace purchasedb_kg = purchased_qb if purchased_unit2_a == 2
replace purchasedb_kg = purchased_qb*100 if purchased_unit2_a == 1
*/

*adding all of the converted seed quantities (need to also convert the weird units and add them to this total)
gen seed_kg = .
replace seed_kg = leftover_kg + freeseed_kg + purchaseda_kg 



keep zone ///
state ///
lga ///
hhid ///
ea ///
plotid ///
cropid ///
leftover_q ///
leftover_unit1 ///
leftover_unit2 ///
freeseed_q ///
freeseed_unit1 ///
freeseed_unit2 ///
purchased_qa ///
purchased_unit1_a ///
purchased_unit2_a ///
seed_kg ///
freeseed_kg ///
leftover_kg ///
purchaseda_kg ///


compress
describe
summarize 

save "/Users/alisonconley/Dropbox/Weather_Project/Data/Nigeria/analysis_datasets/Nigeria_clean/data/wave_1/pp_sect11e.dta", replace

