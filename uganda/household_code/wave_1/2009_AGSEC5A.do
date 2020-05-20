clear all

*attempting to clean Uganda household variables
global user "themacfreezie"

**********************************************************************************
**	UNPS 2009 (Wave 1) - Agriculture Section 5A
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2009"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2009"

use "`root'/2009_AGSEC5A", clear

*	quantification of production. 1st visit

*	Unique identifier can only be generated with parcel, plot, and crop
describe
sort Hhid A5aq1 A5aq3 A5aq5
*	isid Hhid A5aq1 A5aq3 A5aq5, missok
*	The above is not identifying unique observations
*	First weird thing for Uganda
*	There seems to be reporting of quantities in different units of measure
*	See A5aq6a, A5aq6c, and A5aq6d (quantity, unit, conversion factor into kg)
*	What's weird is none of this is labelled (spelling?)
*	I also wonder why the sme household would be using different units to measure crop output from the same fields
*	isid Hhid A5aq1 A5aq3 A5aq5 A5aq6c, missok
*	Also the above still doesn't get the job done (including units of measure)
generate wgt_hvsted = (A5aq6a * A5aq6d)
tabulate wgt_hvsted, missing
tabulate A5aq6a, missing
tabulate A5aq6d, missing
replace wgt_hvsted = A5aq6a if A5aq6d == .	// assuming if conversion factor is missing quantity is given in kg
tabulate wgt_hvsted, missing
*	This will give a standardized weight in kilos. Maybe add them together for like crop_ids?
*	Still, as yet I've found no sensical combination of inputs that makes for a unique id

*	Create unique parcel identifier
generate parcel_id = Hhid + " " + string(A5aq1)
generate plot_id = Hhid + " " + string(A5aq1) + " " + string(A5aq3)
generate crop_id = Hhid + " " + string(A5aq1) + " " + string(A5aq3) + " " + string(A5aq5) 

*	Weight sold gets even weirder
*	See A5aq7a, A5aq7b, and A5aq7c (quantity, condition, and unit for harvest sold)
*	No conversion factor given!
*	Do I need to match conversion factors from A5aq6d with this variable?
*	We need weight harvested aand weight sold as well as value sold correct?
generate wgt_sold = A5aq7a * A5aq6d // assumed conv. factor for weight harvested was vaild for wgt_sold, as unit was not given for many wgt_sold obs
tabulate wgt_sold, missing
tabulate A5aq7a, missing
replace wgt_sold = A5aq7a if A5aq6d == . // assuming quantity is given in kg if conv factor missing
tabulate wgt_sold, missing

*	housekeeping
rename Hhid hhid 
rename A5aq8 crop_value

*which visit?
generate visit = 1

keep hhid parcel_id plot_id crop_id wgt_hvsted wgt_sold crop_value visit

*	Prepare for export
compress
describe
summarize 
sort crop_id
save "`export'/2009_AGSEC5A", replace
