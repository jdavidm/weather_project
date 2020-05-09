* Project: WB Weather
* Created on: May 2020
* Created by: jdm
* Stata v.16

* does
	* loads all Malawi data
	* does final cleaning of data
	* runs rainfall and temperature regressions
	* outputs results file for analysis

* assumes
	* cleaned, merged (weather), and appended (waves) data
	* customsave.ado
	* winsor2.ado

* TO DO:
	* everything

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* set global user
	global	user		"jdmichler"

* define paths
	global		source	= 	"G:/My Drive/weather_project/regression_data/malawi"
	global		export 	= 	"G:/My Drive/weather_project/results_data/malawi/individual_results"
	global		results = 	"G:/My Drive/weather_project/results_data/malawi"
	global		logout 	= 	"G:/My Drive/weather_project/regression_data/logs"

* open log	
	log 	using 		"$logout/mwi_regressions", append

	
* **********************************************************************
* 1 - final cleaning of rainfall data
* **********************************************************************

* read in data file
	use			"$source/mwi_complete.dta", clear

* drop dry season values - we just focus on the rainy season (rs)
	drop		ds*
		
	* put the data id variables up front
		order 		case_id hhid data satellite extraction

	* create harvest variables for maize (others already created)
		gen 		rsmz_harvesthaimp = rsmz_harvestimp/rsmz_cultivatedarea
		lab var 	rsmz_harvesthaimp "Quantity of maize harvest per hectare (kg/ha)"
		order 		rsmz_harvesthaimp, after(rsmz_harvestimp)
	
	* create labor per hectare (others already created)
		gen 		rs_labordayshaimp = rs_labordaysimp/rs_cultivatedarea 
		lab var 	rs_labordayshaimp "Labor per hectare"
		order 		rs_labordayshaimp, after (rs_labordaysimp)

		gen 		rsmz_labordayshaimp = rsmz_labordaysimp/rsmz_cultivatedarea 
		lab var 	rs_labordayshaimp "Labor for maize per hectare"
		order 		rsmz_labordayshaimp, after (rsmz_labordaysimp)
	
	* create locals for sets of variables
		loc		output		rs_harvest_valuehaimp rsmz_harvesthaimp
		loc 	continputs 	rs_fert_inorgpct rs_labordayshaimp ///
							rsmz_fert_inorgpct rsmz_labordayshaimp
		loc		rainfall 	mean_season-dev_percent_raindays

	* winsorize data at 1% and 99% per pre-analysis plan
		winsor2 	`output' `continputs', replace

	* convert output variables to logs using invrse hyperbolic sine 
		foreach 		v of varlist `output' {
			qui: gen 		ln`v' = asinh(`v') 
			qui: lab var 	ln`v' "ln of `v'" 
		}

	* convert continuous input variables to logs using invrse hyperbolic sine 
		foreach 		v of varlist `continputs' {
			qui: gen 		ln`v' = asinh(`v') 
			qui: lab var 	ln`v' "ln of `v'" 
		}

	* create locals for total farm and just for maize
		loc 	inputsrs 	rs_irrigationany lnrs_fert_inorgpct ///
							lnrs_labordayshaimp rs_herb rs_pest
		loc		inputsrsmz 	rsmz_irrigationany lnrsmz_fert_inorgpct ///
							lnrsmz_labordayshaimp rsmz_herb rsmz_pest
	
	
