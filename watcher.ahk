﻿#IfWinActive ahk_exe HOSMy.exe

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
		case "TDoctorWorkBenchVaccineEntryForm":
			CheckMouseHoverInVaccineClass(control)
			return
		case "TERDetailEntryForm":
			CheckMouseHoverOnEquipmentClass(control)
			return
		default:
			return
	}
}


CheckMouseHoverInVaccineClass(control){
	global isVaccineInEditMode, vaccine_preset
	if(!isVaccineInEditMode && control == "TcxButton9"){
		if(ApplyVaccinateInfoToGlobal()){
			SetVaccineDataToPreset(vaccine_preset)
		}
	}
	else if(!isVaccineInEditMode && control == "TcxButton10"){
		EmptyVaccineGlobalVar()
	}
	else if(isVaccineInEditMode && control == "TcxButton9"){
		EmptyVaccineGlobalVar()
	}
}

CheckMouseHoverOnEquipmentClass(control){
	global currentEquip, currentEquipDose
	if(control == "TcxButton10"){
		ValidateVaccine()
	}
}

#IfWinActive