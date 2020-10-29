* Project: WB Weather
* Created on: October 2020
* Created by: jdm
* Last updated: 28 October 2020 
* Last updated by: jdm 
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
	cap 	log 		close
	log 	using 		"`logout'/regressions_mc", append

	
* **********************************************************************
* 1 - read in cross country panel
* **********************************************************************

* read in data file
	use			"`source'/lsms_panel.dta", clear

	
* **********************************************************************
* 2 - regressions on mean and variance of rainfall
* **********************************************************************

* create locals for total farm and just for maize
	loc		rainmean 	v01*
	loc		rainvar		v03* 
	loc		tempmean 	v15*
	loc		tempvar 	v17*

* create file to post results to
	tempname 	reg_results_mv
	postfile 	`reg_results_mv' country str3 varrm str3 satrm str2 extrm ///
					str3 varrv str3 satrv str2 extrv ///
					str3 vartm str3 sattm str2 exttm ///
					str3 vartv str3 sattv str2 exttv ///
					str2 depvar str4 regname betarm serm ///					
					betarv serv betatm setm betatv setv ///
					adjustedr loglike dfr ///
					using "`results'/reg_results_mv.dta", replace
					
* define loop through levels of the data type variable	
	levelsof 	country		, local(levels)
	foreach		l of 		local levels {
 
	* set panel id so it varies by dtype
		xtset		hhid
										
	* define loop through rainfall mean local
		foreach 	rm of	varlist `rainmean' { 
	
		* define locals for rainfall mean naming conventions
			loc 	varrm = substr("`rm'", 1, 3)
			loc 	satrm = substr("`rm'", 5, 3)
			loc 	extrm = substr("`rm'", 9, 2)
			
		* define loop through rainfall variance local
			foreach 	rv of	varlist `rainvar' {
		    
			* define locals for rainfall variance naming conventions
				loc 	varrv = substr("`rv'", 1, 3)
				loc 	satrv = substr("`rv'", 5, 3)
				loc 	extrv = substr("`rv'", 9, 2)
			
				* define loop through temperature mean local
					foreach 	tm of	varlist `tempmean' {
				
				* define locals for temperature mean naming conventions
					loc 	vartm = substr("`tm'", 1, 3)
					loc 	sattm = substr("`tm'", 5, 3)
					loc 	exttm = substr("`tm'", 9, 2)
			
					* define loop through temperature mean local
						foreach 	tv of	varlist `tempvar' {
				
					* define locals for temperature mean naming conventions
						loc 	vartv = substr("`tv'", 1, 3)
						loc 	sattv = substr("`tv'", 5, 3)
						loc 	exttv = substr("`tv'", 9, 2)
						
						* define pairs of extrations to compare
							if 	`"`extrm'"' == `"`extrv'"' & ///
								`"`extrv'"' == `"`exttm'"' & ///
								`"`exttm'"' == `"`exttv'"' & ///
								`"`satrm'"' == `"`satrv'"' & ///
								`"`sattm'"' == `"`sattv'"' {
				    
							* 2.1: Value of Harvest
							loc		inputstf 	lntf_lab lntf_frt tf_pst tf_hrb tf_irr
							loc 	inputscp 	lncp_lab lncp_frt cp_pst cp_hrb cp_irr
		
							* weather
								reg 		lntf_yld `rm' `rv' `tm' `tv' if country == `l', vce(cluster hhid)
								post 		`reg_results_mv' (`l') ("`varrm'") ("`satrm'") ("`extrm'") ///
												("`varrv'") ("`satrv'") ("`extrv'") ///
												("`vartm'") ("`sattm'") ("`exttm'") ///
												("`vartv'") ("`sattv'") ("`exttv'") ///
												("tf") ("reg1") (`=_b[`rm']') (`=_se[`rm']') ///
												(`=_b[`rv']') (`=_se[`rv']') (`=_b[`tm']') ///
												(`=_se[`tm']') (`=_b[`tv']') (`=_se[`tv']') ///
												(`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
									
							* weather and fe	
								xtreg 		lntf_yld `rm' `rv' `tm' `tv' i.year if country == `l', fe vce(cluster hhid)
								post 		`reg_results_mv' (`l') ("`varrm'") ("`satrm'") ("`extrm'") ///
												("`varrv'") ("`satrv'") ("`extrv'") ///
												("`vartm'") ("`sattm'") ("`exttm'") ///
												("`vartv'") ("`sattv'") ("`exttv'") ///
												("tf") ("reg2") (`=_b[`rm']') (`=_se[`rm']') ///
												(`=_b[`rv']') (`=_se[`rv']') (`=_b[`tm']') ///
												(`=_se[`tm']') (`=_b[`tv']') (`=_se[`tv']') ///
												(`=e(r2_a)') (`=e(ll)') (`=e(df_r)')

							* weather and inputs and fe
								xtreg 		lntf_yld `rm' `rv' `tm' `tv' `inputstf' i.year if country == `l', fe vce(cluster hhid)
								post 		`reg_results_mv' (`l') ("`varrm'") ("`satrm'") ("`extrm'") ///
												("`varrv'") ("`satrv'") ("`extrv'") ///
												("`vartm'") ("`sattm'") ("`exttm'") ///
												("`vartv'") ("`sattv'") ("`exttv'") ///
												("tf") ("reg3") (`=_b[`rm']') (`=_se[`rm']') ///
												(`=_b[`rv']') (`=_se[`rv']') (`=_b[`tm']') ///
												(`=_se[`tm']') (`=_b[`tv']') (`=_se[`tv']') ///
												(`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
												
							* 2.2: Quantity of Maize
		
							* weather
								reg 		lncp_yld `rm' `rv' `tm' `tv' if country == `l', vce(cluster hhid)
								post 		`reg_results_mv' (`l') ("`varrm'") ("`satrm'") ("`extrm'") ///
												("`varrv'") ("`satrv'") ("`extrv'") ///
												("`vartm'") ("`sattm'") ("`exttm'") ///
												("`vartv'") ("`sattv'") ("`exttv'") ///
												("cp") ("reg1") (`=_b[`rm']') (`=_se[`rm']') ///
												(`=_b[`rv']') (`=_se[`rv']') (`=_b[`tm']') ///
												(`=_se[`tm']') (`=_b[`tv']') (`=_se[`tv']') ///
												(`=e(r2_a)') (`=e(ll)') (`=e(df_r)')

							* weather and fe	
								xtreg 		lncp_yld `rm' `rv' `tm' `tv' i.year if country == `l', fe vce(cluster hhid)
								post 		`reg_results_mv' (`l') ("`varrm'") ("`satrm'") ("`extrm'") ///
												("`varrv'") ("`satrv'") ("`extrv'") ///
												("`vartm'") ("`sattm'") ("`exttm'") ///
												("`vartv'") ("`sattv'") ("`exttv'") ///
												("cp") ("reg2") (`=_b[`rm']') (`=_se[`rm']') ///
												(`=_b[`rv']') (`=_se[`rv']') (`=_b[`tm']') ///
												(`=_se[`tm']') (`=_b[`tv']') (`=_se[`tv']') ///
												(`=e(r2_a)') (`=e(ll)') (`=e(df_r)')

							* weather and inputs and fe
								xtreg 		lncp_yld `rm' `rv' `tm' `tv' `inputscp' i.year if country == `l', fe vce(cluster hhid)
								post 		`reg_results_mv' (`l') ("`varrm'") ("`satrm'") ("`extrm'") ///
												("`varrv'") ("`satrv'") ("`extrv'") ///
												("`vartm'") ("`sattm'") ("`exttm'") ///
												("`vartv'") ("`sattv'") ("`exttv'") ///
												("cp") ("reg3") (`=_b[`rm']') (`=_se[`rm']') ///
												(`=_b[`rv']') (`=_se[`rv']') (`=_b[`tm']') ///
												(`=_se[`tm']') (`=_b[`tv']') (`=_se[`tv']') ///
												(`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
						}
					}	
				}
			}
		}
	}

* close the post file and open the data file
	postclose	`reg_results_mv' 
	use 		"`results'/reg_results_mv", clear

/*
* close the log
	log	close

/* END */