* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 2 (2012-2013), POST PLANTING, AG SECT 11D
	* determines fertilizer use / measurement
	* outputs clean data file ready for combination with wave 2 plot data

* assumes
	* customsave.ado
	* mdesc.ado
	
* TO DO:
	* complete

* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		root	=	"$data/household_data/nigeria/wave_2/raw"
	loc		export	=	"$data/household_data/nigeria/wave_2/refined"
	loc		logout	=	"$data/household_data/nigeria/logs"

* open log	
	log 	using 	"`logout'/wave_2_pp_sect11d", append
	

* **********************************************************************
* 1 - determine fertilizer  
* **********************************************************************
		
* import the first relevant data file
	use				"`root'/sect11d_plantingw2", clear 	
		
	describe
	sort			hhid plotid 
	isid			hhid plotid

* binary for fert use
	rename			s11dq1 fert_any
	lab var			fert_any "=1 if any fertilizer was used"

* drop manure observations
	drop if			s11dq3 == 3 | s11dq3 == 4
	drop if			s11dq7 == 3 | s11dq7 == 4
	drop if			s11dq15 == 3
	drop if			s11dq27 == 3
	*** dropped 156 observations (manure)
	
* quantity of fertilizer from different sources

* leftover fertilizer
	gen				leftover_fert_kg = s11dq4
	sum				leftover_fert_kg
	*** mean of 176, max of 800
	
	replace			leftover_fert_kg = 0 if leftover_fert_kg ==.
	
* free fertilizer
	gen				free_fert_kg = s11dq8
	sum				free_fert_kg
	*** mean of 7450 and max of 5000
	*** all values for this variable are way too large, we will exclude it
	
	replace			free_fert_kg = 0 if free_fert_kg ==. 

*purchased fertilizer
	gen				purchased_fert_kg1 = s11dq16
	sum				purchased_fert_kg1
	*** mean of 141 and max of 3500
	*** this max value is too high but will keep it and deal with by winsorizing

	gen				purchased_fert_kg2 = s11dq28
	sum				purchased_fert_kg2
	*** mean of 79 and max of 250
	
	replace			purchased_fert_kg1 = 0 if purchased_fert_kg1 ==. 
	replace			purchased_fert_kg2 = 0 if purchased_fert_kg2 ==. 
	*** the survey divides the fertilizer into left over, received for free, and purchased so here I combine them
	*** the quantity is giving in kgs so no conversion is needed

* generate variable for total fertilizer use
	gen				fert_use = leftover_fert_kg + purchased_fert_kg1 + purchased_fert_kg2
	lab var			fert_use "fertilizer use (kg)"

* check for missing values
	mdesc			fert_any fert_use	
	*** 18 fert_any missing no fert_use missing
	
* convert missing values to "no"
	replace			fert_any = 2 if fert_any == .
	
	
* **********************************************************************
* 3 - end matter, clean up to save
* **********************************************************************

	keep 			hhid zone state lga sector hhid ea plotid ///
					fert_any fert_use tracked_obs
	
* create unique household-plot identifier
	isid			hhid plotid
	sort			hhid plotid
	egen			plot_id = group(hhid plotid)
	lab var			plot_id "unique plot identifier"
	
	compress
	describe
	summarize 

* save file
		customsave , idvar(plot_id) filename("pp_sect11d.dta") ///
			path("`export'") dofile(pp_sect11d) user($user)

* close the log
	log	close

/* END */