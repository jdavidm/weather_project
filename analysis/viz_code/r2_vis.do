* Project: WB Weather
* Created on: November 2020
* Created by: jdm
* Edited by: jdm
* Last edit: 30 November 2020 
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


* **********************************************************************
* 1 - generate R^2 specification curves by extraction & model
* **********************************************************************

* load data 
	use 			"$root/lsms_complete_results", clear
	
	sort 			regname ext 

	collapse 		(mean) r2_mu = adjustedr ///
						(sd) r2_sd = adjustedr ///
						(count) n = adjustedr, by(regname ext)
	
	gen 			r2_hi = r2_mu + invttail(n-1,0.025) * (r2_sd / sqrt(n))
	gen				r2_lo = r2_mu - invttail(n-1,0.025) * (r2_sd / sqrt(n))
	
* weather only and weather squared only
preserve
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

	sum			 	r2_hi
	global			bmax = r(max)
	
	sum			 	r2_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	28
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
		
	twoway 			scatter k1 k2 obs, xlab(0(10)20) xsize(10) ysize(6) msize(small small small) title("")	  ///
						ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Extraction 1" 10 "Extraction 2" 11 "Extraction 3" ///
						12 "Extraction 4" 13 "Extraction 5" 14 "Extraction 6" ///
						15 "Extraction 7" 16 "Extraction 8" 17 "Extraction 9" ///
						18 "Extraction 10" 19 "*{bf:Extraction}*" 28 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter r2_mu obs, yaxis(2) mcolor(maroon) ///
						ylab(0.012(0.002)0.024, axis(2) labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2))) || ///
						(rbar r2_lo r2_hi obs, barwidth(.2) color(edkblue%40) yaxis(2) ), ///
						legend(order(3 4 5) cols(1) size(small) rowgap(.5) pos(12) ///
						label(3 "mean adjusted R{sup:2}") label(4 "95% C.I.") ) ///
						saving("$sfig/r2_reg1_reg4_ext", replace)	
restore
	
	
* weather FE and weather squared FE
preserve
	keep			if regname == 2 | regname == 5
	sort 			regname r2_mu 
	gen 			obs = _n	

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	ext + 6 + 2
	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Extraction"

	sum			 	r2_hi
	global			bmax = r(max)
	
	sum			 	r2_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	28
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
		
	twoway 			scatter k1 k2 obs, xlab(0(10)20) xsize(10) ysize(6) msize(small small small) title("")	  ///
						ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Extraction 1" 10 "Extraction 2" 11 "Extraction 3" ///
						12 "Extraction 4" 13 "Extraction 5" 14 "Extraction 6" ///
						15 "Extraction 7" 16 "Extraction 8" 17 "Extraction 9" ///
						18 "Extraction 10" 19 "*{bf:Extraction}*" 28 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter r2_mu obs, yaxis(2) mcolor(maroon) ///
						ylab(.082(.003).097, axis(2) labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2))) || ///
						(rbar r2_lo r2_hi obs, barwidth(.2) color(edkblue%40) yaxis(2) ), ///
						legend(order(3 4 5) cols(1) size(small) rowgap(.5) pos(12) ///
						label(3 "mean adjusted R{sup:2}") label(4 "95% C.I.") ) ///
						saving("$sfig/r2_reg2_reg5_ext", replace)	
restore


* weather FE inputs and weather squared FE inputs
preserve
	keep			if regname == 3 | regname == 6
	sort 			regname r2_mu 
	gen 			obs = _n	

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	ext + 6 + 2
	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Extraction"

	sum			 	r2_hi
	global			bmax = r(max)
	
	sum			 	r2_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	28
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
		
	twoway 			scatter k1 k2 obs, xlab(0(10)20) xsize(10) ysize(6) msize(small small small) title("")	  ///
						ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Extraction 1" 10 "Extraction 2" 11 "Extraction 3" ///
						12 "Extraction 4" 13 "Extraction 5" 14 "Extraction 6" ///
						15 "Extraction 7" 16 "Extraction 8" 17 "Extraction 9" ///
						18 "Extraction 10" 19 "*{bf:Extraction}*" 28 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter r2_mu obs, yaxis(2) mcolor(maroon) ///
						ylab(.223(.003).238, axis(2) labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2))) || ///
						(rbar r2_lo r2_hi obs, barwidth(.2) color(edkblue%40) yaxis(2) ), ///
						legend(order(3 4 5) cols(1) size(small) rowgap(.5) pos(12) ///
						label(3 "mean adjusted R{sup:2}") label(4 "95% C.I.") ) ///
						saving("$sfig/r2_reg3_reg6_ext", replace)	
