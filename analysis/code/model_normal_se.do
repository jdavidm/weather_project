***Project: Nontradtional finance

*A)Set up locations and importing
*location pathes
*global location "C:\Users\jei9\Box Sync\ag-lenders\Chad\stata"
global location "C:\Users\chads\Box Sync\ag-lenders\Chad\stata"

clear
global datapath "$location\data"
global outpath "$location\out"
global dopath "$location\do"
global logpath "$location\log"
global timestamp = "${S_DATE}_${S_TIME}"
cap log close
global timestamp = subinstr(" $timestamp",":","_",.)
log using "$logpath\feedmill$timestamp.log", replace
set more off

use "C:\Users\chads\Box Sync\ag-lenders\Chad\stata\data\june\del2.dta",  ///
clear

xtset FARM_NUMBER year

*Set Control Variable 
global controls operators aoped org_sprop org_prtnr org_llc org_scorp org_ccorp ///
stanchion freestall cmbohsing milk2x milk3x milkotherx tot_acre av_num_cows

gen yr = year

capture erase "C:\Users\chads\Box Sync\ag-lenders\Chad\stata\data\FINAL\normalse_ap.dta"

tempname results
postfile `results' b_mlk_pr se_mlk_pr using ///
 "C:\Users\chads\Box Sync\ag-lenders\Chad\stata\data\FINAL\normalse_ap.dta", replace

*Milk Price

*(1)
quietly reg gdp_chg_ap_pcow ppi_mlk_pr ///
gdp_cost_finbin $controls if year >= 1994 & year <= 2018
post `results' (_b[ppi_mlk_pr]) (_se[ppi_mlk_pr])

*(2)
quietly reg gdp_chg_ap_pcow ppi_mlk_pr ///
gdp_cost_finbin year $controls if year >= 1994 & year <= 2018
post `results' (_b[ppi_mlk_pr]) (_se[ppi_mlk_pr])

*(3)
quietly xtreg gdp_chg_ap_pcow ppi_mlk_pr ///
gdp_cost_finbin year $controls if year >= 1994 & year <= 2018, fe
post `results' (_b[ppi_mlk_pr]) (_se[ppi_mlk_pr])

*(4)
quietly xtreg gdp_chg_ap_pcow ppi_mlk_pr ///
gdp_cost_finbin year post_2006 $controls if year >= 1994 & year <= 2018, fe
post `results' (_b[ppi_mlk_pr]) (_se[ppi_mlk_pr])

*(5)
quietly reg gdp_chg_ap_pcow ppi_mlk_pr ///
gdp_cost_usda $controls
post `results' (_b[ppi_mlk_pr]) (_se[ppi_mlk_pr])

*(6)
quietly reg gdp_chg_ap_pcow ppi_mlk_pr ///
gdp_cost_usda year $controls
post `results' (_b[ppi_mlk_pr]) (_se[ppi_mlk_pr])

*(7)
quietly xtreg gdp_chg_ap_pcow ppi_mlk_pr ///
gdp_cost_usda year $controls, fe
post `results' (_b[ppi_mlk_pr]) (_se[ppi_mlk_pr]) 

*(8)
quietly xtreg gdp_chg_ap_pcow ppi_mlk_pr ///
gdp_cost_usda year post_2006 $controls, fe
post `results' (_b[ppi_mlk_pr]) (_se[ppi_mlk_pr])

*(9)
quietly reg gdp_chg_ap_pcow ppi_mlk_pr ///
gdp_cost_dfbs $controls
post `results' (_b[ppi_mlk_pr]) (_se[ppi_mlk_pr]) 

*(10)
quietly reg gdp_chg_ap_pcow ppi_mlk_pr ///
gdp_cost_dfbs year $controls
post `results' (_b[ppi_mlk_pr]) (_se[ppi_mlk_pr])

*(11)
quietly xtreg gdp_chg_ap_pcow ppi_mlk_pr ///
gdp_cost_dfbs year $controls, fe
post `results' (_b[ppi_mlk_pr]) (_se[ppi_mlk_pr]) 

*(12)
quietly xtreg gdp_chg_ap_pcow ppi_mlk_pr ///
gdp_cost_dfbs year post_2006 $controls, fe
post `results' (_b[ppi_mlk_pr]) (_se[ppi_mlk_pr])

**************************** REDUCED FORM *************************************

*(13)
quietly reg gdp_chg_ap_pcow ppi_grmn_mlk_pr ///
gdp_cost_finbin $controls if year >= 1994 & year <= 2018
post `results' (_b[ppi_grmn_mlk_pr]) (_se[ppi_grmn_mlk_pr])

*(14)
quietly reg gdp_chg_ap_pcow ppi_grmn_mlk_pr ///
gdp_cost_finbin year $controls if year >= 1994 & year <= 2018
post `results' (_b[ppi_grmn_mlk_pr]) (_se[ppi_grmn_mlk_pr])

*(15)
quietly xtreg gdp_chg_ap_pcow ppi_grmn_mlk_pr ///
gdp_cost_finbin year $controls if year >= 1994 & year <= 2018, fe
post `results' (_b[ppi_grmn_mlk_pr]) (_se[ppi_grmn_mlk_pr]) 

*(16)
quietly xtreg gdp_chg_ap_pcow ppi_grmn_mlk_pr ///
gdp_cost_finbin year post_2006 $controls if year >= 1994 & year <= 2018, fe
post `results' (_b[ppi_grmn_mlk_pr]) (_se[ppi_grmn_mlk_pr])

*(17)
quietly reg gdp_chg_ap_pcow ppi_grmn_mlk_pr ///
gdp_cost_usda $controls
post `results' (_b[ppi_grmn_mlk_pr]) (_se[ppi_grmn_mlk_pr])

*(18)
quietly reg gdp_chg_ap_pcow ppi_grmn_mlk_pr ///
gdp_cost_usda year $controls
post `results' (_b[ppi_grmn_mlk_pr]) (_se[ppi_grmn_mlk_pr])

*(19)
quietly xtreg gdp_chg_ap_pcow ppi_grmn_mlk_pr ///
gdp_cost_usda year $controls, fe
post `results' (_b[ppi_grmn_mlk_pr]) (_se[ppi_grmn_mlk_pr])

*(20)
quietly xtreg gdp_chg_ap_pcow ppi_grmn_mlk_pr ///
gdp_cost_usda year post_2006 $controls, fe
post `results' (_b[ppi_grmn_mlk_pr]) (_se[ppi_grmn_mlk_pr])

*(21)
quietly reg gdp_chg_ap_pcow ppi_grmn_mlk_pr ///
gdp_cost_dfbs $controls
post `results' (_b[ppi_grmn_mlk_pr]) (_se[ppi_grmn_mlk_pr])

*(22)
quietly reg gdp_chg_ap_pcow ppi_grmn_mlk_pr ///
gdp_cost_dfbs year $controls
post `results' (_b[ppi_grmn_mlk_pr]) (_se[ppi_grmn_mlk_pr])

*(23)
quietly xtreg gdp_chg_ap_pcow ppi_grmn_mlk_pr ///
gdp_cost_dfbs year $controls, fe
post `results' (_b[ppi_grmn_mlk_pr]) (_se[ppi_grmn_mlk_pr]) 

