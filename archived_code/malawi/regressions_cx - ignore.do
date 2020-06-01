*CODE FOR REGS
*MW4
*alj 9 July 2019
*jdm 12 July 2019

*ssc install winsor2

global user "jdmichler"

*Establish location of regression data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\regressions"

*Establish location of individual regression results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\results\individual_results"

*Establish location of complete results
loc results = "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\results"

*Rainfall regressions
local fileList : dir "`root'" files "cx*rf*.dta" 
	foreach file in `fileList'{
	use "`root'/`file'", clear

/*=========================================================================
                        0: Final Cleaning of Data
===========================================================================*/

*JUST INCLUDING WET REASON (RS)

*drop unwanted variables
*specify as keep based on macros which will be used later
keep mean_season_2016 median_season_2016 sd_season_2016 total_season_2016 skew_season_2016 norain_2016 raindays_2016 raindays_percent_2016 ///
dry_2016 dev_total_season_2016 z_total_season_2016 dev_raindays_2016 dev_norain_2016 dev_raindays_percent_2016 ///
rs_harvest_valuehaimp rsmz_harvestimp rsmz_cultivatedarea rs_cultivatedarea ///
rs_irrigationany rs_fert_inorgpct rs_labordaysimp rs_herb rs_pest rsmz_irrigationany rsmz_fert_inorgpct rsmz_labordaysimp rsmz_herb rsmz_pest ///
hhid case_id region district urban ea_id strata cluster intmonth intyear

*create harvest variables for maize 
*-others already created
gen rsmz_harvesthaimp = rsmz_harvestimp/rsmz_cultivatedarea
	lab var rsmz_harvesthaimp "Quantity of maize harvest per hectare (kg/ha), imputed"
	order rsmz_harvesthaimp, after(rsmz_harvestimp)
	
*create labor per hectare 
*-others already created 
gen rs_labordayshaimp = rs_labordaysimp/rs_cultivatedarea 
	lab var rs_labordayshaimp "Labor per hectare, imputed"
	order rs_labordayshaimp, after (rs_labordaysimp)
gen rsmz_labordayshaimp = rsmz_labordaysimp/rsmz_cultivatedarea 
	lab var rs_labordayshaimp "Labor for maize per hectare, imputed"
	order rsmz_labordayshaimp, after (rsmz_labordaysimp)
	
*create locals for sets of variables
local output rs_harvest_valuehaimp rsmz_harvesthaimp
local continputs rs_fert_inorgpct rs_labordayshaimp rsmz_fert_inorgpct rsmz_labordayshaimp
local rainfall mean_season_2016-dev_raindays_percent_2016

*winsorize 
winsor2 `output' `continputs', replace

*adjustments to variables
*create logs for output variable 
foreach v of varlist `output' {
	qui: gen ln`v' = asinh(`v') 
	qui: label var ln`v' "ln of `v'" 
		}

*create logs for continuous input variables 
foreach v of varlist `continputs' {
	qui: gen ln`v' = asinh(`v') 
	qui: label var ln`v' "ln of `v'" 
		}
		
local inputsrs rs_irrigationany lnrs_fert_inorgpct lnrs_labordayshaimp rs_herb rs_pest
local inputsrsmz rsmz_irrigationany lnrsmz_fert_inorgpct lnrsmz_labordayshaimp rsmz_herb rsmz_pest
	
/*=========================================================================
                        1: Regressions
===========================================================================*/

*
*Need to put everything below into a loop over folders and files.
*Then need to change the name for myresults so that it includes the name of the data being used
*In a different .do file we need to open the results and add a variable that is the satallite name "rf1" and extraction name "x1"
*Finally we need to append all the results files into one giant results file
*

tempname myresults
postfile `myresults' str4 depvar str4 regname str25 varname betarain serain adjustedr loglike dfr using myresults.dta, replace

*-----1.1: Value of Harvest

*-rainfall variables 			
foreach v of varlist `rainfall' {
	qui: reg lnrs_harvest_valuehaimp `v'
	post `myresults' ("rs") ("reg1") ("`v'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
} 
*-rainfall variables and inputs 	
foreach v of varlist `rainfall' {
	qui: reg lnrs_harvest_valuehaimp `v' `inputsrs' 
	post `myresults' ("rs") ("reg2") ("`v'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
} 
*-rainfall and squared rainfall
foreach v of varlist `rainfall' {
	qui: reg lnrs_harvest_valuehaimp c.`v'##c.`v'
	post `myresults' ("rs") ("reg3") ("`v'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
} 
*-rainfall and squared rainfall and inputs
foreach v of varlist `rainfall' {
	qui: reg lnrs_harvest_valuehaimp c.`v'##c.`v' `inputsrs'
	post `myresults' ("rs") ("reg4") ("`v'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
} 

*-----1.2: Quantity of Maize

*-rainfall variables 		
foreach v of varlist `rainfall' {
	qui: reg lnrsmz_harvesthaimp `v' 
	post `myresults' ("rsmz") ("reg1") ("`v'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
} 		
*-rainfall variables and inputs 	
foreach v of varlist `rainfall' {
	qui: reg lnrsmz_harvesthaimp `v' `inputsrsmz' 
	post `myresults' ("rsmz") ("reg2") ("`v'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
} 		
*-rainfall and squared rainfall
foreach v of varlist `rainfall' {
	qui: reg lnrsmz_harvesthaimp c.`v'##c.`v'
	post `myresults' ("rsmz") ("reg3") ("`v'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
} 
*-rainfall and squared rainfall and inputs 
foreach v of varlist `rainfall' {
	qui: reg lnrsmz_harvesthaimp c.`v'##c.`v' `inputsrsmz'
	post `myresults' ("rsmz") ("reg4") ("`v'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
} 
	
postclose `myresults' 
use myresults, clear 

		loc dat = substr("`file'", 1, 2)
		loc ext = substr("`file'", 4, 2)
		loc sat = substr("`file'", 7, 3)
		
		gen str2 ext = "`ext'"
		gen str3 sat = "`sat'"
		
		gen tstat = betarain/serain
		gen pval = 2*ttail(dfr,abs(tstat))
		gen ci_lo =  betarain - invttail(dfr,0.025)*serain
		gen ci_up =  betarain + invttail(dfr,0.025)*serain
		
		save "`export'/myresults_`dat'_`ext'_`sat'.dta", replace
		
		}
		
clear all

save "`export'/cx_results.dta", emptyok replace

loc fileList : dir "`root'" files "myresults_cx*" 
foreach file in `fileList'{
	append using "`root'/`file'" 
}
order sat ext

save "`export'/cx_results.dta", replace
	
/*
ADD FE WHEN PANEL 
xtreg , fe(hhid)

NEED TO ADD TEMPERATURE 
ADD TEMPERATURE AND RAINFALL COMBINATIONS 
