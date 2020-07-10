* Project: WB Weather
* Created on: May 2020
* Created by: ek
* Stata v.16

* does
	* merges individual cleaned plot datasets together
	* imputes values for continuous variables
	* collapses to wave 1 plot level data to household level for combination with other waves

* assumes
	* previously cleaned household datasets
	* customsave.ado

* note
	* region, dept, and canton are missing for all variables
	
* to do
	* review and approve edits
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		root	=	"$data/household_data/niger/wave_1/refined"
	loc 	export	=	"$data/household_data/niger/wave_1/refined"
	loc 	logout	=	"$data/household_data/niger/logs"

* open log
	cap 	log 	close
	log 	using 	"`logout'/2011_niger_merge", append

	
* **********************************************************************
* 1 - merge plot level data sets together
* **********************************************************************

* start by loading harvest quantity and value, since this is our limiting factor
	use 			"`root'/2011_ase1p2_1.dta", clear

	isid			plot_id
	isid 			clusterid hh_num field parcel ord
	
* merge in plot size data
	merge 			m:1 clusterid hh_num field parcel using "`root'/2011_as1p1", generate(_as1p1)
	*** 33 not matched from master out of 1409 not matched 
	*** most unmerged (1376) are from using, meaning we lack production data
	*** per Malawi (rs_plot) we drop all unmerged observations
	
	drop			if _as1p1 != 3
	
* no irrigation, no seed use rate 

* merging in labor data
	merge		m:1 clusterid hh_num field parcel using "`root'/2011_as2ap1_f", generate(_as2ap1f)
	*** 0 unmatched from master
	*** 1407 not merged from using
	
	drop			if _as2ap1f == 2
		
* merging in pesticide and herbicide use
	merge		m:1 clusterid hh_num field parcel using "`root'/2011_pp_as2ap1", generate(_ppas2ap1)
	*** 0 not matched from master
	
* 1407 did not match from using 	
	drop			if _ppas2ap1 == 2

* merging in fertilizer use
	merge		m:1 clusterid hh_num field parcel using "`root'/2011_pp_as2ap1fert", generate(_ppas2ap1fert)
	*** 0 unmatched from master
	*** 1407 did not match from using
	
	drop			if _ppas2ap1fert == 2

* drop observations missing values (not in continuous)
	drop			if plotsize == .
	drop			if pest_any == .
	drop			if herb_any == .
	*** no observations dropped

	drop			_as1p1 _as2ap1f _ppas2ap1 _ppas2ap1fert 

* **********************************************************************
* 2 - impute: yield, value per hectare, labor (both), fertilizer use 
* **********************************************************************


* ******************************************************************************
* FOLLOWING WB: we will construct production variables on a per hectare basis,
* and conduct imputation on the per hectare variables. We will then create 
* 'imputed' versions of the non-per hectare variables (e.g. harvest, 
* value) by multiplying the imputed per hectare vars by plotsize. 
* This approach relies on the assumptions that the 1) GPS measurements are 
* reliable, and 2) outlier values are due to errors in the respondent's 
* self-reported production quantities (see rs_plot.do)
* ******************************************************************************


* **********************************************************************
* 2a - impute: yield
* **********************************************************************

* construct maize yield
	gen				mz_yld = mz_hrv / plotsize, after(mz_hrv)
	lab var			mz_yld	"millet yield (kg/ha)"

* impute zero values	
	
* impute yield outliers
	sum				mz_yld mz_hrv
	bysort canton : egen stddev = sd(mz_yld) if !inlist(mz_yld,.,0)
	recode 			stddev (.=0)
	bysort canton : egen median = median(mz_yld) if !inlist(mz_yld,.,0)
	bysort canton : egen replacement = median(mz_yld) if /// 
						(mz_yld <= median + (3 * stddev)) & ///
						(mz_yld >= median - (3 * stddev)) & !inlist(mz_yld,.,0)
	bysort canton : egen maxrep = max(replacement)
	bysort canton : egen minrep = min(replacement)
	assert 			minrep==maxrep
	generate 		mz_yldimp = mz_yld, after(mz_yld)
	replace  		mz_yldimp = maxrep if !((mz_yld < median + (3 * stddev)) ///
						& (mz_yld > median - (3 * stddev))) ///
						& !inlist(mz_yld,.,0) & !mi(maxrep)
	tabstat 		mz_yld mz_yldimp, ///
						f(%9.0f) s(n me min p1 p50 p95 p99 max) c(s) longstub
	*** reduces mean from 969 to 345
	*** the outliers are now 33182 from 480000

					
	drop 			stddev median replacement maxrep minrep
	lab var 		mz_yldimp "millet yield (kg/ha), imputed"