*(24)
quietly xtreg gdp_chg_ap_pcow ppi_grmn_mlk_pr ///
gdp_cost_dfbs year post_2006 $controls, fe
post `results' (_b[ppi_grmn_mlk_pr]) (_se[ppi_grmn_mlk_pr]) 

*********************** IV ****************************************************

quietly xtreg ppi_mlk_pr ppi_grmn_mlk_pr gdp_cost_finbin $controls yr ///
if year >= 1994 & year <= 2018, fe
predict mlk_pr_finbin_hat

*(25)
quietly reg gdp_chg_ap_pcow mlk_pr_finbin_hat gdp_cost_finbin $controls yr ///
if year >= 1994 & year <= 2018
post `results' (_b[mlk_pr_finbin_hat]) (_se[mlk_pr_finbin_hat])

*(26)
quietly xtreg gdp_chg_ap_pcow mlk_pr_finbin_hat gdp_cost_finbin $controls yr ///
if year >= 1994 & year <= 2018, fe
post `results' (_b[mlk_pr_finbin_hat]) (_se[mlk_pr_finbin_hat])

quietly xtreg ppi_mlk_pr ppi_grmn_mlk_pr gdp_cost_usda $controls yr, fe
predict mlk_pr_usda_hat

*(27)
quietly reg gdp_chg_ap_pcow mlk_pr_usda_hat gdp_cost_usda $controls yr
post `results' (_b[mlk_pr_usda_hat]) (_se[mlk_pr_usda_hat])

*(28)
quietly xtreg gdp_chg_ap_pcow mlk_pr_usda_hat gdp_cost_usda $controls yr, fe
post `results' (_b[mlk_pr_usda_hat]) (_se[mlk_pr_usda_hat])

quietly xtreg ppi_mlk_pr ppi_grmn_mlk_pr gdp_cost_dfbs $controls yr, fe
predict mlk_pr_dfbs_hat

*(29)
quietly reg gdp_chg_ap_pcow mlk_pr_dfbs_hat gdp_cost_dfbs $controls yr
post `results' (_b[mlk_pr_dfbs_hat]) (_se[mlk_pr_dfbs_hat]) 

*(30)
quietly xtreg gdp_chg_ap_pcow mlk_pr_dfbs_hat gdp_cost_dfbs $controls yr, fe
post `results' (_b[mlk_pr_dfbs_hat]) (_se[mlk_pr_dfbs_hat])

***************************** MARGIN ******************************************

*(31) 
quietly reg gdp_chg_ap_pcow dmargin_finbin ///
dpr_yr_down_finbin dpr_2yr_down_finbin dpr_3yr_down_finbin dpr_4yr_down_finbin ///
dpr_yr_up_finbin dpr_2yr_up_finbin dpr_3yr_up_finbin dpr_4yr_up_finbin ///
$controls if year >= 1994 & year <= 2018
post `results' (_b[dmargin_finbin]) (_se[dmargin_finbin])

*(32)
quietly reg gdp_chg_ap_pcow dmargin_finbin year ///
dpr_yr_down_finbin dpr_2yr_down_finbin dpr_3yr_down_finbin dpr_4yr_down_finbin ///
dpr_yr_up_finbin dpr_2yr_up_finbin dpr_3yr_up_finbin dpr_4yr_up_finbin ///
$controls if year >= 1994 & year <= 2018
post `results' (_b[dmargin_finbin]) (_se[dmargin_finbin])

*(33)
quietly xtreg gdp_chg_ap_pcow dmargin_finbin year ///
dpr_yr_down_finbin dpr_2yr_down_finbin dpr_3yr_down_finbin dpr_4yr_down_finbin ///
dpr_yr_up_finbin dpr_2yr_up_finbin dpr_3yr_up_finbin dpr_4yr_up_finbin ///
$controls if year >= 1994 & year <= 2018, fe
post `results' (_b[dmargin_finbin]) (_se[dmargin_finbin])

*(34)
quietly xtreg gdp_chg_ap_pcow dmargin_finbin year post_2006 ///
dpr_yr_down_finbin dpr_2yr_down_finbin dpr_3yr_down_finbin dpr_4yr_down_finbin ///
dpr_yr_up_finbin dpr_2yr_up_finbin dpr_3yr_up_finbin dpr_4yr_up_finbin ///
$controls if year >= 1994 & year <= 2018, fe
post `results' (_b[dmargin_finbin]) (_se[dmargin_finbin]) 

*(35)
quietly reg gdp_chg_ap_pcow dmargin_usda ///
dpr_yr_down_usda dpr_2yr_down_usda dpr_3yr_down_usda dpr_4yr_down_usda ///
dpr_yr_up_usda dpr_2yr_up_usda dpr_3yr_up_usda dpr_4yr_up_usda $controls
post `results' (_b[dmargin_usda]) (_se[dmargin_usda])

*(36)
quietly reg gdp_chg_ap_pcow dmargin_usda year ///
dpr_yr_down_usda dpr_2yr_down_usda dpr_3yr_down_usda dpr_4yr_down_usda ///
dpr_yr_up_usda dpr_2yr_up_usda dpr_3yr_up_usda dpr_4yr_up_usda $controls
post `results' (_b[dmargin_usda]) (_se[dmargin_usda])

*(37)
quietly xtreg gdp_chg_ap_pcow dmargin_usda year ///
dpr_yr_down_usda dpr_2yr_down_usda dpr_3yr_down_usda dpr_4yr_down_usda ///
dpr_yr_up_usda dpr_2yr_up_usda dpr_3yr_up_usda dpr_4yr_up_usda $controls, fe
post `results' (_b[dmargin_usda]) (_se[dmargin_usda])

*(38)
quietly xtreg gdp_chg_ap_pcow dmargin_usda year post_2006 ///
dpr_yr_down_usda dpr_2yr_down_usda dpr_3yr_down_usda dpr_4yr_down_usda ///
dpr_yr_up_usda dpr_2yr_up_usda dpr_3yr_up_usda dpr_4yr_up_usda $controls, fe
post `results' (_b[dmargin_usda]) (_se[dmargin_usda]) 

*(39)
quietly reg gdp_chg_ap_pcow dmargin ///
dpr_yr_down dpr_2yr_down dpr_3yr_down dpr_4yr_down ///
dpr_yr_up dpr_2yr_up dpr_3yr_up dpr_4yr_up $controls
post `results' (_b[dmargin]) (_se[dmargin])

*(40)
quietly reg gdp_chg_ap_pcow dmargin year ///
dpr_yr_down dpr_2yr_down dpr_3yr_down dpr_4yr_down ///
dpr_yr_up dpr_2yr_up dpr_3yr_up dpr_4yr_up $controls
post `results' (_b[dmargin]) (_se[dmargin])

*(41)
quietly xtreg gdp_chg_ap_pcow dmargin year ///
dpr_yr_down dpr_2yr_down dpr_3yr_down dpr_4yr_down ///
dpr_yr_up dpr_2yr_up dpr_3yr_up dpr_4yr_up $controls, fe
post `results' (_b[dmargin]) (_se[dmargin])

