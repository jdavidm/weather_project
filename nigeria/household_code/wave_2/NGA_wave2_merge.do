* Project: WB Weather
* Created on: May 2020
* Created by: jdm
* Edited by : alj
* Stata v.16

* does
	* merges individual cleaned plot datasets together
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
	loc		root	=	"$data/household_data/nigeria/wave_2/refined"
	loc 	export	=	"$data/household_data/nigeria/wave_2/refined"
	loc 	logout	=	"$data/household_data/nigeria/logs"

* open log
	*log 	using 	"`logout'/NGA_wave_2_merge", append

	
* **********************************************************************
* 1 - merge plot level data sets together
* **********************************************************************

* load plot size data
	use 			"`root'/pp_sect11a1", clear

	isid			hhid plotid  
	
* merging in irrigation data
	merge			1:1 hhid plotid using "`root'/pp_sect11b1"
	*** only 17 out of 5876 not merged (0.2%)
	*** we assume these are plots without irrigation
	
	replace			irr_any = 2 if irr_any == .
	*** 17 changes made
	
	drop			plot_id _merge

* merging in planting labor data
	merge		1:1 hhid plotid using "`root'/pp_sect11c1"
	*** 221 from master and 4 from using not matched (4%)
	*** not clear what to do with these, so we will keep them for the moment

	drop			plot_id _merge

* merging in pesticide and herbicide use
	merge		1:1 hhid plotid using "`root'/pp_sect11c2"
	*** 101 from master not merged (2%)
	*** we assume these are plots without pest or herb

	replace			pest_any = 2 if pest_any == .
	replace			herb_any = 2 if herb_any == .
	*** 101 changes made
	
	drop			plot_id _merge

* merging in fertilizer use
	merge		1:1 hhid plotid using "`root'/pp_sect11d"
	*** 128 from master not merged (2%)
	
	drop			plot_id _merge

* merging in harvest labor data
	merge		1:1 hhid plotid using "`root'/ph_secta2"
	*** 201 from master and 223 from using not merged (7%)
	*** like before, not clear if these are zero labor

	drop			plot_id _merge 

* merging in harvest quantity and value
	merge		1:1 hhid plotid using "`root'/ph_secta3"
	*** 1020 from master and 2 from using not merged (20%)
	*** from NGA_ph_secta3.do we removed values that were not in seasons

	drop			_merge plot_id

* drop observations missing values
	drop			if plotsize == .
	drop			if irr_any == .
	drop			if pest_any == .
	drop			if herb_any == .
	drop			if fert_any == .
	*** in total only 124 observations dropped 

* **********************************************************************
* 2 - impute: yield, value per hectare, labor (both), fertilizer use 
* **********************************************************************

********************************************************************************
*	FOLLOWING WB: we will construct production variables on a per hectare basis,
*	and conduct imputation on the per hectare variables. We will then create 
*	'imputed' versions of the non-per hectare variables (e.g. harvest, 
*	value) by multiplying the imputed per hectare vars by plotsize. 
*	This approach relies on the assumptions that the 1) GPS measurements are 
*	reliable, and 2) outlier values are due to errors in the respondent's 
*	self-reported production quantities
********************************************************************************

******YIELD IMPUTATIONS******

* construct maize yield
	generate 		cp_yld = cp_hrv / plotsize, after(cp_hrv)
	assert 			!missing(cp_yld) if !missing(cp_hrv)
	label 			variable cp_yld	"maize yield (kg/ha)"

* impute yield outliers
	summarize 		cp_yld
	bysort state : egen stddev = sd(cp_yld) if !inlist(cp_yld,.,0)
	recode stddev (.=0)
	bysort state : egen median = median(cp_yld) if !inlist(cp_yld,.,0)
	bysort state : egen replacement = median(cp_yld) if /// 
		(cp_yld <= median + (3 * stddev)) & (cp_yld >= median - (3 * stddev)) & !inlist(cp_yld,.,0)
	bysort state : egen maxrep = max(replacement)
	bysort state : egen minrep = min(replacement)
	assert minrep==maxrep
	generate cp_yldimp = cp_yld, after(cp_yld)
	
	*issues next line not working 
	*first half runs - second part doesn't
	replace  cp_yldimp = maxrep if !((cp_yld < median + (3 * stddev)) & (cp_yld > median - (3 * stddev))) 
	*& !inlist (cp_yld,.,0) & !mi(maxrep)
	
	tabstat cp_yld cp_yldimp, f(%9.0f) s(n me min p1 p50 p95 p99 max) c(s) longstub
	drop stddev median replacement maxrep minrep
	la var cp_yldimp "maize yield (kg/ha), imputed"


