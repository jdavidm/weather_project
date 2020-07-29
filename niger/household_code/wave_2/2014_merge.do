* Project: WB Weather
* Created on: May 2020
* Created by: alj
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

* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		root	=	"$data/household_data/niger/wave_2/refined"
	loc 	export	=	"$data/household_data/niger/wave_2/refined"
	loc 	logout	=	"$data/household_data/niger/logs"

* open log
	cap		log close
	log 	using 	"`logout'/2014_niger_merge", append

	
* **********************************************************************
* 1 - merge plot level data sets together
* **********************************************************************

* start by loading harvest quantity and value, since this is our limiting factor
	use 			"`root'/2014_ase1p2_1.dta", clear

	isid			plot_id
	isid 			clusterid hh_num extension field parcel ord

* merge in plot size data
	merge 			m:1 clusterid hh_num extension field parcel using "`root'/2014_as1p1", generate(_as1p1)
	*** 254 out of 9699 missing 
	*** most unmerged (1040) are from using, meaning we lack production data
	*** per Malawi (rs_plot) we drop all unmerged observations
	
	drop			if _as1p1 != 3
	
* no irrigation, no seed use rate 

* merging in labor data
	merge		m:1 clusterid hh_num extension field parcel using "`root'/2014_as2ap1_f", generate(_as2ap1f)
	*** 43 out of 9256 missing in master - impute later 
	*** 1121 out of 9256 missing from using 
	
	drop			if _as2ap1f == 2
		
* merging in pesticide and herbicide use
	merge		m:1 clusterid hh_num extension field parcel using "`root'/2014_pp_as2ap1", generate(_ppas2ap1)
	*** 43 not matched from master
	*** we assume these are plots without pest or herb

	replace			pest_any = 2 if pest_any == . & _ppas2ap1 == 1
	replace			herb_any = 2 if herb_any == . & _ppas2ap1 == 1
	*** 43 changes made
	
* 1121 did not match from using 	
	drop			if _ppas2ap1 == 2

* merging in fertilizer use
	merge		m:1 clusterid hh_num extension field parcel using "`root'/2014_pp_as2ap1fert", generate(_ppas2ap1fert)
	*** 43 missing in master 
	*** we will impute the missing values later
	*** 1121 did not match from using
	
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

*maybe imputing zero values	
	
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
	*** reduces mean from 2143 to 1255
	*** still some crazy high outliers on the upper end... 
	*** will check into this more once w1 is done
					
	drop 			stddev median replacement maxrep minrep
	lab var 		mz_yldimp "millet yield (kg/ha), imputed"

* inferring imputed harvest quantity from imputed yield value 
	generate 		mz_hrvimp = mz_yldimp * plotsize, after(mz_hrv)
	lab var 		mz_hrvimp "millet harvest quantity (kg), imputed"
	lab var 		mz_hrv "millet harvest quantity (kg)"

	sum				mz_hrv mz_hrvimp
	*** reduces mean from 332 to 313
	*** max at 1350 - no change 

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
	*** reduces mean from 359 to 221
	*** again high max
	*** will check after w1 is done  
						
	drop			stddev median replacement maxrep minrep
	lab var			vl_yldimp	"value of yield (2010USD/ha), imputed"

* inferring imputed harvest value from imputed harvest value per hectare
	generate		vl_hrvimp = vl_yldimp * plotsize 
	lab var			vl_hrvimp "value of harvest (2010USD), imputed"
	lab var			vl_hrv "value of harvest (2010USD)"
	
	sum				vl_hrv vl_hrvimp 
	*** reduces mean from 52 to 49
	*** effectively no change in max 
	
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
	*** reduces mean from 432 to 291
	*** still high max at 93200
	
	drop			stddev median replacement maxrep minrep
	lab var			labordays_haimp	"farm labor use (days/ha), imputed"

* make labor days based on imputed labor days per hectare
	gen				labordaysimp = labordays_haimp * plotsize, after(labordays)
	lab var			labordaysimp "farm labor (days), imputed"

	sum				labordays labordaysimp 
	*** reduces mean from 83 to 78
	*** no change in max (590)
	

* **********************************************************************
* 2d - impute: fertilizer
* **********************************************************************

* construct fertilizer use per hectare
	rename			fert_use fert
	gen				fert_ha = fert / plotsize, after(fert)
	lab var			fert_ha "fertilizer use (kg/ha)"
	sum				fert fert_ha

* impute labor outliers, right side only 
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
	*** reduces mean from 28 to 26
	*** max still at 22500 
	
	drop			stddev median replacement maxrep minrep
	lab var			fert_haimp	"fertilizer use (kg/ha), imputed"

* make labor days based on imputed labor days per hectare
	gen				fertimp = fert_haimp * plotsize, after(fert)
	lab var			fertimp "fertilizer (kg), imputed"
	lab var			fert "fertilizer (kg)"

	replace			fert_any = 1 if fertimp > 0
	replace			fert_any = 2 if fertimp == 0

	sum				fert_ha fert_haimp
	*** mean reduces from 28 to 26
	*** max still at 22500 

	
* **********************************************************************
* 3 - collapse to household level
* **********************************************************************

	gen 	cpplotsize 		= 	plotsize 		if mz_hrvimp !=	.
	gen 	cpvl_hrvimp 	= 	vl_hrvimp 		if mz_hrvimp !=	.
	gen 	cplabordaysimp 	= 	labordaysimp 	if mz_hrvimp !=	.
	gen 	cpfertimp		=	fertimp 		if mz_hrvimp !=	.
	gen	 	cppest_any		=	pest_any 		if mz_hrvimp != .
	gen 	cpherb_any 		= 	herb_any 		if mz_hrvimp != .

	
	collapse (sum) tf_lnd=plotsize  tf_hrv=vl_hrvimp  lab_tot=labordaysimp ///
		fert_tot=fertimp cp_lnd=cpplotsize cp_hrv=cpvl_hrvimp cplab_tot=cplabordaysimp ///
		fert_mz=cpfertimp (max) tf_pst=pest_any tf_hrb=herb_any cp_pst=cppest_any ///
		cp_hrb=cpherb_any, by(region dept canton zd clusterid hh_num)

	gen 	tf_yld 		= 	tf_hrv/tf_lnd
	gen 	tf_lab 		= 	lab_tot/tf_lnd
	gen		tf_frt 		= 	fert_tot / tf_lnd

	gen 	cp_yld 		= 	cp_hrv/cp_lnd
	gen		cp_lab 		= 	cplab_tot/cp_lnd
	gen		cp_frt 		= 	fert_mz / cp_lnd

	sum tf_* cp_*
	
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
	
	sum tf_* cp_*
	
* **********************************************************************
* 4 - end matter, clean up to save
* **********************************************************************

* generate year identifier
	gen				year = 2014
	lab var			year "Year"
	
* create unique household identifier
	isid				region dept canton zd clusterid hh_num
	sort				region dept canton zd clusterid hh_num, stable 
	egen				hh_id = group(region dept canton zd clusterid hh_num)
	lab var				hh_id "unique household identifier"
		
	order 			region dept canton zd clusterid hh_num hh_id year tf_hrv tf_lnd tf_yld ///
						tf_lab tf_frt tf_pst tf_hrb cp_hrv cp_lnd ///
						cp_yld cp_lab cp_frt cp_pst cp_hrb
	compress
	describe
	summarize 
	
* saving production dataset
	customsave , idvar(hh_id) filename(hhfinal_niger2014.dta) path("`export'") ///
			dofile(2014_merge) user($user) 

* close the log
	log	close

/* END */
