* Project: WB Weather
* Created on: Aug 2020
* Created by: mcg
* Stata v.16

* does
	* reads in merged data sets
	* appends merged data sets
	* outputs ???


* assumes
	* all ethiopia data has been cleaned and merged with rainfall
	* customsave.ado
	* xfill.ado

* TO DO:
	* complete

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		root 	= 	"$data/merged_data/ethiopia"
	loc		export 	= 	"$data/regression_data/ethiopia"
	loc		logout 	= 	"$data/merged_data/ethiopia/logs"

* open log	
	log 	using 		"`logout'/eth_append_build", append