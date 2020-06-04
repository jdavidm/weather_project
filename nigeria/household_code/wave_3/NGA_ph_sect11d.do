* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Edited by: ek
* Stata v.16

* does
	* reads in Nigeria, WAVE 3 (2015-2016), POST HARVEST, NIGERIA AG SECT11D - Fertilizer
	* determines fertilizer use / measurement
	* outputs clean data file ready for combination with wave 2 plot data

* assumes
	* customsave.ado
	* mdesc.ado
	
* TO DO:
	*correct imputation process and remove outliers

* **********************************************************************
* 0 - setup
* **********************************************************************

* set global user
	global user "emilk"
	
* define paths	
	loc root = "G:/My Drive/weather_project/household_data/nigeria/wave_3/raw"
	loc export = "G:/My Drive/weather_project/household_data/nigeria/wave_3/refined"
	loc logout = "G:/My Drive/weather_project/household_data/nigeria/logs"

* close log (in case still open)
	*log close
	
* open log	
	log using "`logout'/ph_sect11d", append

* **********************************************************************
* 1 - determine fertilizer and conversion to kgs
* **********************************************************************
		
* import the first relevant data file
		use "`root'/secta11d_harvestw3", clear 

describe
sort hhid plotid 
isid hhid plotid

*binary for fert use
rename s11dq1 fert_any
	lab var			fert_any "=1 if any fertilizer was used"

	*drop manure/compost observations
	
	tab sect11dq7
	tab s11dq15 
	tab s11dq27
	tab s11dq3
	
	drop if s11dq15==3
	***1 observation deleted
	drop if s11dq15_os=="COMPOST"
	***1 observation deleted
	
	
	* quantity of fertilizer from different sources

* leftover fertilizer
	gen				leftover_fert_kg = s11dq4a
	replace leftover_fert_kg= leftover_fert_kg*1000 if s11dq4b==2
	replace			leftover_fert_kg = 0 if leftover_fert_kg ==.
	sum leftover_fert_kg
	***Maximum observation is 500000kg which is too high
	
* free fertilizer
	gen				free_fert_kg = sect11dq8a
	replace 		free_fert_kg=free_fert_kg*1000 if sect11dq8b==2
	sum				free_fert_kg
	***Observations are too high the mean is 35000kg
	
	
	replace			free_fert_kg = 0 if free_fert_kg ==. 

*purchased fertilizer
	gen				purchased_fert_kg1 = s11dq16a
	replace purchased_fert_kg1 = purchased_fert_kg1*1000 if s11dq16b==2
	sum				purchased_fert_kg1
	***Observations are too high
	

	gen				purchased_fert_kg2 = s11dq28a
	replace purchased_fert_kg2 = purchased_fert_kg2*1000 if s11dq28b==2
	sum				purchased_fert_kg2
	***observations are too high

	
	replace			purchased_fert_kg1 = 0 if purchased_fert_kg1 ==. 
	replace			purchased_fert_kg2 = 0 if purchased_fert_kg2 ==. 
	*** the survey divides the fertilizer into left over, received for free, and purchased so here I combine them


* generate variable for total fertilizer use
	gen				fert_use = leftover_fert_kg + purchased_fert_kg1 + purchased_fert_kg2
	lab var			fert_use "fertilizer use (kg)"

	* summarize fertilizer
	sum				fert_use, detail
	*** median 0, mean 3908, max 1.25e+07

* replace any +3 s.d. away from median as missing
	replace			fert_use = . if fert_use > `r(p50)'+(3*`r(sd)')
	*** 5 changes made
	
* impute missing values
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed fert_use // identify kilo_fert as the variable being imputed
	sort			hhid plotid, stable // sort to ensure reproducability of results
	mi impute 		pmm fert_use i.state, add(1) rseed(245780) ///
						noisily dots force knn(5) bootstrap
	mi 				unset
	
* how did the imputation go?
	tab				mi_miss
	tabstat			fert_use fert_use_1_, by(mi_miss) ///
						statistics(n mean min max) columns(statistics) ///
						longstub format(%9.3g) 
	replace			fert_use = fert_use_1_
	lab var			fert_use "fertilizer use (kg), imputed"
	drop			fert_use_1_
	*** imputed 5 values out of 5,914 total observations
	

	
* check for missing values
	mdesc			fert_any fert_use	
	*** 9 fert_any missing 5 fert_use missing
	
* convert missing values to "no"
	replace			fert_any	=	2	if	fert_any	==	.
	replace 		fert_use	=	2	if 	fert_use	==	.

* **********************************************************************
* 3 - end matter, clean up to save
* **********************************************************************

	keep 			hhid zone state lga sector hhid ea plotid ///
					fert_any fert_use

* create unique household-plot identifier
	isid			hhid plotid
	sort			hhid plotid
	egen			plot_id = group(hhid plotid)
	lab var			plot_id "unique plot identifier"
	
	compress
	describe
	summarize 
	
* save file
		customsave , idvar(hhid) filename("ph_sect11d.dta") ///
			path("`export'/`folder'") dofile(ph_sect11d) user($user)

* close the log
	log	close

/* END */