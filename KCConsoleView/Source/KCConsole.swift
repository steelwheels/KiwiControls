/**
* @file		KCConsole.h
* @brief	Define KCConsole class
* @par Copyright
*   Copyright (C) 2015 Steel Wheels Project
*/

import Foundation
import Canary

public class KCConsole : CNConsole
{
	private var consoleView : KCConsoleView
	private var is1stString : Bool
	
	public init(view: KCConsoleView){
		consoleView = view
		is1stString = true
		super.init()
	}
	
	public override func putString(str : String){
		var newstr : String
		if is1stString {
			newstr = indentString() + str
			is1stString = false
		} else {
			newstr = str
		}
		consoleView.appendText(newstr)
	}
	
	public override func putNewline(){
		consoleView.appendText("\n")
		is1stString = true
	}
	
}

