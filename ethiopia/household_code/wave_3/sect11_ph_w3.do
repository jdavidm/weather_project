* Project: WB Weather
* Created on: June 2020
* Created by: McG
* Stata v.16

* does
	* cleans Ethiopia household variables, wave 3 PH sec11
	* seems to roughly correspong to Malawi ag-modI and ag-modO
	* contains crop sales data
	* hierarchy: holder > parcel > field > crop

* assumes
	* customsave.ado
	
* TO DO:
	* done
	
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root = "$data/household_data/ethiopia/wave_3/raw"
	loc export = "$data/household_data/ethiopia/wave_3/refined"
	loc logout = "$data/household_data/ethiopia/logs"

* open log
	cap log close
	log using "`logout'/wv3_PHSEC11", append


* **********************************************************************
* 1 - preparing ESS (Wave 3) - Post Harvest Section 11
* **********************************************************************

* load data
	use 		"`root'/sect11_ph_w3.dta", clear

* dropping duplicates
	duplicates drop
	
* creating district identifier
	egen 		district_id = group( saq01 saq02)
	label var 	district_id "Unique district identifier"
	distinct	saq01 saq02, joint
	*** 69 distinct districts
	*** same as pp sect2, pp sect3, and ph sect9, good
	
* drop if obs haven't sold any crop
	tab			ph_s11q01
	*** 6,181 answered no (!)
	
	tab			ph_s11q04 ph_s11q01, missing
	*** sales data not present for al 6,181 obs that answered no
	
	drop 		if ph_s11q01 == 2
	
* creating unique crop identifier
	tostring	crop_code, generate(crop_codeS)
	generate 	crop_id = holder_id + " " + crop_codeS
	isid		crop_id
	drop		crop_codeS	
	
* generate unique identifier
	describe
	sort 		holder_id crop_code
	isid 		holder_id crop_code

* create conversion key 
	rename		ph_s11q03_b unit_cd
	merge 		m:1 crop_code unit_cd using "`root'/Crop_CF_Wave3_use.dta"
	*** 92 not matched from master

	tab 		_merge
	drop		if _merge == 2
	drop		_merge


* **********************************************************************
* 2 - generating sales values and sales quantities
* **********************************************************************
	
* ***********************************************************************
* 2a - generating conversion factors
* ***********************************************************************	
	
* constructing conversion factor - same procedure as sect9_ph_w3
* exploring conversion factors - are any the same across all regions and obs?
	tab 		unit_cd
	egen		unitnum = group(unit_cd)
	*** 29 units listed
	
	gen			cfavg = (mean_cf1 + mean_cf2 + mean_cf3 + mean_cf4 + mean_cf6 ///
							+ mean_cf7 + mean_cf12 + mean_cf99)/8
	pwcorr 		cfavg mean_cf_nat	
	*** correlation of 0.9999 - this will work
	
	local 		units = 29
	forvalues	i = 1/`units'{
	    
		tab		unit_cd if unitnum == `i'
		tab 	cfavg if unitnum == `i', missing
	} 
	*** results! universal units are:
	*** kilogram, gram, quintal, and box
	*** piece/number lg, kubaya lg, and kubaya md are "universal", only one ob
	*** also, chinets (small, medium, and large) have no conversion factors given

* generating conversion factors
* starting with units found to be universal
	gen			cf = 1 if unit_cd == 1 			// kilogram
	replace		cf = .001 if unit_cd == 2 		// gram
	replace		cf = 100 if unit_cd == 3 		// quintal
	replace 	cf = 48.0513 if unit_cd == 6	// box
	
	replace 	cf = 30 if unit_cd == 51		// chinets
	replace 	cf = 50 if unit_cd == 52
	replace 	cf = 70 if unit_cd == 53
	
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
	*** missing 53 converstion factors
	
	sort		cf unit_cd
	*** missing obs are spread out across different units
	*** kubaya (sm)
	*** kunna/mishe/kefer/enkib (sm, md, lg) 
	*** madaberia/nuse/shera/cheret (sm, md, lg)
	*** tasa/tanika/shember/selmon (md, lg)

	*** all the units above have lots of other obs w/ values
	*** all units labelled 'other' missing a conversion factor

* filling in as many missing cfs as possible
	sum			cf if unit_cd == 101, detail	// kubaya (sm)
	replace 	cf = `r(p50)' if unit_cd == 101 & cf == .
	
	sum			cf if unit_cd == 111, detail	// kunna/mishe/kefer/enkib (sm)
	replace 	cf = `r(p50)' if unit_cd == 111 & cf == .
	
	sum			cf if unit_cd == 112, detail	// kunna/mishe/kefer/enkib (md)
	replace 	cf = `r(p50)' if unit_cd == 112 & cf == .
	
	sum			cf if unit_cd == 113, detail	// kunna/mishe/kefer/enkib (lg)
	replace 	cf = `r(p50)' if unit_cd == 113 & cf == .
	
	sum			cf if unit_cd == 121, detail	// madaberia/nuse/shera/cheret (sm)
	replace 	cf = `r(p50)' if unit_cd == 121 & cf == .
	
	sum			cf if unit_cd == 122, detail	// madaberia/nuse/shera/cheret (md)
	replace 	cf = `r(p50)' if unit_cd == 122 & cf == .
	
	sum			cf if unit_cd == 123, detail	// madaberia/nuse/shera/cheret (lg)
	replace 	cf = `r(p50)' if unit_cd == 123 & cf == .
	
	sum			cf if unit_cd == 182, detail	// tasa/tanika/shember/selmon (md)
	replace 	cf = `r(p50)' if unit_cd == 182 & cf == .
	
	sum			cf if unit_cd == 183, detail	// tasa/tanika/shember/selmon (lg)
	replace 	cf = `r(p50)' if unit_cd == 183 & cf == .
	
* check results
	sort		cf unit_cd
	*** 23 obs still missing cfs are all labelled 'other'
	
* ultimate goal is to create a region based set of prices (birr/kg) by crop
* we can therefore probably throw out those 23 obs
	tab			crop_code if unit_cd == 900
	* majority is rape seed, 15 obs of 53 rape seed observations
	* could meaningfully impact price of rape seed (crop_cod = 26)
	* other eight obs are spread across 7 crops:
	* barley, maize, sorghum, teff, wheat, horse beans (2 obs), field peas
	
	drop		if unit_cd == 900

	
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
	tab 		sales_val
	*** not missing any sales values
	
* generate a price per kilogram
	gen 		price = sales_val/sales_qty_kg
	*** this can be applied to harvested crops which weren't sold
	
	lab var		price "Sales Price (BIRR/kg)"
	
	
* ***********************************************************************
* 3 - cleaning and keeping
* ***********************************************************************

* renaming some variables of interest
	rename 		household_id hhid
	rename 		household_id2 hhid2
	rename 		saq01 region
	rename 		saq02 zone
	rename 		saq03 woreda
	rename 		saq05 ea

*	Restrict to variables of interest
	keep  		holder_id- crop_code price crop_id
	order 		holder_id- crop_code price crop_id

* final preparations to export
	isid 		holder_id crop_code
	compress
	describe
	summarize 
	sort 		holder_id ea_id crop_code
	customsave , idvar(crop_id) filename(PP_SEC11.dta) path("`export'") ///
		dofile(PP_SEC11) user($user)

* close the log
	log	close