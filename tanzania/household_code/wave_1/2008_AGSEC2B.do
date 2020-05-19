* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.16

* does
	* examines parcel roster, 2008 short rainy season
	* only 86 total observations so we will exclude all short rain data

* assumes
	* nothing

* TO DO:
	* completed


* **********************************************************************
* 0 - setup
* **********************************************************************

* set user
	*global	user		"jdmichler" // global managed by masterdo, turn on to run single file

* define paths
	loc 	root 		= 	"G:/My Drive/weather_project/household_data/tanzania/wave_1/raw"
	loc 	export 	= 	"G:/My Drive/weather_project/household_data/tanzania/wave_1/refined"
	loc 	logout 	= 	"G:/My Drive/weather_project/household_data/tanzania/logs"

* open log
	log 	using 			"`logout'/wv1_AGSEC2B", append


* **********************************************************************
* 1 - TZA 2008 (Wave 1) - Agriculture Section 2B
* **********************************************************************

* load data
	use 		"`root'/SEC_2B", clear

* look to see how many plots there are
	sum 		s2bq9 area
	*** there are only 12 plots with GPS measures
	*** there are only 86 total plots
	*** this isn't enough observations to analyze
	*** so we exclude the short rainy season for 2008

* close the log
	log	close

/* END */
