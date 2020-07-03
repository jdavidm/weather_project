* Project: WB Weather
* Created on: June 2020
* Created by: ek
* Stata v.16

* does
	* reads in Niger, WAVE 1 (2011), Post Planting, ecvmaas1_p1_en
	* * creates binaries and kg for fertilizer use
	* outputs clean data file ready for combination with wave 1 plot data

* assumes
	* customsave.ado

* TO DO:
	* done
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		root	=		"$data/household_data/niger/wave_1/raw"
	loc		export	=		"$data/household_data/niger/wave_1/refined"
	loc		logout	= 		"$data/household_data/niger/logs"

* open log
	cap 	log 	close
	log 	using	"`logout'/2011_pp_as2ap1fert", append

* **********************************************************************
* 1 - describing plot size - self-reported and GPS
* **********************************************************************
	
* import the first relevant data file
	use				"`root'/ecvmaas1_p1_en", clear
	
	rename 			passage visit
	label 			var visit "number of visit - wave number"
	rename			grappe clusterid
	label 			var clusterid "cluster number"
	rename			menage hh_num
	label 			var hh_num "household number - not unique id"
	rename 			as01qa ord 
	label 			var ord "number of order"
	*** note that ord is the id number
	rename 			as01q03 field 
	label 			var field "field number"
	rename 			as01q05 parcel 
	label 			var parcel "parcel number"
	*** cant find "extension" variable like they have in wave 2. This is a problem because in wave 2 we make a unique id based on clusterid, hhnumber, extension, order, field, and parcel to uniquely identify
	
* need to include clusterid, hhnumber, order, field, and parcel to uniquely identify
	describe
	sort 			clusterid hh_num ord field parcel
	isid 			clusterid hh_num ord field parcel
	
* determine cultivated plot
	rename 			as01q40 cultivated
	label 			var cultivated "plot cultivated"

* drop if not cultivated
	keep 			if cultivated == 1
	*** 220 observations deleted
	
* **********************************************************************
* 2 - determine fertilizer use - binary and kg 
* **********************************************************************

* create fertilizer binary value
	egen 			fert_any = rsum(as02aq11a as02aq12a as02aq13a as02aq14a)
	replace			fert_any = 1 if fert_any > 0 
	tab 			fert_any, missing
	*** 817 use some sort of fertilizer (12.68%), none missing
	
* create conversion units - kgs, tiya
	gen 			kgconv = 1 
	gen 			tiyaconv = 3
	
* create amount of fertilizer value (kg)
	*** Units are measured in kilogram bags of various sizes, will convert to kg's where appropriate
	*** 99 appears to reflect a null or missing value
** UREA 
	replace as02aq11a = . if as02aq11a == 99 
	rename as02aq11b ureaunits
	rename as02aq11a ureaquant
	gen kgurea = ureaquant*kgconv if ureaunits == 1
	replace kgurea = ureaquant*tiyaconv if ureaunits == 6
	replace kgurea = ureaquant*5 if ureaunits == 2
	replace kgurea = ureaquant*10 if ureaunits == 3
	replace kgurea = ureaquant*25 if ureaunits == 4
	replace kgurea = ureaquant*50 if ureaunits == 5
	replace kgurea = . if ureaunits == 8
	replace kgurea = . if ureaunits == 7
	tab kgurea 
** DAP
	replace as02aq12a = . if as02aq12a == 99 
	rename as02aq12b dapunits
	rename as02aq12a dapquant
	gen kgdap = dapquant*kgconv if dapunits == 1
	replace kgdap = dapquant*tiyaconv if dapunits == 6
	replace kgdap = dapquant*5 if dapunits == 2
	replace kgdap = dapquant*10 if dapunits == 3
	replace kgdap = dapquant*25 if dapunits == 4
	replace kgdap = dapquant*50 if dapunits == 5
	replace kgdap = . if dapunits == 7
	tab kgdap 
** NPK
	replace as02aq13a = . if as02aq13a == 99 
	rename as02aq13b npkunits
	rename as02aq13a npkquant
	gen npkkg = npkquant*kgconv if npkunits == 1
	replace npkkg = npkquant*tiyaconv if npkunits == 6
	replace npkkg = npkquant*5 if npkunits == 2
	replace npkkg = npkquant*10 if npkunits == 3
	replace npkkg = npkquant*25 if npkunits == 4
	replace npkkg = npkquant*50 if npkunits == 5
	replace npkkg = . if npkunits == 7
	replace npkkg = . if npkunits == 8
	tab npkkg 
** BLEND 
	replace as02aq14a = . if as02aq14a == 99 
	rename as02aq14b blendunits
	rename as02aq14a blendquant
	gen blendkg = blendquant*kgconv if blendunits == 1
	replace blendkg = blendquant*tiyaconv if blendunits == 5
	replace blendkg = blendquant*5 if blendunits == 2
	replace blendkg = blendquant*25 if blendunits == 3
	replace blendkg = blendquant*50 if blendunits == 4
	replace blendkg = . if blendunits == 6
	tab blendkg 

*total use 
	egen fert_use = rsum(kgurea kgdap npkkg blendkg)
	count  if fert_use != . 
	count  if fert_use == . 
	*** need to replace those in sachets equal to . because those will be replaced with 0s in summation 
	replace fert_use = . if ureaunits == 7
	*** 10 changes made
	replace fert_use = . if ureaunits == 8
	*** 0 changes made
	replace fert_use = . if dapunits == 3
	*** 4 changes made
	replace fert_use = . if dapunits == 7
	*** 0 change made
	replace fert_use = . if npkunits == 7
	*** 8 changes made
	replace fert_use = . if npkunits == 8
	*** 0 changes made
	replace fert_use = . if blendunits == 6
	*** 4 changes made 
	
* summarize fertilizer
	sum				fert_use, detail
	*** median - 0 , mean - 9.517, max - 2750

* replace any +3 s.d. away from median as missing
	replace			fert_use = . if fert_use > `r(p50)'+(3*`r(sd)')
	*** replaced 52 values, max is now 250 
	
* impute missing values
	mi set 			wide 	// declare the data to be wide.
	mi xtset		, clear 	// clear any xtset that may have had in place previously
	mi register		imputed fert_use // identify fert_use as the variable being imputed
	sort			clusterid hh_num ord field parcel, stable // sort to ensure reproducability of results
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
	*** imputed 217 values out of 5139 total observations	
	
* check for missing values
	count 			if fert_use == !.
	count			if fert_use == .
	*** 5814 total values
	*** 0 missing values 

* **********************************************************************
* 3 - end matter, clean up to save
* **********************************************************************

	keep 			clusterid hh_num ord field parcel fert_any fert_use

	
* create unique household-plot identifier
	isid				clusterid hh_num ord field parcel
	sort				clusterid hh_num ord field parcel
	egen				plot_id = group(clusterid hh_num ord field parcel)
	lab var				plot_id "unique field and parcel identifier"

	compress
	describe
	summarize

* save file
		customsave , idvar(plot_id) filename("2011_pp_as2ap1fert.dta") ///
			path("`export'") dofile(2011_AS2AP1_2) user($user)

* close the log
	log	close

/* END */
	
	