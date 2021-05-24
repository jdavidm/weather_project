* Created on: May 2021
* Created by: Brian McGreal
* Stata v.17

* does
	* reads in qgis zonal statistics datasets on AEZs by country
	* combines individual data set into one master dataset

* assumes
	* qgis zonal stats datasetes present in "results_data/gis_data" folder

* TO DO:
	* done

* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		source	= 	"$data/results_data/gis_data"
	loc		results = 	"$data/results_data/gis_data"
	loc		logout 	= 	"$data/results_data/logs"
	
* open log
	cap log close
	log 	using 		"`logout'/aez_area", append
	
	
* **********************************************************************
* 1 - collapse and clean datasets
* **********************************************************************

* establish for-loops -
	loc 	fileList : dir "`source'" files "*xlsx"
	
	* loop through each file in the above local
		foreach file in `fileList' {
			
			clear all
						
			import excel "`source'/`file'", firstrow
			
				* define locals to govern variable naming
				loc temp = substr("`file'", 1, 4)
				
				loc wet = substr("`file'", 5,6)
				
				collapse	(sum) _count _sum, by(NAME)
				
				rename 		_count 		country_area
				rename		_sum 		aez_area
									
				gen 		cool = .
				gen 		warm = .
									
				replace		warm = 1 if substr("`file'", 1, 4) == "warm"
				replace		cool = 1 if substr("`file'", 1, 4) == "cool"
				
				gen 		semiarid = .
				gen 		subhumid = .
				gen 		humid = .
				gen			arid = .
				
				replace		semiarid = 1 if substr("`file'", 6,5) == "sarid"
				replace		subhumid = 1 if substr("`file'", 6,5) == "subhd"
				replace		humid = 1 if substr("`file'", 6,5) == "humid"
				replace 	arid = 1 if substr("`file'", 6,5) == "aridd"
				
				generate	keeper = .
				
				replace		keeper = 1 if NAME == "Ethiopia"
				replace		keeper = 1 if NAME == "Malawi"
				replace		keeper = 1 if NAME == "Niger"
				replace		keeper = 1 if NAME == "Nigeria"
				replace		keeper = 1 if NAME == "Tanzania"
				replace		keeper = 1 if NAME == "Uganda"
				
				drop if 	keeper != 1
				drop		keeper
				
				save 		"`results'/`temp'`wet'.dta", replace

		}
		
	clear all
		
		
* **********************************************************************
* 2 - append and clean datasets
* **********************************************************************

	use 	"`source'\cool_humid.dta"

* establish for-loops
	loc 	fileList : dir "`source'" files "*d.dta"

		* loop through each file in the above local
		foreach file in `fileList' {
		    
			append		using "`source'/`file'"
		    
		}
		
* drop duplicate obs		
	duplicates drop
		
* generate aez-area variables
	gen 	wsa_area = aez_area if warm == 1 & semiarid == 1
	gen 	wsh_area = aez_area if warm == 1 & subhumid == 1
	gen 	whu_area = aez_area if warm == 1 & humid == 1
	gen		war_area = aez_area if warm == 1 & arid == 1
	gen 	csa_area = aez_area if cool == 1 & semiarid == 1
	gen 	csh_area = aez_area if cool == 1 & subhumid == 1
	gen 	chu_area = aez_area if cool == 1 & humid == 1
	gen		car_area = aez_area if cool == 1 & arid == 1
	
* collapse to the country level
	collapse	(sum) wsa_area wsh_area whu_area war_area csa_area csh_area ///
				chu_area car_area, by(NAME country_area)
	
* generate percent measures
	gen		wsa_pct = wsa_area/country_area
	gen		wsh_pct = wsh_area/country_area
	gen		whu_pct = whu_area/country_area
	gen		war_pct = war_area/country_area
	gen		csa_pct = csa_area/country_area
	gen		csh_pct = csh_area/country_area
	gen		chu_pct = chu_area/country_area
	gen		car_pct = car_area/country_area
	
* total area (as a check)
	gen 	total_area = wsa_area + wsh_area + whu_area + war_area + csa_area ///
			+ csh_area + chu_area + car_area
			
	gen		total_pct = total_area/country_area
	

* **********************************************************************
* 3 - labels and things
* **********************************************************************		
	
	rename	NAME country
	label	variable country "Country"
	label	variable country_area "Pixel Area of Country"
	
	label 	variable wsa_area "Pixel Area of Tropic-Warm/Semiarid AEZ"
	label 	variable wsh_area "Pixel Area of Tropic-Warm/Subhumid AEZ"
	label 	variable whu_area "Pixel Area of Tropic-Warm/Humid AEZ"
	label 	variable war_area "Pixel Area of Tropic-Warm/Arid AEZ"
	label 	variable csa_area "Pixel Area of Tropic-Cool/Semiarid AEZ"
	label 	variable csh_area "Pixel Area of Tropic-Cool/Subhumid AEZ"
	label 	variable chu_area "Pixel Area of Tropic-Cool/Humid AEZ"
	label 	variable car_area "Pixel Area of Tropic-Cool/Arid AEZ"
	
	label 	variable wsa_pct "Percent of Country in Tropic-Warm/Semiarid AEZ"
	label 	variable wsh_pct "Percent of Country in Tropic-Warm/Subhumid AEZ"
	label 	variable whu_pct "Percent of Country in Tropic-Warm/Humid AEZ"
	label 	variable war_pct "Percent of Country in Tropic-Warm/Arid AEZ"
	label 	variable csa_pct "Percent of Country in Tropic-Cool/Semiarid AEZ"
	label 	variable csh_pct "Percent of Country in Tropic-Cool/Subhumid AEZ"
	label 	variable chu_pct "Percent of Country in Tropic-Cool/Humid AEZ"
	label 	variable car_pct "Percent of Country in Tropic-Cool/Arid AEZ"
	
	label	variable total_area "Total AEZ Pixel Area"
	label 	variable total_pct "Percent of Country in Any Tropic AEZ"
	
	
* **********************************************************************
* 4 - save output
* **********************************************************************	

	save	"`results'\aez_bycountry.dta", replace
