* Project: WB Weather
* Created on: May 2020
* Created by: jdm
* Edited by: ek
* Stata v.16

* does
	* merges weather data into GHSY2 household data

* assumes
	* cleaned IHPS short panel data
	* processed wave 1 weather data
	* customsave.ado

* TO DO:
	* update Malawi template for Nigeria

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		rootw 	= 	"$data/weather_data/nigeria/wave_1/refined"
	loc		rooth 	= 	"$data/household_data/nigeria/wave_1/refined"
	loc		export 	= 	"$data/merged_data/nigeria/wave_1"
	loc		logout 	= 	"$data/merged_data/nigeria/logs"

* open log	
	cap 	log			 close
	log 	using 		"`logout'/ghsy1_build_wave1", append

	
* **********************************************************************
* 1 - merge northern household data with rainfall data
* **********************************************************************

* import the .dta houeshold file
	use 		"`rooth'/hhfinal_ghsy1.dta", clear

* drop southern regions
	drop if		zone == 4 | zone == 5 | zone == 6
	
* generate variable to record data source
	gen 		data = "ghsy1"
	lab var 	data "Data Source"
	
* define local with all sub-folders in it
	loc 		folderList : dir "`rootw'" dirs "GHSY1_rf*"

* define local with all files in each sub-folder	
	foreach 	folder of local folderList {

	* define each file in the above local
		loc 		fileList : dir "`rootw'/`folder'" files "*_n.dta"
	
	* loop through each file in the above local
		foreach 	file in `fileList' {	
	
		* merge weather data with household data
			merge 	1:1 hhid using "`rootw'/`folder'/`file'"	
	
		* drop files that did not merge
			drop 	if 	_merge != 3
			drop 		_merge
		
		*drop variables for all years but 2010
			drop 		mean_season_1983- dry_2009 mean_season_2011- dry_2017
			drop 		mean_period_total_season- z_total_season_2009 ///
						dev_total_season_2011- z_total_season_2017
			drop 		mean_period_raindays- dev_raindays_2009 ///
						dev_raindays_2011- dev_raindays_2017
			drop 		mean_period_norain- dev_norain_2009 ///
						dev_norain_2011- dev_norain_2017
			drop 		mean_period_percent_raindays- dev_percent_raindays_2009 ///
						dev_percent_raindays_2011- dev_percent_raindays_2017
		
		* define file naming criteria
			loc 		sat = substr("`file'", 10, 3)
			loc 		ext = substr("`file'", 7, 2)
			
		* generate variable to record extraction method
			gen 		`sat'_`ext' = "`sat'_`ext'"
			lab var 	`sat'_`ext' "Satellite/Extraction"			
		
		* rename variables by dropping the year suffix
			gen 		v01_`sat'_`ext' = mean_season_2010 if year == 2010
			lab var		v01_`sat'_`ext' "Mean Daily Rainfall"
		
			gen 		v02_`sat'_`ext' = median_season_2010 if year == 2010
			lab var		v02_`sat'_`ext' "Median Daily Rainfall"

			gen 		v03_`sat'_`ext' = sd_season_2010 if year == 2010
			lab var		v03_`sat'_`ext' "Variance of Daily Rainfall"

			gen 		v04_`sat'_`ext' = skew_season_2010 if year == 2010
			lab var		v04_`sat'_`ext' "Skew of Daily Rainfall"

			gen 		v05_`sat'_`ext' = total_season_2010 if year == 2010
			lab var		v05_`sat'_`ext' "Total Rainfall"

			gen 		v06_`sat'_`ext' = dev_total_season_2010 if year == 2010
			lab var		v06_`sat'_`ext' "Deviation in Total Rainfalll"

			gen 		v07_`sat'_`ext' = z_total_season_2010 if year == 2010
			lab var		v07_`sat'_`ext' "Z-Score of Total Rainfall"	

			gen 		v08_`sat'_`ext' = raindays_2010 if year == 2010
			lab var		v08_`sat'_`ext' "Rainy Days"

			gen 		v09_`sat'_`ext' = dev_raindays_2010 if year == 2010
			lab var		v09_`sat'_`ext' "Deviation in Rainy Days"

			gen 		v10_`sat'_`ext' = norain_2010 if year == 2010	
			lab var		v10_`sat'_`ext' "No Rain Days"

			gen 		v11_`sat'_`ext' = dev_norain_2010 if year == 2010
			lab var		v11_`sat'_`ext' "Deviation in No Rain Days"

			gen 		v12_`sat'_`ext' = percent_raindays_2010 if year == 2010
			lab var		v12_`sat'_`ext' "% Rainy Days"

			gen 		v13_`sat'_`ext' = dev_percent_raindays_2010 if year == 2010
			lab var		v13_`sat'_`ext' "Deviation in % Rainy Days"

			gen 		v14_`sat'_`ext' = dry_2010 if year == 2010
			lab var		v14_`sat'_`ext' "Longest Dry Spell"
		
		* drop year variables
			drop 		*2010
		}
}