* inferring imputed harvest quantity from imputed yield value 
	generate 		mz_hrvimp = mz_yldimp * plotsize, after(mz_hrv)
	lab var 		mz_hrvimp "millet harvest quantity (kg), imputed"
	lab var 		mz_hrv "millet harvest quantity (kg)"

	sum				mz_hrv mz_hrvimp
	*** reduces mean from 164 to 162
	*** max at 780 - no change 

* **********************************************************************
* 2b - impute: value
* **********************************************************************
	
* construct production value per hectare
	gen				vl_yld = vl_hrv / plotsize
	assert 			!missing(vl_yld)
	lab var			vl_yld "value of yield (2010USD/ha)"

* impute value per hectare outliers 
	sum				vl_yld
	bysort canton :	egen stddev = sd(vl_yld) if !inlist(vl_yld,.,0)
	recode stddev	(.=0)
	bysort canton :	egen median = median(vl_yld) if !inlist(vl_yld,.,0)
	bysort canton :	egen replacement = median(vl_yld) if  ///
						(vl_yld <= median + (3 * stddev)) & ///
						(vl_yld >= median - (3 * stddev)) & !inlist(vl_yld,.,0)
	bysort canton :	egen maxrep = max(replacement)
	bysort canton :	egen minrep = min(replacement)
	assert 			minrep==maxrep
	generate 		vl_yldimp = vl_yld
	replace  		vl_yldimp = maxrep if !((vl_yld < median + (3 * stddev)) ///
						& (vl_yld > median - (3 * stddev))) ///
						& !inlist(vl_yld,.,0) & !mi(maxrep)
	tabstat			vl_yld vl_yldimp, ///
						f(%9.0f) s(n me min p1 p50 p95 p99 max) c(s) longstub
	*** reduces mean from 153 to 53
	*** max is high but not unreasonable - 7063

						
	drop			stddev median replacement maxrep minrep
	lab var			vl_yldimp	"value of yield (2010USD/ha), imputed"

* inferring imputed harvest value from imputed harvest value per hectare
	generate		vl_hrvimp = vl_yldimp * plotsize 
	lab var			vl_hrvimp "value of harvest (2010USD), imputed"
	lab var			vl_hrv "value of harvest (2010USD)"
	
	sum				vl_hrv vl_hrvimp 
	*** reduces mean from 19.6 to 19.4
	*** no change in max 
	
* **********************************************************************
* 2c - impute: labor
* **********************************************************************

* generate total labor days
	egen			labordays = rsum(prep_labor_all plant_labor_all harvest_labor_all)
	lab var			labordays "farm labor (days)"

* construct labor days per hectare
	gen				labordays_ha = labordays / plotsize, after(labordays)
	lab var			labordays_ha "farm labor use (days/ha)"
	sum				labordays labordays_ha

* impute labor outliers, right side only 
	sum				labordays_ha, detail
	bysort canton :	egen stddev = sd(labordays_ha) if !inlist(labordays_ha,.,0)
	recode 			stddev (.=0)
	bysort canton :	egen median = median(labordays_ha) if !inlist(labordays_ha,.,0)
	bysort canton :	egen replacement = median(labordays_ha) if ///
						(labordays_ha <= median + (3 * stddev)) & ///
						(labordays_ha >= median - (3 * stddev)) & !inlist(labordays_ha,.,0)
	bysort canton :	egen maxrep = max(replacement)
	bysort canton :	egen minrep = min(replacement)
	assert			minrep==maxrep
	gen				labordays_haimp = labordays_ha, after(labordays_ha)
	replace 		labordays_haimp = maxrep if !((labordays_ha < median + (3 * stddev)) ///
						& (labordays_ha > median - (3 * stddev))) ///
						& labordays_ha != 0 & !mi(maxrep)
	*** note that this code is slighlty different so we can impute missing values
	tabstat 		labordays_ha labordays_haimp, ///
						f(%9.0f) s(n me min p1 p50 p95 p99 max) c(s) longstub
	*** reduces mean from 382 to 144
	*** max is 9928 relatively high
	
	drop			stddev median replacement maxrep minrep
	lab var			labordays_haimp	"farm labor use (days/ha), imputed"

