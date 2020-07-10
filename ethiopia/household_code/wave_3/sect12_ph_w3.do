* Project: WB Weather
* Created on: June 2020
* Created by: McG
* Stata v.16

* does
	* cleans Ethiopia household variables, wave 3 PH sec12
	* seems to roughly correspong to Malawi ag-modD and ag-modK
	* contains harvest and sales info on fruit/nuts/root crops
	* hierarchy: holder > parcel > field > crop

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
	loc root = "$data/household_data/ethiopia/wave_3/raw"
	loc export = "$data/household_data/ethiopia/wave_3/refined"
	loc logout = "$data/household_data/ethiopia/logs"

* open log
	cap log close
	log using "`logout'/wv3_PHSEC12", append


* **********************************************************************
* 1 - preparing ESS (Wave 3) - Post Harvest Section 12
* **********************************************************************

* load data
	use "`root'/sect12_ph_w3.dta", clear

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
	drop if crop_code == 119	// other, oil seed
	drop if crop_code == 123	// other, vegetable
	*** 4,913 obs dropped
	*** must check other crops

* generate unique identifier
	describe
	sort 		holder_id crop_code
	isid 		holder_id crop_code
	
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

* check for missing crop codes
	tab			crop_code, missing	
	*** this is supposed to be fruits and nuts 
	*** but still a few obs w/ maize and sorghum and the like
	*** like in Sect9, no crop codes are missing
	
* look for correlation b/w units of measure (harvest and sales)
	pwcorr		ph_s12q03_b ph_s12q0b
	*** 0.9848 - very very very high

* create conversion key 
	rename 		ph_s12q03_b unit_cd
	merge 		m:1 crop_code unit_cd using "`root'/Crop_CF_Wave3_use.dta"
	*** 572 not matched from master
	*** this seems like a lot, only 399 matched

	tab 		_merge
	drop		if _merge == 2
	drop		_merge

* **********************************************************************
* X - dummy code
* **********************************************************************	

	gen 		hrv_wgt = mean_cf_nat * ph_s12q03_a if mean_cf_nat != .	
	
	mi set 		wide  
	mi xtset, 	clear 
	mi register imputed hrv_wgt 
	sort		holder_id crop_code, stable
	mi impute 	pmm hrv_wgt i.district_id, add(1) rseed(245780) ///
					noisily dots force knn(5) bootstrap 
	mi 			unset	
	
	drop 		hrv_wgt
	rename 		hrv_wgt_1_ hrv_wgt
	
	* renaming key variables	
	rename		ph_s12q07 sales_qty	
	gen			sales_qty_kg = sales_qty * mean_cf_nat if mean_cf_nat != .
	
	rename		ph_s12q08 sales_val
	gen 		price = sales_val/sales_qty_kg
	lab var		price "Sales price (BIRR/kg)"
	
	
