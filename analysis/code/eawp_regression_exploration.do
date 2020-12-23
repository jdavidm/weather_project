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
	* lots
	
	
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
* 2 - regressions on weather data
* **********************************************************************

* create locals for total farm and just for maize
	loc 	inputscp 	lncp_lab lncp_frt cp_pst cp_hrb cp_irr
	loc		inputstf 	lntf_lab lntf_frt tf_pst tf_hrb tf_irr
	loc		weather 	v*

* create file to post results to
	tempname 	ea_aez_reg_results
	postfile 	`ea_aez_reg_results' aez str4 sat str2 depvar str4 ///
					regname str3 varname betarain serain adjustedr loglike dfr ///
					using "`results'/ea_aez_reg_results.dta", replace
					
* define loop through levels of the data type variable	
levelsof 	aez	, local(levels)
foreach l of local levels {
    
	* set panel id so it varies by dtype
		xtset		hhid
		
	* rainfall			
		foreach 	v of varlist `weather' { 
		    
		* define locals for naming conventions
			loc 	sat = 	substr("`v'", 5, 3)
			loc 	varn = 	substr("`v'", 1, 3)
			
		* 2.1: Value of Harvest
		
		* weather
			reg 		lntf_yld `v' if aez == `l', vce(cluster hhid)
			post 		`ea_aez_reg_results' (`l') ("`sat'") ("tf") ("reg1") ///
						("`varn'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') ///
						(`=e(ll)') (`=e(df_r)')

		* weather and fe	
			xtreg 		lntf_yld `v' i.year if aez == `l', fe vce(cluster hhid)
			post 		`ea_aez_reg_results' (`l') ("`sat'") ("tf") ("reg2") ///
						("`varn'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') ///
						(`=e(ll)') (`=e(df_r)')

		* weather and inputs and fe
			xtreg 		lntf_yld `v' `inputstf' i.year if aez == `l', fe vce(cluster hhid)
			post 		`ea_aez_reg_results' (`l') ("`sat'") ("tf") ("reg3") ///
						("`varn'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') ///
						(`=e(ll)') (`=e(df_r)')
			
		* weather and squared weather
			reg 		lntf_yld c.`v'##c.`v' if aez == `l', vce(cluster hhid)
			post 		`ea_aez_reg_results' (`l') ("`sat'") ("tf") ("reg4") ///
						("`varn'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') ///
						(`=e(ll)') (`=e(df_r)')
		
		* weather and squared weather and fe
			xtreg 		lntf_yld c.`v'##c.`v' i.year if aez == `l', fe vce(cluster hhid)
			post 		`ea_aez_reg_results' (`l') ("`sat'") ("tf") ("reg5") ///
						("`varn'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') ///
						(`=e(ll)') (`=e(df_r)')
		
		* weather and squared weather and inputs and fe
			xtreg 		lntf_yld c.`v'##c.`v' `inputstf' i.year if aez == `l', fe vce(cluster hhid)
			post 		`ea_aez_reg_results' (`l') ("`sat'") ("tf") ("reg6") ///
						("`varn'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') ///
						(`=e(ll)') (`=e(df_r)')
						
		}
		}