* Project: WB Weather
* Created on: Aug 2020
* Created by: jdm
* Edited by: ek
* Stata v.16

* does
	* merges individual cleaned plot datasets together
	* imputes values for continuous variables
	* collapses to wave 3 plot level data to household level for combination with other waves

* assumes
	* previously cleaned household datasets
	* customsave.ado

* TO DO:
	* done
	

* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root 		= "$data/household_data/uganda/wave_3/refined"  
	loc export 		= "$data/household_data/uganda/wave_3/refined"
	loc logout 		= "$data/household_data/uganda/logs"
	
* open log
	cap log 		close
	log using 		"`logout'/unps3_merge", append

	
* **********************************************************************
* 1 - merge plot level data sets together
* **********************************************************************

* start by loading harvest quantity and value, since this is our limiting factor
	use 			"`root'/2011_AGSEC5A.dta", clear
	isid 			hhid prcid pltid cropid
	
* merge in plot size data and irrigation data
	merge			m:1 hhid prcid using "`root'/2011_AGSEC2A", generate(_sec2)
	*** matched 9288, unmatched 1279 from master
	*** a lot unmatched, means plots do not area data
	*** for now as per Malawi (rs_plot) we drop all unmerged observations

	drop			if _sec2 != 3
		
* merging in labor, fertilizer and pest data
	merge			m:1 hhid prcid pltid  using "`root'/2011_AGSEC3A", generate(_sec3a)
	*** 24 unmerged from master

	drop			if _sec3a == 2
	
* replace missing binary values
	replace			pest_any = 2 if pest_any == .
	replace 		herb_any = 2 if herb_any == .
	replace			fert_any = 2 if fert_any == .

* drop observations missing values (not in continuous)
	drop			if plotsize == .
	*** 16 deleted
	drop			if pest_any == .
	drop			if herb_any == .
	*** no observations dropped

	drop			_sec2 _sec3a

* **********************************************************************
* 1b - create total farm and maize variables
* **********************************************************************

* rename some variables
	rename			kilo_fert fert
	rename			labor_days labordays

* recode binary variables
	replace			fert_any = 0 if fert_any == 2
	replace			pest_any = 0 if pest_any == 2
	replace			herb_any = 0 if herb_any == 2
	
* generate mz_variables
	gen				mz_lnd = plotsize	if cropid == 130
	gen				mz_lab = labordays	if cropid == 130
	gen				mz_frt = fert		if cropid == 130
	gen				mz_pst = pest_any	if cropid == 130
	gen				mz_hrb = herb_any	if cropid == 130
	gen 			mz_hrv = cropvalue	if cropid == 130
	gen 			mz_damaged = 1 		if cropid == 130 & cropvalue == 0
	
* collapse to plot level
	collapse (sum)	cropvalue plotsize labordays fert ///
						mz_hrv mz_lnd mz_lab mz_frt  ///
			 (max)	pest_any herb_any fert_any  ///
						mz_pst mz_hrb mz_damaged, ///
						by(hhid prcid pltid region district county subcounty ///
						parish hh_status2011 wgt11)

* replace non-maize harvest values as missing
	tab				mz_damaged, missing
	loc	mz			mz_lnd mz_lab mz_frt mz_pst mz_hrb
	foreach v of varlist `mz'{
	    replace		`v' = . if mz_damaged == . & mz_hrv == 0	
	}	
	replace			mz_hrv = . if mz_damaged == . & mz_hrv == 0		
	drop 			mz_damaged
	*** 4607 changes made
	
* encode the string location data
	encode 			district, gen(districtdstrng)
	encode			county, gen(countydstrng)
	encode			subcounty, gen(subcountydstrng)
	encode			parish, gen(parishdstrng)

	
* **********************************************************************
* 2 - impute: total farm value, labor, fertilizer use 
* **********************************************************************

* ******************************************************************************
* FOLLOWING WB: we will construct production variables on a per hectare basis,
* and conduct imputation on the per hectare variables. We will then create 
* 'imputed' versions of the non-per hectare variables (e.g. harvest, 
* value) by multiplying the imputed per hectare vars by plotsize. 
* This approach relies on the assumptions that the 1) GPS measurements are 
* reliable, and 2) outlier values are due to errors in the respondent's 
* self-reported production quantities
* ******************************************************************************


* **********************************************************************
* 2a - impute: total value
* **********************************************************************
	
* construct production value per hectare
	gen				vl_yld = cropvalue / plotsize
	assert 			!missing(vl_yld)
	lab var			vl_yld "value of yield (2010USD/ha)"

