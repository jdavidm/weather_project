* Project: WB Weather
* Created on: May 2020
* Created by: jdm
* Stata v.16

* does
	* establishes an identical workspace between users
	* sets globals that define absolute paths
	* serves as the starting point to find any do-file, dataset or output
	* runs all do-files needed for data work. ([!] Eventually)
	* loads any user written packages needed for analysis

* assumes
	* access to all data and code

* TO DO:
	* add all do-files


* **********************************************************************
* 0 - setup
* **********************************************************************

* set $pack to 0 to skip package installation
	global 			pack 	0
		
* Specify Stata version in use
    global stataVersion 16.1    // set Stata version
    version $stataVersion

* **********************************************************************
* 0 (a) - Create user specific paths
* **********************************************************************


* Define root folder globals
    if `"`c(username)'"' == "jdmichler" {
        global 		code  	"C:/Users/jdmichler/git/weather_project"
		global 		data	"G:/My Drive/weather_project"
    }

    if `"`c(username)'"' == "aljosephson" {
        global 		code  	"C:/Users/aljosephson/git/weather_project"
		global 		data	"G:/My Drive/weather_project"
    }

    if `"`c(username)'"' == "themacfreezie" {
        global 		code  	"C:/Users/themacfreezie/git/weather_project"
		global 		data	"G:/My Drive/weather_project"
    }

    if `"`c(username)'"' == "emilk" {
        global 		code  	"C:/Users/emilk/git/weather_project"
		global 		data	"G:/My Drive/weather_project"
    }

* **********************************************************************
* 0 (b) - Check if any required packages are installed:
* **********************************************************************

* install packages if global is set to 1
if $pack == 1 {
	
	* temporarily set delimiter to ; so can break the line
		#delimit ;
	* for packages/commands, make a local containing any required packages
		loc userpack "blindschemes mdesc estout reghdfe ftools distinct winsor2" ;
		#delimit cr
	
	* install packages that are on ssc	
		foreach package in `userpack' {
			capture : which `package', all
			if (_rc) {
				capture window stopbox rusure "You are missing some packages." "Do you want to install `package'?"
				if _rc == 0 {
					capture ssc install `package', replace
					if (_rc) {
						window stopbox rusure `"This package is not on SSC. Do you want to proceed without it?"'
					}
				}
				else {
					exit 199
				}
			}
		}

	* install -xfill- package
		net install xfill, replace from(https://www.sealedenvelope.com/)
		
	* install -customsave package
		net install StataConfig, ///
		from(https://raw.githubusercontent.com/etjernst/Materials/master/stata/) replace

	* install -weather- package
		net install WeatherConfig, ///
		from(https://jdavidm.github.io/) replace
	
	* update all ado files
		ado update, update

	* set graph and Stata preferences
		set scheme plotplain, perm
		set more off
}


* **********************************************************************
* 1 - run weather data cleaning .do file
* **********************************************************************
/*
	do 			"$code/ethiopia/weather_code/ETH_ESS_masterdo.do"
	do 			"$code/malawi/weather_code/MWI_IHS_masterdo.do"
	do 			"$code/nigeria/weather_code/NGA_GHSY_masterdo.do"
	do 			"$code/tanzania/weather_code/TZA_NPS_masterdo.do"
	do 			"$code/uganda/weather_code/UGA_UNPS_masterdo.do"
*/

* **********************************************************************
* 2 - run household data cleaning .do file
* **********************************************************************
/*
	do 			"$code/ethiopia/household_code/ETH_hh_masterdo.do"
	do 			"$code/malawi/household_code/ETH_hh_masterdo.do"
	do 			"$code/nigeria/household_code/ETH_hh_masterdo.do"
	do 			"$code/tanzania/household_code/ETH_hh_masterdo.do"
	do 			"$code/uganda/household_code/ETH_hh_masterdo.do"
*/

* **********************************************************************
* 5 - run regression .do files
* **********************************************************************


* **********************************************************************
* 5 - run analysis .do files
* **********************************************************************
