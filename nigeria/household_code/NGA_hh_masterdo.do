* Project: WB Weather
* Created on: May 2020
* Created by: jdm
* Stata v.16

* does
	* Executes all wave specific Nigeria hh .do files
	* outputs finished houshold data set ready to merge with weather

* assumes
	* customsave.ado 
	* subsidiary, wave-specific .do files

* TO DO:
	* everything

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root = "$code/tanzania/household_code"


* **********************************************************************
* 1 - run individual hh_cleaning .do files
* **********************************************************************

* loops through four waves of tza hh code
* define local with all sub-folders in it
	loc folderList : dir "`root'" dirs "wave_*"

* define local with all files in each sub-folder
	foreach folder of loc folderList {

* loop through each long rainy season file in the above local
	loc fileList : dir "`root'/`folder'" files "*AGSEC*.do"
	
* loop through each file in the above local
	foreach file in `fileList' {
	    
	* run each individual file
		do "`root'/`folder'/`file'"		
	}		
	}
	
/* END */
