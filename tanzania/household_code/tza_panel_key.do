* Project: WB Weather
* Created on: June 2020
* Created by: jdm
* Stata v.16

* does
	* reads in panel key
	* generates new id
	* outputs new panel key

* assumes
	* customsave.ado

* TO DO:
	* complete

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		cnvrt	=	"$data/household_data/tanzania/wave_3/raw"
	loc		export	=	"$data/household_data/tanzania/wave_3/refined"
	loc		logout 	= 	"$data/household_data/tanzania/logs"

* open log	
	log 	using 		"`logout'/tza_panel_key", append


* **********************************************************************
* 1 - process panel id key
* **********************************************************************

* read in data
	use			"`cnvrt'/NPSY3.PANEL.KEY.dta", clear

* drop duplicate individuals in households
	keep if		indidy3 == 1
	

* drop individual ids and all duplicate household records
	drop		indidy1 indidy2 indidy3 UPI3
	duplicates 	drop
	*** this gets us 5,010 unique households
	

* **********************************************************************
* 2 - end matter, clean up to save
* **********************************************************************

* verify unique household id
	isid		y3_hhid

	compress
	describe
	summarize 
	
* saving production dataset
	customsave , idvar(y3_hhid) filename(panel_key.dta) path("`export'") ///
			dofile(tza_panel_key) user($user) 

* close the log
	log	close

/* END */