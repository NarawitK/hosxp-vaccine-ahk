RemoveAllText(){
    SendInput, ^a{BackSpace}
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

SetEquipmentDosage(){
	KeyWait, Alt
	Input, dose, L1 T3
	if(dose == NULL || ErrorLevel = "Timeout"){
		MsgBox, 8240, Equipment Hotkey Timeout,ไม่รู้จะเลือกเข็มไหนงั้นเหรอ... กลับไปมองกระดาษสิ, 5
		return
	}
	return dose
}