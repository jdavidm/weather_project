* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 1 (2010-2011), POST HARVEST, NGA SECTA3 AG 
	* determines primary crop & cleans harvest
	* converts to kilograms
	* produces value of harvest (Naria) - need to include conversion to Naria 
	* outputs clean data file ready for combination with wave 1 hh data

* assumes
	* customsave.ado
	* harvconv.dta conversion file
	
* TO DO:
	* convert Naira to USD
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths	
	loc root 		= 		"$data/household_data/nigeria/wave_1/raw"
	loc cnvrt 		=		"$data/household_data/nigeria/conversion_files"
	loc export 		= 		"$data/household_data/nigeria/wave_1/refined"
	loc logout 		= 		"$data/household_data/nigeria/logs"

* close log 
	log close
	
* open log	
	log using "`logout'/wave_1_ph_secta3", append
		

* **********************************************************************
* 1 - harvest information
* **********************************************************************

* import the first relevant data file
		use 				"`root'/secta3_harvestw1", clear 	

		rename 				sa3q2 cropcode
		tab 				cropcode
	*** main crop is "cassava old" 
	*** cassava is continuous cropping, so not using that as a main crop
	*** going to use maize, which is second most cultivated crop
		drop				if cropcode == . 

		rename 				sa3q1 cropname

		describe
		sort 				hhid plotid cropid cropcode
		isid 				hhid plotid cropid cropcode, missok

		gen 				crop_area = sa3q5a
		label 				variable crop_area "what was the land area of crop harvested since the last interview? not using standardized unit"
		rename 				sa3q5b area_unit

* **********************************************************************
* 2 - conversion to kilograms
* **********************************************************************

* create harvested quantity variable 
		gen 				harvestq = sa3q6a
		label 				variable harvestq "quantity harvested, not in standardized unit"

* determine units of harvest 
		rename 				sa3q6b harv_unit
		tab 				harv_unit
		tab 				harv_unit, nolabel

		merge m:1 cropcode harv_unit using "`cnvrt'/harvconv"
	*** matched 9,917 but didn't match 5,212 (from master 3,101 and using 2,111)
	*** drop these unmatched - either not producing, no unit collected, or coming from merge conversion file 
	*** values not matched from master usually had issue which prevented harvest e.g. lost crop
	
keep if _merge == 3
drop _merge


*converting harvest quantities to kgs
gen harv_kg = harvestq*harv_conversion

order harvestq harv_unit harv_conversion harv_kg
tab harv_kg, missing
	*5272 missing values generated in harv_kg - looks like either missing unit or missing harvest quantity

rename sa3q3 cultivated

gen cp_hrv = harv_kg if cropcode == 1080 

* **********************************************************************
* 3 - value of harvest 
* **********************************************************************
*STILL NEEDS TO BE CONVERTED TO USD

gen crop_value = sa3q18
label variable crop_value "if you had sold all crop harvested since the last visit, what would be the total value in Naira?"
rename crop_value tf_hrv 

* **********************************************************************
* 4 - end matter, collapse, clean up to save
* **********************************************************************

keep hhid ///
zone ///
state ///
lga ///
sector ///
hhid ///
ea ///
plotid ///
cropid ///
cropcode ///
cp_hrv ///
tf_hrv ///

compress
describe
summarize 

* save file
		customsave , idvar(hhid) filename("ph_secta3.dta") ///
			path("`export'/`folder'") dofile(ph_secta3) user($user)
						
* close the log
	log	close

/* END */