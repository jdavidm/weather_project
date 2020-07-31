* Project: WB Weather
* Created on: July 2020
* Created by: ek
* Stata v.16

* does
	* reads in merged data sets
	* merges panel data sets (W1-W3)
	* appends both to form complete data set (W1-W3)
	* outputs Nigeria data sets for analysis

* assumes
	* all Nigeria data has been cleaned and merged with rainfall
	* customsave.ado
	* xfill.ado

* TO DO:
	* done
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		root 	= 	"$data/merged_data/nigeria"
	loc		export 	= 	"$data/regression_data/nigeria"
	loc		logout 	= 	"$data/merged_data/nigeria/logs"

* open log	
	cap 	log 	close 
	log 	using 	"`logout'/nga_append_built", append

* **********************************************************************
* 1 - merge first three waves of Nigeria household data
* **********************************************************************

* using merge rather than append
* import wave 1 nigeria
	
	use "`root'/wave_1/ghsy1_merged", clear
	*** at the moment I believe that all three waves of nigeria identify hh's the same
	
* append wave 2 file
	append		using "`root'/wave_2/ghsy2_merged", force	
	
* append wave 3 file 
	append		using "`root'/wave_3/ghsy3_merged", force	
	
* check the number of observations again
	count
	*** 8384 observations 
	count if year2010!=.
	*** wave 1 has 2833
	count if year2012!=.
	*** wave 2 has 2768
	count if year2015!=.
	*** wave 3 has 2783
	
	gen			pl_id = hhid
	lab var			pl_id "panel household id/hhid"

	gen				country = "nigeria"
	lab var			country "Country"

	gen				dtype = "lp"
	lab var			dtype "Data type"
	
	gen 			time = .
	replace 		time = 2010 if year2010 == 2010
	replace 		time = 2012 if year2012 == 2012
	replace 		time = 2015 if year2015 == 2015
	
	isid			hhid time
	
* gen data source var
	gen 			data = "ghsy1"
	replace 		data = "ghsy1" if data2010 == "ghsy1"
	replace			data = "ghsy2" if data2012 == "ghsy2"
	replace			data = "ghsy3" if data2015 == "ghsy3"
	
* order variables
	order			country dtype zone state lga sector ea ///
						 time
				
* label household variables	
	lab var			sector  "Sector"
	lab var			zone "Zone"	
	lab var			state "State"
	lab var 		lga "lga"
	lab var			ea "Enumeration Area"
	lab var			time "Year"
	lab var			tf_lnd	"Total farmed area (ha)"
	lab var			tf_hrv	"Total value of harvest (2010 USD)"
	lab var			tf_yld	"value of yield (2010 USD/ha)"
	lab var			tf_lab	"labor rate (days/ha)"
	lab var			tf_frt	"fertilizer rate (kg/ha)"
	lab var			tf_pst	"Any plot has pesticide"
	lab var			tf_hrb	"Any plot has herbicide"
	lab var			tf_irr	"Any plot has irrigation"
	lab var			cp_lnd	"Total maize area (ha)"
	lab var			cp_hrv	"Total quantity of maize harvest (kg)"
	lab var			cp_yld	"Maize yield (kg/ha)"
	lab var			cp_lab	"labor rate for maize (days/ha)"
	lab var			cp_frt	"fertilizer rate for maize (kg/ha)"
	lab var			cp_pst	"Any maize plot has pesticide"
	lab var			cp_hrb	"Any maize plot has herbicide"
	lab var			cp_irr	"Any maize plot has irrigation"
	lab var 		data "Data Source"	

* label satellites variables
	loc	sat			rf* tp*
	foreach v of varlist `sat' {
		lab var 		`v' "Satellite/Extraction"		
	}
	
