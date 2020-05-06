* Project: WB Weather
* Created on: May 2020
* Created by: jdm
* Stata v.16

* does
	* reads in merged data sets
	* appends all the merged data sets
	* outputs three data sets
		* cross section
		* short panel
		* long panel

* assumes
	* cleaned all Malawi data has been cleaned and merged
	* customsave.ado

* TO DO:
	* recode short and long panel
	* check to see if it runs

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* set global user
	global	user		"jdmichler"

* define paths
	loc		root 	= 	"G:/My Drive/weather_project/merged_data/malawi"
	loc		export 	= 	"G:/My Drive/weather_project/regression_data/malawi"
	loc		logout 	= 	"G:/My Drive/weather_project/merged_data/malawi/logs"

* open log	
	log 	using 		"`logout'/mwi_append_merged", append

	
* **********************************************************************
* 1 - append cross section
* **********************************************************************

* define local with all sub-folders in it
	loc			folderList : dir "`root'" dirs "wave_*"

* loop through each file in the above local
	foreach 	folder of local folderList {
	
	* define local to loop through and allow for file name comparison	
		loc 		fileList1 : dir "`root'/`folder'" files "cx*"
		loc 		dat1 = substr("`fileList1'", 1, 3)
		loc 		ext1 = substr("`fileList1'", 5, 2)
		loc 		sat1 = substr("`fileList1'", 8, 3)

	* define local with all wave 1 files in each sub-folder	
		loc 		fileList1 : dir "`root'/`folder'" files "cx1*"
	
	* loop through each file in the above local
		foreach		file1 in `fileList1' {
		
		* import the first .dta merged file files
			use 		"`root'/`file1'", clear
			
		* define local with all wave 2 files in each sub-folder	
			loc fileList2 : dir "`root'" files "cx2*"
	
		* loop through each file in the above local
			foreach		file2 in `fileList2' {
				
				* check to see if files share the same name
					if		(substr("`file1'", 5, 2) == substr("`file2'", 5, 2) )  ///
					& 		(substr("`file1'", 8, 3) == substr("`file2'", 8, 3) )  {
						
					* if they do not match, then append file 2 to file 1
						append		using `root'/`file2', force
				}
		}
		
		* define file naming criteria		
			loc 	ext = substr("`file1'", 5, 2)
			loc 	sat = substr("`file1'", 8, 3)		
					
			* save file
			customsave 	, idvar(case_id) filename("cx_`ext'_tp`sat'_merged.dta") ///
			path("`export'") dofile(mwi_append_merged) user($user)
	}
}
	
* **********************************************************************
* 2 - append short panel
* **********************************************************************

loc fileList1 : dir "`root'" files "sp*"
loc dat1 = substr("`fileList1'", 1, 3)
loc ext1 = substr("`fileList1'", 5, 2)
loc sat1 = substr("`fileList1'", 8, 3)

loc fileList1 : dir "`root'" files "sp1*"
foreach file1 in `fileList1' {
	use "`root'/`file1'", clear
	
	loc fileList2 : dir "`root'" files "sp2*"
	foreach file2 in `fileList2' {
	if  (substr("`file1'", 5, 2) == substr("`file2'", 5, 2) )  ///
	& (substr("`file1'", 8, 3) == substr("`file2'", 8, 3) )  {
	append using `root'/`file2', force
	}
	}
	loc ext = substr("`file1'", 5, 2)
	loc sat = substr("`file1'", 8, 3)
	save "`export'/sp_`ext'_`sat'.dta", replace
}
* **********************************************************************
* 3 - append long panel
* **********************************************************************

loc fileList1 : dir "`root'" files "lp*"
loc dat1 = substr("`fileList1'", 1, 3)
loc ext1 = substr("`fileList1'", 5, 2)
loc sat1 = substr("`fileList1'", 8, 3)

loc fileList1 : dir "`root'" files "lp1*"
foreach file1 in `fileList1' {
	use "`root'/`file1'", clear
	
	loc fileList2 : dir "`root'" files "lp2*"
	foreach file2 in `fileList2' {
	if  (substr("`file1'", 5, 2) == substr("`file2'", 5, 2) )  ///
	& (substr("`file1'", 8, 3) == substr("`file2'", 8, 3) )  {
	append using `root'/`file2', force
		loc fileList3 : dir "`root'" files "lp3*"
		foreach file3 in `fileList3' {
		if  (substr("`file1'", 5, 2) == substr("`file3'", 5, 2) )  ///
		& (substr("`file1'", 8, 3) == substr("`file3'", 8, 3) )  {
		append using `root'/`file3', force
		}
		}
	}
	}
	loc ext = substr("`file1'", 5, 2)
	loc sat = substr("`file1'", 8, 3)
	save "`export'/lp_`ext'_`sat'.dta", replace
}

* close the log
	log	close

/* END */