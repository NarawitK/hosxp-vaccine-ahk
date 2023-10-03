#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

#Include global_vars.ahk
#Include watcher.ahk
#Include keyboard_layout.ahk
#Include preset_function.ahk

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
dose := SetEquipmentDosage()
AddEquipmentF3(az_fn, dose)
return

!S::
currentEquip := sv_id
dose := SetEquipmentDosage()
AddEquipmentF3(sv_fn, dose)
return

!Z::
currentEquip := pf_id
dose := SetEquipmentDosage()
AddEquipmentF3(pf_fn, dose)
return

!C::
currentEquip := pf_id
dose := SetEquipmentDosage()
if(A_Language != "041e"){
	SetDefaultKeyboard(0x041e)
}
AddEquipmentF3(pfc_fn, dose)
SetDefaultKeyboard(0x0409)
return

; R is Pfizer Red Newly Added
!R::
currentEquip := pf_id
dose := SetEquipmentDosage()
AddEquipmentF3(pfr_fn, dose)
return

!P::
currentEquip := sp_id
dose := SetEquipmentDosage()
AddEquipmentF3(sp_fn, dose)
return

!M::
currentEquip := md_id
dose := SetEquipmentDosage()
AddEquipmentF3(md_fn, dose)
return

!X::
currentEquip := cvx_id
dose := SetEquipmentDosage()
AddEquipmentF3(cvx_fn, dose)

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

; R is Pfizer Red Newly Added
!R::
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

^D::
PasteVaccinePreset(vaccine_preset)
return

^S::
ControlFocus, TcxCustomComboBoxInnerEdit2, ahk_class TDoctorWorkBenchVaccineEntryForm
return

^T::	
FinishingVaccine(currentVac, vaccine_preset)
return

#IfWinActive

#Include validation.ahk
#Include core_function.ahk
#Include setter.ahk
#Include utilities.ahk