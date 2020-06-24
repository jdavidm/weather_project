* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 1 POST PLANTING, NIGERIA SECT 11E AG
	* determines seed use 
	* converts kilograms, as appropriate
	* maybe more who knows
	* outputs clean data file ready for combination with wave 1 hh data

* assumes
	* customsave.ado
	
* other notes: 
	* still includes some notes from Alison Conley's work in spring 2020
	
* TO DO:
	* from Alison: "NEED TO CONVERT SEED UNITS TO KGS"
	* unsure - incomplete, runs but maybe not right? 
	* clarify "does" section

* **********************************************************************
* 0 - setup
* **********************************************************************
	
* define paths	
	loc root = "$data/household_data/nigeria/wave_1/raw"
	loc export = "$data/household_data/nigeria/wave_1/refined"
	loc logout = "$data/household_data/nigeria/logs"

* close log (in case still open)
	*log close
	
* open log	
	log using "`logout'/pp_sect11e", append

* **********************************************************************
* 1 - deterine seed use
* **********************************************************************
		
* import the first relevant data file
		use "`root'/sect11e_plantingw1", clear 	

describe
sort hhid plotid cropid
isid hhid plotid cropid, missok
*hhid and plotid do not uniquely identify, with cropid they do

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

****ISSUES HERE??****
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
*NEED TO CONVERT WEIRD UNITS AND ADD TO THIS TOTAL


*ALJ OPINION (6 May) - OMIT SEEDS - these values are a nightmare, official word from WB was to use food conversions to approximate seed measurement, which seems problematic
*as we are already missing seed for Malawi - would not be inappropriate or entirely out of line to omit here as well

* **********************************************************************
* 2 - end matter, clean up to save
* **********************************************************************

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

* save file
		customsave , idvar(hhid) filename("pp-sect11e.dta") ///
			path("`export'/`folder'") dofile(pp_sect11e) user($user)
*note on customsave issue - 2547 observation(s) are missing the ID variable hhid 

* close the log
	log	close

/* END */