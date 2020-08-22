* Project: WB Weather
* Created on: Aug 2020
* Created by: ek
* Stata v.16

* does
	* reads Uganda wave 1 owned plot info (2009_AGSEC2A) for the 1st season
	* ready to append to rented plot info (2010_AGSEC2B)
	* owned plots are in A and rented plots are in B
	* ready to be appended to 2010_AGSEC2B

* assumes
	* customsave.ado
	* mdesc.ado

* TO DO:
	*	done
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths	
	loc 	root 		= 		"$data/household_data/uganda/wave_1/raw"  
	loc     export 		= 		"$data/household_data/uganda/wave_1/refined"
	loc 	logout 		= 		"$data/household_data/uganda/logs"

* close log 
	*log close
	
* open log	
	cap log close
	log using "`logout'/2009_agsec2a", append

**********************************************************************************
* 1	- clean up the key variables
**********************************************************************************

	use "`root'/2009_AGSEC2A", clear

	rename 			Hhid hhid
	rename 			A2aq2 prcid
	rename 			A2aq4 plotsizeGPS
	rename 			A2aq5 plotsizeSR
	rename			A2aq7 tenure
	
	describe
	sort hhid prcid
	isid hhid prcid
	
* make a variable that shows the irrigation
	gen irr_any = 1 if A2aq20 == 1
* **********************************************************************
* 2 - merge location data
* **********************************************************************	
	
* merge the location identification
	merge m:1 hhid using "`export'/2009_GSEC1"
	*** 0 unmatched from master
	drop 		if _merge != 3

**********************************************************************
* 3 - keeping cultivated land
************************************************************************	

* what was the primary use of the parcel
	tab 		 	A2aq13a 
	*** activities include renting out, pasture, forest. cultivation, and other0
	*** we will only include plots used for crops or fallow plots with cover crop
	
	keep			if A2aq13a == 1 | A2aq13a == 2
	*** 850 observations deleted
	
* **********************************************************************
* 3 - clean plotsize
* **********************************************************************

	sum 			plotsizeGPS
	***	mean 2.45, max 810, min 0
	*** plot size of zero looks to be a mistake
	sum				plotsizeSR
	*** mean 2.07, max 250, min 0

	corr 			plotsizeSR plotsizeGPS
	*** 0.178 correlation, low correlation between GPS and self reported
	*** will only use GPS
	
	tab 			plotsizeSR if plotsizeGPS == 0
	*** plotsizeSR is not reliably close to 0 to be used to replace GPS when GPS = 0
	*** change to missing if plotsizeGPS == 0 and impute

	replace 		plotsizeGPS = . if plotsizeGPS == 0
	*** 52 changes made
	
	mdesc 			plotsizeGPS
	
* impute missing plot sizes using predictive mean matching
	mi set 			wide // declare the data to be wide.
	mi xtset		, clear // this is a precautinary step to clear any existing xtset
	mi register 	imputed plotsizeGPS // identify plotsize_GPS as the variable being imputed
	sort			region district hhid prcid, stable // sort to ensure reproducability of results
	mi impute 		pmm plotsizeGPS i.region i.district plotsizeSR, add(1) rseed(245780) noisily dots ///
						force knn(5) bootstrap
	mi unset
	
* how did imputing go?
	sum 			plotsizeGPS_1_
	*** mean 2.85, max 810, min 0.01
	
	corr 			plotsizeGPS_1_ plotsizeSR if plotsizeGPS == .
	*** 0.1136 better correlation
	
	replace 		plotsizeGPS = plotsizeGPS_1_ if plotsizeGPS == .
	
	drop			mi_miss plotsizeGPS_1_
	
* impute one final observation that does not have self reported
	mi set 			wide // declare the data to be wide.
	mi xtset		, clear // this is a precautinary step to clear any existing xtset
	mi register 	imputed plotsizeGPS // identify plotsize_GPS as the variable being imputed
	sort			region district hhid prcid, stable // sort to ensure reproducability of results
	mi impute 		pmm plotsizeGPS i.region i.district, add(1) rseed(245780) noisily dots ///
						force knn(5) bootstrap
	mi unset
	
	replace 		plotsizeGPS = plotsizeGPS_1_ if plotsizeGPS == .
	
* convert acres to square meters
	gen				plotsize = plotsizeGPS*0.404686
	label var       plotsize "Plot size (ha)"

	mdesc 			plotsize
	*** none missing
* **********************************************************************
* 4 - end matter, clean up to save
* **********************************************************************

	keep 			hhid prcid region district county subcounty ///
					parish region_id plotsize irr_any
	*** hhid should identify households accross panel waves

	compress
	describe
	summarize

* save file
		customsave , idvar(hhid) filename("2009_AGSEC2A.dta") ///
			path("`export'/`folder'") dofile(2009_AGSEC2A) user($user)

* close the log
	log	close

/* END */	