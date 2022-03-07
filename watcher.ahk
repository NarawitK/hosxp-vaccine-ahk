#IfWinActive ahk_exe HOSMy.exe

SetTimer, WatchCursor, 100

WatchCursor:
WatchAndValidate()
return

WatchAndValidate(){
	MouseGetPos,,, id, control
	WinGetTitle, title, ahk_id %id%
	WinGetClass, class, ahk_id %id%
	CheckEquipmentWindowExist()
	RecordVaccinationOperation(class, control)
	MouseHoverControlCheckByClass(class, control)
	;CheckMouseHover(class, control)
}

CheckEquipmentWindowExist(){
	global equipWindowExist
	if(!WinExist("ahk_class TERDetailEntryForm") && equipWindowExist){
		equipWindowExist := !equipWindowExist
		EmptyAllGlobalVar()
	}
	else if(WinExist("ahk_class TERDetailEntryForm") && !equipWindowExist){
		equipWindowExist := 1
	}
}

RecordVaccinationOperation(class, control){
	if(class == "TDoctorWorkBenchVaccineListEntryForm" && control == "TcxButton5"){
		global isVaccineInEditMode := 0
	}
	else if(class == "TDoctorWorkBenchVaccineListEntryForm" && control == "TcxButton4"){
		global isVaccineInEditMode := 1
	}
}

MouseHoverControlCheckByClass(class, control){
	switch class{
		case "TERDetailEntryForm":
			CheckMouseHoverOnEquipmentClass(control)
			return
		case "TDoctorWorkBenchVaccineEntryForm":
			CheckMouseHoverInVaccineClass(control)
			return
	}
}

CheckMouseHoverOnEquipmentClass(control){
	global currentEquip, currentEquipDose
	if(control == "TcxButton10"){
		ValidateVaccine()
	}
}
CheckMouseHoverInVaccineClass(control){
	global isVaccineInEditMode
	if(!isVaccineInEditMode && control == "TcxButton9"){
		ApplyVaccinateInfoToGlobal()
	}
	else if(!isVaccineInEditMode && control == "TcxButton10"){
		EmptyVaccineGlobalVar()
	}
	else if(isVaccineInEditMode && control == "TcxButton9"){
		EmptyVaccineGlobalVar()
	}
}

#IfWinActive