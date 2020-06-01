*CODE FOR REGS 
*panel -- not yet done
*alj 11 July 2019
*jdm 12 July 2019
*jdm 15 July 2019

*ssc install winsor2
clear all
global user "jdmichler"

*Establish location of regression data
loc root = "C:\Users/$user\Dropbox\Weather_Project\regressions\combo"

*Establish location of individual regression results
loc export = "C:\Users/$user\Dropbox\Weather_Project\results\individual_results\combo"

*Establish location of complete results
loc results = "C:\Users/$user\Dropbox\Weather_Project\results"

/*Combo regressions
local fileList : dir "`root'" files "lp*.dta" 
	foreach file in `fileList'{
	use "`root'/`file'", clear

/*=========================================================================
                        0: Final Cleaning of Data
===========================================================================*/

*JUST INCLUDING WET REASON (RS)

keep case_id- intyear rs_harvest_valuehaimp rsmz_harvestimp rsmz_cultivatedarea rs_cultivatedarea ///
rs_irrigationany rs_fert_inorgpct rs_labordaysimp rs_herb rs_pest rsmz_irrigationany rsmz_fert_inorgpct rsmz_labordaysimp rsmz_herb rsmz_pest ///
mean_temp- z_gdd data- y2_hhid y3_hhid mean_season- dev_raindays_percent
order y2_hhid y3_hhid data satellite extraction, after(case_id)

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

*set panel
xtset case_id 

