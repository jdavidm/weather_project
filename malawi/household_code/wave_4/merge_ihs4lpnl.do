*merge household file with weather files
global user "jdmichler"

* For weather data
loc rootw = "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\weather_datasets\MWI_IHS4p"
* For household data
loc rooth = "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\merged_datasets"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\merged_datasets"

*Merge rainfall data
local folderList : dir "`rootw'" dirs "IHS4p_rf*"
foreach folder of local folderList {
	local fileList : dir "`rootw'/`folder'" files "*.dta"
	foreach file in `fileList' {
	use "`rootw'/`folder'/`file'", clear
	merge 1:1 y3_hhid using "`rooth'/hhfinal_ihs4lpnl.dta"
	
		*drop files that did not merge
		drop if _merge != 3
		drop _merge
		
		*drop variables for all years but 2015
		drop mean_season_1983- dry_2014 mean_season_2016- dry_2016
		drop mean_period_total_season- z_total_season_2014 dev_total_season_2016- z_total_season_2016
		drop mean_period_raindays- dev_raindays_2014 dev_raindays_2016- dev_raindays_2016
		drop mean_period_norain- dev_norain_2014 dev_norain_2016- dev_norain_2016
		drop mean_period_raindays_percent- dev_raindays_percent_2014 dev_raindays_percent_2016- dev_raindays_percent_2016
		
		rename *_2015 *
		replace intyear = 2015
		
		*ordering - look at this mess
		order y3_hhid y2_hhid case_id- intyear rs_harvest* rs_cultivatedarea ds_harvest* ///
		ds_cultivatedarea rsmz_harvest* rsmz_cultivatedarea dsmz_harvest* dsmz_cultivatedarea ///
		rs_irrigation* rs_fert* rs_labor* rs_herb rs_herbi* rs_fung* rs_pest rs_pesti* rs_insect* ///
		ds_irrigation* ds_fert* ds_labor* ds_herb ds_herbi* ds_fung* ds_pest ds_pesti* ds_insect* ///
		rsmz_irrigation* rsmz_fert* rsmz_labor* rsmz_herb rsmz_herbi* rsmz_fung* rsmz_pest rsmz_pesti* rsmz_insect* ///
		dsmz_irrigation* dsmz_fert* dsmz_labor* dsmz_herb dsmz_herbi* dsmz_fung* dsmz_pest dsmz_pesti* dsmz_insect*
		
		destring case_id, replace
		
		loc ext = substr("`file'", 7, 2)
		loc sat = substr("`file'", 10, 3)
		save "`export'/lp3_`ext'_`sat'_merged.dta", replace
		}
}

*Merge temperature data
local folderList : dir "`rootw'" dirs "IHS4p_t*"
foreach folder of local folderList {
	local fileList : dir "`rootw'/`folder'" files "*.dta"
	foreach file in `fileList' {
	use "`rootw'/`folder'/`file'", clear
	merge 1:1 y3_hhid using "`rooth'/hhfinal_ihs4lpnl.dta"
	
		*drop files that did not merge
		drop if _merge != 3
		drop _merge
		
		*drop variables for all years but 2015
		drop mean_season_1983- tempbin1002014 mean_season_2016- tempbin1002016
		drop mean_gdd- z_gdd_2014 dev_gdd_2016- z_gdd_2016
		
		rename *_2015 *
		rename *2015 *
		replace intyear = 2015
		
		*ordering - look at this mess
		order y3_hhid y2_hhid case_id- intyear rs_harvest* rs_cultivatedarea ds_harvest* ///
		ds_cultivatedarea rsmz_harvest* rsmz_cultivatedarea dsmz_harvest* dsmz_cultivatedarea ///
		rs_irrigation* rs_fert* rs_labor* rs_herb* rs_herbi* rs_fung* rs_pest* rs_pesti* rs_insect* ///
		ds_irrigation* ds_fert* ds_labor* ds_herb* ds_herbi* ds_fung* ds_pest* ds_pesti* ds_insect* ///
		rsmz_irrigation* rsmz_fert* rsmz_labor* rsmz_herb* rsmz_herbi* rsmz_fung* rsmz_pest* rsmz_pesti* rsmz_insect* ///
		dsmz_irrigation* dsmz_fert* dsmz_labor* dsmz_herb* dsmz_herbi* dsmz_fung* dsmz_pest* dsmz_pesti* dsmz_insect*
		
		destring case_id, replace
		
		loc ext = substr("`file'", 7, 2)
		loc sat = substr("`file'", 11, 1)
		save "`export'/lp3_`ext'_tp`sat'_merged.dta", replace
		}
}
clear
