* Project: WB Weather
* Created on: May 2020
* Created by: jdm
* Stata v.16

* does
	* merges individual cleaned plot datasets together
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

	rename			_merge merge_pplab
	drop			plot_id

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
	*** as above, since a majority don't use fert, we assume missing means no fert

	replace			fert_any = 2 if fert_any == .
	replace			fert_use = 2 if fert_use == .
	*** 128 changes made
	
	drop			plot_id _merge

* merging in harvest labor data
	merge		1:1 hhid plotid using "`root'/ph_secta2"
	*** 201 from master and 223 from using not merged (7%)
	*** like before, not clear if these are zero labor

	rename			_merge merge_hvlab
	drop			plot_id

* merging in harvest quantity and value
	merge		1:1 hhid plotid using "`root'/ph_secta3"
	*** 1020 from master and 2 from using not merged (20%)
	*** from NGA_ph_secta3.do we removed values that were not in seasons
	*** so we drop values that lack observations for harvest
	*** assuming that those input observations are from crops not in season

	keep			if _merge == 3
	drop			_merge
	
* go back and check for unmerged labor values
	tab				merge_pplab
	tab				merge_hvlab
	*** 2.6% of pplab still missing and 1.5% of hvlab missing

* replace missing labor if there was no crop harvest
	replace			hrv_labor = 0 if merge_hvlab != 3 & cp_hrv == 0
	replace			pp_labor = 0 if merge_pplab != 3 & cp_hrv == 0
	
* drop observations missing values
	drop			if plotsize == .
	drop			if irr_any == .
	drop			if pp_labor == .
	drop			if pest_any == .
	drop			if herb_any == .
	drop			if fert_any == .
	drop			if fert_use == .
	drop			if hrv_labor == .
	drop			if cp_hrv == .
	drop			if tf_hrv == .
	*** in total only 89 observations dropped
	
	drop			plot_id merge_pplab merge_hvlab

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