* impute labor outliers, right side only 
* replace any +3 s.d. away from mean as missing, by cropid
	sort 			vl_yld
	sum				vl_yld, detail 
	replace			vl_yld = . if vl_yld > `r(p50)'+ (3*`r(sd)')
	sum				vl_yld, detail
	*** replaced 70 values, max is now 1795.92, mean 148.34

	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed vl_yld // identify harvkgsold as the variable being imputed
	sort			hhid prcid pltid vl_yld, stable // sort to ensure reproducability of results
	mi impute 		pmm vl_yld i.districtdstrng i.subcountydstrng, add(1) rseed(245780) ///
						noisily dots force knn(5) bootstrap
	mi 				unset	
	
	replace 		vl_yld = vl_yld_1_ 
	sum 			vl_yld
	*** max is still 1795.92, mean is 148.82
	
	rename 			vl_yld_1_ vl_yldimp
	lab var			vl_yldimp	"value of yield (2010USD/ha), imputed"
	
* inferring imputed harvest value from imputed harvest value per hectare
	generate		vl_hrvimp = vl_yldimp * plotsize 
	lab var			vl_hrvimp "value of harvest (2010USD), imputed"
	lab var			vl_hrv "value of harvest (2010USD)"
	
	drop mi_miss

* **********************************************************************
* 2b - impute: labor
* **********************************************************************

* construct labor days per hectare
	gen				labordays_ha = labordays / plotsize, after(labordays)
	lab var			labordays_ha "farm labor use (days/ha)"
	sum				labordays labordays_ha

* impute labor outliers, right side only 
* replace any +3 s.d. away from mean as missing, by cropid
	sort 			labordays_ha
	sum				labordays_ha, detail 
	replace			labordays_ha = . if labordays_ha > `r(p50)'+ (3*`r(sd)')
	sum				labordays_ha, detail
	*** replaced 90 values, max is now 752.06, mean 34.24

	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed labordays_ha // identify harvkgsold as the variable being imputed
	sort			hhid prcid pltid labordays_ha, stable // sort to ensure reproducability of results
	mi impute 		pmm labordays_ha i.districtdstrng i.subcountydstrng, add(1) rseed(245780) ///
						noisily dots force knn(5) bootstrap
	mi 				unset	
	
	replace 		labordays_ha = labordays_ha_1_ 
	sum 			labordays_ha
	*** max is still 752.06, mean goes up very slightly to 34.97

	
	rename			labordays_ha_1_ labordays_haimp
	lab var			labordays_haimp	"farm labor (days), imputed"

* make labor days based on imputed labor days per hectare
	gen				labordaysimp = labordays_haimp * plotsize, after(labordays)
	lab var			labordaysimp "farm labor (days), imputed"

	drop 			mi_miss
	
* **********************************************************************
* 2c - impute: fertilizer
* **********************************************************************

* construct fertilizer use per hectare
	gen				fert_ha = fert / plotsize, after(fert)
	lab var			fert_ha "fertilizer use (kg/ha)"
	sum				fert fert_ha

* impute yield outliers

* replace any +3 s.d. away from median as missing, by cropid
	sort 			fert_ha
	sum				fert_ha, detail 
	replace			fert_ha = . if fert_ha > `r(p50)'+ (3*`r(sd)')
	sum				fert_ha, detail
	*** replaced 11 values, max is now 226.7, mean 0.543
	
* impute missing values
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed fert_ha // identify harvkgsold as the variable being imputed
	sort			hhid prcid pltid fert_ha, stable // sort to ensure reproducability of results
	mi impute 		pmm fert_ha i.districtdstrng i.subcountydstrng, add(1) rseed(245780) ///
						noisily dots force knn(5) bootstrap
	mi 				unset	
	
	replace 		fert_ha = fert_ha_1_ if fert_any > 0
	sum 			fert_ha
	*** max is still 226.7, mean is 0.544

	rename			fert_ha_1_ fert_haimp
	lab var			fert_haimp	"fertilizer use (kg/ha), imputed"

* make labor days based on imputed labor days per hectare
	gen				fertimp = fert_haimp * plotsize, after(fert)
	lab var			fertimp "fertilizer (kg), imputed"
	lab var			fert "fertilizer (kg)"

	drop 			mi_miss
* **********************************************************************
* 3 - impute: maize yield, labor, fertilizer use 
* **********************************************************************


* **********************************************************************
* 3a - impute: maize yield
* **********************************************************************

* construct maize yield
	gen				mz_yld = mz_hrv / mz_lnd, after(mz_hrv)
	lab var			mz_yld	"maize yield (kg/ha)"
	
* impute yield outliers

* replace any +3 s.d. away from median as missing, by cropid
	sort 			mz_yld
	sum				mz_yld, detail 
	replace			mz_yld = . if mz_yld > `r(p50)'+ (3*`r(sd)')
	sum				mz_yld, detail
	*** replaced 9 values, max is now 2134.04, mean 138.67
	
