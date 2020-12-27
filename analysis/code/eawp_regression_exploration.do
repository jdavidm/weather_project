* Project: WB Weather
* Created on: December 2020
* Created by: mcg
* Stata v.16.1

* does
	* compares various regression models using data from eafrica_aez_panel.dta

* assumes
	* cleaned, merged (weather), and appended (waves) data
	* customsave.ado
	* dropped obs from nigeria and niger, no arid aez, one extraction method

* TO DO:
	* not sure how to get the coefficients for the interaction vars posted - ask j & m 
	* i think a second postfile is necessary for the big regression results
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		source	= 	"$data/regression_data/eawp_sandbox"
	loc		results = 	"$data/regression_data/eawp_sandbox"
	loc		logout 	= 	"$data/regression_data/logs"

* open log	
	cap log close
	log 	using 		"`logout'/eawp_regressions", append

	
* **********************************************************************
* 1 - read in cross country panel
* **********************************************************************

* read in data file
	use			"`source'/eafrica_aez_panel.dta", clear


* **********************************************************************
* 2 - establish locals and postfile
* **********************************************************************

* create locals for total farm and just for maize
	loc 	inputscp 	lncp_lab lncp_frt cp_pst cp_hrb cp_irr
	loc		inputstf 	lntf_lab lntf_frt tf_pst tf_hrb tf_irr
	loc		weather 	v*
