/**
 * @file	KCLabeledStackViewCore.swift
 * @brief Define KCLabeledStackViewCore class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData

open class KCLabeledStackViewCore : KCView
{
	#if os(OSX)
	@IBOutlet weak var mTextField: NSTextField!
	@IBOutlet weak var mStackView: KCStackView!
	#else
	@IBOutlet weak var mTextField: UILabel!
	@IBOutlet weak var mStackView: KCStackView!
	#endif

	public func setup(frame frm: CGRect) -> Void {
		KCView.setAutolayoutMode(views: [self, mTextField, mStackView])
		self.title = "Title"
	}

	private func unionSizes(textSize tsize: KCSize, stackSize ssize: KCSize) -> KCSize {
		let space = CNPreference.shared.windowPreference.spacing
		return KCUnionSize(sizeA: tsize, sizeB: ssize, doVertical: true, spacing: space)
	}

	open override var intrinsicContentSize: KCSize {
		get {
			let textsize  = mTextField.intrinsicContentSize
			let stacksize = mStackView.intrinsicContentSize
			return unionSizes(textSize: textsize, stackSize: stacksize)
		}
	}

	public override func invalidateIntrinsicContentSize() {
		super.invalidateIntrinsicContentSize()
		mTextField.invalidateIntrinsicContentSize()
		mStackView.invalidateIntrinsicContentSize()
	}

	public override func setExpandability(holizontal holiz: KCViewBase.ExpansionPriority, vertical vert: KCViewBase.ExpansionPriority) {
		mTextField.setExpansionPriority(holizontal: holiz, vertical: .fixed)
		mStackView.setExpandability(holizontal: holiz, vertical: vert)
		super.setExpandability(holizontal: holiz, vertical: vert)
	}

	public var title: String {
		get {
			#if os(OSX)
				return mTextField.stringValue
			#else
				if let title = mTextField.text {
					return title
				} else {
					return ""
				}
			#endif
		}
		set(newstr){
			#if os(OSX)
				mTextField.stringValue = newstr
			#else
				mTextField.text = newstr
			#endif
		}
	}
	
	public var contentsView: KCStackView {
		get { return mStackView }
	}

	public var labelView: KCLabel {
		get { return mTextField }
	}
}