* **********************************************************************
* 2 - merge northern temperature data with household data
* **********************************************************************

* define local with all sub-folders in it
	loc 		folderList : dir "`rootw'" dirs "GHSY1_t*"

* define local with all files in each sub-folder	
	foreach 	folder of local folderList {

* define each file in the above local
	loc 		fileList : dir "`rootw'/`folder'" files "*_n.dta"
	
* loop through each file in the above local
	foreach 	file in `fileList' {	
	
	* merge weather data with household data
		merge 	1:1 hhid using "`rootw'/`folder'/`file'"	
	
		* drop files that did not merge
			drop 	if 	_merge != 3
			drop 		_merge
		
		* drop variables for all years but 2010
			drop 		mean_season_1983- tempbin1002009 ///
						mean_season_2011- tempbin1002017
			drop 		mean_gdd- z_gdd_2009 dev_gdd_2011- z_gdd_2017
		
		* define file naming criteria
			loc 		sat = substr("`file'", 11, 1)
			loc 		ext = substr("`file'", 7, 2)
			
		* generate variable to record extraction method
			gen 		tp`sat'_`ext' = "tp`sat'_`ext'"
			lab var 	tp`sat'_`ext' "Satellite/Extraction"
		
		* rename variables but dropping the year suffix
			gen 		v15_tp`sat'_`ext' = mean_season_2010 if year == 2010
			lab var		v15_tp`sat'_`ext' "Mean Daily Temperature"

			gen 		v16_tp`sat'_`ext' = median_season_2010 if year == 2010
			lab var		v16_tp`sat'_`ext' "Median Daily Temperature"

			gen 		v17_tp`sat'_`ext' = sd_season_2010 if year == 2010
			lab var		v17_tp`sat'_`ext' "Variance of Daily Temperature"

			gen 		v18_tp`sat'_`ext' = skew_season_2010 if year == 2010
			lab var		v18_tp`sat'_`ext' "Skew of Daily Temperature"	

			gen 		v19_tp`sat'_`ext' = gdd_2010 if year == 2010
			lab var		v19_tp`sat'_`ext' "Growing Degree Days (GDD)"	

			gen 		v20_tp`sat'_`ext' = dev_gdd_2010 if year == 2010
			lab var		v20_tp`sat'_`ext' "Deviation in GDD"	

			gen 		v21_tp`sat'_`ext' = z_gdd_2010 if year == 2010
			lab var		v21_tp`sat'_`ext' "Z-Score of GDD"	

			gen 		v22_tp`sat'_`ext' = max_season_2010 if year == 2010
			lab var		v22_tp`sat'_`ext' "Maximum Daily Temperature"

			gen 		v23_tp`sat'_`ext' = tempbin202010 if year == 2010
			lab var		v23_tp`sat'_`ext' "Temperature Bin 0-20"	

			gen 		v24_tp`sat'_`ext' = tempbin402010 if year == 2010
			lab var		v24_tp`sat'_`ext' "Temperature Bin 20-40"	

			gen 		v25_tp`sat'_`ext' = tempbin602010 if year == 2010
			lab var		v25_tp`sat'_`ext' "Temperature Bin 40-60"	

			gen 		v26_tp`sat'_`ext' = tempbin802010 if year == 2010
			lab var		v26_tp`sat'_`ext' "Temperature Bin 60-80"	

			gen 		v27_tp`sat'_`ext' = tempbin1002010 if year == 2010
			lab var		v27_tp`sat'_`ext' "Temperature Bin 80-100"
		
		* drop year variables
			drop 		*2010
	}
}

* save file
	qui: compress
	customsave 	, idvar(hhid) filename("ghsy1_merged_n.dta") ///
		path("`export'") dofile(ghsy1_build) user($user)

* **********************************************************************
* 3 - merge southern household data with rainfall data
* **********************************************************************

* import the .dta houeshold file
	use 		"`rooth'/hhfinal_ghsy1.dta", clear

* drop northern regions
	drop if		zone == 1 | zone == 2 | zone == 3
	
* generate variable to record data source
	gen 		data = "ghsy1"
	lab var 	data "Data Source"
	
