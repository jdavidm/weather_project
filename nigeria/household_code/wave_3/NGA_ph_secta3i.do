* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Edited by: ek
* Stata v.16

* does
	* reads in Nigeria, WAVE 3, POST HARVEST, NIGERIA SECTA3i 
	* determines harvest information (area and quantity) and that maize is the second most widely cultivated crop///
	* outputs clean data file ready for combination with wave 3 hh data

* assumes
	* customsave.ado
	* land-conversion.dta conversion file
	
* other notes: 
	* still includes some notes from Alison Conley's work in spring 2020
	
* TO DO:
	* this has info regarding harvest, but the info provided is different from previous waves
	*Cannot identify what isnt merging. identify what isn't merging when converting harvest quantities

	
* **********************************************************************
* 0 - setup
* **********************************************************************

	* set global user
		global user 	"emilk"
	
	* define paths	
		loc 	root 	= 	"G:/My Drive/weather_project/household_data/nigeria/wave_3/raw"
		loc 	export 	= 	"G:/My Drive/weather_project/household_data/nigeria/wave_3/refined"
		loc 	logout 	= 	"G:/My Drive/weather_project/household_data/nigeria/logs"
	
	* open log	
		log 	using		 "`logout'/ph_secta1", append

* **********************************************************************
* 1 - determine area harvested
* **********************************************************************
		
	* import the first relevant data file
		use 	"`root'/secta3i_harvestw3", clear 	

		describe
		sort hhid plotid cropid
		isid hhid plotid cropid, missok
	*rename the important variables to match the variable names in pervious waves: harvested
		rename 				sa3iq3 	harvested

		label 				variable harvested "in the last visit you indicated you had planted crop on plot. Did you harvest this crop on plot during this season?"

	*rename the important variables to match the variable names in pervious waves: harvest month	
		rename 				sa3iq4a1 	harv_month

	*rename the important variables to match the variable names in pervious waves: harvest year
		rename 				sa3iq4a2 	harv_yr

* **********************************************************************
* 2 - conversions  
* **********************************************************************

	*area harvested needs to be converted to standard units
		gen 			crop_area = sa3iq5a
		rename 			sa3iq5b 	area_unit
		tab 			area_unit

	*redefine paths for conversion 
		loc 		root	=	"G:/My Drive/weather_project/household_data/nigeria/conversion_files"
	
	***Make the match. Everything Matched
		merge	 	m:1 	zone using 	"`root'/land-conversion" 



		drop 		_merge


	*converting land area
	***all converted appropriately (comparison of tabbed units to changes made)
		gen 		crop_area_hec 	= 	. 
		replace 	crop_area_hec 	= 	crop_area*heapcon 	if 		area_unit==1
		replace 	crop_area_hec 	= 	crop_area*ridgecon 	if 		area_unit==2
		replace 	crop_area_hec 	= 	crop_area*standcon 	if 		area_unit==3
		replace 	crop_area_hec 	= 	crop_area*plotcon 	if 		area_unit==4
		replace 	crop_area_hec 	= 	crop_area*acrecon 	if 		area_unit==5
		replace 	crop_area_hec 	= 	crop_area*sqmcon 	if 		area_unit==7
		replace 	crop_area_hec 	= 	crop_area 			if 		area_unit==6
		label 		variable crop_area_hec 		"land area of crop harvested since last unit, converted to hectares"


	*this part was not included in previous waves: survey question - percent of plot area harvested
		rename 		sa3iq5c 	portion_plot
		label 		variable 	portion_plot 		"% of plot area harvested"

	*survey: how much did you harvest during this ag season?
		gen 		harvestq = sa3iq6i
		rename 		sa3iq6ii 	harv_unit

	*redefine paths for conversion 
		loc 	root	=	"G:/My Drive/weather_project/household_data/nigeria/conversion_files/wave_3"

	*convert harvest quantities
		merge 		m:1 	zone cropcode harv_unit using	"`root'/ag_conv_w3_long" 


	*converting harvest quantities to kgs
		gen 	harv_kg 	=	 harvestq*conv
	
*missing bin/basket (10) of cassava, kolabut, cocoyam
*missing paint rubber(11) of poil palm, cashew
*missing milk cup (12) of ogbono, agbono
*missing congo small of agbono
*missing congo large of cashew nut, cocoa tree, cassava
*missing mudu (30) small of kola nut
*bowl medium (71) of cassava
*bowl large of cassava
*(82) piece large of sugar cane
*(90) small heap of plantain and agbono
*heap medium (91) of plantain, banana, palm tree
*heap medium yam, 
*small and medium bunch oil palm, small bunch palm tree
*medium stalk (111) cassava
*sack bag (130) yam, 132 of ogbono, yam, water yam, 
*mudu large (31) cassava
*132 of banana, small basket 140 of pear, oil palm
*150 basin small of kolanut
*cassava pick up (180)

	*Maize is the second most widely grown crop 12% of all crops grown are maize. Cassava is most widely cropped but we cannot use cassava as our crop in analysis. So we include this round and measure harvest output by maize
	gen 		cp_hrv 	= 	harv_kg 	if 		cropcode	 == 	1080
	order 		harvestq 	harv_unit 	conv harv_kg
	drop	 	_merge


* **********************************************************************
* 3 - value of harvest 
* **********************************************************************

	rename 		sa3iq6a 	tf_hrv


* **********************************************************************
* 4 - end matter, clean up to save
* **********************************************************************

	*3565 variable and do not have hhid so we drop those 3565 observations
		drop 	if		hhid==.

		keep 	hhid /// 
				zone ///
				state ///
				lga ///
				sector ///
				ea ///
				hhid ///
				plotid ///
				cropid ///
				cropcode ///
				tf_hrv ///
				cp_hrv //
	

		compress
		describe
		summarize 

	*save file
		customsave , idvar(hhid) filename("ph_secta3i.dta") ///
		path("`export'/`folder'") dofile(ph_secta3i) user($user)

*close the log
		log	close

/* END */