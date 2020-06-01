* Project: WB Weather
* Created on: May 2020
* Created by: jdm
* Stata v.16

* does
	* merges IHS4 long panel data with weather data

* assumes
	* cleaned IHS4 long panel data
	* processed wave 4 weather data
	* customsave.ado

* TO DO:
	* complete


* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		rootw 	= 	"$data/weather_data/malawi/wave_4/refined"
	loc		rooth 	= 	"$data/household_data/malawi/wave_4/refined"
	loc		export 	= 	"$data/merged_data/malawi/wave_4"
	loc		logout 	= 	"$data/merged_data/malawi/logs"

* open log
	log 	using 		"`logout'/ihs4lpnl_merge", append


* **********************************************************************
* 1 - merge rainfall data with household data
* **********************************************************************

* define local with all sub-folders in it
	loc			folderList : dir "`rootw'" dirs "IHS4p_rf*"

* define local with all files in each sub-folder
	foreach 	folder of local folderList {

	* define each file in the above local
		loc 		fileList : dir "`rootw'/`folder'" files "*.dta"

	* loop through each file in the above local
		foreach 	file in `fileList' {

		* import the .dta weather files
			use 		"`rootw'/`folder'/`file'", clear

		* merge weather data with household data
			merge 1:1 	y3_hhid using "`rooth'/hhfinal_ihs4lpnl.dta"

		* drop files that did not merge
			drop if 	_merge != 3
			drop 		_merge

		* drop variables for all years but 2015
			drop 		mean_season_1983- dry_2014 mean_season_2016- dry_2016
			drop 		mean_period_total_season- z_total_season_2014 ///
						dev_total_season_2016- z_total_season_2016
			drop 		mean_period_raindays- dev_raindays_2014 ///
						dev_raindays_2016- dev_raindays_2016
			drop 		mean_period_norain- dev_norain_2014 ///
						dev_norain_2016- dev_norain_2016
			drop 		mean_period_percent_raindays- dev_percent_raindays_2014 ///
						dev_percent_raindays_2016- dev_percent_raindays_2016

		* rename variables by dropping the year suffix
			rename 		*_2015 *
			replace 	intyear = 2015

		* ordering - look at this mess
			order 		y3_hhid y2_hhid case_id- intyear rs_harvest* rs_cultivatedarea ///
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

		* destring unique id
			destring 	case_id, replace

		* define file naming criteria
			loc 		ext = substr("`file'", 7, 2)
			loc 		sat = substr("`file'", 10, 3)

		* generate variable to record data source
			gen 		data = "lp2"
			lab var 	data "Data Source"

		* generate variable to record satellite source
			gen 		satellite = "`sat'"
			lab var 	satellite "Weather Satellite"

		* generate variable to record extraction method
			gen 		extraction = "`ext'"
			lab var 	extraction "Extraction Method"

		* save file
		customsave 	, idvar(y3_hhid) filename("lp3_`ext'_`sat'_merged.dta") ///
		path("`export'") dofile(ihs4lpnl_merge) user($user)
		}
}


* **********************************************************************
* 2 - merge temperature data with household data
* **********************************************************************

* define local with all sub-folders in it
		loc			folderList : dir "`rootw'" dirs "IHS4p_t*"

* define local with all files in each sub-folder
	foreach 	folder of local folderList {

	* define each file in the above local
		loc			fileList : dir "`rootw'/`folder'" files "*.dta"

	* loop through each file in the above local
		foreach 	file in `fileList' {

		* import the .dta weather files
			use 		"`rootw'/`folder'/`file'", clear

		* merge weather data with household data
			merge 1:1 	y3_hhid using "`rooth'/hhfinal_ihs4lpnl.dta"

		* drop files that did not merge
			drop if 	_merge != 3
			drop 		_merge

		* drop variables for all years but 2015
			drop 		mean_season_1983- tempbin1002014 ///
						mean_season_2016- tempbin1002016
			drop 		mean_gdd- z_gdd_2014 dev_gdd_2016- z_gdd_2016

		* rename variables by dropping the year suffix
			rename 		*_2015 *
			rename 		*2015 *
			replace 	intyear = 2015

		* ordering - look at this mess
			order 		y3_hhid y2_hhid case_id- intyear rs_harvest* rs_cultivatedarea ///
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

		* destring unique id
		destring case_id, replace

		* define file naming criteria
		loc ext = substr("`file'", 7, 2)
		loc sat = substr("`file'", 11, 1)

		* generate variable to record data source
			gen 		data = "lp2"
			lab var 	data "Data Source"

		* generate variable to record satellite source
			gen 		satellite = "tp`sat'"
			lab var 	satellite "Weather Satellite"

		* generate variable to record extraction method
			gen 		extraction = "`ext'"
			lab var 	extraction "Extraction Method"

		* save file
		customsave 	, idvar(y3_hhid) filename("lp3_`ext'_tp`sat'_merged.dta") ///
		path("`export'") dofile(ihs4lpnl_merge) user($user)
		}
}

* close the log
	log	close

/* END */
