/**
 * @file	KCTerminalPreferenceView.swift
 * @brief	Define KCTerminalPreferenceView class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import CoconutData
#if os(OSX)
import Cocoa
#else
import UIKit
#endif

public class KCTerminalPreferenceView: KCStackView
{
	public typealias CallbackFunction = KCColorSelectorCore.CallbackFunction

	#if os(OSX)
	private var	mDocumentDirectoryField:	KCTextEdit?		= nil
	private var 	mHomeSelectButton:		KCButton?		= nil
	private var 	mHomeResetButton:		KCButton?		= nil
	#endif
	private var	mLogLevelMenu:			KCPopupMenu?		= nil
	private var	mTerminalWidthField:		KCTextEdit?		= nil
	private var	mTerminalHeightField:		KCTextEdit?		= nil
	private var	mFontLabel:			KCTextEdit?		= nil
	private var	mFontNameMenu:			KCPopupMenu?		= nil
	private var 	mFontSizeMenu:			KCPopupMenu?		= nil
	private var	mTextColorSelector:		KCColorSelector?	= nil
	private var	mBackgroundColorSelector:	KCColorSelector?	= nil

	private var	mFontNames:			Array<String>?		= nil
	private var 	mFontSizes:			Array<CGFloat>?		= nil

	private var 	mSystemListner:			Array<CNObserverDictionary.ListnerHolder> = []

	#if os(OSX)
	public override init(frame : NSRect){
		super.init(frame: frame) ;
		setupContext() ;
	}
	#else
	public override init(frame: CGRect){
		super.init(frame: frame) ;
		setupContext()
	}
	#endif

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		CNLog(logLevel: .error, message: "Not supported")
	}

	deinit {
		let spref = CNPreference.shared.systemPreference
		for holder in mSystemListner {
			spref.removeObserver(listnerHolder: holder)
		}
	}

	public convenience init(){
		#if os(OSX)
		let frame = NSRect(x: 0.0, y: 0.0, width: 160, height: 60)
		#else
		let frame = CGRect(x: 0.0, y: 0.0, width: 160, height: 60)
		#endif
		self.init(frame: frame)
	}

	private func setupContext() {
		/* Allocate parts vertically */
		super.axis = .vertical

		let fonts = CNFontManager.shared.availableFixedPitchFonts
		let sizes : Array<CGFloat> = [10.0, 12.0, 16.0, 20.0, 24.0]
		mFontNames = fonts
		mFontSizes = sizes

		/* Allocate labeled subviews */
		var subviews: Array<KCView> = []
		#if os(OSX)
			let homebox = allocateHomeDirectoryView()
			subviews.append(homebox)
		#endif
		let logbox  = allocateLogLevelView()
		let sizebox = allocateSizeSelectorView()
		let fontbox = allocateFontSelectorView(fonts: fonts, sizes: sizes)
		let colbox  = allocateColorSelectorView()
		subviews.append(contentsOf: [logbox, sizebox, fontbox, colbox])
		super.addArrangedSubViews(subViews: subviews)

		/* Set initial values */
		let termpref = CNPreference.shared.terminalPreference
		let userpref = CNPreference.shared.userPreference
		#if os(OSX)
		if let field = mDocumentDirectoryField {
			let url		= userpref.documentDirectory
			field.text	= url.path
		}
		#endif
		if let field = mTerminalWidthField {
			let num		= termpref.width
			field.text	= "\(num)"
		}
		if let field = mTerminalHeightField {
			let num		= termpref.height
			field.text	= "\(num)"
		}
		if let label = mFontLabel {
			label.text	= termpref.font.fontName
		}
		self.textColor		= termpref.foregroundTextColor
		self.backgroundColor	= termpref.backgroundTextColor

		/* Set actions */
		#if os(OSX)
		if let button = mHomeSelectButton {
			button.buttonPressedCallback = {
				() -> Void in
				URL.openPanel(title: "Select home directory", type: .Directory, extensions: [], callback: {
					(_ urlp: URL?) -> Void in
					if let url = urlp {
						if let field = self.mDocumentDirectoryField {
							field.text = url.path
						}
						/* Add to user preference */
						let userpref = CNPreference.shared.userPreference
						userpref.documentDirectory = url
						/* Add to bookmark */
						let bookpref = CNPreference.shared.bookmarkPreference
						bookpref.add(URL: url)
					}
				})
			}
		}
		if let button = mHomeResetButton {
			button.buttonPressedCallback = {
				() -> Void in
				/* Use default home */
				let url = URL(fileURLWithPath: NSHomeDirectory())
				if let field = self.mDocumentDirectoryField {
					field.text = url.path
				}
				let userpref = CNPreference.shared.userPreference
				userpref.documentDirectory = url
				/* Reset bookmark */
				let bookpref = CNPreference.shared.bookmarkPreference
				bookpref.clear()
			}
		}
		#endif
		if let menu = mLogLevelMenu {
			menu.callbackFunction = {
				(_ val: CNValue) -> Void in
				self.updateLogLevel(self.selectedLogLevel)
			}
		}
		if let field = mTerminalWidthField {
			field.callbackFunction = {
				(_ str: String) -> Void in
				if let val = Int(str) {
					let pref = CNPreference.shared.terminalPreference
					pref.width = val
				}
			}
		}
		if let field = mTerminalHeightField {
			field.callbackFunction = {
				(_ str: String) -> Void in
				if let val = Int(str) {
					let pref = CNPreference.shared.terminalPreference
					pref.height = val
				}
			}
		}
		if let menu = mFontNameMenu {
			menu.callbackFunction = {
				(_ val: CNValue) -> Void in
				self.updateFont(name: self.selectedFontName, size: self.selectedFontSize)
			}
		}
		if let menu = mFontSizeMenu {
			menu.callbackFunction = {
				(_ val: CNValue) -> Void in
				self.updateFont(name: self.selectedFontName, size: self.selectedFontSize)
			}
		}

		/* Observe interfaceStyle in the system preference */
		let spref = CNPreference.shared.systemPreference
		mSystemListner.append(
			spref.addObserver(forKey: CNSystemPreference.InterfaceStyleItem, listnerFunction: {
				(_ param: Any?) -> Void in
				CNExecuteInMainThread(doSync: false, execute: {
					() -> Void in
					let termpref = CNPreference.shared.terminalPreference
					if let sel = self.mTextColorSelector {
						sel.color = termpref.foregroundTextColor
					}
					if let sel = self.mBackgroundColorSelector {
						sel.color = termpref.backgroundTextColor
					}
				})
			})
		)
	}

	#if os(OSX)
	private func allocateHomeDirectoryView() -> KCLabeledStackView {
		let pathfield            = KCTextEdit()
		pathfield.isBold         = false
		pathfield.isEditable     = false
		pathfield.text           = "No home directory"
		mDocumentDirectoryField  = pathfield

		let selectbutton = KCButton()
		selectbutton.value = .text("Selet")
		mHomeSelectButton = selectbutton

		let resetbutton = KCButton()
		resetbutton.value = .text("Reset")
		mHomeResetButton = resetbutton

		let buttons = KCStackView()
		buttons.axis = .horizontal
		buttons.addArrangedSubViews(subViews: [selectbutton, resetbutton])

		let top = KCLabeledStackView()
		top.title = "Home directory"
		let content = top.contentsView
		content.axis = .vertical
		content.addArrangedSubViews(subViews: [pathfield, buttons])

		return top
	}
	#endif

	private func allocateLogLevelView() -> KCLabeledStackView {
		let top = KCLabeledStackView()
		top.title = "Log level"

		let logmenu = KCPopupMenu()
		var items: Array<KCPopupMenu.MenuItem> = []
		for i in CNConfig.LogLevel.min ... CNConfig.LogLevel.max {
			if let lvl = CNConfig.LogLevel(rawValue: i) {
				let newitem = KCPopupMenu.MenuItem(title: lvl.description, intValue: lvl.rawValue)
				items.append(newitem)
			} else {
				CNLog(logLevel: .error, message: "Invalid raw value for LogLevel")
			}
		}
		logmenu.addItems(items)
		mLogLevelMenu = logmenu

		let content = top.contentsView
		content.axis = .vertical
		content.addArrangedSubViews(subViews: [logmenu])

		return top
	}

	private func allocateSizeSelectorView() -> KCLabeledStackView {
		let widthfield = KCTextEdit()
		widthfield.isBold		= false
		widthfield.decimalPlaces	= 0
		widthfield.isEditable 		= true
		mTerminalWidthField		= widthfield

		let widthbox = KCLabeledStackView()
		widthbox.title = "width:"
		widthbox.contentsView.addArrangedSubView(subView: widthfield)

		let heightfield = KCTextEdit()
		heightfield.isBold		= false
		heightfield.decimalPlaces	= 0
		heightfield.isEditable 		= true
		mTerminalHeightField   		= heightfield

		let heightbox = KCLabeledStackView()
		heightbox.title = "height:"
		heightbox.contentsView.addArrangedSubView(subView: heightfield)

		let top = KCLabeledStackView()
		top.title = "Size"
		let content = top.contentsView
		content.axis = .horizontal
		content.addArrangedSubViews(subViews: [widthbox, heightbox])

		return top
	}

	private func allocateFontSelectorView(fonts fnts: Array<String>, sizes szs: Array<CGFloat>) -> KCLabeledStackView {
		let fontmenu = KCPopupMenu()
		fontmenu.addItems(fnts.map { KCPopupMenuCore.MenuItem(title: $0, value: .stringValue($0)) } )
		mFontNameMenu = fontmenu

		let fontbox = KCLabeledStackView()
		fontbox.title = "Name:"
		fontbox.contentsView.addArrangedSubView(subView: fontmenu)

		let sizemenu = KCPopupMenu()
		sizemenu.addItems(szs.map { KCPopupMenuCore.MenuItem(title: "\($0)", value: .numberValue(NSNumber(floatLiteral: Double($0))))} )
		mFontSizeMenu = sizemenu

		let sizebox = KCLabeledStackView()
		sizebox.title = "Size:"
		sizebox.contentsView.addArrangedSubView(subView: sizemenu)

		let top = KCLabeledStackView()
		top.title = "Font"
		let content = top.contentsView
		content.axis = .horizontal
		content.addArrangedSubViews(subViews: [fontbox, sizebox])

		return top
	}

	private func allocateColorSelectorView() -> KCLabeledStackView {
		/* Allocate text color selector */
		let textsel = KCColorSelector()
		textsel.color = CNPreference.shared.terminalPreference.foregroundTextColor
		textsel.callbackFunc = {
			(_ color: CNColor) -> Void in
			let pref = CNPreference.shared.terminalPreference
			pref.foregroundTextColor = color
		}
		let textbox = KCLabeledStackView()
		textbox.title = "Text:"
		textbox.contentsView.addArrangedSubView(subView: textsel)

		/* Add background color selector */
		let backsel = KCColorSelector()
		backsel.color = CNPreference.shared.terminalPreference.backgroundTextColor
		backsel.callbackFunc = {
			(_ color: CNColor) -> Void in
			let pref = CNPreference.shared.terminalPreference
			pref.backgroundTextColor = color
		}
		let backbox = KCLabeledStackView()
		backbox.title = "Background:"
		backbox.contentsView.addArrangedSubView(subView: backsel)

		let top = KCLabeledStackView()
		top.title = "Color"
		let content = top.contentsView
		content.axis = .horizontal
		content.addArrangedSubViews(subViews: [textbox, backbox])

		mTextColorSelector 		= textsel
		mBackgroundColorSelector	= backsel
		return top
	}

	private var selectedLogLevel: CNConfig.LogLevel { get {
		if let menu = mLogLevelMenu {
			if let val = menu.selectedValue() {
				if let num = val.toNumber() {
					if let lvl = CNConfig.LogLevel(rawValue: num.intValue) {
						return lvl
					}
				}
			}
		}
		CNLog(logLevel: .error, message: "Failed to get selected log level", atFunction: #function, inFile: #file)
		return .debug
	}}

	private var selectedFontName: String { get {
		if let menu = mFontNameMenu {
			if let val = menu.selectedValue() {
				if let str = val.toString() {
					return str
				}
			}
		}
		CNLog(logLevel: .error, message: "Failed to get selected font name", atFunction: #function, inFile: #file)
		if let names = mFontNames {
			return names[0]
		} else {
			return ""
		}
	}}

	private var selectedFontSize: CGFloat { get {
		if let menu = mFontSizeMenu {
			if let val = menu.selectedValue() {
				if let num = val.toNumber() {
					return CGFloat(num.doubleValue)
				}
			}
		}
		CNLog(logLevel: .error, message: "Failed to get selected font size", atFunction: #function, inFile: #file)
		if let sizes = mFontSizes {
			return sizes[0]
		} else {
			return 10.0
		}
	}}

	private var mPreviousFontName: String  = ""
	private var mPreviousFontSize: CGFloat = 0.0

	private func updateLogLevel(_ lvl: CNConfig.LogLevel) {
		let syspref = CNPreference.shared.systemPreference
		if syspref.logLevel != lvl {
			syspref.logLevel = lvl	// Update log level
		}
	}

	private func updateFont(name nm: String, size sz: CGFloat) {
		/* Suppress chattering */
		if nm != mPreviousFontName || sz != mPreviousFontSize {
			/* Update font */
			if let font  = CNFont(name: nm, size: sz) {
				let pref  = CNPreference.shared.terminalPreference
				pref.font = font
			}
			mPreviousFontName = nm
			mPreviousFontSize = sz
		}
	}

	public var textColor: CNColor {
		get		{ return getColor(from: mTextColorSelector)	  }
		set(newcol) 	{ setColor(to: mTextColorSelector, color: newcol) }
	}

	#if os(OSX)
	public var backgroundColor: CNColor? {
		get		{ return getColor(from: mBackgroundColorSelector)	}
		set(newcol) 	{ setColor(to: mBackgroundColorSelector, color: newcol)	}
	}
	#else
	public override var backgroundColor: CNColor? {
		get		{ return getColor(from: mBackgroundColorSelector)	}
		set(newcol) 	{
			setColor(to: mBackgroundColorSelector, color: newcol)
			super.backgroundColor = newcol
		}
	}
	#endif

	private func getColor(from selector: KCColorSelector?) -> CNColor {
		if let sel = selector {
			return sel.color
		} else {
			CNLog(logLevel: .error, message: "No selector")
			return CNColor.black
		}
	}

	private func setColor(to selector: KCColorSelector?, color col: CNColor?) {
		if let sel = selector, let colp = col {
			sel.color = colp
		}
	}
}
