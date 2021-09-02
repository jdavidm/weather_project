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
	* replace pathways with local
	* debug star command in table build sections
	
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
	loc		weatherRF 	v01* v02* v03* v04* v05* v06* v07* 
	*v08* v09* v10* v11* v12* v13* v14*
	
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

*	PER LAST MEETING W/ A&J		

	* this will be columns are satellites, rows are aezs, one table per metric
	reg 		lncp_yld c.v05_rf1_x1#i.aez lncp_lab lncp_frt cp_pst cp_hrb cp_irr i.year, vce(cluster hhid) 
	
	* this will be columns are satellites, rows are countries, one table per metric
	reg 		lncp_yld c.v05_rf1_x1#i.country lncp_lab lncp_frt cp_pst cp_hrb cp_irr i.year, vce(cluster hhid) 
	
	* this will be columns are satellites, rows are metric, one table per country
	bys country: ///
	reg 		lncp_yld v05_rf1_x1 lncp_lab lncp_frt cp_pst cp_hrb cp_irr i.year, vce(cluster hhid) 
	
	* this will be columns are satellites, rows are aezs, one table per metric per country
	bys country: ///
	reg 		lncp_yld c.v05_rf1_x1#i.aez lncp_lab lncp_frt cp_pst cp_hrb cp_irr i.year, vce(cluster hhid) 
	
*/

