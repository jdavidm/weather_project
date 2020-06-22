* Project: WB Weather
* Created on: June 2020
* Created by: McG
* Stata v.16

* does
	* cleans Ethiopia household variables, wave 3 PH sec9
	* seems to roughly correspong to Malawi ag-modG and ag-modM
	* contains harvest weights and other info (dates, etc.)
	* hierarchy: holder > parcel > field > crop

* assumes
	* customsave.ado
	* distinct.ado
	
* TO DO:
	* like in pp_sect3, many observtions from master are not being matched
	
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc root = "$data/household_data/ethiopia/wave_3/raw"
	loc export = "$data/household_data/ethiopia/wave_3/refined"
	loc logout = "$data/household_data/ethiopia/logs"

* open log
	log using "`logout'/wv3_PHSEC9", append


* **********************************************************************
* 1 - preparing ESS (Wave 3) - Post Harvest Section 9
* **********************************************************************

* load data
	use 		"`root'/sect9_ph_w3.dta", clear

* dropping duplicates
	duplicates drop
	*** 0 obs dropped 
		
* one ob missing local ids, even though holder_id has 4 other obs and crop_code is present	
	replace 	household_id = "07070100903022" ///
					if holder_id == "0707010090302201" & household_id == ""
	replace 	household_id2 = "070701088800903022" ///
					if holder_id == "0707010090302201" & household_id2 == ""
	replace 	rural = 1 if holder_id == "0707010090302201" & rural == .
	replace 	pw_w3 = 3452.8 if holder_id == "0707010090302201" & pw_w3 == .
	replace 	ea_id = "07070100903" ///
					if holder_id == "0707010090302201" & ea_id == ""
	replace 	saq01 = 7 if holder_id == "0707010090302201" & saq01 == .
	replace 	saq02 = 7 if holder_id == "0707010090302201" & saq02 == .
	replace 	saq03 = 1 if holder_id == "0707010090302201" & saq03 == .
	replace 	saq04 = 9 if holder_id == "0707010090302201" & saq04 == .
	replace 	saq05 = 3 if holder_id == "0707010090302201" & saq05 == .
	replace 	saq06 = 22 if holder_id == "0707010090302201" & saq06 == .
	replace 	ph_saq07 = 1 if holder_id == "0707010090302201" & ph_saq07 == .
	
* check # of maize obs
	tab			crop_code
	*** 3,380 maize obs
	
* drop if obs haven't harvested crop
	tab			ph_s9q03
	*** 4,398 answered no
	
	drop 		if ph_s9q03 == 2
				
* attempting to generate unique identifier
	describe
	sort 		holder_id parcel_id field_id crop_code
	isid 		holder_id parcel_id field_id crop_code, missok
	
* creating parcel identifier
	rename		parcel_id parcel
	tostring	parcel, replace
	generate 	parcel_id = holder_id + " " + ea_id + " " + parcel
	
* creating field identifier
	rename		field_id field
	tostring	field, replace
	generate 	field_id = holder_id + " " + ea_id + " " + parcel + " " + field
	
* creating unique crop identifier
	tostring	crop_code, generate(crop_codeS)
	generate 	crop_id = holder_id + " " + ea_id + " " + parcel + " " ///
					+ field + " " + crop_codeS
	isid		crop_id
	drop		crop_codeS

* creating district identifier
	egen 		district_id = group( saq01 saq02)
	label var 	district_id "Unique district identifier"
	distinct	saq01 saq02, joint
	*** 69 distinct districts
	*** same as pp sect2 & pp sect3, good
	
* check for missing crop codes
	tab			crop_code, missing
	** no missing crop codes in this wave =]

* create conversion key 
	rename		ph_s9q04_b unit_cd
	tab 		unit_cd, missing
	*** missing 4,398 units of measure
	
	merge 		m:1 crop_code unit_cd using "`root'/Crop_CF_Wave3.dta"
	*** 7,127 obs not matched from master data
	*** 4,398 due to no unit_cd
	*** why are the others missing?
	
	tab 		_merge
	drop		if _merge == 2
	drop		_merge


* ***********************************************************************
* 2 - finding harvest weights
* ***********************************************************************	

