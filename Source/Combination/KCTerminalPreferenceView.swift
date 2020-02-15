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

	private var	mFontLabel:			KCTextField?		= nil
	private var	mFontNameMenu:			KCPopupMenu?		= nil
	private var 	mFontSizeMenu:			KCPopupMenu?		= nil
	private var	mTextColorSelector:		KCColorSelector?	= nil
	private var	mBackgroundColorSelector:	KCColorSelector?	= nil

	private var	mFontNames:			Array<String>?		= nil
	private var 	mFontSizes:			Array<CGFloat>?		= nil

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
		NSLog("Not supported")
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

		var sizestrs: Array<String> = []
		for size in sizes {
			sizestrs.append("\(size)")
		}
		let fontbox = allocateFontSelectorView(fonts: fonts, sizes: sizestrs)
		let colbox  = allocateColorSelectorView()
		super.addArrangedSubViews(subViews: [fontbox, colbox])

		/* Set initial values */
		let pref = CNPreference.shared.terminalPreference
		if let font = pref.font {
			if let label = mFontLabel {
				label.text = font.fontName
			}
		}
		if let col = pref.foregroundTextColor {
			self.textColor = col
		}
		if let col = pref.backgroundTextColor {
			self.backgroundColor = col
		}

		/* Set actions */
		if let menu = mFontNameMenu {
			menu.callbackFunction = {
				(_ index: Int, _ namep: String?) -> Void in
				self.updateFont(indexOfName: index, indexOfSize: self.indexOfSelectedFontSize)
			}
		}
		if let menu = mFontSizeMenu {
			menu.callbackFunction = {
				(_ index: Int, _ namep: String?) -> Void in
				self.updateFont(indexOfName: self.indexOfSelectedFontName, indexOfSize: index)
			}
		}
	}

	private func allocateFontSelectorView(fonts fnts: Array<String>, sizes szs: Array<String>) -> KCStackView {
		/* Title */
		let title = KCTextField()
		title.text = "Font"

		let fontlabel = KCTextField()
		fontlabel.text = "Name:"

		let fontmenu = KCPopupMenu()
		fontmenu.addItems(withTitles: fnts)
		mFontNameMenu = fontmenu

		let sizelabel = KCTextField()
		sizelabel.text = "Size:"

		let sizemenu = KCPopupMenu()
		sizemenu.addItems(withTitles: szs)
		mFontSizeMenu = sizemenu

		/* Bind items */
		let fontbox = KCStackView()
		fontbox.axis = .horizontal
		fontbox.addArrangedSubViews(subViews: [fontlabel, fontmenu, sizelabel, sizemenu])

		let box = KCStackView()
		box.axis = .vertical
		box.addArrangedSubViews(subViews: [title, fontbox])
		return box
	}

	private func allocateColorSelectorView() -> KCStackView {
		/* Title */
		let title = KCTextField()
		title.text = "Colors"

		/* Add text color selector */
		let textsel = KCColorSelector()
		textsel.setLabel(string: "Text:")
		textsel.callbackFunc = {
			(_ color: KCColor) -> Void in
			let pref = CNPreference.shared.terminalPreference
			pref.foregroundTextColor = color
		}
		mTextColorSelector = textsel

		/* Add backlight color selector */
		let backsel = KCColorSelector()
		backsel.setLabel(string: "Background:")
		backsel.callbackFunc = {
			(_ color: KCColor) -> Void in
			let pref = CNPreference.shared.terminalPreference
			pref.backgroundTextColor = color
		}
		mBackgroundColorSelector = backsel

		/* Bind selectors */
		let colbox = KCStackView()
		colbox.axis = .horizontal
		colbox.addArrangedSubViews(subViews: [textsel, backsel])

		let box = KCStackView()
		box.axis = .vertical
		box.addArrangedSubViews(subViews: [title, colbox])
		return box
	}

	private var indexOfSelectedFontName: Int {
		get {
			if let menu = mFontNameMenu {
				return menu.indexOfSelectedItem
			} else {
				return 0
			}
		}
	}

	private var indexOfSelectedFontSize: Int {
		get {
			if let menu = mFontSizeMenu {
				return menu.indexOfSelectedItem
			} else {
				return 0
			}
		}
	}

	private var mPreviousNameIndex: Int = -1
	private var mPreviousSizeIndex: Int = -1

	private func updateFont(indexOfName iname: Int, indexOfSize isize: Int) {
		if let names = mFontNames, let sizes = mFontSizes {
			/* Suppress chattering */
			if iname != mPreviousNameIndex || isize != mPreviousSizeIndex {
				let name = names[iname]
				let size = sizes[isize]
				//NSLog("Update font: \(name)@\(size)")

				/* Update font */
				let font  = CNFont(name: name, size: size)
				let pref  = CNPreference.shared.terminalPreference
				pref.font = font

				mPreviousNameIndex = iname
				mPreviousSizeIndex = isize
			}
		}
	}

	public var textColor: KCColor {
		get		{ return getColor(from: mTextColorSelector)	  }
		set(newcol) 	{ setColor(to: mTextColorSelector, color: newcol) }
	}

	#if os(OSX)
	public var backgroundColor: KCColor? {
		get		{ return getColor(from: mBackgroundColorSelector)	}
		set(newcol) 	{ setColor(to: mBackgroundColorSelector, color: newcol)	}
	}
	#else
	public override var backgroundColor: KCColor? {
		get		{ return getColor(from: mBackgroundColorSelector)	}
		set(newcol) 	{
			setColor(to: mBackgroundColorSelector, color: newcol)
			super.backgroundColor = newcol
		}
	}
	#endif

	private func getColor(from selector: KCColorSelector?) -> KCColor {
		if let sel = selector {
			return sel.color
		} else {
			NSLog("No selector")
			return KCColor.black
		}
	}

	private func setColor(to selector: KCColorSelector?, color col: KCColor?) {
		if let sel = selector, let colp = col {
			sel.color = colp
		}
	}
}
