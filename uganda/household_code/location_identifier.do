* Project: WB Weather
* Created on: Aug 2020
* Created by: themacfreezie
* Edited by: ek
* Stata v.16

* does
	* reads in Uganda wave 2-4 *year_AGSEC5A (harvest data) and *year_GSEC1 (region identification)
	* merges the planting date and the region identification
	* uses histograms to identify the main planting season

* assumes
	* customsave.ado
	* mdesc.ado

* TO DO:
	* write the code for all 3 waves
	* include sub region histograms
	* consider only using the main crops

* Important: so far we have used the date of the harvest to say what season is the main season. 
* upon reflection harvest does not demonstrate the main season, instead planting date does
* although harvest would reflect the end of the growing season
* wave 4 region identifier identifies households with a string that starts with H, how do you get rid of the H and then destring?

* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths	
	loc 	root 		= 		"$data/household_data/uganda"  
	loc 	logout 		= 		"$data/household_data/uganda/logs"
	loc     export 		= 		"$data/household_data/uganda/seasonid"

* close log 
	*log close
	
* open log	
	cap log close
	log using "`logout'/location_identifier", append

* **********************************************************************
* 1 - wave 2 A
* **********************************************************************

* import wave 2 season A
	use "`root'/wave_2/raw/2010_AGSEC5A.dta", clear

	rename a5aq6e month
	rename HHID hhid

* merge the location identification
	merge m:1 hhid using "`root'/wave_2/refined/2010_GSEC1"
	*** 0 unmerged from master, drop if unmerged from using
	drop if _merge == 2
	drop _merge

* how many people are harvesting and not harvesting in the season	
	sum month
	mdesc month
	*** 13873 observations
	*** 2942 missing
	
* histogram of planting month by region
	hist month, by (region)
	graph save Graph "`export'/wave2seasona.gph", replace

	
* histogram of planting month by subregion


* **********************************************************************
* 2 - wave 2 B
* **********************************************************************	
	
* import wave 2 season B
	use "`root'/wave_2/raw/2010_AGSEC5B.dta", clear

	rename a5bq6e month
	rename HHID hhid

* merge the location identification
	merge m:1 hhid using "`root'/wave_2/refined/2010_GSEC1"
	*** 0 unmerged from master, drop if unmerged from using
	drop if _merge == 2
	drop _merge

* determine how many people are harvesting and not harvesting in the season
	sum month
	mdesc month
	*** 9413 observations
	*** 11 missing

* histogram of planting month by region
	hist month, by (region)
	graph save Graph "`export'/wave2seasonb.gph", replace
	
* histogram of planting month by subregion

* **********************************************************************
* 3 - wave 3 A
* **********************************************************************

* import wave 3 season A
	use "`root'/wave_3/raw/2011_AGSEC5A.dta", clear

	rename a5aq6e month
	rename HHID hhid

* merge the location identification
	merge m:1 hhid using "`root'/wave_3/refined/2011_GSEC1"
	*** 326 unmerged from master, 12035 merged, drop unmerged
	drop if _merge != 3
	drop _merge

* summarize planting month to determine number of plantings that took place	
	sum month
	*** 12035 observations
	*** 2711 missing
	
* histogram of planting month by region
	hist month, by (region)
	graph save Graph "`export'/wave3seasona.gph", replace

* histogram of planting month by subregion


* **********************************************************************
* 4 - wave 3 B
* **********************************************************************	
	
* import wave 2 season B
	use "`root'/wave_3/raw/2011_AGSEC5B.dta", clear

	rename a5bq6e month
	rename HHID hhid

* merge the location identification
	merge m:1 hhid using "`root'/wave_3/refined/2011_GSEC1"
	*** 192 unmerged from master, 10156 merged, drop if unmerged
	drop if _merge != 3
	drop _merge

* summarize planting month to determine number of plantings that took place	
	sum month
	*** 10156 observations
	*** 5338 missing assume they did not harvest
	
* histogram of planting month by region
	hist month, by (region)
	graph save Graph "`export'/wave3seasonb.gph", replace

	
* histogram of planting month by subregion

* **********************************************************************
* 5 - wave 4 A
* **********************************************************************

* import wave 4 season A
	use "`root'/wave_4/raw/2013_AGSEC5A.dta", clear

	rename a5aq6e month
	rename HHID hhid

