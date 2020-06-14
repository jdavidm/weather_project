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

* collapse duplicate individuals in households
	collapse (count) indidy1 indidy2 indidy3, by( y1_hhid y2_hhid y3_hhid)
	
	sort y1_hhid y2_hhid y3_hhid, stable

* generate numeric ids
	egen		y1id = group(y1_hhid)
	egen		y2id = group(y2_hhid)
	egen		y3id = group(y3_hhid)

* fill in missing values
	xtset		y1id
	xfill		y2_hhid if y2_hhid == "", i(y1id)
	xfill		y3_hhid if y3_hhid == "", i(y1id)
	
	xtset		y2id
	xfill		y1_hhid if y1_hhid == "", i(y2id)
	xfill		y3_hhid if y3_hhid == "", i(y2id)

	xtset		y3id
	xfill		y2_hhid if y2_hhid == "", i(y3id)	

* drop individual ids and all duplicate household records
	drop		indidy1 indidy2 indidy3 y1id y2id y3id
	duplicates 	drop
	*** this gets us 8,482 unique households
	
* generate a unique household id
	gen			uid = _n
	

* **********************************************************************
* 2 - end matter, clean up to save
* **********************************************************************

* verify unique household id
	isid		uid
	
	order		uid

	compress
	describe
	summarize 
	
* saving production dataset
	customsave , idvar(uid) filename(panel_key.dta) path("`export'") ///
			dofile(tza_panel_key) user($user) 

* close the log
	log	close

/* END */