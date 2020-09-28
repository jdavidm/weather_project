* Project: WB Weather
* Created on: September 2020
* Created by: jdm
* Stata v.16.1

* does
	* combines data from all countries
	* drops cross sectional data in Malawi and Tanzania
	* does final cleaning of data
	* outputs data set for analysis

* assumes
	* cleaned, merged (weather), and appended (waves) data
	* customsave.ado
	* winsor2.ado

* TO DO:
	* missing Nigeria household weights

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		source	= 	"$data/regression_data"
	loc		export = 	"$data/regression_data"
	loc		logout 	= 	"$data/regression_data/logs"

* open log	
	cap log close
	log 	using 		"`logout'/panel_build", append

	
* **********************************************************************
* 1 - load in and clean malawi data
* **********************************************************************

* read in data file
	use			"`source'/malawi/mwi_complete.dta", clear

* drop dry season values - we just focus on the rainy season (rs)
	drop		ds*

* drop unnecessary variables
	drop		region district urban strata cluster ea_id spid sp_id ///
					y2_hhid y3_hhid cx_id hhid hh_x02 hh_x04 intmonth ///
					intyear qx_type ta lp_id

* drop short panel and cross sectional
	keep if		dtype == "lp"

* rename panel id
	rename		lpid mwi_id
	
* create or rename variables for maize production (seed rate missing in data)
	rename		rsmz_harvestimp cp_hrv
	lab var 	cp_hrv "Harvest of maize (kg)"
		
	rename		rsmz_cultivatedarea cp_lnd
	lab var 	cp_lnd "Land area planted to maize (ha)"
		
	gen 		cp_yld = cp_hrv/cp_lnd
	lab var 	cp_yld "Yield of maize (kg/ha)"

	gen 		cp_lab = rsmz_labordaysimp/cp_lnd
	lab var 	cp_lab "Labor for maize (days/ha)"
		
	rename		rsmz_fert_inorgpct cp_frt
	lab var		cp_frt "Fertilizer (inorganic) for maize (kg/ha)"
		
	rename		rsmz_pest cp_pst
	lab var		cp_pst "Pesticide/Insecticide for maize (=1)"
		
	rename		rsmz_herb cp_hrb
	lab var		cp_hrb "Herbicide/Fungicide for maize (=1)"
		
	rename		rsmz_irrigationany cp_irr
	lab var		cp_irr "Irrigation for maize (=1)"

* convert kwacha into 2010 USD
* exchange rates come from world_bank_exchange_rates.xlsx
	replace		rs_harvest_valueimp = rs_harvest_valueimp/124.3845647 ///
					if year == 2008
	replace		rs_harvest_valueimp = rs_harvest_valueimp/134.2107246 ///
					if year == 2009
	replace		rs_harvest_valueimp = rs_harvest_valueimp/201.9788745 ///
					if year == 2012
	replace		rs_harvest_valueimp = rs_harvest_valueimp/310.8160671 ///
					if year == 2014
	replace		rs_harvest_valueimp = rs_harvest_valueimp/374.6410851 ///
					if year == 2015
		
* create or rename variables for total farm production (seed rate mising)
	rename		rs_harvest_valueimp tf_hrv
	lab var 	tf_hrv "Harvest of all crops (2010 USD)"
		
	rename		rs_cultivatedarea tf_lnd
	lab var 	tf_lnd "Land area planted to all crops (ha)"
		
	gen 		tf_yld = tf_hrv/tf_lnd
	lab var 	tf_yld "Yield of all crops (USD/ha)"
		
	gen 		tf_lab = rs_labordaysimp/tf_lnd
	lab var 	tf_lab "Labor for all crops (days/ha)"
		
	rename		rs_fert_inorgpct tf_frt
	lab var		tf_frt "Fertilizer (inorganic) for all crops (kg/ha)"
		
	rename		rs_pest tf_pst
	lab var		tf_pst "Pesticide/Insecticide for all crops (=1)"
		
	rename		rs_herb tf_hrb
	lab var		tf_hrb "Herbicide/Fungicide for all crops (=1)"
		
	rename		rs_irrigationany tf_irr
	lab var		tf_irr "Irrigation for all crops (=1)"
	
* drop unnecessary variables and reorder remaining
	drop		rs* case_id
	order		tf_hrv tf_lnd tf_yld tf_lab tf_frt tf_pst tf_hrb tf_irr ///
					cp_hrv cp_lnd cp_yld cp_lab cp_frt cp_pst cp_hrb cp_irr, ///
					after(year)


* **********************************************************************
* 2 - load in ethiopia data
* **********************************************************************

* append ethiopia
	append		using "`source'/ethiopia/eth_complete"
		
* drop unnecessary variables
	drop		uid region zone woreda ea
		
* generate household weights		
	replace		hhweight = pw if hhweight == .
	drop		pw household_id household_id2
	