* ***********************************************************************
* 2a - generating conversion factors
* ***********************************************************************	
	
* creating harvest (kg) based on self reported values
* self reported values listed in various units of measure
* if self reported values are missing, we will attempt to replace with dried cutting weight
* will require data merging from another section (I believe sect3_pp_w1)
	rename		ph_s9q04_a hrvqty_self
	rename 		ph_s9q05 hrvqty_self_kgest	
	
* exploring conversion factors - are any the same across all regions and obs?
	tab 		unit_cd
	egen		unitnum = group(unit_cd)
	*** 56 units listed
	
	gen			cfavg = (mean_cf1 + mean_cf2 + mean_cf3 + mean_cf4 + mean_cf6 ///
							+ mean_cf7 + mean_cf12 + mean_cf99)/8
	pwcorr 		cfavg mean_cf_nat	
	*** correlation of 0.9999 - this will work
	
	local 		units = 56
	forvalues	i = 1/`units'{
	    
		tab		unit_cd if unitnum == `i'
		tab 	cfavg if unitnum == `i', missing
	} 
	*** results! universla units are:
	*** kilogram, gram, quintal, and jenbe
	*** bunch (small, medium, and large)
	*** shekim (small, medium, and large)
	*** zorba/akara (small, medium and large)
	*** also, chinets (small, medium, and large) have no conversion factors given

* generating conversion factors
* starting with units found to be universal
	gen			cf = 1 if unit_cd == 1 			// kilogram
	replace		cf = .001 if unit_cd == 2 		// gram
	replace		cf = 100 if unit_cd == 3 		// quintal
	replace		cf = 31.487 if unit_cd == 7 	// jenbe
	replace		cf = 9.6 if unit_cd == 41		// bunches
	replace		cf = 17.5 if unit_cd == 42
	replace		cf = 19.08 if unit_cd == 43	
	replace		cf = 7.27 if unit_cd == 161		// shekim
	replace		cf = 21.66 if unit_cd == 162
	replace		cf = 41 if unit_cd == 163
	replace		cf = .16 if unit_cd == 191		// zorba/akara
	replace		cf = .27 if unit_cd == 192
	replace		cf = .57 if unit_cd == 193
	
	*** PROVIDE CODE AND EXPLANATION ***
	replace 	cf = 30 if unit_cd == 51		// chinets
	replace 	cf = 50 if unit_cd == 52
	replace 	cf = 70 if unit_cd == 53
	
* now moving on to region specific units
	replace 	cf = mean_cf1 if saq01 == 1 & cf == .
	replace		cf = mean_cf2 if saq01 == 2 & cf == .	
	replace 	cf = mean_cf3 if saq01 == 3 & cf == .
	replace 	cf = mean_cf4 if saq01 == 4 & cf == .
	replace 	cf = mean_cf99 if saq01 == 5 & cf == .
	replace 	cf = mean_cf6 if saq01 == 6 & cf == .
	replace 	cf = mean_cf7 if saq01 == 7 & cf == .
	replace 	cf = mean_cf12 if saq01 == 12 & cf == .
	replace 	cf = mean_cf99 if saq01 == 13 & cf == .
	replace 	cf = mean_cf99 if saq01 == 15 & cf == .
	replace		cf = mean_cf_nat if cf == . & mean_cf_nat != . 
	*** 0 changes for the last line
	
* checking veracity of kg estimates
	tab 		cf, missing
	*** missing 6,994 - slightly fewer than missed merges due to univeral units
	
	tab			cf if hrvqty_self != ., missing
	tab			hrvqty_self if cf != ., missing
	*** there are no self report harvest quanities w/out a conversion factor
	
	
* ***********************************************************************
* 2b - constructing harvest weights
* ***********************************************************************		
	
	gen			hrvqty_self_converted = hrvqty_self * cf
	pwcorr		hrvqty_self_converted hrvqty_self_kgest
	*** correlation of 0.5045 - not terrible but not great either
	*** i'm inclined to take the surveyor's estimate over the converted kgs
	*** being that the conversion factors are region wide averages
	*** the surveyor may have been able to estimate based on more local info
	
	gen			hrvqty_selfr = hrvqty_self_kgest
	replace		hrvqty_selfr = hrvqty_self_converted if hrvqty_selfr == . 
	*** only 98 changes made in this step

	tab			hrvqty_selfr, missing
	*** missing 17 obs
	
	sum 		hrvqty_selfr, detail
	*** mean qty 135 kg, this seems plausible
	*** max at 50K - less plausible
	*** there are 49 obs = 0, crop damage?

	
* ***********************************************************************
* 2c - resolving zero values
* ***********************************************************************		

* crop damage
	rename 		ph_s9q11 damaged
	rename 		ph_s9q13 damaged_pct
	tab 		damaged_pct damaged, missing
	tab 		hrvqty_selfr damaged, missing
	*** crop damage reported on 47 of the 49 obs w/ harv quantity = 0
	*** what about 100% crop damage on other obs?
	
	tab 		damaged_pct if hrvqty_selfr == 0
	*** wide range of percentages, was hoping for all 100s	
	
	generate 	destroyed = 1 if damaged == 1 & damaged_pct == 100
	gen 		destroyed_lite = 1 if damaged_pct == 100
	replace		destroyed = 0 if destroyed == .
	replace 	destroyed_lite = 0 if destroyed_lite == .
	pwcorr		destroyed destroyed_lite
	*** correlation of 0.9981 - will use destroyed_lite
	
	tab			damaged_pct
	tab 		destroyed_lite, missing
	*** 1,965 obs reporting 100% destroyed
	*** the problem here is i'm not confident in how damaged_pct is reported
	*** there are 11 obs >100% damage
	*** there are also 258 obs reporting <5% damage
	
* let's take stock of where we're at so far
*	order 		hrvqty_selfr hrvqty_self_kgest hrvqty_self_converted ///
*					hrvqty_self cf destroyed_lite destroyed damaged damaged_pct ///
*					unit_cd							
	sort 		hrvqty_selfr 
	tab			hrvqty_self if hrvqty_selfr == 0, missing
	*** these all have non-zero self reported values
	*** two are listed as destroyed (100% crop damage)
	
	tab			hrvqty_self_converted if hrvqty_selfr == 0, missing
	*** 11 of 49 missing, due to missing conversion factors
	
* i'm torn as to what to do, i'm going to replace zeros w/ self reported values
* this may be inconsistent with my thought process on lines 177-179
	replace		hrvqty_selfr = hrvqty_self_converted if hrvqty_selfr == 0 & ///
					hrvqty_self_converted != .
	sort		hrvqty_selfr
	*** only 11 zeros remain, still 17 = .
	*** if this step is taken, neither of the two destroyed obs remain (line 236)
	
	tab 		unit_cd if hrvqty_selfr == 0
	*** mostly (7 of 11) chinet small
	
	sort		hrvqty_selfr holder_id
	*** only four holders represent these 11 obs
	*** could there be matches for the same unit in the same region?

* what cf's am i needing?
*	order		hrvqty_selfr holder_id unit_cd saq01 
	sort		hrvqty_selfr holder_id unit_cd
	*** i need: 	a medium chinet (52) in snnp, a small chinet (51) in snnp, 
	***				a small kerchat/kemba (91) in snnp, box/casa (6) in harari
	*** recall that no conversion factors were given for any chinets
	
	sort 		unit_cd household_id holder_id
	***	findings:	the same holder that has a zero value for hrvqty_selfr
	***				has two other crops given in kerchat/kemba small, with two
	***				different conversion factors. 
	***				i thought this couldn't be the case. i'm confused
	***				the same holder, same location, no regional differences
	***				values for box/casa in harari vary wildly
	
* here's what occurs to me
	sum			mean_cf7 if unit_cd == 91 // mean 10.2935
	sum			mean_cf99 if unit_cd == 6 // mean 50.5405
	
	replace		cf = 10.2935 if unit_cd == 91 & saq01 == 7 & hrvqty_selfr == 0 ///
					& cf == .
	*** 2 changes, good
	
	replace		cf = 50.5405 if unit_cd == 6 & saq01 == 13 & hrvqty_selfr == 0 ///
					& cf == .
	*** 1 change
	
	replace		hrvqty_self_converted = hrvqty_self * cf ///
					if hrvqty_self_converted == .
	*** 3 changes
	
	replace 	hrvqty_selfr = hrvqty_self_converted if hrvqty_selfr == 0 ///
					& hrvqty_self_converted != .
	*** 3 changes
	
* chinet conversions - 30 for small, 50 for medium, 70 for large
	
* remaining zeros are all chinets in SNNP - 8 obs
* can a regional conversion factor be reverse engineered? how?
* either replace with missing and impute or continue to count these as zeros
* chinet conversions - 30 for small, 50 for medium, 70 for large
* based on algebra and supported by online research
	
* ***********************************************************************
* 2d - resolving missing values
* ***********************************************************************		

* summarize value of harvest
	sum				hrvqty_selfr, detail
	*** median 45, mean 135, max 50,000 - max is huge!

* replace any +3 s.d. away from median as missing
	replace			hrvqty_selfr = . if hrvqty_selfr > `r(p50)'+(3*`r(sd)')
	*** replaced 114 values, max is now 2,000
	
