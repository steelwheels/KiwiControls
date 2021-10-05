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

open class KCLabeledStackViewCore : KCCoreView
{
	#if os(OSX)
	@IBOutlet weak var mTextField: NSTextField!
	@IBOutlet weak var mStackView: KCStackView!
	#else
	@IBOutlet weak var mTextField: UILabel!
	@IBOutlet weak var mStackView: KCStackView!
	#endif

	private var 	mMinWidth:	Int = 100

	public func setup(frame frm: CGRect) -> Void {
		super.setup(isSingleView: false, coreView: mStackView)
		KCView.setAutolayoutMode(views: [self, mTextField, mStackView])
		self.title = "Title"
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

	open func addArrangedSubViews(subViews vs:Array<KCView>){
		mStackView.addArrangedSubViews(subViews: vs)
	}

	open func addArrangedSubView(subView v: KCView){
		mStackView.addArrangedSubView(subView: v)
	}

	open func arrangedSubviews() -> Array<KCView> {
		return mStackView.arrangedSubviews()
	}

	open override func setFrameSize(_ newsize: KCSize) {
		super.setFrameSize(newsize)

		/* Decide label size */
		let newlabheight: CGFloat
		if newsize.height > mTextField.frame.height {
			newlabheight = mTextField.frame.height
		} else {
			newlabheight = newsize.height
		}
		#if os(OSX)
		NSLog("setFrameSize: labelSize: str=\"\(mTextField.stringValue)\" \(newsize.width) \(newlabheight)")
		#endif
		let newlabsize = KCSize(width: newsize.width, height: newlabheight)
		#if os(OSX)
			self.labelView.setFrameSize(newlabsize)
		#else
			self.labelView.setFrameSize(size: newlabsize)
		#endif

		/* Decide content size */
		let contwidth: CGFloat
		if newsize.width > 20.0 {
			contwidth = newsize.width - 20.0
		} else {
			contwidth =  0.0
		}
		let contheight: CGFloat
		if newsize.height > newlabheight + 28.0 {
			contheight = newsize.height - (newlabheight + 8.0)
		} else {
			contheight =  0.0
		}
		NSLog("setFrameSize: contentSize: \(contwidth) \(contheight)")
		let contsize = KCSize(width: contwidth, height: contheight)
		#if os(OSX)
			mStackView.setFrameSize(contsize)
		#else
			mStackView.setFrameSize(size: contsize)
		#endif
	}

	#if os(OSX)
	open override var fittingSize: KCSize {
		get { return contentSize() }
	}
	#else
	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		return contentSize()
	}
	#endif

	open override var intrinsicContentSize: KCSize {
		get { return contentSize() }
	}

	// The constant value for layout is depend on XIB file
	private func contentSize() -> KCSize {
		let textsize    = intrinsicLabelSize()
		#if os(OSX)
		NSLog("intrinsicSize: labelSize: str=\"\(mTextField.stringValue)\" \(textsize.width) \(textsize.height)")
		#endif
		let stacksize   = mStackView.intrinsicContentSize
		let stackbounds = KCSize(width:  stacksize.width + 20.0, height: stacksize.height)
		NSLog("intrinsicSize: stackSize: \(stackbounds.width) \(stackbounds.height)")
		let result = KCUnionSize(sizeA: textsize, sizeB: stackbounds, doVertical: true, spacing: 8.0)
		NSLog("intrinsicSize: resultSize: \(result.width) \(result.height)")
		return result
	}

	private func intrinsicLabelSize() -> KCSize {
		#if os(OSX)
			let curnum  = mTextField.stringValue.count
			let newnum  = max(curnum, mMinWidth)
			let fitsize = mTextField.fittingSize

			let newwidth:  CGFloat
			if let fontsize = self.labelFontSize() {
				newwidth = fontsize.width * CGFloat(newnum)
			} else {
				newwidth = fitsize.width
			}

			mTextField.preferredMaxLayoutWidth = newwidth
			NSLog("intrinsicLabelSize: \(newwidth) \(fitsize.height)")
			return KCSize(width: newwidth, height: fitsize.height)
		#else
			return mTextField.intrinsicContentSize
		#endif
	}

	private func labelFontSize() -> KCSize? {
		if let font = mTextField.font {
			let attr = [NSAttributedString.Key.font: font]
			let str: String = " "
			return str.size(withAttributes: attr)
		} else {
			return nil
		}
	}

	public override func invalidateIntrinsicContentSize() {
		super.invalidateIntrinsicContentSize()
		mTextField.invalidateIntrinsicContentSize()
	}

	public override func setExpandabilities(priorities prival: KCViewBase.ExpansionPriorities) {
		super.setExpandabilities(priorities: prival)
		mStackView.setExpandabilities(priorities: prival)
		let txtpri = KCViewBase.ExpansionPriorities(holizontalHugging: prival.holizontalHugging,
							    holizontalCompression: prival.holizontalCompression,
							    verticalHugging: .low,
							    verticalCompression: .low)
		mTextField.setExpansionPriorities(priorities: txtpri)
	}
}