restore

* combine R^2 specification curves for extration
	grc1leg2 		"$sfig/r2_reg1_reg4_ext.gph" "$sfig/r2_reg2_reg5_ext.gph"  ///
						"$sfig/r2_reg3_reg6_ext.gph", col(2) iscale(.5) ///
						ring(0) pos(5) holes(4) commonscheme
						
	graph export 	"$xfig\r2_ext.eps", as(eps) replace
		

* **********************************************************************
* 2 - generate random number to select extraction method
* **********************************************************************

* choose one extraction method at random
preserve
	clear			all
	set obs			1
	set seed		3317230
	gen double 		u = (10-1) * runiform() + 1
	gen 			i = round(u)
	sum		 		u i 
restore	
*** random number was 3, so we proceed with extraction method 3

* **********************************************************************
* 3 - generate R^2 specification curves by weather metric & model
* **********************************************************************


* **********************************************************************
* 3a - generate R^2 specification curves by rainfall metric & model
* **********************************************************************

* load data 
	use 			"$root/lsms_complete_results", clear

* keep extraction 3	
	keep			if ext == 3
	sort 			regname varname 

	collapse 		(mean) r2_mu = adjustedr ///
						(sd) r2_sd = adjustedr ///
						(count) n = adjustedr, by(regname varname)
	
	gen 			r2_hi = r2_mu + invttail(n-1,0.025) * (r2_sd / sqrt(n))
	gen				r2_lo = r2_mu - invttail(n-1,0.025) * (r2_sd / sqrt(n))

* weather only and weather squared only
preserve
	keep			if regname == 1 | regname == 4
	keep			if varname < 15
	sort 			regname r2_mu 
	gen 			obs = _n	

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	varname + 6 + 2
	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Rainfall Metric"

	sum			 	r2_hi
	global			bmax = r(max)
	
	sum			 	r2_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	37
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
		
	twoway 			scatter k1 k2 obs, xlab(0(4)28) xsize(10) ysize(6) msize(small small small) title("")	  ///
						ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Mean Daily Rain" 10 "Median Daily Rain" 11 "Variance of Daily Rain" ///
						12 "Skew of Daily Rain" 13 "Total Seasonal Rain" 14 "Dev. in Total Rain" ///
						15 "z-Score of Total Rain" 16 "Rainy Days" 17 "Dev. in Rainy Days" ///
						18 "No Rain Days" 19 "Dev. in No Rain Days" 20 "% Rainy Days" ///
						21 "Dev. in % Rainy Days" 22 "Longest Dry Spell" ///
						23 "*{bf:Rainfall Metric}*" 37 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter r2_mu obs, yaxis(2) mcolor(maroon) ///
						ylab(0(0.01)0.04, axis(2) labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2))) || ///
						(rbar r2_lo r2_hi obs, barwidth(.2) color(edkblue%40) yaxis(2) ), ///
						legend(order(3 4 5) cols(1) size(small) rowgap(.5) pos(12) ///
						label(3 "mean adjusted R{sup:2}") label(4 "95% C.I.") ) ///
						saving("$sfig/r2_reg1_reg4_rf", replace)	
restore


* weather FE and weather squared FE
preserve
	keep			if regname == 2 | regname == 5
	keep			if varname < 15
	sort 			regname r2_mu 
	gen 			obs = _n	

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	varname + 6 + 2
	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Rainfall Metric"

	sum			 	r2_hi
	global			bmax = r(max)
	
	sum			 	r2_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	37
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
		
	twoway 			scatter k1 k2 obs, xlab(0(4)28) xsize(10) ysize(6) msize(small small small) title("")	  ///
						ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Mean Daily Rain" 10 "Median Daily Rain" 11 "Variance of Daily Rain" ///
						12 "Skew of Daily Rain" 13 "Total Seasonal Rain" 14 "Dev. in Total Rain" ///
						15 "z-Score of Total Rain" 16 "Rainy Days" 17 "Dev. in Rainy Days" ///
						18 "No Rain Days" 19 "Dev. in No Rain Days" 20 "% Rainy Days" ///
						21 "Dev. in % Rainy Days" 22 "Longest Dry Spell" ///
						23 "*{bf:Rainfall Metric}*" 37 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter r2_mu obs, yaxis(2) mcolor(maroon) ///
						ylab(0.07(0.01)0.12, axis(2) labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2))) || ///
						(rbar r2_lo r2_hi obs, barwidth(.2) color(edkblue%40) yaxis(2) ), ///
						legend(order(3 4 5) cols(1) size(small) rowgap(.5) pos(12) ///
						label(3 "mean adjusted R{sup:2}") label(4 "95% C.I.") ) ///
						saving("$sfig/r2_reg2_reg5_rf", replace)	
