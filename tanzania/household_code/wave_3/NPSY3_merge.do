* Project: WB Weather
* Created on: May 2020
* Created by: jdm
* Edited by : alj
* Stata v.16

* does
	* merges individual cleaned plot datasets together
	* imputes values for continuous variables
	* collapses to wave 2 plot level data to household level for combination with other waves

* assumes
	* previously cleaned household datasets
	* customsave.ado

* TO DO:
	* everything
	* imputations 


* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root = "$data/household_data/tanzania/wave_3/refined"
	loc export = "$data/household_data/tanzania/wave_3/refined"
	loc logout = "$data/household_data/tanzania/logs"

* open log
	log using "`logout'/NPSY4_MERGE", append

	
* **********************************************************************
* 1a - merge plot level data sets together
* **********************************************************************

* start by loading harvest quantity and value, since this is our limiting factor
	use 			"`root'/AG_SEC4A", clear

	isid			plot_id

* merge in plot size data
	merge 			1:1 plot_id using "`root'/AG_SEC2A", generate(_2A)
	*** 0 out of 4702 missing in master 
	*** all unmerged obs came from using data 
	*** meaning we lacked production data
	*** per Malawi (rs_plot) we drop all unmerged observations
	
	drop			if _2A != 3
	
* merging in production inputs data
	merge			1:1 plot_id using "`root'/AG_SEC3A", generate(_3A)
	*** 0 out of 4702 missing in master 
	*** all unmerged obs came from using data 
	*** meaning we lacked production data

	drop			if _3A != 3
	
* fill in missing values
	replace			irrigated = 2 if irrigated == .

* drop observations missing values (not in continuous)
	drop			if plotsize == .
	drop			if irrigated == .
	drop			if pesticide_any == .
	drop			if herbicide_any == .
	*** no observations dropped

	drop			_2A _3A
	
* **********************************************************************
* 1b - adjusting variable names (for imputation)
* **********************************************************************

	rename 			hvst_value vl_hrv
	rename			labor_days	labordays
	rename			kilo_fert fert
	rename			pesticide_any pest_any
	rename 			herbicide_any herb_any
	rename			irrigated irr_any
	
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
	assert			!missing(mz_yld) if !missing(mz_hrv)
	lab var			mz_yld	"maize yield (kg/ha)"

*maybe imputing zero values	
	
* impute yield outliers
	sum				mz_yld
	bysort region : egen stddev = sd(mz_yld) if !inlist(mz_yld,.,0)
	recode 			stddev (.=0)
	bysort region : egen median = median(mz_yld) if !inlist(mz_yld,.,0)
	bysort region : egen replacement = median(mz_yld) if /// 
						(mz_yld <= median + (3 * stddev)) & ///
						(mz_yld >= median - (3 * stddev)) & !inlist(mz_yld,.,0)
	bysort region : egen maxrep = max(replacement)
	bysort region : egen minrep = min(replacement)
	assert 			minrep==maxrep
	generate 		mz_yldimp = mz_yld, after(mz_yld)
	replace  		mz_yldimp = maxrep if !((mz_yld < median + (3 * stddev)) ///
					& (mz_yld > median - (3 * stddev))) ///
					& !inlist(mz_yld,.,0) & !mi(maxrep)
	tabstat 		mz_yld mz_yldimp, ///
					f(%9.0f) s(n me min p1 p50 p95 p99 max) c(s) longstub
	*** reduces mean from 857 to 683
					
	drop 			stddev median replacement maxrep minrep
	lab var 		mz_yldimp "maize yield (kg/ha), imputed"

* inferring imputed harvest quantity from imputed yield value 
	generate 		mz_hrvimp = mz_yldimp * plotsize, after(mz_hrv)
	lab var 		mz_hrvimp "maize harvest quantity (kg), imputed"
	lab var 		mz_hrv "maize harvest quantity (kg)"


* **********************************************************************
* 2b - impute: value
* **********************************************************************
	
* construct production value per hectare
	gen				vl_yld = vl_hrv / plotsize
	assert 			!missing(vl_yld)
	lab var			vl_yld "value of yield (2010USD/ha)"

* impute value per hectare outliers 
	sum				vl_yld
	bysort region :	egen stddev = sd(vl_yld) if !inlist(vl_yld,.,0)
	recode stddev	(.=0)
	bysort region :	egen median = median(vl_yld) if !inlist(vl_yld,.,0)
	bysort region :	egen replacement = median(vl_yld) if  ///
						(vl_yld <= median + (3 * stddev)) & ///
						(vl_yld >= median - (3 * stddev)) & !inlist(vl_yld,.,0)
	bysort region :	egen maxrep = max(replacement)
	bysort region :	egen minrep = min(replacement)
	assert 			minrep==maxrep
	generate 		vl_yldimp = vl_yld
	replace  		vl_yldimp = maxrep if !((vl_yld < median + (3 * stddev)) ///
						& (vl_yld > median - (3 * stddev))) ///
						& !inlist(vl_yld,.,0) & !mi(maxrep)
	tabstat			vl_yld vl_yldimp, ///
						f(%9.0f) s(n me min p1 p50 p95 p99 max) c(s) longstub
	*** reduces mean from 388 to 269
						
	drop			stddev median replacement maxrep minrep
	lab var			vl_yldimp	"value of yield (2010USD/ha), imputed"

