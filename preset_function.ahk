;vaccine_preset list located in global_vars.ahk 

PasteVaccinePreset(preset_list){
	KeyWait, Ctrl
	ControlFocus, TcxCustomInnerTextEdit1, ahk_class TDoctorWorkBenchVaccineEntryForm
	Send, % preset_list["dose_no"]
	ControlFocus, TcxCustomComboBoxInnerEdit3, ahk_class TDoctorWorkBenchVaccineEntryForm
	Send, % preset_list["lot_no"]
	ControlFocus, TcxCustomDropDownInnerEdit2, ahk_class TDoctorWorkBenchVaccineEntryForm
	Send, % preset_list["exp_date"]
	ControlFocus, TcxCustomComboBoxInnerEdit2, ahk_class TDoctorWorkBenchVaccineEntryForm
	Send, % preset_list["serial_no"]
	ControlGetText, vac_name, TcxCustomComboBoxInnerEdit4, ahk_class TDoctorWorkBenchVaccineEntryForm
	ControlFocus, TcxCustomComboBoxInnerEdit4, ahk_class TDoctorWorkBenchVaccineEntryForm
	if(vac_name != null){
		RemoveAllText()
	}
	Send, % preset_list["vac_name"]
}

SetVaccineDataToPreset(preset_list){
	ControlGetText, vaccine_name, TcxCustomComboBoxInnerEdit4, ahk_class TDoctorWorkBenchVaccineEntryForm
	ControlGetText, serial, TcxCustomComboBoxInnerEdit2, ahk_class TDoctorWorkBenchVaccineEntryForm
	ControlGetText, exp_date, TcxCustomDropDownInnerEdit2, ahk_class TDoctorWorkBenchVaccineEntryForm
	ControlGetText, lot, TcxCustomComboBoxInnerEdit3, ahk_class TDoctorWorkBenchVaccineEntryForm
	ControlGetText, dose, TcxCustomInnerTextEdit1, ahk_class TDoctorWorkBenchVaccineEntryForm
	preset_list["vac_name"] := vaccine_name
	preset_list["dose_no"] := dose
	preset_list["lot_no"] := lot
	preset_list["exp_date"] := exp_date
	preset_list["serial_no"] := serial
}