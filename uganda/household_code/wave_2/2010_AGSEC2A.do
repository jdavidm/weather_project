* Project: WB Weather
* Created on: Aug 2020
* Created by: themacfreezie
* Edited by: ek
* Stata v.16

* does
	* reads Uganda wave 2 owned plot info (2010_AGSEC2A) for the 1st season
	* ready to append to rented plot info (2010_AGSEC2B)
	* owned plots are in A and rented plots are in B
	* ready to be appended to 2010_AGSEC2B

* assumes
	* customsave.ado
	* mdesc.ado

* TO DO:
	* done

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
	log using "`logout'/2010_agsec2a", append

* **********************************************************************
* 1 - import data and rename variables
* **********************************************************************

* import wave 2 season A
	use "`root'/2010_AGSEC2A.dta", clear
		
	rename			a2aq15b fallow
	rename			HHID hhid
	
	mdesc prcid
	*** none missing out of 3457 observations
	
	isid 			hhid prcid

* what was the primary use of the parcel
	*** activity in the first season is recorded seperately from activity in the second season
	tab 		 	a2aq13a 
	*** activities include renting out, pasture, forest. cultivation, and other0
	*** we will only include plots used for crops or fallow plots with cover crop
	
	keep			if a2aq13a == 1 | a2aq13a == 2 | a2aq13a == 5
	*** 95 observations deleted
	
* drop observations for fallow fields without covercrop
	tab 			fallow
	*** three types of fallow: bare, with residue incorporated, and with cover crop
	*** will leave cover crop fallow because cover crops can include beans etc
	
	drop 			if fallow == 2 | fallow == 3
	*** dropped 691 observations

* drop if proportion cultivated a2aq17a is 0
	*** note that the label incorrectly reports 2009 but the survey instrument reports 2010 season
	drop if a2aq17a == 0
	*** 14 observations deleted
	
* make an irrigation variable
	gen irr_any = 1 if a2aq20 == 1
	
* **********************************************************************
* 2 - merge location data
* **********************************************************************	
	
* merge the location identification
	merge m:1 hhid using "`export'/2010_GSEC1"
	*** 0 unmatched from master
	drop 		if _merge != 3
	
* **********************************************************************
* 3 - clean plotsize
* **********************************************************************

	rename 			a2aq4	plotsizeGPS
	rename			a2aq5	plotsizeSR
	
	sum 			plotsizeGPS
	***	mean 3.56, max 676, min 0.01
	*** quite a high max, should it be trusted?
	sum				plotsizeSR
	*** mean 2.07, max 100, min 0.01
	
	corr 			plotsizeSR plotsizeGPS
	*** 0.158 correlation, low correlation between GPS and self reported
	*** will only use GPS
	
	mdesc 			plotsizeGPS
	*** 835 missing
	
* encode district to be used in imputation
	encode district, gen (districtdstrng) 
	
* impute missing plot sizes using predictive mean matching
	mi set 			wide // declare the data to be wide.
	mi xtset		, clear // this is a precautinary step to clear any existing xtset
	mi register 	imputed plotsizeGPS // identify plotsize_GPS as the variable being imputed
	sort			region district hhid prcid, stable // sort to ensure reproducability of results
	mi impute 		pmm plotsizeGPS i.region i.districtdstrng plotsizeSR, add(1) rseed(245780) noisily dots ///
						force knn(5) bootstrap
	mi unset
	
* how did imputing go?
	sum 			plotsizeGPS_1_
	*** mean 4.39, max 676, min 0.01
	
	corr 			plotsizeGPS_1_ plotsizeSR if plotsizeGPS == .
	*** 0.41, higher correlation than non missing observations
	*** better than a low negative correlation when we exclude plotsizeSR from impute
	*** replace plotsizeGPS with imputation
	
	replace 		plotsizeGPS = plotsizeGPS_1_ if plotsizeGPS == .
	*** 834 changes, one unchanged, impute that one

	drop			plotsizeGPS_1_ mi_miss
	
* one observation with missing plotsizeGPS lacks regional data but has SR
	replace 		plotsizeGPS = plotsizeSR if plotsizeGPS == . & plotsizeSR != .
	*** one change made
	
* impute missing plot sizes that lacked plotsizeSR using predictive mean matching
	mi set 			wide // declare the data to be wide.
	mi xtset		, clear // this is a precautinary step to clear any existing xtset
	mi register 	imputed plotsizeGPS // identify plotsize_GPS as the variable being imputed
	sort			region district hhid prcid, stable // sort to ensure reproducability of results
	mi impute 		pmm plotsizeGPS i.region i.districtdstrng, add(1) rseed(245780) noisily dots ///
						force knn(5) bootstrap
	mi unset
	
* replace that missing value
	replace plotsizeGPS = plotsizeGPS_1_ if plotsizeGPS == .
	*** 5 changes
	
* convert acres to square meters
	gen				plotsize = plotsizeGPS*0.404686
	label var       plotsize "Plot size (ha)"
	
* **********************************************************************
* 4 - end matter, clean up to save
* **********************************************************************

	rename 			a2aq13a propcultivate
	label variable	propcultivate "Proportion of plot cultivated for owned plots"
	
	keep 			hhid prcid propcultivate region district irr_any ///
					county subcounty parish plotsize
	*** hhid should identify households accross panel waves

	compress
	describe
	summarize

* save file
		customsave , idvar(hhid) filename("2010_AGSEC2A.dta") ///
			path("`export'/`folder'") dofile(2010_AGSEC2A) user($user)

* close the log
	log	close

/* END */