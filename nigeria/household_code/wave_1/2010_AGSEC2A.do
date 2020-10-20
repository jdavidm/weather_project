* Project: WB Weather
* Created on: Aug 2020
* Created by: ek
* Stata v.16

* does
	* reads in Uganda wave 2 (2010-2011) 2010_AGSEC2A and 2010_AGSEC2B
	* 2010_AGSEC2A concern a household's current land holdings
	* 2010_AGSEC2B concern land household's have use rights to.
	* we clean each one seperately and then merge them

* assumes
	* customsave.ado
	* mdesc.ado

* TO DO:
	* everything
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths	
	loc 	root 		= 		"$data/household_data/uganda/wave_2/raw"
	loc 	export 		= 		"$data/household_data/uganda/wave_2/refined"
	loc 	logout 		= 		"$data/household_data/uganda/logs"

* close log 
	*log close
	
* open log	
	cap log close
	log using "`logout'/2010_AGSEC2A", append

* **********************************************************************
* 1 - plotsize information
* **********************************************************************

* import the first relevant data file
	use 		"`root'/2010_AGSEC2A", clear 	
	
	rename 		HHID hhid
	rename 		prcid parcid
	rename 		a2aq15b fallow
	rename 		a2aq4 plotsizegps
	rename 		a2aq5 plotsizesr
	
	drop if fallow == 2 | fallow == 3
	
* **********************************************************************
* 2 - compare self reported and gps plotsize
* **********************************************************************
	