* inferring imputed harvest value from imputed harvest value per hectare
	generate		vl_hrvimp = vl_yldimp * plotsize 
	lab var			vl_hrvimp "value of harvest (2010USD), imputed"
	lab var			vl_hrv "value of harvest (2010USD)"
	

* **********************************************************************
* 2c - impute: labor
* **********************************************************************

* construct labor days per hectare
	gen				labordays_ha = labordays / plotsize, after(labordays)
	lab var			labordays_ha "farm labor use (days/ha)"
	sum				labordays labordays_ha

* impute labor outliers, right side only 
	sum				labordays_ha, detail
	bysort region :	egen stddev = sd(labordays_ha) if !inlist(labordays_ha,.,0)
	recode 			stddev (.=0)
	bysort region :	egen median = median(labordays_ha) if !inlist(labordays_ha,.,0)
	bysort region :	egen replacement = median(labordays_ha) if ///
						(labordays_ha <= median + (3 * stddev)) & ///
						(labordays_ha >= median - (3 * stddev)) & !inlist(labordays_ha,.,0)
	bysort region :	egen maxrep = max(replacement)
	bysort region :	egen minrep = min(replacement)
	assert			minrep==maxrep
	gen				labordays_haimp = labordays_ha, after(labordays_ha)
	replace 		labordays_haimp = maxrep if !((labordays_ha < median + (3 * stddev)) ///
						& (labordays_ha > median - (3 * stddev))) ///
						& !inlist(labordays_ha,.,0) & !mi(maxrep)
	tabstat 		labordays_ha labordays_haimp, ///
						f(%9.0f) s(n me min p1 p50 p95 p99 max) c(s) longstub
	*** reduces mean from 298 to 219
	
	drop			stddev median replacement maxrep minrep
	lab var			labordays_haimp	"farm labor use (days/ha), imputed"

* make labor days based on imputed labor days per hectare
	gen				labordaysimp = labordays_haimp * plotsize, after(labordays)
	lab var			labordaysimp "farm labor (days), imputed"


* **********************************************************************
* 2d - impute: fertilizer
* **********************************************************************

* construct fertilizer use per hectare
	gen				fert_ha = fert / plotsize, after(fert)
	lab var			fert_ha "fertilizer use (kg/ha)"
	sum				fert fert_ha

* impute labor outliers, right side only 
	sum				fert_ha, detail
	bysort region :	egen stddev = sd(fert_ha) if !inlist(fert_ha,.,0)
	recode 			stddev (.=0)
	bysort region :	egen median = median(fert_ha) if !inlist(fert_ha,.,0)
	bysort region :	egen replacement = median(fert_ha) if ///
						(fert_ha <= median + (3 * stddev)) & ///
						(fert_ha >= median - (3 * stddev)) & !inlist(fert_ha,.,0)
	bysort region :	egen maxrep = max(replacement)
	bysort region :	egen minrep = min(replacement)
	assert			minrep==maxrep
	gen				fert_haimp = fert_ha, after(fert_ha)
	replace 		fert_haimp = maxrep if !((fert_ha < median + (3 * stddev)) ///
						& (fert_ha > median - (3 * stddev))) ///
						& fert_ha != 0 & !mi(maxrep)
	*** note that this code is slighlty different we don't use !inlist
	tabstat 		fert_ha fert_haimp, ///
						f(%9.0f) s(n me min p1 p50 p95 p99 max) c(s) longstub
	*** reduces mean from 26 to 20
	
	drop			stddev median replacement maxrep minrep
	lab var			fert_haimp	"fertilizer use (kg/ha), imputed"

* make labor days based on imputed labor days per hectare
	gen				fertimp = fert_haimp * plotsize, after(fert)
	lab var			fertimp "fertilizer (kg), imputed"
	lab var			fert "fertilizer (kg)"

	replace			fert_any = 1 if fertimp > 0
	replace			fert_any = 2 if fertimp == 0


* **********************************************************************
* 3 - collapse to household level
* **********************************************************************
* **********************************************************************
* 3a - generate total farm variables
* **********************************************************************

* generate plot area
	bysort			hhid (plot_id) :	egen tf_lnd = sum(plotsize)
	lab var			tf_lnd	"Total farmed area (ha)"
	assert			tf_lnd > 0 
	sum				tf_lnd, detail

* value of harvest
	bysort			hhid (plot_id) :	egen tf_hrv = sum(vl_hrvimp)
	lab var			tf_hrv	"Total value of harvest (2010 USD)"
	sum				tf_hrv, detail
	
* value of yield
	generate		tf_yld = tf_hrv / tf_lnd
	lab var			tf_yld	"value of yield (2010 USD/ha)"
	sum				tf_yld, detail
	
