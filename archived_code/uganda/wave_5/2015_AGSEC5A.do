clear all

*attempting to clean Uganda household variables
global user "themacfreezie"

**********************************************************************************
**	UNPS 2015 (Wave 5) - Agriculture Section 5A
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2015"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2015"

use "`root'/2015_AGSEC5A", clear

*	quantification of production. 1st visit

*	Unique identifier can only be generated with parcel, plot, and crop
describe
sort HHID parcelID plotID cropID
*	isid HHID parcelID plotID cropID, missok
*	The above is not identifying unique observations
*	There seems to be reporting of quantities in different units of measure
*	See a5aq6a, a5aq6b, and a5aq6d (quantity, unit, conversion factor into kg)
*	What's weird is none of this is labelled (spelling?)
*	I also wonder why the same household would be using different units to measure crop output from the same fields
*	isid HHID parcelID plotID cropID a5aq6b, missok
*	Also the above still doesn't get the job done (including units of measure)

*	Create unique parcel identifier
generate parcel_id = HHID + " " + string(parcelID)
generate plot_id = HHID + " " + string(parcelID) + " " + string(plotID)
generate crop_id = HHID + " " + string(parcelID) + " " + string(plotID) + " " + string(cropID) 

*	Looking at weight harvested
generate wgt_hvsted = a5aq6a * a5aq6d
tabulate wgt_hvsted, missing
tabulate a5aq6a, missing
tabulate a5aq6d, missing
replace wgt_hvsted = a5aq6a if a5aq6d == .	// assuming if conversion factor is missing quantity is given in kg
tabulate wgt_hvsted, missing
*	This will give a standardized weight in kilos. Maybe add them together for like crop_ids?
*	Still, as yet I've found no sensical combination of inputs that makes for a unique id

*	Weight sold gets even weirder
*	See a5aq7a, a5aq7b, and a5aq7c (quantity, condition, and unit for harvest sold)
*	No conversion factor given!
*	Do I need to match conversion factors from a5aq6d with this variable?
*	We need weight harvested and weight sold as well as value sold correct?
generate wgt_sold = a5aq7a * A5AQ7D
tabulate wgt_sold, missing
tabulate a5aq7a, missing
replace wgt_sold = a5aq7a if A5AQ7D == . // assuming quantity is given in kg if conv factor missing
tabulate wgt_sold, missing

*	housekeeping
rename HHID hhid
rename a5aq8 crop_value
rename a5aq6e hvst_month

keep hhid parcel_id plot_id crop_id wgt_hvsted wgt_sold crop_value hvst_month

*	Prepare for export
compress
describe
summarize 
sort crop_id
save "`export'/2015_AGSEC5A", replace