*(42)
quietly xtreg gdp_chg_ap_pcow dmargin year post_2006 ///
dpr_yr_down dpr_2yr_down dpr_3yr_down dpr_4yr_down ///
dpr_yr_up dpr_2yr_up dpr_3yr_up dpr_4yr_up $controls, fe
post `results' (_b[dmargin]) (_se[dmargin])

*(43)
quietly reg gdp_chg_ap_pcow ddiff_mlk_pr_trnd ///
dpr_yr_down_diff dpr_2yr_down_diff dpr_3yr_down_diff dpr_4yr_down_diff ///
pr_yr_up_diff dpr_2yr_up_diff dpr_3yr_up_diff dpr_4yr_up_diff ///
$controls
post `results' (_b[ddiff_mlk_pr_trnd]) (_se[ddiff_mlk_pr_trnd])

*(44)
quietly reg gdp_chg_ap_pcow ddiff_mlk_pr_trnd ///
dpr_yr_down_diff dpr_2yr_down_diff dpr_3yr_down_diff dpr_4yr_down_diff ///
pr_yr_up_diff dpr_2yr_up_diff dpr_3yr_up_diff dpr_4yr_up_diff ///
$controls year
post `results' (_b[ddiff_mlk_pr_trnd]) (_se[ddiff_mlk_pr_trnd])

*(45)
quietly xtreg gdp_chg_ap_pcow ddiff_mlk_pr_trnd ///
dpr_yr_down_diff dpr_2yr_down_diff dpr_3yr_down_diff dpr_4yr_down_diff ///
pr_yr_up_diff dpr_2yr_up_diff dpr_3yr_up_diff dpr_4yr_up_diff ///
$controls year, fe
post `results' (_b[ddiff_mlk_pr_trnd]) (_se[ddiff_mlk_pr_trnd])

*(46)
quietly xtreg gdp_chg_ap_pcow ddiff_mlk_pr_trnd ///
dpr_yr_down_diff dpr_2yr_down_diff dpr_3yr_down_diff dpr_4yr_down_diff ///
pr_yr_up_diff dpr_2yr_up_diff dpr_3yr_up_diff dpr_4yr_up_diff ///
$controls year post_2006, fe
post `results' (_b[ddiff_mlk_pr_trnd]) (_se[ddiff_mlk_pr_trnd])

*(47)
quietly reg gdp_chg_ap_pcow dgmargin_finbin ///
dpr_yr_down_gfinbin dpr_2yr_down_gfinbin dpr_3yr_down_gfinbin dpr_4yr_down_gfinbin ///
dpr_yr_up_gfinbin dpr_2yr_up_gfinbin dpr_3yr_up_gfinbin dpr_4yr_up_gfinbin ///
$controls if year >= 1994 & year <= 2018
post `results' (_b[dgmargin_finbin]) (_se[dgmargin_finbin])

*(48)
quietly reg gdp_chg_ap_pcow dgmargin_finbin year ///
dpr_yr_down_gfinbin dpr_2yr_down_gfinbin dpr_3yr_down_gfinbin dpr_4yr_down_gfinbin ///
dpr_yr_up_gfinbin dpr_2yr_up_gfinbin dpr_3yr_up_gfinbin dpr_4yr_up_gfinbin ///
$controls if year >= 1994 & year <= 2018
post `results' (_b[dgmargin_finbin]) (_se[dgmargin_finbin])

*(49)
quietly xtreg gdp_chg_ap_pcow dgmargin_finbin year ///
dpr_yr_down_gfinbin dpr_2yr_down_gfinbin dpr_3yr_down_gfinbin dpr_4yr_down_gfinbin ///
dpr_yr_up_gfinbin dpr_2yr_up_gfinbin dpr_3yr_up_gfinbin dpr_4yr_up_gfinbin ///
$controls if year >= 1994 & year <= 2018, fe
post `results' (_b[dgmargin_finbin]) (_se[dgmargin_finbin])

*(50)
quietly xtreg gdp_chg_ap_pcow dgmargin_finbin year post_2006 ///
dpr_yr_down_gfinbin dpr_2yr_down_gfinbin dpr_3yr_down_gfinbin dpr_4yr_down_gfinbin ///
dpr_yr_up_gfinbin dpr_2yr_up_gfinbin dpr_3yr_up_gfinbin dpr_4yr_up_gfinbin ///
$controls if year >= 1994 & year <= 2018, fe
post `results' (_b[dgmargin_finbin]) (_se[dgmargin_finbin])

*(51) 
quietly reg gdp_chg_ap_pcow dgmargin_usda ///
dpr_yr_down_gusda dpr_2yr_down_gusda dpr_3yr_down_gusda dpr_4yr_down_gusda ///
dpr_yr_up_gusda dpr_2yr_up_gusda dpr_3yr_up_gusda dpr_4yr_up_gusda ///
$controls
post `results' (_b[dgmargin_usda]) (_se[dgmargin_usda])

*(52) 
quietly reg gdp_chg_ap_pcow dgmargin_usda ///
dpr_yr_down_gusda dpr_2yr_down_gusda dpr_3yr_down_gusda dpr_4yr_down_gusda ///
dpr_yr_up_gusda dpr_2yr_up_gusda dpr_3yr_up_gusda dpr_4yr_up_gusda ///
$controls year
post `results' (_b[dgmargin_usda]) (_se[dgmargin_usda]) 

*(53) 
quietly xtreg gdp_chg_ap_pcow dgmargin_usda ///
dpr_yr_down_gusda dpr_2yr_down_gusda dpr_3yr_down_gusda dpr_4yr_down_gusda ///
dpr_yr_up_gusda dpr_2yr_up_gusda dpr_3yr_up_gusda dpr_4yr_up_gusda ///
$controls year, fe
post `results' (_b[dgmargin_usda]) (_se[dgmargin_usda])   

*(54) 
quietly xtreg gdp_chg_ap_pcow dgmargin_usda ///
dpr_yr_down_gusda dpr_2yr_down_gusda dpr_3yr_down_gusda dpr_4yr_down_gusda ///
dpr_yr_up_gusda dpr_2yr_up_gusda dpr_3yr_up_gusda dpr_4yr_up_gusda ///
$controls year post_2006, fe
post `results' (_b[dgmargin_usda]) (_se[dgmargin_usda])  

*(55)
quietly reg gdp_chg_ap_pcow dgmargin_dfbs ///
dpr_yr_down_gdfbs dpr_2yr_down_gdfbs dpr_3yr_down_gdfbs dpr_4yr_down_gdfbs ///
dpr_yr_up_gdfbs dpr_2yr_up_gdfbs dpr_3yr_up_gdfbs dpr_4yr_up_gdfbs ///
$controls
post `results' (_b[dgmargin_dfbs]) (_se[dgmargin_dfbs])

