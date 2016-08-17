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

	public init(view v: KCConsoleView){
		mConsoleView = v
		super.init()
	}

	public var fontSize: CGFloat {
		get {
			return mConsoleView.fontSize
		}
		set(size){
			mConsoleView.fontSize = size
		}
	}
	
	public var foregroundColor: NSColor? {
		get {
			return mConsoleView.foregroundColor
		}
		set(color){
			mConsoleView.foregroundColor = color
		}
	}
	
	public var backgroundColor: NSColor? {
		get {
			return mConsoleView.backgroundColor
		}
		set(color){
			mConsoleView.backgroundColor = color
		}
	}
	
	public override func flush(text t: CNConsoleText){
		mConsoleView.appendText(text: t)
	}
}

