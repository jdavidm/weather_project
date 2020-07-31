* Project: WB Weather
* Created on: May 2020
* Created by: ek
* Stata v.16

* does
	* reads in Nigera, WAVE 1 (2011), POST HARVEST (first visit), ECVMA2_AS2E2P2
	* determines primary crop & cleans harvest
	* converts to kilograms
	* produces value of harvest (Naria) 
	* including determining regional prices ... 
	* outputs clean data file ready for combination with wave 1 hh data

* assumes
	* customsave.ado
	* probably a conversion file
	
* TO DO:
	* EVERYTHING
	* clarify "does"
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths	
	loc root 		= 		"$data/household_data/niger/wave_2/raw"
   *loc cnvrt 		=		"$data/household_data/niger/conversion_files"
	loc export 		= 		"$data/household_data/niger/wave_2/refined"
	loc logout 		= 		"$data/household_data/niger/logs"

* open log	
	log using "`logout'/2014_as2e2p2", append
		

* **********************************************************************
* 1 - harvest information
* **********************************************************************

* import the first relevant data file
		use 				"`root'/ecvmaas2e_p2_en", clear 	
		