/*
* create file to post results to
	tempname 	ea_aez_reg_results
	postfile 	`ea_aez_reg_results' aez str3 sat str2 depvar str4 ///
					regname str3 varname betarain serain adjustedr loglike dfr ///
					betatwsh betatwhu betatcsa betatcsh betatchu ///
					using "`results'/ea_aez_reg_results.dta", replace


* **********************************************************************
* 3 - regressions on weather data by aez - no interactions
* **********************************************************************					
					
* define loop through levels of the data type variable	
levelsof 	aez	, local(levels)
foreach l of local levels {
    
	* set panel id so it varies by dtype
		xtset		hhid
		
	* weather metrics			
		foreach 	v of varlist `weather' { 
		    
		* define locals for naming conventions
			loc 	sat = 	substr("`v'", 5, 3)
			loc 	varn = 	substr("`v'", 1, 3)
			
		* 2.1: Value of Harvest
		
		* weather
			reg 		lntf_yld `v' if aez == `l', vce(cluster hhid)
			post 		`ea_aez_reg_results' (`l') ("`sat'") ("tf") ("reg1") ///
						("`varn'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') ///
						(`=e(ll)') (`=e(df_r)') (.) (.) (.) (.) (.)

		* weather and fe	
			xtreg 		lntf_yld `v' i.year i.country if aez == `l', fe vce(cluster hhid)
			post 		`ea_aez_reg_results' (`l') ("`sat'") ("tf") ("reg2") ///
						("`varn'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') ///
						(`=e(ll)') (`=e(df_r)') (.) (.) (.) (.) (.)

		* weather and inputs and fe
			xtreg 		lntf_yld `v' `inputstf' i.year i. country if aez == `l', fe vce(cluster hhid)
			post 		`ea_aez_reg_results' (`l') ("`sat'") ("tf") ("reg3") ///
						("`varn'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') ///
						(`=e(ll)') (`=e(df_r)') (.) (.) (.) (.) (.)

		
		* 2.2: Quantity of Maize
		
		* weather
			reg 		lncp_yld `v' if aez == `l', vce(cluster hhid)
			post 		`ea_aez_reg_results' (`l') ("`sat'") ("cp") ("reg1") ///
						("`varn'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') ///
						(`=e(ll)') (`=e(df_r)') (.) (.) (.) (.) (.)

		* weather and fe	
			xtreg 		lncp_yld `v' i.year i.country if aez == `l', fe vce(cluster hhid)
			post 		`ea_aez_reg_results' (`l') ("`sat'") ("cp") ("reg2") ///
						("`varn'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') ///
						(`=e(ll)') (`=e(df_r)') (.) (.) (.) (.) (.)

		* weather and inputs and fe
			xtreg 		lncp_yld `v' `inputscp' i.year i.country if aez == `l', fe vce(cluster hhid)
			post 		`ea_aez_reg_results' (`l') ("`sat'") ("cp") ("reg3") ///
						("`varn'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') ///
						(`=e(ll)') (`=e(df_r)') (.) (.) (.) (.) (.)
						
		}
		}
		

* **********************************************************************
* 4 - regressions on weather data by - aez dummies and interactions
* **********************************************************************

* weather metrics			
	foreach 	v of varlist `weather' { 
		
	* set panel id so it varies by dtype
		xtset		hhid
	    
	* define locals for naming conventions
		loc 	sat = 	substr("`v'", 5, 3)
		loc 	varn = 	substr("`v'", 1, 3)
		
	* big regression - value of harvest
		xtreg			lntf_yld c.`v'##i.aez `inputstf' i.year, fe vce(cluster hhid)
		post 			`ea_aez_reg_results' (0) ("`sat'") ("tf") ("reg4") ///
						("`varn'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') ///
						(`=e(ll)') (`=e(df_r)') (.) (.) (.) (.) (.)
		
	* big regression - quantity of maize
		xtreg			lncp_yld c.`v'##i.aez `inputscp' i.year, fe vce(cluster hhid)
		post 			`ea_aez_reg_results' (0) ("`sat'") ("cp") ("reg4") ///
						("`varn'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') ///
						(`=e(ll)') (`=e(df_r)') (.) (.) (.) (.) (.)
						
	** countries were being dropped due to colinearity so I took them out of the specs for now					
	}

		
* **********************************************************************
* 5 - data file labeling and arranging
* **********************************************************************		
		
* close the post file and open the data file
	postclose	`ea_aez_reg_results' 
	use 		"`results'/ea_aez_reg_results.dta", clear			// also reference file location possibly

* drop the cross section FE results
	drop if		loglike == .
	
* create aez type variable
	lab def		aez 312 "Tropic-warm/semiarid" ///
					313 "Tropic-warm/subhumid" ///
					314 "Tropic-warm/humid" ///
					322 "Tropic-cool/semiarid" ///
					323 "Tropic-cool/subhumid" ///
					324 "Tropic-cool/humid" ///
					0 	"Full dataset"
	lab val		aez aez
	lab var		aez "Agro-economic Zone"
	
* create data type variables
*	lab define 	dtype 0 "cx" 1 "lp" 2 "sp"
*	label val 	data dtype

* create variables for statistical testing
	gen 		tstat = betarain/serain
	lab var		tstat "t-statistic"
	gen 		pval = 2*ttail(dfr,abs(tstat))
	lab var		pval "p-value"
	gen 		ci_lo =  betarain - invttail(dfr,0.025)*serain
	lab var		ci_lo "Lower confidence interval"
	gen 		ci_up =  betarain + invttail(dfr,0.025)*serain
	lab var		ci_up "Upper confidence interval"

* label variables
	rename		betarain beta
	lab var		beta "Coefficient"
	rename		serain stdrd_err
	lab var		stdrd_err "Standard error"
	lab var		adjustedr "Adjusted R^2"
	lab var		loglike "Log likelihood"
	lab var		dfr "Degrees of freedom"

* create unique id variable
	egen 		reg_id = group(aez sat depvar regname varname)
	lab var 	reg_id "unique regression id"
	
* create variable to record the name of the rainfall variable
	sort		varname
	gen 		aux_var = 1 if varname == "v01"
	replace 	aux_var = 2 if varname == "v02"
	replace 	aux_var = 3 if varname == "v03"
	replace 	aux_var = 4 if varname == "v04"
	replace 	aux_var = 5 if varname == "v05"
	replace 	aux_var = 6 if varname == "v06"
	replace 	aux_var = 7 if varname == "v07"
	replace 	aux_var = 8 if varname == "v08"
	replace 	aux_var = 9 if varname == "v09"
	replace 	aux_var = 10 if varname == "v10"
	replace 	aux_var = 11 if varname == "v11"
	replace 	aux_var = 12 if varname == "v12"
	replace 	aux_var = 13 if varname == "v13"
	replace 	aux_var = 14 if varname == "v14"
	replace 	aux_var = 15 if varname == "v15"
	replace 	aux_var = 16 if varname == "v16"
	replace 	aux_var = 17 if varname == "v17"
	replace 	aux_var = 18 if varname == "v18"
	replace 	aux_var = 19 if varname == "v19"
	replace 	aux_var = 20 if varname == "v20"
	replace 	aux_var = 21 if varname == "v21"
	replace 	aux_var = 22 if varname == "v22"

* order and label the varaiable
	order 		aux_var, after(varname)
	lab def		varname 	1 "Mean Daily Rainfall" ///
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
							22 "Maximum Daily Temperature" 
	lab val		aux_var varname
	lab var		aux_var "Variable name"
	drop 		varname
	rename 		aux_var varname
	drop		if varname == .
	
* create variable to record the name of the satellite
	sort 		sat
	egen 		aux_sat = group(sat)

* order and label the varaiable
	order 		aux_sat, after(sat)
	lab def		sat 	1 "Rainfall 1" ///
						2 "Rainfall 2" ///
						3 "Rainfall 3" ///
						4 "Rainfall 4" ///
						5 "Rainfall 5" ///
						6 "Rainfall 6" ///
						7 "Temperature 1" ///
						8 "Temperature 2" ///
						9 "Temperature 3" 
	lab val		aux_sat sat	
	lab var		aux_sat "Satellite source"
	drop 		sat
	rename 		aux_sat sat

* create variable to record the dependent variable
	sort 		depvar
	egen 		aux_dep = group(depvar)

* order and label the varaiable
	order 		aux_dep, after(depvar)
	lab def		depvar 	1 "Quantity" ///
						2 "Value"
	lab val		aux_dep depvar
	lab var		aux_dep "Dependent variable"
	drop 		depvar
	rename 		aux_dep depvar
	
* create variable to record the regressions specification
	sort 		regname
	gen 		aux_reg = 1 if regname == "reg1"
	replace 	aux_reg = 2 if regname == "reg2"
	replace 	aux_reg = 3 if regname == "reg3"
	replace 	aux_reg = 4 if regname == "reg4"
	replace 	aux_reg = 5 if regname == "reg5"

* order and label the varaiable
	order 		aux_reg, after(regname)
	lab def		regname 	1 "Weather Only" ///
							2 "Weather + FE" ///
							3 "Weather + FE + Inputs" ///
							4 "Weather + AEZ + Interaction"
	lab val		aux_reg regname
	lab var		aux_reg "Regression Name"
	drop 		regname
	rename 		aux_reg regname

order	reg_id aez depvar sat varname regname
sort 	aez depvar sat varname regname
	
* save complete results
	loc		results = 	"$data/results_data"
	
	compress
	
	customsave 	, idvarname(reg_id) filename("ea_aez_complete_results.dta") ///
		path("`results'") dofile(regression) user($user)

* close the log
	log	close
*/