*(56)
quietly reg gdp_chg_ap_pcow dgmargin_dfbs year ///
dpr_yr_down_gdfbs dpr_2yr_down_gdfbs dpr_3yr_down_gdfbs dpr_4yr_down_gdfbs ///
dpr_yr_up_gdfbs dpr_2yr_up_gdfbs dpr_3yr_up_gdfbs dpr_4yr_up_gdfbs ///
$controls
post `results' (_b[dgmargin_dfbs]) (_se[dgmargin_dfbs])

*(57)
quietly xtreg gdp_chg_ap_pcow dgmargin_dfbs year ///
dpr_yr_down_gdfbs dpr_2yr_down_gdfbs dpr_3yr_down_gdfbs dpr_4yr_down_gdfbs ///
dpr_yr_up_gdfbs dpr_2yr_up_gdfbs dpr_3yr_up_gdfbs dpr_4yr_up_gdfbs ///
$controls, fe
post `results' (_b[dgmargin_dfbs]) (_se[dgmargin_dfbs])

*(58)
quietly xtreg gdp_chg_ap_pcow dgmargin_dfbs year post_2006 ///
dpr_yr_down_gdfbs dpr_2yr_down_gdfbs dpr_3yr_down_gdfbs dpr_4yr_down_gdfbs ///
dpr_yr_up_gdfbs dpr_2yr_up_gdfbs dpr_3yr_up_gdfbs dpr_4yr_up_gdfbs ///
$controls, fe
post `results' (_b[dgmargin_dfbs]) (_se[dgmargin_dfbs]) 

*(59)
quietly reg gdp_chg_ap_pcow ddiff_gmlk_pr_trnd ///
dpr_yr_down_gdiff dpr_2yr_down_gdiff dpr_3yr_down_gdiff dpr_4yr_down_gdiff ///
dpr_yr_up_gdiff dpr_2yr_up_gdiff dpr_3yr_up_gdiff dpr_4yr_up_gdiff ///
$controls
post `results' (_b[ddiff_gmlk_pr_trnd]) (_se[ddiff_gmlk_pr_trnd])

*(60)
quietly reg gdp_chg_ap_pcow ddiff_gmlk_pr_trnd year ///
dpr_yr_down_gdiff dpr_2yr_down_gdiff dpr_3yr_down_gdiff dpr_4yr_down_gdiff ///
dpr_yr_up_gdiff dpr_2yr_up_gdiff dpr_3yr_up_gdiff dpr_4yr_up_gdiff ///
$controls
post `results' (_b[ddiff_gmlk_pr_trnd]) (_se[ddiff_gmlk_pr_trnd])

*(61)
quietly xtreg gdp_chg_ap_pcow ddiff_gmlk_pr_trnd year ///
dpr_yr_down_gdiff dpr_2yr_down_gdiff dpr_3yr_down_gdiff dpr_4yr_down_gdiff ///
dpr_yr_up_gdiff dpr_2yr_up_gdiff dpr_3yr_up_gdiff dpr_4yr_up_gdiff ///
$controls, fe
post `results' (_b[ddiff_gmlk_pr_trnd]) (_se[ddiff_gmlk_pr_trnd])

*(62)
quietly xtreg gdp_chg_ap_pcow ddiff_gmlk_pr_trnd year post_2006 ///
dpr_yr_down_gdiff dpr_2yr_down_gdiff dpr_3yr_down_gdiff dpr_4yr_down_gdiff ///
dpr_yr_up_gdiff dpr_2yr_up_gdiff dpr_3yr_up_gdiff dpr_4yr_up_gdiff ///
$controls, fe
post `results' (_b[ddiff_gmlk_pr_trnd]) (_se[ddiff_gmlk_pr_trnd])


*(63)
quietly reg gdp_chg_ap_pcow dcum_margin ///
$controls
post `results' (_b[dcum_margin]) (_se[dcum_margin])

*(64)
quietly reg gdp_chg_ap_pcow dcum_margin year ///
$controls
post `results' (_b[dcum_margin]) (_se[dcum_margin])
*outreg2 using "$outpath\MARCH\results_big.xls", excel  

*(65)
quietly xtreg gdp_chg_ap_pcow dcum_margin year ///
$controls, fe
post `results' (_b[dcum_margin]) (_se[dcum_margin])
*outreg2 using "$outpath\MARCH\results_big.xls", excel  

*(66)
quietly xtreg gdp_chg_ap_pcow dcum_margin year post_2006 ///
$controls, fe
post `results' (_b[dcum_margin]) (_se[dcum_margin])
*outreg2 using "$outpath\MARCH\results_big.xls", excel  

*(67)
quietly reg gdp_chg_ap_pcow dcum_margin_fbn ///
$controls if year >= 2006 & year <= 2018
post `results' (_b[dcum_margin_fbn]) (_se[dcum_margin_fbn])

*(68)
quietly reg gdp_chg_ap_pcow dcum_margin_fbn year ///
$controls if year >= 2006 & year <= 2018
post `results' (_b[dcum_margin_fbn]) (_se[dcum_margin_fbn])

*(69)
quietly xtreg gdp_chg_ap_pcow dcum_margin_fbn year ///
$controls if year >= 2006 & year <= 2018, fe
post `results' (_b[dcum_margin_fbn]) (_se[dcum_margin_fbn])

*(70)
quietly xtreg gdp_chg_ap_pcow dcum_margin_fbn year post_2006 ///
$controls if year >= 2006 & year <= 2018, fe
post `results' (_b[dcum_margin_fbn]) (_se[dcum_margin_fbn])

******************************** OP *******************************************
*******************************************************************************
*******************************************************************************

*Milk Price

*(71)
quietly reg gdp_chg_op_pcow ppi_mlk_pr ///
gdp_cost_finbin $controls if year >= 1994 & year <= 2018
post `results' (_b[ppi_mlk_pr]) (_se[ppi_mlk_pr])

*(72)
quietly reg gdp_chg_op_pcow ppi_mlk_pr ///
gdp_cost_finbin year $controls if year >= 1994 & year <= 2018
post `results' (_b[ppi_mlk_pr]) (_se[ppi_mlk_pr])

*(73)
quietly xtreg gdp_chg_op_pcow ppi_mlk_pr ///
gdp_cost_finbin year $controls if year >= 1994 & year <= 2018, fe
post `results' (_b[ppi_mlk_pr]) (_se[ppi_mlk_pr])

*(74)
quietly xtreg gdp_chg_op_pcow ppi_mlk_pr ///
gdp_cost_finbin year post_2006 $controls if year >= 1994 & year <= 2018, fe
post `results' (_b[ppi_mlk_pr]) (_se[ppi_mlk_pr])

*(75)
quietly reg gdp_chg_op_pcow ppi_mlk_pr ///
gdp_cost_usda $controls
post `results' (_b[ppi_mlk_pr]) (_se[ppi_mlk_pr])

*(76)
quietly reg gdp_chg_op_pcow ppi_mlk_pr ///
gdp_cost_usda year $controls
post `results' (_b[ppi_mlk_pr]) (_se[ppi_mlk_pr])

*(77)
quietly xtreg gdp_chg_op_pcow ppi_mlk_pr ///
gdp_cost_usda year $controls, fe
post `results' (_b[ppi_mlk_pr]) (_se[ppi_mlk_pr]) 

