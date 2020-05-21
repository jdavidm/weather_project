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

* User initials:
    * Jeff		jdm
    * Anna	 	alj
    * Brian		mcg
    * Emil      etk

* Set this value to the user currently using this file

    global 			user 	"jdm"

* Specify Stata version in use
    global stataVersion 16.1    // set Stata version
    version $stataVersion

* **********************************************************************
* 0 (a) - Create user specific paths
* **********************************************************************

* Define root folder globals
    if "$user" == "jdm" {
        global 		code  	"C:/Users/jdmichler/git/weather_project"
		global 		data		"G:/My Drive/weather_project"
    }

    if "$user" == "alj" {
        global 		code  	"C:/Users/aljosephson/git/weather_project"
		global 		data		"G:/My Drive/weather_project"
    }

    if "$user" == "mcg" {
        global 		code  	"C:/Users/themacfreezie/git/weather_project"
		global 		data		"G:/My Drive/weather_project"
    }

    if "$user" == "etk" {
        global 		code  	"C:/Users/emilk/git/weather_project"
		global 		data		"G:/My Drive/weather_project"
    }

* **********************************************************************
* 0 (b) - Check if any required packages are installed:
* **********************************************************************

* install packages if global is set to 1
if $pack == 1 {

	* for packages/commands, make a local containing any required packages
		loc userpack "blindschemes mdsec estout mdesc xfill reghdfe ftools weather customsave distinct winsor2"

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

	* the package -xfill- is not on ssc so installing here
		which xfill
		if _rc != 0 {
			capture window stopbox rusure "You are missing some packages." "Do you want to install `package'?"
			if _rc == 0 {
				net install xfill, replace from(https://www.sealedenvelope.com/)
			}
			else {
				exit 199
			}
		}

	* update all ado files
		ado update, update

	* install metadata .do file
		net install StataConfig, ///
		from(https://raw.githubusercontent.com/etjernst/Materials/master/stata/) replace

	* set graph and Stata preferences
		set scheme plotplain
		set more off
}


* **********************************************************************
* 1 - run weather data cleaning .do file
* **********************************************************************


* **********************************************************************
* 2 - run household data cleaning .do file
* **********************************************************************


* **********************************************************************
* 3 - run .do files that merge weather and household data
* **********************************************************************


* **********************************************************************
* 4 - run regression .do files
* **********************************************************************


* **********************************************************************
* 5 - run analysis .do files
* **********************************************************************
