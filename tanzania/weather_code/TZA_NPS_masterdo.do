* Project: weather
* Created: April 2020
* Stata v.16

* does
	* Executes all wave specific Tanzania weather .do files
    * runs weather_command .ado file
	* outputs .dta rainfall data ready to merge with LSMS household data

* assumes
	* weather_command
	* subsidiary, wave-specific .do files

* TO DO:
	* completed

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* set global user
	global user "jdmichler"

* define paths
	loc root = "C:/Users/$user/git/weather_project/tanzania/weather_code"
	loc logout = "G:/My Drive/weather_project/weather_data/tanzania/logs"

* open log	
	log using "`logout'/tza_nps_master"


* **********************************************************************
* 1 - run .do files
* **********************************************************************

* define local with all sub-folders in it
	loc folderList : dir "`root'" dirs "wave_*"

* define local with all files in each sub-folder
	foreach folder of loc folderList {	
		do "`root'/`folder'/TZA_NPSY1_converter.do"				//	convert wave 1 .csv to .dta
		do "`root'/`folder'/TZA_NPSY2_converter.do"				//	convert wave 2 .csv to .dta
		do "`root'/`folder'/TZA_NPSY3_converter.do"				//	convert wave 3 .csv to .dta
		do "`root'/`folder'/TZA_NPSY4_converter.do"				//	convert wave 4 .csv to .dta
	}

* define local with all files in each sub-folder
	foreach folder of loc folderList {	
		do "`root'/`folder'/TZA_NPSY1_weather.do"			//	generate wave 1 .weather variables
		do "`root'/`folder'/TZA_NPSY2_weather.do"			//	generate wave 2 .weather variables
		do "`root'/`folder'/TZA_NPSY3_weather.do"			//	generate wave 3 .weather variables
		do "`root'/`folder'/TZA_NPSY4_weather.do"			//	generate wave 4 .weather variables
	}

* close the log
	log	close

/* END */