*(78)
quietly xtreg gdp_chg_op_pcow ppi_mlk_pr ///
gdp_cost_usda year post_2006 $controls, fe
post `results' (_b[ppi_mlk_pr]) (_se[ppi_mlk_pr])

*(79)
quietly reg gdp_chg_op_pcow ppi_mlk_pr ///
gdp_cost_dfbs $controls
post `results' (_b[ppi_mlk_pr]) (_se[ppi_mlk_pr]) 

*(80)
quietly reg gdp_chg_op_pcow ppi_mlk_pr ///
gdp_cost_dfbs year $controls
post `results' (_b[ppi_mlk_pr]) (_se[ppi_mlk_pr])

*(81)
quietly xtreg gdp_chg_op_pcow ppi_mlk_pr ///
gdp_cost_dfbs year $controls, fe
post `results' (_b[ppi_mlk_pr]) (_se[ppi_mlk_pr]) 

*(82)
quietly xtreg gdp_chg_op_pcow ppi_mlk_pr ///
gdp_cost_dfbs year post_2006 $controls, fe
post `results' (_b[ppi_mlk_pr]) (_se[ppi_mlk_pr])

**************************** REDUCED FORM *************************************

*(83)
quietly reg gdp_chg_op_pcow ppi_grmn_mlk_pr ///
gdp_cost_finbin $controls if year >= 1994 & year <= 2018
post `results' (_b[ppi_grmn_mlk_pr]) (_se[ppi_grmn_mlk_pr])

*(84)
quietly reg gdp_chg_op_pcow ppi_grmn_mlk_pr ///
gdp_cost_finbin year $controls if year >= 1994 & year <= 2018
post `results' (_b[ppi_grmn_mlk_pr]) (_se[ppi_grmn_mlk_pr])

*(85)
quietly xtreg gdp_chg_op_pcow ppi_grmn_mlk_pr ///
gdp_cost_finbin year $controls if year >= 1994 & year <= 2018, fe
post `results' (_b[ppi_grmn_mlk_pr]) (_se[ppi_grmn_mlk_pr]) 

*(86)
quietly xtreg gdp_chg_op_pcow ppi_grmn_mlk_pr ///
gdp_cost_finbin year post_2006 $controls if year >= 1994 & year <= 2018, fe
post `results' (_b[ppi_grmn_mlk_pr]) (_se[ppi_grmn_mlk_pr])

*(87)
quietly reg gdp_chg_op_pcow ppi_grmn_mlk_pr ///
gdp_cost_usda $controls
post `results' (_b[ppi_grmn_mlk_pr]) (_se[ppi_grmn_mlk_pr])

*(88)
quietly reg gdp_chg_op_pcow ppi_grmn_mlk_pr ///
gdp_cost_usda year $controls
post `results' (_b[ppi_grmn_mlk_pr]) (_se[ppi_grmn_mlk_pr])

*(89)
quietly xtreg gdp_chg_op_pcow ppi_grmn_mlk_pr ///
gdp_cost_usda year $controls, fe
post `results' (_b[ppi_grmn_mlk_pr]) (_se[ppi_grmn_mlk_pr])

*(90)
quietly xtreg gdp_chg_op_pcow ppi_grmn_mlk_pr ///
gdp_cost_usda year post_2006 $controls, fe
post `results' (_b[ppi_grmn_mlk_pr]) (_se[ppi_grmn_mlk_pr])

*(91)
quietly reg gdp_chg_op_pcow ppi_grmn_mlk_pr ///
gdp_cost_dfbs $controls
post `results' (_b[ppi_grmn_mlk_pr]) (_se[ppi_grmn_mlk_pr])

*(92)
quietly reg gdp_chg_op_pcow ppi_grmn_mlk_pr ///
gdp_cost_dfbs year $controls
post `results' (_b[ppi_grmn_mlk_pr]) (_se[ppi_grmn_mlk_pr])

*(93)
quietly xtreg gdp_chg_op_pcow ppi_grmn_mlk_pr ///
gdp_cost_dfbs year $controls, fe
post `results' (_b[ppi_grmn_mlk_pr]) (_se[ppi_grmn_mlk_pr]) 

*(94)
quietly xtreg gdp_chg_op_pcow ppi_grmn_mlk_pr ///
gdp_cost_dfbs year post_2006 $controls, fe
post `results' (_b[ppi_grmn_mlk_pr]) (_se[ppi_grmn_mlk_pr]) 

*********************** IV ****************************************************

*quietly xtreg ppi_mlk_pr ppi_grmn_mlk_pr gdp_cost_finbin $controls yr ///
*if year >= 1994 & year <= 2018, fe
*predict mlk_pr_finbin_hat

*(95)
quietly reg gdp_chg_op_pcow mlk_pr_finbin_hat gdp_cost_finbin $controls yr ///
if year >= 1994 & year <= 2018
post `results' (_b[mlk_pr_finbin_hat]) (_se[mlk_pr_finbin_hat])

*(96)
quietly xtreg gdp_chg_op_pcow mlk_pr_finbin_hat gdp_cost_finbin $controls yr ///
if year >= 1994 & year <= 2018, fe
post `results' (_b[mlk_pr_finbin_hat]) (_se[mlk_pr_finbin_hat])

*quietly xtreg ppi_mlk_pr ppi_grmn_mlk_pr gdp_cost_usda $controls yr, fe
*predict mlk_pr_usda_hat

*(97)
quietly reg gdp_chg_op_pcow mlk_pr_usda_hat gdp_cost_usda $controls yr
post `results' (_b[mlk_pr_usda_hat]) (_se[mlk_pr_usda_hat])

*(98)
quietly xtreg gdp_chg_op_pcow mlk_pr_usda_hat gdp_cost_usda $controls yr, fe
post `results' (_b[mlk_pr_usda_hat]) (_se[mlk_pr_usda_hat])

*quietly xtreg ppi_mlk_pr ppi_grmn_mlk_pr gdp_cost_dfbs $controls yr, fe
*predict mlk_pr_dfbs_hat

*(99)
quietly reg gdp_chg_op_pcow mlk_pr_dfbs_hat gdp_cost_dfbs $controls yr
post `results' (_b[mlk_pr_dfbs_hat]) (_se[mlk_pr_dfbs_hat]) 

*(100)
quietly xtreg gdp_chg_op_pcow mlk_pr_dfbs_hat gdp_cost_dfbs $controls yr, fe
post `results' (_b[mlk_pr_dfbs_hat]) (_se[mlk_pr_dfbs_hat])

***************************** MARGIN ******************************************

*(101) 
quietly reg gdp_chg_op_pcow dmargin_finbin ///
dpr_yr_down_finbin dpr_2yr_down_finbin dpr_3yr_down_finbin dpr_4yr_down_finbin ///
dpr_yr_up_finbin dpr_2yr_up_finbin dpr_3yr_up_finbin dpr_4yr_up_finbin ///
$controls if year >= 1994 & year <= 2018
post `results' (_b[dmargin_finbin]) (_se[dmargin_finbin])