* impute missing harvest weights using predictive mean matching 
	mi set 		wide //	declare the data to be wide. 
	mi xtset, 	clear //	this is a precautinary step to clear any xtset that the analyst may have had in place previously
	mi register imputed hrvqty_selfr //	identify hrvqty_selfr as the variable being imputed 
	sort		holder_id parcel field crop_code, stable // sort to ensure reproducability of results
	mi impute 	pmm hrvqty_selfr i.district_id, add(1) rseed(245780) ///
					noisily dots force knn(5) bootstrap 
	mi 			unset

* summarize results of imputation
	tabulate 	mi_miss	//	this binary = 1 for the full set of observations where plotsize_GPS is missing
	tabstat 	hrvqty_selfr hrvqty_selfr_1_, by(mi_miss) ///
					statistics(n mean min max) columns(statistics) longstub ///
					format(%9.3g) 
	*** 4,427 imputations made
	
	drop		mi_miss	

* manipulate variables for export
	drop		hrvqty_selfr
	rename 		hrvqty_selfr_1_ hrvqty_selfr
	label 		variable hrvqty_selfr		"Harvest Weight, kg (self-reported)"
	sum 		hrvqty_selfr, detail
	
* generate maize harvest weights
	gen 		mz_hrv = hrvqty_selfr if crop_code == 2
	
	
