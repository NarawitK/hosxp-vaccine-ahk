ValidateVaccine(){
	global currentEquip, currentEquipDose, currentVac, currentVacDose, isVaccineInEditMode
	global wrong_dose_msg, wrong_sn_msg, wrong_vac_msg, f3key_timeout_msg, vac_names
	invalid_flag := 0
	if(!isVaccineInEditMode && currentEquip == NULL && currentEquipDose == NULL && currentVac == NULL && currentVacDose == NULL){
		invalid_flag++
		ChangeSendVaccineButtonState(False)
		ChangeFinishButtonState(False)
	}
	
	if(!isVaccineInEditMode && currentVacDose != NULL && currentEquipDose != currentVacDose){
		invalid_flag++
		ChangeSendVaccineButtonState(False)
		ChangeFinishButtonState(False)
		msg := RandomMessageText(wrong_dose_msg)
		Msgbox, 8240, Invalid Dose Taken, % msg "`n" EmptyTextConverter(currentEquipDose) " กับ " EmptyTextConverter(currentVacDose), 5
	}

	if(!isVaccineInEditMode && currentEquip != currentVac){
		invalid_flag++
		ChangeSendVaccineButtonState(False)
		ChangeFinishButtonState(False)
		if(currentVac != NULL){
			msg := RandomMessageText(wrong_vac_msg)
			MsgBox, 8208, Vaccine not match, % msg "`n" EmptyTextConverter(vac_names[currentEquip]) " กับ " EmptyTextConverter(vac_names[currentVac]), 5			
		}
	}

	if(!ValidateSerial(currentVac, vac_names)){
		invalid_flag++
		ChangeSendVaccineButtonState(False)
		ChangeFinishButtonState(False)
		msg := RandomMessageText(wrong_sn_msg)
		MsgBox, 8208, Invalid Serial, %msg%, 5
	}

	if(invalid_flag){
		return 0
	}
	else{
		ChangeFinishButtonState(True)
		ChangeSendVaccineButtonState(True)
		return 1
	}
}

ValidateSerial(currentVac, vaccineNameArray){
	validationResult := 1
	if(WinActive("ahk_class TDoctorWorkBenchVaccineEntryForm")){
		ControlGetText, currentSerial, TcxCustomComboBoxInnerEdit2, ahk_class TDoctorWorkBenchVaccineEntryForm
		Switch currentVac
		{ 
			case 1:
				if(StrLen(currentSerial) != 14){
					validationResult := 0
				}
			case 2, case 4:
				if(StrLen(currentSerial) != 20){
					validationResult := 0
				}
			case 3:
				if(StrLen(currentSerial) != 9 && StrLen(currentSerial) != 12){
					validationResult := 0
				}
			case 5:
				if(StrLen(currentSerial) != 10 && StrLen(currentSerial) != 14){
					validationResult := 0
				}
		}		
	}
	return validationResult
}

ValidateGlobalVars(){
	global currentEquip, currentEquipDose, currentVac, currentVacDose
	valid_flag := 0
	if(currentEquip != NULL && currentEquipDose != NULL && currentVac != NULL && currentVacDose != NULL){
		valid_flag++
	}
	if(currentEquip != currentVac){
		valid_flag++
	}
	if(currentEquipDose != currentVacDose){
		valid_flag++
	}
	return valid_flag
}