ValidateVaccine(){
	global currentEquip, currentEquipDose, currentVac, currentVacDose, isVaccineInEditMode
	global wrong_dose_msg, wrong_sn_msg, wrong_vac_msg, f3key_timeout_msg, vac_names
	invalid_flag := 0
	if(!isVaccineInEditMode && currentEquip == NULL && currentEquipDose == NULL && currentVac == NULL && currentVacDose == NULL){
		ChangeSendVaccineButtonState(False)
		ChangeFinishButtonState(False)
		invalid_flag++
	}
	
	if(!isVaccineInEditMode && currentVacDose != NULL && currentEquipDose != currentVacDose){
		ChangeSendVaccineButtonState(False)
		ChangeFinishButtonState(False)
		invalid_flag++
		msg := RandomMessageText(wrong_dose_msg)
		Msgbox, 8240, Invalid Dose Taken, % msg "`n" EmptyTextConverter(currentEquipDose) " กับ " EmptyTextConverter(currentVacDose), 5
	}

	if(!isVaccineInEditMode && currentEquip != currentVac){
		ChangeSendVaccineButtonState(False)
		ChangeFinishButtonState(False)
		invalid_flag++
		if(currentVac != NULL){
			msg := RandomMessageText(wrong_vac_msg)
			MsgBox, 8208, Vaccine not match, % msg "`n" EmptyTextConverter(vac_names[currentEquip]) " กับ " EmptyTextConverter(vac_names[currentVac]), 5			
		}
	}

	if(!ValidateSerial(currentVac, vac_names)){
		ChangeSendVaccineButtonState(False)
		ChangeFinishButtonState(False)
		invalid_flag++
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
				Switch StrLen(currentSerial)
				{
					case 14:
						validationResult := 1
					default:
						validationResult := 0
				}
			case 2, case 4:
				Switch StrLen(currentSerial)
				{
					case 20:
						validationResult := 1
					default:
						validationResult := 0
				}
			case 3:
				Switch StrLen(currentSerial)
				{
					case 6:
					case 9:
					case 12:
					case 14:
						validationResult := 1
					default:
						validationResult := 0
				}
			case 5:
				Switch StrLen(currentSerial)
				{
					case 10:
					case 14:
						validationResult := 1
					default:
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