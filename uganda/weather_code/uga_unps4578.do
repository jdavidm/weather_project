* Project: WB Weather
* Created on: April 2020
* Created by: jdm
* edited by: alj 
* Stata v.16

* does
	* reads in Uganda, wave 1 .csv files
	* outputs .dta file ready for processing by the weather program
	* does the above for both rainfall and temperature data

* assumes
	* customsave.ado

* TO DO:
	* completed
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* set user
	*global user "aljosephson" // global user set in masterdo

* define paths
	global root = "G:/My Drive/weather_project/weather_data/uganda/extra/raw"
	global export = "G:/My Drive/weather_project/weather_data/uganda/extra/daily"
	global logout = "G:/My Drive/weather_project/weather_data/uganda/logs"

* open log
	cap log close 
	log using "$logout/uga_unps4578", replace


* **********************************************************************
* 1 - converts weather data
* **********************************************************************

	* define local with all files in each sub-folder	
		loc fileList : dir "$root" files "*.csv"
		
	* loop through each file in the above local	
	foreach file in `fileList' {
		
		* import the .csv files - this takes time	
		import delimited "$root/`file'", varnames (1)   ///
			encoding(Big5) stringcols(1) clear
			
	* define local to capture property name
		loc name = substr("`file'", 1, 22)

		* save file
		customsave , idvar(xyid) filename("`name'.dta") ///
			path("$export") dofile(uga_unps4578) user($user)
	}

	log close 
	
/* END */