* summarize planting month to determine number of plantings that took place	
	sum month
	mdesc month
	*** 10774 observations
	*** 2009 missing

* histogram of planting month by subregion


* **********************************************************************
* 6 - wave 4 B
* **********************************************************************	
	
* import wave 4 season B
	use "`root'/wave_4/raw/2013_AGSEC5B.dta", clear

	rename a5bq6e month
	rename HHID hhid

* summarize planting month to determine number of plantings that took place	
	sum month
	mdesc month
	*** 10424 observations
	*** 3400 missing assume they did not harvest
	

* histogram of planting month by region
	*hist month, by (region)

* histogram of planting month by subregion



*
	gen crop = 1 if cropID == 210 | cropID == 310
	replace crop = 0 if crop == cropID == 130 | cropID == 141 | cropID == 150

	collapse month, by(crop district region)

	sort crop region

	hist month if crop == 1, by(region)
	hist month if crop == 1 & region == 0 
	hist month if crop == 1 & region == 1

	
graph save Graph "C:\Users\themacfreezie\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\beans_month_5A_2010.gph", replace

hist month if crop == 0, by(region)
graph save Graph "C:\Users\themacfreezie\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\cereal_month_5A_2010.gph", replace

compress
describe
summarize 
save "`export'/2010_5A_district", replace

clear

use "`root'\2010_AGSEC5B.dta", clear

rename a5bq6e month_5B_wv2
rename HHID hhid
keep if cropID == 130 | cropID == 141 | cropID == 150 | cropID == 210 | cropID == 310

merge m:1 hhid using "C:\Users\themacfreezie\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2010/2010_GSEC1"
drop if _merge == 2
drop _merge

gen crop = 1 if cropID == 210 | cropID == 310
replace crop = 0 if crop == .

collapse month, by(crop district region)

sort crop region

hist month if crop == 1, by(region)
graph save Graph "C:\Users\themacfreezie\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\beans_month_5B_2010.gph", replace

hist month if crop == 0, by(region)
graph save Graph "C:\Users\themacfreezie\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\cereal_month_5B_2010.gph", replace

compress
describe
summarize 
save "`export'/2010_5B_district", replace

clear 

global user "themacfreezie"

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2011"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2011"

use "`root'\2011_AGSEC5A.dta", clear

rename a5aq6e month_5A_wv3
tostring HHID, generate(hhid) format(%022.0g) force
keep if cropID == 130 | cropID == 141 | cropID == 150 | cropID == 210 | cropID == 310

merge m:1 hhid using "C:\Users\themacfreezie\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2011/2011_GSEC1"
drop if _merge == 2
drop if _merge == 1
drop _merge
* couldn't match 169 from master, hhs appear not to be in GSEC1

gen crop = 1 if cropID == 210 | cropID == 310
replace crop = 0 if crop == .

collapse month, by(crop district region)

sort crop region

hist month if crop == 1, by(region)
graph save Graph "C:\Users\themacfreezie\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\beans_month_5A_2011.gph", replace

hist month if crop == 0, by(region)
graph save Graph "C:\Users\themacfreezie\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\cereal_month_5A_2011.gph", replace

compress
describe
summarize 
save "`export'/2011_5A_district", replace

clear

use "`root'\2011_AGSEC5B.dta", clear

rename a5bq6e month_5B_wv3
tostring HHID, generate(hhid) format(%022.0g) force
keep if cropID == 130 | cropID == 141 | cropID == 150 | cropID == 210 | cropID == 310

merge m:1 hhid using "C:\Users\themacfreezie\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2011/2011_GSEC1"
drop if _merge == 2
drop if _merge == 1
drop _merge
* couldn't match 80 from master, hhs appear not to be in GSEC1

gen crop = 1 if cropID == 210 | cropID == 310
replace crop = 0 if crop == .

collapse month, by(crop district region)

sort crop region

hist month if crop == 1, by(region)
graph save Graph "C:\Users\themacfreezie\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\beans_month_5B_2011.gph", replace

hist month if crop == 0, by(region)
graph save Graph "C:\Users\themacfreezie\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\cereal_month_5B_2011.gph", replace
*the distributions in these histograms look less conclusive than in the other waves

compress
describe
summarize 
save "`export'/2011_5B_district", replace
