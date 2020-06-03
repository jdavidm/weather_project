* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.16

* does
	* cleans Tanzania household variables, wave 3 Ag sec4a
	* kind of a crop roster, with harvest weights, long rainy season
	* generates weight harvested, harvest month, percentage of plot planted with given crop
	
* assumes
	* customsave.ado
	* mdesc.ado

* TO DO:
	* completed

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		root	=	"$data/household_data/tanzania/wave_3/raw"
	loc		export	=	"$data/household_data/tanzania/wave_3/refined"
	loc		logout	=	"$data/household_data/tanzania/logs"

* open log
	log		using	"`logout'/wv3_AGSEC4A", append

	
* ***********************************************************************
* 1 - prepare TZA 2012 (Wave 3) - Agriculture Section 4A 
* ***********************************************************************

* load data
	use				"`root'/AG_SEC_4A", clear

* rename variables of interest
	rename			y3_hhid hhid
	rename			zaocode crop_code
	
* create percent of area to crops
	gen				pure_stand = ag4a_01 == 1
	lab var			pure_stand "=1 if crop was pure stand"
	gen				any_pure = pure_stand == 1
	lab var			any_pure "=1 if any crop was pure stand"
	gen				any_mixed = pure_stand == 0
	lab var			any_mixed "=1 if any crop was mixed"
	gen				percent_field = 0.25 if ag4a_02 == 1
	lab var			percent_field "percent of field crop was on"

	replace			percent_field = 0.50 if ag4a_02==2
	replace			percent_field = 0.75 if ag4a_02==3
	replace			percent_field = 1 if pure_stand==1
	duplicates		report hhid plotnum zaoname
	*** there are 20 duplicates

* drop the duplicates
	duplicates		drop hhid plotnum zaoname, force
	*** percent_field and pure_stand variables are the same, so dropping duplicates
	
* create total area on field (total on plot across ALL crops)
	bys 			hhid plotnum: egen total_percent_field = total(percent_field)
	replace			percent_field = percent_field / total_percent_field ///
						if total_percent_field > 1

* check for missing values
	mdesc 			crop_code ag4a_28
	*** 2,249 obs missing crop code
	*** 2,714 obs missing harvest weight
	
* drop if crop code is missing
	drop				if crop_code == .
	*** 2,249 observations dropped

* drop if no harvest occured during long rainy season
	drop				if ag4a_19 != 1
	*** 464 obs dropped
	
* replace missing weight 
	replace 			ag4a_28 = 0 if ag4a_28 == .
	*** one value changed
	
* generate hh x plot x crop identifier
	gen		 			plot_id = hhid + " " + plotnum
	lab var				plot_id "plot id"
	tostring 			crop_code, generate(crop_num)
	gen str20 			crop_id = hhid + " " + plotnum + " " + crop_num
	duplicates report 	crop_id
	lab var				crop_id "unique crop id"
	*** five duplicate crop_ids

* must merge in regional identifiers from 2008_HHSECA to impute
	merge			m:1 hhid using "`export'/HH_SECA"
	tab				_merge
	*** 1,710 not matched
	
	drop if			_merge == 2
	drop			_merge
	
* unique district id
	sort			region district
	egen			uq_dist = group(region district)
	distinct		uq_dist
	*** 130 once this time
	
	
* ***********************************************************************
* 2 - generate harvest variables
* ***********************************************************************

* other variables of interest
	rename 				ag4a_28 wgt_hvsted
	rename				ag4a_29 hvst_value
	tab					hvst_value, missing
	*** hvst_value missing no observations

* currency conversion
	replace				hvst_value = hvst_value/1730.033187
	*** Value comes from World Bank: world_bank_exchange_rates.xlxs

* summarize value of harvest
	sum				hvst_value, detail
	*** median 40, mean 118, max 18,311

* replace any +3 s.d. away from median as missing
	replace			hvst_value = . if hvst_value > `r(p50)'+(3*`r(sd)')
	*** replaced 111 values, max is now 1,054
	
* impute missing values
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed hvst_value // identify kilo_fert as the variable being imputed
	sort			hhid plotnum crop_num, stable // sort to ensure reproducability of results
	mi impute 		pmm hvst_value i.uq_dist i.crop_code, add(1) rseed(245780) ///
						noisily dots force knn(5) bootstrap
	mi 				unset	

* how did the imputation go?
	tab				mi_miss
	tabstat			hvst_value hvst_value_1_, by(mi_miss) ///
						statistics(n mean min max) columns(statistics) ///
						longstub format(%9.3g) 
	replace			hvst_value = hvst_value_1_
	lab var				hvst_value "Value of harvest (2010 USD)"
	drop			hvst_value_1_
	*** imputed 64 values out of 7,447 total observations		

* generate new varaible for measuring maize harvest
	gen				mz_hrv = wgt_hvsted if crop_code == 11
	gen				mz_damaged = 1 if crop_code == 11 & mz_hrv == 0

* summarize value of harvest
	sum				mz_hrv, detail
	*** median 200, mean 501, max 40,000

* replace any +3 s.d. away from median as missing
	replace			mz_hrv = . if mz_hrv > `r(p50)' + (3*`r(sd)')
	*** replaced 41 values, max is now 3,700
	
* impute missing values
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed mz_hrv // identify kilo_fert as the variable being imputed
	sort			hhid plotnum crop_num, stable // sort to ensure reproducability of results
	mi impute 		pmm mz_hrv i.uq_dist if crop_code == 11, add(1) rseed(245780) ///
						noisily dots force knn(5) bootstrap
	mi 				unset	

* how did the imputation go?
	tab				mi_miss1 if crop_code == 11
	tabstat			mz_hrv mz_hrv_1_ if crop_code == 11, by(mi_miss) ///
						statistics(n mean min max) columns(statistics) ///
						longstub format(%9.3g) 
	replace			mz_hrv = mz_hrv_1_  if crop_code == 11
	lab var			mz_hrv "Quantity of maize harvested (kg)"
	drop			mz_hrv_1_
	*** imputed 41 values out of 2,868 total observations			

	
* **********************************************************************
* 3 - end matter, clean up to save
* **********************************************************************
	
* keep what we want, get rid of what we don't
	keep 				hhid plotnum plot_id crop_code crop_id clusterid ///
							strataid y3_weight region district ward village ///
							any_* pure_stand percent_field ///
							mz_hrv hvst_value mz_damaged

	order				hhid plotnum plot_id crop_code crop_id clusterid ///
							strataid y3_weight region district ward village

* check for duplicates
	duplicates		report hhid plotnum crop_code
	*** there are 3 duplicates

* drop the duplicates
	duplicates		drop hhid plotnum crop_code, force
	*** the duplicates are all the same, so dropping duplicates
	
* prepare for export
	isid			hhid plotnum crop_code
	compress
	describe
	summarize 
	sort plot_id
	customsave , idvar(crop_id) filename(AG_SEC4A.dta) path("`export'") ///
		dofile(2012_AGSEC4A) user($user)

* close the log
	log	close

/* END */