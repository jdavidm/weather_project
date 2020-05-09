* Project: WB Weather
* Created on: May 2020
* Created by: jdm
* Stata v.16

* does
	* moves extracted and "cleaned" World Bank data from World Bank file structure
	* place it into our own file structure for use by .do files
	* executes all wave specific Malawi weather .do files
	* outputs .dta LSMS household data ready to append into panel

* assumes
	* Extracted and "cleaned" World Bank Malawi data (provided by Talip Kilic)
	* customsave.ado 
	* subsidiary, wave-specific .do files

* TO DO:
	* complete

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* set global user
	global	user		"jdmichler"

* define paths
	global	source 	= 	"G:/My Drive/weather_project/household_data/malawi/wb_raw_data/tmp"
	global	export 	= 	"G:/My Drive/weather_project/household_data/malawi"
	global	code	= 	"C:/Users/$user/git/weather_project/malawi/household_code"

	
* **********************************************************************
* 1 - move files from WB file structure to our file structure
* **********************************************************************

* move IHS3 data to wave 1 folder
	use			"$source/ihs3cx/hh/hh_final.dta", clear
	customsave	, idvar(case_id) filename(ihs3cx_hh.dta) ///
				path("$export/wave_1/raw") dofile(mwi_hh_masterdo) user($user)
				
	use			"$source/ihs3lpnl/hh/hh_final.dta", clear
	customsave	, idvar(case_id) filename(ihs3lpnl_hh.dta) ///
				path("$export/wave_1/raw") dofile(mwi_hh_masterdo) user($user)
				
	use			"$source/ihs3spnl/hh/hh_final.dta", clear
	customsave	, idvar(case_id) filename(ihs3spnl_hh.dta) ///
				path("$export/wave_1/raw") dofile(mwi_hh_masterdo) user($user)

* move IHPS*pnl data to wave 2 folder
				
	use			"$source/ihpsspnl/hh/hh_final.dta", clear
	customsave	, idvar(y2_hhid) filename(ihpsspnl_hh.dta) ///
				path("$export/wave_2/raw") dofile(mwi_hh_masterdo) user($user)
				
	use			"$source/ihpslpnl/hh/hh_final.dta", clear
	customsave	, idvar(y2_hhid) filename(ihpslpnl_hh.dta) ///
				path("$export/wave_2/raw") dofile(mwi_hh_masterdo) user($user)

* move IHS4 data to wave 3 folder
	use			"$source/ihs4cx/hh/hh_final.dta", clear
	customsave	, idvar(case_id) filename(ihs4cx_hh.dta) ///
				path("$export/wave_3/raw") dofile(mwi_hh_masterdo) user($user)

* move IHS4*pnl data to wave 4folder
	use			"$source/ihs4lpnl/hh/hh_final.dta", clear
	customsave	, idvar(y3_hhid) filename(ihs4lpnl_hh.dta) ///
				path("$export/wave_4/raw") dofile(mwi_hh_masterdo) user($user)
				

* **********************************************************************
* 2 - run wave specific cleaning .do files
* **********************************************************************

* do each IHS3 household cleaning files
	do 			"$code/wave_1/ihs3cx_hh_clean.do"		//	cleans IHS3cx
	do 			"$code/wave_1/ihs3spnl_hh_clean.do"		//	cleans IHS3spnl
	do 			"$code/wave_1/ihs3lpnl_hh_clean.do"		//	cleans IHS3lpnl

* do each IHPS*pnl household cleaning files
	do 			"$code/wave_2/ihpsspnl_hh_clean.do"		//	cleans IHPSspnl
	do 			"$code/wave_2/ihpslpnl_hh_clean.do"		//	cleans IHPSlpnl	

* do IHS4 household cleaning filename
	do 			"$code/wave_3/ihs4cx_hh_clean.do"		//	cleans IHS4cx

* do IHS4*pnl household cleaning filefiles
	do 			"$code/wave_4/ihs4lpnl_hh_clean.do"		//	cleans IHS4lpnl


* **********************************************************************
* 3 - run wave specific .do files to merge with weather
* **********************************************************************

* do each IHS3 household cleaning files
	do 			"$code/wave_1/ihs3cx_build.do"			//	builds IHS3cx with weather
	do 			"$code/wave_1/ihs3spnl_build.do"		//	builds IHS3spnl with weather
	do 			"$code/wave_1/ihs3lpnl_build.do"		//	builds IHS3lpnl with weather

* do each IHPS*pnl household cleaning files
	do 			"$code/wave_2/ihpsspnl_build.do"		//	builds IHPSspnl with weather
	do 			"$code/wave_2/ihpslpnl_build.do"		//	builds IHPSlpnl	with weather

* do IHS4 household cleaning filename
	do 			"$code/wave_3/ihs4cx_build.do"			//	builds IHS4cx with weather
	
* do IHS4*pnl household cleaning filefiles
	do 			"$code/wave_4/ihs4lpnl_build.do"		//	builds IHS4lpnl with weather


* **********************************************************************
* 4 - run .do file to append each wave
* **********************************************************************

	do			"$code/MWI_append_built.do"		// append waves
	
/* END */