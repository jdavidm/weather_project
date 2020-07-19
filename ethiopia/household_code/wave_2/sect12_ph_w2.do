* Project: WB Weather
* Created on: June 2020
* Created by: McG
* Stata v.16

* does
	* cleans Ethiopia household variables, wave 3 PH sec12
	* seems to roughly correspong to Malawi ag-modD and ag-modK
	* contains harvest and sales info on fruit/nuts/root crops
	* hierarchy: holder > parcel > field > crop
	* two purposes: generating price data and generating harvest weights

* assumes
	* customsave.ado
	
* TO DO:
	* must find a unique ob identifier
	* like in pp_sect3, ph_sect9, & ph_sect11, many observtions from master are not being matched
	* must finish building out data cleaning - see wave 1 maybe	
	
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root = "$data/household_data/ethiopia/wave_2/raw"
	loc export = "$data/household_data/ethiopia/wave_2/refined"
	loc logout = "$data/household_data/ethiopia/logs"

* open log
	cap log close
	log using "`logout'/wv2_PHSEC12", append


* **********************************************************************
* 1 - preparing ESS 2013/14 (Wave 2) - Post Harvest Section 12
* **********************************************************************

* load data
	use 		"`root'/sect12_ph_w2.dta", clear

* dropping duplicates
	duplicates drop
	
* drop trees and other perennial crops
	drop if crop_code == 41 	// apples
	drop if crop_code == 42 	// bananas
	drop if crop_code == 44 	// lemons
	drop if crop_code == 45 	// mandarins
	drop if crop_code == 46 	// mangos
	drop if crop_code == 47 	// oranges
	drop if crop_code == 48 	// papaya
	drop if crop_code == 49 	// pineapples
	drop if crop_code == 50 	// citron
	drop if crop_code == 65 	// guava
	drop if crop_code == 66 	// peach
	drop if crop_code == 71 	// chat
	drop if crop_code == 72 	// coffee 
	drop if crop_code == 73 	// cotton
	drop if crop_code == 76 	// sugar cane
	drop if crop_code == 78 	// tobacco
	drop if crop_code == 84 	// avocados
	drop if crop_code == 85		// grazing land
	drop if crop_code == 64 	// godere
	drop if crop_code == 74 	// enset
	drop if crop_code == 75 	// gesho
	drop if crop_code == 81 	// rue
	drop if crop_code == 82 	// gishita
	drop if crop_code == 112 	// kazmir
	drop if crop_code == 98 	// other, root
	drop if crop_code == 115	// other, fruits
	drop if crop_code == 117	// other, spices
	drop if crop_code == 118	// other, pulses (?)
	drop if crop_code == 119	// other, oil seed
	drop if crop_code == 120	// other, cereal
	drop if crop_code == 121	// other, case crops
	drop if crop_code == 123	// other, vegetable
	*** 4,788 obs dropped
	
* checking unique identifier
	describe
	sort 		holder_id crop_code
*	isid 		holder_id crop_code
	*** non uniquely identifying

* checking on crop_code
	sort 		holder_id crop_code
	drop		if crop_code == .
	*** no obs dropped
	
	duplicates 	list holder_id crop_code
	*** 22 duplicate observations in terms of these variables
	
* creating unique crop identifier
	tostring	crop_code, generate(crop_codeS)
	generate 	crop_id = holder_id + " " + crop_codeS
	isid		crop_id	
	drop		crop_codeS	

* creating unique region identifier
	egen 		district_id = group( saq01 saq02)
	label var 	district_id "Unique region identifier"
	distinct	saq01 saq02, joint
	*** 64 distinct districts


