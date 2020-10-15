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
	* done

	
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
	use 			"`root'/2014_ase1p2.dta", clear

	isid 			clusterid hh_num extension ord field parcel

* merge in plot size data
	merge 			m:1 clusterid hh_num extension field parcel using "`root'/2014_as1p1", generate(_as1p1)
	*** 254 not matched from master out of 1294 not matched 
	*** most unmerged (1040) are from using, meaning we lack production data
	*** per Malawi (rs_plot) we drop all unmerged observations
	
	drop			if _as1p1 != 3
	
* no irrigation, no seed use rate 

* merging in fertilizer, pesticide, herbicide use and labor
	merge		m:1 clusterid hh_num extension field parcel using "`root'/2014_as2ap1", generate(_as2ap1)
	*** 43 not matched from master
	*** we assume these are plots without inputs
	
	replace			pest_any = 0 if pest_any == . & _as2ap1 == 1
	replace			herb_any = 0 if herb_any == . & _as2ap1 == 1
	*** 43 changes made
	
* 1121 did not match from using 	
	drop			if _as2ap1 == 2

* drop observations missing values (not in continuous)
	drop			if plotsize == .
	drop			if pest_any == .
	drop			if herb_any == .
	*** no observations dropped

	drop			_as1p1 _as2ap1

		
* **********************************************************************
* 1b - create total farm and millet variables
* **********************************************************************

* rename some variables
	gen				labordays = prep_labor_all + plant_labor_all + harvest_labor_all
	rename			fert_use fert

* recode binary variables
	replace			fert_any = 0 if fert_any == 2
	replace			pest_any = 0 if pest_any == 2
	replace			herb_any = 0 if herb_any == 2
	
* generate mz_variables
	gen				mz_lnd = plotsize	if mz_hrv != .
	gen				mz_lab = labordays	if mz_hrv != .
	gen				mz_frt = fert		if mz_hrv != . 
	gen				mz_pst = pest_any	if mz_hrv != .
	gen				mz_hrb = herb_any	if mz_hrv != .

* collapse to plot level
	collapse (sum)	vl_hrv plotsize labordays fert ///
						mz_hrv mz_lnd mz_lab mz_frt ///
			 (max)	pest_any herb_any mz_pst mz_hrb mz_damaged, ///
						by(region dept canton zd clusterid hh_num ///
						extension field parcel)

* replace non-maize harvest values as missing
	tab				mz_damaged, missing
	loc	mz			mz_lnd mz_lab mz_frt mz_pst mz_hrb
	foreach v of varlist `mz'{
	    replace		`v' = . if mz_damaged == 1 & mz_hrv == 0	
	}	
	replace			mz_hrv = . if mz_damaged == 1 & mz_hrv == 0		
	drop 			mz_damaged
	*** 48 changes made
	
* missing mz_pst and mz_hrb values
	replace			mz_pst = 0 if mz_pst == . & mz_hrv != . 
	replace			mz_hrb = 0 if mz_hrb == . & mz_hrv != . 

* some mz_lnd coded as 0 when should be missing
	replace			mz_lnd = . if mz_lnd == 0
	replace			mz_hrv = . if mz_lnd == .
	replace			mz_frt = . if mz_lnd == .
	replace			mz_lab = . if mz_lnd == .
	
	
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
* self-reported production quantities (see rs_plot.do)
* ******************************************************************************


* **********************************************************************
* 2a - impute: value
* **********************************************************************
	
* construct production value per hectare
	gen				vl_yld = vl_hrv / plotsize
	assert 			!missing(vl_yld)
	lab var			vl_yld "value of yield (2010USD/ha)"

* impute value per hectare outliers 
	sum				vl_yld, detail
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
	*** reduces mean from 486 to 191
	*** max falls from 121,321 to 17,097
						
	drop			stddev median replacement maxrep minrep
	lab var			vl_yldimp	"value of yield (2010USD/ha), imputed"