* **********************************************************************
* 2 - regressions on rainfall data
* **********************************************************************

	* set panel as **cluster**
		xtset		cluster

	* create file to post results to
		tempname 	myresults
		postfile 	`myresults' str4 depvar str5 regname str25 varname ///
					betarain serain adjustedr loglike dfr ///
					using myresults.dta, replace

	* 2.1: Value of Harvest

	* rainfall			
		foreach 	v of varlist `rainfall' {
			qui: reg 	lnrs_harvest_valuehaimp `v'
			post 		`myresults' ("rs") ("reg1") ("`v'") (`=_b[`v']') ///
						(`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
	}
	* rainfall and fe			
		foreach 	v of varlist `rainfall' {
			qui: xtreg 	lnrs_harvest_valuehaimp `v' i.intyear, fe
			post 		`myresults' ("rs") ("reg2") ("`v'") (`=_b[`v']') ///
						(`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
	}
	* rainfall and inputs and fe 	
		foreach 	v of varlist `rainfall' {
			qui: xtreg 	lnrs_harvest_valuehaimp `v' `inputsrs' i.year, fe
			post 		`myresults' ("rs") ("reg3") ("`v'") (`=_b[`v']') ///
						(`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
	} 
	*-rainfall and squared rainfall
		foreach 	v of varlist `rainfall' {
			qui: reg 	lnrs_harvest_valuehaimp c.`v'##c.`v'
			post 		`myresults' ("rs") ("reg4") ("`v'") (`=_b[`v']') ///
						(`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
	}
	*-rainfall and squared rainfall and fe
		foreach 	v of varlist `rainfall' {
			qui: xtreg 	lnrs_harvest_valuehaimp c.`v'##c.`v' i.year, fe
			post 		`myresults' ("rs") ("reg5") ("`v'") (`=_b[`v']') ///
						(`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
	}
	*-rainfall and squared rainfall and inputs and fe
		foreach 	v of varlist `rainfall' {
			qui: xtreg 	lnrs_harvest_valuehaimp c.`v'##c.`v' `inputsrs' i.year, fe
			post 		`myresults' ("rs") ("reg6") ("`v'") (`=_b[`v']') ///
						(`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
	}
	*2.2: Quantity of Maize

	*-rainfall		
		foreach 	v of varlist `rainfall' {
			qui: reg 	lnrsmz_harvesthaimp `v' 
			post 		`myresults' ("rsmz") ("reg1") ("`v'") (`=_b[`v']') ///
						(`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
	}
	*-rainfall and fe
		foreach 	v of varlist `rainfall' {
			qui: xtreg 	lnrsmz_harvesthaimp `v' i.year, fe
			post 		`myresults' ("rsmz") ("reg2") ("`v'") (`=_b[`v']') ///
						(`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
	}
	*-rainfall and inputs and fe
		foreach 	v of varlist `rainfall' {
			qui: xtreg 	lnrsmz_harvesthaimp `v' `inputsrsmz' i.year, fe
			post 		`myresults' ("rsmz") ("reg3") ("`v'") (`=_b[`v']') ///
						(`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
	}
	*-rainfall and squared rainfall
		foreach 	v of varlist `rainfall' {
			qui: reg 	lnrsmz_harvesthaimp c.`v'##c.`v'
			post 		`myresults' ("rsmz") ("reg4") ("`v'") (`=_b[`v']') ///
						(`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
	}
	*-rainfall and squared rainfall and fe
		foreach 	v of varlist `rainfall' {
			qui: xtreg 	lnrsmz_harvesthaimp c.`v'##c.`v' i.year, fe
			post 		`myresults' ("rsmz") ("reg5") ("`v'") (`=_b[`v']') ///
						(`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
	}
	*-rainfall and squared rainfall and inputs and fe
		foreach 	v of varlist `rainfall' {
			qui: xtreg 	lnrsmz_harvesthaimp c.`v'##c.`v' `inputsrsmz' i.year, fe
			post 		`myresults' ("rsmz") ("reg6") ("`v'") (`=_b[`v']') ///
						(`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
	} 

	* close the results file
		postclose	`myresults' 
		use 		myresults, clear 

	* define locals for naming conventions
		loc 	dat = 	substr("`file'", 1, 2)
		loc 	ext = 	substr("`file'", 4, 2)
		loc 	sat = 	substr("`file'", 7, 3)
		
	* create variables to record extraction method and satellite
		gen 		str2 ext = "`ext'"
		gen 		str3 sat = "`sat'"
	
	* create variables for statistical testing
		gen 		tstat = betarain/serain
		gen 		pval = 2*ttail(dfr,abs(tstat))
		gen 		ci_lo =  betarain - invttail(dfr,0.025)*serain
		gen 		ci_up =  betarain + invttail(dfr,0.025)*serain

	* create unique id variable
		egen 		regid = group(depvar regname varname)
		lab var 	regid "unique regression id"
		
	* save individual results files
		customsave 	, idvarname(regid) filename("results_`dat'_`ext'_`sat'.dta") ///
			path("`export'") dofile(cx_regression) user($user)		
}

	
* **********************************************************************
* 3 - append individual rainfall results into a single results file
* **********************************************************************
	
	clear		all

* save an empty file to hold the results
	save 		"`results'/appended_cx_rf.dta", emptyok replace

* define local that contains all individual results
	loc 	fileList : 	dir "`export'" files "results_cx*rf*"

* loop through files defined in above local
	foreach 	file in `fileList'{
		append 		using "`export'/`file'" 
	}

* order the variables
	order 		sat ext

* create variable to record the name of the rainfall variable
	sort		varname
	gen 		aux_var = 1 if varname == "mean_season"
	replace 	aux_var = 2 if varname == "median_season"
	replace 	aux_var = 3 if varname == "sd_season"
	replace 	aux_var = 4 if varname == "skew_season"
	replace 	aux_var = 5 if varname == "total_season"
	replace 	aux_var = 6 if varname == "dev_total_season"
	replace 	aux_var = 7 if varname == "z_total_season"
	replace 	aux_var = 8 if varname == "raindays"
	replace 	aux_var = 9 if varname == "dev_raindays"
	replace 	aux_var = 10 if varname == "norain"
	replace 	aux_var = 11 if varname == "dev_norain"
	replace 	aux_var = 12 if varname == "percent_raindays"
	replace 	aux_var = 13 if varname == "dev_percent_raindays"
	replace 	aux_var = 14 if varname == "dry"

* order and label the varaiable
	order 		aux_var, after(varname)
	lab 		define varname 	1 "Mean Daily Rainfall" ///
								2 "Median Daily Rainfall" ///
								3 "Variance of Daily Rainfall" ///
								4 "Skew of Daily Rainfall" ///
								5 "Total Rainfall" ///
								6 "Deviation in Total Rainfall" ///
								7 "Z-Score of Total Rainfall" ///
								8 "Rainy Days" ///
								9 "Deviation in Rainy Days" ///
								10 "No Rain Days" ///
								11 "Deviation in No Rain Days" ///
								12 "% Rainy Days" ///
								13 "Deviation in % Rainy Days" ///
								14 "Longest Dry Spell" ///
								15 "Mean Daily Temperature" ///
								16 "Median Daily Temperature" ///
								17 "Variance of Daily Temperature" ///
								18 "Skew of Daily Temperature" ///
								19 "Growing Degree Days (GDD)" ///
								20 "Deviation in GDD" ///
								21 "Z-Score of GDD" ///
								22 "Maximum Daily Temperature" ///
								23 "Mean of Rain & Temp" ///
								24 "Mean + Variance of  Rain & Temp" ///
								25 "Mean + Variance + Skew of Rain & Temp" ///
								26 "Median Rain & Temp" ///
								27 "Total Rainfall & GDD" ///
								28 "Z-Scores of Total Rainfall & GDD" 
	lab 		values aux_var varname
	drop 		varname
	rename 		aux_var varname

* create variable to record the name of the satellite
	sort 		sat
	egen 		aux_sat = group(sat)

* order and label the varaiable
	order 		aux_sat, after(sat)
	lab 		define sat 	1 "Rainfall 1" ///
							2 "Rainfall 2" ///
							3 "Rainfall 3" ///
							4 "Rainfall 4" ///
							5 "Rainfall 5" ///
							6 "Rainfall 6" ///
							7 "Temperature 1" ///
							8 "Temperature 2" ///
							9 "Temperature 3" 
	lab 		values aux_sat sat
	drop 		sat
	rename 		aux_sat sat

* create variable to record the extraction method
	sort 		ext
	egen 		aux_ext = group(ext)

* order and label the varaiable
	order 		aux_ext, after(ext)
	lab 		define ext 	1 "Extraction 1" ///
							2 "Extraction 2" ///
							3 "Extraction 3" ///
							4 "Extraction 4" ///
							5 "Extraction 5" ///
							6 "Extraction 6" ///
							7 "Extraction 7" ///
							8 "Extraction 8" ///
							9 "Extraction 9" ///
							10 "Extraction 10"
	lab 		values aux_ext ext
	drop 		ext
	rename 		aux_ext ext

* create variable to record the dependent variable
	sort 		depvar
	egen 		aux_dep = group(depvar)

* order and label the varaiable
	order 		aux_dep, after(depvar)
	lab 		define depvar 	1 "Value" ///
								2 "Quantity"
	lab 		values aux_dep depvar
	drop 		depvar
	rename 		aux_dep depvar
	
* create variable to record the regressions specification
	sort 		regname
	gen 		aux_reg = 1 if regname == "reg1"
	replace 	aux_reg = 2 if regname == "reg2"
	replace 	aux_reg = 3 if regname == "reg3"
	replace 	aux_reg = 4 if regname == "reg4"
	replace 	aux_reg = 5 if regname == "reg5"
	replace 	aux_reg = 6 if regname == "reg6"

* order and label the varaiable
	order 		aux_reg, after(regname)
	lab 		define regname 	1 "Weather Only" ///
								2 "Weather + FE" ///
								3 "Weather + FE + Inputs" ///
								4 "Weather + Weather^2" ////
								5 "Weather + Weather^2 + FE" ///
								6 "Weather + Weather^2 + FE + Inputs" ///
								7 "Weather + Year FE" ///
								8 "Weather + Year FE + Inputs" ///
								9 "Weather + Weather^2 + Year FE" ///
								10 "Weather + Weather^2 + Year FE + Inputs"
	lab 		values aux_reg regname
	drop 		regname
	rename 		aux_reg regname


* drop old and create unique id variable
	egen 		regid = group(depvar regname varname sat ext)
	lab var 	regid "unique regression id"
	
* save complete results
	customsave 	, idvarname(regid) filename("appended_cx_rf.dta") ///
		path("`results'") dofile(cx_regression) user($user)

* close the log
	log	close

/* END */