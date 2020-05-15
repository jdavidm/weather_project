*CODE FOR REGS 
*alj 11 July 2019
*jdm 12 July 2019
*alj 17 July 2019

*ssc install winsor2
clear all
global user "jdmichler"

*Establish location of regression data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\regressions"

*Establish location of individual regression results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\results\individual_results"

*Establish location of complete results
loc results = "C:\Users/$user\Dropbox\Weather_Project\Data\Malawi\results"

Rainfall regressions
local fileList : dir "`root'" files "cx*rf*.dta" 
	foreach file in `fileList'{
	use "`root'/`file'", clear

/*=========================================================================
                        0: Final Cleaning of Data
===========================================================================*/

*JUST INCLUDING WET REASON (RS)

keep case_id- intyear rs_harvest_valuehaimp rsmz_harvestimp rsmz_cultivatedarea rs_cultivatedarea ///
rs_irrigationany rs_fert_inorgpct rs_labordaysimp rs_herb rs_pest rsmz_irrigationany rsmz_fert_inorgpct rsmz_labordaysimp rsmz_herb rsmz_pest ///
mean_season- dev_raindays_percent data- hhweight year 
order case_id hhid data satellite extraction

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
local rainfall mean_season-dev_raindays_percent

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

*Set panel as **cluster**
xtset cluster

tempname myresults
postfile `myresults' str4 depvar str5 regname str25 varname betarain serain adjustedr loglike dfr using myresults.dta, replace

*-----1.1: Value of Harvest

*-rainfall			
foreach v of varlist `rainfall' {
	qui: reg lnrs_harvest_valuehaimp `v'
	post `myresults' ("rs") ("reg1") ("`v'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
} 
*-rainfall and fe			
foreach v of varlist `rainfall' {
	qui: xtreg lnrs_harvest_valuehaimp `v' i.intyear, fe
	post `myresults' ("rs") ("reg2") ("`v'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
}
*-rainfall and inputs and fe 	
foreach v of varlist `rainfall' {
	qui: xtreg lnrs_harvest_valuehaimp `v' `inputsrs' i.year, fe
	post `myresults' ("rs") ("reg3") ("`v'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
} 
*-rainfall and squared rainfall
foreach v of varlist `rainfall' {
	qui: reg lnrs_harvest_valuehaimp c.`v'##c.`v'
	post `myresults' ("rs") ("reg4") ("`v'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
} 
*-rainfall and squared rainfall and fe
foreach v of varlist `rainfall' {
	qui: xtreg lnrs_harvest_valuehaimp c.`v'##c.`v' i.year, fe
	post `myresults' ("rs") ("reg5") ("`v'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
} 
*-rainfall and squared rainfall and inputs and fe
foreach v of varlist `rainfall' {
	qui: xtreg lnrs_harvest_valuehaimp c.`v'##c.`v' `inputsrs' i.year, fe
	post `myresults' ("rs") ("reg6") ("`v'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
} 

*-----1.2: Quantity of Maize

*-rainfall		
foreach v of varlist `rainfall' {
	qui: reg lnrsmz_harvesthaimp `v' 
	post `myresults' ("rsmz") ("reg1") ("`v'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
} 	
*-rainfall and fe
foreach v of varlist `rainfall' {
	qui: xtreg lnrsmz_harvesthaimp `v' i.year, fe
	post `myresults' ("rsmz") ("reg2") ("`v'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
} 		
*-rainfall and inputs and fe
foreach v of varlist `rainfall' {
	qui: xtreg lnrsmz_harvesthaimp `v' `inputsrsmz' i.year, fe
	post `myresults' ("rsmz") ("reg3") ("`v'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
} 		
*-rainfall and squared rainfall
foreach v of varlist `rainfall' {
	qui: reg lnrsmz_harvesthaimp c.`v'##c.`v'
	post `myresults' ("rsmz") ("reg4") ("`v'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
} 
*-rainfall and squared rainfall and fe
foreach v of varlist `rainfall' {
	qui: xtreg lnrsmz_harvesthaimp c.`v'##c.`v' i.year, fe
	post `myresults' ("rsmz") ("reg5") ("`v'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
} 
*-rainfall and squared rainfall and inputs and fe
foreach v of varlist `rainfall' {
	qui: xtreg lnrsmz_harvesthaimp c.`v'##c.`v' `inputsrsmz' i.year, fe
	post `myresults' ("rsmz") ("reg6") ("`v'") (`=_b[`v']') (`=_se[`v']') (`=e(r2_a)') (`=e(ll)') (`=e(df_r)')
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

save "`results'/appended_cx_rf.dta", emptyok replace