* make labor days based on imputed labor days per hectare
	gen				labordaysimp = labordays_haimp * plotsize, after(labordays)
	lab var			labordaysimp "farm labor (days), imputed"

	sum				labordays labordaysimp 
	*** reduces mean from 56.6 to 56
	*** no change in max (587)
	

* **********************************************************************
* 2d - impute: fertilizer
* **********************************************************************

* construct fertilizer use per hectare
	rename			fert_use fert
	gen				fert_ha = fert / plotsize, after(fert)
	lab var			fert_ha "fertilizer use (kg/ha)"
	sum				fert fert_ha

* impute fert outliers, right side only 
	sum				fert_ha, detail
	bysort canton :	egen stddev = sd(fert_ha) if !inlist(fert_ha,.,0)
	recode 			stddev (.=0)
	bysort canton :	egen median = median(fert_ha) if !inlist(fert_ha,.,0)
	bysort canton :	egen replacement = median(fert_ha) if ///
						(fert_ha <= median + (3 * stddev)) & ///
						(fert_ha >= median - (3 * stddev)) & !inlist(fert_ha,.,0)
	bysort canton :	egen maxrep = max(replacement)
	bysort canton :	egen minrep = min(replacement)
	assert			minrep==maxrep
	gen				fert_haimp = fert_ha, after(fert_ha)
	replace 		fert_haimp = maxrep if !((fert_ha < median + (3 * stddev)) ///
						& (fert_ha > median - (3 * stddev))) ///
						& fert_ha != 0 & !mi(maxrep)
	*** note that this code is slighlty different so we can impute missing values
	tabstat 		fert_ha fert_haimp, ///
						f(%9.0f) s(n me min p1 p50 p95 p99 max) c(s) longstub
	*** reduces mean from 21 to 9
	*** max is at 4167 
	
	drop			stddev median replacement maxrep minrep
	lab var			fert_haimp	"fertilizer use (kg/ha), imputed"

* make labor days based on imputed labor days per hectare
	gen				fertimp = fert_haimp * plotsize, after(fert)
	lab var			fertimp "fertilizer (kg), imputed"
	lab var			fert "fertilizer (kg)"

	replace			fert_any = 1 if fertimp > 0
	replace			fert_any = 2 if fertimp == 0

	sum				fert_ha fert_haimp
	*** mean reduces from 21.2 to 9.4
	*** max is 4166
	
* **********************************************************************
* 3 - collapse to household level
* **********************************************************************

* **********************************************************************
* 3a - generate total farm variables
* **********************************************************************

* generate plot area
	bysort			clusterid hh_num :	egen tf_lnd = sum(plotsize)
	lab var			tf_lnd	"Total farmed area (ha)"
	assert			tf_lnd > 0 
	sum				tf_lnd, detail

* value of harvest
	bysort			clusterid hh_num :	egen tf_hrv = sum(vl_hrvimp)
	lab var			tf_hrv	"Total value of harvest (2010 USD)"
	sum				tf_hrv, detail
	
* value of yield
	generate		tf_yld = tf_hrv / tf_lnd
	lab var			tf_yld	"value of yield (2010 USD/ha)"
	sum				tf_yld, detail
	
* labor
	bysort 			clusterid hh_num : egen lab_tot = sum(labordaysimp)
	generate		tf_lab = lab_tot / tf_lnd
	lab var			tf_lab	"labor rate (days/ha)"
	sum				tf_lab, detail
	
* fertilizer
	bysort 			clusterid hh_num : egen fert_tot = sum(fertimp)
	generate		tf_frt = fert_tot / tf_lnd
	lab var			tf_frt	"fertilizer rate (kg/ha)"
	sum				tf_frt, detail