/*
* **********************************************************************
* 4.1 - columns are satellites, rows are aezs, one table per metric
* **********************************************************************

loc 		inputscp 	lncp_lab lncp_frt cp_pst cp_hrb cp_irr

		foreach 	v of varlist `weather' { 
		    
		* define locals for naming conventions
			loc 	sat = 	substr("`v'", 5, 3)
			loc 	varn = 	substr("`v'", 1, 3)
			
		* Y = \omega W + \pi X + \alpha_{h} + \gamma_{t} + u_{ht}
			reg 		lncp_yld c.`v'#i.aez `inputscp' i.year, vce(cluster hhid)
			eststo		reg1_`v'
			
}	

*build tables, rainfall
	* mean
		esttab reg1_v01_rf1_x1 reg1_v01_rf2_x1 reg1_v01_rf3_x1 reg1_v01_rf4_x1 ///
			reg1_v01_rf5_x1 reg1_v01_rf6_x1 ///
			using "`source'/rf_mean_byaez.tex", replace ///
			title(Mean Daily Rainfall) nonumbers ///
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
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* median
		esttab reg1_v02_rf1_x1 reg1_v02_rf2_x1 reg1_v02_rf3_x1 reg1_v02_rf4_x1 ///
			reg1_v02_rf5_x1 reg1_v02_rf6_x1 ///
			using "`source'/rf_median_byaez.tex", replace ///
			title(Median Daily Rainfall) nonumbers ///
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
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* variance
		esttab reg1_v03_rf1_x1 reg1_v03_rf2_x1 reg1_v03_rf3_x1 reg1_v03_rf4_x1 ///
			reg1_v03_rf5_x1 reg1_v03_rf6_x1 ///
			using "`source'/rf_var_byaez.tex", replace ///
			title(Variance of Daily Rainfall) nonumbers ///
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
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* skew
		esttab reg1_v04_rf1_x1 reg1_v04_rf2_x1 reg1_v04_rf3_x1 reg1_v04_rf4_x1 ///
			reg1_v04_rf5_x1 reg1_v04_rf6_x1 ///
			using "`source'/rf_skew_byaez.tex", replace ///
			title(Skew of Daily Rainfall) nonumbers ///
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
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* total
		esttab reg1_v05_rf1_x1 reg1_v05_rf2_x1 reg1_v05_rf3_x1 reg1_v05_rf4_x1 ///
			reg1_v05_rf5_x1 reg1_v05_rf6_x1 ///
			using "`source'/rf_total_byaez.tex", replace ///
			title(Total Rainfall) nonumbers ///
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
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* deviation in total
		esttab reg1_v06_rf1_x1 reg1_v06_rf2_x1 reg1_v06_rf3_x1 reg1_v06_rf4_x1 ///
			reg1_v06_rf5_x1 reg1_v06_rf6_x1 ///
			using "`source'/rf_totaldev_byaez.tex", replace ///
			title(Deviation in Total Rainfall) nonumbers ///
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
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* z-score total
		esttab reg1_v07_rf1_x1 reg1_v07_rf2_x1 reg1_v07_rf3_x1 reg1_v07_rf4_x1 ///
			reg1_v07_rf5_x1 reg1_v07_rf6_x1 ///
			using "`source'/rf_totalz_byaez.tex", replace ///
			title(Z-Score of Total Rainfall) nonumbers ///
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
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* rain days 
		esttab reg1_v08_rf1_x1 reg1_v08_rf2_x1 reg1_v08_rf3_x1 reg1_v08_rf4_x1 ///
			reg1_v08_rf5_x1 reg1_v08_rf6_x1 ///
			using "`source'/rf_raindays_byaez.tex", replace ///
			title(Rain Days) nonumbers ///
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
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* deviation in rain days
		esttab reg1_v09_rf1_x1 reg1_v09_rf2_x1 reg1_v09_rf3_x1 reg1_v09_rf4_x1 ///
			reg1_v09_rf5_x1 reg1_v09_rf6_x1 ///
			using "`source'/rf_raindaysdev_byaez.tex", replace ///
			title(Deviation in Rain Days) nonumbers ///
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
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* no rain days
		esttab reg1_v10_rf1_x1 reg1_v10_rf2_x1 reg1_v10_rf3_x1 reg1_v10_rf4_x1 ///
			reg1_v10_rf5_x1 reg1_v10_rf6_x1 ///
			using "`source'/rf_norain_byaez.tex", replace ///
			title(No-Rain Days) nonumbers ///
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
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* deviation in no rain days
		esttab reg1_v11_rf1_x1 reg1_v11_rf2_x1 reg1_v11_rf3_x1 reg1_v11_rf4_x1 ///
			reg1_v11_rf5_x1 reg1_v11_rf6_x1 ///
			using "`source'/rf_noraindev_byaez.tex", replace ///
			title(Deviation in No-Rain Days) nonumbers ///
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
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* rain days percent
		esttab reg1_v12_rf1_x1 reg1_v12_rf2_x1 reg1_v12_rf3_x1 reg1_v12_rf4_x1 ///
			reg1_v12_rf5_x1 reg1_v12_rf6_x1 ///
			using "`source'/rf_percentraindays_byaez.tex", replace ///
			title(Percentage of Rain Days) nonumbers ///
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
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* deviation in raindays percent
		esttab reg1_v13_rf1_x1 reg1_v13_rf2_x1 reg1_v13_rf3_x1 reg1_v13_rf4_x1 ///
			reg1_v13_rf5_x1 reg1_v13_rf6_x1 ///
			using "`source'/rf_percentraindaysdev_byaez.tex", replace ///
			title(Deviation in Percent Rain Days) nonumbers ///
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
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* longest dry spell
		esttab reg1_v14_rf1_x1 reg1_v14_rf2_x1 reg1_v14_rf3_x1 reg1_v14_rf4_x1 ///
			reg1_v14_rf5_x1 reg1_v14_rf6_x1 ///
			using "`source'/rf_dry_byaez.tex", replace ///
			title(Longest Dry Spell) nonumbers ///
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
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
	
*build tables, temperature	
	* mean
		esttab 	reg1_v15_tp1_x1 reg1_v15_tp2_x1 reg1_v15_tp3_x1 ///
				using "`source'/tp_mean_byaez.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Mean Daily Temperature) nonumbers ///
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
				*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* median
		esttab 	reg1_v16_tp1_x1 reg1_v16_tp2_x1 reg1_v16_tp3_x1 ///
				using "`source'/tp_median_byaez.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Median Daily Temperature) nonumbers ///
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
				*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* variance
		esttab 	reg1_v17_tp1_x1 reg1_v17_tp2_x1 reg1_v17_tp3_x1 ///
				using "`source'/tp_variance_byaez.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Variance of Daily Temperature) nonumbers ///
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
				*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* skew
		esttab 	reg1_v18_tp1_x1 reg1_v18_tp2_x1 reg1_v18_tp3_x1 ///
				using "`source'/tp_skew_byaez.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Skew of Daily Temperature) nonumbers ///
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
				*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* growing degree days
		esttab 	reg1_v19_tp1_x1 reg1_v19_tp2_x1 reg1_v19_tp3_x1 ///
				using "`source'/tp_gdd_byaez.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Growing Degree Days) nonumbers ///
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
				*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* deviation in gdd
		esttab 	reg1_v20_tp1_x1 reg1_v20_tp2_x1 reg1_v20_tp3_x1 ///
				using "`source'/tp_gdddev_byaez.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Deviation in GDD) nonumbers ///
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
				*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* z-score of gdd
		esttab 	reg1_v21_tp1_x1 reg1_v21_tp2_x1 reg1_v21_tp3_x1 ///
				using "`source'/tp_gddz_byaez.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Z-Score of GDD) nonumbers ///
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
				*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* max
		esttab 	reg1_v22_tp1_x1 reg1_v22_tp2_x1 reg1_v22_tp3_x1 ///
				using "`source'/tp_max_byaez.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Maximum Daily Temperature) nonumbers ///
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
				*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
	
	
* **********************************************************************
* 4.2 - columns are satellites, rows are countriess, one table per metric
* **********************************************************************

	eststo clear

/*
	clear
	
	* recreate locals
	loc		source	= 	"$data/regression_data/eawp_sandbox"
	loc		results = 	"$data/regression_data/eawp_sandbox"
	loc		logout 	= 	"$data/regression_data/logs"
	
	loc 	inputscp 	lncp_lab lncp_frt cp_pst cp_hrb cp_irr
	loc		weather 	v*

	* read in data file
	use			"`source'/eafrica_aez_panel.dta", clear
*/
	
		foreach 	v of varlist `weather' { 
		    
		* define locals for naming conventions
			loc 	sat = 	substr("`v'", 5, 3)
			loc 	varn = 	substr("`v'", 1, 3)
			
		* Y = \omega W + \pi X + \alpha_{h} + \gamma_{t} + u_{ht}
			reg 		lncp_yld c.`v'#i.country `inputscp' i.year, vce(cluster hhid)
			eststo		reg2_`v'
			
}	

*build tables, rainfall
	* mean
		esttab reg2_v01_rf1_x1 reg2_v01_rf2_x1 reg2_v01_rf3_x1 reg2_v01_rf4_x1 ///
			reg2_v01_rf5_x1 reg2_v01_rf6_x1 ///
			using "`source'/rf_mean_bycountry.tex", replace ///
			title(Mean Daily Rainfall) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(1.country#c.v01_rf1_x1 Ethiopia 1.country#c.v01_rf2_x1 Ethiopia ///
			1.country#c.v01_rf3_x1 Ethiopia 1.country#c.v01_rf4_x1 Ethiopia ///
			1.country#c.v01_rf5_x1 Ethiopia 1.country#c.v01_rf6_x1 Ethiopia ///
			2.country#c.v01_rf1_x1 Malawi 2.country#c.v01_rf2_x1 Malawi ///
			2.country#c.v01_rf3_x1 Malawi 2.country#c.v01_rf4_x1 Malawi ///
			2.country#c.v01_rf5_x1 Malawi 2.country#c.v01_rf6_x1 Malawi ///
			6.country#c.v01_rf1_x1 Tanzania 6.country#c.v01_rf2_x1 Tanzania ///
			6.country#c.v01_rf3_x1 Tanzania 6.country#c.v01_rf4_x1 Tanzania ///
			6.country#c.v01_rf5_x1 Tanzania 6.country#c.v01_rf6_x1 Tanzania ///
			7.country#c.v01_rf1_x1 Uganda 7.country#c.v01_rf2_x1 Uganda ///
			7.country#c.v01_rf3_x1 Uganda 7.country#c.v01_rf4_x1 Uganda ///
			7.country#c.v01_rf5_x1 Uganda 7.country#c.v01_rf6_x1 Uganda) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* median
		esttab reg2_v02_rf1_x1 reg2_v02_rf2_x1 reg2_v02_rf3_x1 reg2_v02_rf4_x1 ///
			reg2_v02_rf5_x1 reg2_v02_rf6_x1 ///
			using "`source'/rf_median_bycountry.tex", replace ///
			title(Median Daily Rainfall) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(1.country#c.v02_rf1_x1 Ethiopia 1.country#c.v02_rf2_x1 Ethiopia ///
			1.country#c.v02_rf3_x1 Ethiopia 1.country#c.v02_rf4_x1 Ethiopia ///
			1.country#c.v02_rf5_x1 Ethiopia 1.country#c.v02_rf6_x1 Ethiopia ///
			2.country#c.v02_rf1_x1 Malawi 2.country#c.v02_rf2_x1 Malawi ///
			2.country#c.v02_rf3_x1 Malawi 2.country#c.v02_rf4_x1 Malawi ///
			2.country#c.v02_rf5_x1 Malawi 2.country#c.v02_rf6_x1 Malawi ///
			6.country#c.v02_rf1_x1 Tanzania 6.country#c.v02_rf2_x1 Tanzania ///
			6.country#c.v02_rf3_x1 Tanzania 6.country#c.v02_rf4_x1 Tanzania ///
			6.country#c.v02_rf5_x1 Tanzania 6.country#c.v02_rf6_x1 Tanzania ///
			7.country#c.v02_rf1_x1 Uganda 7.country#c.v02_rf2_x1 Uganda ///
			7.country#c.v02_rf3_x1 Uganda 7.country#c.v02_rf4_x1 Uganda ///
			7.country#c.v02_rf5_x1 Uganda 7.country#c.v02_rf6_x1 Uganda) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* variance
		esttab reg2_v03_rf1_x1 reg2_v03_rf2_x1 reg2_v03_rf3_x1 reg2_v03_rf4_x1 ///
			reg2_v03_rf5_x1 reg2_v03_rf6_x1 ///
			using "`source'/rf_var_bycountry.tex", replace ///
			title(Variance of Daily Rainfall) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(1.country#c.v03_rf1_x1 Ethiopia 1.country#c.v03_rf2_x1 Ethiopia ///
			1.country#c.v03_rf3_x1 Ethiopia 1.country#c.v03_rf4_x1 Ethiopia ///
			1.country#c.v03_rf5_x1 Ethiopia 1.country#c.v03_rf6_x1 Ethiopia ///
			2.country#c.v03_rf1_x1 Malawi 2.country#c.v03_rf2_x1 Malawi ///
			2.country#c.v03_rf3_x1 Malawi 2.country#c.v03_rf4_x1 Malawi ///
			2.country#c.v03_rf5_x1 Malawi 2.country#c.v03_rf6_x1 Malawi ///
			6.country#c.v03_rf1_x1 Tanzania 6.country#c.v03_rf2_x1 Tanzania ///
			6.country#c.v03_rf3_x1 Tanzania 6.country#c.v03_rf4_x1 Tanzania ///
			6.country#c.v03_rf5_x1 Tanzania 6.country#c.v03_rf6_x1 Tanzania ///
			7.country#c.v03_rf1_x1 Uganda 7.country#c.v03_rf2_x1 Uganda ///
			7.country#c.v03_rf3_x1 Uganda 7.country#c.v03_rf4_x1 Uganda ///
			7.country#c.v03_rf5_x1 Uganda 7.country#c.v03_rf6_x1 Uganda) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* skew
		esttab reg2_v04_rf1_x1 reg2_v04_rf2_x1 reg2_v04_rf3_x1 reg2_v04_rf4_x1 ///
			reg2_v04_rf5_x1 reg2_v04_rf6_x1 ///
			using "`source'/rf_skew_bycountry.tex", replace ///
			title(Skew of Daily Rainfall) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(1.country#c.v04_rf1_x1 Ethiopia 1.country#c.v04_rf2_x1 Ethiopia ///
			1.country#c.v04_rf3_x1 Ethiopia 1.country#c.v04_rf4_x1 Ethiopia ///
			1.country#c.v04_rf5_x1 Ethiopia 1.country#c.v04_rf6_x1 Ethiopia ///
			2.country#c.v04_rf1_x1 Malawi 2.country#c.v04_rf2_x1 Malawi ///
			2.country#c.v04_rf3_x1 Malawi 2.country#c.v04_rf4_x1 Malawi ///
			2.country#c.v04_rf5_x1 Malawi 2.country#c.v04_rf6_x1 Malawi ///
			6.country#c.v04_rf1_x1 Tanzania 6.country#c.v04_rf2_x1 Tanzania ///
			6.country#c.v04_rf3_x1 Tanzania 6.country#c.v04_rf4_x1 Tanzania ///
			6.country#c.v04_rf5_x1 Tanzania 6.country#c.v04_rf6_x1 Tanzania ///
			7.country#c.v04_rf1_x1 Uganda 7.country#c.v04_rf2_x1 Uganda ///
			7.country#c.v04_rf3_x1 Uganda 7.country#c.v04_rf4_x1 Uganda ///
			7.country#c.v04_rf5_x1 Uganda 7.country#c.v04_rf6_x1 Uganda) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* total
		esttab reg2_v05_rf1_x1 reg2_v05_rf2_x1 reg2_v05_rf3_x1 reg2_v05_rf4_x1 ///
			reg2_v05_rf5_x1 reg2_v05_rf6_x1 ///
			using "`source'/rf_total_bycountry.tex", replace ///
			title(Total Rainfall) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(1.country#c.v05_rf1_x1 Ethiopia 1.country#c.v05_rf2_x1 Ethiopia ///
			1.country#c.v05_rf3_x1 Ethiopia 1.country#c.v05_rf4_x1 Ethiopia ///
			1.country#c.v05_rf5_x1 Ethiopia 1.country#c.v05_rf6_x1 Ethiopia ///
			2.country#c.v05_rf1_x1 Malawi 2.country#c.v05_rf2_x1 Malawi ///
			2.country#c.v05_rf3_x1 Malawi 2.country#c.v05_rf4_x1 Malawi ///
			2.country#c.v05_rf5_x1 Malawi 2.country#c.v05_rf6_x1 Malawi ///
			6.country#c.v05_rf1_x1 Tanzania 6.country#c.v05_rf2_x1 Tanzania ///
			6.country#c.v05_rf3_x1 Tanzania 6.country#c.v05_rf4_x1 Tanzania ///
			6.country#c.v05_rf5_x1 Tanzania 6.country#c.v05_rf6_x1 Tanzania ///
			7.country#c.v05_rf1_x1 Uganda 7.country#c.v05_rf2_x1 Uganda ///
			7.country#c.v05_rf3_x1 Uganda 7.country#c.v05_rf4_x1 Uganda ///
			7.country#c.v05_rf5_x1 Uganda 7.country#c.v05_rf6_x1 Uganda) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* deviation in total
		esttab reg2_v06_rf1_x1 reg2_v06_rf2_x1 reg2_v06_rf3_x1 reg2_v06_rf4_x1 ///
			reg2_v06_rf5_x1 reg2_v06_rf6_x1 ///
			using "`source'/rf_totaldev_bycountry.tex", replace ///
			title(Deviation in Total Rainfall) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(1.country#c.v06_rf1_x1 Ethiopia 1.country#c.v06_rf2_x1 Ethiopia ///
			1.country#c.v06_rf3_x1 Ethiopia 1.country#c.v06_rf4_x1 Ethiopia ///
			1.country#c.v06_rf5_x1 Ethiopia 1.country#c.v06_rf6_x1 Ethiopia ///
			2.country#c.v06_rf1_x1 Malawi 2.country#c.v06_rf2_x1 Malawi ///
			2.country#c.v06_rf3_x1 Malawi 2.country#c.v06_rf4_x1 Malawi ///
			2.country#c.v06_rf5_x1 Malawi 2.country#c.v06_rf6_x1 Malawi ///
			6.country#c.v06_rf1_x1 Tanzania 6.country#c.v06_rf2_x1 Tanzania ///
			6.country#c.v06_rf3_x1 Tanzania 6.country#c.v06_rf4_x1 Tanzania ///
			6.country#c.v06_rf5_x1 Tanzania 6.country#c.v06_rf6_x1 Tanzania ///
			7.country#c.v06_rf1_x1 Uganda 7.country#c.v06_rf2_x1 Uganda ///
			7.country#c.v06_rf3_x1 Uganda 7.country#c.v06_rf4_x1 Uganda ///
			7.country#c.v06_rf5_x1 Uganda 7.country#c.v06_rf6_x1 Uganda) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* z-score total
		esttab reg2_v07_rf1_x1 reg2_v07_rf2_x1 reg2_v07_rf3_x1 reg2_v07_rf4_x1 ///
			reg2_v07_rf5_x1 reg2_v07_rf6_x1 ///
			using "`source'/rf_totalz_bycountry.tex", replace ///
			title(Z-Score of Total Rainfall) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(1.country#c.v07_rf1_x1 Ethiopia 1.country#c.v07_rf2_x1 Ethiopia ///
			1.country#c.v07_rf3_x1 Ethiopia 1.country#c.v07_rf4_x1 Ethiopia ///
			1.country#c.v07_rf5_x1 Ethiopia 1.country#c.v07_rf6_x1 Ethiopia ///
			2.country#c.v07_rf1_x1 Malawi 2.country#c.v07_rf2_x1 Malawi ///
			2.country#c.v07_rf3_x1 Malawi 2.country#c.v07_rf4_x1 Malawi ///
			2.country#c.v07_rf5_x1 Malawi 2.country#c.v07_rf6_x1 Malawi ///
			6.country#c.v07_rf1_x1 Tanzania 6.country#c.v07_rf2_x1 Tanzania ///
			6.country#c.v07_rf3_x1 Tanzania 6.country#c.v07_rf4_x1 Tanzania ///
			6.country#c.v07_rf5_x1 Tanzania 6.country#c.v07_rf6_x1 Tanzania ///
			7.country#c.v07_rf1_x1 Uganda 7.country#c.v07_rf2_x1 Uganda ///
			7.country#c.v07_rf3_x1 Uganda 7.country#c.v07_rf4_x1 Uganda ///
			7.country#c.v07_rf5_x1 Uganda 7.country#c.v07_rf6_x1 Uganda) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* rain days 
		esttab reg2_v08_rf1_x1 reg2_v08_rf2_x1 reg2_v08_rf3_x1 reg2_v08_rf4_x1 ///
			reg2_v08_rf5_x1 reg2_v08_rf6_x1 ///
			using "`source'/rf_raindays_bycountry.tex", replace ///
			title(Rain Days) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(1.country#c.v08_rf1_x1 Ethiopia 1.country#c.v08_rf2_x1 Ethiopia ///
			1.country#c.v08_rf3_x1 Ethiopia 1.country#c.v08_rf4_x1 Ethiopia ///
			1.country#c.v08_rf5_x1 Ethiopia 1.country#c.v08_rf6_x1 Ethiopia ///
			2.country#c.v08_rf1_x1 Malawi 2.country#c.v08_rf2_x1 Malawi ///
			2.country#c.v08_rf3_x1 Malawi 2.country#c.v08_rf4_x1 Malawi ///
			2.country#c.v08_rf5_x1 Malawi 2.country#c.v08_rf6_x1 Malawi ///
			6.country#c.v08_rf1_x1 Tanzania 6.country#c.v08_rf2_x1 Tanzania ///
			6.country#c.v08_rf3_x1 Tanzania 6.country#c.v08_rf4_x1 Tanzania ///
			6.country#c.v08_rf5_x1 Tanzania 6.country#c.v08_rf6_x1 Tanzania ///
			7.country#c.v08_rf1_x1 Uganda 7.country#c.v08_rf2_x1 Uganda ///
			7.country#c.v08_rf3_x1 Uganda 7.country#c.v08_rf4_x1 Uganda ///
			7.country#c.v08_rf5_x1 Uganda 7.country#c.v08_rf6_x1 Uganda) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* deviation in rain days
		esttab reg2_v09_rf1_x1 reg2_v09_rf2_x1 reg2_v09_rf3_x1 reg2_v09_rf4_x1 ///
			reg2_v09_rf5_x1 reg2_v09_rf6_x1 ///
			using "`source'/rf_raindaysdev_bycountry.tex", replace ///
			title(Deviation in Rain Days) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(1.country#c.v09_rf1_x1 Ethiopia 1.country#c.v09_rf2_x1 Ethiopia ///
			1.country#c.v09_rf3_x1 Ethiopia 1.country#c.v09_rf4_x1 Ethiopia ///
			1.country#c.v09_rf5_x1 Ethiopia 1.country#c.v09_rf6_x1 Ethiopia ///
			2.country#c.v09_rf1_x1 Malawi 2.country#c.v09_rf2_x1 Malawi ///
			2.country#c.v09_rf3_x1 Malawi 2.country#c.v09_rf4_x1 Malawi ///
			2.country#c.v09_rf5_x1 Malawi 2.country#c.v09_rf6_x1 Malawi ///
			6.country#c.v09_rf1_x1 Tanzania 6.country#c.v09_rf2_x1 Tanzania ///
			6.country#c.v09_rf3_x1 Tanzania 6.country#c.v09_rf4_x1 Tanzania ///
			6.country#c.v09_rf5_x1 Tanzania 6.country#c.v09_rf6_x1 Tanzania ///
			7.country#c.v09_rf1_x1 Uganda 7.country#c.v09_rf2_x1 Uganda ///
			7.country#c.v09_rf3_x1 Uganda 7.country#c.v09_rf4_x1 Uganda ///
			7.country#c.v09_rf5_x1 Uganda 7.country#c.v09_rf6_x1 Uganda) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* no rain days
		esttab reg2_v10_rf1_x1 reg2_v10_rf2_x1 reg2_v10_rf3_x1 reg2_v10_rf4_x1 ///
			reg2_v10_rf5_x1 reg2_v10_rf6_x1 ///
			using "`source'/rf_norain_bycountry.tex", replace ///
			title(No-Rain Days) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(1.country#c.v10_rf1_x1 Ethiopia 1.country#c.v10_rf2_x1 Ethiopia ///
			1.country#c.v10_rf3_x1 Ethiopia 1.country#c.v10_rf4_x1 Ethiopia ///
			1.country#c.v10_rf5_x1 Ethiopia 1.country#c.v10_rf6_x1 Ethiopia ///
			2.country#c.v10_rf1_x1 Malawi 2.country#c.v10_rf2_x1 Malawi ///
			2.country#c.v10_rf3_x1 Malawi 2.country#c.v10_rf4_x1 Malawi ///
			2.country#c.v10_rf5_x1 Malawi 2.country#c.v10_rf6_x1 Malawi ///
			6.country#c.v10_rf1_x1 Tanzania 6.country#c.v10_rf2_x1 Tanzania ///
			6.country#c.v10_rf3_x1 Tanzania 6.country#c.v10_rf4_x1 Tanzania ///
			6.country#c.v10_rf5_x1 Tanzania 6.country#c.v10_rf6_x1 Tanzania ///
			7.country#c.v10_rf1_x1 Uganda 7.country#c.v10_rf2_x1 Uganda ///
			7.country#c.v10_rf3_x1 Uganda 7.country#c.v10_rf4_x1 Uganda ///
			7.country#c.v10_rf5_x1 Uganda 7.country#c.v10_rf6_x1 Uganda) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* deviation in no rain days
		esttab reg2_v11_rf1_x1 reg2_v11_rf2_x1 reg2_v11_rf3_x1 reg2_v11_rf4_x1 ///
			reg2_v11_rf5_x1 reg2_v11_rf6_x1 ///
			using "`source'/rf_noraindev_bycountry.tex", replace ///
			title(Deviation in No-Rain Days) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(1.country#c.v11_rf1_x1 Ethiopia 1.country#c.v11_rf2_x1 Ethiopia ///
			1.country#c.v11_rf3_x1 Ethiopia 1.country#c.v11_rf4_x1 Ethiopia ///
			1.country#c.v11_rf5_x1 Ethiopia 1.country#c.v11_rf6_x1 Ethiopia ///
			2.country#c.v11_rf1_x1 Malawi 2.country#c.v11_rf2_x1 Malawi ///
			2.country#c.v11_rf3_x1 Malawi 2.country#c.v11_rf4_x1 Malawi ///
			2.country#c.v11_rf5_x1 Malawi 2.country#c.v11_rf6_x1 Malawi ///
			6.country#c.v11_rf1_x1 Tanzania 6.country#c.v11_rf2_x1 Tanzania ///
			6.country#c.v11_rf3_x1 Tanzania 6.country#c.v11_rf4_x1 Tanzania ///
			6.country#c.v11_rf5_x1 Tanzania 6.country#c.v11_rf6_x1 Tanzania ///
			7.country#c.v11_rf1_x1 Uganda 7.country#c.v11_rf2_x1 Uganda ///
			7.country#c.v11_rf3_x1 Uganda 7.country#c.v11_rf4_x1 Uganda ///
			7.country#c.v11_rf5_x1 Uganda 7.country#c.v11_rf6_x1 Uganda) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* rain days percent
		esttab reg2_v12_rf1_x1 reg2_v12_rf2_x1 reg2_v12_rf3_x1 reg2_v12_rf4_x1 ///
			reg2_v12_rf5_x1 reg2_v12_rf6_x1 ///
			using "`source'/rf_percentraindays_bycountry.tex", replace ///
			title(Percentage of Rain Days) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(1.country#c.v12_rf1_x1 Ethiopia 1.country#c.v12_rf2_x1 Ethiopia ///
			1.country#c.v12_rf3_x1 Ethiopia 1.country#c.v12_rf4_x1 Ethiopia ///
			1.country#c.v12_rf5_x1 Ethiopia 1.country#c.v12_rf6_x1 Ethiopia ///
			2.country#c.v12_rf1_x1 Malawi 2.country#c.v12_rf2_x1 Malawi ///
			2.country#c.v12_rf3_x1 Malawi 2.country#c.v12_rf4_x1 Malawi ///
			2.country#c.v12_rf5_x1 Malawi 2.country#c.v12_rf6_x1 Malawi ///
			6.country#c.v12_rf1_x1 Tanzania 6.country#c.v12_rf2_x1 Tanzania ///
			6.country#c.v12_rf3_x1 Tanzania 6.country#c.v12_rf4_x1 Tanzania ///
			6.country#c.v12_rf5_x1 Tanzania 6.country#c.v12_rf6_x1 Tanzania ///
			7.country#c.v12_rf1_x1 Uganda 7.country#c.v12_rf2_x1 Uganda ///
			7.country#c.v12_rf3_x1 Uganda 7.country#c.v12_rf4_x1 Uganda ///
			7.country#c.v12_rf5_x1 Uganda 7.country#c.v12_rf6_x1 Uganda) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* deviation in raindays percent
		esttab reg2_v13_rf1_x1 reg2_v13_rf2_x1 reg2_v13_rf3_x1 reg2_v13_rf4_x1 ///
			reg2_v13_rf5_x1 reg2_v13_rf6_x1 ///
			using "`source'/rf_percentraindaysdev_bycountry.tex", replace ///
			title(Deviation in Percent Rain Days) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(1.country#c.v13_rf1_x1 Ethiopia 1.country#c.v13_rf2_x1 Ethiopia ///
			1.country#c.v13_rf3_x1 Ethiopia 1.country#c.v13_rf4_x1 Ethiopia ///
			1.country#c.v13_rf5_x1 Ethiopia 1.country#c.v13_rf6_x1 Ethiopia ///
			2.country#c.v13_rf1_x1 Malawi 2.country#c.v13_rf2_x1 Malawi ///
			2.country#c.v13_rf3_x1 Malawi 2.country#c.v13_rf4_x1 Malawi ///
			2.country#c.v13_rf5_x1 Malawi 2.country#c.v13_rf6_x1 Malawi ///
			6.country#c.v13_rf1_x1 Tanzania 6.country#c.v13_rf2_x1 Tanzania ///
			6.country#c.v13_rf3_x1 Tanzania 6.country#c.v13_rf4_x1 Tanzania ///
			6.country#c.v13_rf5_x1 Tanzania 6.country#c.v13_rf6_x1 Tanzania ///
			7.country#c.v13_rf1_x1 Uganda 7.country#c.v13_rf2_x1 Uganda ///
			7.country#c.v13_rf3_x1 Uganda 7.country#c.v13_rf4_x1 Uganda ///
			7.country#c.v13_rf5_x1 Uganda 7.country#c.v13_rf6_x1 Uganda) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
			
	* longest dry spell
		esttab reg2_v14_rf1_x1 reg2_v14_rf2_x1 reg2_v14_rf3_x1 reg2_v14_rf4_x1 ///
			reg2_v14_rf5_x1 reg2_v14_rf6_x1 ///
			using "`source'/rf_dry_bycountry.tex", replace ///
			title(Longest Dry Spell) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(1.country#c.v14_rf1_x1 Ethiopia 1.country#c.v14_rf2_x1 Ethiopia ///
			1.country#c.v14_rf3_x1 Ethiopia 1.country#c.v14_rf4_x1 Ethiopia ///
			1.country#c.v14_rf5_x1 Ethiopia 1.country#c.v14_rf6_x1 Ethiopia ///
			2.country#c.v14_rf1_x1 Malawi 2.country#c.v14_rf2_x1 Malawi ///
			2.country#c.v14_rf3_x1 Malawi 2.country#c.v14_rf4_x1 Malawi ///
			2.country#c.v14_rf5_x1 Malawi 2.country#c.v14_rf6_x1 Malawi ///
			6.country#c.v14_rf1_x1 Tanzania 6.country#c.v14_rf2_x1 Tanzania ///
			6.country#c.v14_rf3_x1 Tanzania 6.country#c.v14_rf4_x1 Tanzania ///
			6.country#c.v14_rf5_x1 Tanzania 6.country#c.v14_rf6_x1 Tanzania ///
			7.country#c.v14_rf1_x1 Uganda 7.country#c.v14_rf2_x1 Uganda ///
			7.country#c.v14_rf3_x1 Uganda 7.country#c.v14_rf4_x1 Uganda ///
			7.country#c.v14_rf5_x1 Uganda 7.country#c.v14_rf6_x1 Uganda) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))
	
*build tables, temperature	
	* mean
		esttab 	reg2_v15_tp1_x1 reg2_v15_tp2_x1 reg2_v15_tp3_x1 ///
				using "`source'/tp_mean_bycountry.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Mean Daily Temperature) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(1.country#c.v15_tp1_x1 Ethiopia 1.country#c.v15_tp2_x1 Ethiopia ///
				1.country#c.v15_tp3_x1 Ethiopia ///
				2.country#c.v15_tp1_x1 Malawi 2.country#c.v15_tp2_x1 Malawi ///
				2.country#c.v15_tp3_x1 Malawi ///
				6.country#c.v15_tp1_x1 Tanzania 6.country#c.v15_tp2_x1 Tanzania ///
				6.country#c.v15_tp3_x1 Tanzania ///
				7.country#c.v15_tp1_x1 Uganda  7.country#c.v15_tp2_x1 Uganda  ///
				7.country#c.v15_tp3_x1 Uganda ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* median
		esttab 	reg2_v16_tp1_x1 reg2_v16_tp2_x1 reg2_v16_tp3_x1 ///
				using "`source'/tp_median_bycountry.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Median Daily Temperature) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(1.country#c.v16_tp1_x1 Ethiopia 1.country#c.v16_tp2_x1 Ethiopia ///
				1.country#c.v16_tp3_x1 Ethiopia ///
				2.country#c.v16_tp1_x1 Malawi 2.country#c.v16_tp2_x1 Malawi ///
				2.country#c.v16_tp3_x1 Malawi ///
				6.country#c.v16_tp1_x1 Tanzania 6.country#c.v16_tp2_x1 Tanzania ///
				6.country#c.v16_tp3_x1 Tanzania ///
				7.country#c.v16_tp1_x1 Uganda  7.country#c.v16_tp2_x1 Uganda  ///
				7.country#c.v16_tp3_x1 Uganda ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* variance
		esttab 	reg2_v17_tp1_x1 reg2_v17_tp2_x1 reg2_v17_tp3_x1 ///
				using "`source'/tp_variance_bycountry.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Variance of Daily Temperature) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(1.country#c.v17_tp1_x1 Ethiopia 1.country#c.v17_tp2_x1 Ethiopia ///
				1.country#c.v17_tp3_x1 Ethiopia ///
				2.country#c.v17_tp1_x1 Malawi 2.country#c.v17_tp2_x1 Malawi ///
				2.country#c.v17_tp3_x1 Malawi ///
				6.country#c.v17_tp1_x1 Tanzania 6.country#c.v17_tp2_x1 Tanzania ///
				6.country#c.v17_tp3_x1 Tanzania ///
				7.country#c.v17_tp1_x1 Uganda  7.country#c.v17_tp2_x1 Uganda  ///
				7.country#c.v17_tp3_x1 Uganda ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* skew
		esttab 	reg2_v18_tp1_x1 reg2_v18_tp2_x1 reg2_v18_tp3_x1 ///
				using "`source'/tp_skew_bycountry.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Skew of Daily Temperature) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(1.country#c.v18_tp1_x1 Ethiopia 1.country#c.v18_tp2_x1 Ethiopia ///
				1.country#c.v18_tp3_x1 Ethiopia ///
				2.country#c.v18_tp1_x1 Malawi 2.country#c.v18_tp2_x1 Malawi ///
				2.country#c.v18_tp3_x1 Malawi ///
				6.country#c.v18_tp1_x1 Tanzania 6.country#c.v18_tp2_x1 Tanzania ///
				6.country#c.v18_tp3_x1 Tanzania ///
				7.country#c.v18_tp1_x1 Uganda  7.country#c.v18_tp2_x1 Uganda  ///
				7.country#c.v18_tp3_x1 Uganda ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* growing degree days
		esttab 	reg2_v19_tp1_x1 reg2_v19_tp2_x1 reg2_v19_tp3_x1 ///
				using "`source'/tp_gdd_bycountry.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Growing Degree Days) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(1.country#c.v19_tp1_x1 Ethiopia 1.country#c.v19_tp2_x1 Ethiopia ///
				1.country#c.v19_tp3_x1 Ethiopia ///
				2.country#c.v19_tp1_x1 Malawi 2.country#c.v19_tp2_x1 Malawi ///
				2.country#c.v19_tp3_x1 Malawi ///
				6.country#c.v19_tp1_x1 Tanzania 6.country#c.v19_tp2_x1 Tanzania ///
				6.country#c.v19_tp3_x1 Tanzania ///
				7.country#c.v19_tp1_x1 Uganda  7.country#c.v19_tp2_x1 Uganda  ///
				7.country#c.v19_tp3_x1 Uganda ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* deviation in gdd
		esttab 	reg2_v20_tp1_x1 reg2_v20_tp2_x1 reg2_v20_tp3_x1 ///
				using "`source'/tp_gdddev_bycountry.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Deviation in GDD) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(1.country#c.v20_tp1_x1 Ethiopia 1.country#c.v20_tp2_x1 Ethiopia ///
				1.country#c.v20_tp3_x1 Ethiopia ///
				2.country#c.v20_tp1_x1 Malawi 2.country#c.v20_tp2_x1 Malawi ///
				2.country#c.v20_tp3_x1 Malawi ///
				6.country#c.v20_tp1_x1 Tanzania 6.country#c.v20_tp2_x1 Tanzania ///
				6.country#c.v20_tp3_x1 Tanzania ///
				7.country#c.v20_tp1_x1 Uganda  7.country#c.v20_tp2_x1 Uganda  ///
				7.country#c.v20_tp3_x1 Uganda ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* z-score of gdd
		esttab 	reg2_v21_tp1_x1 reg2_v21_tp2_x1 reg2_v21_tp3_x1 ///
				using "`source'/tp_gddz_bycountry.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Z-Score of GDD) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(1.country#c.v21_tp1_x1 Ethiopia 1.country#c.v21_tp2_x1 Ethiopia ///
				1.country#c.v21_tp3_x1 Ethiopia ///
				2.country#c.v21_tp1_x1 Malawi 2.country#c.v21_tp2_x1 Malawi ///
				2.country#c.v21_tp3_x1 Malawi ///
				6.country#c.v21_tp1_x1 Tanzania 6.country#c.v21_tp2_x1 Tanzania ///
				6.country#c.v21_tp3_x1 Tanzania ///
				7.country#c.v21_tp1_x1 Uganda  7.country#c.v21_tp2_x1 Uganda  ///
				7.country#c.v21_tp3_x1 Uganda ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))

	* max
		esttab 	reg2_v22_tp1_x1 reg2_v22_tp2_x1 reg2_v22_tp3_x1 ///
				using "`source'/tp_max_bycountry.tex", replace	 ///
				label booktabs b(3) se(3) alignment(D{.}{.}{-1}) ///
				title(Maximum Daily Temperature) nonumbers ///
				mtitles("Temperature 1" "Temperature 2" "Temperature 3") ///
				rename(1.country#c.v22_tp1_x1 Ethiopia 1.country#c.v22_tp2_x1 Ethiopia ///
				1.country#c.v22_tp3_x1 Ethiopia ///
				2.country#c.v22_tp1_x1 Malawi 2.country#c.v22_tp2_x1 Malawi ///
				2.country#c.v22_tp3_x1 Malawi ///
				6.country#c.v22_tp1_x1 Tanzania 6.country#c.v22_tp2_x1 Tanzania ///
				6.country#c.v22_tp3_x1 Tanzania ///
				7.country#c.v22_tp1_x1 Uganda  7.country#c.v22_tp2_x1 Uganda  ///
				7.country#c.v22_tp3_x1 Uganda ) ///
				drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
				*.year _cons) stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
				"\multicolumn{1}{c}{@}") labels(`"Observations"' `"\(R^{2}\)"'))	

		*/		
*************************************************************************
**# 4.3 - sample split by country, no aezs **IGNORE THIS ANN**
*************************************************************************

	eststo clear
	
	sort		country
	by country:	tab aez
	by country:	tab year
	
	loc 		inputscp 	lncp_lab lncp_frt cp_pst cp_hrb cp_irr
	
***************************************************TANZANIA****************************************************

* preserve only one country - Tanzania
		preserve
		drop 		if country != 6	

		foreach 	v of varlist `weatherRF' { 
		    
		* define locals for naming conventions
			loc 	sat = 	substr("`v'", 5, 3)
			loc 	varn = 	substr("`v'", 1, 3)
			
		* Y = \omega W + \pi X + \alpha_{h} + \gamma_{t} + u_{ht}
			reg 		lncp_yld `v' `inputscp' i.year, vce(cluster hhid)
			eststo		reg3_`v'
}

*build tables, tza rainfall
		esttab 	reg3_v01_rf1_x1 reg3_v01_rf2_x1 reg3_v01_rf3_x1 reg3_v01_rf4_x1 ///
				reg3_v01_rf5_x1 reg3_v01_rf6_x1 ///
				reg3_v02_rf1_x1 reg3_v02_rf2_x1 reg3_v02_rf3_x1 reg3_v02_rf4_x1 ///
				reg3_v02_rf5_x1 reg3_v02_rf6_x1 ///
				reg3_v03_rf1_x1 reg3_v03_rf2_x1 reg3_v03_rf3_x1 reg3_v03_rf4_x1 ///
				reg3_v03_rf5_x1 reg3_v03_rf6_x1 ///
				reg3_v04_rf1_x1 reg3_v04_rf2_x1 reg3_v04_rf3_x1 reg3_v04_rf4_x1 ///
				reg3_v04_rf5_x1 reg3_v04_rf6_x1 ///
				reg3_v05_rf1_x1 reg3_v05_rf2_x1 reg3_v05_rf3_x1 reg3_v05_rf4_x1 ///
				reg3_v05_rf5_x1 reg3_v05_rf6_x1 ///
				reg3_v06_rf1_x1 reg3_v06_rf2_x1 reg3_v06_rf3_x1 reg3_v06_rf4_x1 ///
				reg3_v06_rf5_x1 reg3_v06_rf6_x1 ///
				reg3_v07_rf1_x1 reg3_v07_rf2_x1 reg3_v07_rf3_x1 reg3_v07_rf4_x1 ///
				reg3_v07_rf5_x1 reg3_v07_rf6_x1 ///
				reg3_v08_rf1_x1 reg3_v08_rf2_x1 reg3_v08_rf3_x1 reg3_v08_rf4_x1 ///
				reg3_v08_rf5_x1 reg3_v08_rf6_x1 ///
				reg3_v09_rf1_x1 reg3_v09_rf2_x1 reg3_v09_rf3_x1 reg3_v09_rf4_x1 ///
				reg3_v09_rf5_x1 reg3_v09_rf6_x1 ///
				reg3_v10_rf1_x1 reg3_v10_rf2_x1 reg3_v10_rf3_x1 reg3_v10_rf4_x1 ///
				reg3_v10_rf5_x1 reg3_v10_rf6_x1 ///
				reg3_v11_rf1_x1 reg3_v11_rf2_x1 reg3_v11_rf3_x1 reg3_v11_rf4_x1 ///
				reg3_v11_rf5_x1 reg3_v11_rf6_x1 ///
				reg3_v12_rf1_x1 reg3_v12_rf2_x1 reg3_v12_rf3_x1 reg3_v12_rf4_x1 ///
				reg3_v12_rf5_x1 reg3_v12_rf6_x1 ///
				reg3_v13_rf1_x1 reg3_v13_rf2_x1 reg3_v13_rf3_x1 reg3_v13_rf4_x1 ///
				reg3_v13_rf5_x1 reg3_v13_rf6_x1 ///
				reg3_v14_rf1_x1 reg3_v14_rf2_x1 reg3_v14_rf3_x1 reg3_v14_rf4_x1 ///
				reg3_v14_rf5_x1 reg3_v14_rf6_x1 ///
			using "`source'/allmetrics_tza.tex", replace ///
			title(Tanzania - Rainfall) nonumbers ///
			mtitles("Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" "Rainfall 1" "Rainfall 2" "Rainfall 3" "Rainfall 4" "Rainfall 5" "Rainfall 6" ) ///
			rename(v01_rf1_x1 Mean v01_rf2_x1 Mean ///
			v01_rf3_x1 Mean v01_rf4_x1 Mean ///
			v01_rf5_x1 Mean v01_rf6_x1 Mean ///
			v02_rf1_x1 Median v02_rf2_x1 Median ///
			v02_rf3_x1 Median v02_rf4_x1 Median ///
			v02_rf5_x1 Median v02_rf6_x1 Median) ///
			drop(lncp_lab lncp_frt cp_pst cp_hrb cp_irr ///
			2008.year 2010.year 2012.year _cons)
			
			
			rename(v01_rf1_x1 Mean v01_rf2_x1 Mean ///
			v01_rf3_x1 Mean v01_rf4_x1 Mean ///
			v01_rf5_x1 Mean v01_rf6_x1 Mean ///
			v02_rf1_x1 Median v02_rf2_x1 Median ///
			v02_rf3_x1 Median v02_rf4_x1 Median ///
			v02_rf5_x1 Median v02_rf6_x1 Median ///
			v03_rf1_x1 RF_Variance v03_rf2_x1 RF_Variance ///
			v03_rf3_x1 RF_Variance v03_rf4_x1 RF_Variance ///
			v03_rf5_x1 RF_Variance v03_rf6_x1 RF_Variance ///
			v04_rf1_x1 RF_Skewness v04_rf2_x1 RF_Skewness ///
			v04_rf3_x1 RF_Skewness v04_rf4_x1 RF_Skewness ///
			v04_rf5_x1 RF_Skewness v04_rf6_x1 RF_Skewness ///
			v05_rf1_x1 RF_Total v05_rf2_x1 RF_Total ///
			v05_rf3_x1 RF_Total v05_rf4_x1 RF_Total ///
			v05_rf5_x1 RF_Total v05_rf6_x1 RF_Total ///
			v06_rf1_x1 RF_TotalDev v06_rf2_x1 RF_TotalDev ///
			v06_rf3_x1 RF_TotalDev v06_rf4_x1 RF_TotalDev ///
			v06_rf5_x1 RF_TotalDev v06_rf6_x1 RF_TotalDev ///
			v07_rf1_x1 RF_TotalZ v07_rf2_x1 RF_TotalZ ///
			v07_rf3_x1 RF_TotalZ v07_rf4_x1 RF_TotalZ ///
			v07_rf5_x1 RF_TotalZ v07_rf6_x1 RF_TotalZ ///
			v08_rf1_x1 RF_RainDays v08_rf2_x1 RF_RainDays ///
			v08_rf3_x1 RF_RainDays v08_rf4_x1 RF_RainDays ///
			v08_rf5_x1 RF_RainDays v08_rf6_x1 RF_RainDays ///
			v09_rf1_x1 RF_RainDaysDev v09_rf2_x1 RF_RainDaysDev ///
			v09_rf3_x1 RF_RainDaysDev v09_rf4_x1 RF_RainDaysDev ///
			v09_rf5_x1 RF_RainDaysDev v09_rf6_x1 RF_RainDaysDev ///
			v10_rf1_x1 RF_NoRainDays v10_rf2_x1 RF_NoRainDays ///
			v10_rf3_x1 RF_NoRainDays v10_rf4_x1 RF_NoRainDays ///
			v10_rf5_x1 RF_NoRainDays v10_rf6_x1 RF_NoRainDays ///
			v11_rf1_x1 RF_NoRainDaysDev v11_rf2_x1 RF_NoRainDaysDev ///
			v11_rf3_x1 RF_NoRainDaysDev v11_rf4_x1 RF_NoRainDaysDev ///
			v11_rf5_x1 RF_NoRainDaysDev v11_rf6_x1 RF_NoRainDaysDev ///
			v12_rf1_x1 RF_PercentRainDays v12_rf2_x1 RF_PercentRainDays ///
			v12_rf3_x1 RF_PercentRainDays v12_rf4_x1 RF_PercentRainDays ///
			v12_rf5_x1 RF_PercentRainDays v12_rf6_x1 RF_PercentRainDays ///
			v13_rf1_x1 RF_PercentRainDaysDev v13_rf2_x1 RF_PercentRainDaysDev ///
			v13_rf3_x1 RF_PercentRainDaysDev v13_rf4_x1 RF_PercentRainDaysDev ///
			v13_rf5_x1 RF_PercentRainDaysDev v13_rf6_x1 RF_PercentRainDaysDev ///
			v14_rf1_x1 RF_LongestDry v14_rf2_x1 RF_LongestDry ///
			v14_rf3_x1 RF_LongestDry v14_rf4_x1 RF_LongestDry ///
			v14_rf5_x1 RF_LongestDry v14_rf6_x1 RF_LongestDry )
			stats(N r2, fmt(0 3) layout("\multicolumn{1}{c}{@}" ///
			"\multicolumn{1}{c}{@}"))
			
		restore	
	
* **********************************************************************
* 4.4 - sample split by country, looking at aezs
* **********************************************************************

	eststo clear

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
			eststo		reg4_`v'
			
}			

*build tables, tza rainfall
	* mean
		esttab reg4_v01_rf1_x1 reg4_v01_rf2_x1 reg4_v01_rf3_x1 reg4_v01_rf4_x1 ///
			reg4_v01_rf5_x1 reg4_v01_rf6_x1 ///
			using "`source'/rf_mean_tza.tex", replace ///
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
		esttab reg4_v02_rf1_x1 reg4_v02_rf2_x1 reg4_v02_rf3_x1 reg4_v02_rf4_x1 ///
			reg4_v02_rf5_x1 reg4_v02_rf6_x1 ///
			using "`source'/rf_median_tza.tex", replace ///
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
		esttab reg4_v03_rf1_x1 reg4_v03_rf2_x1 reg4_v03_rf3_x1 reg4_v03_rf4_x1 ///
			reg4_v03_rf5_x1 reg4_v03_rf6_x1 ///
			using "`source'/rf_var_tza.tex", replace ///
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
		esttab reg4_v04_rf1_x1 reg4_v04_rf2_x1 reg4_v04_rf3_x1 reg4_v04_rf4_x1 ///
			reg4_v04_rf5_x1 reg4_v04_rf6_x1 ///
			using "`source'/rf_skew_tza.tex", replace ///
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
		esttab reg4_v05_rf1_x1 reg4_v05_rf2_x1 reg4_v05_rf3_x1 reg4_v05_rf4_x1 ///
			reg4_v05_rf5_x1 reg4_v05_rf6_x1 ///
			using "`source'/rf_total_tza.tex", replace ///
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
		esttab reg4_v06_rf1_x1 reg4_v06_rf2_x1 reg4_v06_rf3_x1 reg4_v06_rf4_x1 ///
			reg4_v06_rf5_x1 reg4_v06_rf6_x1 ///
			using "`source'/rf_totaldev_tza.tex", replace ///
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
		esttab reg4_v07_rf1_x1 reg4_v07_rf2_x1 reg4_v07_rf3_x1 reg4_v07_rf4_x1 ///
			reg4_v07_rf5_x1 reg4_v07_rf6_x1 ///
			using "`source'/rf_totalz_tza.tex", replace ///
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
		esttab reg4_v08_rf1_x1 reg4_v08_rf2_x1 reg4_v08_rf3_x1 reg4_v08_rf4_x1 ///
			reg4_v08_rf5_x1 reg4_v08_rf6_x1 ///
			using "`source'/rf_raindays_tza.tex", replace ///
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
		esttab reg4_v09_rf1_x1 reg4_v09_rf2_x1 reg4_v09_rf3_x1 reg4_v09_rf4_x1 ///
			reg4_v09_rf5_x1 reg4_v09_rf6_x1 ///
			using "`source'/rf_raindaysdev_tza.tex", replace ///
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
		esttab reg4_v10_rf1_x1 reg4_v10_rf2_x1 reg4_v10_rf3_x1 reg4_v10_rf4_x1 ///
			reg4_v10_rf5_x1 reg4_v10_rf6_x1 ///
			using "`source'/rf_norain_tza.tex", replace ///
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
		esttab reg4_v11_rf1_x1 reg4_v11_rf2_x1 reg4_v11_rf3_x1 reg4_v11_rf4_x1 ///
			reg4_v11_rf5_x1 reg4_v11_rf6_x1 ///
			using "`source'/rf_noraindev_tza.tex", replace ///
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
		esttab reg4_v12_rf1_x1 reg4_v12_rf2_x1 reg4_v12_rf3_x1 reg4_v12_rf4_x1 ///
			reg4_v12_rf5_x1 reg4_v12_rf6_x1 ///
			using "`source'/rf_percentraindays_tza.tex", replace ///
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
		esttab reg4_v13_rf1_x1 reg4_v13_rf2_x1 reg4_v13_rf3_x1 reg4_v13_rf4_x1 ///
			reg4_v13_rf5_x1 reg4_v13_rf6_x1 ///
			using "`source'/rf_percentraindaysdev_tza.tex", replace ///
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
		esttab reg4_v14_rf1_x1 reg4_v14_rf2_x1 reg4_v14_rf3_x1 reg4_v14_rf4_x1 ///
			reg4_v14_rf5_x1 reg4_v14_rf6_x1 ///
			using "`source'/rf_dry_tza.tex", replace ///
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
		esttab 	reg4_v15_tp1_x1 reg4_v15_tp2_x1 reg4_v15_tp3_x1 ///
				using "`source'/tp_mean_tza.tex", replace	 ///
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
		esttab 	reg4_v16_tp1_x1 reg4_v16_tp2_x1 reg4_v16_tp3_x1 ///
				using "`source'/tp_median_tza.tex", replace	 ///
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
		esttab 	reg4_v17_tp1_x1 reg4_v17_tp2_x1 reg4_v17_tp3_x1 ///
				using "`source'/tp_variance_tza.tex", replace	 ///
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
		esttab 	reg4_v18_tp1_x1 reg4_v18_tp2_x1 reg4_v18_tp3_x1 ///
				using "`source'/tp_skew_tza.tex", replace	 ///
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
		esttab 	reg4_v19_tp1_x1 reg4_v19_tp2_x1 reg4_v19_tp3_x1 ///
				using "`source'/tp_gdd_tza.tex", replace	 ///
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
		esttab 	reg4_v20_tp1_x1 reg4_v20_tp2_x1 reg4_v20_tp3_x1 ///
				using "`source'/tp_gdddev_tza.tex", replace	 ///
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
		esttab 	reg4_v21_tp1_x1 reg4_v21_tp2_x1 reg4_v21_tp3_x1 ///
				using "`source'/tp_gddz_tza.tex", replace	 ///
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
		esttab 	reg4_v22_tp1_x1 reg4_v22_tp2_x1 reg4_v22_tp3_x1 ///
				using "`source'/tp_max_tza.tex", replace	 ///
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
			eststo		reg4_`v'
			
}			

*build tables, eth rainfall
	* mean
		esttab reg4_v01_rf1_x1 reg4_v01_rf2_x1 reg4_v01_rf3_x1 reg4_v01_rf4_x1 ///
			reg4_v01_rf5_x1 reg4_v01_rf6_x1 ///
			using "`source'/rf_mean_eth.tex", replace ///
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
		esttab reg4_v02_rf1_x1 reg4_v02_rf2_x1 reg4_v02_rf3_x1 reg4_v02_rf4_x1 ///
			reg4_v02_rf5_x1 reg4_v02_rf6_x1 ///
			using "`source'/rf_median_eth.tex", replace ///
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
		esttab reg4_v03_rf1_x1 reg4_v03_rf2_x1 reg4_v03_rf3_x1 reg4_v03_rf4_x1 ///
			reg4_v03_rf5_x1 reg4_v03_rf6_x1 ///
			using "`source'/rf_var_eth.tex", replace ///
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
		esttab reg4_v04_rf1_x1 reg4_v04_rf2_x1 reg4_v04_rf3_x1 reg4_v04_rf4_x1 ///
			reg4_v04_rf5_x1 reg4_v04_rf6_x1 ///
			using "`source'/rf_skew_eth.tex", replace ///
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
		esttab reg4_v05_rf1_x1 reg4_v05_rf2_x1 reg4_v05_rf3_x1 reg4_v05_rf4_x1 ///
			reg4_v05_rf5_x1 reg4_v05_rf6_x1 ///
			using "`source'/rf_total_eth.tex", replace ///
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
		esttab reg4_v06_rf1_x1 reg4_v06_rf2_x1 reg4_v06_rf3_x1 reg4_v06_rf4_x1 ///
			reg4_v06_rf5_x1 reg4_v06_rf6_x1 ///
			using "`source'/rf_totaldev_eth.tex", replace ///
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
		esttab reg4_v07_rf1_x1 reg4_v07_rf2_x1 reg4_v07_rf3_x1 reg4_v07_rf4_x1 ///
			reg4_v07_rf5_x1 reg4_v07_rf6_x1 ///
			using "`source'/rf_totalz_eth.tex", replace ///
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
		esttab reg4_v08_rf1_x1 reg4_v08_rf2_x1 reg4_v08_rf3_x1 reg4_v08_rf4_x1 ///
			reg4_v08_rf5_x1 reg4_v08_rf6_x1 ///
			using "`source'/rf_raindays_eth.tex", replace ///
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
		esttab reg4_v09_rf1_x1 reg4_v09_rf2_x1 reg4_v09_rf3_x1 reg4_v09_rf4_x1 ///
			reg4_v09_rf5_x1 reg4_v09_rf6_x1 ///
			using "`source'/rf_raindaysdev_eth.tex", replace ///
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
		esttab reg4_v10_rf1_x1 reg4_v10_rf2_x1 reg4_v10_rf3_x1 reg4_v10_rf4_x1 ///
			reg4_v10_rf5_x1 reg4_v10_rf6_x1 ///
			using "`source'/rf_norain_eth.tex", replace ///
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
		esttab reg4_v11_rf1_x1 reg4_v11_rf2_x1 reg4_v11_rf3_x1 reg4_v11_rf4_x1 ///
			reg4_v11_rf5_x1 reg4_v11_rf6_x1 ///
			using "`source'/rf_noraindev_eth.tex", replace ///
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
		esttab reg4_v12_rf1_x1 reg4_v12_rf2_x1 reg4_v12_rf3_x1 reg4_v12_rf4_x1 ///
			reg4_v12_rf5_x1 reg4_v12_rf6_x1 ///
			using "`source'/rf_percentraindays_eth.tex", replace ///
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
		esttab reg4_v13_rf1_x1 reg4_v13_rf2_x1 reg4_v13_rf3_x1 reg4_v13_rf4_x1 ///
			reg4_v13_rf5_x1 reg4_v13_rf6_x1 ///
			using "`source'/rf_percentraindaysdev_eth.tex", replace ///
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
		esttab reg4_v14_rf1_x1 reg4_v14_rf2_x1 reg4_v14_rf3_x1 reg4_v14_rf4_x1 ///
			reg4_v14_rf5_x1 reg4_v14_rf6_x1 ///
			using "`source'/rf_dry_eth.tex", replace ///
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
		esttab 	reg4_v15_tp1_x1 reg4_v15_tp2_x1 reg4_v15_tp3_x1 ///
				using "`source'/tp_mean_eth.tex", replace	 ///
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
		esttab 	reg4_v16_tp1_x1 reg4_v16_tp2_x1 reg4_v16_tp3_x1 ///
				using "`source'/tp_median_eth.tex", replace	 ///
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
		esttab 	reg4_v17_tp1_x1 reg4_v17_tp2_x1 reg4_v17_tp3_x1 ///
				using "`source'/tp_variance_eth.tex", replace	 ///
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
		esttab 	reg4_v18_tp1_x1 reg4_v18_tp2_x1 reg4_v18_tp3_x1 ///
				using "`source'/tp_skew_eth.tex", replace	 ///
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
		esttab 	reg4_v19_tp1_x1 reg4_v19_tp2_x1 reg4_v19_tp3_x1 ///
				using "`source'/tp_gdd_eth.tex", replace	 ///
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
		esttab 	reg4_v20_tp1_x1 reg4_v20_tp2_x1 reg4_v20_tp3_x1 ///
				using "`source'/tp_gdddev_eth.tex", replace	 ///
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
		esttab 	reg4_v21_tp1_x1 reg4_v21_tp2_x1 reg4_v21_tp3_x1 ///
				using "`source'/tp_gddz_eth.tex", replace	 ///
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
		esttab 	reg4_v22_tp1_x1 reg4_v22_tp2_x1 reg4_v22_tp3_x1 ///
				using "`source'/tp_max_eth.tex", replace	 ///
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
			eststo		reg4_`v'
			
}			

*build tables, mwi rainfall
	* mean
		esttab reg4_v01_rf1_x1 reg4_v01_rf2_x1 reg4_v01_rf3_x1 reg4_v01_rf4_x1 ///
			reg4_v01_rf5_x1 reg4_v01_rf6_x1 ///
			using "`source'/rf_mean_mwi.tex", replace ///
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
		esttab reg4_v02_rf1_x1 reg4_v02_rf2_x1 reg4_v02_rf3_x1 reg4_v02_rf4_x1 ///
			reg4_v02_rf5_x1 reg4_v02_rf6_x1 ///
			using "`source'/rf_median_mwi.tex", replace ///
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
		esttab reg4_v03_rf1_x1 reg4_v03_rf2_x1 reg4_v03_rf3_x1 reg4_v03_rf4_x1 ///
			reg4_v03_rf5_x1 reg4_v03_rf6_x1 ///
			using "`source'/rf_var_mwi.tex", replace ///
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
		esttab reg4_v04_rf1_x1 reg4_v04_rf2_x1 reg4_v04_rf3_x1 reg4_v04_rf4_x1 ///
			reg4_v04_rf5_x1 reg4_v04_rf6_x1 ///
			using "`source'/rf_skew_mwi.tex", replace ///
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
		esttab reg4_v05_rf1_x1 reg4_v05_rf2_x1 reg4_v05_rf3_x1 reg4_v05_rf4_x1 ///
			reg4_v05_rf5_x1 reg4_v05_rf6_x1 ///
			using "`source'/rf_total_mwi.tex", replace ///
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
		esttab reg4_v06_rf1_x1 reg4_v06_rf2_x1 reg4_v06_rf3_x1 reg4_v06_rf4_x1 ///
			reg4_v06_rf5_x1 reg4_v06_rf6_x1 ///
			using "`source'/rf_totaldev_mwi.tex", replace ///
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
		esttab reg4_v07_rf1_x1 reg4_v07_rf2_x1 reg4_v07_rf3_x1 reg4_v07_rf4_x1 ///
			reg4_v07_rf5_x1 reg4_v07_rf6_x1 ///
			using "`source'/rf_totalz_mwi.tex", replace ///
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
		esttab reg4_v08_rf1_x1 reg4_v08_rf2_x1 reg4_v08_rf3_x1 reg4_v08_rf4_x1 ///
			reg4_v08_rf5_x1 reg4_v08_rf6_x1 ///
			using "`source'/rf_raindays_mwi.tex", replace ///
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
		esttab reg4_v09_rf1_x1 reg4_v09_rf2_x1 reg4_v09_rf3_x1 reg4_v09_rf4_x1 ///
			reg4_v09_rf5_x1 reg4_v09_rf6_x1 ///
			using "`source'/rf_raindaysdev_mwi.tex", replace ///
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
		esttab reg4_v10_rf1_x1 reg4_v10_rf2_x1 reg4_v10_rf3_x1 reg4_v10_rf4_x1 ///
			reg4_v10_rf5_x1 reg4_v10_rf6_x1 ///
			using "`source'/rf_norain_mwi.tex", replace ///
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
		esttab reg4_v11_rf1_x1 reg4_v11_rf2_x1 reg4_v11_rf3_x1 reg4_v11_rf4_x1 ///
			reg4_v11_rf5_x1 reg4_v11_rf6_x1 ///
			using "`source'/rf_noraindev_mwi.tex", replace ///
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
		esttab reg4_v12_rf1_x1 reg4_v12_rf2_x1 reg4_v12_rf3_x1 reg4_v12_rf4_x1 ///
			reg4_v12_rf5_x1 reg4_v12_rf6_x1 ///
			using "`source'/rf_percentraindays_mwi.tex", replace ///
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
		esttab reg4_v13_rf1_x1 reg4_v13_rf2_x1 reg4_v13_rf3_x1 reg4_v13_rf4_x1 ///
			reg4_v13_rf5_x1 reg4_v13_rf6_x1 ///
			using "`source'/rf_percentraindaysdev_mwi.tex", replace ///
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
		esttab reg4_v14_rf1_x1 reg4_v14_rf2_x1 reg4_v14_rf3_x1 reg4_v14_rf4_x1 ///
			reg4_v14_rf5_x1 reg4_v14_rf6_x1 ///
			using "`source'/rf_dry_mwi.tex", replace ///
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
		esttab 	reg4_v15_tp1_x1 reg4_v15_tp2_x1 reg4_v15_tp3_x1 ///
				using "`source'/tp_mean_mwi.tex", replace	 ///
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
		esttab 	reg4_v16_tp1_x1 reg4_v16_tp2_x1 reg4_v16_tp3_x1 ///
				using "`source'/tp_median_mwi.tex", replace	 ///
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
		esttab 	reg4_v17_tp1_x1 reg4_v17_tp2_x1 reg4_v17_tp3_x1 ///
				using "`source'/tp_variance_mwi.tex", replace	 ///
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
		esttab 	reg4_v18_tp1_x1 reg4_v18_tp2_x1 reg4_v18_tp3_x1 ///
				using "`source'/tp_skew_mwi.tex", replace	 ///
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
		esttab 	reg4_v19_tp1_x1 reg4_v19_tp2_x1 reg4_v19_tp3_x1 ///
				using "`source'/tp_gdd_mwi.tex", replace	 ///
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
		esttab 	reg4_v20_tp1_x1 reg4_v20_tp2_x1 reg4_v20_tp3_x1 ///
				using "`source'/tp_gdddev_mwi.tex", replace	 ///
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
		esttab 	reg4_v21_tp1_x1 reg4_v21_tp2_x1 reg4_v21_tp3_x1 ///
				using "`source'/tp_gddz_mwi.tex", replace	 ///
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
		esttab 	reg4_v22_tp1_x1 reg4_v22_tp2_x1 reg4_v22_tp3_x1 ///
				using "`source'/tp_max_mwi.tex", replace	 ///
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
			eststo		reg4_`v'
			
}			

*build tables, uga rainfall
	* mean
		esttab reg4_v01_rf1_x1 reg4_v01_rf2_x1 reg4_v01_rf3_x1 reg4_v01_rf4_x1 ///
			reg4_v01_rf5_x1 reg4_v01_rf6_x1 ///
			using "`source'/rf_mean_uga.tex", replace ///
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
		esttab reg4_v02_rf1_x1 reg4_v02_rf2_x1 reg4_v02_rf3_x1 reg4_v02_rf4_x1 ///
			reg4_v02_rf5_x1 reg4_v02_rf6_x1 ///
			using "`source'/rf_median_uga.tex", replace ///
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
		esttab reg4_v03_rf1_x1 reg4_v03_rf2_x1 reg4_v03_rf3_x1 reg4_v03_rf4_x1 ///
			reg4_v03_rf5_x1 reg4_v03_rf6_x1 ///
			using "`source'/rf_var_uga.tex", replace ///
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
		esttab reg4_v04_rf1_x1 reg4_v04_rf2_x1 reg4_v04_rf3_x1 reg4_v04_rf4_x1 ///
			reg4_v04_rf5_x1 reg4_v04_rf6_x1 ///
			using "`source'/rf_skew_uga.tex", replace ///
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
		esttab reg4_v05_rf1_x1 reg4_v05_rf2_x1 reg4_v05_rf3_x1 reg4_v05_rf4_x1 ///
			reg4_v05_rf5_x1 reg4_v05_rf6_x1 ///
			using "`source'/rf_total_uga.tex", replace ///
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
		esttab reg4_v06_rf1_x1 reg4_v06_rf2_x1 reg4_v06_rf3_x1 reg4_v06_rf4_x1 ///
			reg4_v06_rf5_x1 reg4_v06_rf6_x1 ///
			using "`source'/rf_totaldev_uga.tex", replace ///
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
		esttab reg4_v07_rf1_x1 reg4_v07_rf2_x1 reg4_v07_rf3_x1 reg4_v07_rf4_x1 ///
			reg4_v07_rf5_x1 reg4_v07_rf6_x1 ///
			using "`source'/rf_totalz_uga.tex", replace ///
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
		esttab reg4_v08_rf1_x1 reg4_v08_rf2_x1 reg4_v08_rf3_x1 reg4_v08_rf4_x1 ///
			reg4_v08_rf5_x1 reg4_v08_rf6_x1 ///
			using "`source'/rf_raindays_uga.tex", replace ///
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
		esttab reg4_v09_rf1_x1 reg4_v09_rf2_x1 reg4_v09_rf3_x1 reg4_v09_rf4_x1 ///
			reg4_v09_rf5_x1 reg4_v09_rf6_x1 ///
			using "`source'/rf_raindaysdev_uga.tex", replace ///
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
		esttab reg4_v10_rf1_x1 reg4_v10_rf2_x1 reg4_v10_rf3_x1 reg4_v10_rf4_x1 ///
			reg4_v10_rf5_x1 reg4_v10_rf6_x1 ///
			using "`source'/rf_norain_uga.tex", replace ///
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
		esttab reg4_v11_rf1_x1 reg4_v11_rf2_x1 reg4_v11_rf3_x1 reg4_v11_rf4_x1 ///
			reg4_v11_rf5_x1 reg4_v11_rf6_x1 ///
			using "`source'/rf_noraindev_uga.tex", replace ///
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
		esttab reg4_v12_rf1_x1 reg4_v12_rf2_x1 reg4_v12_rf3_x1 reg4_v12_rf4_x1 ///
			reg4_v12_rf5_x1 reg4_v12_rf6_x1 ///
			using "`source'/rf_percentraindays_uga.tex", replace ///
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
		esttab reg4_v13_rf1_x1 reg4_v13_rf2_x1 reg4_v13_rf3_x1 reg4_v13_rf4_x1 ///
			reg4_v13_rf5_x1 reg4_v13_rf6_x1 ///
			using "`source'/rf_percentraindaysdev_uga.tex", replace ///
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
		esttab reg4_v14_rf1_x1 reg4_v14_rf2_x1 reg4_v14_rf3_x1 reg4_v14_rf4_x1 ///
			reg4_v14_rf5_x1 reg4_v14_rf6_x1 ///
			using "`source'/rf_dry_uga.tex", replace ///
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
		esttab 	reg4_v15_tp1_x1 reg4_v15_tp2_x1 reg4_v15_tp3_x1 ///
				using "`source'/tp_mean_uga.tex", replace	 ///
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
		esttab 	reg4_v16_tp1_x1 reg4_v16_tp2_x1 reg4_v16_tp3_x1 ///
				using "`source'/tp_median_uga.tex", replace	 ///
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
		esttab 	reg4_v17_tp1_x1 reg4_v17_tp2_x1 reg4_v17_tp3_x1 ///
				using "`source'/tp_variance_uga.tex", replace	 ///
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
		esttab 	reg4_v18_tp1_x1 reg4_v18_tp2_x1 reg4_v18_tp3_x1 ///
				using "`source'/tp_skew_uga.tex", replace	 ///
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
		esttab 	reg4_v19_tp1_x1 reg4_v19_tp2_x1 reg4_v19_tp3_x1 ///
				using "`source'/tp_gdd_uga.tex", replace	 ///
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
		esttab 	reg4_v20_tp1_x1 reg4_v20_tp2_x1 reg4_v20_tp3_x1 ///
				using "`source'/tp_gdddev_uga.tex", replace	 ///
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
		esttab 	reg4_v21_tp1_x1 reg4_v21_tp2_x1 reg4_v21_tp3_x1 ///
				using "`source'/tp_gddz_uga.tex", replace	 ///
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
		esttab 	reg4_v22_tp1_x1 reg4_v22_tp2_x1 reg4_v22_tp3_x1 ///
				using "`source'/tp_max_uga.tex", replace	 ///
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
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	