* **********************************************************************
* Alternate approach
* **********************************************************************

* original linear regression (weather + inputs + fe) by aez	(maize)
/*
* define loop through levels of the data type variable	
	levelsof 	aez	, local(levels)
	foreach l of local levels {

	* set panel id so it varies by dtype
		xtset		hhid
	
	* per metric		
		foreach 	v of varlist `weather' { 

		* weather and inputs and fe
			xtreg 		lncp_yld `v' `inputscp' i.year i.country if aez == `l', fe vce(cluster hhid)
			** omitting lots of whole countries due to colinearity
	}
	}
	
* new approach with full dataset (maize)
	
* per metric		
	foreach 	v of varlist `weather' { 
	
	* big regression - quantity of maize
		xtset		hhid
		xtreg			lncp_yld c.`v'##i.aez `inputscp' i.year, fe vce(cluster hhid)
		}
	*/
	
eststo clear
	
* no level terms
	foreach 	v of varlist `weather' { 
	
	* big regression - quantity of maize
		xtset		hhid
		eststo:		xtreg lncp_yld c.`v'#i.aez `inputscp' i.year, fe vce(cluster hhid)
		}
	
	esttab 		est1 est2 est3 est4 est5 est6 est7 est8 est9 est10 est11 est12 est13 est14 ///
				using "$data/regression_data/eawp_sandbox/rf2.csv", replace ///
				se title(Rainfall 2) nonumbers ///
				mtitles("Mean Daily Rainfall" "Median Daily Rainfall" ///
				"Variance of Daily Rainfall" "Skew of Daily Rainfall" ///
				"Total Rainfall" "Deviation in Total Rainfall" ///
				"Z-Score of Total Rainfall" "Rainy Days" "Deviation in Rainy Days" ///
				"No Rain Days" "Deviation in No Rain Days" "% Rainy Days" ///
				"Deviation in % Rainy Days" "Longest Dry Spell") ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2008.year 2009.year 2010.year 2011.year 2012.year ///
				2013.year 2015.year) ///
				label

	esttab 		est15 est16 est17 est18 est19 est20 est21 est22 est23 est24 est25 est26 est27 est28 ///
				using "$data/regression_data/eawp_sandbox/rf3.csv", replace ///
				se title(Rainfall 3) nonumbers ///
				mtitles("Mean Daily Rainfall" "Median Daily Rainfall" ///
				"Variance of Daily Rainfall" "Skew of Daily Rainfall" ///
				"Total Rainfall" "Deviation in Total Rainfall" ///
				"Z-Score of Total Rainfall" "Rainy Days" "Deviation in Rainy Days" ///
				"No Rain Days" "Deviation in No Rain Days" "% Rainy Days" ///
				"Deviation in % Rainy Days" "Longest Dry Spell") ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2008.year 2009.year 2010.year 2011.year 2012.year ///
				2013.year 2015.year) ///
				label
				
	esttab 		est29 est30 est31 est32 est33 est34 est35 est36 est37 est38 est39 est40 est41 est42 ///
				using "$data/regression_data/eawp_sandbox/rf1.csv", replace ///
				se title(Rainfall 1) nonumbers ///
				mtitles("Mean Daily Rainfall" "Median Daily Rainfall" ///
				"Variance of Daily Rainfall" "Skew of Daily Rainfall" ///
				"Total Rainfall" "Deviation in Total Rainfall" ///
				"Z-Score of Total Rainfall" "Rainy Days" "Deviation in Rainy Days" ///
				"No Rain Days" "Deviation in No Rain Days" "% Rainy Days" ///
				"Deviation in % Rainy Days" "Longest Dry Spell") ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2008.year 2009.year 2010.year 2011.year 2012.year ///
				2013.year 2015.year) ///
				label
				
	esttab 		est43 est44 est45 est46 est47 est48 est49 est50 est51 est52 est53 est54 est55 est56 ///
				using "$data/regression_data/eawp_sandbox/rf5.csv", replace ///
				se title(Rainfall 5) nonumbers ///
				mtitles("Mean Daily Rainfall" "Median Daily Rainfall" ///
				"Variance of Daily Rainfall" "Skew of Daily Rainfall" ///
				"Total Rainfall" "Deviation in Total Rainfall" ///
				"Z-Score of Total Rainfall" "Rainy Days" "Deviation in Rainy Days" ///
				"No Rain Days" "Deviation in No Rain Days" "% Rainy Days" ///
				"Deviation in % Rainy Days" "Longest Dry Spell") ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2008.year 2009.year 2010.year 2011.year 2012.year ///
				2013.year 2015.year) ///
				label
				
	esttab 		est57 est58 est59 est60 est61 est62 est63 est64 est65 est66 est67 est68 est69 est70 ///
				using "$data/regression_data/eawp_sandbox/rf4.csv", replace ///
				se title(Rainfall 4) nonumbers ///
				mtitles("Mean Daily Rainfall" "Median Daily Rainfall" ///
				"Variance of Daily Rainfall" "Skew of Daily Rainfall" ///
				"Total Rainfall" "Deviation in Total Rainfall" ///
				"Z-Score of Total Rainfall" "Rainy Days" "Deviation in Rainy Days" ///
				"No Rain Days" "Deviation in No Rain Days" "% Rainy Days" ///
				"Deviation in % Rainy Days" "Longest Dry Spell") ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2008.year 2009.year 2010.year 2011.year 2012.year ///
				2013.year 2015.year) ///
				label
				
	esttab 		est71 est72 est73 est74 est75 est76 est77 est78 est79 est80 est81 est82 est83 est84 ///
				using "$data/regression_data/eawp_sandbox/rf6.csv", replace ///
				se title(Rainfall 6) nonumbers ///
				mtitles("Mean Daily Rainfall" "Median Daily Rainfall" ///
				"Variance of Daily Rainfall" "Skew of Daily Rainfall" ///
				"Total Rainfall" "Deviation in Total Rainfall" ///
				"Z-Score of Total Rainfall" "Rainy Days" "Deviation in Rainy Days" ///
				"No Rain Days" "Deviation in No Rain Days" "% Rainy Days" ///
				"Deviation in % Rainy Days" "Longest Dry Spell") ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2008.year 2009.year 2010.year 2011.year 2012.year ///
				2013.year 2015.year) ///
				label
				
	esttab 		est85 est86 est87 est88 est89 est90 est91 est92 ///
				using "$data/regression_data/eawp_sandbox/tp3.csv", replace ///
				se title(Temperature 3) nonumbers ///
				mtitles("Mean Daily Temperature" "Median Daily Temperature" ///
				"Variance of Daily Temperature" "Skew of Daily Temperature" ///
				"Growing Degree Days (GDD)" "Deviation in GDD" ///
				"Z-Score of GDD" "Maximum Daily Temperature" ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2008.year 2009.year 2010.year 2011.year 2012.year ///
				2013.year 2015.year) ///
				label
				
	esttab 		est93 est94 est95 est96 est97 est98 est99 est100 ///
				using "$data/regression_data/eawp_sandbox/tp1.csv", replace ///
				se title(Temperature 1) nonumbers ///
				mtitles("Mean Daily Temperature" "Median Daily Temperature" ///
				"Variance of Daily Temperature" "Skew of Daily Temperature" ///
				"Growing Degree Days (GDD)" "Deviation in GDD" ///
				"Z-Score of GDD" "Maximum Daily Temperature" ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2008.year 2009.year 2010.year 2011.year 2012.year ///
				2013.year 2015.year) ///
				label
				
	esttab 		est101 est102 est103 est104 est105 est106 est107 est108 ///
				using "$data/regression_data/eawp_sandbox/tp2.csv", replace ///
				se title(Temperature 2) nonumbers ///
				mtitles("Mean Daily Temperature" "Median Daily Temperature" ///
				"Variance of Daily Temperature" "Skew of Daily Temperature" ///
				"Growing Degree Days (GDD)" "Deviation in GDD" ///
				"Z-Score of GDD" "Maximum Daily Temperature" ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2008.year 2009.year 2010.year 2011.year 2012.year ///
				2013.year 2015.year) ///
				label
				
* build table for sat 1
*	esttab 	reg_v01_rf2_x1 reg_v02_rf2_x1 reg_v03_rf2_x1 reg_v04_rf2_x1 ///
*			reg_v05_rf2_x1 reg_v06_rf2_x1 reg_v07_rf2_x1 reg_v08_rf2_x1 ///
*			reg_v09_rf2_x1 reg_v10_rf2_x1 reg_v11_rf2_x1 reg_v12_rf2_x1 ///
*			reg_v13_rf2_x1 reg_v14_rf2_x1 ///
*				using "$data/regression_data/eawp_sandbox/rf2.tex", replace
	
* close the log
	log	close
	
/* END */