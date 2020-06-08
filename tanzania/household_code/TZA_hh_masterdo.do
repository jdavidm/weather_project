* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.16

* does
	* Executes all wave specific Tanzania hh .do files
	* outputs finished houshold data set ready to merge with weather

* assumes
	* customsave.ado 
	* subsidiary, wave-specific .do files

* TO DO:
	* write build.do and append-built.do files

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* set global user
	global user "themacfreezie"

* define paths
	loc root = "C:/Users/$user/git/weather_project/tanzania/household_code"


* **********************************************************************
* 1 - run individual HH and AG cleaning .do files
* **********************************************************************

* loops through four waves of tza hh code

* starting with running all individual hh data files
* define local with all sub-folders in it
	loc folderList : dir "`root'" dirs "wave_*"

* define local with all files in each sub-folder
	foreach folder of loc folderList {

	* loop through each HHSEC file in the folder local
		loc HHfile : dir "`root'/`folder'" files "*HHSEC*.do"
	
	* loop through each file in the above local
		foreach file in `HHfile' {
	    
		* run each individual file
			do "`root'/`folder'/`file'"		
	}
	* loop through each AGSEC file in the folder local
		loc AGfile : dir "`root'/`folder'" files "*AGSEC*.do"
	
	* loop through each file in the above local
		foreach file in `AGfile' {
	    
		* run each individual file
			do "`root'/`folder'/`file'"		
	}		
}


* **********************************************************************
* 2 - run wave specific .do files to merge with weather
* **********************************************************************

* do each IHS3 household cleaning files
	do 			"`dofile'/wave_1/npsy1_build.do"			//	merges NPSY1 to weather
	do 			"`dofile'/wave_2/npsy2_build.do"			//	merges NPSY2 to weather
	do 			"`dofile'/wave_3/npsy3_build.do"			//	merges NPSY3 to weather
	do 			"`dofile'/wave_4/npsy4_build.do"			//	merges NPSY4 to weather


* **********************************************************************
* 3 - run .do file to append each wave
* **********************************************************************

	do			"`dofile'/TZA_append_built.do"				// append waves
	
/* END */