* inferring imputed harvest value from imputed harvest value per hectare
	generate		vl_hrvimp = vl_yldimp * plotsize 
	lab var			vl_hrvimp "value of harvest (2010USD), imputed"
	lab var			vl_hrv "value of harvest (2010USD)"

	sum				vl_hrv vl_hrvimp
	*** mean reduces from 112 to 110
	
* **********************************************************************
* 2b - impute: labor
* **********************************************************************

* construct labor days per hectare
	gen				labordays_ha = labordays / plotsize, after(labordays)
	lab var			labordays_ha "farm labor use (days/ha)"
	sum				labordays labordays_ha

* impute labor outliers, right side only 
	sum				labordays_ha, detail
	bysort region :	egen stddev = sd(labordays_ha) if !inlist(labordays_ha,.,0)
	recode stddev	(.=0)
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
	*** reduces mean from 544 to 239
	*** max falls from 93,200 to 18,022

	drop			stddev median replacement maxrep minrep
	lab var			labordays_haimp	"farm labor use (days/ha), imputed"

* make labor days based on imputed labor days per hectare
	gen				labordaysimp = labordays_haimp * plotsize, after(labordays)
	lab var			labordaysimp "farm labor (days), imputed"

	sum				labordays labordaysimp
	*** mean reduces from 172 to 170
	

* **********************************************************************
* 2c - impute: fertilizer
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
						& !inlist(fert_ha,.,0) & !mi(maxrep)
	tabstat 		fert_ha fert_haimp, ///
						f(%9.0f) s(n me min p1 p50 p95 p99 max) c(s) longstub
	*** reduces mean from 34 to 14
	*** max falls from 22,5000 to 3,030
	
	drop			stddev median replacement maxrep minrep
	lab var			fert_haimp	"fertilizer use (kg/ha), imputed"

* make labor days based on imputed labor days per hectare
	gen				fertimp = fert_haimp * plotsize, after(fert)
	lab var			fertimp "fertilizer (kg), imputed"
	lab var			fert "fertilizer (kg)"

	sum				fert fertimp
	*** mean reduces from 5.5 to 5.3

	
* **********************************************************************
* 3 - impute: millet yield, labor, fertilizer use 
* **********************************************************************


* **********************************************************************
* 3a - impute: millet yield
* **********************************************************************

* construct millet yield
	gen				mz_yld = mz_hrv / mz_lnd, after(mz_hrv)
	lab var			mz_yld	"millet yield (kg/ha)"


* impute yield outliers
	sum				mz_yld mz_hrv
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
	*** reduces mean from 2128 to 714
	*** still some crazy high outliers on the upper end... 
	*** will check into this more once w1 is done
					
	drop 			stddev median replacement maxrep minrep
	lab var 		mz_yldimp "millet yield (kg/ha), imputed"

* inferring imputed harvest quantity from imputed yield value 
	generate 		mz_hrvimp = mz_yldimp * mz_lnd, after(mz_hrv)
	lab var 		mz_hrvimp "millet harvest quantity (kg), imputed"
	lab var 		mz_hrv "millet harvest quantity (kg)"

	sum				mz_hrv mz_hrvimp
	*** reduces mean from 339 to 334
	

* **********************************************************************
* 3b - impute: millet labor
* **********************************************************************

* construct labor days per hectare
	gen				mz_lab_ha = mz_lab / mz_lnd, after(labordays)
	lab var			mz_lab_ha "maize labor use (days/ha)"
	sum				mz_lab mz_lab_ha

