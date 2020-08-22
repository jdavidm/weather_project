* Project: WB Weather
* Created on: Aug 2020
* Created by: ek
* Stata v.16

* does
	* reads Uganda wave 3 rented plot info (2011_AGSEC2B) for the 1st season
	* appends 2011_AGSEC2A to 2011_AGSEC2B
	* owned plots are in A and rented plots are in B
	* ready to merge with harvest and labor information

* assumes
	* 2011_AGSEC2A.dta for append
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
	loc 	root 		= 		"$data/household_data/uganda/wave_3/raw"  
	loc     export 		= 		"$data/household_data/uganda/wave_3/refined"
	loc 	logout 		= 		"$data/household_data/uganda/logs"

* close log 
	*log close
	
* open log	
	cap log close
	log using "`logout'/2011_agsec2b", append

* **********************************************************************
* 1 - import data and rename variables
* **********************************************************************

* import wave 2 season A
	use "`root'/2011_AGSEC2B", clear
		
	rename			HHID hhid
	
	mdesc parcelID
	*** none missing out of 1063 observations
	
	isid 			hhid parcelID

* what was the primary use of the parcel
	*** activity in the first season is recorded seperately from activity in the second season
	tab 		 	a2bq12a 
	*** activities include cultivation, pasture, forest, fallow, and other
	tab 			a2bq12a_1
	*** we will only include plots used for crops or fallow plots with cover crop
	keep			if a2bq12a == 1 | a2bq12a == 2 | a2bq12a == 5
	*** 42 deleted
	drop 			if a2bq12a_1 == 2 | a2bq12a_1 == 3
	*** 87 deleted 
	
* **********************************************************************
* 3 - merge location data
* **********************************************************************	
	
* merge the location identification
	merge m:1 hhid using "`export'/2011_GSEC1"
	*** 24 unmatched from master, no better option than to drop them at this point
	drop 		if _merge != 3
	
* **********************************************************************
* 4 - clean plotsize
* **********************************************************************

	rename 			a2bq4	plotsizeGPS
	rename			a2bq5	plotsizeSR
	
	sum 			plotsizeGPS
	***	mean 1.24, max 12.2, min 0.07
	sum				plotsizeSR
	*** mean 1.1, max 12, min 0.01
	
	corr 			plotsizeSR plotsizeGPS
	*** 0.902 correlation, high correlation between GPS and self reported
	*** but will only use GPS because section A only used GPS
	
	mdesc 			plotsizeGPS
	*** 789 missing
	mdesc			plotsizeSR if plotsizeGPS==.
	*** 0 missing
	
* encode district to use in imputation
	encode			district, gen(districtdstrng)
	
* impute missing plotsize values using predictive mean matching
	mi set 			wide // declare the data to be wide.
	mi xtset		, clear // this is a precautinary step to clear any existing xtset
	mi register 	imputed plotsizeGPS // identify plotsize_GPS as the variable being imputed
	sort			region district hhid parcelID, stable // sort to ensure reproducability of results
	mi impute 		pmm plotsizeGPS i.region i.districtdstrng plotsizeSR, add(1) rseed(245780) noisily dots ///
						force knn(5) bootstrap
	mi unset
	
* how did imputing go?
	sum 			plotsizeGPS_1_
	*** mean 1.08, max 12.2, min 0.07
	
	corr 			plotsizeGPS_1_ plotsizeSR
	*** 0.818, pretty close to the correlation we had on line 85, looks good
	
	replace 		plotsizeGPS = plotsizeGPS_1_ if plotsizeGPS == .
	*** 746 changes
	drop 			plotsizeGPS_1_ mi_miss
	
	mdesc 			plotsizeGPS
	sort			plotsizeGPS
	*** 43 missing. Missing because those observations lack location data
	*** replace them with SR
	
* replace values
	replace plotsizeGPS = plotsizeSR if plotsizeGPS == .
	*** 43 changes
	
* convert acres to square meters
	gen				plotsize = plotsizeGPS*0.404686
	label var       plotsize "Plot size (ha)"
	
* **********************************************************************
* 4 - end matter, clean up to save
* **********************************************************************
	rename 			parcelID prcid
	
	keep 			hhid prcid region district ///
					county subcounty parish plotsize
	*** hhid should identify households accross panel waves
	
	append using  "`export'/2011_AGSEC2A"

	isid hhid prcid
	
	compress
	describe
	summarize

* save file
		customsave , idvar(hhid) filename("2011_AGSEC2.dta") ///
			path("`export'/`folder'") dofile(2011_AGSEC2B) user($user)

* close the log
	log	close

/* END */