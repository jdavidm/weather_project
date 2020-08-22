* Project: WB Weather
* Created on: Aug 2020
* Created by: ek
* Stata v.16

* does
	* reads Uganda wave 2 rented plot info (2010_AGSEC2B) for the 1st season
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
	log using "`logout'/2010_agsec2b", append

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

* gen irrigation binary
	gen irr_any = 1 if a2bq19 == 1
* **********************************************************************
* 3 - merge location data
* **********************************************************************	
	
* merge the location identification
	merge m:1 hhid using "`export'/2010_GSEC1"
	*** 0 unmatched from master
	drop 		if _merge != 3
	
* **********************************************************************
* 4 - clean plotsize
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
	
	mdesc 			plotsizeGPS
	*** 616 missing
	mdesc			plotsizeSR if plotsizeGPS==.
	*** 9 missing
	
* encode district to use in imputation
	encode			district, gen(districtdstrng)
	
* impute missing plotsize values using predictive mean matching
	mi set 			wide // declare the data to be wide.
	mi xtset		, clear // this is a precautinary step to clear any existing xtset
	mi register 	imputed plotsizeGPS // identify plotsize_GPS as the variable being imputed
	sort			region district hhid prcid, stable // sort to ensure reproducability of results
	mi impute 		pmm plotsizeGPS i.region i.districtdstrng plotsizeSR, add(1) rseed(245780) noisily dots ///
						force knn(5) bootstrap
	mi unset
	
* how did imputing go?
	sum 			plotsizeGPS_1_
	*** mean 1.17, max 29, min 0.08
	
	corr 			plotsizeGPS_1_ plotsizeSR
	*** 0.482, pretty close to the correlation we had on line 87, looks good
	
	replace 		plotsizeGPS = plotsizeGPS_1_ if plotsizeGPS == .
	*** 601 changes
	drop 			plotsizeGPS_1_ mi_miss
	
* impute the remaining missing values without SR
	mi set 			wide // declare the data to be wide.
	mi xtset		, clear // this is a precautinary step to clear any existing xtset
	mi register 	imputed plotsizeGPS // identify plotsize_GPS as the variable being imputed
	sort			region district hhid prcid, stable // sort to ensure reproducability of results
	mi impute 		pmm plotsizeGPS i.region i.districtdstrng, add(1) rseed(245780) noisily dots ///
						force knn(5) bootstrap
	mi unset
	
* replace values
	replace plotsizeGPS = plotsizeGPS_1_ if plotsizeGPS == .
	*** 9 changes
	
* convert acres to square meters
	gen				plotsize = plotsizeGPS*0.404686
	label var       plotsize "Plot size (ha)"

* **********************************************************************
* 4 - end matter, clean up to save
* **********************************************************************
	
	keep 			hhid prcid region district irr_any ///
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