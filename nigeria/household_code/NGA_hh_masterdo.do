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
	loc dofile = "$code/nigeria/household_code"

* **********************************************************************
* 1 - run individual HH cleaning .do files
* **********************************************************************

* loops through three waves of nga hh code

* starting with running all individual hh data files
* define local with all sub-folders in it
	loc folderList : dir "`dofile'" dirs "wave_*"

* define local with all files in each sub-folder
	foreach folder of loc folderList {

	* loop through each NGA file in the folder local
		loc NGA : dir "`dofile'/`folder'" files "NGA*.do"
	
	* loop through each file in the above local
		foreach file in `NGA' {
	    
		* run each individual file
			do "`dofile'/`folder'/`file'"		
	}		
}

* **********************************************************************
* 2 - run wave specific .do files to merge hh data together
* **********************************************************************

* do each GHSY2 household cleaning files
	do 			"`dofile'/wave_1/GHSY1_merge.do"			//	merges wv 1 hh datasets
	do 			"`dofile'/wave_2/GHSY2_merge.do"			//	merges wv 2 hh datasets
	do 			"`dofile'/wave_3/GHSY3_merge.do"			//	merges wv 3 hh datasets

* **********************************************************************
* 3 - run wave specific .do files to merge with weather
* **********************************************************************

* do each IHS3 household cleaning files
	do 			"`dofile'/wave_1/GHSY1_build.do"			//	merges NPSY1 to weather
	do 			"`dofile'/wave_2/GHSY2_build.do"			//	merges NPSY2 to weather
	do 			"`dofile'/wave_3/GHSY3_build.do"			//	merges NPSY3 to weather



* **********************************************************************
* 5 - run .do file to append each wave
* **********************************************************************

	do			"$code/nigeria/NGA_append_built.do"				// append waves
	
/* END */
