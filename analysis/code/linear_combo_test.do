* Project: WB Weather
* Created on: September 2020
* Created by: alj
* Last updated: 26 October 2020 
* Last updated by: alj 
* Stata v.16.1

* does
	* NOTE IT TAKES 2.5 HOURS TO RUN ALL REGRESSIONS
	* loads multi country data set
	* runs rainfall and temperature regressions
	* outputs results file for analysis

* assumes
	* cleaned, merged (weather), and appended (waves) data
	* customsave.ado

* TO DO:
	* everything 
	* complete

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		source	= 	"$data/regression_data"
	loc		results = 	"$data/results_data"
	loc		logout 	= 	"$data/regression_data/logs"

* open log	
	cap log close
	log 	using 		"`logout'/regressions_lc-test", append

	
* **********************************************************************
* 1 - read in cross country panel
* **********************************************************************

* read in data file
	use			"`source'/lsms_panel.dta", clear

	
* **********************************************************************
* 2 - regressions on weather data
* **********************************************************************


* create locals for total farm and just for maize
	loc		rainmean 	v01* v03* v04* v02* v05* v07*
	loc		tempmean 	v15* v17* v18* v16* v19* v21*

* create file to post results to
	tempname 	reg_results_lc_test
	postfile 	`reg_results_lc_test' country str3 varr str3 satr str2 extr ///
					str3 vart str3 satt str2 extt str2 depvar str4 regname ///
					betarain serain betatemp setemp adjustedr loglike dfr ///
					using "`results'/reg_results_lc_test.dta", replace
					
