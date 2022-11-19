/**
 * @file	KCIconViewCore.swift
 * @brief	Define KCIconViewCore class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

#if os(OSX)
import Cocoa
#else
import UIKit
#endif
import CoconutData

#if os(OSX)
public class KCIconButtonCell: NSButtonCell {
	public override func highlight(_ flag: Bool, withFrame cellFrame: NSRect, in controlView: NSView) {
		self.isHighlighted = flag
	}
}
#endif

open class KCIconViewCore : KCCoreView
{
	public enum Size {
		case small
		case normal
		case big
	}

	static let SmallSizeValue	: CGFloat =  32.0
	static let NormalSizeValue	: CGFloat =  64.0
	static let BigSizeValue		: CGFloat = 129.0

	public var buttonPressedCallback: (() -> Void)? = nil

	#if os(OSX)
	@IBOutlet weak var mImageButton: NSButton!
	@IBOutlet weak var mLabelView: NSTextField!
	#else
	@IBOutlet weak var mImageButton: UIButton!
	@IBOutlet weak var mLabelView: UILabel!
	#endif

	private var mSize: Size		= .normal

	public func setup(frame frm: CGRect){
		super.setup(isSingleView: false, coreView: mImageButton)
		KCView.setAutolayoutMode(views: [self, mImageButton])

		self.title = "Untitled"
		#if os(OSX)
		mImageButton.imageScaling	= .scaleProportionallyUpOrDown
		mImageButton.imagePosition	= .imageOnly
		mImageButton.isTransparent	= true
		mLabelView.isEditable		= false
		mLabelView.isSelectable		= false
		#else
		mImageButton.contentMode	= .scaleAspectFit
		//mImageButton.imagePosition	= .imageAbove
		#endif
	}

	#if os(OSX)
	@IBAction func buttonPressed(_ sender: Any) {
		if let callback = buttonPressedCallback {
			callback()
		}
	}
	#else
	@IBAction func buttonPressed(_ sender: Any) {
		if let callback = buttonPressedCallback {
			callback()
		}
	}
	#endif

	public var image: CNImage? {
		get {
			#if os(OSX)
				return mImageButton.image
			#else
				return mImageButton.image(for: .normal)
			#endif
		}
		set(newimg)	{
			guard let img = newimg else {
				CNLog(logLevel: .error, message: "No image")
				return
			}
			#if os(OSX)
				mImageButton.image = img
			#else
				mImageButton.setImage(img, for: .normal)
			#endif
			mImageButton.invalidateIntrinsicContentSize()
		}
	}

	public var title: String {
		get {
			#if os(OSX)
				return mLabelView.stringValue
			#else
				if let str = mLabelView.text {
					return str
				} else {
					return ""
				}
			#endif
		}
		set(newstr){
			#if os(OSX)
				mLabelView.stringValue = newstr
			#else
				mLabelView.text = newstr
			#endif
			mLabelView.invalidateIntrinsicContentSize()
		}
	}

	public var size: Size {
		get	     { return mSize    }
		set(newsize) { mSize = newsize }
	}

	open override func setFrameSize(_ newsize: CGSize) {
		let _ = adjustSize(in: newsize)
		super.setFrameSize(newsize)
	}

	public override func invalidateIntrinsicContentSize() {
		super.invalidateIntrinsicContentSize()
		// The size of image is NOT invalidated
	}

	#if os(OSX)
	open override var fittingSize: CGSize {
		get { return requiredSize() }
	}
	#else
	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		return adjustSize(in: size)
	}
	#endif

	open override var intrinsicContentSize: CGSize {
		get { return requiredSize() }
	}

	private func requiredSize() -> CGSize {
		let btnsize = mImageButton.intrinsicContentSize
		let labsize = mLabelView.intrinsicContentSize
		return CNUnionSize(sizeA: btnsize, sizeB: labsize, doVertical: true, spacing: CNPreference.shared.windowPreference.spacing)
	}

	private func adjustSize(in sz: CGSize) -> CGSize {
		if sz.width <= KCIconViewCore.SmallSizeValue || sz.height <= KCIconViewCore.SmallSizeValue {
			return adjustSize(sizeType: .small)
		} else if sz.width <= KCIconViewCore.NormalSizeValue || sz.height <= KCIconViewCore.NormalSizeValue {
			return adjustSize(sizeType: .normal)
		} else {
			return adjustSize(sizeType: .big)
		}
	}

	private func adjustSize(sizeType styp: Size) -> CGSize {
		let targsize = sizeToValue(size: styp)
		let spacing  = CNPreference.shared.windowPreference.spacing
		
		/* Get label size */
		let labsize: CGSize
		mLabelView.sizeToFit()
		labsize = mLabelView.frame.size
		#if os(OSX)
			mLabelView.setFrameSize(labsize)
		#else
			mLabelView.setFrame(size: labsize)
		#endif

		/* Adjust image size */
		let imgsize: CGSize
		if targsize.height > (labsize.height + spacing) {
			if let img = imageInButton() {
				let reqsize = CGSize(width: targsize.width, height: targsize.height - (labsize.height + spacing))
				imgsize = adjustImageSize(image: img, targetSize: reqsize)
			} else {
				CNLog(logLevel: .error, message: "No image in icon", atFunction: #function, inFile: #file)
				imgsize = CGSize.zero
			}
		} else {
			CNLog(logLevel: .error, message: "No space to put image in icon", atFunction: #function, inFile: #file)
			imgsize = CGSize.zero
		}

		return CNUnionSize(sizeA: imgsize, sizeB: labsize, doVertical: true, spacing: 0.0)
	}

	private func adjustImageSize(image img: CNImage, targetSize target: CGSize) -> CGSize {
		let newsize = img.size.resizeWithKeepingAscpect(inSize: target)
		if let newimg = img.resized(to: newsize) {
			setImageToButton(image: newimg)
			#if os(OSX)
				mImageButton.setFrameSize(newsize)
			#else
				mImageButton.setFrame(size: newsize)
			#endif
			return newsize
		} else {
			CNLog(logLevel: .error, message: "Failed to resize image", atFunction: #function, inFile: #file)
			return img.size
		}
	}

	private func sizeToValue(size sz: Size) -> CGSize {
		let val: CGFloat
		switch sz {
		case .small:	val = KCIconViewCore.SmallSizeValue
		case .normal:	val = KCIconViewCore.NormalSizeValue
		case .big:	val = KCIconViewCore.BigSizeValue
		}
		return CGSize(width: val, height: val)
	}

	private func imageInButton() -> CNImage? {
		#if os(OSX)
			return mImageButton.image
		#else
			return mImageButton.image(for: .normal)
		#endif
	}

	private func setImageToButton(image img: CNImage) {
		#if os(OSX)
			mImageButton.image = img
		#else
		mImageButton.setImage(img, for: .normal)
		#endif
	}

	public override func setExpandabilities(priorities prival: KCViewBase.ExpansionPriorities) {
		super.setExpandabilities(priorities: prival)
		mImageButton.setExpansionPriorities(priorities: prival)
		let labpri = KCViewBase.ExpansionPriorities(holizontalHugging: prival.holizontalHugging,
							    holizontalCompression: prival.holizontalCompression,
							    verticalHugging: .low,
							    verticalCompression: .low)
		mLabelView.setExpansionPriorities(priorities: labpri)
	}
}

