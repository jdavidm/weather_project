* Project: WB Weather
* Created on: November 2020
* Created by: jdm
* Edited by: jdm
* Last edit: 10 November 2020 
* Stata v.16.1 

* does
	* reads in results data set
	* makes visualziations of results 

* assumes
	* you have results file 
	* customsave.ado
	* grc1leg2.ado

* TO DO:
	* complete

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	global	root 	= 	"$data/results_data"
	global	stab 	= 	"$data/results_data/tables"
	global	xtab 	= 	"$data/output/paper/tables"
	global	sfig	= 	"$data/results_data/figures"	
	global 	xfig    =   "$data/output/paper/figures"
	global	logout 	= 	"$data/results_data/logs"

* open log	
	cap log close
	log 	using 	"$logout/resultsvis_r2", append

* load data 
	use 			"$root/lsms_complete_results", clear

	
* **********************************************************************
* 1 - generate R^2 specification curves by extraction & model
* **********************************************************************

	sort 			regname ext 
	egen			r2_mu = mean(adjustedr), by(regname ext)
	lab var			r2_mu "Mean adjusted R^2"
	egen			r2_se = sd(adjustedr), by(regname ext )
	lab var			r2_se "Standard error of adjusted R^2"
	
	gen				hi95 = r2_mu + 1.96 * (r2_se/sqrt(1296))
	gen				lo95 = r2_mu - 1.96 * (r2_se/sqrt(1296))
	
* weather only and weather squared only
preserve
	duplicates 		drop r2_mu, force
	keep			if regname == 1 | regname == 4
	sort 			regname r2_mu 
	gen 			obs = _n	

	global			title =		"Adjusted R-Squared"

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	ext + 6 + 2
	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Extraction"

	sum			 	hi95
	global			bmax = r(max)
	
	sum			 	lo95
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin-2.5*$brange
	global			gheight	=	28
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
		
	twoway 			scatter k1 k2 obs, xlab(0(10)20) xsize(10) ysize(6) msize(small small small) title("")	  ///
						ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather^2" 5 "Weather + Weather^2 + FE" /// 
						6 "Weather + Weather^2 + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Extraction 1" 10 "Extraction 2" 11 "Extraction 3" ///
						12 "Extraction 4" 13 "Extraction 5" 14 "Extraction 6" ///
						15 "Extraction 7" 16 "Extraction 8" 17 "Extraction 9" ///
						18 "Extraction 10" 19 "*{bf:Extraction}*" 28 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter r2_mu obs, yaxis(2) mcolor(maroon) ///
						ylab(0.012(0.002)0.024, axis(2) labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2))) || ///
						(rbar lo95 hi95 obs, barwidth(.2) color(edkblue%40) yaxis(2) ), ///
						legend(order(3 4 5) cols(1) size(small) rowgap(.5) pos(12) ///
						label(3 "mean adjusted R{sup:2}") label(4 "95% C.I.") ) ///
						saving("$sfig/r2_reg1_reg4", replace)	
restore
	
	
* weather FE and weather squared FE
preserve
	duplicates 		drop r2_mu, force
	keep			if regname == 2 | regname == 5
	sort 			regname r2_mu 
	gen 			obs = _n	

	global			title =		"Adjusted R-Squared"

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	ext + 6 + 2
	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Extraction"

	sum			 	hi95
	global			bmax = r(max)
	
	sum			 	lo95
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin-2.5*$brange
	global			gheight	=	28
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
		
	twoway 			scatter k1 k2 obs, xlab(0(10)20) xsize(10) ysize(6) msize(small small small) title("")	  ///
						ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather^2" 5 "Weather + Weather^2 + FE" /// 
						6 "Weather + Weather^2 + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Extraction 1" 10 "Extraction 2" 11 "Extraction 3" ///
						12 "Extraction 4" 13 "Extraction 5" 14 "Extraction 6" ///
						15 "Extraction 7" 16 "Extraction 8" 17 "Extraction 9" ///
						18 "Extraction 10" 19 "*{bf:Extraction}*" 28 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter r2_mu obs, yaxis(2) mcolor(maroon) ///
						ylab(.082(.003).097, axis(2) labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2))) || ///
						(rbar lo95 hi95 obs, barwidth(.2) color(edkblue%40) yaxis(2) ), ///
						legend(order(3 4 5) cols(1) size(small) rowgap(.5) pos(12) ///
						label(3 "mean adjusted R{sup:2}") label(4 "95% C.I.") ) ///
						saving("$sfig/r2_reg2_reg5", replace)	
restore


* weather FE inputs and weather squared FE inputs
preserve
	duplicates 		drop r2_mu, force
	keep			if regname == 3 | regname == 6
	sort 			regname r2_mu 
	gen 			obs = _n	

	global			title =		"Adjusted R-Squared"

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	ext + 6 + 2
	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Extraction"

	sum			 	hi95
	global			bmax = r(max)
	
	sum			 	lo95
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin-2.5*$brange
	global			gheight	=	28
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
		
	twoway 			scatter k1 k2 obs, xlab(0(10)20) xsize(10) ysize(6) msize(small small small) title("")	  ///
						ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather^2" 5 "Weather + Weather^2 + FE" /// 
						6 "Weather + Weather^2 + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Extraction 1" 10 "Extraction 2" 11 "Extraction 3" ///
						12 "Extraction 4" 13 "Extraction 5" 14 "Extraction 6" ///
						15 "Extraction 7" 16 "Extraction 8" 17 "Extraction 9" ///
						18 "Extraction 10" 19 "*{bf:Extraction}*" 28 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter r2_mu obs, yaxis(2) mcolor(maroon) ///
						ylab(.223(.003).238, axis(2) labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2))) || ///
						(rbar lo95 hi95 obs, barwidth(.2) color(edkblue%40) yaxis(2) ), ///
						legend(order(3 4 5) cols(1) size(small) rowgap(.5) pos(12) ///
						label(3 "mean adjusted R{sup:2}") label(4 "95% C.I.") ) ///
						saving("$sfig/r2_reg3_reg6", replace)	
restore

* combine moments graphs
	grc1leg2 		"$sfig/r2_reg1_reg4.gph" "$sfig/r2_reg2_reg5.gph"  ///
						"$sfig/r2_reg3_reg6.gph", col(2) iscale(.5) ///
						ring(0) pos(5) holes(4) commonscheme
						
	graph export 	"$xfig\r2_ext.png", width(1400) replace
		

* **********************************************************************
* 2 - generate random number to select extraction method
* **********************************************************************

* choose one extraction method at random
preserve
	clear			all
	set obs			1
	set seed		5203317230
	gen double 		u = (10-1)*runiform() + 1
	gen 			i = round(u)
	sum		 		u i 
restore	


* **********************************************************************
* 3 - generate R^2 specification curves by satellite & model
* **********************************************************************


		
* **********************************************************************
* 4 - end matter
* **********************************************************************


* close the log
	log	close

/* END */		