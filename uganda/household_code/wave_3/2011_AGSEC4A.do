* Project: WB Weather
* Created on: Aug 2020
* Created by: ek
* Stata v.16

* does
	* Crop output
	* reads Uganda wave 3 crops grown and seeds used (2011_AGSEC4A) for the 1st season
	* 3A - 5A are questionaires for the first planting season
	* 3B - 5B are questionaires for the second planting season

* assumes
	* customsave.ado
	* mdesc.ado

* TO DO:
	* determine what month people start planting the first season based on their location

* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths	
	loc 	root 		= 		"$data/household_data/uganda/wave_3/raw"  
	loc     export 		= 		"$data/household_data/uganda/wave_3/refined"
	loc 	logout 		= 		"$data/household_data/uganda/logs"
	
* open log	
	cap log close
	log using "`logout'/2011_AGSEC4A", append

* **********************************************************************
* 1 - import data and rename variables
* **********************************************************************

* import wave 2 season 1
	use "`root'/2011_AGSEC4A.dta", clear
	
	rename 		HHID hhid
	rename 		cropID cropid
	rename		plotID pltid
	rename		parcelID prcid
	rename 		Crop_Planted_Month cropplantedmonth
	
* **********************************************************************
* 2 - merge location data
* **********************************************************************	
	
* merge the location identification
	merge m:1 hhid using "`export'/2011_GSEC1"
	*** 278 unmatched from master
	*** 10660 matched
	drop 			if _merge != 3
	drop			_merge
	
* encode district for the imputation
	encode 			district, gen (districtdstrng)
	encode			county, gen (countydstrng)
	encode			subcounty, gen (subcountydstrng)
	encode			parish, gen (parishdstrng)
	
	*kdensity 		cropplantedmonth
	*** across the country most planting occurs in march
	*** next most planting is in january, then april, feburary, may
	
	*hist 			cropplantedmonth, by (region)
	*** central region plants 1st - jan, 2nd march, 3rd feb, close spread in the first 3 months
	*** eastern region plants mostly in march, next most but far behind march is plant in april, next jan, feb and may tie
	*** northern region plants mostly march, very few plant before march. 2nd most is april, then may and then june
	*** western region plants mostly in january, next in feb, then march, then hardly any after march

	tab 			cropid
	*** maize cropid is 130

	gen 			mz = 1 if cropid == 130

* consider maize only
	keep 			if mz == 1
	
	*hist 			cropplantedmonth, by (region)
	*** central mostly plants in march, then feb, equal density planting in jan and april
	*** eastern mostly plants in march, then april and then feburary
	*** north mosly plants in similar density from march to may
	*** western mostly plants in march and 2nd in feb, but mostly in march

*hist cropplantedmonth, by (countydstrng)
	bys 			countydstrng: 	egen meanplantmonth = mean(cropplantedmonth)

	sum 			meanplantmonth, detail
	*** 50th percentile is 3.111 which is march, that will be the cutoff for early or late

	gen 			earlyplant = 1 if meanplantmonth < 3.11111
	replace 		earlyplant = 0 if early == .


* **********************************************************************
* 3 - collapse to the crop level
* **********************************************************************
	
* collapse the data to the crop level so that our imputations are reproducable and consistent
	collapse (max) earlyplant, by(hhid region district county subcounty parish )

	isid hhid

	
* **********************************************************************
* 4 - end matter, clean up to save
* **********************************************************************

	keep hhid region district county subcounty parish earlyplant

	compress
	describe
	summarize

* save file
		customsave , idvar(hhid) filename("2011_AGSEC4A.dta") ///
			path("`export'/`folder'") dofile(2011_AGSEC4A) user($user)

* close the log
	log	close

/* END */