* define local with all sub-folders in it
	loc 		folderList : dir "`rootw'" dirs "GHSY1_rf*"

* define local with all files in each sub-folder	
	foreach 	folder of local folderList {

	* define each file in the above local
		loc 		fileList : dir "`rootw'/`folder'" files "*_s.dta"
	
	* loop through each file in the above local
		foreach 	file in `fileList' {	
	
		* merge weather data with household data
			merge 	1:1 hhid using "`rootw'/`folder'/`file'"	
	
		* drop files that did not merge
			drop 	if 	_merge != 3
			drop 		_merge
		
		*drop variables for all years but 2010
			drop 		mean_season_1983- dry_2009 mean_season_2011- dry_2017
			drop 		mean_period_total_season- z_total_season_2009 ///
						dev_total_season_2011- z_total_season_2017
			drop 		mean_period_raindays- dev_raindays_2009 ///
						dev_raindays_2011- dev_raindays_2017
			drop 		mean_period_norain- dev_norain_2009 ///
						dev_norain_2011- dev_norain_2017
			drop 		mean_period_percent_raindays- dev_percent_raindays_2009 ///
						dev_percent_raindays_2011- dev_percent_raindays_2017
		
		* define file naming criteria
			loc 		sat = substr("`file'", 10, 3)
			loc 		ext = substr("`file'", 7, 2)
			
		* generate variable to record extraction method
			gen 		`sat'_`ext' = "`sat'_`ext'"
			lab var 	`sat'_`ext' "Satellite/Extraction"			
		
		* rename variables by dropping the year suffix
			gen 		v01_`sat'_`ext' = mean_season_2010 if year == 2010
			lab var		v01_`sat'_`ext' "Mean Daily Rainfall"
		
			gen 		v02_`sat'_`ext' = median_season_2010 if year == 2010
			lab var		v02_`sat'_`ext' "Median Daily Rainfall"

			gen 		v03_`sat'_`ext' = sd_season_2010 if year == 2010
			lab var		v03_`sat'_`ext' "Variance of Daily Rainfall"

			gen 		v04_`sat'_`ext' = skew_season_2010 if year == 2010
			lab var		v04_`sat'_`ext' "Skew of Daily Rainfall"

			gen 		v05_`sat'_`ext' = total_season_2010 if year == 2010
			lab var		v05_`sat'_`ext' "Total Rainfall"

			gen 		v06_`sat'_`ext' = dev_total_season_2010 if year == 2010
			lab var		v06_`sat'_`ext' "Deviation in Total Rainfalll"

			gen 		v07_`sat'_`ext' = z_total_season_2010 if year == 2010
			lab var		v07_`sat'_`ext' "Z-Score of Total Rainfall"	

			gen 		v08_`sat'_`ext' = raindays_2010 if year == 2010
			lab var		v08_`sat'_`ext' "Rainy Days"

			gen 		v09_`sat'_`ext' = dev_raindays_2010 if year == 2010
			lab var		v09_`sat'_`ext' "Deviation in Rainy Days"

			gen 		v10_`sat'_`ext' = norain_2010 if year == 2010	
			lab var		v10_`sat'_`ext' "No Rain Days"

			gen 		v11_`sat'_`ext' = dev_norain_2010 if year == 2010
			lab var		v11_`sat'_`ext' "Deviation in No Rain Days"

			gen 		v12_`sat'_`ext' = percent_raindays_2010 if year == 2010
			lab var		v12_`sat'_`ext' "% Rainy Days"

			gen 		v13_`sat'_`ext' = dev_percent_raindays_2010 if year == 2010
			lab var		v13_`sat'_`ext' "Deviation in % Rainy Days"

			gen 		v14_`sat'_`ext' = dry_2010 if year == 2010
			lab var		v14_`sat'_`ext' "Longest Dry Spell"
		
		* drop year variables
			drop 		*2010
		}
}

	
* **********************************************************************
* 4 - merge northern temperature data with household data
* **********************************************************************

* define local with all sub-folders in it
	loc 		folderList : dir "`rootw'" dirs "GHSY1_t*"

