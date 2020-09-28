	loc		root1 	= 	"$data/weather_data/ethiopia/wave_1/refined"
	loc		root2 	= 	"$data/weather_data/ethiopia/wave_2/refined"
	loc		root3 	= 	"$data/weather_data/ethiopia/wave_3/refined"
	
	loc 		folderList : dir "`root1'" dirs "e*"
	foreach 	folder of local folderList {
	loc 		fileList : dir "`root1'/`folder'" files "*.dta"
	foreach 	file in `fileList' {	
	    
		display		"`root1'/`folder'/`file'"
		use 		"`root1'/`folder'/`file'", clear
		duplicates  report
		duplicates 	report household_id
		duplicates 	list household_id		
		display		"BREAK"
	}
	}
	
	loc 		folderList : dir "`root2'" dirs "e*"
	foreach 	folder of local folderList {
	loc 		fileList : dir "`root2'/`folder'" files "*.dta"
	foreach 	file in `fileList' {	
	    
		display		"`root2'/`folder'/`file'"
		use 		"`root2'/`folder'/`file'", clear
		duplicates  report
		duplicates 	report household_id2
		duplicates 	list household_id2		
		display		"BREAK"
	}
	}

	loc 		folderList : dir "`root3'" dirs "e*"
	foreach 	folder of local folderList {
	loc 		fileList : dir "`root3'/`folder'" files "*.dta"
	foreach 	file in `fileList' {	
	    
		display		"`root3'/`folder'/`file'"
		use 		"`root3'/`folder'/`file'", clear
		duplicates  report
		duplicates 	report household_id2
		duplicates 	list household_id2		
		display		"BREAK"
	}
	}