tempname myresults
postfile `myresults' str4 depvar str4 regname str25 varname adjustedr loglike dfr  ///
	beta1rain se1rain beta1temp se1temp beta2rain se2rain beta2temp se2temp ///
	beta3rain se3rain beta3temp se3temp using myresults.dta, replace

*-----1.1: Value of Harvest

*-mean variables 	
	qui: reg lnrs_harvest_valuehaimp mean_season mean_temp
	post `myresults' ("rs") ("reg1") ("mean") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[mean_season]') (`=_se[mean_season]') (`=_b[mean_temp]') (`=_se[mean_temp]') ///
	(.) (.) (.) (.) (.) (.) (.) (.)

	qui: xtreg lnrs_harvest_valuehaimp mean_season mean_temp i.intyear, fe
	post `myresults' ("rs") ("reg2") ("mean") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[mean_season]') (`=_se[mean_season]') (`=_b[mean_temp]') (`=_se[mean_temp]') ///
	(.) (.) (.) (.) (.) (.) (.) (.)

	qui: xtreg lnrs_harvest_valuehaimp mean_season mean_temp `inputsrs' i.intyear, fe 
	post `myresults' ("rs") ("reg3") ("mean") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[mean_season]') (`=_se[mean_season]') (`=_b[mean_temp]') (`=_se[mean_temp]') ///
	(.) (.) (.) (.) (.) (.) (.) (.)

*-mean + variance variables 	
	qui: reg lnrs_harvest_valuehaimp mean_season mean_temp sd_season sd_temp 
	post `myresults' ("rs") ("reg1") ("mean+var") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[mean_season]') (`=_se[mean_season]') (`=_b[mean_temp]') (`=_se[mean_temp]') ///
	(`=_b[sd_season]') (`=_se[sd_season]') (`=_b[sd_temp]') (`=_se[sd_temp]')  ///
	(.) (.) (.) (.)

	qui: xtreg lnrs_harvest_valuehaimp mean_season mean_temp sd_season sd_temp i.intyear, fe
	post `myresults' ("rs") ("reg2") ("mean+var") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[mean_season]') (`=_se[mean_season]') (`=_b[mean_temp]') (`=_se[mean_temp]') ///
	(`=_b[sd_season]') (`=_se[sd_season]') (`=_b[sd_temp]') (`=_se[sd_temp]') ///
	(.) (.) (.) (.)

	qui: xtreg lnrs_harvest_valuehaimp mean_season mean_temp sd_season sd_temp `inputsrs' i.intyear, fe 
	post `myresults' ("rs") ("reg3") ("mean+var") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[mean_season]') (`=_se[mean_season]') (`=_b[mean_temp]') (`=_se[mean_temp]') ///
	(`=_b[sd_season]') (`=_se[sd_season]') (`=_b[sd_temp]') (`=_se[sd_temp]') ///
	(.) (.) (.) (.)

*-mean + variance + skew variables
	qui: reg lnrs_harvest_valuehaimp mean_season mean_temp sd_season skew_season sd_temp skew_temp
	post `myresults' ("rs") ("reg1") ("mean+var+skew") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[mean_season]') (`=_se[mean_season]') (`=_b[mean_temp]') (`=_se[mean_temp]') ///
	(`=_b[sd_season]') (`=_se[sd_season]') (`=_b[sd_temp]') (`=_se[sd_temp]')  ///
	(`=_b[skew_season]') (`=_se[skew_season]') (`=_b[skew_temp]') (`=_se[skew_temp]')

	qui: xtreg lnrs_harvest_valuehaimp mean_season mean_temp sd_season skew_season sd_temp skew_temp i.intyear, fe
	post `myresults' ("rs") ("reg2") ("mean+var+skew") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[mean_season]') (`=_se[mean_season]') (`=_b[mean_temp]') (`=_se[mean_temp]') ///
	(`=_b[sd_season]') (`=_se[sd_season]') (`=_b[sd_temp]') (`=_se[sd_temp]') ///
	(`=_b[skew_season]') (`=_se[skew_season]') (`=_b[skew_temp]') (`=_se[skew_temp]')

	qui: xtreg lnrs_harvest_valuehaimp mean_season mean_temp sd_season skew_season sd_temp skew_temp `inputsrs' i.intyear, fe 
	post `myresults' ("rs") ("reg3") ("mean+var+skew") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[mean_season]') (`=_se[mean_season]') (`=_b[mean_temp]') (`=_se[mean_temp]') ///
	(`=_b[sd_season]') (`=_se[sd_season]') (`=_b[sd_temp]') (`=_se[sd_temp]') ///
	(`=_b[skew_season]') (`=_se[skew_season]') (`=_b[skew_temp]') (`=_se[skew_temp]')

*-median variables 	
	qui: reg lnrs_harvest_valuehaimp median_season median_temp
	post `myresults' ("rs") ("reg1") ("median") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[median_season]') (`=_se[median_season]') (`=_b[median_temp]') (`=_se[median_temp]') ///
	(.) (.) (.) (.) (.) (.) (.) (.)

	qui: xtreg lnrs_harvest_valuehaimp median_season median_temp i.intyear, fe
	post `myresults' ("rs") ("reg2") ("median") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[median_season]') (`=_se[median_season]') (`=_b[median_temp]') (`=_se[median_temp]') ///
	(.) (.) (.) (.) (.) (.) (.) (.)

	qui: xtreg lnrs_harvest_valuehaimp median_season median_temp `inputsrs' i.intyear, fe 
	post `myresults' ("rs") ("reg3") ("median") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[median_season]') (`=_se[median_season]') (`=_b[median_temp]') (`=_se[median_temp]') ///
	(.) (.) (.) (.) (.) (.) (.) (.)

*-total variables 	
	qui: reg lnrs_harvest_valuehaimp total_season gdd
	post `myresults' ("rs") ("reg1") ("total") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[total_season]') (`=_se[total_season]') (`=_b[gdd]') (`=_se[gdd]') ///
	(.) (.) (.) (.) (.) (.) (.) (.)

	qui: xtreg lnrs_harvest_valuehaimp total_season gdd i.intyear, fe
	post `myresults' ("rs") ("reg2") ("total") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[total_season]') (`=_se[total_season]') (`=_b[gdd]') (`=_se[gdd]') ///
	(.) (.) (.) (.) (.) (.) (.) (.)

	qui: xtreg lnrs_harvest_valuehaimp total_season gdd `inputsrs' i.intyear, fe 
	post `myresults' ("rs") ("reg3") ("total") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[total_season]') (`=_se[total_season]') (`=_b[gdd]') (`=_se[gdd]') ///
	(.) (.) (.) (.) (.) (.) (.) (.)

