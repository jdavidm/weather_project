*putting conversions by region into mergeable file
*feb 28 2020
*alj

use "C:\Users\aljosephson\Dropbox\Weather_Project\Data\Nigeria\analysis_datasets\Nigeria_raw\conversion_files\wave_3\ag_conv_w3.dta" 
drop crop_name unit_name
tab note
drop note
drop conv_national
gen zone = .
drop zone
rename conv_NC_1 conv1
rename conv_NE_2 conv2
rename conv_NW_3 conv3
rename conv_SE_4 conv4
rename conv_SS_5 conv5
rename conv_SW_6 conv6
reshape long conv, i( crop_cd unit_cd ) j(zone)

rename crop_cd cropcode
rename unit harv_unit

save "C:\Users\aljosephson\Dropbox\Weather_Project\Data\Nigeria\analysis_datasets\Nigeria_raw\conversion_files\wave_3\ag_conv_w3_long.dta", replace