restore


* weather FE inputs and weather squared FE inputs
preserve
	keep			if regname == 3 | regname == 6
	keep			if varname < 15
	sort 			regname r2_mu 
	gen 			obs = _n	

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	varname + 6 + 2
	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Rainfall Metric"

	sum			 	r2_hi
	global			bmax = r(max)
	
	sum			 	r2_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	37
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
		
	twoway 			scatter k1 k2 obs, xlab(0(4)28) xsize(10) ysize(6) msize(small small small) title("")	  ///
						ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Mean Daily Rain" 10 "Median Daily Rain" 11 "Variance of Daily Rain" ///
						12 "Skew of Daily Rain" 13 "Total Seasonal Rain" 14 "Dev. in Total Rain" ///
						15 "z-Score of Total Rain" 16 "Rainy Days" 17 "Dev. in Rainy Days" ///
						18 "No Rain Days" 19 "Dev. in No Rain Days" 20 "% Rainy Days" ///
						21 "Dev. in % Rainy Days" 22 "Longest Dry Spell" ///
						23 "*{bf:Rainfall Metric}*" 37 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter r2_mu obs, yaxis(2) mcolor(maroon) ///
						ylab(0.2(0.02)0.26, axis(2) labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2))) || ///
						(rbar r2_lo r2_hi obs, barwidth(.2) color(edkblue%40) yaxis(2) ), ///
						legend(order(3 4 5) cols(1) size(small) rowgap(.5) pos(12) ///
						label(3 "mean adjusted R{sup:2}") label(4 "95% C.I.") ) ///
						saving("$sfig/r2_reg3_reg6_rf", replace)	
restore	
	
* combine R^2 specification curves for satellite
	grc1leg2 		"$sfig/r2_reg1_reg4_rf.gph" "$sfig/r2_reg2_reg5_rf.gph"  ///
						"$sfig/r2_reg3_reg6_rf.gph", col(2) iscale(.5) ///
						ring(0) pos(5) holes(4) commonscheme
						
	graph export 	"$xfig\r2_rf.pdf", as(pdf) replace
		

* **********************************************************************
* 3b - generate R^2 specification curves by temperature metric & model
* **********************************************************************

* load data 
	use 			"$root/lsms_complete_results", clear

* keep extraction 3	
	keep			if ext == 3
	sort 			regname varname 

	collapse 		(mean) r2_mu = adjustedr ///
						(sd) r2_sd = adjustedr ///
						(count) n = adjustedr, by(regname varname)
	
	gen 			r2_hi = r2_mu + invttail(n-1,0.025) * (r2_sd / sqrt(n))
	gen				r2_lo = r2_mu - invttail(n-1,0.025) * (r2_sd / sqrt(n))

* weather only and weather squared only
preserve
	keep			if regname == 1 | regname == 4
	keep			if varname > 14
	sort 			regname r2_mu 
	gen 			obs = _n	

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	varname + 6 + 2 - 14
	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Temperature Metric"

	sum			 	r2_hi
	global			bmax = r(max)
	
	sum			 	r2_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	31
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
		
	twoway 			scatter k1 k2 obs, xlab(0(4)18) xsize(10) ysize(6) msize(small small small) title("")	  ///
						ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Mean Daily Temp" 10 "Median Daily Temp" ///
						11 "Variance of Daily Temp" 12 "Skew of Daily Temp" ///
						13 "Growing Degree Days" 14 "Dev. in GDD" 15 "z-Score of GDD" ///
						16 "Max Daily Temp" 17 "*{bf:Temperature Metric}*" 31 " ", ///
						angle(0) labsize(vsmall) tstyle(notick)) || ///
						(scatter r2_mu obs, yaxis(2) mcolor(maroon) ///
						ylab(0(0.02)0.08, axis(2) labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2))) || ///
						(rbar r2_lo r2_hi obs, barwidth(.2) color(edkblue%40) yaxis(2) ), ///
						legend(order(3 4 5) cols(1) size(small) rowgap(.5) pos(12) ///
						label(3 "mean adjusted R{sup:2}") label(4 "95% C.I.") ) ///
						saving("$sfig/r2_reg1_reg4_tp", replace)	