*(102)
quietly reg gdp_chg_op_pcow dmargin_finbin year ///
dpr_yr_down_finbin dpr_2yr_down_finbin dpr_3yr_down_finbin dpr_4yr_down_finbin ///
dpr_yr_up_finbin dpr_2yr_up_finbin dpr_3yr_up_finbin dpr_4yr_up_finbin ///
$controls if year >= 1994 & year <= 2018
post `results' (_b[dmargin_finbin]) (_se[dmargin_finbin])

*(103)
quietly xtreg gdp_chg_op_pcow dmargin_finbin year ///
dpr_yr_down_finbin dpr_2yr_down_finbin dpr_3yr_down_finbin dpr_4yr_down_finbin ///
dpr_yr_up_finbin dpr_2yr_up_finbin dpr_3yr_up_finbin dpr_4yr_up_finbin ///
$controls if year >= 1994 & year <= 2018, fe
post `results' (_b[dmargin_finbin]) (_se[dmargin_finbin])

*(104)
quietly xtreg gdp_chg_op_pcow dmargin_finbin year post_2006 ///
dpr_yr_down_finbin dpr_2yr_down_finbin dpr_3yr_down_finbin dpr_4yr_down_finbin ///
dpr_yr_up_finbin dpr_2yr_up_finbin dpr_3yr_up_finbin dpr_4yr_up_finbin ///
$controls if year >= 1994 & year <= 2018, fe
post `results' (_b[dmargin_finbin]) (_se[dmargin_finbin]) 

*(105)
quietly reg gdp_chg_op_pcow dmargin_usda ///
dpr_yr_down_usda dpr_2yr_down_usda dpr_3yr_down_usda dpr_4yr_down_usda ///
dpr_yr_up_usda dpr_2yr_up_usda dpr_3yr_up_usda dpr_4yr_up_usda $controls
post `results' (_b[dmargin_usda]) (_se[dmargin_usda])

*(106)
quietly reg gdp_chg_op_pcow dmargin_usda year ///
dpr_yr_down_usda dpr_2yr_down_usda dpr_3yr_down_usda dpr_4yr_down_usda ///
dpr_yr_up_usda dpr_2yr_up_usda dpr_3yr_up_usda dpr_4yr_up_usda $controls
post `results' (_b[dmargin_usda]) (_se[dmargin_usda])

*(107)
quietly xtreg gdp_chg_op_pcow dmargin_usda year ///
dpr_yr_down_usda dpr_2yr_down_usda dpr_3yr_down_usda dpr_4yr_down_usda ///
dpr_yr_up_usda dpr_2yr_up_usda dpr_3yr_up_usda dpr_4yr_up_usda $controls, fe
post `results' (_b[dmargin_usda]) (_se[dmargin_usda])

*(108)
quietly xtreg gdp_chg_op_pcow dmargin_usda year post_2006 ///
dpr_yr_down_usda dpr_2yr_down_usda dpr_3yr_down_usda dpr_4yr_down_usda ///
dpr_yr_up_usda dpr_2yr_up_usda dpr_3yr_up_usda dpr_4yr_up_usda $controls, fe
post `results' (_b[dmargin_usda]) (_se[dmargin_usda]) 

*(109)
quietly reg gdp_chg_op_pcow dmargin ///
dpr_yr_down dpr_2yr_down dpr_3yr_down dpr_4yr_down ///
dpr_yr_up dpr_2yr_up dpr_3yr_up dpr_4yr_up $controls
post `results' (_b[dmargin]) (_se[dmargin])

*(110)
quietly reg gdp_chg_op_pcow dmargin year ///
dpr_yr_down dpr_2yr_down dpr_3yr_down dpr_4yr_down ///
dpr_yr_up dpr_2yr_up dpr_3yr_up dpr_4yr_up $controls
post `results' (_b[dmargin]) (_se[dmargin])

*(111)
quietly xtreg gdp_chg_op_pcow dmargin year ///
dpr_yr_down dpr_2yr_down dpr_3yr_down dpr_4yr_down ///
dpr_yr_up dpr_2yr_up dpr_3yr_up dpr_4yr_up $controls, fe
post `results' (_b[dmargin]) (_se[dmargin])

*(112)
quietly xtreg gdp_chg_op_pcow dmargin year post_2006 ///
dpr_yr_down dpr_2yr_down dpr_3yr_down dpr_4yr_down ///
dpr_yr_up dpr_2yr_up dpr_3yr_up dpr_4yr_up $controls, fe
post `results' (_b[dmargin]) (_se[dmargin])

*(113)
quietly reg gdp_chg_op_pcow ddiff_mlk_pr_trnd ///
dpr_yr_down_diff dpr_2yr_down_diff dpr_3yr_down_diff dpr_4yr_down_diff ///
pr_yr_up_diff dpr_2yr_up_diff dpr_3yr_up_diff dpr_4yr_up_diff ///
$controls
post `results' (_b[ddiff_mlk_pr_trnd]) (_se[ddiff_mlk_pr_trnd])

*(114)
quietly reg gdp_chg_op_pcow ddiff_mlk_pr_trnd ///
dpr_yr_down_diff dpr_2yr_down_diff dpr_3yr_down_diff dpr_4yr_down_diff ///
pr_yr_up_diff dpr_2yr_up_diff dpr_3yr_up_diff dpr_4yr_up_diff ///
$controls year
post `results' (_b[ddiff_mlk_pr_trnd]) (_se[ddiff_mlk_pr_trnd])

*(115)
quietly xtreg gdp_chg_op_pcow ddiff_mlk_pr_trnd ///
dpr_yr_down_diff dpr_2yr_down_diff dpr_3yr_down_diff dpr_4yr_down_diff ///
pr_yr_up_diff dpr_2yr_up_diff dpr_3yr_up_diff dpr_4yr_up_diff ///
$controls year, fe
post `results' (_b[ddiff_mlk_pr_trnd]) (_se[ddiff_mlk_pr_trnd])

*(116)
quietly xtreg gdp_chg_op_pcow ddiff_mlk_pr_trnd ///
dpr_yr_down_diff dpr_2yr_down_diff dpr_3yr_down_diff dpr_4yr_down_diff ///
pr_yr_up_diff dpr_2yr_up_diff dpr_3yr_up_diff dpr_4yr_up_diff ///
$controls year post_2006, fe
post `results' (_b[ddiff_mlk_pr_trnd]) (_se[ddiff_mlk_pr_trnd])

*(117)
quietly reg gdp_chg_op_pcow dgmargin_finbin ///
dpr_yr_down_gfinbin dpr_2yr_down_gfinbin dpr_3yr_down_gfinbin dpr_4yr_down_gfinbin ///
dpr_yr_up_gfinbin dpr_2yr_up_gfinbin dpr_3yr_up_gfinbin dpr_4yr_up_gfinbin ///
$controls if year >= 1994 & year <= 2018
post `results' (_b[dgmargin_finbin]) (_se[dgmargin_finbin])

