* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 2 (2012-2013), POST HARVEST, AG SECTA2
	* determines harvest labor (only) for preceeding rainy season
	* outputs clean data file ready for combination with wave 2 plot data

* assumes
	* customsave.ado
	* mdesc.ado
	
* TO DO:
	* complete
	

* **********************************************************************
* 0 - setup
* **********************************************************************
	
* define paths
	loc		root	=	"$data/household_data/nigeria/wave_2/raw"
	loc		export	=	"$data/household_data/nigeria/wave_2/refined"
	loc		logout	=	"$data/household_data/nigeria/logs"

* open log	
	log 	using 	"`logout'/wave_2_ph_secta2", append

	
* **********************************************************************
* 1 - determine labor allocation
* **********************************************************************
		
* import the first relevant data file
	use 			"`root'/secta2_harvestw2", clear

	describe
	sort			hhid plotid
	isid			hhid plotid

* create household member labor (weeks x days per week)
	gen				hh_1 = (sa2q1a2 * sa2q1a3)
	replace			hh_1 = 0 if hh_1 == .

	gen				hh_2 = (sa2q1b2 * sa2q1b3)
	replace			hh_2 = 0 if hh_2 == . 

	gen				hh_3 = (sa2q1c2 * sa2q1c3)
	replace			hh_3 = 0 if hh_3 == .

	gen				hh_4 = (sa2q1d2 * sa2q1d3)
	replace			hh_4 = 0 if hh_4 == . 
	*** this calculation is for up to 4 members of the household that were laborers
	*** per the survey, these are laborers from the last rainy/harvest season
	*** NOT the dry season harvest
	*** does not include planting or cultivation labor (see NGA_pp_sect11c1)

* create total household labor days for harvest
	gen				hh_days = hh_1 + hh_2 + hh_3 + hh_4
	
* hired labor days (# of people hired for harvest)(# of days they worked)
	gen				men_days = (sa2q2 * sa2q3)
	replace			men_days = 0 if men_days == . 

	gen				women_days = (sa2q5 * sa2q6)
	replace			women_days = 0 if women_days == .

	gen				child_days = (sa2q8 * sa2q9)
	replace			child_days = 0 if child_days == . 
	*** again, this is hired labor only for harvest
	
* free labor days, from other households
	replace			sa2q12a = 0 if sa2q12a == .
	replace			sa2q12b = 0 if sa2q12b == .
	replace			sa2q12c = 0 if sa2q12c == .

	gen				free_days = (sa2q12a + sa2q12b + sa2q12c)
	replace			free_days = 0 if free_days == . 

* total labor days for harvest
	gen 			hrv_labor = (men_days + women_days + child_days + free_days + hh_days)
	lab var			hrv_labor "total labor at harvest (days)"

* check for missing values
	mdesc			hrv_labor
	*** no missing values
	
	
* **********************************************************************
* 2 - end matter, clean up to save
* **********************************************************************

	keep 			hhid zone state lga sector hhid ea plotid ///
					hrv_labor tracked_obs
	
* create unique household-plot identifier
	sort			hhid plotid
	egen			plot_id = group(hhid plotid)
	lab var			plot_id "unique plot identifier"
	
	compress
	describe
	summarize 

* save file
		customsave , idvar(plot_id) filename("ph_secta2.dta") ///
			path("`export'") dofile(ph_secta2) user($user)

* close the log
	log	close

/* END */