loc fileList : dir "`export'" files "myresults_cx*rf*" 
foreach file in `fileList'{
	append using "`export'/`file'" 
}
order sat ext

*Create new ID variables
sort varname
gen aux_var = 1 if varname == "mean_season"
replace aux_var = 2 if varname == "median_season"
replace aux_var = 3 if varname == "sd_season"
replace aux_var = 4 if varname == "skew_season"
replace aux_var = 5 if varname == "total_season"
replace aux_var = 6 if varname == "dev_total_season"
replace aux_var = 7 if varname == "z_total_season"
replace aux_var = 8 if varname == "raindays"
replace aux_var = 9 if varname == "dev_raindays"
replace aux_var = 10 if varname == "norain"
replace aux_var = 11 if varname == "dev_norain"
replace aux_var = 12 if varname == "raindays_percent"
replace aux_var = 13 if varname == "dev_raindays_percent"
replace aux_var = 14 if varname == "dry"

order aux_var, after(varname)
lab define varname 	1 "Mean Daily Rainfall" ///
					2 "Median Daily Rainfall" ///
					3 "Variance of Daily Rainfall" ///
					4 "Skew of Daily Rainfall" ///
					5 "Total Rainfall" ///
					6 "Deviation in Total Rainfall" ///
					7 "Z-Score of Total Rainfall" ///
					8 "Rainy Days" ///
					9 "Deviation in Rainy Days" ///
					10 "No Rain Days" ///
					11 "Deviation in No Rain Days" ///
					12 "% Rainy Days" ///
					13 "Deviation in % Rainy Days" ///
					14 "Longest Dry Spell" ///
					15 "Mean Daily Temperature" ///
					16 "Median Daily Temperature" ///
					17 "Variance of Daily Temperature" ///
					18 "Skew of Daily Temperature" ///
					19 "Growing Degree Days (GDD)" ///
					20 "Deviation in GDD" ///
					21 "Z-Score of GDD" ///
					22 "Maximum Daily Temperature" ///
					23 "Mean of Rain & Temp" ///
					24 "Mean + Variance of  Rain & Temp" ///
					25 "Mean + Variance + Skew of Rain & Temp" ///
					26 "Median Rain & Temp" ///
					27 "Total Rainfall & GDD" ///
					28 "Z-Scores of Total Rainfall & GDD" 
lab values aux_var varname
drop varname
rename aux_var varname

sort sat
egen aux_sat = group(sat)
order aux_sat, after(sat)
lab define sat 	1 "Rainfall 1" ///
				2 "Rainfall 2" ///
				3 "Rainfall 3" ///
				4 "Rainfall 4" ///
				5 "Rainfall 5" ///
				6 "Rainfall 6" ///
				7 "Temperature 1" ///
				8 "Temperature 2" ///
				9 "Temperature 3" 
lab values aux_sat sat
drop sat
rename aux_sat sat

sort ext
egen aux_ext = group(ext)
order aux_ext, after(ext)
lab define ext 	1 "Extraction 1" ///
				2 "Extraction 2" ///
				3 "Extraction 3" ///
				4 "Extraction 4" ///
				5 "Extraction 5" ///
				6 "Extraction 6" ///
				7 "Extraction 7" ///
				8 "Extraction 8" ///
				9 "Extraction 9" ///
				10 "Extraction 10"
lab values aux_ext ext
drop ext
rename aux_ext ext

sort depvar
egen aux_dep = group(depvar)
order aux_dep, after(depvar)
lab define depvar 	1 "Value" ///
					2 "Quantity"
lab values aux_dep depvar
drop depvar
rename aux_dep depvar

sort regname
gen aux_reg = 1 if regname == "reg1"
replace aux_reg = 2 if regname == "reg2"
replace aux_reg = 3 if regname == "reg3"
replace aux_reg = 4 if regname == "reg4"
replace aux_reg = 5 if regname == "reg5"
replace aux_reg = 6 if regname == "reg6"
order aux_reg, after(regname)
lab define regname 	1 "Weather Only" ///
					2 "Weather + FE" ///
					3 "Weather + FE + Inputs" ///
					4 "Weather + Weather^2" ////
					5 "Weather + Weather^2 + FE" ///
					6 "Weather + Weather^2 + FE + Inputs" ///
					7 "Weather + Year FE" ///
					8 "Weather + Year FE + Inputs" ///
					9 "Weather + Weather^2 + Year FE" ///
					10 "Weather + Weather^2 + Year FE + Inputs"
lab values aux_reg regname
drop regname
rename aux_reg regname

save "`results'/appended_cx_rf.dta", replace