* ***********************************************************************
* 3 - cleaning and keeping
* ***********************************************************************

* purestand or mixed and if mixed what percent was planted with this crop?
	rename		ph_s9q01 purestand
	rename		ph_s9q02 mixedcrop_pct

* renaming some variables of interest
	rename 		household_id hhid
	rename 		household_id2 hhid2	
	rename 		saq01 region
	rename		saq02 zone
	rename 		saq03 woreda
	rename 		saq05 ea 
	rename		hrvqty_selfr harvest_qty
	
* restrict to variables of interest 
* this is how world bank has their do-file set up
* if we want to keep all identifiers (i.e. region, zone, etc) we can do that easily
	keep  		holder_id- crop_code crop_id mz_hrv harvest_qty purestand ///
					mixedcrop_pct
	*** keeping harvest quantity for all crops as a precaution
	
	drop		crop_name
	order 		holder_id- crop_code
	
* renaming and relabelling variables
	lab var			region "Region Code"
	lab var			zone "Zone Code"
	lab var			woreda "Woreda Code"
	lab var			ea "Village / Enumeration Area Code"	
	lab var			mz_hrv "Quantity of Maize Harvested (kg)"
	lab var 		crop_code "Crop Identifier"
	lab var			crop_id "Unique Crop ID Within Plot"

* final preparations to export
	isid 		crop_id
	compress
	describe
	summarize 
	*** one ob is missing ea, other obs w/ same ea id exist
	
	replace		ea = 6 if ea == .
	summarize
	sort 		holder_id ea_id parcel field crop_code
	customsave , idvar(crop_id) filename(PP_SEC9.dta) path("`export'") ///
		dofile(PP_SEC9) user($user)

* close the log
	log	close