*(118)
quietly reg gdp_chg_op_pcow dgmargin_finbin year ///
dpr_yr_down_gfinbin dpr_2yr_down_gfinbin dpr_3yr_down_gfinbin dpr_4yr_down_gfinbin ///
dpr_yr_up_gfinbin dpr_2yr_up_gfinbin dpr_3yr_up_gfinbin dpr_4yr_up_gfinbin ///
$controls if year >= 1994 & year <= 2018
post `results' (_b[dgmargin_finbin]) (_se[dgmargin_finbin])

*(119)
quietly xtreg gdp_chg_op_pcow dgmargin_finbin year ///
dpr_yr_down_gfinbin dpr_2yr_down_gfinbin dpr_3yr_down_gfinbin dpr_4yr_down_gfinbin ///
dpr_yr_up_gfinbin dpr_2yr_up_gfinbin dpr_3yr_up_gfinbin dpr_4yr_up_gfinbin ///
$controls if year >= 1994 & year <= 2018, fe
post `results' (_b[dgmargin_finbin]) (_se[dgmargin_finbin])

*(120)
quietly xtreg gdp_chg_op_pcow dgmargin_finbin year post_2006 ///
dpr_yr_down_gfinbin dpr_2yr_down_gfinbin dpr_3yr_down_gfinbin dpr_4yr_down_gfinbin ///
dpr_yr_up_gfinbin dpr_2yr_up_gfinbin dpr_3yr_up_gfinbin dpr_4yr_up_gfinbin ///
$controls if year >= 1994 & year <= 2018, fe
post `results' (_b[dgmargin_finbin]) (_se[dgmargin_finbin])

*(121) 
quietly reg gdp_chg_op_pcow dgmargin_usda ///
dpr_yr_down_gusda dpr_2yr_down_gusda dpr_3yr_down_gusda dpr_4yr_down_gusda ///
dpr_yr_up_gusda dpr_2yr_up_gusda dpr_3yr_up_gusda dpr_4yr_up_gusda ///
$controls
post `results' (_b[dgmargin_usda]) (_se[dgmargin_usda])

*(122) 
quietly reg gdp_chg_op_pcow dgmargin_usda ///
dpr_yr_down_gusda dpr_2yr_down_gusda dpr_3yr_down_gusda dpr_4yr_down_gusda ///
dpr_yr_up_gusda dpr_2yr_up_gusda dpr_3yr_up_gusda dpr_4yr_up_gusda ///
$controls year
post `results' (_b[dgmargin_usda]) (_se[dgmargin_usda]) 

*(123) 
quietly xtreg gdp_chg_op_pcow dgmargin_usda ///
dpr_yr_down_gusda dpr_2yr_down_gusda dpr_3yr_down_gusda dpr_4yr_down_gusda ///
dpr_yr_up_gusda dpr_2yr_up_gusda dpr_3yr_up_gusda dpr_4yr_up_gusda ///
$controls year, fe
post `results' (_b[dgmargin_usda]) (_se[dgmargin_usda])   

*(124) 
quietly xtreg gdp_chg_op_pcow dgmargin_usda ///
dpr_yr_down_gusda dpr_2yr_down_gusda dpr_3yr_down_gusda dpr_4yr_down_gusda ///
dpr_yr_up_gusda dpr_2yr_up_gusda dpr_3yr_up_gusda dpr_4yr_up_gusda ///
$controls year post_2006, fe
post `results' (_b[dgmargin_usda]) (_se[dgmargin_usda])  

*(125)
quietly reg gdp_chg_op_pcow dgmargin_dfbs ///
dpr_yr_down_gdfbs dpr_2yr_down_gdfbs dpr_3yr_down_gdfbs dpr_4yr_down_gdfbs ///
dpr_yr_up_gdfbs dpr_2yr_up_gdfbs dpr_3yr_up_gdfbs dpr_4yr_up_gdfbs ///
$controls
post `results' (_b[dgmargin_dfbs]) (_se[dgmargin_dfbs])

*(126)
quietly reg gdp_chg_op_pcow dgmargin_dfbs year ///
dpr_yr_down_gdfbs dpr_2yr_down_gdfbs dpr_3yr_down_gdfbs dpr_4yr_down_gdfbs ///
dpr_yr_up_gdfbs dpr_2yr_up_gdfbs dpr_3yr_up_gdfbs dpr_4yr_up_gdfbs ///
$controls
post `results' (_b[dgmargin_dfbs]) (_se[dgmargin_dfbs])

*(127)
quietly xtreg gdp_chg_op_pcow dgmargin_dfbs year ///
dpr_yr_down_gdfbs dpr_2yr_down_gdfbs dpr_3yr_down_gdfbs dpr_4yr_down_gdfbs ///
dpr_yr_up_gdfbs dpr_2yr_up_gdfbs dpr_3yr_up_gdfbs dpr_4yr_up_gdfbs ///
$controls, fe
post `results' (_b[dgmargin_dfbs]) (_se[dgmargin_dfbs])

*(128)
quietly xtreg gdp_chg_op_pcow dgmargin_dfbs year post_2006 ///
dpr_yr_down_gdfbs dpr_2yr_down_gdfbs dpr_3yr_down_gdfbs dpr_4yr_down_gdfbs ///
dpr_yr_up_gdfbs dpr_2yr_up_gdfbs dpr_3yr_up_gdfbs dpr_4yr_up_gdfbs ///
$controls, fe
post `results' (_b[dgmargin_dfbs]) (_se[dgmargin_dfbs]) 

*(129)
quietly reg gdp_chg_op_pcow ddiff_gmlk_pr_trnd ///
dpr_yr_down_gdiff dpr_2yr_down_gdiff dpr_3yr_down_gdiff dpr_4yr_down_gdiff ///
dpr_yr_up_gdiff dpr_2yr_up_gdiff dpr_3yr_up_gdiff dpr_4yr_up_gdiff ///
$controls
post `results' (_b[ddiff_gmlk_pr_trnd]) (_se[ddiff_gmlk_pr_trnd])

*(130)
quietly reg gdp_chg_op_pcow ddiff_gmlk_pr_trnd year ///
dpr_yr_down_gdiff dpr_2yr_down_gdiff dpr_3yr_down_gdiff dpr_4yr_down_gdiff ///
dpr_yr_up_gdiff dpr_2yr_up_gdiff dpr_3yr_up_gdiff dpr_4yr_up_gdiff ///
$controls
post `results' (_b[ddiff_gmlk_pr_trnd]) (_se[ddiff_gmlk_pr_trnd])

*(131)
quietly xtreg gdp_chg_op_pcow ddiff_gmlk_pr_trnd year ///
dpr_yr_down_gdiff dpr_2yr_down_gdiff dpr_3yr_down_gdiff dpr_4yr_down_gdiff ///
dpr_yr_up_gdiff dpr_2yr_up_gdiff dpr_3yr_up_gdiff dpr_4yr_up_gdiff ///
$controls, fe
post `results' (_b[ddiff_gmlk_pr_trnd]) (_se[ddiff_gmlk_pr_trnd])