* label rainfall variables	
	loc	v01			v01*
	foreach v of varlist `v01' {
		lab var 		`v' "Mean Daily Rainfall"	
	}	
	
	loc	v02			v02*
	foreach v of varlist `v02' {
		lab var 		`v' "Median Daily Rainfall"
	}					
	
	loc	v03			v03*
	foreach v of varlist `v03' {
		lab var 		`v' "Variance of Daily Rainfall"
	}					
	
	loc	v04			v04*
	foreach v of varlist `v04' {
		lab var 		`v'  "Skew of Daily Rainfall"
	}					
	
	loc	v05			v05*
	foreach v of varlist `v05' {
		lab var 		`v'  "Total Rainfall"
	}					
	
	loc	v06			v06*
	foreach v of varlist `v06' {
		lab var 		`v' "Deviation in Total Rainfalll"
	}					
	
	loc	v07			v07*
	foreach v of varlist `v07' {
		lab var 		`v' "Z-Score of Total Rainfall"	
	}					
	
	loc	v08			v08*
	foreach v of varlist `v08' {
		lab var 		`v' "Rainy Days"
	}					
	
	loc	v09			v09*
	foreach v of varlist `v09' {
		lab var 		`v' "Deviation in Rainy Days"	
	}					
	
	loc	v10			v10*
	foreach v of varlist `v10' {
		lab var 		`v' "No Rain Days"
	}					
	
	loc	v11			v11*
	foreach v of varlist `v11' {
		lab var 		`v' "Deviation in No Rain Days"
	}					
	
	loc	v12			v12*
	foreach v of varlist `v12' {
		lab var 		`v' "% Rainy Days"	
	}					
	
	loc	v13			v13*
	foreach v of varlist `v13' {
		lab var 		`v' "Deviation in % Rainy Days"	
	}					
	
	loc	v14			v14*
	foreach v of varlist `v14' {
		lab var 		`v' "Longest Dry Spell"	
	}									

* label weather variables	
	loc	v15			v15*
	foreach v of varlist `v15' {
		lab var 		`v' "Mean Daily Temperature"
	}
	
	loc	v16			v16*
	foreach v of varlist `v16' {
		lab var 		`v' "Median Daily Temperature"
	}
	
	loc	v17			v17*
	foreach v of varlist `v17' {
		lab var 		`v' "Variance of Daily Temperature"
	}
	
	loc	v18			v18*
	foreach v of varlist `v18' {
		lab var 		`v' "Skew of Daily Temperature"	
	}
	
	loc	v19			v19*
	foreach v of varlist `v19' {
		lab var 		`v' "Growing Degree Days (GDD)"	
	}
	
	loc	v20			v20*
	foreach v of varlist `v20' {
		lab var 		`v' "Deviation in GDD"		
	}
	
	loc	v21			v21*
	foreach v of varlist `v21' {
		lab var 		`v' "Z-Score of GDD"	
	}
	
	loc	v22			v22*
	foreach v of varlist `v22' {
		lab var 		`v' "Maximum Daily Temperature"
	}
	
	loc	v23			v23*
	foreach v of varlist `v23' {
		lab var 		`v' "Temperature Bin 0-20"	
	}
	
	loc	v24			v24*
	foreach v of varlist `v24' {
		lab var 		`v' "Temperature Bin 20-40"	
	}
	
	loc	v25			v25*
	foreach v of varlist `v25' {
		lab var 		`v' "Temperature Bin 40-60"
	}
	
	loc	v26			v26*
	foreach v of varlist `v26' {
		lab var 		`v' "Temperature Bin 60-80"		
	}
	
	loc	v27			v27*
	foreach v of varlist `v27' {
		lab var 		`v' "Temperature Bin 80-100"	
	}
		
		
* save file
	qui: compress
	customsave 	, idvarname(pl_id) filename("nga_lp.dta") ///
		path("`export'") dofile(nga_append_built) user($user)

		
* **********************************************************************
* 4 - End matter
* **********************************************************************

* create household, country, and data identifiers
	egen			uid = seq()
	lab var			uid "unique id"
	
* order variables
	order		uid pl_id
	
* save file
	qui: compress
	customsave 	, idvarname(uid) filename("nga_complete.dta") ///
		path("`export'") dofile(nga_append_built) user($user)

* close the log
	log	close

/* END */