restore


* weather FE and weather squared FE
preserve
	keep			if regname == 2 | regname == 5
	keep			if varname > 14
	sort 			regname r2_mu 
	gen 			obs = _n	

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	varname + 6 + 2 - 14
	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Temperature Metric"

	sum			 	r2_hi
	global			bmax = r(max)
	
	sum			 	r2_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	37
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
		
	twoway 			scatter k1 k2 obs, xlab(0(4)18) xsize(10) ysize(6) msize(small small small) title("")	  ///
						ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Mean Daily Temp" 10 "Median Daily Temp" ///
						11 "Variance of Daily Temp" 12 "Skew of Daily Temp" ///
						13 "Growing Degree Days" 14 "Dev. in GDD" 15 "z-Score of GDD" ///
						16 "Max Daily Temp" 17 "*{bf:Temperature Metric}*" 31 " ", ///
						angle(0) labsize(vsmall) tstyle(notick)) || ///
						(scatter r2_mu obs, yaxis(2) mcolor(maroon) ///
						ylab(0.06(0.02)0.14, axis(2) labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2))) || ///
						(rbar r2_lo r2_hi obs, barwidth(.2) color(edkblue%40) yaxis(2) ), ///
						legend(order(3 4 5) cols(1) size(small) rowgap(.5) pos(12) ///
						label(3 "mean adjusted R{sup:2}") label(4 "95% C.I.") ) ///
						saving("$sfig/r2_reg2_reg5_tp", replace)	
restore


* weather FE inputs and weather squared FE inputs
preserve
	keep			if regname == 3 | regname == 6
	keep			if varname > 14
	sort 			regname r2_mu 
	gen 			obs = _n	

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	varname + 6 + 2 - 14
	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Temperature Metric"

	sum			 	r2_hi
	global			bmax = r(max)
	
	sum			 	r2_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	37
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
		
	twoway 			scatter k1 k2 obs, xlab(0(4)18) xsize(10) ysize(6) msize(small small small) title("")	  ///
						ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Mean Daily Temp" 10 "Median Daily Temp" ///
						11 "Variance of Daily Temp" 12 "Skew of Daily Temp" ///
						13 "Growing Degree Days" 14 "Dev. in GDD" 15 "z-Score of GDD" ///
						16 "Max Daily Temp" 17 "*{bf:Temperature Metric}*" 31 " ", ///
						angle(0) labsize(vsmall) tstyle(notick)) || ///
						(scatter r2_mu obs, yaxis(2) mcolor(maroon) ///
						ylab(0.18(0.02)0.28, axis(2) labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2))) || ///
						(rbar r2_lo r2_hi obs, barwidth(.2) color(edkblue%40) yaxis(2) ), ///
						legend(order(3 4 5) cols(1) size(small) rowgap(.5) pos(12) ///
						label(3 "mean adjusted R{sup:2}") label(4 "95% C.I.") ) ///
						saving("$sfig/r2_reg3_reg6_tp", replace)	
restore	
	
* combine R^2 specification curves for satellite
	grc1leg2 		"$sfig/r2_reg1_reg4_tp.gph" "$sfig/r2_reg2_reg5_tp.gph"  ///
						"$sfig/r2_reg3_reg6_tp.gph", col(2) iscale(.5) ///
						ring(0) pos(5) holes(4) commonscheme
						
	graph export 	"$xfig\r2_tp.pdf", as(pdf) replace


* **********************************************************************
* 4 - select weather metrics to investigate
* **********************************************************************

* based on above analysis we will proceed with following rainfall metrics
	* mean rainfall
	* total rainfall
	* rainy days or % rainy days (choose one of these two)

* based on above analysis we will proceed with following temperature metrics
	* mean temperature
	* median temperature	
	

* **********************************************************************
* 4a - generate R^2 specification curves by rainfall satellite & model
* **********************************************************************

* load data 
	use 			"$root/lsms_complete_results", clear

