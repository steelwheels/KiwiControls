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
	@IBOutlet weak var mLabel: KCTextEdit!
	@IBOutlet weak var mStack: KCStackView!
	#else
	@IBOutlet weak var mLabel: KCTextEdit!
	@IBOutlet weak var mStack: KCStackView!
	#endif

	private var 	mMinWidth:	Int = 100

	public func setup(frame frm: CGRect) -> Void {
		super.setup(isSingleView: false, coreView: mStack)
		KCView.setAutolayoutMode(views: [self, mLabel, mStack])
		mLabel.format = .label
		self.title    = "Title"
	}

	public var title: String {
		get { return mLabel.text }
		set(newstr){ mLabel.text = newstr }
	}
	
	public var contentsView: KCStackView {
		get { return mStack }
	}

	public var labelView: KCTextEdit {
		get { return mLabel }
	}

	open func addArrangedSubViews(subViews vs:Array<KCView>){
		mStack.addArrangedSubViews(subViews: vs)
	}

	open func addArrangedSubView(subView v: KCView){
		mStack.addArrangedSubView(subView: v)
	}

	open func arrangedSubviews() -> Array<KCView> {
		return mStack.arrangedSubviews()
	}

	private let LabelHeight : CGFloat = 20.0

	open override func setFrameSize(_ newsize: KCSize) {
		super.setFrameSize(newsize)

		/* Decide label size */
		let newlabsize = KCSize(width: newsize.width, height: LabelHeight)
		#if os(OSX)
			self.labelView.setFrameSize(newlabsize)
		#else
			self.labelView.setFrameSize(size: newlabsize)
		#endif

		/* Decide content size */
		let contwidth: CGFloat
		if newsize.width > LabelHeight {
			contwidth = newsize.width - LabelHeight
		} else {
			contwidth =  0.0
		}
		let contheight: CGFloat
		if newsize.height > LabelHeight {
			contheight = newsize.height - LabelHeight
		} else {
			contheight =  0.0
		}
		let contsize = KCSize(width: contwidth, height: contheight)
		#if os(OSX)
			mStack.setFrameSize(contsize)
		#else
			mStack.setFrameSize(size: contsize)
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
		let textsize    = mLabel.intrinsicContentSize
		let stacksize   = mStack.intrinsicContentSize
		let result = KCUnionSize(sizeA: textsize, sizeB: stacksize, doVertical: true, spacing: 0.0)
		return result
	}

	public override func invalidateIntrinsicContentSize() {
		mLabel.invalidateIntrinsicContentSize()
		mStack.invalidateIntrinsicContentSize()
		super.invalidateIntrinsicContentSize()
	}

	public override func setExpandabilities(priorities prival: KCViewBase.ExpansionPriorities) {
		super.setExpandabilities(priorities: prival)
		mStack.setExpandabilities(priorities: prival)
		let txtpri = KCViewBase.ExpansionPriorities(holizontalHugging: prival.holizontalHugging,
							    holizontalCompression: prival.holizontalCompression,
							    verticalHugging: .low,
							    verticalCompression: .low)
		mLabel.setExpansionPriorities(priorities: txtpri)
	}
}

