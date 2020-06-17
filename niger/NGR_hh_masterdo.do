* Project: WB Weather
* Created on: May 2020
* Created by: alj 
* Stata v.16

* does
	* Executes all wave specific Niger hh .do files
	* outputs finished houshold data set ready to merge with weather

* assumes
	* customsave.ado 
	* subsidiary, wave-specific .do files

* TO DO:
	* everything
	* ORDER WILL BE VERY IMPORTANT (see notes below)
	
* FILE LIST 
	* 2014_AS1P1 - do file to create plot size 
	* 2014_AS2AP1_1 - do file to create pesticide and herbicide binaries 
	* 2014_AS2AP1_2 - do file to create fertilizer 
		*** AS2AP_* both come from same original file - these could theoretically could be combined
	* 2014_as2ap2_1 - do file to create planting labor
	* 2014_as2ap2_2 - do file to create harvest labor 
	* 2014_AS2AP1_3 - do file to create prep labor AND merges in harvest and planting labor
		*** _3 MUST BE RUN LAST, with _1 and _2 preceeding - becuase these must be created to include in merge at end of file 
	* 2014_ms00p1 - do file to get regional indicators which are used in constructing prices (2014_as1p2_p)
	* 2014_as1p2_p - do file to create prices
		*** MUST BE RUN AFTER 2014_ms00p1
	* 2014_AS2E1P2 - do file to create harvest quantity and value - for millet and overall
		*** merges in prices - so must be created AFTER 2014_as1p2_p
	* 2014_merge - do file to combine above - should be run last 

* UN-NEEDED FILE LIST		
	* 2014_AS2BP1 - do file which examines seed - not used 
	* 2014_AS2E2P2 - placeholder file, was experimenting - not used 
	
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root = "$code/niger/household_code"


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
