/**
 * @file KCDrawingView.swift
 * @brief Define KCDrawingView class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData

open class KCDrawingView: KCStackView
{
	private var mToolsView:		KCCollectionView?
	private var mBezierView:	KCBezierView?

	#if os(OSX)
	public override init(frame : NSRect){
		mToolsView	= nil
		mBezierView	= nil
		super.init(frame: frame) ;
		setup()
	}
	#else
	public override init(frame: CGRect){
		mToolsView	= nil
		mBezierView	= nil
		super.init(frame: frame)
		setup()
	}
	#endif

	public convenience init(){
		#if os(OSX)
			let frame = NSRect(x: 0.0, y: 0.0, width: 480, height: 270)
		#else
			let frame = CGRect(x: 0.0, y: 0.0, width: 375, height: 346)
		#endif
		self.init(frame: frame)
	}

	public required init?(coder: NSCoder) {
		mToolsView	= nil
		mBezierView	= nil
		super.init(coder: coder)
		setup()
	}

	private func setup(){
		/* Holizontal axis*/
		self.axis = .horizontal

		/* Add tools component */
		let toolview = KCCollectionView()
		toolview.store(data: allocateToolImages())
		self.addArrangedSubView(subView: toolview)
		mToolsView = toolview

		/* Add drawing area */
		let bezierview = KCBezierView()
		self.addArrangedSubView(subView: bezierview)
		mBezierView = bezierview
	}

	private func allocateToolImages() -> CNCollection {
		let images: Array<CNCollection.Item> = [
			.image(CNSymbol.shared.URLOfSymbol(type: .pencil	)),
			.image(CNSymbol.shared.URLOfSymbol(type: .paintbrush	)),
			.image(CNSymbol.shared.URLOfSymbol(type: .characterA	))
		]
		let cdata = CNCollection()
		cdata.add(header: "", footer: "", items: images)
		return cdata
	}

	public var drawingWidth: CGFloat? {
		get {
			if let view = mBezierView {
				return view.width
			} else {
				return nil
			}
		}
		set(newval){
			if let view = mBezierView {
				view.width = newval
			} else {
				CNLog(logLevel: .error, message: "No bezier view", atFunction: #function, inFile: #file)
			}
		}
	}

	public var drawingHeight: CGFloat? {
		get {
			if let view = mBezierView {
				return view.height
			} else {
				return nil
			}
		}
		set(newval){
			if let view = mBezierView {
				view.height = newval
			} else {
				CNLog(logLevel: .error, message: "No bezier view", atFunction: #function, inFile: #file)
			}
		}
	}
}

