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

	public init(view: KCConsoleView){
		consoleView = view
		super.init()
	}
	
	public override func flushLine(line : String, attribute : Dictionary<String, AnyObject>?){
		if let attr = attribute {
			consoleView.appendTextWithAttributes(line + "\n", attribute: attr)
		} else {
			consoleView.appendText(line + "\n")
		}
	}
}