*-z-score variables 	
	qui: reg lnrs_harvest_valuehaimp z_total_season z_gdd
	post `myresults' ("rs") ("reg1") ("z-score") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[z_total_season]') (`=_se[z_total_season]') (`=_b[z_gdd]') (`=_se[z_gdd]') ///
	(.) (.) (.) (.) (.) (.) (.) (.)

	qui: xtreg lnrs_harvest_valuehaimp z_total_season z_gdd i.intyear, fe
	post `myresults' ("rs") ("reg2") ("z-score") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[z_total_season]') (`=_se[z_total_season]') (`=_b[z_gdd]') (`=_se[z_gdd]') ///
	(.) (.) (.) (.) (.) (.) (.) (.)

	qui: xtreg lnrs_harvest_valuehaimp z_total_season z_gdd `inputsrs' i.intyear, fe 
	post `myresults' ("rs") ("reg3") ("z-score") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[z_total_season]') (`=_se[z_total_season]') (`=_b[z_gdd]') (`=_se[z_gdd]') ///
	(.) (.) (.) (.) (.) (.) (.) (.)

*-----1.2: Quantity of Maize

*-mean variables 	
	qui: reg lnrsmz_harvesthaimp mean_season mean_temp
	post `myresults' ("rsmz") ("reg1") ("mean") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[mean_season]') (`=_se[mean_season]') (`=_b[mean_temp]') (`=_se[mean_temp]') ///
	(.) (.) (.) (.) (.) (.) (.) (.)

	qui: xtreg lnrsmz_harvesthaimp mean_season mean_temp i.intyear, fe
	post `myresults' ("rsmz") ("reg2") ("mean") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[mean_season]') (`=_se[mean_season]') (`=_b[mean_temp]') (`=_se[mean_temp]') ///
	(.) (.) (.) (.) (.) (.) (.) (.)

	qui: xtreg lnrsmz_harvesthaimp mean_season mean_temp `inputsrsmz' i.intyear, fe 
	post `myresults' ("rsmz") ("reg3") ("mean") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[mean_season]') (`=_se[mean_season]') (`=_b[mean_temp]') (`=_se[mean_temp]')  ///
	(.) (.) (.) (.) (.) (.) (.) (.)

