* Created on: May 2021
* Created by: Brian McGreal
* Stata v.17

* does
	* reads in qgis zonal statistics datasets on cotton and alfalfa cropping by ID
	* combines individual data set into one master dataset

* assumes
	* qgis zonal stats datasetes present in "groundwater project\data\crop_acres" folder

* TO DO:
	* done

* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc logout = "C:\Users\thema\OneDrive\Documents\EAWP\gis\code"	
	loc dofile = "C:\Users\thema\OneDrive\Documents\EAWP\gis\data"
	
* open log
	cap log close
	log using "`logout'/aez_area", append
	
	
* **********************************************************************
* 1 - collapse and clean datasets
* **********************************************************************

* establish for-loops -
	loc 	fileList : dir "`dofile'" files "*xlsx"
	
	* loop through each file in the above local
		foreach file in `fileList' {
			
			clear all
						
			import excel "`dofile'/`file'", firstrow
			
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
				replace		subhumid = 1 if substr("`file'", 6,5) == "subhu"
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
				
				save 		"`dofile'/`temp'`wet'.dta", replace

		}
		
	clear all
		
		
* **********************************************************************
* 2 - append and clean datasets
* **********************************************************************

	use 	"`dofile'\cool_humid.dta"

* establish for-loops
	loc 	fileList : dir "`dofile'" files "*.dta"

		* loop through each file in the above local
		foreach file in `fileList' {
		    
			append		using "`dofile'/`file'"
		    
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
	
	
* **********************************************************************
* 3 - save output
* **********************************************************************	

	save	"C:\Users\thema\OneDrive\Documents\EAWP\gis\aez_bycountry.dta", replace
