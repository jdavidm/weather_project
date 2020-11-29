* Project: WB Weather
* Created on: September 2020
* Created by: alj
* Edited by: alj
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
	global	root 	= 	"$data/regression_data"
	global	stab 	= 	"$data/results_data/tables"
	global	xtab 	= 	"$data/output/paper/tables"
	global	sfig	= 	"$data/results_data/figures"	
	global 	xfig    =   "$data/output/paper/figures"
	global	logout 	= 	"$data/results_data/logs"

* open log	
	cap log close
	log 	using 		"$logout/summarytab", append

		
* **********************************************************************
* 1 - load and process data
* **********************************************************************

* load data 
	use 			"$root/lsms_panel", clear

* replace missing values as zeros for rainfall variables 1-9
	forval j = 1/9 {
	    forval i = 1/6 {
		    forval k = 0/9 {
				qui: replace		v0`j'_rf`i'_x`k' = 0 if v0`j'_rf`i'_x`k' == .    
			}
		}
	}

* replace missing values as zeros for rainfall variables 10-14
	forval j = 10/14 {
	    forval i = 1/6 {
		    forval k = 0/9 {
				qui: replace		v`j'_rf`i'_x`k' = 0 if v`j'_rf`i'_x`k' == .    
			}
		}
	}

* replace missing values as zeros for temperature variables 15-22
	forval j = 15/22 {
	    forval i = 1/3 {
		    forval k = 0/9 {
				qui: replace		v`j'_tp`i'_x`k' = 0 if v`j'_tp`i'_x`k' == .    
			}
		}
	}


* **********************************************************************
* 2 - generate summary variables
* **********************************************************************

* generate averages across extractions for rainfall variables 1-9
	forval j = 1/9 {
	    forval i = 1/6 {
				egen 		v0`j'_rf`i' = rowmean(v0`j'_rf`i'_x0 ///
								v0`j'_rf`i'_x1 v0`j'_rf`i'_x2 v0`j'_rf`i'_x3 ///
								v0`j'_rf`i'_x4 v0`j'_rf`i'_x5 v0`j'_rf`i'_x6 ///
								v0`j'_rf`i'_x7 v0`j'_rf`i'_x8 v0`j'_rf`i'_x9)  
		}
	}
	
* generate averages across extractions for rainfall variables 10-14
	forval j = 10/14 {
	    forval i = 1/6 {
				egen 		v`j'_rf`i' = rowmean(v`j'_rf`i'_x0 ///
								v`j'_rf`i'_x1 v`j'_rf`i'_x2 v`j'_rf`i'_x3 ///
								v`j'_rf`i'_x4 v`j'_rf`i'_x5 v`j'_rf`i'_x6 ///
								v`j'_rf`i'_x7 v`j'_rf`i'_x8 v`j'_rf`i'_x9)  
		}
	}

* generate averages across extractions for temperature variables 15-22
	forval j = 15/22 {
	    forval i = 1/3 {
				egen 		v`j'_tp`i' = rowmean(v`j'_tp`i'_x0 ///
								v`j'_tp`i'_x1 v`j'_tp`i'_x2 v`j'_tp`i'_x3 ///
								v`j'_tp`i'_x4 v`j'_tp`i'_x5 v`j'_tp`i'_x6 ///
								v`j'_tp`i'_x7 v`j'_tp`i'_x8 v`j'_tp`i'_x9)  
		}
	}		

* **********************************************************************
* 3 - generate table of summary statistics
* **********************************************************************
							
label var lntf_yld		"Total Farm: Log of Yield"
label var lntf_lab		"Total Farm: Log of Labor"
label var lntf_frt		"Total Farm: Log of Fertilizer Use" 
label var tf_pst		"Total Farm: Pesticide Use"
label var tf_hrb 		"Total Farm: Herbicide Use"
label var tf_irr 		"Total Farm: Irrigation Use"
label var lncp_yld		"Total Crop: Log of Yield"
label var lncp_lab		"Total Crop: Log of Labor"
label var lncp_frt		"Total Crop: Log of Fertilizer Use" 
label var cp_pst		"Total Crop: Pesticide Use"
label var cp_hrb 		"Total Crop: Herbicide Use"
label var cp_irr 		"Total Crop: Irrigation Use"

estpost tabstat lntf_yld lntf_lab lntf_frt tf_pst tf_hrb tf_irr lncp_yld lncp_lab lncp_frt cp_pst cp_hrb cp_irr, statistics(mean) by(country) col(statistics)
matrix anys = e(mean)
matrix colnames anys = Ethiopia Malawi Niger Nigeria Uganda Tanzania 	
matrix rownames anys = anys

eststo clear
estpost tabstat lntf_yld lntf_lab lntf_frt tf_pst tf_hrb tf_irr lncp_yld lncp_lab lncp_frt cp_pst cp_hrb cp_irr, statistics(mean sd p50) by(country) col(statistics)

estadd matrix anys

esttab using "$xtab/sumstat.tex", ///
	cells("mean(fmt(a2) label(Mean)) sd(fmt(a2) label(Std.\ Dev.)) p50(fmt(a2) label(50\%))") ///
	nostar nonumbers nomtitle label booktabs width(38em) replace
							
			
* **********************************************************************
* 7 - end matter
* **********************************************************************

* close the log
	log	close

/* END */