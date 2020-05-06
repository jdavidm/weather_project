clear all

*merge household file with weather files
global user "jdmichler"

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\merged_datasets"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\regressions"


*Append Cross Section
loc fileList1 : dir "`root'" files "cx*"
loc dat1 = substr("`fileList1'", 1, 3)
loc ext1 = substr("`fileList1'", 5, 2)
loc sat1 = substr("`fileList1'", 8, 3)

loc fileList1 : dir "`root'" files "cx1*"
foreach file1 in `fileList1' {
	use "`root'/`file1'", clear
	
	loc fileList2 : dir "`root'" files "cx2*"
	foreach file2 in `fileList2' {
	if  (substr("`file1'", 5, 2) == substr("`file2'", 5, 2) )  ///
	& (substr("`file1'", 8, 3) == substr("`file2'", 8, 3) )  {
	append using `root'/`file2', force
	}
	}
	loc ext = substr("`file1'", 5, 2)
	loc sat = substr("`file1'", 8, 3)
	save "`export'/cx_`ext'_`sat'.dta", replace
}
/*
*Append Short Panel
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

*Append Long Panel
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
clear
