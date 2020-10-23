* Project: WB Weather
* Created on: May 2020
* Created by: alj 
* Edited by: jdm
* Last edit: 23 October 2020 
* Stata v.16

* does
	* Executes all wave specific Uganda hh .do files
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
	loc root = "$code/niger/household_code"


* **********************************************************************
* 1 - run prep hh_cleaning .do files
* **********************************************************************

* do each GSEC1 household cleaning files
	do 			"`dofile'/wave_1/ECVMA_2011_ms00p1.do"		//	clean location information wv1 
	do 			"`dofile'/wave_2/ECVMA_2014_ms00p1.do"		//	clean location information wv2 
	do 			"`dofile'/wave_2/ECVMA_2014_as2e2p2.do"		//	clean price data wv2

* **********************************************************************
* 2 - run individual hh_cleaning .do files
* **********************************************************************

* because of naming conventions in Niger
* it is easier to just run each file individually

* wave 1 cleaning files
	do 			"`dofile'/wave_1/ECVMA_2011_as1p1.do"		//	clean plot and inputs
	do 			"`dofile'/wave_1/ECVMA_2011_as1p2.do"		//	clean post planting labor
	do 			"`dofile'/wave_1/ECVMA_2011_as2ep2.do"		//	clean crop production & prices

* wave 2 cleaning files
	do 			"`dofile'/wave_2/ECVMA_2014_as1p1.do"		//	clean plot size
	do 			"`dofile'/wave_2/ECVMA_2014_as2ap1.do"		//	clean inputs
	do 			"`dofile'/wave_2/ECVMA_2014_as2ap2.do"		//	clean post planting labor
	do 			"`dofile'/wave_2/ECVMA_2014_as2e1p2.do"		//	clean crop production
	
		
* **********************************************************************
* 2 - run wave specific .do files to merge hh data together
* **********************************************************************

* merge each cleaned file together
	do 			"`dofile'/wave_1/ECVMA_2011_merge.do"			//	merges wv 1 hh datasets
	do 			"`dofile'/wave_2/ECVMA_2014_merge.do"			//	merges wv 2 hh datasets

	
* **********************************************************************
* 3 - run wave specific .do files to merge with weather
* **********************************************************************

* merge weather data into cleaned household data
	do 			"`dofile'/wave_1/ECVMA_2011_build.do"			//	merges ECVAMAY1 to weather
	do 			"`dofile'/wave_2/ECVMA_2014_build.do"			//	merges ECVAMAY2 to weather

	
* **********************************************************************
* 5 - run .do file to append each wave
* **********************************************************************

	do			"$`dofile'/ngr_cappend_built.do"				// append waves
	
/* END */
