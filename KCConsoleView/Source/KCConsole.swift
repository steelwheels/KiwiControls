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
	private var mConsoleView : KCConsoleView

	public init(view: KCConsoleView){
		mConsoleView = view
		super.init()
	}

	public var consoleView: KCConsoleView {
		get { return mConsoleView }
	}
	
	public override func flush(text: CNConsoleText){
		mConsoleView.appendText(text)
	}
}