* pesticide
	replace			pest_any = 0 if pest_any == 2
	tab				pest_any, missing
	bysort 			clusterid hh_num : egen tf_pst = max(pest_any)
	lab var			tf_pst	"Any plot has pesticide"
	tab				tf_pst
	
* herbicide
	replace			herb_any = 0 if herb_any == 2
	tab				herb_any, missing
	bysort 			clusterid hh_num : egen tf_hrb = max(herb_any)
	lab var			tf_hrb	"Any plot has herbicide"
	tab				tf_hrb
	
* **********************************************************************
* 3b - generate maize variables 
* **********************************************************************	
	
* generate plot area
	bysort			clusterid hh_num :	egen cp_lnd = sum(plotsize) ///
						if mz_hrvimp != .
	lab var			cp_lnd	"Total millet area (ha)"
	assert			cp_lnd > 0 
	sum				cp_lnd, detail

* value of harvest
	bysort			clusterid hh_num :	egen cp_hrv = sum(vl_hrvimp) ///
						if mz_hrvimp != .
	lab var			cp_hrv	"Total quantity of millet harvest (kg)"
	sum				cp_hrv, detail
	
* value of yield
	generate		cp_yld = cp_hrv / cp_lnd if mz_hrvimp != .
	lab var			cp_yld	"Millet yield (kg/ha)"
	sum				cp_yld, detail
	
* labor
	bysort 			clusterid hh_num : egen lab_mz = sum(labordaysimp) ///
						if mz_hrvimp != .
	generate		cp_lab = lab_mz / cp_lnd
	lab var			cp_lab	"labor rate for millet (days/ha)"
	sum				cp_lab, detail

* fertilizer
	bysort 			clusterid hh_num : egen fert_mz = sum(fertimp) ///
						if mz_hrvimp != .
	generate		cp_frt = fert_mz / cp_lnd
	lab var			cp_frt	"fertilizer rate for millet (kg/ha)"
	sum				cp_frt, detail

* pesticide
	tab				pest_any, missing
	bysort 			clusterid hh_num : egen cp_pst = max(pest_any) /// 
						if mz_hrvimp != .
	lab var			cp_pst	"Any millet plot has pesticide"
	tab				cp_pst
	
* herbicide
	tab				herb_any, missing
	bysort 			clusterid hh_num : egen cp_hrb = max(herb_any) ///
						if mz_hrvimp != .
	lab var			cp_hrb	"Any millet plot has herbicide"
	tab				cp_hrb

* verify values are accurate
	sum				tf_* cp_*

	*** the total farm land and crop land are a bit high and so are total harvests.
	
* collapse to the household level
	loc	cp			cp_*
	foreach v of varlist `cp'{
	    replace		`v' = 0 if `v' == .
	}		
	
	collapse (max)	tf_* cp_*, by(clusterid hh_num)
	*** we went from 8741 to 2135 observations 
	
* return non-maize production to missing
	replace			cp_yld = . if cp_yld == 0
	replace			cp_hrb = 1 if cp_hrb > 0
	replace			cp_hrb = . if cp_yld == .
	replace			cp_pst = 1 if cp_pst > 0
	replace			cp_pst = . if cp_yld == .
	replace			cp_frt = . if cp_yld == .
	replace			cp_lnd = . if cp_yld == .
	replace			cp_hrv = . if cp_yld == .
	replace			cp_lab = . if cp_yld == .

* adjust binary total farm variables
	replace			tf_pst = 1 if tf_pst > 0
	replace			tf_hrb = 1 if tf_hrb > 0
	
* verify values are accurate
	sum				tf_* cp_*
	*** most values seem much more reasonable
	*** labor has a very large max

* checks and balances
	*** Production variables should corroborate each other. 
	*** Use discrepencies between production variables to determine if an outlier is a mistake and replace that outlier with missing then impute them.
	*** A high labor should be associated with a high land area and yield and a high yield should be associated with a high value. 

