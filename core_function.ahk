AddEquipmentF3(name){
	KeyWait, Alt
	Input, dose, L1 T3
	if(dose == NULL || ErrorLevel = "Timeout"){
		MsgBox, 8240, Equipment Hotkey Timeout,ไม่รู้จะเลือกเข็มไหนงั้นเหรอ... กลับไปมองกระดาษสิ, 5
		return
	}
	ControlFocus, TcxCustomInnerTextEdit9, ahk_class TERDetailEntryForm
	Send, {BackSpace}{BackSpace}
	if(dose == 1){
		Send,%name%
		Sleep, 250
		Send,{Enter}0
	}
	else{
		times := dose-1
		Send,%name%
		Sleep, 250
		Send, {Down %times%}{Enter}0
	}
	global currentEquipDose := dose
	Sleep, 300
	ControlClick, TcxButton14, ahk_class TERDetailEntryForm, เพิ่ม, LEFT, 1, NA
	Sleep, 300
	ControlClick, TcxButton2 , ahk_class TERDetailEntryForm, Vaccine, LEFT, 1, NA
}

InsertVaccine(name){
	KeyWait, Alt
	Input, dose, L1 T3
	InsertDose(dose)
	ControlFocus, TcxCustomComboBoxInnerEdit4, ahk_class TDoctorWorkBenchVaccineEntryForm
	RemoveAllText()
	SendInput,%name%
	SendInput,{Down}{Enter}
	Sleep, 1700
	LotTextBoxFocus()
}

InsertDose(dose){
	ControlFocus, TcxCustomInnerTextEdit1, ahk_class TDoctorWorkBenchVaccineEntryForm
	Send, %dose%
	LotTextBoxFocus()
}

LotTextBoxFocus(){
	ControlFocus, TcxCustomComboBoxInnerEdit3, ahk_class TDoctorWorkBenchVaccineEntryForm
}

FinishingVaccine(currentVac, vaccine_preset){
	KeyWait, Alt
	ControlFocus, TcxButton3, ahk_class TDoctorWorkBenchVaccineEntryForm
	Send,{Enter}
	ControlFocus, TcxDBCheckBox2, ahk_class TDoctorWorkBenchVaccineEntryForm
	Send,{Space}
	ControlFocus, TcxButton2, ahk_class TDoctorWorkBenchVaccineEntryForm
	Send,{Space}
	if(ApplyVaccinateInfoToGlobal()){
		SetVaccineDataToPreset(vaccine_preset)
		ControlFocus, TcxButton9, ahk_class TDoctorWorkBenchVaccineEntryForm
		SendInput, {Enter}
	}
	else{
		return
	}
}

DetermineFinishBtnStateOnEqScr(){
	if(ValidateGlobalVars()){
		ChangeFinishButtonState(True)
	}
	else{
		ChangeFinishButtonState(False)
	}
}