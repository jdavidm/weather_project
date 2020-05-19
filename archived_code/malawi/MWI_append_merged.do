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

* define paths
	loc		root 		= 	"$data/merged_data/malawi"
	loc		export 	= 	"$data/regression_data/malawi"
	loc		logout 	= 	"$data/merged_data/malawi/logs"

* open log
	log 	using 		"`logout'/mwi_append_merged", append


* **********************************************************************
* 1 - append cross section
* **********************************************************************

* define local to loop through and allow for file name comparison
	loc 		fileList1 : dir "`root'/wave_1" files "cx*"
	loc 		dat1 = substr("`fileList1'", 1, 3)
	loc 		ext1 = substr("`fileList1'", 5, 2)
	loc 		sat1 = substr("`fileList1'", 8, 3)

* define local with all wave 1 files in each sub-folder
	loc 		fileList1 : dir "`root'/wave_1" files "cx1*"

* loop through each file in the above local
	foreach		file1 in `fileList1' {

	* import the first .dta merged file
		use 		"`root'/wave_1/`file1'", clear

	* define local with all wave 3 files in each sub-folder
		loc 		fileList2 : dir "`root'/wave_3" files "cx2*"

	* loop through each file in the above local
		foreach		file2 in `fileList2' {

		* check to see if files share the same name
			if		(substr("`file1'", 5, 2) == substr("`file2'", 5, 2) )  ///
			& 		(substr("`file1'", 8, 3) == substr("`file2'", 8, 3) )  {

			* if they do not match, then append file 2 to file 1
				append		using "`root'/wave_3/`file2'", force
		}
	}
	* define file naming criteria
		loc 	ext = substr("`file1'", 5, 2)
		loc 	sat = substr("`file1'", 8, 3)

	* save file
		customsave 	, idvar(case_id) filename("cx_`ext'_`sat'.dta") ///
			path("`export'") dofile(mwi_append_merged) user($user)
}


* **********************************************************************
* 2 - append short panel
* **********************************************************************

* define local to loop through and allow for file name comparison
	loc 		fileList1 : dir "`root'/wave_1" files "sp*"
	loc 		dat1 = substr("`fileList1'", 1, 3)
	loc 		ext1 = substr("`fileList1'", 5, 2)
	loc 		sat1 = substr("`fileList1'", 8, 3)

* define local with all wave 1 files in each sub-folder
	loc 		fileList1 : dir "`root'/wave_1" files "sp1*"

* loop through each file in the above local
	foreach 	file1 in `fileList1' {

	* import the first .dta merged file files
		use 		"`root'/wave_1/`file1'", clear

	* define local with all wave 2 files in each sub-folder
		loc 		fileList2 : dir "`root'/wave_2" files "sp2*"

	* loop through each file in the above local
		foreach 	file2 in `fileList2' {

		* check to see if files share the same name
			if  	(substr("`file1'", 5, 2) == substr("`file2'", 5, 2) )  ///
			& 		(substr("`file1'", 8, 3) == substr("`file2'", 8, 3) )  {

			* if they do not match, then append file 2 to file 1
				append 		using "`root'/wave_2/`file2'", force
		}
	}
	* define file naming criteria
	loc 		ext = substr("`file1'", 5, 2)
	loc 		sat = substr("`file1'", 8, 3)

	* save file
	customsave 	, idvar(case_id) filename("sp_`ext'_`sat'.dta") ///
		path("`export'") dofile(mwi_append_merged) user($user)
}


* **********************************************************************
* 3 - append long panel
* **********************************************************************

* define local to loop through and allow for file name comparison
	loc 		fileList1 : dir "`root'/wave_1" files "lp*"
	loc 		dat1 = substr("`fileList1'", 1, 3)
	loc 		ext1 = substr("`fileList1'", 5, 2)
	loc 		sat1 = substr("`fileList1'", 8, 3)

* define local with all wave 1 files in each sub-folder
	loc 		fileList1 : dir "`root'/wave_1" files "lp1*"

* loop through each file in the above local
	foreach 	file1 in `fileList1' {

	* import the first .dta merged file files
		use 		"`root'/wave_1/`file1'", clear

	* define local with all wave 2 files in each sub-folder
		loc 		fileList2 : dir "`root'/wave_2" files "lp2*"

	* loop through each file in the above local
		foreach 	file2 in `fileList2' {

		* check to see if files share the same name
			if  	(substr("`file1'", 5, 2) == substr("`file2'", 5, 2) )  ///
			& 		(substr("`file1'", 8, 3) == substr("`file2'", 8, 3) )  {

			* if they do not match, then append file 2 to file 1
				append 		using "`root'/wave_2/`file2'", force

			* define local with all wave 4 files in each sub-folder
				loc 		fileList3 : dir "`root'/wave_4" files "lp3*"

			* loop through each file in the above local
				foreach 	file3 in `fileList3' {

				* check to see if files share the same name
					if  		(substr("`file1'", 5, 2) == substr("`file3'", 5, 2) )  ///
					& 			(substr("`file1'", 8, 3) == substr("`file3'", 8, 3) )  {

				* if they do not match, then append file 2 to file 1
					append 		using "`root'/wave_4/`file3'", force
				}
			}
		}
	}
	* define file naming criteria
		loc 		ext = substr("`file1'", 5, 2)
		loc 		sat = substr("`file1'", 8, 3)

	* save file
	customsave 	, idvar(y2_hhid) filename("lp_`ext'_`sat'.dta") ///
		path("`export'") dofile(mwi_append_merged) user($user)
}

* close the log
	log	close

/* END */