* keep extraction 3	
	keep			if ext == 3
	keep			if varname == 1 | varname == 5 | varname == 8 | ///
						varname == 15 | varname == 16
	sort 			regname sat 

	collapse 		(mean) r2_mu = adjustedr ///
						(sd) r2_sd = adjustedr ///
						(count) n = adjustedr, by(regname varname sat)
	
	gen 			r2_hi = r2_mu + invttail(n-1,0.025) * (r2_sd / sqrt(n))
	gen				r2_lo = r2_mu - invttail(n-1,0.025) * (r2_sd / sqrt(n))

* weather only and weather squared only
preserve
	keep			if regname == 1 | regname == 4
	keep			if varname < 15
	sort 			sat r2_mu 
	gen 			obs = _n	

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	sat + 6 + 2
	gen				k3		=	varname + 6 + 6 + 2 + 2
	
	* subtract values of off k3 because of varname numbering
		replace			k3		=	18 if k3 == 21
		replace			k3		=	19 if k3 == 24

* label new variables	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Weather Product"
	lab 			var k3 "Rainfall Metric"

	sum			 	r2_hi
	global			bmax = r(max)
	
	sum			 	r2_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	30
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
		
	twoway 			scatter k1 k2 k3 obs, xlab(0(2)36) xsize(10) ysize(6) msize(small small small) title("")	  ///
						ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Rainfall 1" 10 "Rainfall 2" 11 "Rainfall 3" ///
						12 "Rainfall 4" 13 "Rainfall 5" 14 "Rainfall 6" ///
						15 "*{bf:Weather Product}*" 17 "Mean Daily Rain" ///
						18 "Total Seasonal Rain" 19 "Rainy Days" ///
						20 "*{bf:Rainfall Metric}*" 30 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter r2_mu obs, yaxis(2) mcolor(maroon) ///
						ylab( 0.00(0.01)0.07, axis(2) labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2))) || ///
						(rbar r2_lo r2_hi obs, barwidth(.2) color(edkblue%40) yaxis(2) ), ///
						legend(order(4 5) cols(1) size(small) rowgap(.5) pos(12) ///
						label(4 "mean adjusted R{sup:2}") label(5 "95% C.I.") ) ///
						saving("$sfig/r2_reg1_reg4_sat_rf", replace)	
restore

* weather FE and weather squared FE
preserve
	keep			if regname == 2 | regname == 5
	keep			if varname < 15
	sort 			sat r2_mu 
	gen 			obs = _n	

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	sat + 6 + 2
	gen				k3		=	varname + 6 + 6 + 2 + 2
	
	* subtract values of off k3 because of varname numbering
		replace			k3		=	18 if k3 == 21
		replace			k3		=	19 if k3 == 24

* label new variables	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Weather Product"
	lab 			var k3 "Rainfall Metric"

	sum			 	r2_hi
	global			bmax = r(max)
	
	sum			 	r2_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	30
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
		
	twoway 			scatter k1 k2 k3 obs, xlab(0(2)36) xsize(10) ysize(6) msize(small small small) title("")	  ///
						ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Rainfall 1" 10 "Rainfall 2" 11 "Rainfall 3" ///
						12 "Rainfall 4" 13 "Rainfall 5" 14 "Rainfall 6" ///
						15 "*{bf:Weather Product}*" 17 "Mean Daily Rain" ///
						18 "Total Seasonal Rain" 19 "Rainy Days" ///
						20 "*{bf:Rainfall Metric}*" 30 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter r2_mu obs, yaxis(2) mcolor(maroon) ///
						ylab(0.03(0.03)0.15 , axis(2) labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2))) || ///
						(rbar r2_lo r2_hi obs, barwidth(.2) color(edkblue%40) yaxis(2) ), ///
						legend(order(4 5) cols(1) size(small) rowgap(.5) pos(12) ///
						label(4 "mean adjusted R{sup:2}") label(5 "95% C.I.") ) ///
						saving("$sfig/r2_reg2_reg5_sat_rf", replace)	
restore


* weather FE inputs and weather squared FE inputs
preserve
	keep			if regname == 3 | regname == 6
	keep			if varname < 15
	sort 			sat r2_mu 
	gen 			obs = _n	

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	sat + 6 + 2
	gen				k3		=	varname + 6 + 6 + 2 + 2
	
	* subtract values of off k3 because of varname numbering
		replace			k3		=	18 if k3 == 21
		replace			k3		=	19 if k3 == 24

