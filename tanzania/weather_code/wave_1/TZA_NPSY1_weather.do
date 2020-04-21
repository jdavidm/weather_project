* Project: weather
* Created: April 2020
* Stata v.16

* does
	* reads in .dta files with daily values
    * runs weather_command .ado file
	* outputs .dta file of the relevant weather variables
	* does the above for both rainfall and temperature data

* assumes
	* masterDoFile.do
	* weather_command

* TO DO:
	* completed

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* set global user
	global user "jdmichler"

* define paths	
	global root = "G:/My Drive/weather_project/weather_data/tanzania/wave_1/daily"
	global export = "G:/My Drive/weather_project/weather_data/tanzania/wave_1/refined"
	global logout = "C:/Users/$user/git/weather_project/tanzania/weather_code/logs"

* open log	
	log using "`logout'/tza_npsy1_weather"


* **********************************************************************
* 1 - run command for rainfall
* **********************************************************************

* define local with all sub-folders in it
	loc folderList : dir "`root'" dirs "NPSY1_rf*"

* loop through each of the sub-folders in the above local
foreach folder of local folderList {
	
	* define local with all files in each sub-folder
		loc fileList : dir "`root'/`folder'" files "*.dta"
	
	* loop through each file in the above local
	foreach file in `fileList' {
		
		* import the daily data file
		use `root'/`folder'/`file', clear
		
		* define locals to govern file naming
		loc dat = substr("`file'", 1, 5)
		loc ext = substr("`file'", 7, 2)
		loc sat = substr("`file'", 10, 3)
		
		* run the user written weather command - this takes a while
		weather rf_ , rain_data ini_month(1) fin_month(7) day_month(1) keep(hhid)
		customsave , idvar(hhid) filename(`dat'_`ext'_`sat'.dta) path($export/`folder') dofile(TZA_NPSY1_weather)
	}
}


* **********************************************************************
* 2 - run command for temperature
* **********************************************************************

* define local with all sub-folders in it
	loc folderList : dir "`root'" dirs "NPSY1_t*"

* loop through each of the sub-folders in the above local
foreach folder of local folderList {

	* define local with all files in each sub-folder	
	loc fileList : dir "`root'/`folder'" files "*.dta"
	
	* loop through each file in the above local
	foreach file in `fileList' {
		
		* import the daily data file		
		use `root'/`folder'/`file', clear
		
		* define locals to govern file naming		
		loc dat = substr("`file'", 1, 5)
		loc ext = substr("`file'", 7, 2)
		loc sat = substr("`file'", 10, 2)
		
		* run the user written weather command - this takes a while		
		weather tmp_ , temperature_data growbase_low(10) growbase_high(30) ini_month(1) fin_month(7) day_month(1) keep(hhid)
		customsave , idvar(hhid) filename(`dat'_`ext'_`sat'.dta) path($export/`folder') dofile(TZA_NPSY1_weather)
		}
}

/* END */