* inferring imputed harvest quantity from imputed yield value 
	generate cp_hrvimp = cp_yldimp * plotsize, after(cp_hrv)
	la var cp_hrvimp "maize harvest quantity (kg), imputed"

*not tested from this point ...
	
	
******VALUE PER HECTARE IMPUTATIONS******	
	
* construct production value per hectare
	generate tf_yld = tf_hrv / plotsize
	assert !missing(tf_yld)
	label variable tf_yld "value of harvest per hectare (2010USD/ha)"

* impute value per hectare outliers 
	summarize tf_yld
	bysort region : egen stddev = sd(harvest_valueha) if !inlist(tf_yld,.,0)
	recode stddev (.=0)
	bysort state : egen median = median(tf_yld) if !inlist(tf_yld,.,0)
	bysort state : egen replacement = median(tf_yld) if  ///
		(tf_yld <= median + (3 * stddev)) & (tf_yld >= median - (3 * stddev)) & !inlist(tf_yld,.,0)
	bysort state : egen maxrep = max(replacement)
	bysort state : egen minrep = min(replacement)
	assert minrep==maxrep
	generate tf_yldimp = tf_yld
	replace  tf_yldimp = maxrep if !((tf_yld < median + (3 * stddev)) & (tf_yld > median - (3 * stddev))) & ///
		!inlist(tf_yld,.,0) & !mi(maxrep)
	tabstat tf_yld tf_yldimp, f(%9.0f) s(n me min p1 p50 p95 p99 max) c(s) longstub
	drop stddev median replacement maxrep minrep
	label variable tf_yldimp	"value of harvest per hectare (2010USD/ha), imputed"

* inferring imputed harvest value from imputed harvest value per hectare
	generate tf_hrvimp = tf_yldimp * plotsize 
	label variable tf_hrvimp "value of harvest (2010USD), imputed"

******LABOR DAYS PER HECTARE IMPUTATIONS******	

*labor days are undifferentiated with respect to crop v. total labor on farm 
*shouldn't be an issue at the plot level
*but will need to check into this - because obviously labor on maize is relevant for that regression...

egen total_labor_days = rsum (hrv_labor pp_labor)	


/* **unchanged**
	
*	Generate labor days per hectare
generate labordays_ha = labordays / plotsize, after(labordays)
label variable labordays_ha			"Days of labor per hectare (Days/ha)"
summarize labordays labordays_ha


*	Impute labor outliers, right side only 
summarize labordays_ha, detail
bysort region : egen stddev = sd(labordays_ha) if !inlist(labordays_ha,.,0)
recode stddev (.=0)
bysort region : egen median = median(labordays_ha) if !inlist(labordays_ha,.,0)
bysort region : egen replacement = median(labordays_ha) if /*
*/	(labordays_ha <= median + (3 * stddev)) /*& (labordays_ha >= median - (3 * stddev))*/ & !inlist(labordays_ha,.,0)
bysort region : egen maxrep = max(replacement)
bysort region : egen minrep = min(replacement)
assert minrep==maxrep
generate labordays_haimp = labordays_ha, after(labordays_ha)
replace labordays_haimp = maxrep if !((labordays_ha < median + (3 * stddev)) /*& (labordays_ha > median - (3 * stddev))*/) & !inlist(labordays_ha,.,0) & !mi(maxrep)
tabstat labordays_ha labordays_haimp, f(%9.0f) s(n me min p1 p50 p95 p99 max) c(s) longstub
drop stddev median replacement maxrep minrep
label variable labordays_haimp		"Days of labor per hectare (Days/ha), imputed"


*	make labor days based on imputed labor days per hectare
generate labordaysimp = labordays_haimp * plotsize, after(labordays)
label variable labordaysimp			"Days of labor on plot, imputed"
tabstat labordays labordaysimp, f(%9.0f) s(n me min p1 p50 p95 p99 max) c(s) longstub

*/
	
* collapse plot level data to household level data/household_data/nigeria/logs


* **********************************************************************
* 3 - end matter, clean up to save
* **********************************************************************

* verify unique household id
	isid			hhid
	
	compress
	describe
	summarize 
	
* saving production dataset
	customsave , idvar(hhid) filename(wave_2_merged.dta) path("`export'") ///
			dofile(NGA_wave2_merge) user($user) 

* close the log
	log	close

/* END */