* impute missing values
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed mz_yld // identify harvkgsold as the variable being imputed
	sort			hhid prcid pltid mz_yld, stable // sort to ensure reproducability of results
	mi impute 		pmm mz_yld i.districtdstrng i.subcountydstrng, add(1) rseed(245780) ///
						noisily dots force knn(5) bootstrap
	mi 				unset	
	
	replace 		mz_yld = mz_yld_1_ if mz_lnd > 0
	sum 			mz_yld
	*** max is still 2134.04, mean is 124.2

	rename			mz_yld_1_ mz_yldimp
	lab var 		mz_yldimp "maize yield (kg/ha), imputed"

* inferring imputed harvest quantity from imputed yield value 
	generate 		mz_hrvimp = mz_yldimp * mz_lnd, after(mz_hrv)
	lab var 		mz_hrvimp "maize harvest quantity (kg), imputed"
	lab var 		mz_hrv "maize harvest quantity (kg)"

	drop 			mi_miss
* **********************************************************************
* 3b - impute: maize labor
* **********************************************************************

* construct labor days per hectare
	gen				mz_lab_ha = mz_lab / mz_lnd, after(labordays)
	lab var			mz_lab_ha "maize labor use (days/ha)"
	sum				mz_lab mz_lab_ha

* replace any +3 s.d. away from median as missing, by cropid
	sort 			mz_lab_ha
	sum				mz_lab_ha, detail 
	replace			mz_lab_ha = . if mz_lab_ha > `r(p50)'+ (3*`r(sd)')
	sum				mz_lab_ha, detail
	*** replaced 15 values, max is now 1074.37, mean 49.96
	
* impute missing values
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed mz_lab_ha // identify harvkgsold as the variable being imputed
	sort			hhid prcid pltid mz_lab_ha, stable // sort to ensure reproducability of results
	mi impute 		pmm mz_lab_ha i.districtdstrng i.subcountydstrng, add(1) rseed(245780) ///
						noisily dots force knn(5) bootstrap
	mi 				unset	
	
	replace 		mz_lab_ha = mz_lab_ha_1_ if mz_lnd > 0
	sum 			mz_lab_ha
	*** increases mean to 59.52
	*** max stays at 1074.37

	rename 			mz_lab_ha_1_ mz_lab_haimp
	lab var			mz_lab_haimp	"maize labor use (days/ha), imputed"

* make labor days based on imputed labor days per hectare
	gen				mz_labimp = mz_lab_haimp * mz_lnd, after(mz_lab)
	lab var			mz_labimp "maize labor (days), imputed"

	drop			mi_miss
* **********************************************************************
* 3c - impute: maize fertilizer
* **********************************************************************

* construct fertilizer use per hectare
	gen				mz_frt_ha = mz_frt / mz_lnd, after(mz_frt)
	lab var			mz_frt_ha "fertilizer use (kg/ha)"
	sum				mz_frt mz_frt_ha

* replace any +3 s.d. away from median as missing, by cropid
	sort 			mz_frt_ha
	sum				mz_frt_ha, detail 
	replace			mz_frt_ha = . if mz_frt_ha > `r(p50)'+ (3*`r(sd)')
	sum				mz_frt_ha, detail
	*** max is 138.82, mean is 0.639
	
* impute labor outliers, right side only 
	sum				mz_frt_ha, detail
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed mz_frt_ha // identify harvkgsold as the variable being imputed
	sort			hhid prcid pltid mz_frt_ha, stable // sort to ensure reproducability of results
	mi impute 		pmm mz_frt_ha i.districtdstrng i.subcountydstrng, add(1) rseed(245780) ///
						noisily dots force knn(5) bootstrap
	mi 				unset	
	
	replace 		mz_frt_ha = mz_frt_ha_1_ if mz_lnd > 0
	sum 			mz_frt_ha
	*** max is the same and mean is 0.306

	rename 			mz_frt_ha_1_ mz_frt_haimp
	lab var			mz_frt_haimp	"fertilizer use (kg/ha), imputed"

* make labor days based on imputed labor days per hectare
	gen				mz_frtimp = mz_frt_haimp * mz_lnd, after(mz_frt)
	lab var			mz_frtimp "fertilizer (kg), imputed"
	lab var			mz_frt "fertilizer (kg)"

* **********************************************************************
* 4 - collapse to household level
* **********************************************************************


* **********************************************************************
* 4a - generate total farm variables
* **********************************************************************

* generate plot area
	bysort			hhid (pltid) : egen tf_lnd = sum(plotsize)
	assert			tf_lnd > 0 
	sum				tf_lnd, detail

