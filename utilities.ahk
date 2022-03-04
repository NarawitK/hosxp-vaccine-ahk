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