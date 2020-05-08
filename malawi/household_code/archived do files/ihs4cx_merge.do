* Project: WB Weather
* Created on: May 2020
* Created by: jdm
* Stata v.16

* does
	* merges IHS4 cross sectional data with weather data

* assumes
	* cleaned IHS4 cross sectional data
	* processed wave 3 weather data
	* customsave.ado

* TO DO:
	* complete

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* set global user
	*global	user		"jdmichler" // global managed by masterdo, turn on to run single file

* define paths
	loc		rootw 	= 	"G:/My Drive/weather_project/weather_data/malawi/wave_3/refined"
	loc		rooth 	= 	"G:/My Drive/weather_project/household_data/malawi/wave_3/refined"
	loc		export 	= 	"G:/My Drive/weather_project/merged_data/malawi/wave_3"
	loc		logout 	= 	"G:/My Drive/weather_project/merged_data/malawi/logs"

* open log	
	log 	using 		"`logout'/ihs4cx_merge", append

	
* **********************************************************************
* 1 - merge rainfall data with household data
* **********************************************************************

* define local with all sub-folders in it
	loc			folderList : dir "`rootw'" dirs "IHS4_rf*"

* define local with all files in each sub-folder	
	foreach 	folder of local folderList {
	
	* define each file in the above local
		loc 		fileList : dir "`rootw'/`folder'" files "*.dta"
	
	* loop through each file in the above local
		foreach 	file in `fileList' {
		
		* import the .dta weather files
			use 		"`rootw'/`folder'/`file'", clear
		
		* merge weather data with household data
			merge 1:1 	hhid using "`rooth'/hhfinal_ihs4cx.dta"
	
		* drop files that did not merge
			drop if 	_merge != 3
			drop 		_merge
		
		* drop variables for all years before 2014 and after 2015
			drop 		mean_season_1983- dry_2013 mean_season_2016- dry_2016
			drop 		mean_period_total_season- z_total_season_2013 ///
						dev_total_season_2016- z_total_season_2016
			drop 		mean_period_raindays- dev_raindays_2013 ///
						dev_raindays_2016- dev_raindays_2016
			drop 		mean_period_norain- dev_norain_2013 ///
						dev_norain_2016- dev_norain_2016
			drop 		mean_period_percent_raindays- dev_percent_raindays_2013 ///
						dev_percent_raindays_2016- dev_percent_raindays_2016
		
		* rename variables by dropping the year suffix
			gen 		mean_season = mean_season_2014 if year == 2014
			replace 	mean_season = mean_season_2015 if year == 2015

			gen 		median_season = median_season_2014 if year == 2014
			replace 	median_season = median_season_2015 if year == 2015

			gen 		sd_season = sd_season_2014 if year == 2014
			replace 	sd_season = sd_season_2015 if year == 2015

			gen 		total_season = total_season_2014 if year == 2014
			replace 	total_season = total_season_2015 if year == 2015

			gen 		skew_season = skew_season_2014 if year == 2014
			replace 	skew_season = skew_season_2015 if year == 2015

			gen 		norain = norain_2014 if year == 2014
			replace 	norain = norain_2015 if year == 2015		
	
			gen 		raindays = raindays_2014 if year == 2014
			replace 	raindays = raindays_2015 if year == 2015

			gen 		percent_raindays = percent_raindays_2014 if year == 2014
			replace 	percent_raindays = percent_raindays_2015 if year == 2015

			gen 		dry = dry_2014 if year == 2014
			replace 	dry = dry_2015 if year == 2015

			gen 		dev_total_season = dev_total_season_2014 if year == 2014
			replace 	dev_total_season = dev_total_season_2015 if year == 2015

			gen 		z_total_season = z_total_season_2014 if year == 2014
			replace 	z_total_season = z_total_season_2015 if year == 2015

			gen 		dev_raindays = dev_raindays_2014 if year == 2014
			replace 	dev_raindays = dev_raindays_2015 if year == 2015

			gen 		dev_norain = dev_norain_2014 if year == 2014
			replace 	dev_norain = dev_norain_2015 if year == 2015

			gen 		dev_percent_raindays = dev_percent_raindays_2014 if year == 2014
			replace 	dev_percent_raindays = dev_percent_raindays_2015 if year == 2015
		
		* drop year variables
			drop 		*_2014 *_2015
		
		* ordering - look at this mess
			order 		hhid case_id region- year rs_harvest* rs_cultivatedarea ///
						ds_harvest* ds_cultivatedarea rsmz_harvest* ///
						rsmz_cultivatedarea dsmz_harvest* dsmz_cultivatedarea ///
						rs_irrigation* rs_fert* rs_labor* rs_herb rs_herbi* ///
						rs_fung* rs_pest rs_pesti* rs_insect* ds_irrigation* ///
						ds_fert* ds_labor* ds_herb ds_herbi* ds_fung* ds_pest ///
						ds_pesti* ds_insect* rsmz_irrigation* rsmz_fert* ///
						rsmz_labor* rsmz_herb rsmz_herbi* rsmz_fung* ///
						rsmz_pest rsmz_pesti* rsmz_insect* dsmz_irrigation* ///
						dsmz_fert* dsmz_labor* dsmz_herb dsmz_herbi* ///
						dsmz_fung* dsmz_pest dsmz_pesti* dsmz_insect*
		
		* define file naming criteria
			loc 		ext = substr("`file'", 6, 2)
			loc 		sat = substr("`file'", 9, 3)

		* generate variable to record data source
			gen 		data = "cx1"
			lab var 	data "Data Source"
		
		* generate variable to record satellite source
			gen 		satellite = "`sat'"
			lab var 	satellite "Weather Satellite"
		
		* generate variable to record extraction method
			gen 		extraction = "`ext'"
			lab var 	extraction "Extraction Method"			
							
		* save file
		customsave 	, idvar(case_id) filename("cx2_`ext'_`sat'_merged.dta") ///
		path("`export'") dofile(ihs4cx_merge) user($user)
		}
}

	
* **********************************************************************
* 2 - merge temperature data with household data
* **********************************************************************