* impute labor outliers, right side only 
	sum				mz_lab_ha, detail
	bysort region :	egen stddev = sd(mz_lab_ha) if !inlist(mz_lab_ha,.,0)
	recode 			stddev (.=0)
	bysort region :	egen median = median(mz_lab_ha) if !inlist(mz_lab_ha,.,0)
	bysort region :	egen replacement = median(mz_lab_ha) if ///
						(mz_lab_ha <= median + (3 * stddev)) & ///
						(mz_lab_ha >= median - (3 * stddev)) & !inlist(mz_lab_ha,.,0)
	bysort region :	egen maxrep = max(replacement)
	bysort region :	egen minrep = min(replacement)
	assert			minrep==maxrep
	gen				mz_lab_haimp = mz_lab_ha, after(mz_lab_ha)
	replace 		mz_lab_haimp = maxrep if !((mz_lab_ha < median + (3 * stddev)) ///
						& (mz_lab_ha > median - (3 * stddev))) ///
						& !inlist(mz_lab_ha,.,0) & !mi(maxrep)
	tabstat 		mz_lab_ha mz_lab_haimp, ///
						f(%9.0f) s(n me min p1 p50 p95 p99 max) c(s) longstub
	*** reduces mean from 425 to 168
	*** max falls from 87,500 to 14,091 - still crazy high value
	
	drop			stddev median replacement maxrep minrep
	lab var			mz_lab_haimp	"maize labor use (days/ha), imputed"

* make labor days based on imputed labor days per hectare
	gen				mz_labimp = mz_lab_haimp * mz_lnd, after(mz_lab)
	lab var			mz_labimp "maize labor (days), imputed"

	sum				mz_lab mz_labimp
	*** reduces mean 80 to 79

* **********************************************************************
* 3c - impute: millet fertilizer
* **********************************************************************

* construct fertilizer use per hectare
	gen				mz_frt_ha = mz_frt / mz_lnd, after(mz_frt)
	lab var			mz_frt_ha "fertilizer use (kg/ha)"
	sum				mz_frt mz_frt_ha

* impute labor outliers, right side only 
	sum				mz_frt_ha, detail
	bysort region :	egen stddev = sd(mz_frt_ha) if !inlist(mz_frt_ha,.,0)
	recode 			stddev (.=0)
	bysort region :	egen median = median(mz_frt_ha) if !inlist(mz_frt_ha,.,0)
	bysort region :	egen replacement = median(mz_frt_ha) if ///
						(mz_frt_ha <= median + (3 * stddev)) & ///
						(mz_frt_ha >= median - (3 * stddev)) & !inlist(mz_frt_ha,.,0)
	bysort region :	egen maxrep = max(replacement)
	bysort region :	egen minrep = min(replacement)
	assert			minrep==maxrep
	gen				mz_frt_haimp = mz_frt_ha, after(mz_frt_ha)
	replace 		mz_frt_haimp = maxrep if !((mz_frt_ha < median + (3 * stddev)) ///
						& (mz_frt_ha > median - (3 * stddev))) ///
						& !inlist(mz_frt_ha,.,0) & !mi(maxrep)
	tabstat 		mz_frt_ha mz_frt_haimp, ///
						f(%9.0f) s(n me min p1 p50 p95 p99 max) c(s) longstub
	*** reduces mean from 23 to 4
	*** max falls from 22,500 to 2,000
	
	drop			stddev median replacement maxrep minrep
	lab var			mz_frt_haimp	"fertilizer use (kg/ha), imputed"

* make labor days based on imputed labor days per hectare
	gen				mz_frtimp = mz_frt_haimp * mz_lnd, after(mz_frt)
	lab var			mz_frtimp "fertilizer (kg), imputed"
	lab var			mz_frt "fertilizer (kg)"

	sum				mz_frt mz_frtimp
	*** reduces mean 2.2 to 2.1


* **********************************************************************
* 4 - collapse to household level
* **********************************************************************


* **********************************************************************
* 4a - generate total farm variables
* **********************************************************************

* generate plot area
	bysort			clusterid hh_num extension (field parcel) :	egen tf_lnd = sum(plotsize)
	assert			tf_lnd > 0 
	sum				tf_lnd, detail