*(132)
quietly xtreg gdp_chg_op_pcow ddiff_gmlk_pr_trnd year post_2006 ///
dpr_yr_down_gdiff dpr_2yr_down_gdiff dpr_3yr_down_gdiff dpr_4yr_down_gdiff ///
dpr_yr_up_gdiff dpr_2yr_up_gdiff dpr_3yr_up_gdiff dpr_4yr_up_gdiff ///
$controls, fe
post `results' (_b[ddiff_gmlk_pr_trnd]) (_se[ddiff_gmlk_pr_trnd])


*(133)
quietly reg gdp_chg_op_pcow dcum_margin ///
$controls
post `results' (_b[dcum_margin]) (_se[dcum_margin])

*(134)
quietly reg gdp_chg_op_pcow dcum_margin year ///
$controls
post `results' (_b[dcum_margin]) (_se[dcum_margin])
*outreg2 using "$outpath\MARCH\results_big.xls", excel  

*(135)
quietly xtreg gdp_chg_op_pcow dcum_margin year ///
$controls, fe
post `results' (_b[dcum_margin]) (_se[dcum_margin])
*outreg2 using "$outpath\MARCH\results_big.xls", excel  

*(136)
quietly xtreg gdp_chg_op_pcow dcum_margin year post_2006 ///
$controls, fe
post `results' (_b[dcum_margin]) (_se[dcum_margin])
*outreg2 using "$outpath\MARCH\results_big.xls", excel  

*(137)
quietly reg gdp_chg_op_pcow dcum_margin_fbn ///
$controls if year >= 2006 & year <= 2018
post `results' (_b[dcum_margin_fbn]) (_se[dcum_margin_fbn])

*(138)
quietly reg gdp_chg_op_pcow dcum_margin_fbn year ///
$controls if year >= 2006 & year <= 2018
post `results' (_b[dcum_margin_fbn]) (_se[dcum_margin_fbn])

*(139)
quietly xtreg gdp_chg_op_pcow dcum_margin_fbn year ///
$controls if year >= 2006 & year <= 2018, fe
post `results' (_b[dcum_margin_fbn]) (_se[dcum_margin_fbn])

*(140)
quietly xtreg gdp_chg_op_pcow dcum_margin_fbn year post_2006 ///
$controls if year >= 2006 & year <= 2018, fe
post `results' (_b[dcum_margin_fbn]) (_se[dcum_margin_fbn])

postclose `results'

use "C:\Users\chads\Box Sync\ag-lenders\Chad\stata\data\FINAL\normalse_ap.dta", clear

gen obs = _n
gen obs2 = 0
replace obs2 = 2.5+obs if obs <=70
replace obs2 = 5+obs if obs > 70
gen obs3 = obs2/147.5

serrbar b_mlk_pr se_mlk_pr obs3, xline(.5) yline(0) ///
title("Dairy Business Cycle Model Coefficients") ///
subtitle("Accounts Payable                        Operating Credit") ///
ytitle("USD per cow") ///
xscale(off) caption(70 Model Estimates for Change in Accounts Payable and Operating Credit) 
graph save "$outpath\FINAL\dmodel_scatter.gph", replace
graph export "$outpath\FINAL\dmodel_scatter.png", replace width(6000) height(4000)

gen model = 0
replace model = 1 if obs <= 70
replace model = 2 if obs > 70

gen obs_sorted = 0
replace obs_sorted = 5+obs if obs <=70
replace obs_sorted = 15+obs if obs > 70
gen obs_sorted2 = obs_sorted/160

serrbar b_mlk_pr se_mlk_pr obs_sorted2, scale (1.96) xline(.5) yline(0) ///
title("Dairy Business Cycle Model Coefficients") ///
subtitle("Accounts Payable           95% CI             Operating Credit") ///
ytitle("USD per cow") ///
xscale(off) caption(70 Model Estimates for Change in Accounts Payable and Operating Credit)
graph save "$outpath\FINAL\dsorted_est95.gph", replace
graph export "$outpath\FINAL\dsorted_est95.png", replace width(6000) height(4000) 

serrbar b_mlk_pr se_mlk_pr obs_sorted2, scale (2.576) xline(.5) yline(0) ///
title("Dairy Business Cycle Model Coefficients") ///
subtitle("Accounts Payable           99% CI            Operating Credit") ///
ytitle("USD per cow") ///
xscale(off) caption(70 Model Estimates for Change in Accounts Payable and Operating Credit)
graph save "$outpath\FINAL\dsorted_est99.gph", replace
graph export "$outpath\FINAL\dsorted_est99.png", replace width(6000) height(4000)

serrbar b_mlk_pr se_mlk_pr obs_sorted2, scale (1.65) xline(.5) yline(0) ///
title("Dairy Business Cycle Model Coefficients") ///
subtitle("Accounts Payable           90% CI            Operating Credit") ///
ytitle("USD per cow") ///
xscale(off) caption(70 Model Estimates for Change in Accounts Payable and Operating Credit)
graph save "$outpath\FINAL\dsorted_est90.gph", replace
graph export "$outpath\FINAL\dsorted_est90.png", replace width(6000) height(4000)

clear
use "C:\Users\chads\Box Sync\ag-lenders\Chad\stata\data\MARCH\results_ap.dta", clear

gen model = 0
replace model = 1 if _n <= 12
replace model = 2 if _n > 12 & _n <= 24
replace model = 3 if _n > 24 & _n <= 30
replace model = 4 if _n > 30 & _n <= 46
replace model = 5 if _n > 46 & _n <= 62
replace model = 6 if _n > 62 & _n <= 70
replace model = 1 if _n > 70 & _n <= 82
replace model = 2 if _n > 82 & _n <= 94
replace model = 3 if _n > 94 & _n <= 100
replace model = 4 if _n > 100 & _n <= 116
replace model = 5 if _n > 116 & _n <= 132
replace model = 6 if _n > 132 & _n <= 140

gen milk_pr = 1

gen obs = _n
 
label define model 1 "Milk Price" 2 "Reduced Form" 3 "IV" 4 "Milk Price Margin" ///
5 "German Price Margin" 6 "Cumulative Margin" 

*ALL MILK PRICE
serrbar b_mlk_pr se_mlk_pr obs if model == 1

*GERMAN MILK PRICE
serrbar b_mlk_pr se_mlk_pr obs if model == 2

*IV
serrbar b_mlk_pr se_mlk_pr obs if model == 3

*MILK PRICE MARGIN
serrbar b_mlk_pr se_mlk_pr obs if model == 4

*GERMAN MILK PRICE MARGIN
serrbar b_mlk_pr se_mlk_pr obs if model == 5

*CUMULATIVE MARGIN 
serrbar b_mlk_pr se_mlk_pr obs if model == 6

serrbar b_mlk_pr se_mlk_pr obs if obs == 4 | obs == 74 | obs == 12 ///
& obs == 82 | obs == 26 | obs == 96 | obs == 34 | obs == 104, ///
scale (1.65) xline(70) yline(0)   


