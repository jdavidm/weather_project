clear all

*attempting to clean Uganda household variables
global user "themacfreezie"

**********************************************************************************
**	UNPS 2009 (Wave 1) - Agriculture Section 5B
**********************************************************************************

* For household data
loc root = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_raw\UGA_2009"
* To export results
loc export = "C:\Users/$user\Dropbox\Weather_Project\Data\Uganda\analysis_datasets\Uganda_refined\UGA_2009"

use "`root'/2009_AGSEC5B", clear

*	quantification of production. 2nd visit

*	Unique identifier can only be generated with parcel, plot, and crop
describe
sort Hhid A5bq1 A5bq3 A5bq5
*	isid Hhid A5bq1 A5bq3 A5bq5, missok
*	The above is not identifying unique observations
*	First weird thing for Uganda
*	There seems to be reporting of quantities in different units of measure
*	See A5bq6a, A5bq6c, and A5bq6d (quantity, unit, conversion factor into kg)
*	What's weird is none of this is labelled (spelling?)
*	I also wonder why the sme household would be using different units to measure crop output from the same fields
*	isid Hhid A5bq1 A5bq3 A5bq5 A5bq6c, missok
*	Also the above still doesn't get the job done (including units of measure)
generate wgt_hvsted = (A5bq6a * A5bq6d)
tabulate wgt_hvsted, missing
tabulate A5bq6a, missing
tabulate A5bq6d, missing
replace wgt_hvsted = A5bq6a if A5bq6d == .	// assuming if conversion factor is missing quantity is given in kg
tabulate wgt_hvsted, missing
*	This will give a standardized weight in kilos. Maybe add them together for like crop_ids?
*	Still, as yet I've found no sensical combination of inputs that makes for a unique id

*	Create unique parcel identifier
generate parcel_id = Hhid + " " + string(A5bq1)
generate plot_id = Hhid + " " + string(A5bq1) + " " + string(A5bq3)
generate crop_id = Hhid + " " + string(A5bq1) + " " + string(A5bq3) + " " + string(A5bq5) 

*	Weight sold gets even weirder
*	See A5bq7a, A5bq7b, and A5bq7c (quantity, condition, and unit for harvest sold)
*	No conversion factor given!
*	Do I need to match conversion factors from A5aq6d with this variable?
*	We need weight harvested aand weight sold as well as value sold correct?
generate wgt_sold = A5bq7a * A5bq6d
tabulate wgt_sold, missing
tabulate A5bq7a, missing
replace wgt_sold = A5bq7a if A5bq6d == . // assuming quantity is given in kg if conv factor missing
tabulate wgt_sold, missing
*	wgt_sold is only missing ~30 obs more than A5bq7a

*	housekeeping
rename Hhid hhid 
rename A5bq8 crop_value

*which visit?
generate visit = 2

keep hhid parcel_id plot_id crop_id wgt_hvsted wgt_sold crop_value visit

*	Prepare for export
compress
describe
summarize 
sort crop_id
save "`export'/2009_AGSEC5B", replace
