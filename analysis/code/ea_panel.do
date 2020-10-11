* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	loc		source	= 	"$data/regression_data"
	loc		results = 	"$data/results_data"
	loc		logout 	= 	"$data/regression_data/logs"

* open log	
	cap log close
	log 	using 		"`logout'/regressions", append

	
* **********************************************************************
* 1 - read in cross country panel
* **********************************************************************

* read in data file
	use			"`source'/lsms_panel.dta", clear
	
* dropping observations from west african countries
	drop 		if country == 3
	drop		if country == 4
	drop		if country == 5 

* dropping nine of ten extraction methods (keeping true location)
	drop 		*x0
	drop 		*x2
	drop 		*x3
	drop 		*x4
	drop 		*x5
	drop 		*x6
	drop 		*x7
	drop 		*x8
	drop 		*x9
	
* save complete results
	qui: compress
	customsave 	, idvarname(hhid) filename("ea_panel.dta") ///
		path("`source'") dofile(ea_panel) user($user)

* close the log
	log	close

/* END */