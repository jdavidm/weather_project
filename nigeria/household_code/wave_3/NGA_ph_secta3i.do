* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Edited by: ek
* Stata v.16

* does
	* reads in Nigeria, WAVE 3, (2015-2016) POST HARVEST, NIGERIA SECTA3i
	* determines harvest information (area and quantity) and that maize is the second most widely cultivated crop///
	* outputs clean data file ready for combination with wave 3 hh data

	* WILL WANT TO DROP INFORMATION ON LAND AREA

* assumes
	* customsave.ado
	* land-conversion.dta conversion file

* other notes:
	* still includes some notes from Alison Conley's work in spring 2020

* TO DO:
	* this has info regarding harvest, but the info provided is different from previous waves
	* cannot identify what isnt merging. identify what isn't merging when converting harvest quantities
	* make this do file look more like wave 2 NGA_ph_secta3.do file


* **********************************************************************
* 0 - setup
* **********************************************************************

	* define paths
		loc 	root		= 	"$data/household_data/nigeria/wave_3/raw"
		loc		cnvrt		=	"$data/household_data/nigeria/conversion_files"
		loc 	export 		= 	"$data/household_data/nigeria/wave_3/refined"
		loc 	logout 		= 	"$data/household_data/nigeria/logs"

	* open log
		*log 	using		"`logout'/ph_secta1", append

* **********************************************************************
* 1 - determine area harvested
* **********************************************************************

* import the first relevant data file
		use 					"`root'/secta3i_harvestw3", clear

		describe
		sort 				hhid plotid cropid
		isid 				hhid plotid cropid
		
		tab 			cropcode	
	*** cassava is most widely cropped 16.41% wont use cassava as main crop
	*** maize is second most widely cropped 14.38% we use maize as main crop
	
	tab sa3iq4
	
	* drop observations in which it was not harvest season
	drop if sa3iq4	==	9	|	sa3iq4	==	10	|	sa3iq4	==	11
	***1450 deleted
	
	replace sa3iq6i 	= 	0 	if 	sa3iq6i	==	. 	& 	sa3iq3	==	2
	***228 changes
	replace sa3iq6a 	= 	0 	if 	sa3iq6a	==	. 	& 	sa3iq3	==	2
	***228 changes
	
	* drop if missing both harvest quantities and harvest value
	drop if 	sa3iq6a	==	. 	& 	sa3iq6i	==	.
	***12 deleted
	
	* replace missing value if quantity is not missing
	replace			sa3iq6a = 0 if sa3iq6a == . & sa3iq6i != .
	***33 changes
	
* replace missing quantity if value is not missing
	replace			sa3iq6i = 0 if sa3iq6i == . & sa3iq6a != .
	***no changes
	
	* check to see if there are missing observations for quantity and value
	mdesc 			sa3iq6i sa3iq6a
	*** no missing values
	
	describe
	sort 			hhid plotid cropid
	isid 			hhid plotid cropid

	* **********************************************************************
* 2 - generate harvested values
* **********************************************************************

* create quantity harvested variable
	gen 			harvestq = sa3iq6i
	lab	var			harvestq "quantity harvested, not in standardized unit"

* units of harvest
	rename 			sa3iq6ii harv_unit
	tab				harv_unit, nolabel

* create value variable
	gen 			crop_value = sa3iq6a
	rename 			crop_value vl_hrv

* convert 2015 Naria to constant 2010 USD
	replace			vl_hrv = vl_hrv/204.9997322
	lab var			vl_hrv 	"total value of harvest in 2010 USD"
	*** value comes from World Bank: world_bank_exchange_rates.xlxs

* summarize value of harvest
	sum				vl_hrv, detail
	*** median 97.56, mean 253.16, max 28292.72

* replace any +3 s.d. away from median as missing
	replace			vl_hrv = . if vl_hrv > `r(p50)'+(3*`r(sd)')
	*** replaced 149 values, max is now 1951.22
	
	* impute missing values
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed vl_hrv // identify kilo_fert as the variable being imputed
	sort			hhid plotid cropid, stable // sort to ensure reproducability of results
	mi impute 		pmm vl_hrv i.state i.cropid, add(1) rseed(245780) ///
						noisily dots force knn(5) bootstrap
	mi 				unset	

* how did the imputation go?
	tab				mi_miss
	tabstat			vl_hrv vl_hrv_1_, by(mi_miss) ///
						statistics(n mean min max) columns(statistics) ///
						longstub format(%9.3g) 
	replace			vl_hrv = vl_hrv_1_
	lab var			vl_hrv "Value of harvest (2010 USD), imputed"
	drop			vl_hrv_1_
	***imputed 149 observations out of 10,494
	*** mean from 201 to 203, max = 1951
	
* **********************************************************************
* 3 - generate maize harvest quantities
* **********************************************************************

* merge harvest conversion file
	merge 			m:1 cropcode harv_unit using "`cnvrt'/harvconv_wave_3" 
	
	*** WILL NEED TO USE DIFFERENT FILE THAN PREVIOUS - alj will update file appropriately but file in folder named here should work 
	*** 9069 matched
	*** of those 1425 not matched, of those 92 are maize
	*** of those 92, 65 did not harvest and 7 who did harvest had a crop failure - so should set those equal to zero 
	*** okay with mismatch in using - not every crop and unit are used in the master 
		
* drop unmerged using
	drop if			_merge == 2
	

* **********************************************************************
* 4 - end matter, clean up to save
* **********************************************************************

* drop variables without household ids
		drop 				if	hhid==.
		*** 3565 are dropped

		keep 				hhid zone state lga sector ea hhid plotid cropid cropcode ///
								tf_hrv cp_hrv

		compress
		describe
		summarize

* save file
		customsave , idvar(hhid) filename("ph_secta3i.dta") ///
			path("`export'/`folder'") dofile(ph_secta3i) user($user)

* close the log
		log	close

/* END */