/*	
* ***********************************************************************
* 2a - generating conversion factors
* ***********************************************************************	
	
* constructing conversion factor - same procedure as sect9_ph_w3
* exploring conversion factors - are any the same across all regions and obs?
	tab 		unit_cd
	egen		unitnum = group(unit_cd)
	*** 60 units listed
	
	gen			cfavg = (mean_cf1 + mean_cf2 + mean_cf3 + mean_cf4 + mean_cf6 ///
							+ mean_cf7 + mean_cf12 + mean_cf99)/8
	pwcorr 		cfavg mean_cf_nat	
	*** correlation of 0.9999
	
	local 		units = 60
	forvalues	i = 1/`units'{
	    
		tab		unit_cd if unitnum == `i'
		tab 	cfavg if unitnum == `i', missing
	} 
	*** results! universal units are:
	*** kilogram, gram, quintal, box, shekim (md)
	
	*** "universal" with only one ob w/ a value
	*** jenbe, bumch (sm, md, lg), chinet (sm, md, lg), shekim (sm, lg)
	*** zorba (sm, md, lg)
	
	*** no conversion values for:
	*** and 17 obs labelled 'other' missing cfs

* generating conversion factors
* starting with units found to be universal
	gen			cf = 1 if unit_cd == 1 			// kilogram
	replace		cf = .001 if unit_cd == 2 		// gram
	replace		cf = 100 if unit_cd == 3 		// quintal
	replace 	cf = 21.66 if unit_cd == 162		// sjekim (md)
	
* now moving on to region specific units
	replace 	cf = mean_cf1 if saq01 == 1 & cf == .
	replace		cf = mean_cf2 if saq01 == 2 & cf == .	
	replace 	cf = mean_cf3 if saq01 == 3 & cf == .
	replace 	cf = mean_cf4 if saq01 == 4 & cf == .
	replace 	cf = mean_cf99 if saq01 == 5 & cf == .
	replace 	cf = mean_cf6 if saq01 == 6 & cf == .
	replace 	cf = mean_cf7 if saq01 == 7 & cf == .
	replace 	cf = mean_cf12 if saq01 == 12 & cf == .
	replace 	cf = mean_cf99 if saq01 == 13 & cf == .
	replace 	cf = mean_cf99 if saq01 == 15 & cf == .
	replace		cf = mean_cf_nat if cf == . & mean_cf_nat != . 
	*** 0 changes for the last line
	
* checking veracity of kg estimates
	tab 		cf, missing
	*** missing 2,017 converstion factors!
	
	sort		cf unit_cd
	*** missing obs are spread out across different units
	*** jenbe
	*** chinet (md, lg)
	*** esir (sm, md, lg)
	*** joniya/kasha (sm, lg)
	*** kerchat/kemba (sm, md, lg)
	*** kubaya (sm)
	*** kunna/mishe/kefer/enkib (sm, md) 
	*** madaberia/nuse/shera/cheret (sm, md, lg)
	*** medeb (sm, md)
	*** sahin (sm, md, lg)
	*** tasa/tanika/shember/selmon (sm)
	*** zorba/akara (md)
	*** other

	*** some of the units above have lots of other obs w/ values, including
	*** esir (sm, md, lg), kerchat/kemba (sm, md), 
	*** madaberia/nuse/shera/cheret (sm, md, lg), medeb (sm, md),
	*** sahin (sm, md, lg), tasa/tanika/shember/selmon (sm)
	
	*** some have only one or no obs w/ cfs, including:
	*** jenbe (0 values), chinet md (0), chinet lg (0), joniya/kasha sm (1), 
	*** joniya/kasha lg (1), kerchat/kemba lg (1), kubaya sm (0), 
	*** kunna/mishe/kefer/enkib sm (0), kunna/mishe/kefer/enkib md (1), 
	*** zorba/akara md (0)
	
	*** all units labelled 'other' missing a conversion factor

* filling in as many missing cfs as possible
* only using means of units w/ multiple other obs with values
	sum			cf if unit_cd == 101	// esir (sm), mean = 
	replace 	cf = .26825 if unit_cd == 101 & cf == .
	
	sum			cf if unit_cd == 111	// esir (md), mean = 
	replace 	cf = 6.073 if unit_cd == 111 & cf == .
	
	sum			cf if unit_cd == 112	// esir (lg), mean = 
	replace 	cf = 9.9388 if unit_cd == 112 & cf == .
	
	sum			cf if unit_cd == 113	// kerchat/kemba (sm), mean = 
	replace 	cf = 17.2898 if unit_cd == 113 & cf == .
	
	sum			cf if unit_cd == 121	// kerchat/kemba (md), mean = 
	replace 	cf = 36.806 if unit_cd == 121 & cf == .
	
	sum			cf if unit_cd == 122	// madaberia/nuse/shera/cheret (sm), mean = 
	replace 	cf = 82.231 if unit_cd == 122 & cf == .
	
	sum			cf if unit_cd == 122	// madaberia/nuse/shera/cheret (md), mean = 
	replace 	cf = 82.231 if unit_cd == 122 & cf == .
	
	sum			cf if unit_cd == 123	// madaberia/nuse/shera/cheret (lg), mean = 
	replace 	cf = 104.42 if unit_cd == 123 & cf == .
	
	sum			cf if unit_cd == 183	// medeb (sm), mean = 
	replace 	cf = 1.0824 if unit_cd == 183 & cf == .
	
	sum			cf if unit_cd == 182	// medeb (md), mean = 
	replace 	cf = .66792 if unit_cd == 182 & cf == .
	
	sum			cf if unit_cd == 101	// sahin (sm), mean = 
	replace 	cf = .26825 if unit_cd == 101 & cf == .

	sum			cf if unit_cd == 101	// sahin (md), mean = 
	replace 	cf = .26825 if unit_cd == 101 & cf == .
	
	sum			cf if unit_cd == 101	// sahin (lg), mean = 
	replace 	cf = .26825 if unit_cd == 101 & cf == .
	
	sum			cf if unit_cd == 111	// tasa/tanika/shember/selmon (sm), mean = 
	replace 	cf = 6.073 if unit_cd == 111 & cf == .
	
* check results
	sort		cf unit_cd
	*** 23 obs still missing cfs are all labelled 'other'
	*** not sure how to address this
	
* ultimate goal is to create a region based set of prices (birr/kg) by crop
* we can therefore probably throw out those 23 obs

* investigating those 23 'other' unit of measure obs
	tab			crop_code if unit_cd == 900
	* majority is rape seed, 15 obs of 53 rape seed observations
	* could meaningfully impact price of rape seed (crop_cod = 26)
	* other eight obs are spread across 7 crops:
	* barley, maize, sorghum, teff, wheat, horse beans (2 obs), field peas
	
*	drop		if unit_cd == 900
	*** leaving this out for now
	
* ***********************************************************************
* 2b - constructing harvest weights
* ***********************************************************************	
	
* renaming key variables	
	rename		ph_s11q03_a sales_qty
	tab			sales_qty, missing
	*** not missing any values
	
	rename		ph_s11q04 sales_val
	
* converting sales quantity to kilos
	gen			sales_qty_kg = sales_qty * cf
	*** missing 23 values, this is expected (line 178)
	
	tab 		sales_val
	*** full information on sales values
	
* generate a price per kilogram
	gen 		price = sales_val/sales_qty_kg
	*** this can be applied to harvested crops which weren't sold
	*** still missing those 23
	
	lab var		price "Sales price (BIRR/kg)"
*/	

* ***********************************************************************
* 3 - cleaning and keeping
* ***********************************************************************

* renaming some variables of interest
	rename 		household_id hhid
	rename 		household_id2 hhid2
	rename 		saq01 region
	rename 		saq02 district
	label var 	district "District Code"
	rename 		saq03 ward	

*	Restrict to variables of interest
	keep  		holder_id- crop_code hrv_wgt price
	order 		holder_id- crop_code

* final preparations to export
*	isid 		// don't have one yet
	compress
	describe
	summarize 
	sort 		holder_id ea_id crop_code
	customsave , idvar(holder_id) filename(PP_SEC12.dta) path("`export'") ///
		dofile(PP_SEC12) user($user)

* close the log
	log	close	