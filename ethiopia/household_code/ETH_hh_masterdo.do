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
	* complete

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc dofile = "$code/ethiopia/household_code"


* **********************************************************************
* 1 - run individual HH cleaning .do files
* **********************************************************************

* loops through four waves of tza hh code

* starting with running all individual hh data files
* define local with all sub-folders in it
	loc folderList : dir "`dofile'" dirs "wave_*"

* define local with all files in each sub-folder
	foreach folder of loc folderList {

	* loop through each HHSEC file in the folder local
		loc HHfile : dir "`dofile'/`folder'" files "sec*.do"
	
	* loop through each file in the above local
		foreach file in `HHfile' {
	    
		* run each individual file
			do "`dofile'/`folder'/`file'"		
	}
}

	
* **********************************************************************
* 2 - run wave specific .do files to merge hh data together
* **********************************************************************

* do each individual dataset merge file
	do 			"`dofile'/wave_1/ess1_merge.do"			//	merges wv 1 hh datasets
	do 			"`dofile'/wave_2/ess2_merge.do"			//	merges wv 2 hh datasets
	do 			"`dofile'/wave_3/ess3_merge.do"			//	merges wv 3 hh datasets


* **********************************************************************
* 3 - run wave specific .do files to merge with weather
* **********************************************************************

* do each build file (merges hh data to weatehr data)
	do 			"`dofile'/wave_1/ess1_build.do"			//	merges ESSY1 to weather
	do 			"`dofile'/wave_2/ess2_build.do"			//	merges ESSY2 to weather
	do 			"`dofile'/wave_3/ess3_build.do"			//	merges ESSY3 to weather
	

* **********************************************************************
* 4 - run .do file to append each wave
* **********************************************************************

	do			"`dofile'/ETH_append_built.do"				// append waves
	
/* END */

