/**
 * @file	KCTextFieldCore.swift
 * @brief	Define KCTextFieldCore class
 * @par Copyright
 *   Copyright (C) 2016-2017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData

open class KCTextFieldCore : KCView
{
	public enum FormatterType {
		case general
		case decimal
	}

	#if os(OSX)
	@IBOutlet weak var mTextField: NSTextField!
	#else
	@IBOutlet weak var mTextField: UILabel!
	#endif

	public func setup(frame frm: CGRect){
		self.rebounds(origin: KCPoint.zero, size: frm.size)

		mTextField.translatesAutoresizingMaskIntoConstraints = false
		mTextField.autoresizesSubviews = true

		#if os(OSX)
			mTextField.usesSingleLineMode 		= false
			mTextField.isBezeled			= false
			mTextField.maximumNumberOfLines		= 1
			mTextField.lineBreakMode		= .byTruncatingMiddle

			if let cell = mTextField.cell {
				cell.wraps		= true
				cell.isScrollable	= false
			}
		#endif
	}

	public func set(format form: FormatterType){
		#if os(OSX)
		switch form {
		case .general:
			mTextField.formatter = nil
		case .decimal:
			let numformatter = NumberFormatter()
			numformatter.numberStyle           = .decimal
			numformatter.maximumFractionDigits = 0
			numformatter.minimumFractionDigits = 0
			mTextField.formatter = numformatter
		}
		#endif
	}

	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		return mTextField.sizeThatFits(size)
	}

	open override var fittingSize: KCSize {
		get {
			#if os(OSX)
				return mTextField.fittingSize
			#else
				return mTextField.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
			#endif
		}
	}

	open override var intrinsicContentSize: KCSize {
		get {
			if hasFixedSize {
				return super.intrinsicContentSize
			} else {
				return mTextField.intrinsicContentSize
			}
		}
	}
	
	open override func resize(_ size: KCSize) {
		let width   = min(mTextField.frame.size.width,  size.width)
		let newsize = KCSize(width: width, height: size.height)
		mTextField.preferredMaxLayoutWidth = width
		mTextField.frame.size  = newsize
		mTextField.bounds.size = newsize
		super.resize(newsize)
	}

	public var isEnabled: Bool {
		get {
			return mTextField.isEnabled
		}
		set(newval){
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					myself.mTextField.isEnabled   = newval
				}
			})
		}
	}

	public var text: String {
		get {
			return getText()
		}
		set(newval) {
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					myself.setText(label: newval)
				}
			})
		}
	}

	private func getText() -> String {
		#if os(OSX)
			return mTextField.stringValue
		#else
			if let t = mTextField.text {
				return t
			} else {
				return ""
			}
		#endif
	}

	private func setText(label str:String){
		CNExecuteInMainThread(doSync: false, execute: {
			[weak self] () -> Void in
			if let myself = self {
				#if os(OSX)
					myself.mTextField.stringValue = str
				#else
					myself.mTextField.text = str
				#endif
			}
		})
	}

	public var font: CNFont? {
		get {
			return mTextField.font
		}
		set(font){
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					myself.mTextField.font = font
				}
			})
		}
	}

	public var textColor: KCColor? {
		get 		{ return mTextField.textColor }
		set(newcol)	{
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					#if os(OSX)
						myself.mTextField.textColor = newcol
					#else
						myself.mTextField.tintColor = newcol
					#endif
				}
			})
		}
	}

	#if os(OSX)
	public var backgroundColor: KCColor? {
		get 		{ return mTextField.backgroundColor }
		set(newcol)	{ setBackgroundColor(color: newcol) }
	}
	#else
	public override var backgroundColor: KCColor? {
		get 		{ return mTextField.backgroundColor }
		set(newcol)	{ setBackgroundColor(color: newcol) }
	}
	#endif

	private func setBackgroundColor(color col: KCColor?) {
		#if os(OSX)
		CNExecuteInMainThread(doSync: false, execute: {
			[weak self]  () -> Void in
			if let myself = self {
				myself.mTextField.backgroundColor = col
				myself.mTextField.drawsBackground = true
			}
		})
		#else
		super.backgroundColor = col
		#endif
	}

	public var alignment: NSTextAlignment {
		get {
			#if os(iOS)
				return mTextField.textAlignment
			#else
				return mTextField.alignment
			#endif
		}
		set(align){
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					#if os(iOS)
						myself.mTextField.textAlignment = align
					#else
						myself.mTextField.alignment = align
					#endif
				}
			})
		}
	}

	public var lineBreak: KCLineBreakMode {
		get {
			return mTextField.lineBreakMode
		}
		set(mode) {
			mTextField.lineBreakMode = mode
		}
	}
}
