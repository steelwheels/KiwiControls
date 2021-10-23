/*
 * @file	KCButtonCore.swift
 * @brief	Define KCButtonCore class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif
import CoconutData

public enum KCButtonSymbol {
	case leftArrow
	case rightArrow

	public var description: String { get {
		let result: String
		switch self {
		case .leftArrow:	result = "left-arrow"
		case .rightArrow:	result = "right-arrow"
		}
		return result
	}}
}

public enum KCButtonValue {
	case text(String)
	case symbol(KCButtonSymbol)
}

public class KCButtonCore: KCCoreView
{
	#if os(iOS)
	@IBOutlet weak var mButton: UIButton!
	#else
	@IBOutlet weak var mButton: KCButtonBody!
	#endif

	public var buttonPressedCallback: (() -> Void)? = nil

	private var mButtonValue:	KCButtonValue = .text("")

	public func setup(frame frm: CGRect) -> Void {
		super.setup(isSingleView: true, coreView: mButton)
		KCView.setAutolayoutMode(views: [self, mButton])
	}

	#if os(iOS)
	@IBAction func buttonPressed(_ sender: UIButton) {
		if let callback = buttonPressedCallback {
			callback()
		}
	}
	#else
	@IBAction func buttonPressed(_ sender: NSButton) {
		if let callback = buttonPressedCallback {
			callback()
		}
	}
	#endif

	public var value: KCButtonValue {
		get {
			return mButtonValue
		}
		set(newval){
			switch newval {
			case .text(let str):
				#if os(iOS)
					mButton.setTitle(str, for: .normal)
				#else
					mButton.title = str
					mButton.setButtonType(.momentaryPushIn)
					mButton.bezelStyle = .rounded
					mButton.imagePosition = .noImage
				#endif
			case .symbol(let sym):
				let img = loadSymbol(symbol: sym)
				#if os(OSX)
					mButton.bezelStyle = .regularSquare
					mButton.image = img
					mButton.imagePosition = .imageOnly
				#else
					mButton.setImage(img, for: .normal)
				#endif
			}
			mButtonValue = newval
		}
	}

	private func loadSymbol(symbol sym: KCButtonSymbol) -> CNImage {
		let type: CNSymbol.SymbolType
		switch sym {
		case .leftArrow:	type = .chevronBackward
		case .rightArrow:	type = .chevronForward
		}
		return CNSymbol.shared.load(symbol: type)
	}

	public var isEnabled: Bool {
		get {
			return mButton.isEnabled
		}
		set(newval){
			self.mButton.isEnabled   = newval
		}
	}
}