* check correlation at high values of labor with value
	sum 			tf_lab, detail
	sum 			tf_hrv, detail
	tab 			tf_hrv tf_lab 	if tf_lab > 5000
	*** at the higher end high labor has low yields
	pwcorr 			tf_lab tf_hrv 	if tf_lab> 300
	*** really poor correlation and unexpectadly negative with labor and yield: -0.062
	
	tab tf_hrv if tf_lab==0
	*** 10 observations have no labor but a non-negative harvest
	scatter 		tf_hrv tf_lab
	*** the outliers show that at the highest applications of labor to land we see some of the lowest harvest values
	
	sum tf_lab, detail
	*** mean 188, max 61666
	
	replace tf_lab = . if tf_lab >5000
	replace tf_lab = . if tf_lab == 0 & tf_yld != 0
	*** 21 changes made
	
* impute missing labor values using predictive mean matching
	mi set 			wide // declare the data to be wide.
	mi xtset		, clear // this is a precautinary step to clear any existing xtset
	mi register 	imputed tf_lab // identify tf_lab as the variable being imputed
	sort			tf_hrv clusterid, stable // sort to ensure reproducability of results
	mi impute 		pmm tf_lab i.clusterid tf_hrv, add(1) rseed(245780) noisily dots ///
						force knn(5) bootstrap
	mi unset
	
	sum 			tf_lab_1_, detail
	*** mean 89.8, max 4277
	*** looks good
	
	replace 		tf_lab = tf_lab_1_
	drop 			tf_lab_1_
	
	pwcorr 			tf_lab tf_hrv
	*** larger negative correlation between hours/ha and value of harvest after impute: -0.11

* check correlation at high values of labor with crop value
	sum 			cp_lab, detail
	sum 			cp_hrv, detail
	tab 			cp_hrv cp_lab 	if cp_lab > 5000
	*** at the higher end high labor has mostly low harvests
	pwcorr 			cp_lab tf_hrv 	if cp_lab> 300
	*** poor correlation and unexpectadly negative with labor and harvest: -0.108
	
	tab 			cp_hrv if cp_lab==0
	*** 6 observations have no labor but a non-negative harvest
	scatter 		cp_hrv cp_lab
	*** the outliers show that at the highest applications of labor to land we see some of the lowest harvest values
	
	sum 			cp_lab, detail
	*** mean 149.4, max 61666
	
	replace 		cp_lab = . 	if cp_lab >5000
	replace 		cp_lab = . 	if cp_lab == 0 & cp_yld != 0
	*** 13 changes made
	
* impute missing labor values using predictive mean matching
	mi set 			wide // declare the data to be wide.
	mi xtset		, clear // this is a precautinary step to clear any existing xtset
	mi register 	imputed cp_lab // identify cp_lab as the variable being imputed
	sort			cp_hrv clusterid, stable // sort to ensure reproducability of results
	mi impute 		pmm cp_lab i.clusterid tf_hrv, add(1) rseed(245780) noisily dots ///
						force knn(5) bootstrap
	mi unset
	
	sum 			cp_lab_1_, detail
	*** mean 74.6, max 4634
	*** looks good
	
	replace 		cp_lab = cp_lab_1_
	drop 			cp_lab_1_
	
	pwcorr 			cp_lab cp_hrv
	*** reduced the negative correlation between cp_lab and cp_hrv but closer to 0 after impute (-.086)
	
* verify values are accurate
	sum				tf_* cp_*
	
* **********************************************************************
* 4 - end matter, clean up to save
* **********************************************************************

* generate year identifier
	gen				year = 2011
	lab var			year "Year"
	
* create unique household identifier
	*** all observations are missing region, canton and dept, will create id without region, canton and dept for now
	isid				 clusterid hh_num
	sort				clusterid hh_num, stable 
	egen				hh_id = group(clusterid hh_num)
	lab var				hh_id "unique household identifier"
		
	order 			clusterid hh_num hh_id year tf_hrv tf_lnd tf_yld ///
						tf_lab tf_frt tf_pst tf_hrb cp_hrv cp_lnd ///
						cp_yld cp_lab cp_frt cp_pst cp_hrb
	compress
	describe
	summarize 
	
* saving production dataset
	customsave , idvar(hh_id) filename(hhfinal_niger2011.dta) path("`export'") ///
			dofile(2011_merge) user($user) 

* close the log
	log	close

/* END */