*-mean + variance variables 	
	qui: reg lnrsmz_harvesthaimp mean_season mean_temp sd_season sd_temp 
	post `myresults' ("rsmz") ("reg1") ("mean+var") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[mean_season]') (`=_se[mean_season]') (`=_b[mean_temp]') (`=_se[mean_temp]') ///
	(`=_b[sd_season]') (`=_se[sd_season]') (`=_b[sd_temp]') (`=_se[sd_temp]') ///
	(.) (.) (.) (.)

	qui: xtreg lnrsmz_harvesthaimp mean_season mean_temp sd_season sd_temp i.intyear, fe
	post `myresults' ("rsmz") ("reg2") ("mean+var") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[mean_season]') (`=_se[mean_season]') (`=_b[mean_temp]') (`=_se[mean_temp]') ///
	(`=_b[sd_season]') (`=_se[sd_season]') (`=_b[sd_temp]') (`=_se[sd_temp]') ///
	(.) (.) (.) (.)

	qui: xtreg lnrsmz_harvesthaimp mean_season mean_temp sd_season sd_temp `inputsrsmz' i.intyear, fe 
	post `myresults' ("rsmz") ("reg3") ("mean+var") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[mean_season]') (`=_se[mean_season]') (`=_b[mean_temp]') (`=_se[mean_temp]') ///
	(`=_b[sd_season]') (`=_se[sd_season]') (`=_b[sd_temp]') (`=_se[sd_temp]') ///
	(.) (.) (.) (.)

*-mean + variance + skew variables
	qui: reg lnrsmz_harvesthaimp mean_season mean_temp sd_season skew_season sd_temp skew_temp
	post `myresults' ("rsmz") ("reg1") ("mean+var+skew") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[mean_season]') (`=_se[mean_season]') (`=_b[mean_temp]') (`=_se[mean_temp]') ///
	(`=_b[sd_season]') (`=_se[sd_season]') (`=_b[sd_temp]') (`=_se[sd_temp]')  ///
	(`=_b[skew_season]') (`=_se[skew_season]') (`=_b[skew_temp]') (`=_se[skew_temp]')

	qui: xtreg lnrsmz_harvesthaimp mean_season mean_temp sd_season skew_season sd_temp skew_temp i.intyear, fe
	post `myresults' ("rsmz") ("reg2") ("mean+var+skew") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[mean_season]') (`=_se[mean_season]') (`=_b[mean_temp]') (`=_se[mean_temp]') ///
	(`=_b[sd_season]') (`=_se[sd_season]') (`=_b[sd_temp]') (`=_se[sd_temp]') ///
	(`=_b[skew_season]') (`=_se[skew_season]') (`=_b[skew_temp]') (`=_se[skew_temp]')

	qui: xtreg lnrsmz_harvesthaimp mean_season mean_temp sd_season skew_season sd_temp skew_temp `inputsrsmz' i.intyear, fe 
	post `myresults' ("rsmz") ("reg3") ("mean+var+skew") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[mean_season]') (`=_se[mean_season]') (`=_b[mean_temp]') (`=_se[mean_temp]') ///
	(`=_b[sd_season]') (`=_se[sd_season]') (`=_b[sd_temp]') (`=_se[sd_temp]') ///
	(`=_b[skew_season]') (`=_se[skew_season]') (`=_b[skew_temp]') (`=_se[skew_temp]')

*-median variables 	
	qui: reg lnrsmz_harvesthaimp median_season median_temp
	post `myresults' ("rsmz") ("reg1") ("median") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[median_season]') (`=_se[median_season]') (`=_b[median_temp]') (`=_se[median_temp]') ///
	(.) (.) (.) (.) (.) (.) (.) (.)

	qui: xtreg lnrsmz_harvesthaimp median_season median_temp i.intyear, fe
	post `myresults' ("rsmz") ("reg2") ("median") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[median_season]') (`=_se[median_season]') (`=_b[median_temp]') (`=_se[median_temp]') ///
	(.) (.) (.) (.) (.) (.) (.) (.)

	qui: xtreg lnrsmz_harvesthaimp median_season median_temp `inputsrsmz' i.intyear, fe 
	post `myresults' ("rsmz") ("reg3") ("median") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[median_season]') (`=_se[median_season]') (`=_b[median_temp]') (`=_se[median_temp]') ///
	(.) (.) (.) (.) (.) (.) (.) (.)

*-total variables 		
	qui: reg lnrsmz_harvesthaimp total_season gdd
	post `myresults' ("rsmz") ("reg1") ("total") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[total_season]') (`=_se[total_season]') (`=_b[gdd]') (`=_se[gdd]') ///
	(.) (.) (.) (.) (.) (.) (.) (.)

	qui: xtreg lnrsmz_harvesthaimp total_season gdd i.intyear, fe
	post `myresults' ("rsmz") ("reg2") ("total") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[total_season]') (`=_se[total_season]') (`=_b[gdd]') (`=_se[gdd]') ///
	(.) (.) (.) (.) (.) (.) (.) (.)

	qui: xtreg lnrsmz_harvesthaimp total_season gdd `inputsrsmz' i.intyear, fe 
	post `myresults' ("rsmz") ("reg3") ("total") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[total_season]') (`=_se[total_season]') (`=_b[gdd]') (`=_se[gdd]') ///
	(.) (.) (.) (.) (.) (.) (.) (.)

*-z-score variables 		
	qui: reg lnrsmz_harvesthaimp z_total_season z_gdd
	post `myresults' ("rsmz") ("reg1") ("z-score") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[z_total_season]') (`=_se[z_total_season]') (`=_b[z_gdd]') (`=_se[z_gdd]') ///
	(.) (.) (.) (.) (.) (.) (.) (.)
	qui: xtreg lnrsmz_harvesthaimp z_total_season z_gdd i.intyear, fe
	post `myresults' ("rsmz") ("reg2") ("z-score") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[z_total_season]') (`=_se[z_total_season]') (`=_b[z_gdd]') (`=_se[z_gdd]') ///
	(.) (.) (.) (.) (.) (.) (.) (.)

	qui: xtreg lnrsmz_harvesthaimp z_total_season z_gdd `inputsrsmz' i.intyear, fe 
	post `myresults' ("rsmz") ("reg3") ("z-score") (`=e(r2_a)') (`=e(ll)') (`=e(df_r)') ///
	(`=_b[z_total_season]') (`=_se[z_total_season]') (`=_b[z_gdd]') (`=_se[z_gdd]') ///
	(.) (.) (.) (.) (.) (.) (.) (.)
		
	
postclose `myresults'
use myresults, clear 

		loc dat = substr("`file'", 1, 2)
		loc ext = substr("`file'", 4, 2)
		loc sat1 = substr("`file'", 7, 3)
		loc sat2 = substr("`file'", 11, 3)
		
		gen str2 ext = "`ext'"
		gen str3 sat1 = "`sat1'"
		gen str3 sat2 = "`sat2'"
		
		forvalues i=1/3 {
		gen tstat`i'rain = beta`i'rain/se`i'rain
		gen pval`i'rain = 2*ttail(dfr,abs(tstat`i'rain))
		gen ci_lo`i'rain =  beta`i'rain - invttail(dfr,0.025)*se`i'rain
		gen ci_up`i'rain =  beta`i'rain + invttail(dfr,0.025)*se`i'rain
			
		gen tstat`i'temp = beta`i'temp/se`i'temp
		gen pval`i'temp = 2*ttail(dfr,abs(tstat`i'temp))
		gen ci_lo`i'temp =  beta`i'temp - invttail(dfr,0.025)*se`i'temp
		gen ci_up`i'temp =  beta`i'temp + invttail(dfr,0.025)*se`i'temp
		}
		
		
		save "`export'/myresults_`dat'_`ext'_`sat1'_`sat2'_combo.dta", replace
		
		}
	
