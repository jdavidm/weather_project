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

* TO DO:
	* complete

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* set global user
	*global	user		"jdmichler" // global managed by masterdo, turn on to run single file

* define paths
	loc		root 	= 	"G:/My Drive/weather_project/merged_data/malawi"
	loc		export 	= 	"G:/My Drive/weather_project/regression_data/malawi"
	loc		logout 	= 	"G:/My Drive/weather_project/merged_data/malawi/logs"

* open log	
	log 	using 		"`logout'/mwi_append_built", append

	
* **********************************************************************
* 1 - append cross section
* **********************************************************************

* import the first cross section file
	use 		"`root'/wave_1/cx1_merged.dta", clear

* append the second cross section file
	append		using "`root'/wave_3/cx2_merged.dta", force
	
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
	
* save file
	qui: compress
	customsave 	, idvarname(case_id) filename("mwi_sp.dta") ///
		path("`export'") dofile(mwi_append_built) user($user)


* **********************************************************************
* 3 - append long panel
* **********************************************************************
	
* import the first long panel file
	use 		"`root'/wave_1/lp1_merged.dta", clear

* append the second and third long panel file
	append		using "`root'/wave_2/lp2_merged.dta", force	
	append		using "`root'/wave_4/lp3_merged.dta", force	
	
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
	
* save file
	qui: compress
	customsave 	, idvarname(case_id) filename("mwi_complete.dta") ///
		path("`export'") dofile(mwi_append_built) user($user)

* close the log
	log	close

/* END */