* define local with all sub-folders in it
	loc			folderList : dir "`rootw'" dirs "IHS4_t*"

* define local with all files in each sub-folder	
	foreach 	folder of local folderList {
	
	* define each file in the above local
		loc			fileList : dir "`rootw'/`folder'" files "*.dta"
	
	* loop through each file in the above local
		foreach 	file in `fileList' {
		
		* import the .dta weather files
			use 		"`rootw'/`folder'/`file'", clear
		
		* merge weather data with household data
			merge 1:1 	hhid using "`rooth'/hhfinal_ihs4cx.dta"
	
		* drop files that did not merge
			drop if 	_merge != 3
			drop 		_merge
		
		* drop variables for all years before 2014 and after 2015
			drop 		mean_season_1983- tempbin1002013 ///
						mean_season_2016- tempbin1002016
			drop 		mean_gdd- z_gdd_2013 dev_gdd_2016- z_gdd_2016
		
		* rename variables by dropping the year suffix
			gen 		mean_season = mean_season_2014 if year == 2014
			replace 	mean_season = mean_season_2015 if year == 2015

			gen 		median_season = median_season_2014 if year == 2014
			replace 	median_season = median_season_2015 if year == 2015

			gen 		sd_season = sd_season_2014 if year == 2014
			replace 	sd_season = sd_season_2015 if year == 2015

			gen 		skew_season = skew_season_2014 if year == 2014
			replace 	skew_season = skew_season_2015 if year == 2015	

			gen 		max_season = max_season_2014 if year == 2014
			replace 	max_season = max_season_2015 if year == 2015	

			gen 		gdd = gdd_2014 if year == 2014
			replace 	gdd = gdd_2015 if year == 2015	

			gen 		tempbin20 = tempbin202014 if year == 2014
			replace 	tempbin20 = tempbin202015 if year == 2015	

			gen 		tempbin40 = tempbin402014 if year == 2014
			replace 	tempbin40 = tempbin402015 if year == 2015	

			gen 		tempbin60 = tempbin602014 if year == 2014
			replace 	tempbin60 = tempbin602015 if year == 2015	

			gen 		tempbin80 = tempbin802014 if year == 2014
			replace 	tempbin80 = tempbin802015 if year == 2015	

			gen 		tempbin100 = tempbin1002014 if year == 2014
			replace 	tempbin100 = tempbin1002015 if year == 2015	

			gen 		dev_gdd = dev_gdd_2014 if year == 2014
			replace 	dev_gdd = dev_gdd_2015 if year == 2015	

			gen 		z_gdd = z_gdd_2014 if year == 2014
			replace 	z_gdd = z_gdd_2015 if year == 2015	
		
		* drop year variables
			drop 		*2014 *2015
		
		* ordering - look at this mess
			order 		hhid case_id- intyear rs_harvest* rs_cultivatedarea ///
						ds_harvest* ds_cultivatedarea rsmz_harvest* ///
						rsmz_cultivatedarea dsmz_harvest* dsmz_cultivatedarea ///
						rs_irrigation* rs_fert* rs_labor* rs_herb rs_herbi* ///
						rs_fung* rs_pest rs_pesti* rs_insect* ds_irrigation* ///
						ds_fert* ds_labor* ds_herb ds_herbi* ds_fung* ///
						ds_pest ds_pesti* ds_insect* rsmz_irrigation* ///
						rsmz_fert* rsmz_labor* rsmz_herb rsmz_herbi* ///
						rsmz_fung* rsmz_pest rsmz_pesti* rsmz_insect* ///
						dsmz_irrigation* dsmz_fert* dsmz_labor* dsmz_herb ///
						dsmz_herbi* dsmz_fung* dsmz_pest dsmz_pesti* dsmz_insect*
		
		* define file naming criteria
			loc 		ext = substr("`file'", 6, 2)
			loc 		sat = substr("`file'", 10, 1)

		* generate variable to record data source
			gen 		data = "cx1"
			lab var 	data "Data Source"
		
		* generate variable to record satellite source
			gen 		satellite = "tp`sat'"
			lab var 	satellite "Weather Satellite"
		
		* generate variable to record extraction method
			gen 		extraction = "`ext'"
			lab var 	extraction "Extraction Method"			
							
		* save file
		customsave 	, idvar(case_id) filename("cx2_`ext'_tp`sat'_merged.dta") ///
		path("`export'") dofile(ihs4cx_merge) user($user)
		}
}

* close the log
	log	close

/* END */