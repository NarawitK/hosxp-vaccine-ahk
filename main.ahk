; #NoTrayIcon
#NoEnv
#SingleInstance Force

; 0 = Add, 1 = Edit
isVaccineInEditMode := false
equipWindowExist := false

currentEquip := NULL
currentEquipDose := NULL
currentVac := NULL
currentVacDose:= NULL

; Equipment Name
az_fn := "COVID-19 AstraZeneca"
sv_fn := "CORONAVAC"
pf_fn := "COVID-19 Pfizer"
sp_fn := "COVID-19 Sinopharm"
md_fn := "COVID-19 Moderna"
pfc_fn := "COVID-19 Pfizer เด็ก 5ปี ถึง<12ปี"

az_id := 1
sv_id := 2
pf_id := 3
sp_id := 4
md_id := 5

az := "Astrazeneca"
sv := "Sinovac"
pf := "Pfizer"
sp := "Sinopharm"
md := "Moderna"
;pfc := "Pfizer (เด็กอายุ 5-11 ปี)"

vac_names := ["Astrazeneca", "Sinovac", "Pfizer", "Sinopharm", "Moderna"]

f3key_timeout_msg := ["กดปุ่มตัวเลขไม่ทันในช่วงเวลาที่กำหนดไว้"]
wrong_dose_msg := ["ครั้งที่ฉีดไม่ตรงกับที่คีย์ในเวชภัณฑ์","แค่ฉีดโดสไหนยังกรอกไม่ถูก คงนานๆเหมือนถูกหวยซักครั้ง", "ครั้งที่ฉีดไม่ถูก กลับไปดูใหม่"]
wrong_sn_msg := ["Serial ไม่ถูกต้อง",  "สวัสดี  Serial ไม่ถูก ใจลอยหรือ"]
wrong_vac_msg := ["วัคซีนตรงกันหรือเปล่า ?", "คีย์วัคซีนให้ตรงกันมันยากตรงไหน", "วัคซีน F3 อย่าง วัคซีนก็อีกอย่าง"]

SetTimer, WatchCursor, 100

WatchCursor:
WatchAndValidate()
return

WatchAndValidate(){
	MouseGetPos,,, id, control
	WinGetTitle, title, ahk_id %id%
	WinGetClass, class, ahk_id %id%
	CheckEquipmentWindowExist()
	RecordVaccinationOperation(control, class)
	CheckMouseHover(control, class)
}

CheckEquipmentWindowExist(){
	global equipWindowExist
	if(!WinExist("ahk_class TERDetailEntryForm") && equipWindowExist){
		equipWindowExist := !equipWindowExist
		EmptyAllGlobalVar()
	}
	else{
		equipWindowExist := 1
	}
}

RecordVaccinationOperation(control, class){
	if(class == "TDoctorWorkBenchVaccineListEntryForm" && control == "TcxButton5"){
		global isVaccineInEditMode := 0
	}
	else if(class == "TDoctorWorkBenchVaccineListEntryForm" && control == "TcxButton4"){
		global isVaccineInEditMode := 1
	}
}

CheckMouseHover(control, class){
	global isVaccineInEditMode
	if(isVaccineInEditMode && control == "TcxButton10" && class == "TERDetailEntryForm"){
		ValidateVaccine()
	}
	else if(!isVaccineInEditMode && control == "TcxButton10" && class == "TERDetailEntryForm"){
		ValidateVaccine()
	}
	else if(isVaccineInEditMode && control == "TcxButton9" && class == "TDoctorWorkBenchVaccineEntryForm"){
		EmptyVaccineGlobalVar()
	}
	else if(!isVaccineInEditMode && control == "TcxButton9" && class == "TDoctorWorkBenchVaccineEntryForm"){
		ApplyVaccinateInfoToGlobal()
	}
	else if(!isVaccineInEditMode && control == "TcxButton10" && class == "TDoctorWorkBenchVaccineEntryForm"){
		EmptyVaccineGlobalVar()
	}
}


