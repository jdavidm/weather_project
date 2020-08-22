* Project: WB Weather
* Created on: Aug 2020
* Created by: ek
* Stata v.16

* does
	* reads Uganda wave 3 owned plot info (2011_AGSEC2A) for the 1st season
	* ready to append to rented plot info (2011_AGSEC2B)
	* owned plots are in A and rented plots are in B
	* ready to be appended to 2011_AGSEC2B to make 2011_AGSEC2

* assumes
	* customsave.ado
	* mdesc.ado

* TO DO:
	* done

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
	log using "`logout'/2011_agsec2a", append

* **********************************************************************
* 1 - import data and rename variables
* **********************************************************************

* irrigation should be in this file but there is an error that replaces irrigation question with a sand type response

* import wave 2 season A
	use "`root'/2011_AGSEC2A.dta", clear
		
	rename			a2aq15b fallow
	rename			HHID hhid
	
	mdesc 			parcelID
	*** none missing out of 3457 observations
	
	isid 			hhid parcelID

* what was the primary use of the parcel
	*** activity in the first season is recorded seperately from activity in the second season
	tab 		 	a2aq11a 
	*** activities include renting out, pasture, forest. cultivation, and other0
	*** we will only include plots used for crops or fallow plots with cover crop
	
	keep			if a2aq11a == 1 | a2aq11a == 2 | a2aq11a == 5
	*** 133 observations deleted
	
* drop observations for fallow fields without covercrop
	tab				a2aq13b
	*** three types of fallow: bare, with residue incorporated, and with cover crop
	*** will leave cover crop fallow because cover crops can include beans etc
	
	drop 			if a2aq13b == 2 | a2aq13b == 3
	*** dropped 712 observations

* drop if proportion cultivated a2aq15a is 0
	*** note that the label incorrectly reports 2009 but the survey instrument reports 2010 season
	drop if a2aq15a == 0
	*** 0 observations deleted		

* **********************************************************************
* 2 - merge location data
* **********************************************************************	
	
* merge the location identification
	merge m:1 hhid using "`export'/2011_GSEC1"
	*** 72 unmatched from master
	*** that means 72 observations did not have location data
	*** no option at this stage except to drop all unmatched
	
	drop 		if _merge != 3	
	
* **********************************************************************
* 3 - clean plotsize
* **********************************************************************

	rename 			a2aq4	plotsizeGPS
	rename			a2aq5	plotsizeSR
	
	sum 			plotsizeGPS
	***	mean 2.01, max 75, min 0.01
	sum				plotsizeSR
	*** mean 2.12, max 100, min 0.01
	
	corr 			plotsizeSR plotsizeGPS
	*** 0.79 correlation, high correlation between GPS and self reported
	*** will only use SR to impute missing GPS
	
	mdesc 			plotsizeGPS
	*** 2599 missing
	*** a chance that the larger plots in waves 1 and 2 were unmeasured in this wave
	
* encode district to be used in imputation
	encode district, gen (districtdstrng) 
	
* impute missing plot sizes using predictive mean matching
	mi set 			wide // declare the data to be wide.
	mi xtset		, clear // this is a precautinary step to clear any existing xtset
	mi register 	imputed plotsizeGPS // identify plotsize_GPS as the variable being imputed
	sort			region district hhid parcelID, stable // sort to ensure reproducability of results
	mi impute 		pmm plotsizeGPS i.region i.districtdstrng plotsizeSR, add(1) rseed(245780) noisily dots ///
						force knn(5) bootstrap
	mi unset
	
* how did imputing go?
	sum 			plotsizeGPS_1_
	*** mean 2.05, max 75, min 0.01
	
	corr 			plotsizeGPS_1_ plotsizeSR if plotsizeGPS == .
	*** 0.85, higher correlation than non missing observations
	*** replace plotsizeGPS with imputation
	
	replace 		plotsizeGPS = plotsizeGPS_1_ if plotsizeGPS == .
	*** 1370 changes, one unchanged, impute that one

	drop			plotsizeGPS_1_ mi_miss

*check for still missing plotsizeGPS
	mdesc 			plotsizeGPS
	
	sort			plotsizeGPS
	*** missing plotsizes lack location data but have plotsizeSR
	*** replace missing plotsizeGPS with SR

	replace 		plotsizeGPS = plotsizeSR if plotsizeGPS == . & plotsizeSR != .
	*** 82 change made
	
* convert acres to square meters
	gen				plotsize = plotsizeGPS*0.404686
	label var       plotsize "Plot size (ha)"

* **********************************************************************
* 4 - end matter, clean up to save
* **********************************************************************
	rename			parcelID prcid
	rename 			a2aq15a propcultivate
	label variable	propcultivate "Proportion of plot cultivated for owned plots"
	
	keep 			hhid prcid propcultivate region district ///
					county subcounty parish plotsize
	*** hhid should identify households accross panel waves

	compress
	describe
	summarize

* save file
		customsave , idvar(hhid) filename("2011_AGSEC2A.dta") ///
			path("`export'/`folder'") dofile(2011_AGSEC2A) user($user)

* close the log
	log	close

/* END */