* value of harvest
	bysort			clusterid hh_num extension (field parcel) :	egen tf_hrv = sum(vl_hrvimp)
	sum				tf_hrv, detail
	
* value of yield
	generate		tf_yld = tf_hrv / tf_lnd
	sum				tf_yld, detail
	
* labor
	bysort 			clusterid hh_num extension (field parcel) : egen lab_tot = sum(labordaysimp)
	generate		tf_lab = lab_tot / tf_lnd
	sum				tf_lab, detail

* fertilizer
	bysort 			clusterid hh_num extension (field parcel) : egen fert_tot = sum(fertimp)
	generate		tf_frt = fert_tot / tf_lnd
	sum				tf_frt, detail

* pesticide
	bysort 			clusterid hh_num extension (field parcel) : egen tf_pst = max(pest_any)
	tab				tf_pst
	
* herbicide
	bysort 			clusterid hh_num extension (field parcel) : egen tf_hrb = max(herb_any)
	tab				tf_hrb
	
* **********************************************************************
* 3b - generate maize variables 
* **********************************************************************	
	
* generate plot area
	bysort			clusterid hh_num extension (field parcel) :	egen cp_lnd = sum(mz_lnd) ///
						if mz_hrvimp != .
	assert			cp_lnd > 0 
	sum				cp_lnd, detail

* value of harvest
	bysort			clusterid hh_num extension (field parcel) :	egen cp_hrv = sum(mz_hrvimp) ///
						if mz_hrvimp != .
	sum				cp_hrv, detail
	
* value of yield
	generate		cp_yld = cp_hrv / cp_lnd if mz_hrvimp != .
	sum				cp_yld, detail
	
* labor
	bysort 			clusterid hh_num extension (field parcel) : egen lab_mz = sum(mz_labimp) ///
						if mz_hrvimp != .
	generate		cp_lab = lab_mz / cp_lnd
	sum				cp_lab, detail

* fertilizer
	bysort 			clusterid hh_num extension (field parcel) : egen fert_mz = sum(mz_frtimp) ///
						if mz_hrvimp != .
	generate		cp_frt = fert_mz / cp_lnd
	sum				cp_frt, detail

* pesticide
	bysort 			clusterid hh_num extension (field parcel) : egen cp_pst = max(mz_pst) /// 
						if mz_hrvimp != .
	tab				cp_pst
	
* herbicide
	bysort 			clusterid hh_num extension (field parcel) : egen cp_hrb = max(mz_hrb) ///
						if mz_hrvimp != .
	tab				cp_hrb

* verify values are accurate
	sum				tf_* cp_*
	
* collapse to the household level
	loc	cp			cp_*
	foreach v of varlist `cp'{
	    replace		`v' = 0 if `v' == .
	}		
	
	collapse (max)	tf_* cp_*, by(region dept canton zd ///
						clusterid hh_num extension)
	*** we went from 4,047 to 1747 observations 
	
* return non-millet production to missing
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
	*** mostly looks good
	*** labor seems a little high

