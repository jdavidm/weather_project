* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in output from pp_sect11a1 (area) 
	* merges with production and value from ph_secta3
	* creates yield and value per hectare values
	* outputs clean data file ready for combination with wave 1 hh data

* assumes
	* customsave.ado
	
* TO DO:
	* issues calling merge file from root   
	
* **********************************************************************
* 0 - setup
* **********************************************************************
	
* define paths	
	loc root = "$data/household_data/nigeria/wave_1/refined"
	loc export = "$data/household_data/nigeria/wave_1/refined"
	loc logout = "$data/household_data/nigeria/logs"


* close log (in case still open)
	*log close
	
* open log	
	log using "`logout'/create_yld", append

* **********************************************************************
* 1 - general clean up, importing, etc. 
* **********************************************************************

* import the file 
		use "`root'/pp_sect11a1", clear 

*merge in conversion file 
*having issues to call file using root???
	merge 1:m zone state lga ea hhid plotid using "G:\My Drive\weather_project\household_data\nigeria\wave_1\refined\ph_secta3.dta" 
	***matched 9,829
	***not matched - using 88, master 940
sort _merge
	***umatched master 940 observations with some plotsize but maybe did not produce - or had no output in the rainy season
	***unmatched user no plot size reported - unclear why no plot size reported... but not very many...
keep if _merge == 3
drop _merge

* **********************************************************************
* 2 - rename denominator variables + collapse  
* **********************************************************************

gen tf_lnd = plotsize
gen cp_lnd = plotsize if cropcode == 1080 
	***8520 missing values - matches with observations for production 

collapse (sum) tf_lnd tf_hrv cp_lnd cp_hrv, by (zone state lga ea hhid)

* **********************************************************************
* 3 - generate per hectare measures 
* **********************************************************************

gen tf_yld = tf_hrv / tf_lnd
gen cp_yld = cp_hrv / cp_lnd
	***1828 missing values - 1028 producing households 

