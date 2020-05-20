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
	* everything

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* set global user
	global user "themacfreezie"

* define paths
	loc root = "C:/Users/$user/git/weather_project/tanzania/household_code"


* **********************************************************************
* 1 - run individual hh_cleaning .do files
* **********************************************************************

* loops through four waves of tza hh code
* define local with all sub-folders in it
	loc folderList : dir "`root'" dirs "wave_*"

* define local with all files in each sub-folder
	foreach folder of loc folderList {

* loop through each long rainy season file in the above local
	loc fileList : dir "`root'/`folder'" files "*AGSEC*A.do"
	
* loop through each file in the above local
	foreach file in `fileList' {
	    
	* run each individual file
		do "`root'/`folder'/`file'"		
	}
	
* loop through each short rainy season file in the above local
	loc fileList : dir "`root'/`folder'" files "*AGSEC*B.do"
	
* loop through each file in the above local
	foreach file in `fileList' {
	    
	* run each individual file
		do "`root'/`folder'/`file'"			
	}
	}
	
/* END */

* some commentary:
* 2A and 2B are same variables but in different seasons
* merge all the As first, merge all the Bs first
* start by merging sec3s into sec2s
* sec4s can be pulled into the merged 2&3 (using plot_id)
* sec5s must be collapsed down to the household level before merging (using hhid)
* will need to merge household regional identifiers (HH_SEC_A) into sec 5 before merging with other sections
* then append A big dataset with B big dataset
