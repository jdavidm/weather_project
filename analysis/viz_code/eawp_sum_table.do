* Project: WB Weather
* Created on: November 2020
* Created by: alj
* Edited by: jdm
* Last edit: 29 November 2020 
* Stata v.16.1 

* does
	* reads in lsms data set
	* makes visualziations of summary statistics  

* assumes
	* you have results file 
	* customsave.ado
	* grc1leg2.ado

* TO DO:
	* complete
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	global	root 	= 	"$data/regression_data/eawp_sandbox"
	global	stab 	= 	"$data/results_data/tables/eawp_tables"
	global	xtab 	= 	"$data/output/paper/tables/eawp_tables"
	global	sfig	= 	"$data/results_data/figures/eawp_figures"	
	global 	xfig    =   "$data/output/paper/figures/eawp_figures"
	global	logout 	= 	"$data/results_data/logs"

* open log	
	cap log close
	log 	using 		"$logout/eawp_summarytab", append

		
* **********************************************************************
* 1 - load and process data
* **********************************************************************

* load data 
	use 			"$root/eafrica_aez_panel.dta", clear

* label variables
	lab var 		tf_hrv	"Total farm production (2010 USD)"
	lab var 		tf_lnd	"Total farmed area (ha)"
	lab var 		tf_yld	"Total farm yield (2010 USD/ha)"
	lab var 		tf_lab	"Total farm labor rate (days/ha)"
	lab var 		tf_frt	"Total farm fertilizer rate (kg/ha)" 
	lab var 		tf_pst	"Total farm pesticide use (\%)"
	lab var 		tf_hrb 	"Total farm herbicide use (\%)"
	lab var 		tf_irr 	"Total farm irrigation use (\%)"
	
	lab var 		cp_hrv	"Primary crop production (kg)"
	lab var 		cp_lnd	"Primary crop farmed area (ha)"
	lab var 		cp_yld	"Primary crop yield (kg/ha)"
	lab var 		cp_lab	"Primary crop labor rate (days/ha)"
	lab var 		cp_frt	"Primary crop fertilizer rate (kg/ha)" 
	lab var 		cp_pst	"Primary crop pesticide use (\%)"
	lab var 		cp_hrb 	"Primary crop herbicide use (\%)"
	lab var 		cp_irr 	"Primary crop irrigation use (\%)"	

	
	
* **********************************************************************
* 2.1 - create tables by country
* **********************************************************************
	
* define loop through levels of countries	
	levelsof 	country		, local(lc)
	foreach c of local lc {
		estpost 		tabstat tf* if country == `c', ///
							statistics(mean sd) columns(statistics) listwise
		est 			store sig_`c' 
	}

* output table
	esttab 				sig_1 sig_2 sig_6 sig_7 ///
							using "$xtab/var_sum_tf_country.tex", ///
							main(mean sd) cells(mean(fmt(3)) sd(fmt(3)par)) label ///
							mtitle("Ethiopia" "Malawi" "Tanzania" "Uganda") ///
							nonum collabels(none) booktabs f replace	

* define loop through levels of countries	
	levelsof 	country		, local(lc)
	foreach c of local lc {
		estpost 		tabstat cp* if country == `c', ///
							statistics(mean sd) columns(statistics) listwise
		est 			store sig_`c' 
	}

* output table
	esttab 				sig_1 sig_2 sig_6 sig_7 ///
							using "$xtab/var_sum_cp_country.tex", ///
							main(mean sd) cells(mean(fmt(3)) sd(fmt(3)par)) label ///
							mtitle("Ethiopia" "Malawi" "Tanzania" "Uganda") ///
							nonum collabels(none) booktabs f replace	


* **********************************************************************
* 2.2 - create tables by aez
* **********************************************************************							

* define loop through levels of countries	
	levelsof 	aez		, local(laez)
	foreach z of local laez {
		estpost 		tabstat tf* if aez == `z', ///
							statistics(mean sd) columns(statistics) listwise
		est 			store sig_`z' 
	}

* output table
	esttab 				sig_312 sig_313 sig_314 sig_322 sig_323 sig_324 ///
							using "$xtab/var_sum_tf_aez.tex", ///
							main(mean sd) cells(mean(fmt(3)) sd(fmt(3)par)) label ///
							mtitle("Tropic-warm/semiarid" "Tropic-warm/subhumid" "Tropic-warm/humid" ///
							"Tropic-cool/semiarid" "Troipc-cool/subhumid" "Tropic-cool/humid") ///
							nonum collabels(none) booktabs f replace	

* define loop through levels of countries	
	levelsof 	aez		, local(laez)
	foreach z of local laez {
		estpost 		tabstat cp* if aez == `z', ///
							statistics(mean sd) columns(statistics) listwise
		est 			store sig_`z' 
	}

* output table
	esttab 				sig_312 sig_313 sig_314 sig_322 sig_323 sig_324 ///
							using "$xtab/var_sum_cp_aez.tex", ///
							main(mean sd) cells(mean(fmt(3)) sd(fmt(3)par)) label ///
							mtitle("Tropic-warm/semiarid" "Tropic-warm/subhumid" "Tropic-warm/humid" ///
							"Tropic-cool/semiarid" "Troipc-cool/subhumid" "Tropic-cool/humid") ///
							nonum collabels(none) booktabs f replace							
		
		
* **********************************************************************
* 3 - end matter
* **********************************************************************

* close the log
	log	close

/* END */