* labor
	bysort 			hhid (plot_id) : egen lab_tot = sum(labordaysimp)
	generate		tf_lab = lab_tot / tf_lnd
	lab var			tf_lab	"labor rate (days/ha)"
	sum				tf_lab, detail

* fertilizer
	bysort 			hhid (plot_id) : egen fert_tot = sum(fertimp)
	generate		tf_frt = fert_tot / tf_lnd
	lab var			tf_frt	"fertilizer rate (kg/ha)"
	sum				tf_frt, detail

* pesticide
	replace			pest_any = 0 if pest_any == 2
	tab				pest_any, missing
	bysort 			hhid (plot_id) : egen tf_pst = max(pest_any)
	lab var			tf_pst	"Any plot has pesticide"
	tab				tf_pst
	
* herbicide
	replace			herb_any = 0 if herb_any == 2
	tab				herb_any, missing
	bysort 			hhid (plot_id) : egen tf_hrb = max(herb_any)
	lab var			tf_hrb	"Any plot has herbicide"
	tab				tf_hrb
	
* irrigation
	replace			irr_any = 0 if irr_any == 2
	tab				irr_any, missing
	bysort 			hhid (plot_id) : egen tf_irr = max(irr_any)
	lab var			tf_irr	"Any plot has irrigation"
	tab				tf_irr
	
* **********************************************************************
* 3b - generate maize variables 
* **********************************************************************	
	
* generate plot area
	bysort			hhid (plot_id) :	egen cp_lnd = sum(plotsize) ///
						if mz_hrvimp != .
	lab var			cp_lnd	"Total maize area (ha)"
	assert			cp_lnd > 0 
	sum				cp_lnd, detail

* value of harvest
	bysort			hhid (plot_id) :	egen cp_hrv = sum(vl_hrvimp) ///
						if mz_hrvimp != .
	lab var			cp_hrv	"Total quantity of maize harvest (kg)"
	sum				cp_hrv, detail
	
* value of yield
	generate		cp_yld = cp_hrv / cp_lnd if mz_hrvimp != .
	lab var			cp_yld	"Maize yield (kg/ha)"
	sum				cp_yld, detail
	
* labor
	bysort 			hhid (plot_id) : egen lab_mz = sum(labordaysimp) ///
						if mz_hrvimp != .
	generate		cp_lab = lab_mz / cp_lnd
	lab var			cp_lab	"labor rate for maize (days/ha)"
	sum				cp_lab, detail

* fertilizer
	bysort 			hhid (plot_id) : egen fert_mz = sum(fertimp) ///
						if mz_hrvimp != .
	generate		cp_frt = fert_mz / cp_lnd
	lab var			cp_frt	"fertilizer rate for maize (kg/ha)"
	sum				cp_frt, detail

* pesticide
	tab				pest_any, missing
	bysort 			hhid (plot_id) : egen cp_pst = max(pest_any) /// 
						if mz_hrvimp != .
	lab var			cp_pst	"Any maize plot has pesticide"
	tab				cp_pst
	
* herbicide
	tab				herb_any, missing
	bysort 			hhid (plot_id) : egen cp_hrb = max(herb_any) ///
						if mz_hrvimp != .
	lab var			cp_hrb	"Any maize plot has herbicide"
	tab				cp_hrb
	
* irrigation
	tab				irr_any, missing
	bysort 			hhid (plot_id) : egen cp_irr = max(irr_any) ///
						if mz_hrvimp != .
	lab var			cp_irr	"Any maize plot has irrigation"
	tab				cp_irr

* verify values are accurate
	sum				tf_* cp_*
	
* collapse to the household level
	loc	cp			cp_*
	foreach v of varlist `cp'{
	    replace		`v' = 0 if `v' == .
	}		
	
	collapse (sum)	tf_* cp_*, by(region district ward village hhid)
	*** we went frm ?? to ?? observations 
	
* return non-maize production to missing
	replace			cp_yld = . if cp_yld == 0
	replace			cp_irr = 1 if cp_irr > 0	
	replace			cp_irr = . if cp_yld == . 
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
	replace			tf_irr = 1 if tf_irr > 0	
	
* verify values are accurate
	sum				tf_* cp_*
	
* **********************************************************************
* 4 - end matter, clean up to save
* **********************************************************************

* verify unique household id
	isid			hhid
	
* generate year identifier
	gen				year = 2012
	lab var		year "Year"
		
	order 			region district ward village hhid year tf_hrv tf_lnd tf_yld ///
						tf_lab tf_frt tf_pst tf_hrb tf_irr cp_hrv cp_lnd ///
						cp_yld cp_lab cp_frt cp_pst cp_hrb cp_irr
	compress
	describe
	summarize 
	
* saving production dataset
	customsave , idvar(hhid) filename(hhfinal_npsy3.dta) path("`export'") ///
			dofile(NPSY3_merge) user($user) 

* close the log
	log	close

/* END */
