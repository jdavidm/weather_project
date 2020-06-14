* Project: WB Weather
* Created on: June 2020
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
	loc		cnvrt	=	"$data/household_data/tanzania/wave_3/raw"
	loc		root 	= 	"$data/merged_data/tanzania"
	loc		export 	= 	"$data/regression_data/tanzania"
	loc		logout 	= 	"$data/merged_data/tanzania/logs"

* open log	
	*log 	using 		"`logout'/tza_append_built", append

	
* **********************************************************************
* 1 - append all Tanzania data
* **********************************************************************
	
* import the third wave file
	use 		"`root'/wave_3/npsy3_merged.dta", clear

* append the first wave file
	append		using "`root'/wave_1/npsy1_merged.dta", force	
	
* create household panel id for year 1
	sort		y1_hhid
	egen		y1id = group(y1_hhid)
	lab var		y1id "panel household id"
	order		y1id
	
	xtset		y1id	
	xfill		y3_hhid if y3_hhid == "", i(y1id)
	xfill		y2_hhid if y2_hhid == "", i(y1id)

	duplicates 	drop y1id year if y1id != ., force
	
* append the second wave file
	append		using "`root'/wave_2/hhfinal_npsy2.dta", force	
	
* create household panel id for year 1
	sort		y2_hhid
	egen		y2id = group(y2_hhid)
	lab var		y2id "panel household id"
	order		y2id
	
	xtset		y2id	
	xfill		y3_hhid if y3_hhid == "", i(y2id)
	xfill		y1_hhid if y1_hhid == "", i(y2id)
	xfill		y1id if y1id == ., i(y2id)

	duplicates 	drop y2id year if y2id != ., force
	*** this gives us a data set of 6,173 but we should have 6,649

	
* append the fourth wave file
	append		using "`root'/wave_4/npsy4_merged.dta", force	
	*** this gives us a data set of 6,321 observations

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