* organize variables
	order		eth_id, before(mwi_id)


* **********************************************************************
* 3 - load in nigeria data
* **********************************************************************

* append nigeria
	append		using "`source'/nigeria/nga_complete"
		
* drop unnecessary variables
	drop		uid zone state lga sector ea hhid
		
* generate household weights		
*	replace		hhweight = pw if hhweight == .
*	drop		pw household_id household_id2
	
* organize variables
	order		nga_id, after(mwi_id)		
		

* **********************************************************************
* 4 - load in tanzania data
* **********************************************************************

* append tanzania
	append		using "`source'/tanzania/tza_complete"		

* drop short panel and cross sectional
	keep if		dtype == "lp"

* drop unnecessary variables
	drop		region district ward ea strataid clusterid uid cx_id

* organize variables
	order		tza_id, after(nga_id)					
	
	
* **********************************************************************
* 5 - clean combined data
* **********************************************************************

* destring data type
	gen			Dtype = 0 if dtype == "cx"
	replace		Dtype = 1 if dtype == "lp"
	replace		Dtype = 2 if dtype == "sp"
	lab var		Dtype "Data type"
	drop		dtype
	rename		Dtype dtype
	order		dtype, after(country)
	lab def 	dtype 0 "cx" 1 "lp" 2 "sp"
	label val 	dtype dtype		

* destring country
	gen			Country = 1 if country == "ethiopia"
	replace		Country = 2 if country == "malawi"
	replace		Country = 3 if country == "mali"
	replace		Country = 4 if country == "niger"
	replace		Country = 5 if country == "nigeria"
	replace		Country = 6 if country == "tanzania"
	replace		Country = 7 if country == "uganda"
	lab var		Country "Country"
	drop		country
	rename		Country country
	order		country
	lab def		country 1 "Ethiopia" 2 "Malawi" 3 "Mali" ///
					4 "Niger" 5 "Nigeria" 6 "Tanzania" ///
					7 "Uganda"
	lab val		country country
	sort 		country

* redefine country household ids
	sort 			country eth_id year
	tostring		eth_id, replace
	replace 		eth_id = "eth" + eth_id if eth_id != "."
	replace			eth_id = "" if eth_id == "."
	
	sort 			country mwi_id year
	tostring		mwi_id, replace
	replace 		mwi_id = "mwi" + mwi_id if mwi_id != "."
	replace			mwi_id = "" if mwi_id == "."
	
	sort 			country nga_id year
	tostring		nga_id, replace
	replace 		nga_id = "nga" + nga_id if nga_id != "."
	replace			nga_id = "" if nga_id == "."
	
	sort 			country tza_id year
	tostring		tza_id, replace
	replace 		tza_id = "tza" + tza_id if tza_id != "."
	replace			tza_id = "" if tza_id == "."

* define cross country household id
	gen				HHID = eth_id if eth_id != ""
	replace			HHID = mwi_id if mwi_id != ""
	replace			HHID = nga_id if nga_id != ""
	replace			HHID = tza_id if tza_id != ""
	
	sort			country HHID year
	egen			hhid = group(HHID)
	
	drop			HHID eth_id mwi_id nga_id tza_id
	order			hhid, after(country)
	lab var			hhid "Unique household ID"
	
* drop temperature bins (for now)
	drop		v23* v24* v25* v26* v27*
		
* create locals for sets of variables
	loc		output		tf_yld cp_yld
	loc 	continputs 	tf_lab tf_frt cp_lab cp_frt		
		
* winsorize data at 1% and 99% per pre-analysis plan
	winsor2 	`output' `continputs', by(country) replace

* convert output variables to logs using invrse hyperbolic sine 
	foreach 		v of varlist `output' {
		qui: gen 		ln`v' = asinh(`v') 
		qui: lab var 	ln`v' "ln of `v'" 
	}

* convert continuous input variables to logs using invrse hyperbolic sine 
	foreach 		v of varlist `continputs' {
		qui: gen 		ln`v' = asinh(`v') 
		qui: lab var 	ln`v' "ln of `v'" 
	}
	
	order		lntf_yld, before(tf_yld)
	order		lncp_yld, before(cp_yld)
	
	order		lntf_la, before(tf_la)
	order		lncp_lab, before(cp_lab)
	
	order		lntf_frt, before(tf_frt)
	order		lncp_frt, before(cp_frt)

* drop unnecessary variables
	drop tf_hrv tf_lnd tf_yld cp_hrv cp_lnd cp_yld tf_lab tf_frt cp_lab cp_frt	
	
	
* **********************************************************************
* 6 - end matter
* **********************************************************************

* save complete results
	qui: compress
	customsave 	, idvarname(hhid) filename("lsms_panel.dta") ///
		path("`export'") dofile(panel_build) user($user)

* close the log
	log	close

/* END */