clear all
*/
save "`results'/appended_lp_combo.dta", emptyok replace

loc fileList : dir "`export'" files "myresults_lp*_combo.dta" 
foreach file in `fileList'{
	append using "`export'/`file'" 
}
order sat* ext

*Create new ID variables
sort varname
gen aux_var = 23 if varname == "mean"
replace aux_var = 24 if varname == "mean+var"
replace aux_var = 25 if varname == "mean+var+skew"
replace aux_var = 26 if varname == "median"
replace aux_var = 27 if varname == "total"
replace aux_var = 28 if varname == "z-score"
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

sort sat2
egen aux_sat1 = group(sat2)
order aux_sat1, after(sat2)
lab define sat1	1 "Rainfall 1" ///
				2 "Rainfall 2" ///
				3 "Rainfall 3" ///
				4 "Rainfall 4" ///
				5 "Rainfall 5" ///
				6 "Rainfall 6"
lab values aux_sat1 sat1

sort sat1
egen aux_sat2 = group(sat1)
order aux_sat2, after(sat1)
lab define sat2	1 "Temperature 1" ///
				2 "Temperature 2" ///
				3 "Temperature 3" 
lab values aux_sat2 sat2

drop sat1 sat2
rename aux_sat1 sat1
rename aux_sat2 sat2
order sat1 sat2

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
egen aux_reg = group(regname)
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

save "`results'/appended_lp_combo.dta", replace

