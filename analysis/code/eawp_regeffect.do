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
			reg 		lncp_yld c.`v'#i.aez `inputscp' i.year, vce(cluster hhid)
			eststo		reg_`v'_`l'
			
}			

*build tables
		esttab reg_v01_rf1_x1_`l' reg_v01_rf2_x1_`l' reg_v01_rf3_x1_`l' reg_v01_rf4_x1_`l' ///
			reg_v01_rf5_x1_`l' reg_v01_rf6_x1_`l' ///
			using "G:/My Drive/weather_project/regression_data/eawp_sandbox/rf_mean_0.tex", replace ///
			title(Mean Daily Rainfall `l') nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(312.aez#c.v01_rf1_x1 312.aez 312.aez#c.v01_rf2_x1 312.aez ///
			312.aez#c.v01_rf3_x1 312.aez 312.aez#c.v01_rf4_x1 312.aez ///
			312.aez#c.v01_rf5_x1 312.aez 312.aez#c.v01_rf6_x1 312.aez ///
			313.aez#c.v01_rf1_x1 313.aez 313.aez#c.v01_rf2_x1 313.aez ///
			313.aez#c.v01_rf3_x1 313.aez 313.aez#c.v01_rf4_x1 313.aez ///
			313.aez#c.v01_rf5_x1 313.aez 313.aez#c.v01_rf6_x1 313.aez ///
			314.aez#c.v01_rf1_x1 314.aez 314.aez#c.v01_rf2_x1 314.aez ///
			314.aez#c.v01_rf3_x1 314.aez 314.aez#c.v01_rf4_x1 314.aez ///
			314.aez#c.v01_rf5_x1 314.aez 314.aez#c.v01_rf6_x1 314.aez ///
			322.aez#c.v01_rf1_x1 322.aez 322.aez#c.v01_rf2_x1 322.aez ///
			322.aez#c.v01_rf3_x1 322.aez 322.aez#c.v01_rf4_x1 322.aez ///
			322.aez#c.v01_rf5_x1 322.aez 322.aez#c.v01_rf6_x1 322.aez ///
			323.aez#c.v01_rf1_x1 323.aez 323.aez#c.v01_rf2_x1 323.aez ///
			323.aez#c.v01_rf3_x1 323.aez 323.aez#c.v01_rf4_x1 323.aez ///
			323.aez#c.v01_rf5_x1 323.aez 323.aez#c.v01_rf6_x1 323.aez ///
			324.aez#c.v01_rf1_x1 324.aez 324.aez#c.v01_rf2_x1 324.aez ///
			324.aez#c.v01_rf3_x1 324.aez 324.aez#c.v01_rf4_x1 324.aez ///
			324.aez#c.v01_rf5_x1 324.aez 324.aez#c.v01_rf6_x1 324.aez ) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2011.year 2013.year 2015.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
				
		restore
		}
