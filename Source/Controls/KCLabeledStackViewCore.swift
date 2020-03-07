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
		let usize = KCUnionSize(sizeA: tsize, sizeB: ssize, doVertical: true, spacing: space)
		return KCSize(width: usize.width + space*2.0, height: usize.height + space)
	}

	open override var fittingSize: KCSize {
		get {
			#if os(OSX)
			let textsize  = mTextField.fittingSize
			let stacksize = mStackView.fittingSize
			#else
			let textsize  = mTextField.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
			let stacksize = mStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
			#endif
			return unionSizes(textSize: textsize, stackSize: stacksize)
		}
	}

	open override var intrinsicContentSize: KCSize {
		get {
			if hasFixedSize {
				return super.intrinsicContentSize
			} else {
				let textsize  = mTextField.intrinsicContentSize
				let stacksize = mStackView.intrinsicContentSize
				return unionSizes(textSize: textsize, stackSize: stacksize)
			}
		}
	}

	public override func setExpandability(holizontal holiz: KCViewBase.ExpansionPriority, vertical vert: KCViewBase.ExpansionPriority) {
		mTextField.setExpansionPriority(holizontal: holiz, vertical: .Fixed)
		mStackView.setExpandability(holizontal: holiz, vertical: vert)
		super.setExpandability(holizontal: holiz, vertical: vert)
	}

	open override func resize(_ size: KCSize) {
		#if os(OSX)
		var textsize = mTextField.fittingSize
		#else
		var textsize = mTextField.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
		#endif
		textsize.width = size.width

		let space = CNPreference.shared.windowPreference.spacing
		let stackheight = max(0.0, size.height - textsize.height - space)
		let stacksize   = KCSize(width: size.width, height: stackheight)

		mTextField.frame.size  = textsize
		mTextField.bounds.size = textsize
		mStackView.frame.size  = stacksize
		mStackView.bounds.size = stacksize

		super.resize(size)
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

	public func sizeToContain(size content: KCSize) -> KCSize {
		#if os(OSX)
		let textsize = mTextField.fittingSize
		#else
		let textsize = mTextField.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
		#endif
		let space    = CNPreference.shared.windowPreference.spacing
		let width    = max(textsize.width, content.width)
		let height   = textsize.height + space + content.height
		return KCSize(width: width, height: height)
	}
	
	public var contentsView: KCStackView {
		get { return mStackView }
	}
}

