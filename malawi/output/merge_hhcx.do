*merge household file with weather files
global user "jdmichler"

* For weather data
loc roota = "C:\Users/$user\Dropbox\Weather_Project\Malawi_analysis_datasets\data"
* For household data
loc rooth = "C:\Users/$user\Dropbox\Weather_Project\merged_datasets"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\merged_datasets"

*merge cross section household files with ag season files

use "`roota'/ihs3cx\ag\AG_MOD_A_FILT.dta", clear
destring case_id, replace

merge 1:1 case_id using "`rooth'/hhfinal_ihs3cx.dta"

drop ag_c01 ag_j01- ag_s00

save "`rooth'/hhfinal_ihs3cx.dta", replace

use "`roota'/ihs3cx\ag\AG_MOD_A_FILT.dta", clear
destring case_id, replace

merge 1:1 case_id using "`rooth'/hhfinal_ihs3cx.dta"

drop ag_c01 ag_j01- ag_s00

save "`rooth'/hhfinal_ihs3cx.dta", replace

