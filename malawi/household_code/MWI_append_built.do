* Project: WB Weather
* Created on: May 2020
* Created by: jdm
* Stata v.16

* does
	* reads in merged data sets
	* appends merged data sets
	* outputs foure data sets
		* all Malawi data
		* cross section
		* short panel
		* long panel

* assumes
	* all Malawi data has been cleaned and merged with rainfall
	* customsave.ado
	* xfill.ado

* TO DO:
	* complete

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		root 	= 	"$data/merged_data/malawi"
	loc		export 	= 	"$data/regression_data/malawi"
	loc		logout 	= 	"$data/merged_data/malawi/logs"

* open log	
	log 	using 		"`logout'/mwi_append_built", append

	
* **********************************************************************
* 1 - append cross section
* **********************************************************************

* import the first cross section file
	use 		"`root'/wave_1/cx1_merged.dta", clear

* append the second cross section file
	append		using "`root'/wave_3/cx2_merged.dta", force

* reformat case_id
	format %15.0g case_id

* drop duplicates (not sure why there are duplicats)
	duplicates 	tag case_id, generate(dup)
	drop if 	dup > 0 & qx_type == ""
	drop		dup

* create household, country, and data identifiers
	egen		cx_id = seq()
	lab var		cx_id "Cross section unique id"

	gen			country = "malawi"
	lab var		country "Country"

	gen			dtype = "cx"
	lab var		dtype "Data type"

* combine variables
	replace		hhweight	= hhweightR1 if hhweight == .
	replace		hh_x02 		= ag_c0a if hh_x02 == .
	replace		hh_x04		= ag_j0a if hh_x04 == .
	drop		hhweightR1 ag_c0a ag_j0a
	
* order variables
	order		country dtype region district urban ta strata cluster ///
				ea_id cx_id case_id hhid hhweight hh_x02 hh_x04

* save file
	qui: compress
	customsave 	, idvarname(case_id) filename("mwi_cx.dta") ///
		path("`export'") dofile(mwi_append_built) user($user)
	
	
* **********************************************************************
* 2 - append short panel
* **********************************************************************

* import the first short panel file
	use 		"`root'/wave_1/sp1_merged.dta", clear

* append the second short panel file
	append		using "`root'/wave_2/sp2_merged.dta", force

* reformat case_id
	format %15.0g case_id

* drop split-off households, keep only original households
	duplicates 	tag case_id year, generate(dup)
	drop if 	dup > 0 & splitoffR2 != 1
	drop if 	dup > 0 & tracking_R1_to_R2 ==1
	drop		dup
	duplicates 	tag case_id year, generate(dup)
	drop if		dup > 0 
	drop		dup

* create household, country, and data identifiers
	egen		spid = group(case_id)
	lab var		spid "Short panel household id"
	
	egen		sp_id = seq()
	lab var		sp_id "Short panel unique id"

	gen			country = "malawi"
	lab var		country "Country"

	gen			dtype = "sp"
	lab var		dtype "Data type"

* combine variables
	replace		urban		= urbanR2 if urban == .
	replace		strata 		= strataR2 if strata == .
	rename		hhweightR1 	hhweight
	drop		urbanR2- distance_R1_to_R2
	
* order variables
	order		country dtype region district urban ta strata cluster ///
				ea_id spid sp_id case_id y2_hhid hhweight
	
* save file
	qui: compress
	customsave 	, idvarname(sp_id) filename("mwi_sp.dta") ///
		path("`export'") dofile(mwi_append_built) user($user)


* **********************************************************************
* 3 - append long panel
* **********************************************************************
	
* import the first long panel file
	use 		"`root'/wave_1/lp1_merged.dta", clear

* append the second long panel file
	append		using "`root'/wave_2/lp2_merged.dta", force	
	
* reformat case_id
	format %15.0g case_id
	
* create household panel id for lp1 and lp2 using case_id
	egen		lpid = group(case_id)
	lab var		lpid "Long panel household id"	
	
* append the third long panel file	
	append		using "`root'/wave_4/lp3_merged.dta", force	

* fill in missing lpid for third long panel using y2_hhid
	egen		aux_id = group(y2_hhid)
	xtset 		aux_id
	xfill 		lpid if aux_id != ., i(aux_id)
	drop		aux_id
	
* drop split-off households, keep only original households
	duplicates 	tag lpid year, generate(dup)
	drop if		dup > 0 & mover_R1R2R3 == 1
	drop		dup
	duplicates 	tag case_id year, generate(dup)
	drop if 	dup > 0 & splitoffR2 != 1
	drop if 	dup > 0 & tracking_R1_to_R2 ==1
	drop		dup
	duplicates 	tag case_id year, generate(dup)
	drop if		dup > 0 
	drop		dup

* create household, country, and data identifiers
	sort		lpid year
	egen		lp_id = seq()
	lab var		lp_id "Long panel unique id"

	gen			country = "malawi"
	lab var		country "Country"

	gen			dtype = "lp"
	lab var		dtype "Data type"

* combine variables
	replace		urban		= urbanR2 if urban == .
	replace		urban		= urbanR3 if urban == .
	replace		strata 		= strataR2 if strata == .
	replace		strata 		= strataR3 if strata == .
	rename		hhweightR1 	hhweight
	drop		urbanR2- distance_R1_to_R2 urbanR3- distance_R2_to_R3
	
* order variables
	order		country dtype region district urban ta strata cluster ///
				ea_id lpid lp_id case_id y2_hhid y3_hhid hhweight
	
* save file
	qui: compress
	customsave 	, idvarname(case_id) filename("mwi_lp.dta") ///
		path("`export'") dofile(mwi_append_built) user($user)

* **********************************************************************
* 4 - append all Malawi data
* **********************************************************************
	
* import the cross section file
	use 		"`export'/mwi_cx.dta", clear

* append the two panel files
	append		using "`export'/mwi_sp.dta", force	
	append		using "`export'/mwi_lp.dta", force	

* order variables
	order		country dtype region district urban ta strata cluster ///
				ea_id case_id spid- y3_hhid hhweight	
* save file
	qui: compress
	customsave 	, idvarname(case_id) filename("mwi_complete.dta") ///
		path("`export'") dofile(mwi_append_built) user($user)

* close the log
	log	close

/* END */