/* 	EMIL, I'VE COMMENTED OUT THIS SECTION UNTIL WE GET WAVE 1 FIXED AND CAN COMPARE ACROSS WAVES. THEN WE CAN RETURN TO THIS CLEANING CODE 
* checks and balances
	*** Production variables should corroborate each other. 
	*** Use discrepencies between production variables to determine if an outlier is a mistake and replace that outlier with missing then impute them.
	*** A high labor should be associated with a high land area and yield and a high yield should be associated with a high value. 

* check correlation at high values of labor with value
	sum 			tf_lab, detail
	*** labor is very high
	pwcorr 			tf_lab tf_hrv 	if tf_lab> 300
	*** poor correlation and unexpectadly negative with labor and harvest: -0.1
	
	tab tf_hrv if tf_lab==0
	*** 10 observations have no labor but a non-negative harvest
	scatter 		tf_hrv tf_lab
	*** the outliers show that at the highest applications of labor to land we see some of the lowest harvest values
	
	sum tf_lab, detail
	*** mean 369, max 93200
	
	replace 	tf_lab = . if tf_lab > 6000
	replace 	tf_lab = . if tf_lab == 0 & tf_yld != 0
	*** 30 changes made
	
* impute missing labor values using predictive mean matching
	mi set 			wide // declare the data to be wide.
	mi xtset		, clear // this is a precautinary step to clear any existing xtset
	mi register 	imputed tf_lab // identify tf_lab as the variable being imputed
	sort			tf_hrv clusterid, stable // sort to ensure reproducability of results
	mi impute 		pmm tf_lab i.clusterid tf_hrv, add(1) rseed(245780) noisily dots ///
						force knn(5) bootstrap
	mi unset
	
	sum 			tf_lab_1_, detail
	*** mean 137.6, max 5633.8
	*** looks good
	
	replace 		tf_lab = tf_lab_1_
	drop 			tf_lab_1_
	
	pwcorr 			tf_lab tf_hrv
	*** negative correlation between labor and harvest : -0.06

* check correlation at high values of labor with crop value
	sum 			cp_lab, detail
	sum 			cp_hrv, detail
	tab 			cp_hrv cp_lab 	if cp_lab > 6000
	*** at the higher end high labor has mostly low harvests
	pwcorr 			cp_lab tf_hrv 	if cp_lab> 300
	*** poor correlation and unexpectadly negative with labor and harvest: -0.11
	
	tab 			cp_hrv if cp_lab==0
	*** 7 observations have no labor but a non-negative harvest
	scatter 		cp_hrv cp_lab
	*** the outliers show that at the highest applications of labor to land we see some of the lowest harvest values
	
	sum 			cp_lab, detail
	*** mean 302.1, max 52857
	
	replace 		cp_lab = . 	if cp_lab >6000
	replace 		cp_lab = . 	if cp_lab == 0 & cp_yld != 0
	*** 24 changes made
	
* impute missing labor values using predictive mean matching
	mi set 			wide // declare the data to be wide.
	mi xtset		, clear // this is a precautinary step to clear any existing xtset
	mi register 	imputed cp_lab // identify cp_lab as the variable being imputed
	sort			cp_hrv clusterid, stable // sort to ensure reproducability of results
	mi impute 		pmm cp_lab i.clusterid tf_hrv, add(1) rseed(245780) noisily dots ///
						force knn(5) bootstrap
	mi unset
	
	sum 			cp_lab_1_, detail
	*** mean 107, max 5633
	*** looks good
	
	replace 		cp_lab = cp_lab_1_
	drop 			cp_lab_1_
	
	pwcorr 			cp_lab cp_hrv
	*** reduced the negative correlation between cp_lab and cp_hrv but closer to 0 after impute (-.08)
	
* verify values are accurate
	sum				tf_* cp_*
*/
	
* **********************************************************************
* 4 - end matter, clean up to save
* **********************************************************************

* verify unique household id
	isid			clusterid hh_num extension

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
	
* generate year identifier
	gen				year = 2014
	lab var			year "Year"
	
* create unique household identifier

	egen				hhid_y2 = group(clusterid hh_num extension)
	lab var				hhid_y2 "Unique wave 2 household identifier"
		
	order 			region dept canton zd clusterid hh_num extension hhid_y2 year tf_hrv tf_lnd tf_yld ///
						tf_lab tf_frt tf_pst tf_hrb cp_hrv cp_lnd ///
						cp_yld cp_lab cp_frt cp_pst cp_hrb
	compress
	describe
	summarize 
	
* saving production dataset
	customsave , idvar(hhid_y2) filename(hhfinal_ecvma2.dta) path("`export'") ///
			dofile(2014_merge) user($user) 

* close the log
	log	close

/* END */
