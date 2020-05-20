* Project: WB Weather
* Created on: May 2020
* Created by: jdm
* Stata v.16

* does
	* loads Malawi results
	* produces specification chart

* assumes
	* posted results
	* customsave.ado

* TO DO:
	* first draft


* **********************************************************************
* 0 - setup
* **********************************************************************

* set global user
	global	user		"jdmichler"

* define paths
	global		source	= 	"G:/My Drive/weather_project/results_data/malawi"
	global		export 	= 	"C:/$user/git/weather_project/malawi/output/figures"
	global		logout 	= 	"G:/My Drive/weather_project/results_data/logs"

* open log
	log 		using 		"$logout/mwi_spec_chart", append


* **********************************************************************
* 1 - final cleaning of rainfall data
* **********************************************************************

* load results file
	use			"$source/mwi_complete_results.dta", clear

* keep only the long panel and rainfall data (we can do this in loops later)
	keep 		if data == 1
	keep		if sat < 7
	
* generate country variable
	gen				country 	= 	2
	lab 			define cnty 	1 "Ethiopia" ///
													2 "Malawi" ///
													3 "Mali" ///
													4 "Niger" ///
													5 "Nigeria" ///
													6 "Tanzania" ///
													7 "Uganda"
	lab 			values country cnty
	order			country

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
			xlab(0(1000)10080) xsize(10) ysize(6) ylab(0(1)$gheight ) ylabel( , angle(0) labsize(tiny) tstyle(notick)) legend(off)  || ///
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
		   
		   
* save complete results
	customsave 	, idvarname(reg_id) filename("mwi_complete_results.dta") ///
		path("$results") dofile(mwi_regression) user($user)

* close the log
	log	close

/* END */
