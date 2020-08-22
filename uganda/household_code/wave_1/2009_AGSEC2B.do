* Project: WB Weather
* Created on: Aug 2020
* Created by: ek
* Stata v.16

* does
	* reads Uganda wave 1 rented plot info (2009_AGSEC2B) for the 1st season
	* appends 2009_AGSEC2A to 2009_AGSEC2B 
	* creates plotsize data to merge with labor, fertilizer etc.

* assumes
	* customsave.ado
	* mdesc.ado
	* cleaned wave 1 owned plot info (2009_AGSEC2B)

* TO DO:
	*	Important note! Plot sizes above are actually parcel sizes
	*	Parcels are larger than plots in this hierarchy
	*	Kept the term plotsize to maintain consistent naming conventions with other countries
	*	This could get confusing though?
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths	
	loc 	root 		= 		"$data/household_data/uganda/wave_1/raw"  
	loc     export 		= 		"$data/household_data/uganda/wave_1/refined"
	loc 	logout 		= 		"$data/household_data/uganda/logs"

* open log	
	cap log close
	log using "`logout'/2009_agsec2b", append

**********************************************************************************
* 1	- clean up the key variables
**********************************************************************************

	use "`root'/2009_AGSEC2B", clear

	rename 			Hhid hhid
	rename 			A2bq2 prcid
	rename 			A2bq4 plotsizeGPS
	rename 			A2bq5 plotsizeSR
	
	describe
	sort hhid prcid
	isid hhid prcid

* make an irrigation variable
	gen 		irr_any = 1 if A2bq19 == 1
* **********************************************************************
* 2 - merge location data
* **********************************************************************	
	
* merge the location identification
	merge m:1 hhid using "`export'/2009_GSEC1"
	*** 0 unmatched from master
	drop 		if _merge != 3

* **********************************************************************
* 3 - keeping cultivated land
* **********************************************************************	

* what was the primary use of the parcel
	tab 		 	A2bq15a 
	*** activities include renting out, pasture, forest. cultivation, and other0
	*** we will only include plots used for crops or fallow plots with cover crop
	
	keep			if A2bq15a == 1 | A2bq15a == 2
	*** 322 observations deleted
	
* **********************************************************************
* 3 - clean plotsize
* **********************************************************************

	sum 			plotsizeGPS
	***	mean 0.72, max 80.9, min 0
	*** plot size of zero looks to be a mistake
	sum				plotsizeSR
	*** mean 1.04, max 25, min 0

	corr 			plotsizeSR plotsizeGPS
	*** 0.378 correlation, decent correlation between GPS and self reported
	*** will only use GPS
	
	tab 			plotsizeSR if plotsizeGPS == 0
	*** plotsizeSR is not reliably close to 0 to be used to replace GPS when GPS = 0
	*** change to missing if plotsizeGPS == 0 and impute

	replace 		plotsizeGPS = . if plotsizeGPS == 0
	*** 215 changes made
	
	mdesc 			plotsizeGPS
	*** 776 missing
	
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
	*** mean 1.11, max 80.9, min 0.01
	
	corr 			plotsizeGPS_1_ plotsizeSR if plotsizeGPS == .
	*** 0.375 similar correlation to before
	
	replace 		plotsizeGPS = plotsizeGPS_1_ if plotsizeGPS == .
	
	drop			mi_miss plotsizeGPS_1_
	
	mdesc 			plotsizeGPS 
	
* impute one final observations that does not have self reported
	mi set 			wide // declare the data to be wide.
	mi xtset		, clear // this is a precautinary step to clear any existing xtset
	mi register 	imputed plotsizeGPS // identify plotsize_GPS as the variable being imputed
	sort			region district hhid prcid, stable // sort to ensure reproducability of results
	mi impute 		pmm plotsizeGPS i.region i.district, add(1) rseed(245780) noisily dots ///
						force knn(5) bootstrap
	mi unset
	
	replace 		plotsizeGPS = plotsizeGPS_1_ if plotsizeGPS == .
	
* the remaining missing plotsizes have SR so we'll replace with SR
	replace 		plotsizeGPS = plotsizeSR if plotsizeGPS == .
	
* convert acres to square meters
	gen				plotsize = plotsizeGPS*0.404686
	label var       plotsize "Plot size (ha)"

	mdesc 			plotsize
	*** none missing	
	
* **********************************************************************
* 4 - end matter, clean up to save
* **********************************************************************
	
	keep 			hhid prcid region district ///
					irr_any county subcounty parish plotsize
	*** hhid should identify households accross panel waves
	
	append using  "`export'/2009_AGSEC2A"

	mdesc 			hhid prcid plotsize
	*** none missing
	
	isid hhid prcid
	
	compress
	describe
	summarize

* save file
		customsave , idvar(hhid) filename("2009_AGSEC2.dta") ///
			path("`export'/`folder'") dofile(2009_AGSEC2B) user($user)

* close the log
	log	close

/* END */