SetDefaultKeyboard(LocaleID){
	Static SPI_SETDEFAULTINPUTLANG := 0x0409, SPIF_SENDWININICHANGE := 2
	
	Lan := DllCall("LoadKeyboardLayout", "Str", Format("{:08x}", LocaleID), "Int", 0)
	VarSetCapacity(binaryLocaleID, 4, 0)
	NumPut(LocaleID, binaryLocaleID)
	DllCall("SystemParametersInfo", "UInt", SPI_SETDEFAULTINPUTLANG, "UInt", 0, "UPtr", &binaryLocaleID, "UInt", SPIF_SENDWININICHANGE)
	
	WinGet, windows, List
	Loop % windows {
		PostMessage 0x50, 0, % Lan, , % "ahk_id " windows%A_Index%
	}
}

#IfWinActive ahk_class TERDetailEntryForm
^F1::
ControlFocus, TdxPickEdit7, ahk_class TERDetailEntryForm
SendInput,{Down 2}{Enter}3{Enter}n{Enter 2}1{Enter}{F2}{Tab 15}
return

^F2::
SendInput,{Tab 11}U119{Enter}1{Enter}{F3}
return

^E:: ToggleOnEditMode()

^S::
ControlClick, TcxButton10, ahk_class TERDetailEntryForm,, LEFT, 1, NA
Sleep, 200
Send, {Enter}
return

!A::
currentEquip := az_id
AddEquipmentF3(az_fn)
return

!S::
currentEquip := sv_id
AddEquipmentF3(sv_fn)
return

!Z::
currentEquip := pf_id
AddEquipmentF3(pf_fn)
return

!C::
currentEquip := pf_id
if(A_Language != "041e"){
	SetDefaultKeyboard(0x041e)
}
AddEquipmentF3(pfc_fn)
SetDefaultKeyboard(0x0409)
return

!P::
currentEquip := sp_id
AddEquipmentF3(sp_fn)
return

!M::
currentEquip := md_id
AddEquipmentF3(md_fn)
return

#IfWinActive

;Extra Work from HOSXP

#IfWinActive ahk_class TFindAllItemDialog
~Enter:: DetermineEquipmentByRegEx()
~LButton:: DetermineEquipmentByRegEx()
#IfWinActive

#IfWinActive ahk_class TDoctorWorkBenchVaccineListEntryForm

^A::
ControlClick, TcxButton5, ahk_class TDoctorWorkBenchVaccineListEntryForm,, LEFT, 1, NA
isVaccineInEditMode := 0
return

^E::
ControlClick, TcxButton4, ahk_class TDoctorWorkBenchVaccineListEntryForm,, LEFT, 1, NA
isVaccineInEditMode := 1
return

^X::
ControlClick, TcxButton6, ahk_class TDoctorWorkBenchVaccineListEntryForm,, LEFT, 1, NA
return

#IfWinActive


#IfWinActive ahk_class TDoctorWorkBenchVaccineEntryForm
!A::
currentVac := az_id
InsertVaccine(az)
return

!S::
currentVac := sv_id
InsertVaccine(sv)
return

!Z::
currentVac := pf_id
InsertVaccine(pf)
return

!C::
currentVac := pf_id
InsertVaccine(pf)
return

!P::
currentVac := sp_id
InsertVaccine(sp)
return

!M::
currentVac := md_id
InsertVaccine(md)
return

^S::
ControlFocus, TcxCustomComboBoxInnerEdit2, ahk_class TDoctorWorkBenchVaccineEntryForm
return

^T::	
FinishingVaccine()
return
#IfWinActive

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
	SendInput,^{a}{BackSpace}
	SendInput,%name%
	SendInput,{Down}{Enter}
	Sleep, 1700
	LotTextBoxFocus()
}

InsertDose(dose){
	ControlFocus, TcxCustomInnerTextEdit1, ahk_class TDoctorWorkBenchVaccineEntryForm
	Send,%dose%
	LotTextBoxFocus()
}

