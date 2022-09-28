;SubFunction of ValidateVaccine
ApplyVaccinateInfoToGlobal(){
	global az, sv, pf, sp, md, cvx, az_id, sv_id, pf_id, sp_id, md_id, cvx_id, currentVac
	ControlGetText, vaccine, TcxCustomComboBoxInnerEdit4, ahk_class TDoctorWorkBenchVaccineEntryForm
	if(InStr(vaccine, az, false)){
		currentVac := az_id	
	}
	else if(InStr(vaccine, sv)){
		currentVac := sv_id
	}
	else if(InStr(vaccine, pf)){
		currentVac := pf_id
	}
	else if(InStr(vaccine, sp)){
		currentVac := sp_id
	}
	else if(InStr(vaccine, md)){
		currentVac := md_id
	}
	else if(InStr(vaccine, cvx)){
		currentVac := cvx_id
	}
	ControlGetText, dose , TcxCustomInnerTextEdit1, ahk_class TDoctorWorkBenchVaccineEntryForm
	if(dose != NULL){
		global currentVacDose := dose
		return ValidateVaccine()
	}
}

DetermineEquipmentByRegEx(){
	ChangeFinishButtonState(False)
	global currentEquip, currentEquipDose, vac_names
	global az, sv, pf, pfc, sp, md, cvx
	global sv_id, az_id, pf_id, sp_id, md_id, cvx_id
	Sleep, 200
	ControlGetText, equip_text, TcxCustomInnerTextEdit9, ahk_class TERDetailEntryForm
	if(InStr(equip_text, sv)){
		currentEquip := sv_id
		SetEquipDosageFromRegex(equip_text)
	}
	else if(InStr(equip_text, az)){
		currentEquip := az_id
		SetEquipDosageFromRegex(equip_text)
	}
	else if(InStr(equip_text, pf) || InStr(equip_text, pfc)){
		currentEquip := pf_id
		SetEquipDosageFromRegex(equip_text)
	}
	else if(InStr(equip_text, sp)){
		currentEquip := sp_id
		SetEquipDosageFromRegex(equip_text)
	}
	else if(InStr(equip_text, md)){
		currentEquip := md_id
		SetEquipDosageFromRegex(equip_text)
	}
	else if(InStr(equip_text, cvx)){
		currentEquip := cvx_id
		SetEquipDosageFromRegex(equip_text)
	}
	else{
		if(currentEquip != NULL || currentEquipDose != NULL){
			currentEquip := NULL
			currentEquipDose := NULL
		}
		ControlClick, TcxButton13, ahk_class TERDetailEntryForm,, LEFT, 2, NA
	}
}

;SubFunc of "DetermineEquipmentByRegEx"
SetEquipDosageFromRegex(equip_text){
	global currentEquipDose
	if(RegExMatch(equip_text, "(?<=เข็ม )[1-9]", dosage) > 0){
		currentEquipDose := dosage
	}
}

ChangeFinishButtonState(state){
	if(state){
		Control, Enable,, TcxButton10, ahk_class TERDetailEntryForm
	}
	else{
		Control, Disable,, TcxButton10, ahk_class TERDetailEntryForm
	}
}

;Change Send Vaccinate Button in Vaccinate Screen
ChangeSendVaccineButtonState(state){
	if(state){
		Control, Enable,, TcxButton9, ahk_class TDoctorWorkBenchVaccineEntryForm
	}
	else{
		Control, Disable,, TcxButton9, ahk_class TDoctorWorkBenchVaccineEntryForm
	}
}

ToggleOnEditMode(){
	global isVaccineInEditMode := !isVaccineInEditMode
}

;Clear Global Variables
EmptyAllGlobalVar(){
	global currentEquip, currentEquipDose, currentVac,  currentVacDose, isVaccineInEditMode
	isVaccineInEditMode := false
	currentEquip := NULL
	currentEquipDose := NULL
	currentVac := NULL
	currentVacDose := NULL
}

EmptyEquipmentGlobalVar(){
	global currentEquip, currentEquipDose
	currentEquip := NULL
	currentEquipDose := NULL
}

EmptyVaccineGlobalVar(){
	global currentVac, currentVacDose
	currentVac := NULL
	currentVacDose := NULL
}