* label new variables	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Weather Product"
	lab 			var k3 "Rainfall Metric"

	sum			 	r2_hi
	global			bmax = r(max)
	
	sum			 	r2_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	30
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
		
	twoway 			scatter k1 k2 k3 obs, xlab(0(2)36) xsize(10) ysize(6) msize(small small small) title("")	  ///
						ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Rainfall 1" 10 "Rainfall 2" 11 "Rainfall 3" ///
						12 "Rainfall 4" 13 "Rainfall 5" 14 "Rainfall 6" ///
						15 "*{bf:Weather Product}*" 17 "Mean Daily Rain" ///
						18 "Total Seasonal Rain" 19 "Rainy Days" ///
						20 "*{bf:Rainfall Metric}*" 30 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter r2_mu obs, yaxis(2) mcolor(maroon) ///
						ylab(0.15(0.03)0.30 , axis(2) labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2))) || ///
						(rbar r2_lo r2_hi obs, barwidth(.2) color(edkblue%40) yaxis(2) ), ///
						legend(order(4 5) cols(1) size(small) rowgap(.5) pos(12) ///
						label(4 "mean adjusted R{sup:2}") label(5 "95% C.I.") ) ///
						saving("$sfig/r2_reg3_reg6_sat_rf", replace)	
restore	
	
* combine R^2 specification curves for satellite
	grc1leg2 		"$sfig/r2_reg1_reg4_sat_rf.gph" "$sfig/r2_reg2_reg5_sat_rf.gph"  ///
						"$sfig/r2_reg3_reg6_sat_rf.gph", col(2) iscale(.5) ///
						ring(0) pos(5) holes(4) commonscheme
						
	graph export 	"$xfig\r2_sat_rf.pdf", as(pdf) replace
		
	
* **********************************************************************
* 4a - generate R^2 specification curves by temperature satellite & model
* **********************************************************************


* weather only and weather squared only
preserve
	keep			if regname == 1 | regname == 4
	keep			if varname > 14
	sort 			sat r2_mu 
	gen 			obs = _n	

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	sat + 6 + 2
	gen				k3		=	varname + 6 + 6 + 2 + 2
	
	* subtract values of off k3 because of varname numbering
		replace			k2		=	9 if k2 == 15
		replace			k2		=	10 if k2 == 16
		replace			k2		=	11 if k2 == 17
		replace			k3		=	14 if k3 == 31
		replace			k3		=	15 if k3 == 32

* label new variables	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Weather Product"
	lab 			var k3 "Rainfall Metric"

	sum			 	r2_hi
	global			bmax = r(max)
	
	sum			 	r2_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	24
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
		
	twoway 			scatter k1 k2 k3 obs, xlab(0(1)12) xsize(10) ysize(6) msize(small small small) title("")	  ///
						ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Temperature 1" 10 "Temperature 2" 11 "Temperature 3" ///
						12 "*{bf:Weather Product}*" 14 "Mean Daily Temp" ///
						15 "Median Daily Temp" 16 "*{bf:Temperature Metric}*" ///
						24 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter r2_mu obs, yaxis(2) mcolor(maroon) ///
						ylab( 0.00(0.02)0.08, axis(2) labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2))) || ///
						(rbar r2_lo r2_hi obs, barwidth(.1) color(edkblue%40) yaxis(2) ), ///
						legend(order(4 5) cols(1) size(small) rowgap(.5) pos(12) ///
						label(4 "mean adjusted R{sup:2}") label(5 "95% C.I.") ) ///
						saving("$sfig/r2_reg1_reg4_sat_tp", replace)	
restore


* weather FE and weather squared FE
preserve
	keep			if regname == 2 | regname == 5
	keep			if varname > 14
	sort 			sat r2_mu 
	gen 			obs = _n	

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	sat + 6 + 2
	gen				k3		=	varname + 6 + 6 + 2 + 2
	
	* subtract values of off k3 because of varname numbering
		replace			k2		=	9 if k2 == 15
		replace			k2		=	10 if k2 == 16
		replace			k2		=	11 if k2 == 17
		replace			k3		=	14 if k3 == 31
		replace			k3		=	15 if k3 == 32

