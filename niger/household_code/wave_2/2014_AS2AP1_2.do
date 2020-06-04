* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Niger, WAVE 2 (2014), POST PLANTING, AG AS2AP1
	* creates binaries and kg for fertilizer use
	* outputs clean data file ready for combination with wave 2 plot data

* assumes
	* customsave.ado
	
* TO DO:
	* add conversion factors for black and white sachets 
	* run file with those conversions 
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		root	=	"$data/household_data/niger/wave_2/raw"
	loc		export	=	"$data/household_data/niger/wave_2/refined"
	loc		logout	=	"$data/household_data/niger/logs"

* open log	
	log 	using 	"`logout'/2014_pp_as2ap1fert", append
	
* **********************************************************************
* 1 - determine pesticide and herbicide use 
* **********************************************************************
		
* import the first relevant data file
	use				"`root'/ECVMA2_AS2AP1", clear 	
	
* need to rename for English
	rename 			PASSAGE visit
	label 			var visit "number of visit"
	rename			GRAPPE clusterid
	label 			var clusterid "cluster number"
	rename			MENAGE hh_num
	label 			var hh_num "household number - not unique id"
	rename 			EXTENSION extension 
	label 			var extension "extension of household"
	*** will need to do these in every file
	rename 			AS02AQA ord 
	label 			var ord "number of order"
	rename 			AS01Q01 field 
	label 			var field "field number"
	rename 			AS01Q03 parcel 
	label 			var parcel "parcel number"
	
* need to include clusterid, hhnumber, extension, order, field, and parcel to uniquely identify
	describe
	sort 			clusterid hh_num extension ord field parcel
	isid 			clusterid hh_num extension ord field parcel

* determine cultivated plot
	rename 			AS02AQ04 cultivated
	label 			var cultivated "plot (parcel) cultivated"
* drop if not cultivated
	keep 			if cultivated == 1
	*** 301 observations dropped

* **********************************************************************
* 2 - determine fertilizer use - binary and kg 
* **********************************************************************

* create fertilizer binary value
	egen 			fert_any = rsum(AS02AQ09B AS02AQ10B AS02AQ11B AS02AQ12B)
	replace			fert_any = 1 if fert_any > 0 
	tab 			fert_any, missing
	*** 1,123 use some sort of fertilizer (21%), none missing
	
* create conversion units - kgs, tiya, black sachet, white sachet 	
	gen 			kgconv = 1 
	gen 			tiyaconv = 3
	gen 			bsachet = .
	gen 			wsachet = . 
	*** do not currently know converison for black and white sachets 
	
* create amoung of fertilizer value (kg)
** UREA 
	replace AS02AQ09C = . if AS02AQ09C == 9 
	rename AS02AQ09C ureaunits
	rename AS02AQ09B ureaquant
	gen kgurea = ureaquant*kgconv if ureaunits == 1
	replace kgurea = ureaquant*tiyaconv if ureaunits == 2
	*replace kgurea = ureaquant*bsachetconv if ureaunits == 3
	*replace kgurea = ureaquant*wsachetconv if ureaunits == 4
	tab kgurea 
** DAP
	replace AS02AQ10C = . if AS02AQ10C == 9 
	rename AS02AQ10C dapunits
	rename AS02AQ10B dapquant
	gen kgdap = dapquant*kgconv if dapunits == 1
	replace kgdap = dapquant*tiyaconv if dapunits == 2
	*replace kgdap = dapquant*bsachetconv if dapunits == 3
	*replace kgdap = dapquant*wsachetconv if dapunits == 4
	tab kgdap 
** NPK
	replace AS02AQ11C = . if AS02AQ11C == 9 
	rename AS02AQ11C npkunits
	rename AS02AQ11B npkquant
	gen npkkg = npkquant*kgconv if npkunits == 1
	replace npkkg = npkquant*tiyaconv if npkunits == 2
	*replace npkkg = npkquant*bsachetconv if npkunits == 3
	*replace npkkg = npkquant*wsachetconv if npkunits == 4
	tab npkkg 
** BLEND 
	replace AS02AQ12C = . if AS02AQ12C == 9 
	rename AS02AQ12C blendunits
	rename AS02AQ12B blendquant
	gen blendkg = blendquant*kgconv if blendunits == 1
	replace blendkg = blendquant*tiyaconv if blendunits == 2
	*replace blendkg = blendquant*bsachetconv if blendunits == 3
	*replace blendkg = blendquant*wsachetconv if blendunits == 4
	tab blendkg 

*total use 
	egen fert_use = rsum(kgurea kgdap npkkg blendkg)
	count  if fert_use != . 
	count  if fert_use == . 
	*** how many missing / not
	
* summarize fertilizer
	sum				fert_use, detail
	*** median , mean , max 

* replace any +3 s.d. away from median as missing
	replace			fert_use = . if fert_use > `r(p50)'+(3*`r(sd)')
	*** replaced  values, max is now 
	
* impute missing values
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed fert_use // identify kilo_fert as the variable being imputed
	sort			clusterid hh_num extension ord field parcel, stable // sort to ensure reproducability of results
	mi impute 		pmm fert_use i.clusterid, add(1) rseed(245780) ///
						noisily dots force knn(5) bootstrap
	mi 				unset
	
* how did the imputation go?
	tab				mi_miss
	tabstat			fert_use fert_use_1_, by(mi_miss) ///
						statistics(n mean min max) columns(statistics) ///
						longstub format(%9.3g) 
	replace			fert_use = fert_use_1_
	lab var			fert_use "fertilizer use (kg), imputed"
	drop			fert_use_1_
	*** imputed  values out of  total observations	
	
* check for missing values
	count 			if fert_use == !.
	count			if fert_use == .
	*** 

* **********************************************************************
* 3 - end matter, clean up to save
* **********************************************************************

	keep 			clusterid hh_num extension ord field parcel fert_any fert_use

	
* create unique household-plot identifier
	isid				clusterid hh_num extension ord field parcel
	sort				clusterid hh_num extension ord field parcel
	egen				plot_id = group(clusterid hh_num extension ord field parcel)
	lab var				plot_id "unique field and parcel identifier"

	compress
	describe
	summarize

* save file
		customsave , idvar(plot_id) filename("2014_pp_as2ap1fert.dta") ///
			path("`export'") dofile(2014_AS2AP1_2) user($user)

* close the log
	log	close

/* END */