* Project: WB Weather
* Created on: May 2020
* Created by: McG
* Stata v.16

* does
	* examines parcel roster, 2012 short rainy season
	* only 27 total observations so we will exclude all short rain data

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
	loc 	root 		= 	"G:/My Drive/weather_project/household_data/tanzania/wave_3/raw"
	loc 	export 	= 	"G:/My Drive/weather_project/household_data/tanzania/wave_3/refined"
	loc 	logout 	= 	"G:/My Drive/weather_project/household_data/tanzania/logs"

* open log
	log 	using "`logout'/wv3_AGSEC2B", append

* ***********************************************************************
* 1 - TZA 2012 (Wave 3) - Agriculture Section 2B
* ***********************************************************************

* load data
	use 		"`root'/AG_SEC_2B", clear

* look to see how many plots there are
	sum			ag2b_15 ag2b_20
	*** there are only 9 plots with GPS measures
	*** there are only 27 total plots
	*** this isn't enough observations to analyze
	*** so we exclude the short rainy season for 2012

* close the log
	log	close

/* END */