* label new variables	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Weather Product"
	lab 			var k3 "Rainfall Metric"

	sum			 	r2_hi
	global			bmax = r(max)
	
	sum			 	r2_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	24
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
		
	twoway 			scatter k1 k2 k3 obs, xlab(0(1)12) xsize(10) ysize(6) msize(small small small) title("")	  ///
						ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Temperature 1" 10 "Temperature 2" 11 "Temperature 3" ///
						12 "*{bf:Weather Product}*" 14 "Mean Daily Temp" ///
						15 "Median Daily Temp" 16 "*{bf:Temperature Metric}*" ///
						24 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter r2_mu obs, yaxis(2) mcolor(maroon) ///
						ylab( 0.03(0.03)0.15, axis(2) labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2))) || ///
						(rbar r2_lo r2_hi obs, barwidth(.1) color(edkblue%40) yaxis(2) ), ///
						legend(order(4 5) cols(1) size(small) rowgap(.5) pos(12) ///
						label(4 "mean adjusted R{sup:2}") label(5 "95% C.I.") ) ///
						saving("$sfig/r2_reg2_reg5_sat_tp", replace)	
restore


* weather FE inputs and weather squared FE inputs
preserve
	keep			if regname == 3 | regname == 6
	keep			if varname > 14
	sort 			sat r2_mu 
	gen 			obs = _n	

* stack values of the specification indicators
	gen 			k1 		= 	regname
	gen 			k2 		= 	sat + 6 + 2
	gen				k3		=	varname + 6 + 6 + 2 + 2
	
	* subtract values of off k3 because of varname numbering
		replace			k2		=	9 if k2 == 15
		replace			k2		=	10 if k2 == 16
		replace			k2		=	11 if k2 == 17
		replace			k3		=	14 if k3 == 31
		replace			k3		=	15 if k3 == 32

* label new variables	
	lab				var obs "Specification # - sorted by model & effect size"

	lab 			var k1 "Model"
	lab 			var k2 "Weather Product"
	lab 			var k3 "Rainfall Metric"

	sum			 	r2_hi
	global			bmax = r(max)
	
	sum			 	r2_lo
	global			bmin = r(min)
	
	global			brange	=	$bmax - $bmin
	global			from_y	=	$bmin - 2.5*$brange
	global			gheight	=	24
	  
	di $bmin
	di $brange
	di $from_y
	di $gheight
		
	twoway 			scatter k1 k2 k3 obs, xlab(0(1)12) xsize(10) ysize(6) msize(small small small) title("")	  ///
						ylab(0(1)$gheight ) ylabel(1 "Weather" ///
						2 "Weather + FE" 3 "Weather + FE + Inputs" ///
						4 "Weather + Weather{sup:2}" 5 "Weather + Weather{sup:2} + FE" /// 
						6 "Weather + Weather{sup:2} + FE + Inputs" 7 "*{bf:Model}*" ///
						9 "Temperature 1" 10 "Temperature 2" 11 "Temperature 3" ///
						12 "*{bf:Weather Product}*" 14 "Mean Daily Temp" ///
						15 "Median Daily Temp" 16 "*{bf:Temperature Metric}*" ///
						24 " ", angle(0) ///
						labsize(vsmall) tstyle(notick)) || ///
						(scatter r2_mu obs, yaxis(2) mcolor(maroon) ///
						ylab( 0.15(0.03)0.30, axis(2) labsize(tiny) angle(0) ) yscale(range($from_y $bmax ) axis(2))) || ///
						(rbar r2_lo r2_hi obs, barwidth(.1) color(edkblue%40) yaxis(2) ), ///
						legend(order(4 5) cols(1) size(small) rowgap(.5) pos(12) ///
						label(4 "mean adjusted R{sup:2}") label(5 "95% C.I.") ) ///
						saving("$sfig/r2_reg3_reg6_sat_tp", replace)	
restore	
	
* combine R^2 specification curves for satellite
	grc1leg2 		"$sfig/r2_reg1_reg4_sat_tp.gph" "$sfig/r2_reg2_reg5_sat_tp.gph"  ///
						"$sfig/r2_reg3_reg6_sat_tp.gph", col(2) iscale(.5) ///
						ring(0) pos(5) holes(4) commonscheme
						
	graph export 	"$xfig\r2_sat_tp.pdf", as(pdf) replace
	
	
* **********************************************************************
* 4 - end matter
* **********************************************************************


* close the log
	log	close

/* END */		