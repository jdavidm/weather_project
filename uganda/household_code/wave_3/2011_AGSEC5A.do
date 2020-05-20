clear all

*attempting to clean Uganda household variables
global user "themacfreezie"

**********************************************************************************
**	UNPS 2011 (Wave 3) - Agriculture Section 5A 
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2011"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2011"

use "`root'/2011_AGSEC5A", clear

*	quantification of production. 1st visit

*	Unique identifier can only be generated with parcel, plot, and crop
describe
sort HHID parcelID plotID cropID
*	isid HHID parcelID plotID cropID, missok
*	The above is not identifying unique observations
*	There seems to be reporting of quantities in different units of measure
*	See a5aq6a, a5aq6c, and a5aq6d (quantity, unit, conversion factor into kg)
*	What's weird is none of this is labelled (spelling?)
*	I also wonder why the sme household would be using different units to measure crop output from the same fields
*	isid HHID parcelID plotID cropID a5aq6c, missok
*	Also the above still doesn't get the job done (including units of measure)
generate wgt_hvsted = a5aq6a * a5aq6d
tabulate wgt_hvsted, missing
tabulate a5aq6a, missing
tabulate a5aq6d, missing
replace wgt_hvsted = a5aq6a if a5aq6d == .	// assuming if conversion factor is missing quantity is given in kg
tabulate wgt_hvsted, missing
*	This will give a standardized weight in kilos. Maybe add them together for like crop_ids?
*	Still, as yet I've found no sensical combination of inputs that makes for a unique id

tostring HHID, generate(hhid) format(%016.0f) force
duplicates report hhid parcelID plotID cropID

*	Create unique parcel identifier
generate parcel_id = hhid + " " + string(parcelID)
generate plot_id = hhid + " " + string(parcelID) + " " + string(plotID)
generate crop_id = hhid + " " + string(parcelID) + " " + string(plotID) + " " + string(cropID) 

*	Weight sold gets even weirder
*	See a5aq7a, a5aq7b, and a5aq7c (quantity, condition, and unit for harvest sold)
*	No conversion factor given!
*	Do I need to match conversion factors from a5aq6d with this variable?
*	We need weight harvested and weight sold as well as value sold correct?
generate wgt_sold = a5aq7a * a5aq6d
tabulate wgt_sold, missing
tabulate a5aq7a, missing
replace wgt_sold = a5aq7a if a5aq6d == . // assuming quantity is given in kg if conv factor missing
tabulate wgt_sold, missing

*	housekeeping
rename a5aq8 crop_value
rename a5aq6e hvst_month

*which visit?
generate visit = 1

keep hhid parcel_id plot_id crop_id wgt_hvsted wgt_sold crop_value hvst_month visit

*	Prepare for export
compress
describe
summarize 
sort crop_id
save "`export'/2011_AGSEC5A", replace
