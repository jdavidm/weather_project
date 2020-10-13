
	loc root 		= "$data/household_data/uganda/wave_2/raw"
	loc export 		= "$data/household_data/uganda/wave_2/refined"
	loc logout 		= "$data/variable_related_files/Uganda planting month"
	
	cap log 		close
	log using 		"`logout'/harvmonth", append
	
		use 			"`root'/2010_AGSEC5A.dta", clear
		
			keep if cropID == 130

			sum cropID
			
			rename a5aq6e harvmonth
			
			rename HHID hhid
			
* merge the location identification
	merge m:1 		hhid using "`export'/2010_GSEC1"
	
	drop 			if _merge == 2
	drop			_merge
	
* encode district for the imputation
	encode 			district, gen (districtdstrng)
	encode			county, gen (countydstrng)
	encode			subcounty, gen (subcountydstrng)
	encode			parish, gen (parishdstrng)
	
			* by region
			histogram harvmonth, by(region)
			graph export "G:\My Drive\weather_project\variable_related_files\Uganda planting month\harvmonth by region.png", as(png) name("Graph") replace
			
			* by district
			histogram harvmonth, by(districtdstrng)
graph export "G:\My Drive\weather_project\variable_related_files\Uganda planting month\harvmonth by district.png", as(png) name("Graph") replace

			* by county
			histogram harvmonth, by(countydstrng)
graph export "G:\My Drive\weather_project\variable_related_files\Uganda planting month\harvmonth by county.png", as(png) name("Graph") replace


bys districtdstrng: sum harvmonth if region == 0

bys districtdstrng: sum harvmonth if region == 1

bys districtdstrng: sum harvmonth if region == 2

bys districtdstrng: sum harvmonth if region == 3

bys districtdstrng: sum harvmonth if region == 4

log close
