* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.15

* does
	*cleans Tanzania household variables, wave 1 Ag sec4b
	* kind of a crop roster, with harvest weights, short rainy season
	
* assumes
	* customsave.ado

* TO DO:
	* completed

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* set user
	global user "themacfreezie"

* define paths
	global root = "G:/My Drive/weather_project/household_data/tanzania/wave_1/raw"
	global export = "G:/My Drive/weather_project/household_data/tanzania/wave_1/refined"
	global logout = "C:/Users/$user/git/weather_project/tanzania/household_code/logs"

* open log
	log using "$logout/wv1_AGSEC4B", append

**********************************************************************************
**	TZA 2008 (Wave 1) - Agriculture Section 4B 
**********************************************************************************

* load data
	use 	"$root/SEC_4B", clear

* rename variables of interest
	rename 		zaocode crop_code

* generate unique identifier
	generate 			plot_id = hhid + " " + plotnum
	tostring 			crop_code, generate(crop_num)
	gen str21 			crop_id = hhid + " " + plotnum + " " + crop_num
	duplicates report 	crop_id
* no duplicates!
	isid 				crop_id

* generating mixed crop variable
	rename 		s4bq3 purestand
	generate 	mixedcrop_pct = .
	replace 	mixedcrop_pct = 100 if purestand == 1
	replace 	mixedcrop_pct = 75 if s4bq4 == 3
	replace 	mixedcrop_pct = 50 if s4bq4 == 2
	replace 	mixedcrop_pct = 25 if s4bq4 == 1
	tab			mixedcrop_pct, missing
* there are 923 obs missing mixedcrop_pct here
	tab 		mixedcrop_pct crop_code, missing
* only 2 of that 923 is missing a crop code
* 381 of these for maize
	sort 		crop_code
* this is an issue

* other variables of interest
	rename 		s4bq11_1 harvest_month
	rename 		s4bq15 wgt_hvsted
	label 		variable wgt_hvsted "What was the quanitity harvested? (kg)"
	rename 		s4bq20 value_seed_purch
	generate 	season = 1
* see if you can find quantity purchased and quantity of old seeds used to derive total value seeds used

* keep what we want, get rid of what we don't
	keep 		hhid plotnum plot_id crop_id crop_code mixedcrop_pct harvest_month ///
				wgt_hvsted value_seed_purch season

* prepare for export
compress
describe
summarize 
sort crop_id
customsave , idvar(crop_id) filename(AG_SEC4B.dta) path("$export") dofile(2008_AGSEC4B) user($user)

* close the log
	log	close

/* END */