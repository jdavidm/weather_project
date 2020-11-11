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
* 1 - generate serrbar graphs by satellite
* **********************************************************************

	
* **********************************************************************
* 1a - generate serrbar graphs by rainfall variable and satellite
* **********************************************************************

	sort 			regname ext 
	egen			r2_mu = mean(adjustedr), by(regname ext)
	egen			r2_se = sd(adjustedr), by(regname ext )
	
	gen				hi95 = r2_mu + 1.96 * (r2_se/sqrt(1296))
	gen				lo95 = r2_mu - 1.96 * (r2_se/sqrt(1296))
	
	gen				hi90 = r2_mu + 1.645 * (r2_se/sqrt(1296))
	gen				lo90 = r2_mu - 1.645 * (r2_se/sqrt(1296))
	
* weather only and weather squared only
preserve
	duplicates 		drop r2_mu, force
	keep			if regname == 1 | regname == 4
	sort 			regname r2_mu 
	gen 			obs = _n	
	
	global		title =		"Adjusted R^2"

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	ext + 6 + 2
	
	lab				var obs "Specification # - sorted by effect size"

	lab 			var k1 "Specification"
	lab 			var k2 "Extraction"
	
	twoway 			scatter k1 k2 obs, msize(vtiny vtiny vtiny vtiny vtiny vtiny) title("$title") ///
						ylabel( , angle(0) labsize(tiny) tstyle(notick))  legend(off) || ///
						(scatter r2_mu obs) ///
						(rbar lo95 hi95 obs, barwidth(.4) color(gs7%60)) ///
						 (rbar lo90 hi90 obs, barwidth(.6) color(gs7%40)), ///
						 legend(off) saving("$sfig/r2_reg1_reg4", replace)	
restore
				 
* weather FE and weather squared FE
preserve
	duplicates 		drop r2_mu, force
	keep			if regname == 2 | regname == 5
	sort 			regname r2_mu 
	gen 			obs = 20 + _n		
	
	twoway 			(scatter r2_mu obs) ///
						(rbar lo95 hi95 obs, barwidth(.4) color(gs7%60)) ///
						 (rbar lo90 hi90 obs, barwidth(.6) color(gs7%40)), ////
						 legend(off) saving("$sfig/r2_reg2_reg5", replace)	
restore

* weather FE and weather squared FE
preserve
	duplicates 		drop r2_mu, force
	keep			if regname == 3 | regname == 6
	sort 			regname r2_mu 
	gen 			obs = 40 + _n		
	
	twoway 			(scatter r2_mu obs) ///
						(rbar lo95 hi95 obs, barwidth(.4) color(gs7%60)) ///
						 (rbar lo90 hi90 obs, barwidth(.6) color(gs7%40)), ///
						 legend(off) saving("$sfig/r2_reg3_reg6", replace)	
restore
		
	gr combine 		"$sfig/r2_reg1_reg4.gph" "$sfig/r2_reg2_reg5.gph" ///
						"$sfig/r2_reg3_reg6.gph", col(3) iscale(.5) ///
						imargin(0 0 0 0) commonscheme
	



* generate variable for main effect
	gen 			b 		= 	betarain
	gen 			p 		= 	serain
	global		title =		"Main Effect of Rainfall in Malawi"

* stack values of the specification indicators
	gen 			k1 		= 	depvar
	gen 			k2 		= 	regname + 2 + 2
	gen 			k3 		= 	ext + 10 + 2
	gen				k4 		= 	sat + 22 + 2
	gen				k5 		= 	varname + 30 + 2

* significant vs non significant results
	gen 			b_sig = 	b
	replace 		b_sig	=		. if p > .05
	label 			var b_sig "p<.05"

	gen 			b_ns	=		b
	replace 		b_ns	= . if p < .05
	lab				var b_ns "n.s."

* sort effect size
	sort 			b
	gen 			sk		=	_n
	lab				var sk "Specification # - sorted by effect size"

	lab 			var k1 "Dependent Variable"
	lab 			var k2 "Specification"
	lab				var k3 "Extraction"
	lab 			var k4 "Satellite"
	lab				var k5 "Weather Metric"

	anova b k1 k2 k3 k4 k5

* graph parameters
	summarize b
	global		brange	=	r(max)-r(min)
	global		bmin		=	r(min)
	global		bmax		=	r(max)
	global		from_y	=	$bmin-4.5*$brange
	global		gheight	=	46*4/3

	 di 			$bmin
	 di 			$brange
	 di 			$from_y
	 di 			$gheight


	scatter k1 k2 k3 k4 k5  sk, msize(vtiny vtiny vtiny vtiny vtiny vtiny) title("$title") ///
			xlab(0(1000)72) xsize(10) ysize(6) ylab(0(1)$gheight ) ylabel( , angle(0) labsize(tiny) tstyle(notick)) legend(off)  || ///
	scatter b_ns  sk, yaxis(2) mcolor(eltblue) msize(vtiny) ytitle("{bf:% difference}",axis(2) placement(north)) 	|| ///
	scatter b_sig sk,yaxis(2) mcolor(black) msize(vtiny)  ylab(, axis(2) labsize(tiny) angle(0) ) yscale(range($from_y $bmax) axis(2)) ///
		yline(0, axis(2) lw(thin) lcolor(gray))  yline(3 4 11 12 23 24 31 32 47 48, lw(thick) lcolor(white) lpattern(solid)) ///
		yline(48(0.5)62 ,axis(1) lw(vthick) lcolor(olive_teal) lpattern(solid)) 


/*
///
			1	"Quantity (kg/ha)" 2 "Value (USD/ha)" ///
			5 	"Weather Only" 6 "Weather + FE" 7 "Weather + FE + Inputs" ///
			8 	"Weather + Weather^2" 9 "Weather + Weather^2 + FE" ///
			10	"Weather + Weather^2 + FE + Inputs" ///
		    13 	"Extraction 1" 14 "Extraction 2" 15 "Extraction 3" ///
			16 	"Extraction 4" 17 "Extraction 5" 18 "Extraction 6" ///
			19	"Extraction 7" 20 "Extraction 8" 21 "Extraction 9" 22 "Extraction 10" ///
			25	"Satellite 1" 26 "Satellite 2" 27 "Satellite 3" ///
			28 	"Satellite 4" 29 "Satellite 5" 30 "Satellite 6" ///
			33 	"Mean Daily Rainfall" 34 "Median Daily Rainfall" ///
			35 	"Variance of Daily Rainfall" 36 "Skew of Daily Rainfall" ///
			37 	"Total Rainfall" 38 "Deviation in Total Rainfall" ///
			39 "Z-Score of Total Rainfall" 40 "Rainy Days" ///
			41 "Deviation in Rainy Days" 42 "No Rain Days" ///
			43 "Deviation in No Rain Days" 44 "% Rainy Days" ///
			45 "Deviation in % Rainy Days" 46 "Longest Dry Spell" ///
			3 	"*{bf:Dependent Variable}*" 11 "*{bf:Specification}*"  23 "*{bf:Extraction}*" ///
			31 "*{bf:Satellite}*" 47 "*{bf:Weather Metric}*"
*/

	
* **********************************************************************
* 4 - end matter
* **********************************************************************


* close the log
	log	close

/* END */		