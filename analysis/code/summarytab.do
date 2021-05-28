* Project: WB Weather
* Created on: May 2021
* Created by: jdm
* Edited by: jdm
* Last edit: 26 May 2021
* Stata v.16.1 

* does
	* reads in lsms data set
	* generates table of summary statistics  

* assumes
	* customsave.ado

* TO DO:
	* all of it

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	global	root 	= 	"$data/regression_data"
	global	xtab 	= 	"$data/results_data/tables"
	global	xfig    =   "$data/results_data/figures"
	global	logout 	= 	"$data/results_data/logs"

* open log	
	cap log close
	log 	using 		"$logout/summarytab", append

		
* **********************************************************************
* 1 - load and process data
* **********************************************************************

* load data 
	use 			"$root/lsms_panel", clear

* re-label variables
	lab var			tf_hrv "Total farm production (2010 USD)"
	lab var			tf_lnd "Total farmed area (ha)"
	lab var			tf_yld "Total farm yield (2010 USD/ha)"
	lab var			tf_lab "Total farm labor rate (days/ha)"
	lab var			tf_frt "Total farm fertilizer rate (kg/ha)"
	lab var			tf_pst "Total farm pesticide use (\%)"
	lab var			tf_hrb "Total farm herbicide use (\%)"
	lab var			tf_irr "Total farm irrigation use (\%)"
	
	lab var			cp_hrv "Primary crop production (kg)"
	lab var			cp_lnd "Primary crop farmed area (ha)"
	lab var			cp_yld "Primary crop yield (kg/ha)"
	lab var			cp_lab "Primary crop labor rate (days/ha)"
	lab var			cp_frt "Primary crop fertilizer rate (kg/ha)"
	lab var			cp_pst "Primary crop pesticide use (\%)"
	lab var			cp_hrb "Primary crop herbicide use (\%)"
	lab var			cp_irr "Primary crop irrigation use (\%)"
	
	
* **********************************************************************
* 2 - generate summary variables for total farm
* **********************************************************************

* generate total farm summary stats for Ethiopia	    
	estpost tabstat 	tf_hrv tf_lnd tf_yld tf_lab tf_frt tf_pst tf_hrb ///
							tf_irr if country == 1, statistics(mean sd) ///
							columns(statistics) listwise
	est store 			eth

* generate total farm summary stats for Malawi	
	estpost tabstat 	tf_hrv tf_lnd tf_yld tf_lab tf_frt tf_pst tf_hrb ///
							tf_irr if country == 2, statistics(mean sd) ///
							columns(statistics) listwise
	est store 			mwi

* generate total farm summary stats for Niger	
	estpost tabstat 	tf_hrv tf_lnd tf_yld tf_lab tf_frt tf_pst tf_hrb ///
							tf_irr if country == 4, statistics(mean sd) ///
							columns(statistics) listwise
	est store 			ngr

* generate total farm summary stats for Nigeria	
	estpost tabstat 	tf_hrv tf_lnd tf_yld tf_lab tf_frt tf_pst tf_hrb ///
							tf_irr if country == 5, statistics(mean sd) ///
							columns(statistics) listwise
	est store 			nga

* generate total farm summary stats for Tanzania	
	estpost tabstat 	tf_hrv tf_lnd tf_yld tf_lab tf_frt tf_pst tf_hrb ///
							tf_irr if country == 6, statistics(mean sd) ///
							columns(statistics) listwise
	est store 			tza

* generate total farm summary stats for Uganda	
	estpost tabstat 	tf_hrv tf_lnd tf_yld tf_lab tf_frt tf_pst tf_hrb ///
							tf_irr if country == 7, statistics(mean sd) ///
							columns(statistics) listwise
	est store 			uga

* output panel A of summary stats table (total farm)
	esttab 			eth mwi ngr nga tza uga using "$xtab/sumtab.tex", ///
						replace main(mean) aux(sd) cells(mean(fmt(a3)) ///
						sd(fmt(a3)par)) label booktabs nonum nonum collabels(none) f ///
						refcat(tf_hrv "\multicolumn{7}{l}{\emph{\textbf{Panel A}: Total Farm Production}}", nolabel) ///
						mtitle("Ethiopia" "Malawi" "Niger" "Nigeria" "Tanzania" "Uganda") ///
						stats(N, fmt(%18.0g) labels("\midrule Observations"))


* **********************************************************************
* 3 - generate summary variables for primary crop
* **********************************************************************

* generate primary crop summary stats for Ethiopia	    
	estpost tabstat 	cp_hrv cp_lnd cp_yld cp_lab cp_frt cp_pst cp_hrb ///
							cp_irr if country == 1, statistics(mean sd) ///
							columns(statistics) listwise
	est store 			eth

* generate primary crop summary stats for Malawi	
	estpost tabstat 	cp_hrv cp_lnd cp_yld cp_lab cp_frt cp_pst cp_hrb ///
							cp_irr if country == 2, statistics(mean sd) ///
							columns(statistics) listwise
	est store 			mwi

* generate primary crop summary stats for Niger	
	estpost tabstat 	cp_hrv cp_lnd cp_yld cp_lab cp_frt cp_pst cp_hrb ///
							cp_irr if country == 4, statistics(mean sd) ///
							columns(statistics) listwise
	est store 			ngr

* generate primary crop summary stats for Nigeria	
	estpost tabstat 	cp_hrv cp_lnd cp_yld cp_lab cp_frt cp_pst cp_hrb ///
							cp_irr if country == 5, statistics(mean sd) ///
							columns(statistics) listwise
	est store 			nga

* generate primary crop summary stats for Tanzania	
	estpost tabstat 	cp_hrv cp_lnd cp_yld cp_lab cp_frt cp_pst cp_hrb ///
							cp_irr if country == 6, statistics(mean sd) ///
							columns(statistics) listwise
	est store 			tza

* generate primary crop summary stats for Uganda	
	estpost tabstat 	cp_hrv cp_lnd cp_yld cp_lab cp_frt cp_pst cp_hrb ///
							cp_irr if country == 7, statistics(mean sd) ///
							columns(statistics) listwise
	est store 			uga

* output panel A of summary stats table (primary crop)
	esttab 			eth mwi ngr nga tza uga using "$xtab/sumtab.tex", ///
						append nomtitles main(mean) aux(sd) cells(mean(fmt(a3)) ///
						sd(fmt(a3)par)) label booktabs nonum nonum collabels(none) f ///
						refcat(cp_hrv "\multicolumn{7}{l}{\emph{\textbf{Panel B}: Primary Crop Production}}", nolabel) ///
						stats(N, fmt(%18.0g) labels("\midrule Observations"))

			
* **********************************************************************
* 4 - end matter
* **********************************************************************

* close the log
	log	close

/* END */