* define loop through levels of the data type variable	
	levelsof 	country		, local(levels)
	foreach		l of 		local levels {
 
	* set panel id so it varies by dtype
		xtset		hhid
					
	* define loop through rainfall local
		foreach 	r of	varlist `rainmean' { 
	
		* define locals for rainfall naming conventions
			loc 	varr = 	substr("`r'", 1, 3)
			loc 	satr = 	substr("`r'", 5, 3)
			loc 	extr = 	substr("`r'", 9, 2)
			
		* define loop through temperature local
			foreach 	t of	varlist `tempmean' {
		    
			* define locals for temperature naming conventions
				loc 	vart = 	substr("`t'", 1, 3)
				loc 	satt = 	substr("`t'", 5, 3)
				loc 	extt = 	substr("`t'", 9, 2)

			* define pairs to compare for linear regressions
				if 	`"`varr'"' == "v01"	& `"`vart'"' == "v15" | ///
					`"`varr'"' == "v02" & `"`vart'"' == "v16" | ///
					`"`varr'"' == "v05" & `"`vart'"' == "v19" | ///
					`"`varr'"' == "v07" & `"`vart'"' == "v21" {
	
				* define pairs of extrations to compare
					if `"`extr'"' == `"`extt'"' {
				    
				    * 2.1: Value of Harvest
		
					* weather
						reg 		lntf_yld `r' `t' if country == `l', vce(cluster hhid)
						post 		`reg_results_lc_test' (`l') ("`varr'") ("`satr'") ("`extr'") ///
										("`vart'") ("`satt'") ("`extt'") ("tf") ("reg1") ///
										(`=_b[`r']') (`=_se[`r']') (`=_b[`t']') (`=_se[`t']') ///
										(`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
									
					* weather and fe	
						xtreg 		lntf_yld `r' `t' i.year if country == `l', fe vce(cluster hhid)
						post 		`reg_results_lc_test' (`l') ("`varr'") ("`satr'") ("`extr'") ///
										("`vart'") ("`satt'") ("`extt'") ("tf") ("reg2") ///
										(`=_b[`r']') (`=_se[`r']') (`=_b[`t']') (`=_se[`t']') ///
										(`=e(r2_a)') (`=e(ll)') (`=e(df_r)')

					* weather and inputs and fe
						xtreg 		lntf_yld `r' `t' `inputsrs' i.year if country == `l', fe vce(cluster hhid)
						post 		`reg_results_lc_test' (`l') ("`varr'") ("`satr'") ("`extr'") ///
										("`vart'") ("`satt'") ("`extt'") ("tf") ("reg3") ///
										(`=_b[`r']') (`=_se[`r']') (`=_b[`t']') (`=_se[`t']') ///
										(`=e(r2_a)') (`=e(ll)') (`=e(df_r)')

					* 2.2: Quantity of Maize
		
					* weather
						reg 		lncp_yld `r' `t' if country == `l', vce(cluster hhid)
						post 		`reg_results_lc_test' (`l') ("`varr'") ("`satr'") ("`extr'") ///
										("`vart'") ("`satt'") ("`extt'") ("cp") ("reg1") ///
										(`=_b[`r']') (`=_se[`r']') (`=_b[`t']') (`=_se[`t']') ///
										(`=e(r2_a)') (`=e(ll)') (`=e(df_r)')

					* weather and fe	
						xtreg 		lncp_yld `r' `t' i.year if country == `l', fe vce(cluster hhid)
						post 		`reg_results_lc_test' (`l') ("`varr'") ("`satr'") ("`extr'") ///
										("`vart'") ("`satt'") ("`extt'") ("cp") ("reg2") ///
										(`=_b[`r']') (`=_se[`r']') (`=_b[`t']') (`=_se[`t']') ///
										(`=e(r2_a)') (`=e(ll)') (`=e(df_r)')

					* weather and inputs and fe
						xtreg 		lncp_yld `r' `t' `inputsrs' i.year if country == `l', fe vce(cluster hhid)
						post 		`reg_results_lc_test' (`l') ("`varr'") ("`satr'") ("`extr'") ///
										("`vart'") ("`satt'") ("`extt'") ("cp") ("reg3") ///
										(`=_b[`r']') (`=_se[`r']') (`=_b[`t']') (`=_se[`t']') ///
										(`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
				}
			}
			* define pairs to compare for quadratic regressions
				if 	`"`varr'"' == "v01" & `"`vart'"' == "v15" | ///
					`"`varr'"' == "v05" & `"`vart'"' == "v19" {
	
				* define pairs of extrations to compare
					if `"`extr'"' == `"`extt'"' {
				    
				    * 2.1: Value of Harvest
					
					* weather and squared weather
						reg 		lntf_yld c.`r'##c.`r' c.`t'##c.`t' if country == `l', vce(cluster hhid)
						post 		`reg_results_lc_test' (`l') ("`varr'") ("`satr'") ("`extr'") ///
										("`vart'") ("`satt'") ("`extt'") ("tf") ("reg4") ///
										(`=_b[`r']') (`=_se[`r']') (`=_b[`t']') (`=_se[`t']') ///
										(`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
		
					* weather and squared weather and fe
						xtreg 		lntf_yld c.`r'##c.`r' c.`t'##c.`t' i.year if country == `l', fe vce(cluster hhid)
						post 		`reg_results_lc_test' (`l') ("`varr'") ("`satr'") ("`extr'") ///
										("`vart'") ("`satt'") ("`extt'") ("tf") ("reg5") ///
										(`=_b[`r']') (`=_se[`r']') (`=_b[`t']') (`=_se[`t']') ///
										(`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
		
					* weather and squared weather and inputs and fe
						xtreg 		lntf_yld c.`r'##c.`r' c.`t'##c.`t' `inputsrs' i.year if country == `l', fe vce(cluster hhid)
						post 		`reg_results_lc_test' (`l') ("`varr'") ("`satr'") ("`extr'") ///
										("`vart'") ("`satt'") ("`extt'") ("tf") ("reg6") ///
										(`=_b[`r']') (`=_se[`r']') (`=_b[`t']') (`=_se[`t']') ///
										(`=e(r2_a)') (`=e(ll)') (`=e(df_r)')

					* 2.2: Quantity of Maize
			
					* weather and squared weather
						reg 		lncp_yld c.`r'##c.`r' c.`t'##c.`t' if country == `l', vce(cluster hhid)
						post 		`reg_results_lc_test' (`l') ("`varr'") ("`satr'") ("`extr'") ///
										("`vart'") ("`satt'") ("`extt'") ("cp") ("reg4") ///
										(`=_b[`r']') (`=_se[`r']') (`=_b[`t']') (`=_se[`t']') ///
										(`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
						
					* weather and squared weather and fe
						xtreg 		lncp_yld c.`r'##c.`r' c.`t'##c.`t' i.year if country == `l', fe vce(cluster hhid)
						post 		`reg_results_lc_test' (`l') ("`varr'") ("`satr'") ("`extr'") ///
										("`vart'") ("`satt'") ("`extt'") ("cp") ("reg5") ///
										(`=_b[`r']') (`=_se[`r']') (`=_b[`t']') (`=_se[`t']') ///
										(`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
		
					* weather and squared weather and inputs and fe
						xtreg 		lncp_yld c.`r'##c.`r' c.`t'##c.`t' `inputsrs' i.year if country == `l', fe vce(cluster hhid)
						post 		`reg_results_lc_test' (`l') ("`varr'") ("`satr'") ("`extr'") ///
										("`vart'") ("`satt'") ("`extt'") ("cp") ("reg6") ///
										(`=_b[`r']') (`=_se[`r']') (`=_b[`t']') (`=_se[`t']') ///
										(`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
				}
			}	
		}
	}
}

* close the post file and open the data file
	postclose	`reg_results_lc_test' 
	use 		"`results'/reg_results_lc_test", clear

* close the log
	log	close
