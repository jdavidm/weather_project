*merge household file with weather files
clear all
global user "jdmichler"

* For data
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\regressions"

****x0
use "`export'/lp_x0_tp1.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x0_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x0_tp1_rf`i'.dta", replace
	}

use "`export'/lp_x0_tp2.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x0_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x0_tp2_rf`i'.dta", replace
	}

use "`export'/lp_x0_tp3.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x0_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x0_tp3_rf`i'.dta", replace
	}

****x1
use "`export'/lp_x1_tp1.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x1_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x1_tp1_rf`i'.dta", replace
	}

use "`export'/lp_x1_tp2.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x1_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x1_tp2_rf`i'.dta", replace
	}

use "`export'/lp_x1_tp3.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x1_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x1_tp3_rf`i'.dta", replace
	}

****x2
use "`export'/lp_x2_tp1.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x2_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x2_tp1_rf`i'.dta", replace
	}

use "`export'/lp_x2_tp2.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x2_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x2_tp2_rf`i'.dta", replace
	}

use "`export'/lp_x2_tp3.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x2_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x2_tp3_rf`i'.dta", replace
	}

****x3
use "`export'/lp_x3_tp1.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x3_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x3_tp1_rf`i'.dta", replace
	}

use "`export'/lp_x3_tp2.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x3_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x3_tp2_rf`i'.dta", replace
	}

use "`export'/lp_x3_tp3.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x3_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x3_tp3_rf`i'.dta", replace
	}


****x4
use "`export'/lp_x4_tp1.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x4_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x4_tp1_rf`i'.dta", replace
	}

use "`export'/lp_x4_tp2.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x4_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x4_tp2_rf`i'.dta", replace
	}

use "`export'/lp_x4_tp3.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x4_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x4_tp3_rf`i'.dta", replace
	}

****x5
use "`export'/lp_x5_tp1.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x5_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x5_tp1_rf`i'.dta", replace
	}

use "`export'/lp_x5_tp2.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x5_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x5_tp2_rf`i'.dta", replace
	}

use "`export'/lp_x5_tp3.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x5_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x5_tp3_rf`i'.dta", replace
	}

****x6
use "`export'/lp_x6_tp1.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x6_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x6_tp1_rf`i'.dta", replace
	}

use "`export'/lp_x6_tp2.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x6_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x6_tp2_rf`i'.dta", replace
	}

use "`export'/lp_x6_tp3.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x6_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x6_tp3_rf`i'.dta", replace
	}


****x7
use "`export'/lp_x7_tp1.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x7_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x7_tp1_rf`i'.dta", replace
	}

use "`export'/lp_x7_tp2.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x7_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x7_tp2_rf`i'.dta", replace
	}

use "`export'/lp_x7_tp3.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x7_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x7_tp3_rf`i'.dta", replace
	}

****x8
use "`export'/lp_x8_tp1.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x8_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x8_tp1_rf`i'.dta", replace
	}

use "`export'/lp_x8_tp2.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x8_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x8_tp2_rf`i'.dta", replace
	}

use "`export'/lp_x8_tp3.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x8_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x8_tp3_rf`i'.dta", replace
	}

****x9
use "`export'/lp_x9_tp1.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x9_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x9_tp1_rf`i'.dta", replace
	}

use "`export'/lp_x9_tp2.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x9_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x9_tp2_rf`i'.dta", replace
	}

use "`export'/lp_x9_tp3.dta", clear
	rename mean_season mean_temp
	rename median_season median_temp
	rename sd_season sd_temp
	rename skew_season skew_temp
	rename max_season max_temp
		
	forvalues i=1/6 {
		merge 1:1 case_id y3_hhid y2_hhid using "`export'/lp_x9_rf`i'.dta"
		drop _merge
		save "`export'/combo/lp_x9_tp3_rf`i'.dta", replace
	}
clear
