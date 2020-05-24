* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 2 (2012-2013), POST PLANTING, AG SECT11C1
	* determines planting (not harvest) labor for rainy season
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
	log 	using 	"`logout'/wave_2_pp_sect11c1", append

	
* **********************************************************************
* 1 - labor 
* **********************************************************************
		
* import the first relevant data file
	use 			"`root'/sect11c1_plantingw2", clear 	

	describe
	sort			hhid plotid
	isid			hhid plotid

* create household member labor (weeks x days per week)
	gen				hh_1 = (s11c1q1a2 * s11c1q1a3)
	replace			hh_1 = 0 if hh_1 == .
	
	gen				hh_2 = (s11c1q1b2 * s11c1q1b3)
	replace			hh_2 = 0 if hh_2 == .
	
	gen				hh_3 = (s11c1q1c2 * s11c1q1c3)
	replace			hh_3 = 0 if hh_3 == .
	
	gen				hh_4 = (s11c1q1d2 * s11c1q1d3)
	replace			hh_4 = 0 if hh_4 == .
	*** this calculation is for up to 4 members of the household that were laborers
	*** per the survey, these are laborers for planting
	*** does not include harvest labor (see NGA_ph_secta2)

* create total household labor days for harvest
	gen				hh_days = hh_1 + hh_2 + hh_3 + hh_4
	
* hired labor days (# of people hired for harvest)(# of days they worked)
	gen				men_days = (s11c1q2 * s11c1q3)
	replace			men_days = 0 if men_days == .
	
	gen				women_days = (s11c1q5 * s11c1q6)
	replace			women_days = 0 if women_days == .
	
	gen				child_days = (s11c1q8 * s11c1q9)
	replace			child_days = 0 if child_days == . 

* total labor in days
	gen				pp_labor = hh_1 + hh_2 + hh_3 + hh_4 + men_days + women_days + child_days
	lab var			pp_labor "total labor for planting (days)"
	*** unlike harvest labor, this did not ask for unpaid/exchange labor

* check for missing values
	mdesc			pp_labor
	*** no missing values
		

* **********************************************************************
* 2 - end matter, clean up to save
* **********************************************************************

	keep 			hhid zone state lga sector hhid ea plotid ///
					pp_labor tracked_obs
	
* create unique household-plot identifier
	sort			hhid plotid
	egen			plot_id = group(hhid plotid)
	lab var			plot_id "unique plot identifier"
	
	compress
	describe
	summarize 

* save file
	customsave , idvar(plot_id) filename("pp_sect11c1.dta") ///
		path("`export'") dofile(pp_sect11c1) user($user)

* close the log
	log	close

/* END */