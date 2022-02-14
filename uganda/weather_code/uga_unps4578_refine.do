* Project: WB Weather
* Created on: April 2020
* Created by: jdm
* edited by: alj 
* Stata v.16

* does
	* reads in Uganda, .dta files with daily values
    * runs weather_command .ado file
	* outputs .dta file of the relevant weather variables
	* does the above for both rainfall and temperature data
	/* 	-the growing season that we care about is defined on the FAO website:
			http://www.fao.org/giews/countrybrief/country.jsp?code=UGA
		-we measure rainfall during the months that the FAO defines as sowing and growing
		-Uganda has a bi-modal distribution so we generate variables for both north and south
		-we define the relevant months for the north as April 1 - September 30 
		-we define the relevant months for the south as February 1 - July 31 */

* assumes
	* UGA_UNPS4578_converter.do
	* weather_command.ado
	* customsave.ado

* TO DO:
	* completed

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* set global user
	*global user "aljosephson"	// global user set in masterdo
	
* define paths	
	global root = "G:/My Drive/weather_project/weather_data/uganda/extra/daily"
	global export = "G:/My Drive/weather_project/weather_data/uganda/extra/refined"
	global logout = "G:/My Drive/weather_project/weather_data/uganda/logs"

* open log	
	cap log close 
*	log using "`$logout/uga_unpsy4578_weatherrefine", append 


* **********************************************************************
* 1.A - run command for rainfall - north
* **********************************************************************

	* define local with all files in each sub-folder
	loc fileList : dir "$root" files "*rf*.dta"
		
	* loop through each file in the above local
	foreach file in `fileList' {
		
		* import the daily data file
		use "$root/`file'", clear
				
	* define local to capture property name
		loc name = substr("`file'", 1, 16)
		
		* run the user written weather command - this takes a while
		weather rf_ , rain_data ini_month(4) fin_month(10) day_month(1) keep(xyid)
		
		* save file
		customsave , idvar(xyid) filename("`name'_n.dta") ///
			path("$export") dofile(uga_unps4578_refine) user($user)
	}


* **********************************************************************
* 1.B - run command for rainfall - south
* **********************************************************************
	
	* define local with all files in each sub-folder
	loc fileList : dir "$root" files "*rf*.dta"
	
	* loop through each file in the above local
	foreach file in `fileList' {
		
		* import the daily data file
		use "$root/`file'", clear
		
	* define local to capture property name
		loc name = substr("`file'", 1, 16)
		
		* run the user written weather command - this takes a while
		weather rf_ , rain_data ini_month(2) fin_month(8) day_month(1) keep(xyid)
		
		* save file
		customsave , idvar(xyid) filename("`name'_s.dta") ///
			path("$export") dofile(uga_unps4578_refine) user($user)
	}

* **********************************************************************
* 2.A - run command for temperature - north
* **********************************************************************
	
	* define local with all files in each sub-folder
	loc fileList : dir "$root" files "*tp*.dta"
	
	* loop through each file in the above local
	foreach file in `fileList' {
		
		* import the daily data file
		use "$root/`file'", clear
		
	* define local to capture property name
		loc name = substr("`file'", 1, 16)
		
		* run the user written weather command - this takes a while
		weather tmp_ , temperature_data growbase_low(10) growbase_high(30) ini_month(4) fin_month(10) day_month(1) keep(xyid)
		
		* save file
		customsave , idvar(xyid) filename("`name'_n.dta") ///
			path("$export") dofile(uga_unps4578_refine) user($user)
	}


* **********************************************************************
* 2.B - run command for temperature - south
* **********************************************************************
	
	* define local with all files in each sub-folder
	loc fileList : dir "$root" files "*tp*.dta"
	
	* loop through each file in the above local
	foreach file in `fileList' {
		
		* import the daily data file
		use "$root/`file'", clear
		
	* define local to capture property name
		loc name = substr("`file'", 1, 16)
		
		* run the user written weather command - this takes a while
		weather tmp_ , temperature_data growbase_low(10) growbase_high(30) ini_month(2) fin_month(8) day_month(1) keep(xyid)
		
		* save file
		customsave , idvar(xyid) filename("`name'_s.dta") ///
			path("$export") dofile(uga_unps4578_refine) user($user)
	}

* close the log
*	log	close

/* END */
