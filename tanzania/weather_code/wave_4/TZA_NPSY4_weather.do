* Project: weather
* Created: April 2020
* Stata v.16

* does
	* reads in Tanzania, wave 4 .dta files with daily values
    * runs weather_command .ado file
	* outputs .dta file of the relevant weather variables
	* does the above for both rainfall and temperature data

* assumes
	* TZA_NPS_masterDoFile.do
	* weather_command.ado

* TO DO:
	* completed

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* set global user
	global user "jdmichler"

* define paths	
	loc root = "G:/My Drive/weather_project/weather_data/tanzania/wave_4/daily"
	loc export = "G:/My Drive/weather_project/weather_data/tanzania/wave_4/refined"
	loc logout = "G:/My Drive/weather_project/weather_data/tanzania/logs"

* open log	
	*log using "`logout'/tza_npsy4_weather"


* **********************************************************************
* 1 - run command for rainfall
* **********************************************************************

* define local with all sub-folders in it
	loc folderList : dir "`root'" dirs "NPSY4_rf*"

* loop through each of the sub-folders in the above local
foreach folder of local folderList {
	
	* create directories to write output to
	qui: capture mkdir "`export'/`folder'/"
	
	* define local with all files in each sub-folder
		loc fileList : dir "`root'/`folder'" files "*.dta"
	
	* loop through each file in the above local
	foreach file in `fileList' {
		
		* import the daily data file
		use "`root'/`folder'/`file'", clear
		
		* define locals to govern file naming
		loc dat = substr("`file'", 1, 5)
		loc ext = substr("`file'", 7, 2)
		loc sat = substr("`file'", 10, 3)
		
		* run the user written weather command - this takes a while
		weather rf_ , rain_data ini_month(1) fin_month(7) day_month(1) keep(hhid)
		
		* save file
		customsave , idvar(hhid) filename("`dat'_`ext'_`sat'.dta") ///
			path("`export'/`folder'") dofile(TZA_NPSY4_weather) user(jdmichler)
	}
}


* **********************************************************************
* 2 - run command for temperature
* **********************************************************************

* define local with all sub-folders in it
	loc folderList : dir "`root'" dirs "NPSY4_t*"

* loop through each of the sub-folders in the above local
foreach folder of local folderList {
	
	* create directories to write output to
	qui: capture mkdir "`export'/`folder'/"

	* define local with all files in each sub-folder	
	loc fileList : dir "`root'/`folder'" files "*.dta"
	
	* loop through each file in the above local
	foreach file in `fileList' {
		
		* import the daily data file		
		use "`root'/`folder'/`file'", clear
		
		* define locals to govern file naming		
		loc dat = substr("`file'", 1, 5)
		loc ext = substr("`file'", 7, 2)
		loc sat = substr("`file'", 10, 2)
		
		* run the user written weather command - this takes a while		
		weather tmp_ , temperature_data growbase_low(10) growbase_high(30) ini_month(1) fin_month(7) day_month(1) keep(hhid)
		
		* save file
		customsave , idvar(hhid) filename("`dat'_`ext'_`sat'.dta") ///
			path("`export'/`folder'") dofile(TZA_NPSY4_weather) user(jdmichler)
		}
}

* close the log
	log	close

/* END */