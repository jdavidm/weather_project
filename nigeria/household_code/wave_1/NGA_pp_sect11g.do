* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Stata v.16

* does
	* reads in Nigeria, WAVE 1 POST PLANTING, NIGERIA SECT11G
	* converts harvest quantitites 
	* converts to kilograms, as appropriate
	* outputs clean data file ready for combination with wave 1 hh data

* assumes
	* customsave.ado
	* harvconv.dta conversion file 

* **********************************************************************
* 0 - setup
* **********************************************************************
	
* define paths	
	loc root = "$data/household_data/nigeria/wave_1/raw"
	loc export = "$data/household_data/nigeria/wave_1/refined"
	loc logout = "$data/household_data/nigeria/logs"

* close log (in case still open)
	*log close
	
* open log	
	log using "`logout'/pp_sect11g", append

* **********************************************************************
* 1 - general clean up, renaming, etc. 
* **********************************************************************
		
* import the first relevant data file
		use "`root'/sect11g_plantingw1", clear 	

describe
sort hhid plotid cropid
isid hhid plotid cropid, missok

gen harvestq_pp = s11gq8a
label variable harvestq_pp "How much (tree/perm crop) did you harvest since the new year? post planting survey"
rename s11gq8b harv_unit
rename s11gq8c harv_unit2
*these are the units of measurement

*create conv column for harv_unit2 - following kg matches, logic, etc. 
*[alj in charge of errors]
sort harv_unit2 harv_unit
gen conv_harvunit2 = .
replace conv_harvunit2 = 1 in 924
replace conv_harvunit2 = 1 in 925
replace conv_harvunit2 = 1 in 926
replace conv_harvunit2 = 1 in 927
replace conv_harvunit2 = 1 in 928
replace conv_harvunit2 = 1 in 929
replace conv_harvunit2 = 1 in 930
replace conv_harvunit2 = 1 in 931
replace conv_harvunit2 = 1 in 932
replace conv_harvunit2 = 1 in 933
replace conv_harvunit2 = 1 in 934
replace conv_harvunit2 = 1 in 935
replace conv_harvunit2 = 1 in 936
replace conv_harvunit2 = 1 in 937
replace conv_harvunit2 = 1 in 938
replace conv_harvunit2 = 1 in 939
replace conv_harvunit2 = 1 in 940
replace conv_harvunit2 = 1 in 941
replace conv_harvunit2 = 1 in 942
replace conv_harvunit2 = 1 in 943
replace conv_harvunit2 = 1 in 944
replace conv_harvunit2 = 1 in 821
replace conv_harvunit2 = 1 in 822
replace conv_harvunit2 = 50 in 823
replace conv_harvunit2 = 50 in 824
replace conv_harvunit2 = 50 in 825
replace conv_harvunit2 = 50 in 826
replace conv_harvunit2 = 50 in 827
replace conv_harvunit2 = 50 in 828
replace conv_harvunit2 = 50 in 829
replace conv_harvunit2 = 50 in 830
replace conv_harvunit2 = 50 in 831
replace conv_harvunit2 = 50 in 832
replace conv_harvunit2 = 50 in 833
replace conv_harvunit2 = 50 in 834
replace conv_harvunit2 = 50 in 835
replace conv_harvunit2 = 50 in 836
replace conv_harvunit2 = 50 in 837
replace conv_harvunit2 = 50 in 838
replace conv_harvunit2 = 50 in 839
replace conv_harvunit2 = 1 in 845
replace conv_harvunit2 = 1 in 846
replace conv_harvunit2 = 1 in 847
replace conv_harvunit2 = 1 in 848
replace conv_harvunit2 = 1 in 849
replace conv_harvunit2 = 1 in 850
replace conv_harvunit2 = 1 in 851
replace conv_harvunit2 = 1 in 852
replace conv_harvunit2 = 1 in 853
replace conv_harvunit2 = 1 in 854
replace conv_harvunit2 = 1 in 855
replace conv_harvunit2 = 1 in 856
replace conv_harvunit2 = 1 in 857
replace conv_harvunit2 = 1 in 858
replace conv_harvunit2 = 1 in 859
replace conv_harvunit2 = 1 in 860
replace conv_harvunit2 = 1 in 861
replace conv_harvunit2 = 1 in 862
replace conv_harvunit2 = 1 in 863
replace conv_harvunit2 = 1 in 864
replace conv_harvunit2 = 1 in 865
replace conv_harvunit2 = 1 in 866
replace conv_harvunit2 = 1 in 867
replace conv_harvunit2 = 1 in 868
replace conv_harvunit2 = 1 in 869
replace conv_harvunit2 = 1 in 871
replace conv_harvunit2 = 1 in 870
replace conv_harvunit2 = 1 in 872
replace conv_harvunit2 = 1 in 873
replace conv_harvunit2 = 1 in 874
replace conv_harvunit2 = 2 in 875
replace conv_harvunit2 = 3.75 in 883
replace conv_harvunit2 = 1 in 882
replace conv_harvunit2 = 1 in 946
replace conv_harvunit2 = 50 in 948
replace conv_harvunit2 = .5 in 949
sort harv_unit2 harv_unit

*obs = 950

*issues with encoding harv_unit2
encode harv_unit2, generate (harv_unit2a)
rename harv_unit2 harv_unit2_test
rename harv_unit2a harv_unit2

* **********************************************************************
* 2 - converting quantities
* **********************************************************************

* define new paths for conversions	
	loc root = "G:/My Drive/weather_project/household_data/nigeria/conversion_files/"
  
merge m:1 cropcode harv_unit using "`root'/harvconv"

drop if _merge == 1 & harv_conversion == .
*either no conversion (no definition for head) or no units 
*obs = 520

drop _merge

gen harvestq = .
replace harvestq = harvestq_pp*conv_harvunit2 if conv_harvunit2 != .

merge m:1 cropcode harv_unit2 using "`root'/harvconv"
replace harvestq = harvestq_pp*conv_harvunit2 if conv_harvunit2 != .

* **********************************************************************
* 3 - end matter, clean up to save
* **********************************************************************

keep zone ///
state ///
lga ///
sector ///
hhid ///
ea ///
plotid ///
cropid ///
cropcode ///
harvestq_pp ///

compress
describe
summarize 


* save file
		customsave , idvar(hhid) filename("pp_sect11g.dta") ///
			path("`export'/`folder'") dofile(pp_sect11g) user($user)

* close the log
	log	close

/* END */