* define local with all files in each sub-folder	
	foreach 	folder of local folderList {

* define each file in the above local
	loc 		fileList : dir "`rootw'/`folder'" files "*_s.dta"
	
* loop through each file in the above local
	foreach 	file in `fileList' {	
	
	* merge weather data with household data
		merge 	1:1 hhid using "`rootw'/`folder'/`file'"	
	
		* drop files that did not merge
			drop 	if 	_merge != 3
			drop 		_merge
		
		* drop variables for all years but 2010
			drop 		mean_season_1983- tempbin1002009 ///
						mean_season_2011- tempbin1002017
			drop 		mean_gdd- z_gdd_2009 dev_gdd_2011- z_gdd_2017
		
		* define file naming criteria
			loc 		sat = substr("`file'", 11, 1)
			loc 		ext = substr("`file'", 7, 2)
			
		* generate variable to record extraction method
			gen 		tp`sat'_`ext' = "tp`sat'_`ext'"
			lab var 	tp`sat'_`ext' "Satellite/Extraction"
		
		* rename variables but dropping the year suffix
			gen 		v15_tp`sat'_`ext' = mean_season_2010 if year == 2010
			lab var		v15_tp`sat'_`ext' "Mean Daily Temperature"

			gen 		v16_tp`sat'_`ext' = median_season_2010 if year == 2010
			lab var		v16_tp`sat'_`ext' "Median Daily Temperature"

			gen 		v17_tp`sat'_`ext' = sd_season_2010 if year == 2010
			lab var		v17_tp`sat'_`ext' "Variance of Daily Temperature"

			gen 		v18_tp`sat'_`ext' = skew_season_2010 if year == 2010
			lab var		v18_tp`sat'_`ext' "Skew of Daily Temperature"	

			gen 		v19_tp`sat'_`ext' = gdd_2010 if year == 2010
			lab var		v19_tp`sat'_`ext' "Growing Degree Days (GDD)"	

			gen 		v20_tp`sat'_`ext' = dev_gdd_2010 if year == 2010
			lab var		v20_tp`sat'_`ext' "Deviation in GDD"	

			gen 		v21_tp`sat'_`ext' = z_gdd_2010 if year == 2010
			lab var		v21_tp`sat'_`ext' "Z-Score of GDD"	

			gen 		v22_tp`sat'_`ext' = max_season_2010 if year == 2010
			lab var		v22_tp`sat'_`ext' "Maximum Daily Temperature"

			gen 		v23_tp`sat'_`ext' = tempbin202010 if year == 2010
			lab var		v23_tp`sat'_`ext' "Temperature Bin 0-20"	

			gen 		v24_tp`sat'_`ext' = tempbin402010 if year == 2010
			lab var		v24_tp`sat'_`ext' "Temperature Bin 20-40"	

			gen 		v25_tp`sat'_`ext' = tempbin602010 if year == 2010
			lab var		v25_tp`sat'_`ext' "Temperature Bin 40-60"	

			gen 		v26_tp`sat'_`ext' = tempbin802010 if year == 2010
			lab var		v26_tp`sat'_`ext' "Temperature Bin 60-80"	

			gen 		v27_tp`sat'_`ext' = tempbin1002010 if year == 2010
			lab var		v27_tp`sat'_`ext' "Temperature Bin 80-100"
		
		* drop year variables
			drop 		*2010
	}
}

* save file
	qui: compress
	customsave 	, idvar(hhid) filename("ghsy1_merged_s.dta") ///
		path("`export'") dofile(ghsy1_build) user($user)

* rename hhid
	gen	y1_hhid = hhid 
	
* create wide data set 	
	rename 			* *2010
	rename 			zone2010 zone
	rename 			state2010 state
	rename 			lga2010 lga
	rename 			ea2010 ea
	rename 			sector2010 sector
	rename 			*hhid2010 *hhid
	
	
* **********************************************************************
* 5 - append northern and southern data sets
* **********************************************************************

* import northern data
	use 		"`export'/ghsy1_merged_n.dta", clear

* append southern data
	append		using "`export'/ghsy1_merged_s.dta", force

	qui: compress	
	describe
	summarize 
	
* save file
	customsave 	, idvar(hhid) filename("ghsy1_merged.dta") ///
		path("`export'") dofile(ghsy1_build) user($user)

* erase northern and southern files
	erase		"`export'/ghsy1_merged_n.dta"
	erase		"`export'/ghsy1_merged_s.dta"

* rename hhid
	gen	y1_hhid = hhid 
	
* create wide data set 	
	rename 			* *2010
	rename 			zone2010 zone
	rename 			state2010 state
	rename 			lga2010 lga
	rename 			ea2010 ea
	rename 			sector2010 sector
	rename 			*hhid2010 *hhid

* save file
	customsave 	, idvar(hhid) filename("ghsy1_merged.dta") ///
		path("`export'") dofile(ghsy1_build) user($user)
		
* close the log
	log	close

/* END */