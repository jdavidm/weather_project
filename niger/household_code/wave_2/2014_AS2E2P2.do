* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigera, WAVE 2 (2014), POST HARVEST (second visit), ECVMA2_AS2E2P2
	* determines primary crop & cleans harvest
	* converts to kilograms
	* produces value of harvest (Naria) 
	* including determining regional prices ... 
	* outputs clean data file ready for combination with wave 2 hh data

* assumes
	* customsave.ado
	* probably a conversion file
	
* TO DO:
	* EVERYTHING
	* clarify "does"
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths	
	loc root 		= 		"$data/household_data/niger/wave_2/raw"
   *loc cnvrt 		=		"$data/household_data/niger/conversion_files"
	loc export 		= 		"$data/household_data/niger/wave_2/refined"
	loc logout 		= 		"$data/household_data/niger/logs"

* open log	
	log using "`logout'/2014_AS2E2P2", append
		

* **********************************************************************
* 1 - harvest information
* **********************************************************************

* import the first relevant data file
		use 				"`root'/ECVMA2_AS2E2P2", clear 	
		
* need to rename for English
	rename 			PASSAGE visit
	label 			var visit "number of visit"
	rename			GRAPPE clusterid
	label 			var clusterid "cluster number"
	rename			MENAGE hh_num
	label 			var hh_num "household number - not unique id"
	rename 			EXTENSION extension 
	label 			var extension "extension of household"
	*** will need to do these in every file
	rename 			AS02EQD ord 
	label 			var ord "number of order"
	rename 			AS01Q01 field 
	label 			var field "field number"
	rename 			AS01Q03 parcel 
	label 			var parcel "parcel number"
	
* need to include clusterid, hhnumber, extension, order, field, and parcel to uniquely identify
	describe
	sort 			clusterid hh_num extension ord field parcel
	isid 			clusterid hh_num extension ord field parcel
		
		rename 				AS02EQ110B cropcode
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