LotTextBoxFocus(){
	ControlFocus, TcxCustomComboBoxInnerEdit3, ahk_class TDoctorWorkBenchVaccineEntryForm
}

FinishingVaccine(){
	KeyWait, Alt
	ControlFocus, TcxButton3, ahk_class TDoctorWorkBenchVaccineEntryForm
	Send,{Enter}
	ControlFocus, TcxDBCheckBox2, ahk_class TDoctorWorkBenchVaccineEntryForm
	Send,{Space}
	ControlFocus, TcxButton2, ahk_class TDoctorWorkBenchVaccineEntryForm
	Send,{Space}
	if(ApplyVaccinateInfoToGlobal()){ 
		ControlFocus, TcxButton9, ahk_class TDoctorWorkBenchVaccineEntryForm
		Send, {Enter}
	}
	else{
		return
	}
}

ValidateVaccine(){
	global currentEquip, currentEquipDose, currentVac, currentVacDose, isVaccineInEditMode
	global wrong_dose_msg, wrong_sn_msg, wrong_vac_msg, f3key_timeout_msg, vac_names
	invalid_flag := 0
	ControlGetText, currentLot, TcxCustomComboBoxInnerEdit3, ahk_class TDoctorWorkBenchVaccineEntryForm
	if(currentLot == NULL){
		invalid_flag++
		ChangeSendVaccineButtonState(False)
		ChangeFinishButtonState(False)
		MsgBox, 8208, Lot is empty,ไหน Lot, 5
	}
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
		MsgBox, 8208,Invalid Serial, %msg%, 5
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

RandomMessageText(array_of_text){
	maxIndex := array_of_text.Length()
	Random, index, 1, % maxIndex
	return array_of_text[index]
}

EmptyTextConverter(text){
	if(text != NULL)
		return text
	else
		return "..."
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
				if(StrLen(currentSerial) != 9 AND StrLen(currentSerial) != 12){
					validationResult := 0
				}
			case 5:
				if(StrLen(currentSerial) != 10){
					validationResult := 0
				}
		}		
	}
	return validationResult
}

DetermineFinishBtnStateOnEqScr(){
	if(ValidateGlobalVars()){
		ChangeFinishButtonState(True)
	}
	else{
		ChangeFinishButtonState(False)
	}

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

;SubFunction of ValidateVaccine
ApplyVaccinateInfoToGlobal(){
	global az, sv, pf, sp, md, pfc 
	global az_id, sv_id, pf_id, sp_id, md_id, currentVac
	ControlGetText, vaccine, TcxCustomComboBoxInnerEdit4, ahk_class TDoctorWorkBenchVaccineEntryForm
	if(InStr(vaccine, az, false)){
		currentVac := az_id	
	}
	else if(InStr(vaccine, sv)){
		currentVac := sv_id
	}
	else if(InStr(vaccine, pf) || InStr(vaccine, pfc)){
		currentVac := pf_id
	}
	else if(InStr(vaccine, sp)){
		currentVac := sp_id
	}
	else if(InStr(vaccine, md)){
		currentVac := md_id
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
	global sv_id, az_id, pf_id, sp_id, md_id
	Sleep, 200
	ControlGetText, equip_text, TcxCustomInnerTextEdit9, ahk_class TERDetailEntryForm
	if(InStr(equip_text, "CORONAVAC")){
		currentEquip := sv_id
		SetEquipDosageFromRegex(equip_text)
	}
	else if(InStr(equip_text, "AstraZeneca")){
		currentEquip := az_id
		SetEquipDosageFromRegex(equip_text)
	}
	; Pfizer Orange Label will be added here
	else if(InStr(equip_text, "Pfizer") || InStr(equip_text, "Pfizer (เด็ก")){
		currentEquip := pf_id
		SetEquipDosageFromRegex(equip_text)
	}
	else if(InStr(equip_text, "Sinopharm")){
		currentEquip := sp_id
		SetEquipDosageFromRegex(equip_text)
	}
	else if(InStr(equip_text, "Moderna")){
		currentEquip := md_id
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

;Type: Utilities

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