* value of harvest
	bysort			hhid (pltid) : egen tf_hrv = sum(vl_hrvimp)
	sum				tf_hrv, detail
	
* value of yield
	generate		tf_yld = tf_hrv / tf_lnd
	sum				tf_yld, detail
	
* labor
	bysort 			hhid (pltid) : egen lab_tot = sum(labordaysimp)
	generate		tf_lab = lab_tot / tf_lnd
	sum				tf_lab, detail

* fertilizer
	bysort 			hhid (pltid) : egen fert_tot = sum(fertimp)
	generate		tf_frt = fert_tot / tf_lnd
	sum				tf_frt, detail

* pesticide
	bysort 			hhid (pltid) : egen tf_pst = max(pest_any)
	tab				tf_pst
	
* herbicide
	bysort 			hhid (pltid) : egen tf_hrb = max(herb_any)
	tab				tf_hrb
	
	
* **********************************************************************
* 4b - generate maize variables 
* **********************************************************************	
	
* generate plot area
	bysort			hhid (pltid) :	egen cp_lnd = sum(mz_lnd) ///
						if mz_hrvimp != .
	assert			cp_lnd > 0 
	sum				cp_lnd, detail

* value of harvest
	bysort			hhid (pltid) :	egen cp_hrv = sum(mz_hrvimp) ///
						if mz_hrvimp != .
	sum				cp_hrv, detail
	
* value of yield
	generate		cp_yld = cp_hrv / cp_lnd if mz_hrvimp != .
	sum				cp_yld, detail
	
* labor
	bysort 			hhid (pltid) : egen lab_mz = sum(mz_labimp) ///
						if mz_hrvimp != .
	generate		cp_lab = lab_mz / cp_lnd
	sum				cp_lab, detail

* fertilizer
	bysort 			hhid (pltid) : egen fert_mz = sum(mz_frtimp) ///
						if mz_hrvimp != .
	generate		cp_frt = fert_mz / cp_lnd
	sum				cp_frt, detail

* pesticide
	bysort 			hhid (pltid) : egen cp_pst = max(mz_pst) /// 
						if mz_hrvimp != .
	tab				cp_pst
	
* herbicide
	bysort 			hhid (pltid) : egen cp_hrb = max(mz_hrb) ///
						if mz_hrvimp != .
	tab				cp_hrb

* verify values are accurate
	sum				tf_* cp_*
	
* collapse to the household level
	loc	cp			cp_*
	foreach v of varlist `cp'{
	    replace		`v' = 0 if `v' == .
	}		
	
* count before collapse
	count
	***6068 obs
	
	collapse (max)	tf_* cp_* HHS_hh_shftd_dsntgrtd_2011 panel_wgt_2011, by(region districtdstrng countydstrng subcountydstrng parishdstrng hhid)

* count after collapse 
	count 
	*** 6031 to 1988 observations 
	
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

* verify values are accurate
	sum				tf_* cp_*

* label variables
	lab var			tf_lnd	"Total farmed area (ha)"
	lab var			tf_hrv	"Total value of harvest (2010 USD)"
	lab var			tf_yld	"value of yield (2010 USD/ha)"
	lab var			tf_lab	"labor rate (days/ha)"
	lab var			tf_frt	"fertilizer rate (kg/ha)"
	lab var			tf_pst	"Any plot has pesticide"
	lab var			tf_hrb	"Any plot has herbicide"
	lab var			cp_lnd	"Total maize area (ha)"
	lab var			cp_hrv	"Total quantity of maize harvest (kg)"
	lab var			cp_yld	"Maize yield (kg/ha)"
	lab var			cp_lab	"labor rate for maize (days/ha)"
	lab var			cp_frt	"fertilizer rate for maize (kg/ha)"
	lab var			cp_pst	"Any maize plot has pesticide"
	lab var			cp_hrb	"Any maize plot has herbicide"

* **********************************************************************
* 4 - end matter, clean up to save
* **********************************************************************

* destring hhid
	destring hhid, replace

* verify unique household id
	isid			hhid

* generate year identifier
	gen				year = 2011
	lab var			year "Year"
		
	order 			region districtdstrng countydstrng subcountydstrng parishdstrng hhid /// 	
					tf_hrv tf_lnd tf_yld tf_lab tf_frt ///
					tf_pst tf_hrb cp_hrv cp_lnd cp_yld cp_lab ///
					cp_frt cp_pst cp_hrb
	compress
	describe
	summarize 
	
* saving production dataset
	customsave , idvar(hhid) filename(hhfinal_unps3.dta) path("`export'") ///
			dofile(unps3_merge) user($user) 

* close the log
	log	close

/* END */




