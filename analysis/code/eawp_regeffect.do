* Project: WB Weather
* Created on: Aug 2021
* Created by: mcg
* Stata v.16.1

* does
	* compares various regression models using data from eafrica_aez_panel.dta

* assumes
	* cleaned, merged (weather), and appended (waves) data
	* customsave.ado
	* dropped obs from nigeria and niger, no arid aez, one extraction method

* TO DO:
	* 
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		source	= 	"$data/regression_data/eawp_sandbox"
	loc		results = 	"$data/regression_data/eawp_sandbox"
	loc		logout 	= 	"$data/regression_data/logs"

* open log	
	cap log close
	log 	using 		"`logout'/eawp_regression_effects", append

	
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
	tempname 	ea_aez_regeff_results
	postfile 	`ea_aez_regeff_results' aez str3 sat str2 depvar str4 ///
					regname str3 varname betarain serain adjustedr loglike dfr ///
					betatwsh betatwhu betatcsa betatcsh betatchu ///
					using "`results'/ea_aez_reg_results.dta", replace
*/
					

* **********************************************************************
* 3 - exploring effects of country and aez
* **********************************************************************
    
* 0 - TEST FOR AEZ v. FE

/*

	** hhids are perfectly colinear w/ country, highly colinear w/ aez
	** 102 hh w/ differing aezs (of 9,260)
	** will not include hhFE in future regressions
	
	by hhid (aez), sort: gen diff = aez[1] != aez[_N]
	list hhid aez if diff

	* set panel id so it varies by dtype
		xtset		hhid
		
	* weather metrics			
		foreach 	v of varlist `weather' { 
		    
		* define locals for naming conventions
			loc 	sat = 	substr("`v'", 5, 3)
			loc 	varn = 	substr("`v'", 1, 3)

		* AEZ, no hhFE
			reg 		lncp_yld `v' i.aez `inputscp' i.year
			
		* hhFE, no AEZ
			xtreg 		lncp_yld `v' `inputscp' i.year, fe
			
		* both AEZ & hhFE
			xtreg 		lncp_yld `v' i.aez `inputscp' i.year, fe
		
}	*/


* **********************************************************************
* 3.1 - exploring weather effects by country and aez
* **********************************************************************
/*	
* 1 - HETEROGENEITY OF WEATHER EFFECT BY AEZ WITHOUT REGARD TO COUNTRY	

	loc 		inputscp 	lncp_lab lncp_frt cp_pst cp_hrb cp_irr
		
	* weather metrics			
		foreach 	v of varlist `weather' { 
		    
		* define locals for naming conventions
			loc 	sat = 	substr("`v'", 5, 3)
			loc 	varn = 	substr("`v'", 1, 3)
			
		* Y = \beta AEZ + \omega W + \theta (W x AEZ) + \pi X + \alpha_{h} + \gamma_{t} + u_{ht}
			reg 	lncp_yld c.`v'##i.aez `inputscp' i.year, vce(cluster hhid)
}
		

* 2 - HETEROGENEITY OF WEATHER EFFECT BY COUNTRY WITHOUT REGARD TO AEZ		

	loc 		inputscp 	lncp_lab lncp_frt cp_pst cp_hrb cp_irr
		
	* weather metrics			
		foreach 	v of varlist `weather' { 
		    
		* define locals for naming conventions
			loc 	sat = 	substr("`v'", 5, 3)
			loc 	varn = 	substr("`v'", 1, 3)

		* Y = \beta country + \omega W + \theta (W x country) + \pi X + \alpha_{h} + \gamma_{t} + u_{ht}
			reg 	lncp_yld c.`v'##i.country `inputscp' i.year, vce(cluster hhid)
}

	
* 3 - EFFECT OF WEATHER BY COUNTRY WITHOUT REGARD TO AEZ		

loc 		inputscp 	lncp_lab lncp_frt cp_pst cp_hrb cp_irr

levelsof 	country, local(levels)
foreach l of local levels {	
	
* preserve only one country
		preserve
		drop 		if country != `l'	
		
	* weather metrics			
		foreach 	v of varlist `weather' { 
		    
		* define locals for naming conventions
			loc 	sat = 	substr("`v'", 5, 3)
			loc 	varn = 	substr("`v'", 1, 3)
			
		* Y = \omega W + \pi X + \alpha_{h} + \gamma_{t} + u_{ht}
			reg 		lncp_yld `v' `inputscp' i.year, vce(cluster hhid)
			
}			
		restore
}


* 4 - EFFECT OF WEATHER AND AEZ IN DIFFERENT COUNTRIES	
	
loc 		inputscp 	lncp_lab lncp_frt cp_pst cp_hrb cp_irr	
	
levelsof 	country, local(levels)
foreach l of local levels {	
	
* preserve only one country
		preserve
		drop 		if country != `l'	
		
	* weather metrics			
		foreach 	v of varlist `weather' { 
		    
		* define locals for naming conventions
			loc 	sat = 	substr("`v'", 5, 3)
			loc 	varn = 	substr("`v'", 1, 3)
			
		* Y = \omega W + \beta AEZ + \pi X + \alpha_{h} + \gamma_{t} + u_{ht}
			reg 		lncp_yld `v' i.aez `inputscp' i.year, vce(cluster hhid)
			
}			
		restore
}


* 5 - HETEROGENEITY OF WEATHER EFFECT BY AEZ WITHOUT IN DIFFERENT COUNTRIES	

loc 		inputscp 	lncp_lab lncp_frt cp_pst cp_hrb cp_irr
		
levelsof 	country, local(levels)
foreach l of local levels {	
	
* preserve only one country
		preserve
		drop 		if country != `l'	
		
	* weather metrics			
		foreach 	v of varlist `weather' { 
		    
		* define locals for naming conventions
			loc 	sat = 	substr("`v'", 5, 3)
			loc 	varn = 	substr("`v'", 1, 3)
			
		* EFFECT OF AEZ WITHOUT REGARD TO COUNTRY	
		* Y = \omega W + \beta AEZ + \theta (W x country) + \pi X + \alpha_{h} + \gamma_{t} + u_{ht}
			reg 		lncp_yld c.`v'##i.aez `inputscp' i.year, vce(cluster hhid)
			
}

		restore
}							
*/

* **********************************************************************
* 4 - sample split by country, building tables
* **********************************************************************

sort		country
by country:	tab aez
by country:	tab year

loc 		inputscp 	lncp_lab lncp_frt cp_pst cp_hrb cp_irr

***************************************************TANZANIA****************************************************

