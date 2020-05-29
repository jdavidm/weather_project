* Project: WB Weather
* Created on: May 2020
* Created by: alj
* Edited by: ek
* Stata v.16

* does
	* reads in Nigeria, WAVE 3, (2015-2016) POST HARVEST, NIGERIA SECTA3i
	* determines harvest information (area and quantity) and that maize is the second most widely cultivated crop///
	* outputs clean data file ready for combination with wave 3 hh data

	* WILL WANT TO DROP INFORMATION ON LAND AREA

* assumes
	* customsave.ado
	* land-conversion.dta conversion file

* other notes:
	* still includes some notes from Alison Conley's work in spring 2020

* TO DO:
	* this has info regarding harvest, but the info provided is different from previous waves
	* cannot identify what isnt merging. identify what isn't merging when converting harvest quantities
	* make this do file look more like wave 2 NGA_ph_secta3.do file


* **********************************************************************
* 0 - setup
* **********************************************************************

	* define paths
		loc 	root		= 	"$data/household_data/nigeria/wave_3/raw"
		loc		cnvrt		=		"$data/household_data/nigeria/conversion_files"
		loc 	export 	= 	"$data/household_data/nigeria/wave_3/refined"
		loc 	logout 	= 	"$data/household_data/nigeria/logs"

	* open log
		log 	using		"`logout'/ph_secta1", append

* **********************************************************************
* 1 - determine area harvested
* **********************************************************************

* import the first relevant data file
		use 					"`root'/secta3i_harvestw3", clear

		describe
		sort 				hhid plotid cropid
		isid 				hhid plotid cropid, missok

* rename the important variables to match the variable names in pervious waves: harvested
		rename 				sa3iq3 	harvested
		lab var				harvested "Did you harvest this crop on plot during this season?"

* rename the important variables to match the variable names in pervious waves: harvest month
		rename 				sa3iq4a1 	harv_month

* rename the important variables to match the variable names in pervious waves: harvest year
		rename 				sa3iq4a2 	harv_yr

* **********************************************************************
* 2 - conversions
* **********************************************************************

* area harvested needs to be converted to standard units
		gen 				crop_area = sa3iq5a
		rename 				sa3iq5b 	area_unit
		tab 				area_unit

* dropping observations from households that did not harvest

		tab harvested
		
		drop if harvested == 2
		
		*check for missing quantity and value
		mdesc 			 sa3iq6ii sa3iq6a
		*** 45 missing value, 22 missing quantity
		
		*drop if missing both value and quantity
		drop if sa3iq6ii==. & sa3iq6a==.
		*** 18 observations deleted
		
		drop if sa3iq6ii==. & sa3iq6a==0
		*** 3 observations deleted
		
		count if sa3iq6a==.
		*** 27 observations have a weight harvested but no value
		
		count if sa3iq6ii==.
		*** 1 observation has no weight but a value harvested

	
* merge in land converstion
		merge	 	m:1 	zone using 	"`cnvrt'/land-conversion"
		*** All observations matched

		keep 				if 	_merge == 3
		drop 					_merge

* converting land area
		gen 				crop_area_hec 	= 	.
		replace 			crop_area_hec 	= 	crop_area*heapcon	if 		area_unit == 1
		replace 			crop_area_hec 	= 	crop_area*ridgecon	if 		area_unit == 2
		replace 			crop_area_hec 	= 	crop_area*standcon	if 		area_unit == 3
		replace 			crop_area_hec 	= 	crop_area*plotcon	if 		area_unit == 4
		replace 			crop_area_hec 	= 	crop_area*acrecon	if 		area_unit == 5
		replace 			crop_area_hec 	= 	crop_area*sqmcon	if 		area_unit == 7
		replace 			crop_area_hec 	= 	crop_area			if 		area_unit == 6
		lab var				crop_area_hec 	"land area of crop harvested in hectares"
		*** all converted appropriately (comparison of tabbed units to changes made)

* this part was not included in previous waves: survey question - percent of plot area harvested
		rename 				sa3iq5c 	portion_plot
		lab var				portion_plot 		"% of plot area harvested"

* survey: how much did you harvest during this ag season?
		gen 					harvestq = sa3iq6i
		label var 					harvestq "quantity harvested not in standardized units"
		rename 					sa3iq6ii 	harv_unit
		
		rename 					sa3iq6a tf_hrv
		replace 				tf_hrv=tf_hrv/224.5642303
		label var					tf_hrv "total value of harvest in 2016 US$"
		*** value comes from World Bank: world_bank_exchange_rates.xlxs
		
		
* merge in conversion for harvest quantities
		merge 				m:1 zone cropcode harv_unit using	"`cnvrt'/wave_3/ag_conv_w3_long"
		*** 1,188 did not match from master , 3,565 did not match from using  
		*** matching failed because "`cnvrt'/wave_3/ag_conv_w3_long" is incomplete
   
   * drop unmerged using
	drop if				_merge == 2
	* dropped 3,565

* check into 1,188 unmatched from master
	tab 				harv_unit if _merge == 1
	mdesc				harv_unit if _merge == 1


		keep 					if _merge == 3
		drop 					_merge

* converting harvest quantities to kgs
		gen 					harv_kg 	=	 harvestq*conv
		*** missing the following
				* bin/basket (10) of cassava, kolabut, cocoyam
				* paint rubber(11) of poil palm, cashew
				* milk cup (12) of ogbono, agbono
				* congo small of agbono
				* congo large of cashew nut, cocoa tree, cassava
				* mudu (30) small of kola nut
				* bowl medium (71) of cassava
				* bowl large of cassava
				* (82) piece large of sugar cane
				* (90) small heap of plantain and agbono
				* heap medium (91) of plantain, banana, palm tree
				* heap medium yam,
				* small and medium bunch oil palm, small bunch palm tree
				* medium stalk (111) cassava
				* sack bag (130) yam, 132 of ogbono, yam, water yam,
				* mudu large (31) cassava
				* 132 of banana, small basket 140 of pear, oil palm
				* 150 basin small of kolanut
				* cassava pick up (180)
		*** how many are missing as a percentage of total?

		* generate new variable that measures maize (1080) harvest
		gen 					cp_hrv 	= 	harv_kg 	if 		cropcode	 == 	1080
		order 				harvestq 	harv_unit 	conv harv_kg
		*** maize is the second most widely grown crop 12% of all crops grown are maize
		*** cassava is most widely cropped but we cannot use cassava since it is continuously cropped


* **********************************************************************
* 3 - value of harvest
* **********************************************************************

		rename 				sa3iq6a 	tf_hrv
		*** need to convert to constant 2010 USD

* **********************************************************************
* 4 - end matter, clean up to save
* **********************************************************************

* drop variables without household ids
		drop 				if	hhid==.
		*** 3565 are dropped

		keep 				hhid zone state lga sector ea hhid plotid cropid cropcode ///
								tf_hrv cp_hrv

		compress
		describe
		summarize

* save file
		customsave , idvar(hhid) filename("ph_secta3i.dta") ///
			path("`export'/`folder'") dofile(ph_secta3i) user($user)

* close the log
		log	close

/* END */
