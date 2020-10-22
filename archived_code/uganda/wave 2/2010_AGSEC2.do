* Project: WB Weather
* Created on: Aug 2020
* Created by: ek
* Stata v.16

* does
	* reads Uganda wave 2 owned plot info (2010_AGSEC2B) for the 2nd season
	* appends 2010_AGSEC2A to 2010_AGSEC2B
	* owned plots are in A and rented plots are in B
	* ready to merge with harvest and labor information

* assumes
	* 2010_AGSEC2A.dta for append
	* customsave.ado
	* mdesc.ado

* TO DO:
	* merge the rented and owned
	* decide if the GPS needs to imputed
	* questions regarding use of plot during season are in questions that appear with 1st and 2nd in the label

* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths	
	loc 	root 		= 		"$data/household_data/uganda/wave_2/raw"  
	loc     export 		= 		"$data/household_data/uganda/wave_2/refined"
	loc 	logout 		= 		"$data/household_data/uganda/logs"

* close log 
	*log close
	
* open log	
	cap log close
	log using "`logout'/2010_agsec2", append

* **********************************************************************
* 1 - import data and rename variables
* **********************************************************************

* import wave 2 season A
	use "`root'/2010_AGSEC2B.dta", clear
		
	rename			HHID hhid
	
	mdesc prcid
	*** none missing out of 1063 observations
	
	isid 			hhid prcid

* what was the primary use of the parcel
	*** activity in the first season is recorded seperately from activity in the second season
	tab 		 	a2bq15a 
	*** activities include cultivation, pasture, forest, fallow, and other
	*** we will only include plots used for crops or fallow plots with cover crop
	drop 			if a2bq15a == 96
	*** 74 deleted
	
	tab 			a2bq15a1
	
	drop			if a2bq15a1 == 2 | a2bq15a1 == 3
	*** 132 deleted


* **********************************************************************
* 2 - clean plotsize
* **********************************************************************

	rename 			a2bq4	plotsizeGPS
	rename			a2bq5	plotsizeSR
	
	sum 			plotsizeGPS
	***	mean 1.26, max 29, min 0.08
	*** quite a high max, should it be trusted?
	sum				plotsizeSR
	*** mean 1.09, max 10, min 0.1
	
	corr 			plotsizeSR plotsizeGPS
	*** 0.565 correlation, ok correlation between GPS and self reported
	*** but will only use GPS because section A only used GPS
	
* convert acres to square meters
	gen				plotsize = plotsizeGPS*4046.86
	label var       plotsize "Plot size (sqm)"
	
* **********************************************************************
* 3 - merge location data
* **********************************************************************	
	
* merge the location identification
	merge m:1 hhid using "`export'/2010_GSEC1"
	*** 0 unmatched from master
	drop 		if _merge != 3
	
* **********************************************************************
* 4 - end matter, clean up to save
* **********************************************************************
	
	keep 			hhid prcid region district ///
					county subcounty parish plotsize
	*** hhid should identify households accross panel waves
	
	append using  "`export'/2010_AGSEC2A"

	isid hhid prcid
	
	compress
	describe
	summarize

* save file
		customsave , idvar(hhid) filename("2010_AGSEC2.dta") ///
			path("`export'/`folder'") dofile(2010_AGSEC2) user($user)

* close the log
	log	close

/* END */