* preserve only one country - Tanzania
		preserve
		drop 		if country != 6	
		
	* weather metrics			
		foreach 	v of varlist `weather' { 
		    
		* define locals for naming conventions
			loc 	sat = 	substr("`v'", 5, 3)
			loc 	varn = 	substr("`v'", 1, 3)
			
		* Y = \omega W + \pi X + \alpha_{h} + \gamma_{t} + u_{ht}
			reg 		lncp_yld c.`v'#i.aez `inputscp' i.year, vce(cluster hhid)
			eststo		reg_`v'
			
}			

*build tables, tza rainfall
	* mean
		esttab reg_v01_rf1_x1 reg_v01_rf2_x1 reg_v01_rf3_x1 reg_v01_rf4_x1 ///
			reg_v01_rf5_x1 reg_v01_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_mean_tza.tex", replace ///
			title(Mean Daily Rainfall - Tanzania) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v01_rf1_x1 Tropic-warm/semiarid 312.aez#c.v01_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v01_rf3_x1 Tropic-warm/semiarid 312.aez#c.v01_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v01_rf5_x1 Tropic-warm/semiarid 312.aez#c.v01_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v01_rf1_x1 Tropic-warm/subhumid 313.aez#c.v01_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v01_rf3_x1 Tropic-warm/subhumid 313.aez#c.v01_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v01_rf5_x1 Tropic-warm/subhumid 313.aez#c.v01_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v01_rf1_x1 Tropic-warm/humid 314.aez#c.v01_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v01_rf3_x1 Tropic-warm/humid 314.aez#c.v01_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v01_rf5_x1 Tropic-warm/humid 314.aez#c.v01_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v01_rf1_x1 Tropic-cool/semiarid 322.aez#c.v01_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v01_rf3_x1 Tropic-cool/semiarid 322.aez#c.v01_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v01_rf5_x1 Tropic-cool/semiarid 322.aez#c.v01_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v01_rf1_x1 Tropic-cool/subhumid 323.aez#c.v01_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v01_rf3_x1 Tropic-cool/subhumid 323.aez#c.v01_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v01_rf5_x1 Tropic-cool/subhumid 323.aez#c.v01_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v01_rf1_x1 Tropic-cool/humid 324.aez#c.v01_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v01_rf3_x1 Tropic-cool/humid 324.aez#c.v01_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v01_rf5_x1 Tropic-cool/humid 324.aez#c.v01_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2008.year 2010.year 2012.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* median
		esttab reg_v02_rf1_x1 reg_v02_rf2_x1 reg_v02_rf3_x1 reg_v02_rf4_x1 ///
			reg_v02_rf5_x1 reg_v02_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_median_tza.tex", replace ///
			title(Median Daily Rainfall - Tanzania) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v02_rf1_x1 Tropic-warm/semiarid 312.aez#c.v02_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v02_rf3_x1 Tropic-warm/semiarid 312.aez#c.v02_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v02_rf5_x1 Tropic-warm/semiarid 312.aez#c.v02_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v02_rf1_x1 Tropic-warm/subhumid 313.aez#c.v02_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v02_rf3_x1 Tropic-warm/subhumid 313.aez#c.v02_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v02_rf5_x1 Tropic-warm/subhumid 313.aez#c.v02_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v02_rf1_x1 Tropic-warm/humid 314.aez#c.v02_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v02_rf3_x1 Tropic-warm/humid 314.aez#c.v02_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v02_rf5_x1 Tropic-warm/humid 314.aez#c.v02_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v02_rf1_x1 Tropic-cool/semiarid 322.aez#c.v02_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v02_rf3_x1 Tropic-cool/semiarid 322.aez#c.v02_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v02_rf5_x1 Tropic-cool/semiarid 322.aez#c.v02_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v02_rf1_x1 Tropic-cool/subhumid 323.aez#c.v02_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v02_rf3_x1 Tropic-cool/subhumid 323.aez#c.v02_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v02_rf5_x1 Tropic-cool/subhumid 323.aez#c.v02_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v02_rf1_x1 Tropic-cool/humid 324.aez#c.v02_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v02_rf3_x1 Tropic-cool/humid 324.aez#c.v02_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v02_rf5_x1 Tropic-cool/humid 324.aez#c.v02_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2008.year 2010.year 2012.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* variance
		esttab reg_v03_rf1_x1 reg_v03_rf2_x1 reg_v03_rf3_x1 reg_v03_rf4_x1 ///
			reg_v03_rf5_x1 reg_v03_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_var_tza.tex", replace ///
			title(Variance of Daily Rainfall - Tanzania) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v03_rf1_x1 Tropic-warm/semiarid 312.aez#c.v03_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v03_rf3_x1 Tropic-warm/semiarid 312.aez#c.v03_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v03_rf5_x1 Tropic-warm/semiarid 312.aez#c.v03_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v03_rf1_x1 Tropic-warm/subhumid 313.aez#c.v03_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v03_rf3_x1 Tropic-warm/subhumid 313.aez#c.v03_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v03_rf5_x1 Tropic-warm/subhumid 313.aez#c.v03_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v03_rf1_x1 Tropic-warm/humid 314.aez#c.v03_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v03_rf3_x1 Tropic-warm/humid 314.aez#c.v03_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v03_rf5_x1 Tropic-warm/humid 314.aez#c.v03_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v03_rf1_x1 Tropic-cool/semiarid 322.aez#c.v03_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v03_rf3_x1 Tropic-cool/semiarid 322.aez#c.v03_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v03_rf5_x1 Tropic-cool/semiarid 322.aez#c.v03_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v03_rf1_x1 Tropic-cool/subhumid 323.aez#c.v03_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v03_rf3_x1 Tropic-cool/subhumid 323.aez#c.v03_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v03_rf5_x1 Tropic-cool/subhumid 323.aez#c.v03_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v03_rf1_x1 Tropic-cool/humid 324.aez#c.v03_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v03_rf3_x1 Tropic-cool/humid 324.aez#c.v03_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v03_rf5_x1 Tropic-cool/humid 324.aez#c.v03_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2008.year 2010.year 2012.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* skew
		esttab reg_v04_rf1_x1 reg_v04_rf2_x1 reg_v04_rf3_x1 reg_v04_rf4_x1 ///
			reg_v04_rf5_x1 reg_v04_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_skew_tza.tex", replace ///
			title(Skew of Daily Rainfall - Tanzania) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v04_rf1_x1 Tropic-warm/semiarid 312.aez#c.v04_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v04_rf3_x1 Tropic-warm/semiarid 312.aez#c.v04_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v04_rf5_x1 Tropic-warm/semiarid 312.aez#c.v04_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v04_rf1_x1 Tropic-warm/subhumid 313.aez#c.v04_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v04_rf3_x1 Tropic-warm/subhumid 313.aez#c.v04_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v04_rf5_x1 Tropic-warm/subhumid 313.aez#c.v04_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v04_rf1_x1 Tropic-warm/humid 314.aez#c.v04_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v04_rf3_x1 Tropic-warm/humid 314.aez#c.v04_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v04_rf5_x1 Tropic-warm/humid 314.aez#c.v04_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v04_rf1_x1 Tropic-cool/semiarid 322.aez#c.v04_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v04_rf3_x1 Tropic-cool/semiarid 322.aez#c.v04_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v04_rf5_x1 Tropic-cool/semiarid 322.aez#c.v04_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v04_rf1_x1 Tropic-cool/subhumid 323.aez#c.v04_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v04_rf3_x1 Tropic-cool/subhumid 323.aez#c.v04_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v04_rf5_x1 Tropic-cool/subhumid 323.aez#c.v04_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v04_rf1_x1 Tropic-cool/humid 324.aez#c.v04_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v04_rf3_x1 Tropic-cool/humid 324.aez#c.v04_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v04_rf5_x1 Tropic-cool/humid 324.aez#c.v04_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2008.year 2010.year 2012.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* total
		esttab reg_v05_rf1_x1 reg_v05_rf2_x1 reg_v05_rf3_x1 reg_v05_rf4_x1 ///
			reg_v05_rf5_x1 reg_v05_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_total_tza.tex", replace ///
			title(Total Rainfall - Tanzania) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v05_rf1_x1 Tropic-warm/semiarid 312.aez#c.v05_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v05_rf3_x1 Tropic-warm/semiarid 312.aez#c.v05_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v05_rf5_x1 Tropic-warm/semiarid 312.aez#c.v05_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v05_rf1_x1 Tropic-warm/subhumid 313.aez#c.v05_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v05_rf3_x1 Tropic-warm/subhumid 313.aez#c.v05_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v05_rf5_x1 Tropic-warm/subhumid 313.aez#c.v05_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v05_rf1_x1 Tropic-warm/humid 314.aez#c.v05_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v05_rf3_x1 Tropic-warm/humid 314.aez#c.v05_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v05_rf5_x1 Tropic-warm/humid 314.aez#c.v05_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v05_rf1_x1 Tropic-cool/semiarid 322.aez#c.v05_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v05_rf3_x1 Tropic-cool/semiarid 322.aez#c.v05_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v05_rf5_x1 Tropic-cool/semiarid 322.aez#c.v05_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v05_rf1_x1 Tropic-cool/subhumid 323.aez#c.v05_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v05_rf3_x1 Tropic-cool/subhumid 323.aez#c.v05_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v05_rf5_x1 Tropic-cool/subhumid 323.aez#c.v05_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v05_rf1_x1 Tropic-cool/humid 324.aez#c.v05_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v05_rf3_x1 Tropic-cool/humid 324.aez#c.v05_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v05_rf5_x1 Tropic-cool/humid 324.aez#c.v05_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2008.year 2010.year 2012.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* deviation in total
		esttab reg_v06_rf1_x1 reg_v06_rf2_x1 reg_v06_rf3_x1 reg_v06_rf4_x1 ///
			reg_v06_rf5_x1 reg_v06_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_totaldev_tza.tex", replace ///
			title(Deviation in Total Rainfall - Tanzania) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v06_rf1_x1 Tropic-warm/semiarid 312.aez#c.v06_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v06_rf3_x1 Tropic-warm/semiarid 312.aez#c.v06_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v06_rf5_x1 Tropic-warm/semiarid 312.aez#c.v06_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v06_rf1_x1 Tropic-warm/subhumid 313.aez#c.v06_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v06_rf3_x1 Tropic-warm/subhumid 313.aez#c.v06_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v06_rf5_x1 Tropic-warm/subhumid 313.aez#c.v06_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v06_rf1_x1 Tropic-warm/humid 314.aez#c.v06_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v06_rf3_x1 Tropic-warm/humid 314.aez#c.v06_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v06_rf5_x1 Tropic-warm/humid 314.aez#c.v06_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v06_rf1_x1 Tropic-cool/semiarid 322.aez#c.v06_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v06_rf3_x1 Tropic-cool/semiarid 322.aez#c.v06_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v06_rf5_x1 Tropic-cool/semiarid 322.aez#c.v06_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v06_rf1_x1 Tropic-cool/subhumid 323.aez#c.v06_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v06_rf3_x1 Tropic-cool/subhumid 323.aez#c.v06_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v06_rf5_x1 Tropic-cool/subhumid 323.aez#c.v06_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v06_rf1_x1 Tropic-cool/humid 324.aez#c.v06_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v06_rf3_x1 Tropic-cool/humid 324.aez#c.v06_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v06_rf5_x1 Tropic-cool/humid 324.aez#c.v06_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2008.year 2010.year 2012.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* z-score total
		esttab reg_v07_rf1_x1 reg_v07_rf2_x1 reg_v07_rf3_x1 reg_v07_rf4_x1 ///
			reg_v07_rf5_x1 reg_v07_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_totalz_tza.tex", replace ///
			title(Z-Score of Total Rainfall - Tanzania) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v07_rf1_x1 Tropic-warm/semiarid 312.aez#c.v07_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v07_rf3_x1 Tropic-warm/semiarid 312.aez#c.v07_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v07_rf5_x1 Tropic-warm/semiarid 312.aez#c.v07_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v07_rf1_x1 Tropic-warm/subhumid 313.aez#c.v07_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v07_rf3_x1 Tropic-warm/subhumid 313.aez#c.v07_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v07_rf5_x1 Tropic-warm/subhumid 313.aez#c.v07_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v07_rf1_x1 Tropic-warm/humid 314.aez#c.v07_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v07_rf3_x1 Tropic-warm/humid 314.aez#c.v07_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v07_rf5_x1 Tropic-warm/humid 314.aez#c.v07_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v07_rf1_x1 Tropic-cool/semiarid 322.aez#c.v07_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v07_rf3_x1 Tropic-cool/semiarid 322.aez#c.v07_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v07_rf5_x1 Tropic-cool/semiarid 322.aez#c.v07_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v07_rf1_x1 Tropic-cool/subhumid 323.aez#c.v07_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v07_rf3_x1 Tropic-cool/subhumid 323.aez#c.v07_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v07_rf5_x1 Tropic-cool/subhumid 323.aez#c.v07_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v07_rf1_x1 Tropic-cool/humid 324.aez#c.v07_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v07_rf3_x1 Tropic-cool/humid 324.aez#c.v07_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v07_rf5_x1 Tropic-cool/humid 324.aez#c.v07_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2008.year 2010.year 2012.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* rain days 
		esttab reg_v08_rf1_x1 reg_v08_rf2_x1 reg_v08_rf3_x1 reg_v08_rf4_x1 ///
			reg_v08_rf5_x1 reg_v08_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_raindays_tza.tex", replace ///
			title(Rain Days - Tanzania) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v08_rf1_x1 Tropic-warm/semiarid 312.aez#c.v08_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v08_rf3_x1 Tropic-warm/semiarid 312.aez#c.v08_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v08_rf5_x1 Tropic-warm/semiarid 312.aez#c.v08_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v08_rf1_x1 Tropic-warm/subhumid 313.aez#c.v08_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v08_rf3_x1 Tropic-warm/subhumid 313.aez#c.v08_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v08_rf5_x1 Tropic-warm/subhumid 313.aez#c.v08_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v08_rf1_x1 Tropic-warm/humid 314.aez#c.v08_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v08_rf3_x1 Tropic-warm/humid 314.aez#c.v08_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v08_rf5_x1 Tropic-warm/humid 314.aez#c.v08_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v08_rf1_x1 Tropic-cool/semiarid 322.aez#c.v08_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v08_rf3_x1 Tropic-cool/semiarid 322.aez#c.v08_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v08_rf5_x1 Tropic-cool/semiarid 322.aez#c.v08_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v08_rf1_x1 Tropic-cool/subhumid 323.aez#c.v08_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v08_rf3_x1 Tropic-cool/subhumid 323.aez#c.v08_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v08_rf5_x1 Tropic-cool/subhumid 323.aez#c.v08_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v08_rf1_x1 Tropic-cool/humid 324.aez#c.v08_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v08_rf3_x1 Tropic-cool/humid 324.aez#c.v08_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v08_rf5_x1 Tropic-cool/humid 324.aez#c.v08_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2008.year 2010.year 2012.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* deviation in rain days
		esttab reg_v09_rf1_x1 reg_v09_rf2_x1 reg_v09_rf3_x1 reg_v09_rf4_x1 ///
			reg_v09_rf5_x1 reg_v09_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_raindaysdev_tza.tex", replace ///
			title(Deviation in Rain Days - Tanzania) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v09_rf1_x1 Tropic-warm/semiarid 312.aez#c.v09_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v09_rf3_x1 Tropic-warm/semiarid 312.aez#c.v09_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v09_rf5_x1 Tropic-warm/semiarid 312.aez#c.v09_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v09_rf1_x1 Tropic-warm/subhumid 313.aez#c.v09_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v09_rf3_x1 Tropic-warm/subhumid 313.aez#c.v09_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v09_rf5_x1 Tropic-warm/subhumid 313.aez#c.v09_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v09_rf1_x1 Tropic-warm/humid 314.aez#c.v09_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v09_rf3_x1 Tropic-warm/humid 314.aez#c.v09_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v09_rf5_x1 Tropic-warm/humid 314.aez#c.v09_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v09_rf1_x1 Tropic-cool/semiarid 322.aez#c.v09_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v09_rf3_x1 Tropic-cool/semiarid 322.aez#c.v09_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v09_rf5_x1 Tropic-cool/semiarid 322.aez#c.v09_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v09_rf1_x1 Tropic-cool/subhumid 323.aez#c.v09_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v09_rf3_x1 Tropic-cool/subhumid 323.aez#c.v09_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v09_rf5_x1 Tropic-cool/subhumid 323.aez#c.v09_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v09_rf1_x1 Tropic-cool/humid 324.aez#c.v09_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v09_rf3_x1 Tropic-cool/humid 324.aez#c.v09_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v09_rf5_x1 Tropic-cool/humid 324.aez#c.v09_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2008.year 2010.year 2012.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* no rain days
		esttab reg_v10_rf1_x1 reg_v10_rf2_x1 reg_v10_rf3_x1 reg_v10_rf4_x1 ///
			reg_v10_rf5_x1 reg_v10_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_norain_tza.tex", replace ///
			title(No-Rain Days - Tanzania) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v10_rf1_x1 Tropic-warm/semiarid 312.aez#c.v10_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v10_rf3_x1 Tropic-warm/semiarid 312.aez#c.v10_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v10_rf5_x1 Tropic-warm/semiarid 312.aez#c.v10_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v10_rf1_x1 Tropic-warm/subhumid 313.aez#c.v10_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v10_rf3_x1 Tropic-warm/subhumid 313.aez#c.v10_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v10_rf5_x1 Tropic-warm/subhumid 313.aez#c.v10_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v10_rf1_x1 Tropic-warm/humid 314.aez#c.v10_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v10_rf3_x1 Tropic-warm/humid 314.aez#c.v10_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v10_rf5_x1 Tropic-warm/humid 314.aez#c.v10_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v10_rf1_x1 Tropic-cool/semiarid 322.aez#c.v10_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v10_rf3_x1 Tropic-cool/semiarid 322.aez#c.v10_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v10_rf5_x1 Tropic-cool/semiarid 322.aez#c.v10_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v10_rf1_x1 Tropic-cool/subhumid 323.aez#c.v10_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v10_rf3_x1 Tropic-cool/subhumid 323.aez#c.v10_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v10_rf5_x1 Tropic-cool/subhumid 323.aez#c.v10_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v10_rf1_x1 Tropic-cool/humid 324.aez#c.v10_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v10_rf3_x1 Tropic-cool/humid 324.aez#c.v10_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v10_rf5_x1 Tropic-cool/humid 324.aez#c.v10_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2008.year 2010.year 2012.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* deviation in no rain days
		esttab reg_v11_rf1_x1 reg_v11_rf2_x1 reg_v11_rf3_x1 reg_v11_rf4_x1 ///
			reg_v11_rf5_x1 reg_v11_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_noraindev_tza.tex", replace ///
			title(Deviation in No-Rain Days - Tanzania) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v11_rf1_x1 Tropic-warm/semiarid 312.aez#c.v11_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v11_rf3_x1 Tropic-warm/semiarid 312.aez#c.v11_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v11_rf5_x1 Tropic-warm/semiarid 312.aez#c.v11_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v11_rf1_x1 Tropic-warm/subhumid 313.aez#c.v11_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v11_rf3_x1 Tropic-warm/subhumid 313.aez#c.v11_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v11_rf5_x1 Tropic-warm/subhumid 313.aez#c.v11_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v11_rf1_x1 Tropic-warm/humid 314.aez#c.v11_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v11_rf3_x1 Tropic-warm/humid 314.aez#c.v11_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v11_rf5_x1 Tropic-warm/humid 314.aez#c.v11_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v11_rf1_x1 Tropic-cool/semiarid 322.aez#c.v11_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v11_rf3_x1 Tropic-cool/semiarid 322.aez#c.v11_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v11_rf5_x1 Tropic-cool/semiarid 322.aez#c.v11_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v11_rf1_x1 Tropic-cool/subhumid 323.aez#c.v11_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v11_rf3_x1 Tropic-cool/subhumid 323.aez#c.v11_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v11_rf5_x1 Tropic-cool/subhumid 323.aez#c.v11_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v11_rf1_x1 Tropic-cool/humid 324.aez#c.v11_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v11_rf3_x1 Tropic-cool/humid 324.aez#c.v11_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v11_rf5_x1 Tropic-cool/humid 324.aez#c.v11_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2008.year 2010.year 2012.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* rain days percent
		esttab reg_v12_rf1_x1 reg_v12_rf2_x1 reg_v12_rf3_x1 reg_v12_rf4_x1 ///
			reg_v12_rf5_x1 reg_v12_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_percentraindays_tza.tex", replace ///
			title(Percentage of Rain Days - Tanzania) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v12_rf1_x1 Tropic-warm/semiarid 312.aez#c.v12_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v12_rf3_x1 Tropic-warm/semiarid 312.aez#c.v12_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v12_rf5_x1 Tropic-warm/semiarid 312.aez#c.v12_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v12_rf1_x1 Tropic-warm/subhumid 313.aez#c.v12_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v12_rf3_x1 Tropic-warm/subhumid 313.aez#c.v12_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v12_rf5_x1 Tropic-warm/subhumid 313.aez#c.v12_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v12_rf1_x1 Tropic-warm/humid 314.aez#c.v12_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v12_rf3_x1 Tropic-warm/humid 314.aez#c.v12_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v12_rf5_x1 Tropic-warm/humid 314.aez#c.v12_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v12_rf1_x1 Tropic-cool/semiarid 322.aez#c.v12_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v12_rf3_x1 Tropic-cool/semiarid 322.aez#c.v12_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v12_rf5_x1 Tropic-cool/semiarid 322.aez#c.v12_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v12_rf1_x1 Tropic-cool/subhumid 323.aez#c.v12_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v12_rf3_x1 Tropic-cool/subhumid 323.aez#c.v12_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v12_rf5_x1 Tropic-cool/subhumid 323.aez#c.v12_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v12_rf1_x1 Tropic-cool/humid 324.aez#c.v12_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v12_rf3_x1 Tropic-cool/humid 324.aez#c.v12_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v12_rf5_x1 Tropic-cool/humid 324.aez#c.v12_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2008.year 2010.year 2012.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* deviation in raindays percent
		esttab reg_v13_rf1_x1 reg_v13_rf2_x1 reg_v13_rf3_x1 reg_v13_rf4_x1 ///
			reg_v13_rf5_x1 reg_v13_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_percentraindaysdev_tza.tex", replace ///
			title(Deviation in Percent Rain Days - Tanzania) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v13_rf1_x1 Tropic-warm/semiarid 312.aez#c.v13_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v13_rf3_x1 Tropic-warm/semiarid 312.aez#c.v13_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v13_rf5_x1 Tropic-warm/semiarid 312.aez#c.v13_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v13_rf1_x1 Tropic-warm/subhumid 313.aez#c.v13_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v13_rf3_x1 Tropic-warm/subhumid 313.aez#c.v13_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v13_rf5_x1 Tropic-warm/subhumid 313.aez#c.v13_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v13_rf1_x1 Tropic-warm/humid 314.aez#c.v13_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v13_rf3_x1 Tropic-warm/humid 314.aez#c.v13_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v13_rf5_x1 Tropic-warm/humid 314.aez#c.v13_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v13_rf1_x1 Tropic-cool/semiarid 322.aez#c.v13_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v13_rf3_x1 Tropic-cool/semiarid 322.aez#c.v13_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v13_rf5_x1 Tropic-cool/semiarid 322.aez#c.v13_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v13_rf1_x1 Tropic-cool/subhumid 323.aez#c.v13_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v13_rf3_x1 Tropic-cool/subhumid 323.aez#c.v13_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v13_rf5_x1 Tropic-cool/subhumid 323.aez#c.v13_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v13_rf1_x1 Tropic-cool/humid 324.aez#c.v13_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v13_rf3_x1 Tropic-cool/humid 324.aez#c.v13_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v13_rf5_x1 Tropic-cool/humid 324.aez#c.v13_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2008.year 2010.year 2012.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* longest dry spell
		esttab reg_v14_rf1_x1 reg_v14_rf2_x1 reg_v14_rf3_x1 reg_v14_rf4_x1 ///
			reg_v14_rf5_x1 reg_v14_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_dry_tza.tex", replace ///
			title(Longest Dry Spell - Tanzania) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v14_rf1_x1 Tropic-warm/semiarid 312.aez#c.v14_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v14_rf3_x1 Tropic-warm/semiarid 312.aez#c.v14_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v14_rf5_x1 Tropic-warm/semiarid 312.aez#c.v14_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v14_rf1_x1 Tropic-warm/subhumid 313.aez#c.v14_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v14_rf3_x1 Tropic-warm/subhumid 313.aez#c.v14_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v14_rf5_x1 Tropic-warm/subhumid 313.aez#c.v14_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v14_rf1_x1 Tropic-warm/humid 314.aez#c.v14_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v14_rf3_x1 Tropic-warm/humid 314.aez#c.v14_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v14_rf5_x1 Tropic-warm/humid 314.aez#c.v14_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v14_rf1_x1 Tropic-cool/semiarid 322.aez#c.v14_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v14_rf3_x1 Tropic-cool/semiarid 322.aez#c.v14_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v14_rf5_x1 Tropic-cool/semiarid 322.aez#c.v14_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v14_rf1_x1 Tropic-cool/subhumid 323.aez#c.v14_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v14_rf3_x1 Tropic-cool/subhumid 323.aez#c.v14_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v14_rf5_x1 Tropic-cool/subhumid 323.aez#c.v14_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v14_rf1_x1 Tropic-cool/humid 324.aez#c.v14_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v14_rf3_x1 Tropic-cool/humid 324.aez#c.v14_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v14_rf5_x1 Tropic-cool/humid 324.aez#c.v14_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2008.year 2010.year 2012.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
	
*build tables, tza temperature	
	* mean
		esttab 	reg_v15_tp1_x1 reg_v15_tp2_x1 reg_v15_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_mean_tza.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Mean Daily Temperature - Tanzania) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v15_tp1_x1 Tropic-warm/semiarid 312.aez#c.v15_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v15_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v15_tp1_x1 Tropic-warm/subhumid 313.aez#c.v15_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v15_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v15_tp1_x1 Tropic-warm/humid 314.aez#c.v15_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v15_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v15_tp1_x1 Tropic-cool/semiarid  322.aez#c.v15_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v15_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v15_tp1_x1 Tropic-cool/subhumid  323.aez#c.v15_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v15_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v15_tp1_x1 Tropic-cool/humid  324.aez#c.v15_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v15_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2008.year 2010.year 2012.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* median
		esttab 	reg_v16_tp1_x1 reg_v16_tp2_x1 reg_v16_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_median_tza.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Median Daily Temperature - Tanzania) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v16_tp1_x1 Tropic-warm/semiarid 312.aez#c.v16_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v16_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v16_tp1_x1 Tropic-warm/subhumid 313.aez#c.v16_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v16_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v16_tp1_x1 Tropic-warm/humid 314.aez#c.v16_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v16_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v16_tp1_x1 Tropic-cool/semiarid  322.aez#c.v16_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v16_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v16_tp1_x1 Tropic-cool/subhumid  323.aez#c.v16_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v16_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v16_tp1_x1 Tropic-cool/humid  324.aez#c.v16_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v16_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2008.year 2010.year 2012.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* variance
		esttab 	reg_v17_tp1_x1 reg_v17_tp2_x1 reg_v17_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_variance_tza.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Variance of Daily Temperature - Tanzania) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v17_tp1_x1 Tropic-warm/semiarid 312.aez#c.v17_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v17_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v17_tp1_x1 Tropic-warm/subhumid 313.aez#c.v17_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v17_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v17_tp1_x1 Tropic-warm/humid 314.aez#c.v17_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v17_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v17_tp1_x1 Tropic-cool/semiarid  322.aez#c.v17_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v17_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v17_tp1_x1 Tropic-cool/subhumid  323.aez#c.v17_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v17_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v17_tp1_x1 Tropic-cool/humid  324.aez#c.v17_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v17_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2008.year 2010.year 2012.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* skew
		esttab 	reg_v18_tp1_x1 reg_v18_tp2_x1 reg_v18_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_skew_tza.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Skew of Daily Temperature - Tanzania) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v18_tp1_x1 Tropic-warm/semiarid 312.aez#c.v18_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v18_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v18_tp1_x1 Tropic-warm/subhumid 313.aez#c.v18_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v18_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v18_tp1_x1 Tropic-warm/humid 314.aez#c.v18_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v18_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v18_tp1_x1 Tropic-cool/semiarid  322.aez#c.v18_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v18_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v18_tp1_x1 Tropic-cool/subhumid  323.aez#c.v18_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v18_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v18_tp1_x1 Tropic-cool/humid  324.aez#c.v18_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v18_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2008.year 2010.year 2012.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* growing degree days
		esttab 	reg_v19_tp1_x1 reg_v19_tp2_x1 reg_v19_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_gdd_tza.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Growing Degree Days - Tanzania) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v19_tp1_x1 Tropic-warm/semiarid 312.aez#c.v19_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v19_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v19_tp1_x1 Tropic-warm/subhumid 313.aez#c.v19_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v19_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v19_tp1_x1 Tropic-warm/humid 314.aez#c.v19_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v19_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v19_tp1_x1 Tropic-cool/semiarid  322.aez#c.v19_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v19_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v19_tp1_x1 Tropic-cool/subhumid  323.aez#c.v19_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v19_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v19_tp1_x1 Tropic-cool/humid  324.aez#c.v19_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v19_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2008.year 2010.year 2012.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* deviation in gdd
		esttab 	reg_v20_tp1_x1 reg_v20_tp2_x1 reg_v20_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_gdddev_tza.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Deviation in GDD - Tanzania) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v20_tp1_x1 Tropic-warm/semiarid 312.aez#c.v20_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v20_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v20_tp1_x1 Tropic-warm/subhumid 313.aez#c.v20_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v20_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v20_tp1_x1 Tropic-warm/humid 314.aez#c.v20_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v20_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v20_tp1_x1 Tropic-cool/semiarid  322.aez#c.v20_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v20_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v20_tp1_x1 Tropic-cool/subhumid  323.aez#c.v20_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v20_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v20_tp1_x1 Tropic-cool/humid  324.aez#c.v20_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v20_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2008.year 2010.year 2012.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* z-score of gdd
		esttab 	reg_v21_tp1_x1 reg_v21_tp2_x1 reg_v21_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_gddz_tza.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Z-Score of GDD - Tanzania) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v21_tp1_x1 Tropic-warm/semiarid 312.aez#c.v21_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v21_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v21_tp1_x1 Tropic-warm/subhumid 313.aez#c.v21_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v21_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v21_tp1_x1 Tropic-warm/humid 314.aez#c.v21_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v21_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v21_tp1_x1 Tropic-cool/semiarid  322.aez#c.v21_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v21_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v21_tp1_x1 Tropic-cool/subhumid  323.aez#c.v21_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v21_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v21_tp1_x1 Tropic-cool/humid  324.aez#c.v21_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v21_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2008.year 2010.year 2012.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* max
		esttab 	reg_v22_tp1_x1 reg_v22_tp2_x1 reg_v22_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_max_tza.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Maximum Daily Temperature - Tanzania) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v22_tp1_x1 Tropic-warm/semiarid 312.aez#c.v22_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v22_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v22_tp1_x1 Tropic-warm/subhumid 313.aez#c.v22_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v22_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v22_tp1_x1 Tropic-warm/humid 314.aez#c.v22_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v22_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v22_tp1_x1 Tropic-cool/semiarid  322.aez#c.v22_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v22_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v22_tp1_x1 Tropic-cool/subhumid  323.aez#c.v22_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v22_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v22_tp1_x1 Tropic-cool/humid  324.aez#c.v22_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v22_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2008.year 2010.year 2012.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
				
		restore

***************************************************ETHIOPIA****************************************************		
		
* preserve only one country - Ethiopia
		preserve
		drop 		if country != 1
		
	* weather metrics			
		foreach 	v of varlist `weather' { 
		    
		* define locals for naming conventions
			loc 	sat = 	substr("`v'", 5, 3)
			loc 	varn = 	substr("`v'", 1, 3)
			
		* Y = \omega W + \pi X + \alpha_{h} + \gamma_{t} + u_{ht}
			reg 		lncp_yld c.`v'#i.aez `inputscp' i.year, vce(cluster hhid)
			eststo		reg_`v'
			
}			

*build tables, eth rainfall
	* mean
		esttab reg_v01_rf1_x1 reg_v01_rf2_x1 reg_v01_rf3_x1 reg_v01_rf4_x1 ///
			reg_v01_rf5_x1 reg_v01_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_mean_eth.tex", replace ///
			title(Mean Daily Rainfall - Ethiopia) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v01_rf1_x1 Tropic-warm/semiarid 312.aez#c.v01_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v01_rf3_x1 Tropic-warm/semiarid 312.aez#c.v01_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v01_rf5_x1 Tropic-warm/semiarid 312.aez#c.v01_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v01_rf1_x1 Tropic-warm/subhumid 313.aez#c.v01_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v01_rf3_x1 Tropic-warm/subhumid 313.aez#c.v01_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v01_rf5_x1 Tropic-warm/subhumid 313.aez#c.v01_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v01_rf1_x1 Tropic-warm/humid 314.aez#c.v01_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v01_rf3_x1 Tropic-warm/humid 314.aez#c.v01_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v01_rf5_x1 Tropic-warm/humid 314.aez#c.v01_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v01_rf1_x1 Tropic-cool/semiarid 322.aez#c.v01_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v01_rf3_x1 Tropic-cool/semiarid 322.aez#c.v01_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v01_rf5_x1 Tropic-cool/semiarid 322.aez#c.v01_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v01_rf1_x1 Tropic-cool/subhumid 323.aez#c.v01_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v01_rf3_x1 Tropic-cool/subhumid 323.aez#c.v01_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v01_rf5_x1 Tropic-cool/subhumid 323.aez#c.v01_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v01_rf1_x1 Tropic-cool/humid 324.aez#c.v01_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v01_rf3_x1 Tropic-cool/humid 324.aez#c.v01_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v01_rf5_x1 Tropic-cool/humid 324.aez#c.v01_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2011.year 2013.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* median
		esttab reg_v02_rf1_x1 reg_v02_rf2_x1 reg_v02_rf3_x1 reg_v02_rf4_x1 ///
			reg_v02_rf5_x1 reg_v02_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_median_eth.tex", replace ///
			title(Median Daily Rainfall - Ethiopia) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v02_rf1_x1 Tropic-warm/semiarid 312.aez#c.v02_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v02_rf3_x1 Tropic-warm/semiarid 312.aez#c.v02_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v02_rf5_x1 Tropic-warm/semiarid 312.aez#c.v02_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v02_rf1_x1 Tropic-warm/subhumid 313.aez#c.v02_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v02_rf3_x1 Tropic-warm/subhumid 313.aez#c.v02_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v02_rf5_x1 Tropic-warm/subhumid 313.aez#c.v02_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v02_rf1_x1 Tropic-warm/humid 314.aez#c.v02_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v02_rf3_x1 Tropic-warm/humid 314.aez#c.v02_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v02_rf5_x1 Tropic-warm/humid 314.aez#c.v02_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v02_rf1_x1 Tropic-cool/semiarid 322.aez#c.v02_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v02_rf3_x1 Tropic-cool/semiarid 322.aez#c.v02_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v02_rf5_x1 Tropic-cool/semiarid 322.aez#c.v02_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v02_rf1_x1 Tropic-cool/subhumid 323.aez#c.v02_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v02_rf3_x1 Tropic-cool/subhumid 323.aez#c.v02_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v02_rf5_x1 Tropic-cool/subhumid 323.aez#c.v02_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v02_rf1_x1 Tropic-cool/humid 324.aez#c.v02_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v02_rf3_x1 Tropic-cool/humid 324.aez#c.v02_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v02_rf5_x1 Tropic-cool/humid 324.aez#c.v02_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2011.year 2013.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* variance
		esttab reg_v03_rf1_x1 reg_v03_rf2_x1 reg_v03_rf3_x1 reg_v03_rf4_x1 ///
			reg_v03_rf5_x1 reg_v03_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_var_eth.tex", replace ///
			title(Variance of Daily Rainfall - Ethiopia) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v03_rf1_x1 Tropic-warm/semiarid 312.aez#c.v03_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v03_rf3_x1 Tropic-warm/semiarid 312.aez#c.v03_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v03_rf5_x1 Tropic-warm/semiarid 312.aez#c.v03_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v03_rf1_x1 Tropic-warm/subhumid 313.aez#c.v03_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v03_rf3_x1 Tropic-warm/subhumid 313.aez#c.v03_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v03_rf5_x1 Tropic-warm/subhumid 313.aez#c.v03_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v03_rf1_x1 Tropic-warm/humid 314.aez#c.v03_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v03_rf3_x1 Tropic-warm/humid 314.aez#c.v03_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v03_rf5_x1 Tropic-warm/humid 314.aez#c.v03_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v03_rf1_x1 Tropic-cool/semiarid 322.aez#c.v03_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v03_rf3_x1 Tropic-cool/semiarid 322.aez#c.v03_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v03_rf5_x1 Tropic-cool/semiarid 322.aez#c.v03_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v03_rf1_x1 Tropic-cool/subhumid 323.aez#c.v03_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v03_rf3_x1 Tropic-cool/subhumid 323.aez#c.v03_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v03_rf5_x1 Tropic-cool/subhumid 323.aez#c.v03_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v03_rf1_x1 Tropic-cool/humid 324.aez#c.v03_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v03_rf3_x1 Tropic-cool/humid 324.aez#c.v03_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v03_rf5_x1 Tropic-cool/humid 324.aez#c.v03_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2011.year 2013.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* skew
		esttab reg_v04_rf1_x1 reg_v04_rf2_x1 reg_v04_rf3_x1 reg_v04_rf4_x1 ///
			reg_v04_rf5_x1 reg_v04_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_skew_eth.tex", replace ///
			title(Skew of Daily Rainfall - Ethiopia) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v04_rf1_x1 Tropic-warm/semiarid 312.aez#c.v04_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v04_rf3_x1 Tropic-warm/semiarid 312.aez#c.v04_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v04_rf5_x1 Tropic-warm/semiarid 312.aez#c.v04_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v04_rf1_x1 Tropic-warm/subhumid 313.aez#c.v04_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v04_rf3_x1 Tropic-warm/subhumid 313.aez#c.v04_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v04_rf5_x1 Tropic-warm/subhumid 313.aez#c.v04_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v04_rf1_x1 Tropic-warm/humid 314.aez#c.v04_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v04_rf3_x1 Tropic-warm/humid 314.aez#c.v04_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v04_rf5_x1 Tropic-warm/humid 314.aez#c.v04_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v04_rf1_x1 Tropic-cool/semiarid 322.aez#c.v04_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v04_rf3_x1 Tropic-cool/semiarid 322.aez#c.v04_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v04_rf5_x1 Tropic-cool/semiarid 322.aez#c.v04_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v04_rf1_x1 Tropic-cool/subhumid 323.aez#c.v04_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v04_rf3_x1 Tropic-cool/subhumid 323.aez#c.v04_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v04_rf5_x1 Tropic-cool/subhumid 323.aez#c.v04_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v04_rf1_x1 Tropic-cool/humid 324.aez#c.v04_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v04_rf3_x1 Tropic-cool/humid 324.aez#c.v04_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v04_rf5_x1 Tropic-cool/humid 324.aez#c.v04_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2011.year 2013.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* total
		esttab reg_v05_rf1_x1 reg_v05_rf2_x1 reg_v05_rf3_x1 reg_v05_rf4_x1 ///
			reg_v05_rf5_x1 reg_v05_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_total_eth.tex", replace ///
			title(Total Rainfall - Ethiopia) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v05_rf1_x1 Tropic-warm/semiarid 312.aez#c.v05_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v05_rf3_x1 Tropic-warm/semiarid 312.aez#c.v05_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v05_rf5_x1 Tropic-warm/semiarid 312.aez#c.v05_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v05_rf1_x1 Tropic-warm/subhumid 313.aez#c.v05_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v05_rf3_x1 Tropic-warm/subhumid 313.aez#c.v05_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v05_rf5_x1 Tropic-warm/subhumid 313.aez#c.v05_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v05_rf1_x1 Tropic-warm/humid 314.aez#c.v05_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v05_rf3_x1 Tropic-warm/humid 314.aez#c.v05_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v05_rf5_x1 Tropic-warm/humid 314.aez#c.v05_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v05_rf1_x1 Tropic-cool/semiarid 322.aez#c.v05_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v05_rf3_x1 Tropic-cool/semiarid 322.aez#c.v05_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v05_rf5_x1 Tropic-cool/semiarid 322.aez#c.v05_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v05_rf1_x1 Tropic-cool/subhumid 323.aez#c.v05_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v05_rf3_x1 Tropic-cool/subhumid 323.aez#c.v05_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v05_rf5_x1 Tropic-cool/subhumid 323.aez#c.v05_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v05_rf1_x1 Tropic-cool/humid 324.aez#c.v05_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v05_rf3_x1 Tropic-cool/humid 324.aez#c.v05_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v05_rf5_x1 Tropic-cool/humid 324.aez#c.v05_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2011.year 2013.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* deviation in total
		esttab reg_v06_rf1_x1 reg_v06_rf2_x1 reg_v06_rf3_x1 reg_v06_rf4_x1 ///
			reg_v06_rf5_x1 reg_v06_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_totaldev_eth.tex", replace ///
			title(Deviation in Total Rainfall - Ethiopia) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v06_rf1_x1 Tropic-warm/semiarid 312.aez#c.v06_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v06_rf3_x1 Tropic-warm/semiarid 312.aez#c.v06_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v06_rf5_x1 Tropic-warm/semiarid 312.aez#c.v06_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v06_rf1_x1 Tropic-warm/subhumid 313.aez#c.v06_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v06_rf3_x1 Tropic-warm/subhumid 313.aez#c.v06_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v06_rf5_x1 Tropic-warm/subhumid 313.aez#c.v06_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v06_rf1_x1 Tropic-warm/humid 314.aez#c.v06_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v06_rf3_x1 Tropic-warm/humid 314.aez#c.v06_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v06_rf5_x1 Tropic-warm/humid 314.aez#c.v06_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v06_rf1_x1 Tropic-cool/semiarid 322.aez#c.v06_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v06_rf3_x1 Tropic-cool/semiarid 322.aez#c.v06_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v06_rf5_x1 Tropic-cool/semiarid 322.aez#c.v06_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v06_rf1_x1 Tropic-cool/subhumid 323.aez#c.v06_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v06_rf3_x1 Tropic-cool/subhumid 323.aez#c.v06_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v06_rf5_x1 Tropic-cool/subhumid 323.aez#c.v06_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v06_rf1_x1 Tropic-cool/humid 324.aez#c.v06_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v06_rf3_x1 Tropic-cool/humid 324.aez#c.v06_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v06_rf5_x1 Tropic-cool/humid 324.aez#c.v06_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2011.year 2013.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* z-score total
		esttab reg_v07_rf1_x1 reg_v07_rf2_x1 reg_v07_rf3_x1 reg_v07_rf4_x1 ///
			reg_v07_rf5_x1 reg_v07_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_totalz_eth.tex", replace ///
			title(Z-Score of Total Rainfall - Ethiopia) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v07_rf1_x1 Tropic-warm/semiarid 312.aez#c.v07_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v07_rf3_x1 Tropic-warm/semiarid 312.aez#c.v07_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v07_rf5_x1 Tropic-warm/semiarid 312.aez#c.v07_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v07_rf1_x1 Tropic-warm/subhumid 313.aez#c.v07_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v07_rf3_x1 Tropic-warm/subhumid 313.aez#c.v07_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v07_rf5_x1 Tropic-warm/subhumid 313.aez#c.v07_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v07_rf1_x1 Tropic-warm/humid 314.aez#c.v07_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v07_rf3_x1 Tropic-warm/humid 314.aez#c.v07_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v07_rf5_x1 Tropic-warm/humid 314.aez#c.v07_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v07_rf1_x1 Tropic-cool/semiarid 322.aez#c.v07_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v07_rf3_x1 Tropic-cool/semiarid 322.aez#c.v07_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v07_rf5_x1 Tropic-cool/semiarid 322.aez#c.v07_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v07_rf1_x1 Tropic-cool/subhumid 323.aez#c.v07_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v07_rf3_x1 Tropic-cool/subhumid 323.aez#c.v07_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v07_rf5_x1 Tropic-cool/subhumid 323.aez#c.v07_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v07_rf1_x1 Tropic-cool/humid 324.aez#c.v07_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v07_rf3_x1 Tropic-cool/humid 324.aez#c.v07_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v07_rf5_x1 Tropic-cool/humid 324.aez#c.v07_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2011.year 2013.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* rain days 
		esttab reg_v08_rf1_x1 reg_v08_rf2_x1 reg_v08_rf3_x1 reg_v08_rf4_x1 ///
			reg_v08_rf5_x1 reg_v08_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_raindays_eth.tex", replace ///
			title(Rain Days - Ethiopia) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v08_rf1_x1 Tropic-warm/semiarid 312.aez#c.v08_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v08_rf3_x1 Tropic-warm/semiarid 312.aez#c.v08_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v08_rf5_x1 Tropic-warm/semiarid 312.aez#c.v08_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v08_rf1_x1 Tropic-warm/subhumid 313.aez#c.v08_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v08_rf3_x1 Tropic-warm/subhumid 313.aez#c.v08_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v08_rf5_x1 Tropic-warm/subhumid 313.aez#c.v08_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v08_rf1_x1 Tropic-warm/humid 314.aez#c.v08_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v08_rf3_x1 Tropic-warm/humid 314.aez#c.v08_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v08_rf5_x1 Tropic-warm/humid 314.aez#c.v08_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v08_rf1_x1 Tropic-cool/semiarid 322.aez#c.v08_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v08_rf3_x1 Tropic-cool/semiarid 322.aez#c.v08_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v08_rf5_x1 Tropic-cool/semiarid 322.aez#c.v08_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v08_rf1_x1 Tropic-cool/subhumid 323.aez#c.v08_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v08_rf3_x1 Tropic-cool/subhumid 323.aez#c.v08_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v08_rf5_x1 Tropic-cool/subhumid 323.aez#c.v08_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v08_rf1_x1 Tropic-cool/humid 324.aez#c.v08_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v08_rf3_x1 Tropic-cool/humid 324.aez#c.v08_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v08_rf5_x1 Tropic-cool/humid 324.aez#c.v08_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2011.year 2013.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* deviation in rain days
		esttab reg_v09_rf1_x1 reg_v09_rf2_x1 reg_v09_rf3_x1 reg_v09_rf4_x1 ///
			reg_v09_rf5_x1 reg_v09_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_raindaysdev_eth.tex", replace ///
			title(Deviation in Rain Days - Ethiopia) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v09_rf1_x1 Tropic-warm/semiarid 312.aez#c.v09_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v09_rf3_x1 Tropic-warm/semiarid 312.aez#c.v09_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v09_rf5_x1 Tropic-warm/semiarid 312.aez#c.v09_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v09_rf1_x1 Tropic-warm/subhumid 313.aez#c.v09_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v09_rf3_x1 Tropic-warm/subhumid 313.aez#c.v09_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v09_rf5_x1 Tropic-warm/subhumid 313.aez#c.v09_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v09_rf1_x1 Tropic-warm/humid 314.aez#c.v09_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v09_rf3_x1 Tropic-warm/humid 314.aez#c.v09_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v09_rf5_x1 Tropic-warm/humid 314.aez#c.v09_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v09_rf1_x1 Tropic-cool/semiarid 322.aez#c.v09_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v09_rf3_x1 Tropic-cool/semiarid 322.aez#c.v09_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v09_rf5_x1 Tropic-cool/semiarid 322.aez#c.v09_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v09_rf1_x1 Tropic-cool/subhumid 323.aez#c.v09_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v09_rf3_x1 Tropic-cool/subhumid 323.aez#c.v09_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v09_rf5_x1 Tropic-cool/subhumid 323.aez#c.v09_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v09_rf1_x1 Tropic-cool/humid 324.aez#c.v09_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v09_rf3_x1 Tropic-cool/humid 324.aez#c.v09_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v09_rf5_x1 Tropic-cool/humid 324.aez#c.v09_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2011.year 2013.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* no rain days
		esttab reg_v10_rf1_x1 reg_v10_rf2_x1 reg_v10_rf3_x1 reg_v10_rf4_x1 ///
			reg_v10_rf5_x1 reg_v10_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_norain_eth.tex", replace ///
			title(No-Rain Days - Ethiopia) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v10_rf1_x1 Tropic-warm/semiarid 312.aez#c.v10_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v10_rf3_x1 Tropic-warm/semiarid 312.aez#c.v10_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v10_rf5_x1 Tropic-warm/semiarid 312.aez#c.v10_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v10_rf1_x1 Tropic-warm/subhumid 313.aez#c.v10_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v10_rf3_x1 Tropic-warm/subhumid 313.aez#c.v10_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v10_rf5_x1 Tropic-warm/subhumid 313.aez#c.v10_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v10_rf1_x1 Tropic-warm/humid 314.aez#c.v10_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v10_rf3_x1 Tropic-warm/humid 314.aez#c.v10_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v10_rf5_x1 Tropic-warm/humid 314.aez#c.v10_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v10_rf1_x1 Tropic-cool/semiarid 322.aez#c.v10_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v10_rf3_x1 Tropic-cool/semiarid 322.aez#c.v10_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v10_rf5_x1 Tropic-cool/semiarid 322.aez#c.v10_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v10_rf1_x1 Tropic-cool/subhumid 323.aez#c.v10_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v10_rf3_x1 Tropic-cool/subhumid 323.aez#c.v10_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v10_rf5_x1 Tropic-cool/subhumid 323.aez#c.v10_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v10_rf1_x1 Tropic-cool/humid 324.aez#c.v10_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v10_rf3_x1 Tropic-cool/humid 324.aez#c.v10_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v10_rf5_x1 Tropic-cool/humid 324.aez#c.v10_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2011.year 2013.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* deviation in no rain days
		esttab reg_v11_rf1_x1 reg_v11_rf2_x1 reg_v11_rf3_x1 reg_v11_rf4_x1 ///
			reg_v11_rf5_x1 reg_v11_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_noraindev_eth.tex", replace ///
			title(Deviation in No-Rain Days - Ethiopia) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v11_rf1_x1 Tropic-warm/semiarid 312.aez#c.v11_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v11_rf3_x1 Tropic-warm/semiarid 312.aez#c.v11_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v11_rf5_x1 Tropic-warm/semiarid 312.aez#c.v11_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v11_rf1_x1 Tropic-warm/subhumid 313.aez#c.v11_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v11_rf3_x1 Tropic-warm/subhumid 313.aez#c.v11_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v11_rf5_x1 Tropic-warm/subhumid 313.aez#c.v11_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v11_rf1_x1 Tropic-warm/humid 314.aez#c.v11_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v11_rf3_x1 Tropic-warm/humid 314.aez#c.v11_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v11_rf5_x1 Tropic-warm/humid 314.aez#c.v11_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v11_rf1_x1 Tropic-cool/semiarid 322.aez#c.v11_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v11_rf3_x1 Tropic-cool/semiarid 322.aez#c.v11_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v11_rf5_x1 Tropic-cool/semiarid 322.aez#c.v11_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v11_rf1_x1 Tropic-cool/subhumid 323.aez#c.v11_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v11_rf3_x1 Tropic-cool/subhumid 323.aez#c.v11_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v11_rf5_x1 Tropic-cool/subhumid 323.aez#c.v11_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v11_rf1_x1 Tropic-cool/humid 324.aez#c.v11_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v11_rf3_x1 Tropic-cool/humid 324.aez#c.v11_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v11_rf5_x1 Tropic-cool/humid 324.aez#c.v11_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2011.year 2013.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* rain days percent
		esttab reg_v12_rf1_x1 reg_v12_rf2_x1 reg_v12_rf3_x1 reg_v12_rf4_x1 ///
			reg_v12_rf5_x1 reg_v12_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_percentraindays_eth.tex", replace ///
			title(Percentage of Rain Days - Ethiopia) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v12_rf1_x1 Tropic-warm/semiarid 312.aez#c.v12_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v12_rf3_x1 Tropic-warm/semiarid 312.aez#c.v12_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v12_rf5_x1 Tropic-warm/semiarid 312.aez#c.v12_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v12_rf1_x1 Tropic-warm/subhumid 313.aez#c.v12_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v12_rf3_x1 Tropic-warm/subhumid 313.aez#c.v12_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v12_rf5_x1 Tropic-warm/subhumid 313.aez#c.v12_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v12_rf1_x1 Tropic-warm/humid 314.aez#c.v12_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v12_rf3_x1 Tropic-warm/humid 314.aez#c.v12_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v12_rf5_x1 Tropic-warm/humid 314.aez#c.v12_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v12_rf1_x1 Tropic-cool/semiarid 322.aez#c.v12_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v12_rf3_x1 Tropic-cool/semiarid 322.aez#c.v12_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v12_rf5_x1 Tropic-cool/semiarid 322.aez#c.v12_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v12_rf1_x1 Tropic-cool/subhumid 323.aez#c.v12_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v12_rf3_x1 Tropic-cool/subhumid 323.aez#c.v12_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v12_rf5_x1 Tropic-cool/subhumid 323.aez#c.v12_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v12_rf1_x1 Tropic-cool/humid 324.aez#c.v12_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v12_rf3_x1 Tropic-cool/humid 324.aez#c.v12_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v12_rf5_x1 Tropic-cool/humid 324.aez#c.v12_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2011.year 2013.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* deviation in raindays percent
		esttab reg_v13_rf1_x1 reg_v13_rf2_x1 reg_v13_rf3_x1 reg_v13_rf4_x1 ///
			reg_v13_rf5_x1 reg_v13_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_percentraindaysdev_eth.tex", replace ///
			title(Deviation in Percent Rain Days - Ethiopia) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v13_rf1_x1 Tropic-warm/semiarid 312.aez#c.v13_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v13_rf3_x1 Tropic-warm/semiarid 312.aez#c.v13_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v13_rf5_x1 Tropic-warm/semiarid 312.aez#c.v13_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v13_rf1_x1 Tropic-warm/subhumid 313.aez#c.v13_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v13_rf3_x1 Tropic-warm/subhumid 313.aez#c.v13_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v13_rf5_x1 Tropic-warm/subhumid 313.aez#c.v13_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v13_rf1_x1 Tropic-warm/humid 314.aez#c.v13_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v13_rf3_x1 Tropic-warm/humid 314.aez#c.v13_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v13_rf5_x1 Tropic-warm/humid 314.aez#c.v13_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v13_rf1_x1 Tropic-cool/semiarid 322.aez#c.v13_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v13_rf3_x1 Tropic-cool/semiarid 322.aez#c.v13_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v13_rf5_x1 Tropic-cool/semiarid 322.aez#c.v13_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v13_rf1_x1 Tropic-cool/subhumid 323.aez#c.v13_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v13_rf3_x1 Tropic-cool/subhumid 323.aez#c.v13_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v13_rf5_x1 Tropic-cool/subhumid 323.aez#c.v13_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v13_rf1_x1 Tropic-cool/humid 324.aez#c.v13_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v13_rf3_x1 Tropic-cool/humid 324.aez#c.v13_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v13_rf5_x1 Tropic-cool/humid 324.aez#c.v13_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2011.year 2013.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* longest dry spell
		esttab reg_v14_rf1_x1 reg_v14_rf2_x1 reg_v14_rf3_x1 reg_v14_rf4_x1 ///
			reg_v14_rf5_x1 reg_v14_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_dry_eth.tex", replace ///
			title(Longest Dry Spell - Ethiopia) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v14_rf1_x1 Tropic-warm/semiarid 312.aez#c.v14_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v14_rf3_x1 Tropic-warm/semiarid 312.aez#c.v14_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v14_rf5_x1 Tropic-warm/semiarid 312.aez#c.v14_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v14_rf1_x1 Tropic-warm/subhumid 313.aez#c.v14_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v14_rf3_x1 Tropic-warm/subhumid 313.aez#c.v14_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v14_rf5_x1 Tropic-warm/subhumid 313.aez#c.v14_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v14_rf1_x1 Tropic-warm/humid 314.aez#c.v14_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v14_rf3_x1 Tropic-warm/humid 314.aez#c.v14_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v14_rf5_x1 Tropic-warm/humid 314.aez#c.v14_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v14_rf1_x1 Tropic-cool/semiarid 322.aez#c.v14_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v14_rf3_x1 Tropic-cool/semiarid 322.aez#c.v14_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v14_rf5_x1 Tropic-cool/semiarid 322.aez#c.v14_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v14_rf1_x1 Tropic-cool/subhumid 323.aez#c.v14_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v14_rf3_x1 Tropic-cool/subhumid 323.aez#c.v14_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v14_rf5_x1 Tropic-cool/subhumid 323.aez#c.v14_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v14_rf1_x1 Tropic-cool/humid 324.aez#c.v14_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v14_rf3_x1 Tropic-cool/humid 324.aez#c.v14_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v14_rf5_x1 Tropic-cool/humid 324.aez#c.v14_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2011.year 2013.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
	
*build tables, eth temperature	
	* mean
		esttab 	reg_v15_tp1_x1 reg_v15_tp2_x1 reg_v15_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_mean_eth.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Mean Daily Temperature - Ethiopia) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v15_tp1_x1 Tropic-warm/semiarid 312.aez#c.v15_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v15_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v15_tp1_x1 Tropic-warm/subhumid 313.aez#c.v15_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v15_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v15_tp1_x1 Tropic-warm/humid 314.aez#c.v15_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v15_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v15_tp1_x1 Tropic-cool/semiarid  322.aez#c.v15_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v15_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v15_tp1_x1 Tropic-cool/subhumid  323.aez#c.v15_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v15_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v15_tp1_x1 Tropic-cool/humid  324.aez#c.v15_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v15_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2011.year 2013.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* median
		esttab 	reg_v16_tp1_x1 reg_v16_tp2_x1 reg_v16_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_median_eth.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Median Daily Temperature - Ethiopia) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v16_tp1_x1 Tropic-warm/semiarid 312.aez#c.v16_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v16_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v16_tp1_x1 Tropic-warm/subhumid 313.aez#c.v16_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v16_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v16_tp1_x1 Tropic-warm/humid 314.aez#c.v16_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v16_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v16_tp1_x1 Tropic-cool/semiarid  322.aez#c.v16_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v16_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v16_tp1_x1 Tropic-cool/subhumid  323.aez#c.v16_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v16_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v16_tp1_x1 Tropic-cool/humid  324.aez#c.v16_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v16_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2011.year 2013.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* variance
		esttab 	reg_v17_tp1_x1 reg_v17_tp2_x1 reg_v17_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_variance_eth.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Variance of Daily Temperature - Ethiopia) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v17_tp1_x1 Tropic-warm/semiarid 312.aez#c.v17_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v17_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v17_tp1_x1 Tropic-warm/subhumid 313.aez#c.v17_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v17_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v17_tp1_x1 Tropic-warm/humid 314.aez#c.v17_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v17_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v17_tp1_x1 Tropic-cool/semiarid  322.aez#c.v17_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v17_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v17_tp1_x1 Tropic-cool/subhumid  323.aez#c.v17_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v17_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v17_tp1_x1 Tropic-cool/humid  324.aez#c.v17_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v17_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2011.year 2013.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* skew
		esttab 	reg_v18_tp1_x1 reg_v18_tp2_x1 reg_v18_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_skew_eth.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Skew of Daily Temperature - Ethiopia) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v18_tp1_x1 Tropic-warm/semiarid 312.aez#c.v18_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v18_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v18_tp1_x1 Tropic-warm/subhumid 313.aez#c.v18_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v18_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v18_tp1_x1 Tropic-warm/humid 314.aez#c.v18_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v18_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v18_tp1_x1 Tropic-cool/semiarid  322.aez#c.v18_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v18_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v18_tp1_x1 Tropic-cool/subhumid  323.aez#c.v18_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v18_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v18_tp1_x1 Tropic-cool/humid  324.aez#c.v18_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v18_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2011.year 2013.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* growing degree days
		esttab 	reg_v19_tp1_x1 reg_v19_tp2_x1 reg_v19_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_gdd_eth.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Growing Degree Days - Ethiopia) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v19_tp1_x1 Tropic-warm/semiarid 312.aez#c.v19_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v19_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v19_tp1_x1 Tropic-warm/subhumid 313.aez#c.v19_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v19_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v19_tp1_x1 Tropic-warm/humid 314.aez#c.v19_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v19_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v19_tp1_x1 Tropic-cool/semiarid  322.aez#c.v19_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v19_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v19_tp1_x1 Tropic-cool/subhumid  323.aez#c.v19_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v19_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v19_tp1_x1 Tropic-cool/humid  324.aez#c.v19_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v19_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2011.year 2013.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* deviation in gdd
		esttab 	reg_v20_tp1_x1 reg_v20_tp2_x1 reg_v20_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_gdddev_eth.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Deviation in GDD - Ethiopia) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v20_tp1_x1 Tropic-warm/semiarid 312.aez#c.v20_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v20_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v20_tp1_x1 Tropic-warm/subhumid 313.aez#c.v20_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v20_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v20_tp1_x1 Tropic-warm/humid 314.aez#c.v20_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v20_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v20_tp1_x1 Tropic-cool/semiarid  322.aez#c.v20_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v20_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v20_tp1_x1 Tropic-cool/subhumid  323.aez#c.v20_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v20_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v20_tp1_x1 Tropic-cool/humid  324.aez#c.v20_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v20_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2011.year 2013.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* z-score of gdd
		esttab 	reg_v21_tp1_x1 reg_v21_tp2_x1 reg_v21_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_gddz_eth.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Z-Score of GDD - Ethiopia) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v21_tp1_x1 Tropic-warm/semiarid 312.aez#c.v21_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v21_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v21_tp1_x1 Tropic-warm/subhumid 313.aez#c.v21_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v21_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v21_tp1_x1 Tropic-warm/humid 314.aez#c.v21_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v21_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v21_tp1_x1 Tropic-cool/semiarid  322.aez#c.v21_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v21_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v21_tp1_x1 Tropic-cool/subhumid  323.aez#c.v21_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v21_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v21_tp1_x1 Tropic-cool/humid  324.aez#c.v21_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v21_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2011.year 2013.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* max
		esttab 	reg_v22_tp1_x1 reg_v22_tp2_x1 reg_v22_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_max_eth.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Maximum Daily Temperature - Ethiopia) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v22_tp1_x1 Tropic-warm/semiarid 312.aez#c.v22_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v22_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v22_tp1_x1 Tropic-warm/subhumid 313.aez#c.v22_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v22_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v22_tp1_x1 Tropic-warm/humid 314.aez#c.v22_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v22_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v22_tp1_x1 Tropic-cool/semiarid  322.aez#c.v22_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v22_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v22_tp1_x1 Tropic-cool/subhumid  323.aez#c.v22_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v22_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v22_tp1_x1 Tropic-cool/humid  324.aez#c.v22_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v22_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2011.year 2013.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
				
		restore
		
***************************************************MALAWI****************************************************		
		
* preserve only one country - Malawi
		preserve
		drop 		if country != 2
		
	* weather metrics			
		foreach 	v of varlist `weather' { 
		    
		* define locals for naming conventions
			loc 	sat = 	substr("`v'", 5, 3)
			loc 	varn = 	substr("`v'", 1, 3)
			
		* Y = \omega W + \pi X + \alpha_{h} + \gamma_{t} + u_{ht}
			reg 		lncp_yld c.`v'#i.aez `inputscp' i.year, vce(cluster hhid)
			eststo		reg_`v'
			
}			

*build tables, mwi rainfall
	* mean
		esttab reg_v01_rf1_x1 reg_v01_rf2_x1 reg_v01_rf3_x1 reg_v01_rf4_x1 ///
			reg_v01_rf5_x1 reg_v01_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_mean_mwi.tex", replace ///
			title(Mean Daily Rainfall - Malawi) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v01_rf1_x1 Tropic-warm/semiarid 312.aez#c.v01_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v01_rf3_x1 Tropic-warm/semiarid 312.aez#c.v01_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v01_rf5_x1 Tropic-warm/semiarid 312.aez#c.v01_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v01_rf1_x1 Tropic-warm/subhumid 313.aez#c.v01_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v01_rf3_x1 Tropic-warm/subhumid 313.aez#c.v01_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v01_rf5_x1 Tropic-warm/subhumid 313.aez#c.v01_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v01_rf1_x1 Tropic-warm/humid 314.aez#c.v01_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v01_rf3_x1 Tropic-warm/humid 314.aez#c.v01_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v01_rf5_x1 Tropic-warm/humid 314.aez#c.v01_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v01_rf1_x1 Tropic-cool/semiarid 322.aez#c.v01_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v01_rf3_x1 Tropic-cool/semiarid 322.aez#c.v01_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v01_rf5_x1 Tropic-cool/semiarid 322.aez#c.v01_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v01_rf1_x1 Tropic-cool/subhumid 323.aez#c.v01_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v01_rf3_x1 Tropic-cool/subhumid 323.aez#c.v01_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v01_rf5_x1 Tropic-cool/subhumid 323.aez#c.v01_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v01_rf1_x1 Tropic-cool/humid 324.aez#c.v01_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v01_rf3_x1 Tropic-cool/humid 324.aez#c.v01_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v01_rf5_x1 Tropic-cool/humid 324.aez#c.v01_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2012.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* median
		esttab reg_v02_rf1_x1 reg_v02_rf2_x1 reg_v02_rf3_x1 reg_v02_rf4_x1 ///
			reg_v02_rf5_x1 reg_v02_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_median_mwi.tex", replace ///
			title(Median Daily Rainfall - Malawi) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v02_rf1_x1 Tropic-warm/semiarid 312.aez#c.v02_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v02_rf3_x1 Tropic-warm/semiarid 312.aez#c.v02_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v02_rf5_x1 Tropic-warm/semiarid 312.aez#c.v02_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v02_rf1_x1 Tropic-warm/subhumid 313.aez#c.v02_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v02_rf3_x1 Tropic-warm/subhumid 313.aez#c.v02_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v02_rf5_x1 Tropic-warm/subhumid 313.aez#c.v02_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v02_rf1_x1 Tropic-warm/humid 314.aez#c.v02_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v02_rf3_x1 Tropic-warm/humid 314.aez#c.v02_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v02_rf5_x1 Tropic-warm/humid 314.aez#c.v02_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v02_rf1_x1 Tropic-cool/semiarid 322.aez#c.v02_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v02_rf3_x1 Tropic-cool/semiarid 322.aez#c.v02_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v02_rf5_x1 Tropic-cool/semiarid 322.aez#c.v02_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v02_rf1_x1 Tropic-cool/subhumid 323.aez#c.v02_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v02_rf3_x1 Tropic-cool/subhumid 323.aez#c.v02_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v02_rf5_x1 Tropic-cool/subhumid 323.aez#c.v02_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v02_rf1_x1 Tropic-cool/humid 324.aez#c.v02_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v02_rf3_x1 Tropic-cool/humid 324.aez#c.v02_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v02_rf5_x1 Tropic-cool/humid 324.aez#c.v02_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2012.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* variance
		esttab reg_v03_rf1_x1 reg_v03_rf2_x1 reg_v03_rf3_x1 reg_v03_rf4_x1 ///
			reg_v03_rf5_x1 reg_v03_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_var_mwi.tex", replace ///
			title(Variance of Daily Rainfall - Malawi) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v03_rf1_x1 Tropic-warm/semiarid 312.aez#c.v03_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v03_rf3_x1 Tropic-warm/semiarid 312.aez#c.v03_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v03_rf5_x1 Tropic-warm/semiarid 312.aez#c.v03_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v03_rf1_x1 Tropic-warm/subhumid 313.aez#c.v03_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v03_rf3_x1 Tropic-warm/subhumid 313.aez#c.v03_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v03_rf5_x1 Tropic-warm/subhumid 313.aez#c.v03_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v03_rf1_x1 Tropic-warm/humid 314.aez#c.v03_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v03_rf3_x1 Tropic-warm/humid 314.aez#c.v03_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v03_rf5_x1 Tropic-warm/humid 314.aez#c.v03_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v03_rf1_x1 Tropic-cool/semiarid 322.aez#c.v03_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v03_rf3_x1 Tropic-cool/semiarid 322.aez#c.v03_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v03_rf5_x1 Tropic-cool/semiarid 322.aez#c.v03_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v03_rf1_x1 Tropic-cool/subhumid 323.aez#c.v03_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v03_rf3_x1 Tropic-cool/subhumid 323.aez#c.v03_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v03_rf5_x1 Tropic-cool/subhumid 323.aez#c.v03_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v03_rf1_x1 Tropic-cool/humid 324.aez#c.v03_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v03_rf3_x1 Tropic-cool/humid 324.aez#c.v03_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v03_rf5_x1 Tropic-cool/humid 324.aez#c.v03_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2012.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* skew
		esttab reg_v04_rf1_x1 reg_v04_rf2_x1 reg_v04_rf3_x1 reg_v04_rf4_x1 ///
			reg_v04_rf5_x1 reg_v04_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_skew_mwi.tex", replace ///
			title(Skew of Daily Rainfall - Malawi) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v04_rf1_x1 Tropic-warm/semiarid 312.aez#c.v04_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v04_rf3_x1 Tropic-warm/semiarid 312.aez#c.v04_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v04_rf5_x1 Tropic-warm/semiarid 312.aez#c.v04_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v04_rf1_x1 Tropic-warm/subhumid 313.aez#c.v04_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v04_rf3_x1 Tropic-warm/subhumid 313.aez#c.v04_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v04_rf5_x1 Tropic-warm/subhumid 313.aez#c.v04_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v04_rf1_x1 Tropic-warm/humid 314.aez#c.v04_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v04_rf3_x1 Tropic-warm/humid 314.aez#c.v04_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v04_rf5_x1 Tropic-warm/humid 314.aez#c.v04_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v04_rf1_x1 Tropic-cool/semiarid 322.aez#c.v04_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v04_rf3_x1 Tropic-cool/semiarid 322.aez#c.v04_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v04_rf5_x1 Tropic-cool/semiarid 322.aez#c.v04_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v04_rf1_x1 Tropic-cool/subhumid 323.aez#c.v04_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v04_rf3_x1 Tropic-cool/subhumid 323.aez#c.v04_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v04_rf5_x1 Tropic-cool/subhumid 323.aez#c.v04_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v04_rf1_x1 Tropic-cool/humid 324.aez#c.v04_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v04_rf3_x1 Tropic-cool/humid 324.aez#c.v04_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v04_rf5_x1 Tropic-cool/humid 324.aez#c.v04_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2012.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* total
		esttab reg_v05_rf1_x1 reg_v05_rf2_x1 reg_v05_rf3_x1 reg_v05_rf4_x1 ///
			reg_v05_rf5_x1 reg_v05_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_total_mwi.tex", replace ///
			title(Total Rainfall - Malawi) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v05_rf1_x1 Tropic-warm/semiarid 312.aez#c.v05_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v05_rf3_x1 Tropic-warm/semiarid 312.aez#c.v05_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v05_rf5_x1 Tropic-warm/semiarid 312.aez#c.v05_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v05_rf1_x1 Tropic-warm/subhumid 313.aez#c.v05_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v05_rf3_x1 Tropic-warm/subhumid 313.aez#c.v05_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v05_rf5_x1 Tropic-warm/subhumid 313.aez#c.v05_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v05_rf1_x1 Tropic-warm/humid 314.aez#c.v05_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v05_rf3_x1 Tropic-warm/humid 314.aez#c.v05_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v05_rf5_x1 Tropic-warm/humid 314.aez#c.v05_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v05_rf1_x1 Tropic-cool/semiarid 322.aez#c.v05_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v05_rf3_x1 Tropic-cool/semiarid 322.aez#c.v05_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v05_rf5_x1 Tropic-cool/semiarid 322.aez#c.v05_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v05_rf1_x1 Tropic-cool/subhumid 323.aez#c.v05_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v05_rf3_x1 Tropic-cool/subhumid 323.aez#c.v05_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v05_rf5_x1 Tropic-cool/subhumid 323.aez#c.v05_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v05_rf1_x1 Tropic-cool/humid 324.aez#c.v05_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v05_rf3_x1 Tropic-cool/humid 324.aez#c.v05_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v05_rf5_x1 Tropic-cool/humid 324.aez#c.v05_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2012.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* deviation in total
		esttab reg_v06_rf1_x1 reg_v06_rf2_x1 reg_v06_rf3_x1 reg_v06_rf4_x1 ///
			reg_v06_rf5_x1 reg_v06_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_totaldev_mwi.tex", replace ///
			title(Deviation in Total Rainfall - Malawi) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v06_rf1_x1 Tropic-warm/semiarid 312.aez#c.v06_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v06_rf3_x1 Tropic-warm/semiarid 312.aez#c.v06_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v06_rf5_x1 Tropic-warm/semiarid 312.aez#c.v06_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v06_rf1_x1 Tropic-warm/subhumid 313.aez#c.v06_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v06_rf3_x1 Tropic-warm/subhumid 313.aez#c.v06_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v06_rf5_x1 Tropic-warm/subhumid 313.aez#c.v06_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v06_rf1_x1 Tropic-warm/humid 314.aez#c.v06_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v06_rf3_x1 Tropic-warm/humid 314.aez#c.v06_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v06_rf5_x1 Tropic-warm/humid 314.aez#c.v06_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v06_rf1_x1 Tropic-cool/semiarid 322.aez#c.v06_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v06_rf3_x1 Tropic-cool/semiarid 322.aez#c.v06_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v06_rf5_x1 Tropic-cool/semiarid 322.aez#c.v06_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v06_rf1_x1 Tropic-cool/subhumid 323.aez#c.v06_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v06_rf3_x1 Tropic-cool/subhumid 323.aez#c.v06_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v06_rf5_x1 Tropic-cool/subhumid 323.aez#c.v06_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v06_rf1_x1 Tropic-cool/humid 324.aez#c.v06_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v06_rf3_x1 Tropic-cool/humid 324.aez#c.v06_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v06_rf5_x1 Tropic-cool/humid 324.aez#c.v06_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2012.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* z-score total
		esttab reg_v07_rf1_x1 reg_v07_rf2_x1 reg_v07_rf3_x1 reg_v07_rf4_x1 ///
			reg_v07_rf5_x1 reg_v07_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_totalz_mwi.tex", replace ///
			title(Z-Score of Total Rainfall - Malawi) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v07_rf1_x1 Tropic-warm/semiarid 312.aez#c.v07_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v07_rf3_x1 Tropic-warm/semiarid 312.aez#c.v07_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v07_rf5_x1 Tropic-warm/semiarid 312.aez#c.v07_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v07_rf1_x1 Tropic-warm/subhumid 313.aez#c.v07_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v07_rf3_x1 Tropic-warm/subhumid 313.aez#c.v07_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v07_rf5_x1 Tropic-warm/subhumid 313.aez#c.v07_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v07_rf1_x1 Tropic-warm/humid 314.aez#c.v07_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v07_rf3_x1 Tropic-warm/humid 314.aez#c.v07_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v07_rf5_x1 Tropic-warm/humid 314.aez#c.v07_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v07_rf1_x1 Tropic-cool/semiarid 322.aez#c.v07_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v07_rf3_x1 Tropic-cool/semiarid 322.aez#c.v07_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v07_rf5_x1 Tropic-cool/semiarid 322.aez#c.v07_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v07_rf1_x1 Tropic-cool/subhumid 323.aez#c.v07_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v07_rf3_x1 Tropic-cool/subhumid 323.aez#c.v07_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v07_rf5_x1 Tropic-cool/subhumid 323.aez#c.v07_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v07_rf1_x1 Tropic-cool/humid 324.aez#c.v07_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v07_rf3_x1 Tropic-cool/humid 324.aez#c.v07_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v07_rf5_x1 Tropic-cool/humid 324.aez#c.v07_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2012.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* rain days 
		esttab reg_v08_rf1_x1 reg_v08_rf2_x1 reg_v08_rf3_x1 reg_v08_rf4_x1 ///
			reg_v08_rf5_x1 reg_v08_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_raindays_mwi.tex", replace ///
			title(Rain Days - Malawi) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v08_rf1_x1 Tropic-warm/semiarid 312.aez#c.v08_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v08_rf3_x1 Tropic-warm/semiarid 312.aez#c.v08_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v08_rf5_x1 Tropic-warm/semiarid 312.aez#c.v08_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v08_rf1_x1 Tropic-warm/subhumid 313.aez#c.v08_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v08_rf3_x1 Tropic-warm/subhumid 313.aez#c.v08_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v08_rf5_x1 Tropic-warm/subhumid 313.aez#c.v08_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v08_rf1_x1 Tropic-warm/humid 314.aez#c.v08_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v08_rf3_x1 Tropic-warm/humid 314.aez#c.v08_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v08_rf5_x1 Tropic-warm/humid 314.aez#c.v08_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v08_rf1_x1 Tropic-cool/semiarid 322.aez#c.v08_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v08_rf3_x1 Tropic-cool/semiarid 322.aez#c.v08_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v08_rf5_x1 Tropic-cool/semiarid 322.aez#c.v08_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v08_rf1_x1 Tropic-cool/subhumid 323.aez#c.v08_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v08_rf3_x1 Tropic-cool/subhumid 323.aez#c.v08_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v08_rf5_x1 Tropic-cool/subhumid 323.aez#c.v08_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v08_rf1_x1 Tropic-cool/humid 324.aez#c.v08_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v08_rf3_x1 Tropic-cool/humid 324.aez#c.v08_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v08_rf5_x1 Tropic-cool/humid 324.aez#c.v08_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2012.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* deviation in rain days
		esttab reg_v09_rf1_x1 reg_v09_rf2_x1 reg_v09_rf3_x1 reg_v09_rf4_x1 ///
			reg_v09_rf5_x1 reg_v09_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_raindaysdev_mwi.tex", replace ///
			title(Deviation in Rain Days - Malawi) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v09_rf1_x1 Tropic-warm/semiarid 312.aez#c.v09_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v09_rf3_x1 Tropic-warm/semiarid 312.aez#c.v09_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v09_rf5_x1 Tropic-warm/semiarid 312.aez#c.v09_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v09_rf1_x1 Tropic-warm/subhumid 313.aez#c.v09_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v09_rf3_x1 Tropic-warm/subhumid 313.aez#c.v09_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v09_rf5_x1 Tropic-warm/subhumid 313.aez#c.v09_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v09_rf1_x1 Tropic-warm/humid 314.aez#c.v09_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v09_rf3_x1 Tropic-warm/humid 314.aez#c.v09_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v09_rf5_x1 Tropic-warm/humid 314.aez#c.v09_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v09_rf1_x1 Tropic-cool/semiarid 322.aez#c.v09_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v09_rf3_x1 Tropic-cool/semiarid 322.aez#c.v09_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v09_rf5_x1 Tropic-cool/semiarid 322.aez#c.v09_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v09_rf1_x1 Tropic-cool/subhumid 323.aez#c.v09_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v09_rf3_x1 Tropic-cool/subhumid 323.aez#c.v09_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v09_rf5_x1 Tropic-cool/subhumid 323.aez#c.v09_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v09_rf1_x1 Tropic-cool/humid 324.aez#c.v09_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v09_rf3_x1 Tropic-cool/humid 324.aez#c.v09_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v09_rf5_x1 Tropic-cool/humid 324.aez#c.v09_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2012.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* no rain days
		esttab reg_v10_rf1_x1 reg_v10_rf2_x1 reg_v10_rf3_x1 reg_v10_rf4_x1 ///
			reg_v10_rf5_x1 reg_v10_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_norain_mwi.tex", replace ///
			title(No-Rain Days - Malawi) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v10_rf1_x1 Tropic-warm/semiarid 312.aez#c.v10_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v10_rf3_x1 Tropic-warm/semiarid 312.aez#c.v10_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v10_rf5_x1 Tropic-warm/semiarid 312.aez#c.v10_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v10_rf1_x1 Tropic-warm/subhumid 313.aez#c.v10_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v10_rf3_x1 Tropic-warm/subhumid 313.aez#c.v10_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v10_rf5_x1 Tropic-warm/subhumid 313.aez#c.v10_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v10_rf1_x1 Tropic-warm/humid 314.aez#c.v10_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v10_rf3_x1 Tropic-warm/humid 314.aez#c.v10_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v10_rf5_x1 Tropic-warm/humid 314.aez#c.v10_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v10_rf1_x1 Tropic-cool/semiarid 322.aez#c.v10_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v10_rf3_x1 Tropic-cool/semiarid 322.aez#c.v10_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v10_rf5_x1 Tropic-cool/semiarid 322.aez#c.v10_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v10_rf1_x1 Tropic-cool/subhumid 323.aez#c.v10_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v10_rf3_x1 Tropic-cool/subhumid 323.aez#c.v10_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v10_rf5_x1 Tropic-cool/subhumid 323.aez#c.v10_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v10_rf1_x1 Tropic-cool/humid 324.aez#c.v10_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v10_rf3_x1 Tropic-cool/humid 324.aez#c.v10_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v10_rf5_x1 Tropic-cool/humid 324.aez#c.v10_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2012.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* deviation in no rain days
		esttab reg_v11_rf1_x1 reg_v11_rf2_x1 reg_v11_rf3_x1 reg_v11_rf4_x1 ///
			reg_v11_rf5_x1 reg_v11_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_noraindev_mwi.tex", replace ///
			title(Deviation in No-Rain Days - Malawi) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v11_rf1_x1 Tropic-warm/semiarid 312.aez#c.v11_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v11_rf3_x1 Tropic-warm/semiarid 312.aez#c.v11_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v11_rf5_x1 Tropic-warm/semiarid 312.aez#c.v11_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v11_rf1_x1 Tropic-warm/subhumid 313.aez#c.v11_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v11_rf3_x1 Tropic-warm/subhumid 313.aez#c.v11_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v11_rf5_x1 Tropic-warm/subhumid 313.aez#c.v11_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v11_rf1_x1 Tropic-warm/humid 314.aez#c.v11_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v11_rf3_x1 Tropic-warm/humid 314.aez#c.v11_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v11_rf5_x1 Tropic-warm/humid 314.aez#c.v11_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v11_rf1_x1 Tropic-cool/semiarid 322.aez#c.v11_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v11_rf3_x1 Tropic-cool/semiarid 322.aez#c.v11_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v11_rf5_x1 Tropic-cool/semiarid 322.aez#c.v11_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v11_rf1_x1 Tropic-cool/subhumid 323.aez#c.v11_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v11_rf3_x1 Tropic-cool/subhumid 323.aez#c.v11_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v11_rf5_x1 Tropic-cool/subhumid 323.aez#c.v11_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v11_rf1_x1 Tropic-cool/humid 324.aez#c.v11_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v11_rf3_x1 Tropic-cool/humid 324.aez#c.v11_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v11_rf5_x1 Tropic-cool/humid 324.aez#c.v11_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2012.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* rain days percent
		esttab reg_v12_rf1_x1 reg_v12_rf2_x1 reg_v12_rf3_x1 reg_v12_rf4_x1 ///
			reg_v12_rf5_x1 reg_v12_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_percentraindays_mwi.tex", replace ///
			title(Percentage of Rain Days - Malawi) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v12_rf1_x1 Tropic-warm/semiarid 312.aez#c.v12_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v12_rf3_x1 Tropic-warm/semiarid 312.aez#c.v12_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v12_rf5_x1 Tropic-warm/semiarid 312.aez#c.v12_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v12_rf1_x1 Tropic-warm/subhumid 313.aez#c.v12_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v12_rf3_x1 Tropic-warm/subhumid 313.aez#c.v12_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v12_rf5_x1 Tropic-warm/subhumid 313.aez#c.v12_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v12_rf1_x1 Tropic-warm/humid 314.aez#c.v12_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v12_rf3_x1 Tropic-warm/humid 314.aez#c.v12_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v12_rf5_x1 Tropic-warm/humid 314.aez#c.v12_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v12_rf1_x1 Tropic-cool/semiarid 322.aez#c.v12_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v12_rf3_x1 Tropic-cool/semiarid 322.aez#c.v12_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v12_rf5_x1 Tropic-cool/semiarid 322.aez#c.v12_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v12_rf1_x1 Tropic-cool/subhumid 323.aez#c.v12_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v12_rf3_x1 Tropic-cool/subhumid 323.aez#c.v12_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v12_rf5_x1 Tropic-cool/subhumid 323.aez#c.v12_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v12_rf1_x1 Tropic-cool/humid 324.aez#c.v12_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v12_rf3_x1 Tropic-cool/humid 324.aez#c.v12_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v12_rf5_x1 Tropic-cool/humid 324.aez#c.v12_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2012.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* deviation in raindays percent
		esttab reg_v13_rf1_x1 reg_v13_rf2_x1 reg_v13_rf3_x1 reg_v13_rf4_x1 ///
			reg_v13_rf5_x1 reg_v13_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_percentraindaysdev_mwi.tex", replace ///
			title(Deviation in Percent Rain Days - Malawi) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v13_rf1_x1 Tropic-warm/semiarid 312.aez#c.v13_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v13_rf3_x1 Tropic-warm/semiarid 312.aez#c.v13_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v13_rf5_x1 Tropic-warm/semiarid 312.aez#c.v13_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v13_rf1_x1 Tropic-warm/subhumid 313.aez#c.v13_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v13_rf3_x1 Tropic-warm/subhumid 313.aez#c.v13_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v13_rf5_x1 Tropic-warm/subhumid 313.aez#c.v13_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v13_rf1_x1 Tropic-warm/humid 314.aez#c.v13_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v13_rf3_x1 Tropic-warm/humid 314.aez#c.v13_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v13_rf5_x1 Tropic-warm/humid 314.aez#c.v13_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v13_rf1_x1 Tropic-cool/semiarid 322.aez#c.v13_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v13_rf3_x1 Tropic-cool/semiarid 322.aez#c.v13_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v13_rf5_x1 Tropic-cool/semiarid 322.aez#c.v13_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v13_rf1_x1 Tropic-cool/subhumid 323.aez#c.v13_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v13_rf3_x1 Tropic-cool/subhumid 323.aez#c.v13_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v13_rf5_x1 Tropic-cool/subhumid 323.aez#c.v13_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v13_rf1_x1 Tropic-cool/humid 324.aez#c.v13_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v13_rf3_x1 Tropic-cool/humid 324.aez#c.v13_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v13_rf5_x1 Tropic-cool/humid 324.aez#c.v13_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2012.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* longest dry spell
		esttab reg_v14_rf1_x1 reg_v14_rf2_x1 reg_v14_rf3_x1 reg_v14_rf4_x1 ///
			reg_v14_rf5_x1 reg_v14_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_dry_mwi.tex", replace ///
			title(Longest Dry Spell - Malawi) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v14_rf1_x1 Tropic-warm/semiarid 312.aez#c.v14_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v14_rf3_x1 Tropic-warm/semiarid 312.aez#c.v14_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v14_rf5_x1 Tropic-warm/semiarid 312.aez#c.v14_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v14_rf1_x1 Tropic-warm/subhumid 313.aez#c.v14_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v14_rf3_x1 Tropic-warm/subhumid 313.aez#c.v14_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v14_rf5_x1 Tropic-warm/subhumid 313.aez#c.v14_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v14_rf1_x1 Tropic-warm/humid 314.aez#c.v14_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v14_rf3_x1 Tropic-warm/humid 314.aez#c.v14_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v14_rf5_x1 Tropic-warm/humid 314.aez#c.v14_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v14_rf1_x1 Tropic-cool/semiarid 322.aez#c.v14_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v14_rf3_x1 Tropic-cool/semiarid 322.aez#c.v14_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v14_rf5_x1 Tropic-cool/semiarid 322.aez#c.v14_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v14_rf1_x1 Tropic-cool/subhumid 323.aez#c.v14_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v14_rf3_x1 Tropic-cool/subhumid 323.aez#c.v14_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v14_rf5_x1 Tropic-cool/subhumid 323.aez#c.v14_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v14_rf1_x1 Tropic-cool/humid 324.aez#c.v14_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v14_rf3_x1 Tropic-cool/humid 324.aez#c.v14_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v14_rf5_x1 Tropic-cool/humid 324.aez#c.v14_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2012.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
	
*build tables, mwi temperature	
	* mean
		esttab 	reg_v15_tp1_x1 reg_v15_tp2_x1 reg_v15_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_mean_mwi.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Mean Daily Temperature - Malawi) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v15_tp1_x1 Tropic-warm/semiarid 312.aez#c.v15_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v15_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v15_tp1_x1 Tropic-warm/subhumid 313.aez#c.v15_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v15_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v15_tp1_x1 Tropic-warm/humid 314.aez#c.v15_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v15_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v15_tp1_x1 Tropic-cool/semiarid  322.aez#c.v15_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v15_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v15_tp1_x1 Tropic-cool/subhumid  323.aez#c.v15_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v15_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v15_tp1_x1 Tropic-cool/humid  324.aez#c.v15_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v15_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2009.year 2012.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* median
		esttab 	reg_v16_tp1_x1 reg_v16_tp2_x1 reg_v16_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_median_mwi.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Median Daily Temperature - Malawi) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v16_tp1_x1 Tropic-warm/semiarid 312.aez#c.v16_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v16_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v16_tp1_x1 Tropic-warm/subhumid 313.aez#c.v16_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v16_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v16_tp1_x1 Tropic-warm/humid 314.aez#c.v16_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v16_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v16_tp1_x1 Tropic-cool/semiarid  322.aez#c.v16_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v16_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v16_tp1_x1 Tropic-cool/subhumid  323.aez#c.v16_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v16_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v16_tp1_x1 Tropic-cool/humid  324.aez#c.v16_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v16_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2009.year 2012.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* variance
		esttab 	reg_v17_tp1_x1 reg_v17_tp2_x1 reg_v17_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_variance_mwi.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Variance of Daily Temperature - Malawi) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v17_tp1_x1 Tropic-warm/semiarid 312.aez#c.v17_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v17_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v17_tp1_x1 Tropic-warm/subhumid 313.aez#c.v17_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v17_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v17_tp1_x1 Tropic-warm/humid 314.aez#c.v17_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v17_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v17_tp1_x1 Tropic-cool/semiarid  322.aez#c.v17_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v17_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v17_tp1_x1 Tropic-cool/subhumid  323.aez#c.v17_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v17_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v17_tp1_x1 Tropic-cool/humid  324.aez#c.v17_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v17_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2009.year 2012.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* skew
		esttab 	reg_v18_tp1_x1 reg_v18_tp2_x1 reg_v18_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_skew_mwi.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Skew of Daily Temperature - Malawi) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v18_tp1_x1 Tropic-warm/semiarid 312.aez#c.v18_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v18_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v18_tp1_x1 Tropic-warm/subhumid 313.aez#c.v18_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v18_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v18_tp1_x1 Tropic-warm/humid 314.aez#c.v18_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v18_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v18_tp1_x1 Tropic-cool/semiarid  322.aez#c.v18_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v18_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v18_tp1_x1 Tropic-cool/subhumid  323.aez#c.v18_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v18_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v18_tp1_x1 Tropic-cool/humid  324.aez#c.v18_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v18_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2009.year 2012.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* growing degree days
		esttab 	reg_v19_tp1_x1 reg_v19_tp2_x1 reg_v19_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_gdd_mwi.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Growing Degree Days - Malawi) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v19_tp1_x1 Tropic-warm/semiarid 312.aez#c.v19_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v19_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v19_tp1_x1 Tropic-warm/subhumid 313.aez#c.v19_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v19_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v19_tp1_x1 Tropic-warm/humid 314.aez#c.v19_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v19_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v19_tp1_x1 Tropic-cool/semiarid  322.aez#c.v19_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v19_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v19_tp1_x1 Tropic-cool/subhumid  323.aez#c.v19_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v19_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v19_tp1_x1 Tropic-cool/humid  324.aez#c.v19_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v19_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2009.year 2012.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* deviation in gdd
		esttab 	reg_v20_tp1_x1 reg_v20_tp2_x1 reg_v20_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_gdddev_mwi.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Deviation in GDD - Malawi) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v20_tp1_x1 Tropic-warm/semiarid 312.aez#c.v20_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v20_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v20_tp1_x1 Tropic-warm/subhumid 313.aez#c.v20_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v20_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v20_tp1_x1 Tropic-warm/humid 314.aez#c.v20_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v20_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v20_tp1_x1 Tropic-cool/semiarid  322.aez#c.v20_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v20_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v20_tp1_x1 Tropic-cool/subhumid  323.aez#c.v20_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v20_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v20_tp1_x1 Tropic-cool/humid  324.aez#c.v20_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v20_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2009.year 2012.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* z-score of gdd
		esttab 	reg_v21_tp1_x1 reg_v21_tp2_x1 reg_v21_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_gddz_mwi.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Z-Score of GDD - Malawi) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v21_tp1_x1 Tropic-warm/semiarid 312.aez#c.v21_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v21_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v21_tp1_x1 Tropic-warm/subhumid 313.aez#c.v21_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v21_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v21_tp1_x1 Tropic-warm/humid 314.aez#c.v21_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v21_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v21_tp1_x1 Tropic-cool/semiarid  322.aez#c.v21_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v21_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v21_tp1_x1 Tropic-cool/subhumid  323.aez#c.v21_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v21_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v21_tp1_x1 Tropic-cool/humid  324.aez#c.v21_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v21_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2009.year 2012.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* max
		esttab 	reg_v22_tp1_x1 reg_v22_tp2_x1 reg_v22_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_max_mwi.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Maximum Daily Temperature - Malawi) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v22_tp1_x1 Tropic-warm/semiarid 312.aez#c.v22_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v22_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v22_tp1_x1 Tropic-warm/subhumid 313.aez#c.v22_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v22_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v22_tp1_x1 Tropic-warm/humid 314.aez#c.v22_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v22_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v22_tp1_x1 Tropic-cool/semiarid  322.aez#c.v22_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v22_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v22_tp1_x1 Tropic-cool/subhumid  323.aez#c.v22_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v22_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v22_tp1_x1 Tropic-cool/humid  324.aez#c.v22_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v22_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2009.year 2012.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
				
		restore
		
***************************************************UGANDA****************************************************		
		
* preserve only one country - Uganda
		preserve
		drop 		if country != 7
		
	* weather metrics			
		foreach 	v of varlist `weather' { 
		    
		* define locals for naming conventions
			loc 	sat = 	substr("`v'", 5, 3)
			loc 	varn = 	substr("`v'", 1, 3)
			
		* Y = \omega W + \pi X + \alpha_{h} + \gamma_{t} + u_{ht}
			reg 		lncp_yld c.`v'#i.aez `inputscp' i.year, vce(cluster hhid)
			eststo		reg_`v'
			
}			

*build tables, uga rainfall
	* mean
		esttab reg_v01_rf1_x1 reg_v01_rf2_x1 reg_v01_rf3_x1 reg_v01_rf4_x1 ///
			reg_v01_rf5_x1 reg_v01_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_mean_uga.tex", replace ///
			title(Mean Daily Rainfall - Uganda) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v01_rf1_x1 Tropic-warm/semiarid 312.aez#c.v01_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v01_rf3_x1 Tropic-warm/semiarid 312.aez#c.v01_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v01_rf5_x1 Tropic-warm/semiarid 312.aez#c.v01_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v01_rf1_x1 Tropic-warm/subhumid 313.aez#c.v01_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v01_rf3_x1 Tropic-warm/subhumid 313.aez#c.v01_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v01_rf5_x1 Tropic-warm/subhumid 313.aez#c.v01_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v01_rf1_x1 Tropic-warm/humid 314.aez#c.v01_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v01_rf3_x1 Tropic-warm/humid 314.aez#c.v01_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v01_rf5_x1 Tropic-warm/humid 314.aez#c.v01_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v01_rf1_x1 Tropic-cool/semiarid 322.aez#c.v01_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v01_rf3_x1 Tropic-cool/semiarid 322.aez#c.v01_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v01_rf5_x1 Tropic-cool/semiarid 322.aez#c.v01_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v01_rf1_x1 Tropic-cool/subhumid 323.aez#c.v01_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v01_rf3_x1 Tropic-cool/subhumid 323.aez#c.v01_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v01_rf5_x1 Tropic-cool/subhumid 323.aez#c.v01_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v01_rf1_x1 Tropic-cool/humid 324.aez#c.v01_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v01_rf3_x1 Tropic-cool/humid 324.aez#c.v01_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v01_rf5_x1 Tropic-cool/humid 324.aez#c.v01_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2010.year 2011.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* median
		esttab reg_v02_rf1_x1 reg_v02_rf2_x1 reg_v02_rf3_x1 reg_v02_rf4_x1 ///
			reg_v02_rf5_x1 reg_v02_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_median_uga.tex", replace ///
			title(Median Daily Rainfall - Uganda) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v02_rf1_x1 Tropic-warm/semiarid 312.aez#c.v02_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v02_rf3_x1 Tropic-warm/semiarid 312.aez#c.v02_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v02_rf5_x1 Tropic-warm/semiarid 312.aez#c.v02_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v02_rf1_x1 Tropic-warm/subhumid 313.aez#c.v02_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v02_rf3_x1 Tropic-warm/subhumid 313.aez#c.v02_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v02_rf5_x1 Tropic-warm/subhumid 313.aez#c.v02_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v02_rf1_x1 Tropic-warm/humid 314.aez#c.v02_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v02_rf3_x1 Tropic-warm/humid 314.aez#c.v02_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v02_rf5_x1 Tropic-warm/humid 314.aez#c.v02_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v02_rf1_x1 Tropic-cool/semiarid 322.aez#c.v02_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v02_rf3_x1 Tropic-cool/semiarid 322.aez#c.v02_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v02_rf5_x1 Tropic-cool/semiarid 322.aez#c.v02_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v02_rf1_x1 Tropic-cool/subhumid 323.aez#c.v02_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v02_rf3_x1 Tropic-cool/subhumid 323.aez#c.v02_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v02_rf5_x1 Tropic-cool/subhumid 323.aez#c.v02_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v02_rf1_x1 Tropic-cool/humid 324.aez#c.v02_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v02_rf3_x1 Tropic-cool/humid 324.aez#c.v02_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v02_rf5_x1 Tropic-cool/humid 324.aez#c.v02_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2010.year 2011.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* variance
		esttab reg_v03_rf1_x1 reg_v03_rf2_x1 reg_v03_rf3_x1 reg_v03_rf4_x1 ///
			reg_v03_rf5_x1 reg_v03_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_var_uga.tex", replace ///
			title(Variance of Daily Rainfall - Uganda) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v03_rf1_x1 Tropic-warm/semiarid 312.aez#c.v03_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v03_rf3_x1 Tropic-warm/semiarid 312.aez#c.v03_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v03_rf5_x1 Tropic-warm/semiarid 312.aez#c.v03_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v03_rf1_x1 Tropic-warm/subhumid 313.aez#c.v03_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v03_rf3_x1 Tropic-warm/subhumid 313.aez#c.v03_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v03_rf5_x1 Tropic-warm/subhumid 313.aez#c.v03_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v03_rf1_x1 Tropic-warm/humid 314.aez#c.v03_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v03_rf3_x1 Tropic-warm/humid 314.aez#c.v03_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v03_rf5_x1 Tropic-warm/humid 314.aez#c.v03_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v03_rf1_x1 Tropic-cool/semiarid 322.aez#c.v03_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v03_rf3_x1 Tropic-cool/semiarid 322.aez#c.v03_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v03_rf5_x1 Tropic-cool/semiarid 322.aez#c.v03_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v03_rf1_x1 Tropic-cool/subhumid 323.aez#c.v03_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v03_rf3_x1 Tropic-cool/subhumid 323.aez#c.v03_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v03_rf5_x1 Tropic-cool/subhumid 323.aez#c.v03_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v03_rf1_x1 Tropic-cool/humid 324.aez#c.v03_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v03_rf3_x1 Tropic-cool/humid 324.aez#c.v03_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v03_rf5_x1 Tropic-cool/humid 324.aez#c.v03_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2010.year 2011.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* skew
		esttab reg_v04_rf1_x1 reg_v04_rf2_x1 reg_v04_rf3_x1 reg_v04_rf4_x1 ///
			reg_v04_rf5_x1 reg_v04_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_skew_uga.tex", replace ///
			title(Skew of Daily Rainfall - Uganda) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v04_rf1_x1 Tropic-warm/semiarid 312.aez#c.v04_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v04_rf3_x1 Tropic-warm/semiarid 312.aez#c.v04_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v04_rf5_x1 Tropic-warm/semiarid 312.aez#c.v04_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v04_rf1_x1 Tropic-warm/subhumid 313.aez#c.v04_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v04_rf3_x1 Tropic-warm/subhumid 313.aez#c.v04_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v04_rf5_x1 Tropic-warm/subhumid 313.aez#c.v04_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v04_rf1_x1 Tropic-warm/humid 314.aez#c.v04_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v04_rf3_x1 Tropic-warm/humid 314.aez#c.v04_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v04_rf5_x1 Tropic-warm/humid 314.aez#c.v04_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v04_rf1_x1 Tropic-cool/semiarid 322.aez#c.v04_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v04_rf3_x1 Tropic-cool/semiarid 322.aez#c.v04_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v04_rf5_x1 Tropic-cool/semiarid 322.aez#c.v04_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v04_rf1_x1 Tropic-cool/subhumid 323.aez#c.v04_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v04_rf3_x1 Tropic-cool/subhumid 323.aez#c.v04_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v04_rf5_x1 Tropic-cool/subhumid 323.aez#c.v04_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v04_rf1_x1 Tropic-cool/humid 324.aez#c.v04_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v04_rf3_x1 Tropic-cool/humid 324.aez#c.v04_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v04_rf5_x1 Tropic-cool/humid 324.aez#c.v04_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2010.year 2011.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* total
		esttab reg_v05_rf1_x1 reg_v05_rf2_x1 reg_v05_rf3_x1 reg_v05_rf4_x1 ///
			reg_v05_rf5_x1 reg_v05_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_total_uga.tex", replace ///
			title(Total Rainfall - Uganda) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v05_rf1_x1 Tropic-warm/semiarid 312.aez#c.v05_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v05_rf3_x1 Tropic-warm/semiarid 312.aez#c.v05_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v05_rf5_x1 Tropic-warm/semiarid 312.aez#c.v05_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v05_rf1_x1 Tropic-warm/subhumid 313.aez#c.v05_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v05_rf3_x1 Tropic-warm/subhumid 313.aez#c.v05_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v05_rf5_x1 Tropic-warm/subhumid 313.aez#c.v05_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v05_rf1_x1 Tropic-warm/humid 314.aez#c.v05_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v05_rf3_x1 Tropic-warm/humid 314.aez#c.v05_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v05_rf5_x1 Tropic-warm/humid 314.aez#c.v05_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v05_rf1_x1 Tropic-cool/semiarid 322.aez#c.v05_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v05_rf3_x1 Tropic-cool/semiarid 322.aez#c.v05_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v05_rf5_x1 Tropic-cool/semiarid 322.aez#c.v05_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v05_rf1_x1 Tropic-cool/subhumid 323.aez#c.v05_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v05_rf3_x1 Tropic-cool/subhumid 323.aez#c.v05_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v05_rf5_x1 Tropic-cool/subhumid 323.aez#c.v05_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v05_rf1_x1 Tropic-cool/humid 324.aez#c.v05_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v05_rf3_x1 Tropic-cool/humid 324.aez#c.v05_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v05_rf5_x1 Tropic-cool/humid 324.aez#c.v05_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2010.year 2011.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* deviation in total
		esttab reg_v06_rf1_x1 reg_v06_rf2_x1 reg_v06_rf3_x1 reg_v06_rf4_x1 ///
			reg_v06_rf5_x1 reg_v06_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_totaldev_uga.tex", replace ///
			title(Deviation in Total Rainfall - Uganda) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v06_rf1_x1 Tropic-warm/semiarid 312.aez#c.v06_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v06_rf3_x1 Tropic-warm/semiarid 312.aez#c.v06_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v06_rf5_x1 Tropic-warm/semiarid 312.aez#c.v06_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v06_rf1_x1 Tropic-warm/subhumid 313.aez#c.v06_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v06_rf3_x1 Tropic-warm/subhumid 313.aez#c.v06_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v06_rf5_x1 Tropic-warm/subhumid 313.aez#c.v06_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v06_rf1_x1 Tropic-warm/humid 314.aez#c.v06_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v06_rf3_x1 Tropic-warm/humid 314.aez#c.v06_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v06_rf5_x1 Tropic-warm/humid 314.aez#c.v06_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v06_rf1_x1 Tropic-cool/semiarid 322.aez#c.v06_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v06_rf3_x1 Tropic-cool/semiarid 322.aez#c.v06_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v06_rf5_x1 Tropic-cool/semiarid 322.aez#c.v06_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v06_rf1_x1 Tropic-cool/subhumid 323.aez#c.v06_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v06_rf3_x1 Tropic-cool/subhumid 323.aez#c.v06_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v06_rf5_x1 Tropic-cool/subhumid 323.aez#c.v06_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v06_rf1_x1 Tropic-cool/humid 324.aez#c.v06_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v06_rf3_x1 Tropic-cool/humid 324.aez#c.v06_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v06_rf5_x1 Tropic-cool/humid 324.aez#c.v06_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2010.year 2011.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* z-score total
		esttab reg_v07_rf1_x1 reg_v07_rf2_x1 reg_v07_rf3_x1 reg_v07_rf4_x1 ///
			reg_v07_rf5_x1 reg_v07_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_totalz_uga.tex", replace ///
			title(Z-Score of Total Rainfall - Uganda) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v07_rf1_x1 Tropic-warm/semiarid 312.aez#c.v07_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v07_rf3_x1 Tropic-warm/semiarid 312.aez#c.v07_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v07_rf5_x1 Tropic-warm/semiarid 312.aez#c.v07_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v07_rf1_x1 Tropic-warm/subhumid 313.aez#c.v07_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v07_rf3_x1 Tropic-warm/subhumid 313.aez#c.v07_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v07_rf5_x1 Tropic-warm/subhumid 313.aez#c.v07_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v07_rf1_x1 Tropic-warm/humid 314.aez#c.v07_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v07_rf3_x1 Tropic-warm/humid 314.aez#c.v07_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v07_rf5_x1 Tropic-warm/humid 314.aez#c.v07_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v07_rf1_x1 Tropic-cool/semiarid 322.aez#c.v07_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v07_rf3_x1 Tropic-cool/semiarid 322.aez#c.v07_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v07_rf5_x1 Tropic-cool/semiarid 322.aez#c.v07_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v07_rf1_x1 Tropic-cool/subhumid 323.aez#c.v07_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v07_rf3_x1 Tropic-cool/subhumid 323.aez#c.v07_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v07_rf5_x1 Tropic-cool/subhumid 323.aez#c.v07_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v07_rf1_x1 Tropic-cool/humid 324.aez#c.v07_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v07_rf3_x1 Tropic-cool/humid 324.aez#c.v07_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v07_rf5_x1 Tropic-cool/humid 324.aez#c.v07_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2010.year 2011.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* rain days 
		esttab reg_v08_rf1_x1 reg_v08_rf2_x1 reg_v08_rf3_x1 reg_v08_rf4_x1 ///
			reg_v08_rf5_x1 reg_v08_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_raindays_uga.tex", replace ///
			title(Rain Days - Uganda) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v08_rf1_x1 Tropic-warm/semiarid 312.aez#c.v08_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v08_rf3_x1 Tropic-warm/semiarid 312.aez#c.v08_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v08_rf5_x1 Tropic-warm/semiarid 312.aez#c.v08_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v08_rf1_x1 Tropic-warm/subhumid 313.aez#c.v08_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v08_rf3_x1 Tropic-warm/subhumid 313.aez#c.v08_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v08_rf5_x1 Tropic-warm/subhumid 313.aez#c.v08_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v08_rf1_x1 Tropic-warm/humid 314.aez#c.v08_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v08_rf3_x1 Tropic-warm/humid 314.aez#c.v08_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v08_rf5_x1 Tropic-warm/humid 314.aez#c.v08_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v08_rf1_x1 Tropic-cool/semiarid 322.aez#c.v08_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v08_rf3_x1 Tropic-cool/semiarid 322.aez#c.v08_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v08_rf5_x1 Tropic-cool/semiarid 322.aez#c.v08_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v08_rf1_x1 Tropic-cool/subhumid 323.aez#c.v08_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v08_rf3_x1 Tropic-cool/subhumid 323.aez#c.v08_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v08_rf5_x1 Tropic-cool/subhumid 323.aez#c.v08_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v08_rf1_x1 Tropic-cool/humid 324.aez#c.v08_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v08_rf3_x1 Tropic-cool/humid 324.aez#c.v08_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v08_rf5_x1 Tropic-cool/humid 324.aez#c.v08_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2010.year 2011.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* deviation in rain days
		esttab reg_v09_rf1_x1 reg_v09_rf2_x1 reg_v09_rf3_x1 reg_v09_rf4_x1 ///
			reg_v09_rf5_x1 reg_v09_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_raindaysdev_uga.tex", replace ///
			title(Deviation in Rain Days - Uganda) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v09_rf1_x1 Tropic-warm/semiarid 312.aez#c.v09_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v09_rf3_x1 Tropic-warm/semiarid 312.aez#c.v09_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v09_rf5_x1 Tropic-warm/semiarid 312.aez#c.v09_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v09_rf1_x1 Tropic-warm/subhumid 313.aez#c.v09_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v09_rf3_x1 Tropic-warm/subhumid 313.aez#c.v09_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v09_rf5_x1 Tropic-warm/subhumid 313.aez#c.v09_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v09_rf1_x1 Tropic-warm/humid 314.aez#c.v09_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v09_rf3_x1 Tropic-warm/humid 314.aez#c.v09_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v09_rf5_x1 Tropic-warm/humid 314.aez#c.v09_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v09_rf1_x1 Tropic-cool/semiarid 322.aez#c.v09_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v09_rf3_x1 Tropic-cool/semiarid 322.aez#c.v09_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v09_rf5_x1 Tropic-cool/semiarid 322.aez#c.v09_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v09_rf1_x1 Tropic-cool/subhumid 323.aez#c.v09_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v09_rf3_x1 Tropic-cool/subhumid 323.aez#c.v09_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v09_rf5_x1 Tropic-cool/subhumid 323.aez#c.v09_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v09_rf1_x1 Tropic-cool/humid 324.aez#c.v09_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v09_rf3_x1 Tropic-cool/humid 324.aez#c.v09_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v09_rf5_x1 Tropic-cool/humid 324.aez#c.v09_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2010.year 2011.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* no rain days
		esttab reg_v10_rf1_x1 reg_v10_rf2_x1 reg_v10_rf3_x1 reg_v10_rf4_x1 ///
			reg_v10_rf5_x1 reg_v10_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_norain_uga.tex", replace ///
			title(No-Rain Days - Uganda) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v10_rf1_x1 Tropic-warm/semiarid 312.aez#c.v10_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v10_rf3_x1 Tropic-warm/semiarid 312.aez#c.v10_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v10_rf5_x1 Tropic-warm/semiarid 312.aez#c.v10_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v10_rf1_x1 Tropic-warm/subhumid 313.aez#c.v10_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v10_rf3_x1 Tropic-warm/subhumid 313.aez#c.v10_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v10_rf5_x1 Tropic-warm/subhumid 313.aez#c.v10_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v10_rf1_x1 Tropic-warm/humid 314.aez#c.v10_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v10_rf3_x1 Tropic-warm/humid 314.aez#c.v10_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v10_rf5_x1 Tropic-warm/humid 314.aez#c.v10_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v10_rf1_x1 Tropic-cool/semiarid 322.aez#c.v10_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v10_rf3_x1 Tropic-cool/semiarid 322.aez#c.v10_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v10_rf5_x1 Tropic-cool/semiarid 322.aez#c.v10_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v10_rf1_x1 Tropic-cool/subhumid 323.aez#c.v10_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v10_rf3_x1 Tropic-cool/subhumid 323.aez#c.v10_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v10_rf5_x1 Tropic-cool/subhumid 323.aez#c.v10_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v10_rf1_x1 Tropic-cool/humid 324.aez#c.v10_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v10_rf3_x1 Tropic-cool/humid 324.aez#c.v10_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v10_rf5_x1 Tropic-cool/humid 324.aez#c.v10_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2010.year 2011.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* deviation in no rain days
		esttab reg_v11_rf1_x1 reg_v11_rf2_x1 reg_v11_rf3_x1 reg_v11_rf4_x1 ///
			reg_v11_rf5_x1 reg_v11_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_noraindev_uga.tex", replace ///
			title(Deviation in No-Rain Days - Uganda) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v11_rf1_x1 Tropic-warm/semiarid 312.aez#c.v11_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v11_rf3_x1 Tropic-warm/semiarid 312.aez#c.v11_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v11_rf5_x1 Tropic-warm/semiarid 312.aez#c.v11_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v11_rf1_x1 Tropic-warm/subhumid 313.aez#c.v11_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v11_rf3_x1 Tropic-warm/subhumid 313.aez#c.v11_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v11_rf5_x1 Tropic-warm/subhumid 313.aez#c.v11_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v11_rf1_x1 Tropic-warm/humid 314.aez#c.v11_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v11_rf3_x1 Tropic-warm/humid 314.aez#c.v11_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v11_rf5_x1 Tropic-warm/humid 314.aez#c.v11_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v11_rf1_x1 Tropic-cool/semiarid 322.aez#c.v11_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v11_rf3_x1 Tropic-cool/semiarid 322.aez#c.v11_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v11_rf5_x1 Tropic-cool/semiarid 322.aez#c.v11_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v11_rf1_x1 Tropic-cool/subhumid 323.aez#c.v11_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v11_rf3_x1 Tropic-cool/subhumid 323.aez#c.v11_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v11_rf5_x1 Tropic-cool/subhumid 323.aez#c.v11_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v11_rf1_x1 Tropic-cool/humid 324.aez#c.v11_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v11_rf3_x1 Tropic-cool/humid 324.aez#c.v11_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v11_rf5_x1 Tropic-cool/humid 324.aez#c.v11_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2010.year 2011.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* rain days percent
		esttab reg_v12_rf1_x1 reg_v12_rf2_x1 reg_v12_rf3_x1 reg_v12_rf4_x1 ///
			reg_v12_rf5_x1 reg_v12_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_percentraindays_uga.tex", replace ///
			title(Percentage of Rain Days - Uganda) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v12_rf1_x1 Tropic-warm/semiarid 312.aez#c.v12_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v12_rf3_x1 Tropic-warm/semiarid 312.aez#c.v12_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v12_rf5_x1 Tropic-warm/semiarid 312.aez#c.v12_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v12_rf1_x1 Tropic-warm/subhumid 313.aez#c.v12_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v12_rf3_x1 Tropic-warm/subhumid 313.aez#c.v12_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v12_rf5_x1 Tropic-warm/subhumid 313.aez#c.v12_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v12_rf1_x1 Tropic-warm/humid 314.aez#c.v12_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v12_rf3_x1 Tropic-warm/humid 314.aez#c.v12_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v12_rf5_x1 Tropic-warm/humid 314.aez#c.v12_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v12_rf1_x1 Tropic-cool/semiarid 322.aez#c.v12_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v12_rf3_x1 Tropic-cool/semiarid 322.aez#c.v12_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v12_rf5_x1 Tropic-cool/semiarid 322.aez#c.v12_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v12_rf1_x1 Tropic-cool/subhumid 323.aez#c.v12_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v12_rf3_x1 Tropic-cool/subhumid 323.aez#c.v12_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v12_rf5_x1 Tropic-cool/subhumid 323.aez#c.v12_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v12_rf1_x1 Tropic-cool/humid 324.aez#c.v12_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v12_rf3_x1 Tropic-cool/humid 324.aez#c.v12_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v12_rf5_x1 Tropic-cool/humid 324.aez#c.v12_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2010.year 2011.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* deviation in raindays percent
		esttab reg_v13_rf1_x1 reg_v13_rf2_x1 reg_v13_rf3_x1 reg_v13_rf4_x1 ///
			reg_v13_rf5_x1 reg_v13_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_percentraindaysdev_uga.tex", replace ///
			title(Deviation in Percent Rain Days - Uganda) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v13_rf1_x1 Tropic-warm/semiarid 312.aez#c.v13_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v13_rf3_x1 Tropic-warm/semiarid 312.aez#c.v13_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v13_rf5_x1 Tropic-warm/semiarid 312.aez#c.v13_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v13_rf1_x1 Tropic-warm/subhumid 313.aez#c.v13_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v13_rf3_x1 Tropic-warm/subhumid 313.aez#c.v13_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v13_rf5_x1 Tropic-warm/subhumid 313.aez#c.v13_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v13_rf1_x1 Tropic-warm/humid 314.aez#c.v13_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v13_rf3_x1 Tropic-warm/humid 314.aez#c.v13_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v13_rf5_x1 Tropic-warm/humid 314.aez#c.v13_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v13_rf1_x1 Tropic-cool/semiarid 322.aez#c.v13_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v13_rf3_x1 Tropic-cool/semiarid 322.aez#c.v13_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v13_rf5_x1 Tropic-cool/semiarid 322.aez#c.v13_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v13_rf1_x1 Tropic-cool/subhumid 323.aez#c.v13_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v13_rf3_x1 Tropic-cool/subhumid 323.aez#c.v13_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v13_rf5_x1 Tropic-cool/subhumid 323.aez#c.v13_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v13_rf1_x1 Tropic-cool/humid 324.aez#c.v13_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v13_rf3_x1 Tropic-cool/humid 324.aez#c.v13_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v13_rf5_x1 Tropic-cool/humid 324.aez#c.v13_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2010.year 2011.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* longest dry spell
		esttab reg_v14_rf1_x1 reg_v14_rf2_x1 reg_v14_rf3_x1 reg_v14_rf4_x1 ///
			reg_v14_rf5_x1 reg_v14_rf6_x1 ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_dry_uga.tex", replace ///
			title(Longest Dry Spell - Uganda) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v14_rf1_x1 Tropic-warm/semiarid 312.aez#c.v14_rf2_x1 Tropic-warm/semiarid ///
			312.aez#c.v14_rf3_x1 Tropic-warm/semiarid 312.aez#c.v14_rf4_x1 Tropic-warm/semiarid ///
			312.aez#c.v14_rf5_x1 Tropic-warm/semiarid 312.aez#c.v14_rf6_x1 Tropic-warm/semiarid ///
			313.aez#c.v14_rf1_x1 Tropic-warm/subhumid 313.aez#c.v14_rf2_x1 Tropic-warm/subhumid ///
			313.aez#c.v14_rf3_x1 Tropic-warm/subhumid 313.aez#c.v14_rf4_x1 Tropic-warm/subhumid ///
			313.aez#c.v14_rf5_x1 Tropic-warm/subhumid 313.aez#c.v14_rf6_x1 Tropic-warm/subhumid ///
			314.aez#c.v14_rf1_x1 Tropic-warm/humid 314.aez#c.v14_rf2_x1 Tropic-warm/humid ///
			314.aez#c.v14_rf3_x1 Tropic-warm/humid 314.aez#c.v14_rf4_x1 Tropic-warm/humid ///
			314.aez#c.v14_rf5_x1 Tropic-warm/humid 314.aez#c.v14_rf6_x1 Tropic-warm/humid ///
			322.aez#c.v14_rf1_x1 Tropic-cool/semiarid 322.aez#c.v14_rf2_x1 Tropic-cool/semiarid ///
			322.aez#c.v14_rf3_x1 Tropic-cool/semiarid 322.aez#c.v14_rf4_x1 Tropic-cool/semiarid ///
			322.aez#c.v14_rf5_x1 Tropic-cool/semiarid 322.aez#c.v14_rf6_x1 Tropic-cool/semiarid ///
			323.aez#c.v14_rf1_x1 Tropic-cool/subhumid 323.aez#c.v14_rf2_x1 Tropic-cool/subhumid ///
			323.aez#c.v14_rf3_x1 Tropic-cool/subhumid 323.aez#c.v14_rf4_x1 Tropic-cool/subhumid ///
			323.aez#c.v14_rf5_x1 Tropic-cool/subhumid 323.aez#c.v14_rf6_x1 Tropic-cool/subhumid ///
			324.aez#c.v14_rf1_x1 Tropic-cool/humid 324.aez#c.v14_rf2_x1 Tropic-cool/humid ///
			324.aez#c.v14_rf3_x1 Tropic-cool/humid 324.aez#c.v14_rf4_x1 Tropic-cool/humid ///
			324.aez#c.v14_rf5_x1 Tropic-cool/humid 324.aez#c.v14_rf6_x1 Tropic-cool/humid ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2009.year 2010.year 2011.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
	
*build tables, uga temperature	
	* mean
		esttab 	reg_v15_tp1_x1 reg_v15_tp2_x1 reg_v15_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_mean_uga.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Mean Daily Temperature - Uganda) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v15_tp1_x1 Tropic-warm/semiarid 312.aez#c.v15_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v15_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v15_tp1_x1 Tropic-warm/subhumid 313.aez#c.v15_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v15_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v15_tp1_x1 Tropic-warm/humid 314.aez#c.v15_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v15_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v15_tp1_x1 Tropic-cool/semiarid  322.aez#c.v15_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v15_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v15_tp1_x1 Tropic-cool/subhumid  323.aez#c.v15_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v15_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v15_tp1_x1 Tropic-cool/humid  324.aez#c.v15_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v15_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2009.year 2010.year 2011.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* median
		esttab 	reg_v16_tp1_x1 reg_v16_tp2_x1 reg_v16_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_median_uga.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Median Daily Temperature - Uganda) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v16_tp1_x1 Tropic-warm/semiarid 312.aez#c.v16_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v16_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v16_tp1_x1 Tropic-warm/subhumid 313.aez#c.v16_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v16_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v16_tp1_x1 Tropic-warm/humid 314.aez#c.v16_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v16_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v16_tp1_x1 Tropic-cool/semiarid  322.aez#c.v16_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v16_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v16_tp1_x1 Tropic-cool/subhumid  323.aez#c.v16_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v16_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v16_tp1_x1 Tropic-cool/humid  324.aez#c.v16_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v16_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2009.year 2010.year 2011.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* variance
		esttab 	reg_v17_tp1_x1 reg_v17_tp2_x1 reg_v17_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_variance_uga.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Variance of Daily Temperature - Uganda) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v17_tp1_x1 Tropic-warm/semiarid 312.aez#c.v17_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v17_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v17_tp1_x1 Tropic-warm/subhumid 313.aez#c.v17_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v17_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v17_tp1_x1 Tropic-warm/humid 314.aez#c.v17_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v17_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v17_tp1_x1 Tropic-cool/semiarid  322.aez#c.v17_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v17_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v17_tp1_x1 Tropic-cool/subhumid  323.aez#c.v17_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v17_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v17_tp1_x1 Tropic-cool/humid  324.aez#c.v17_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v17_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2009.year 2010.year 2011.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* skew
		esttab 	reg_v18_tp1_x1 reg_v18_tp2_x1 reg_v18_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_skew_uga.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Skew of Daily Temperature - Uganda) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v18_tp1_x1 Tropic-warm/semiarid 312.aez#c.v18_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v18_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v18_tp1_x1 Tropic-warm/subhumid 313.aez#c.v18_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v18_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v18_tp1_x1 Tropic-warm/humid 314.aez#c.v18_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v18_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v18_tp1_x1 Tropic-cool/semiarid  322.aez#c.v18_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v18_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v18_tp1_x1 Tropic-cool/subhumid  323.aez#c.v18_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v18_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v18_tp1_x1 Tropic-cool/humid  324.aez#c.v18_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v18_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2009.year 2010.year 2011.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* growing degree days
		esttab 	reg_v19_tp1_x1 reg_v19_tp2_x1 reg_v19_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_gdd_uga.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Growing Degree Days - Uganda) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v19_tp1_x1 Tropic-warm/semiarid 312.aez#c.v19_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v19_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v19_tp1_x1 Tropic-warm/subhumid 313.aez#c.v19_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v19_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v19_tp1_x1 Tropic-warm/humid 314.aez#c.v19_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v19_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v19_tp1_x1 Tropic-cool/semiarid  322.aez#c.v19_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v19_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v19_tp1_x1 Tropic-cool/subhumid  323.aez#c.v19_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v19_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v19_tp1_x1 Tropic-cool/humid  324.aez#c.v19_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v19_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2009.year 2010.year 2011.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* deviation in gdd
		esttab 	reg_v20_tp1_x1 reg_v20_tp2_x1 reg_v20_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_gdddev_uga.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Deviation in GDD - Uganda) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v20_tp1_x1 Tropic-warm/semiarid 312.aez#c.v20_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v20_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v20_tp1_x1 Tropic-warm/subhumid 313.aez#c.v20_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v20_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v20_tp1_x1 Tropic-warm/humid 314.aez#c.v20_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v20_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v20_tp1_x1 Tropic-cool/semiarid  322.aez#c.v20_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v20_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v20_tp1_x1 Tropic-cool/subhumid  323.aez#c.v20_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v20_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v20_tp1_x1 Tropic-cool/humid  324.aez#c.v20_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v20_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2009.year 2010.year 2011.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* z-score of gdd
		esttab 	reg_v21_tp1_x1 reg_v21_tp2_x1 reg_v21_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_gddz_uga.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Z-Score of GDD - Uganda) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v21_tp1_x1 Tropic-warm/semiarid 312.aez#c.v21_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v21_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v21_tp1_x1 Tropic-warm/subhumid 313.aez#c.v21_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v21_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v21_tp1_x1 Tropic-warm/humid 314.aez#c.v21_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v21_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v21_tp1_x1 Tropic-cool/semiarid  322.aez#c.v21_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v21_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v21_tp1_x1 Tropic-cool/subhumid  323.aez#c.v21_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v21_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v21_tp1_x1 Tropic-cool/humid  324.aez#c.v21_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v21_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2009.year 2010.year 2011.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* max
		esttab 	reg_v22_tp1_x1 reg_v22_tp2_x1 reg_v22_tp3_x1 ///
				using "G:/My Drive/weather_project/regression_data/eawp_sandbox/tp_max_uga.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Maximum Daily Temperature - Uganda) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(312.aez#c.v22_tp1_x1 Tropic-warm/semiarid 312.aez#c.v22_tp2_x1 Tropic-warm/semiarid ///
				312.aez#c.v22_tp3_x1 Tropic-warm/semiarid ///
				313.aez#c.v22_tp1_x1 Tropic-warm/subhumid 313.aez#c.v22_tp2_x1 Tropic-warm/subhumid ///
				313.aez#c.v22_tp3_x1 Tropic-warm/subhumid ///
				314.aez#c.v22_tp1_x1 Tropic-warm/humid 314.aez#c.v22_tp2_x1 Tropic-warm/humid ///
				314.aez#c.v22_tp3_x1 Tropic-warm/humid ///
				322.aez#c.v22_tp1_x1 Tropic-cool/semiarid  322.aez#c.v22_tp2_x1 Tropic-cool/semiarid  ///
				322.aez#c.v22_tp3_x1 Tropic-cool/semiarid  ///
				323.aez#c.v22_tp1_x1 Tropic-cool/subhumid  323.aez#c.v22_tp2_x1 Tropic-cool/subhumid  ///
				323.aez#c.v22_tp3_x1 Tropic-cool/subhumid  ///
				324.aez#c.v22_tp1_x1 Tropic-cool/humid  324.aez#c.v22_tp2_x1 Tropic-cool/humid  ///
				324.aez#c.v22_tp3_x1 Tropic-cool/humid ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				2009.year 2010.year 2011.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
				
		restore
