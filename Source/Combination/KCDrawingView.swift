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
	public enum ToolType {
		case pencil
		case paintBrush
		case characterA
	}

	private var mCurrentTool:	ToolType
	private var mMainToolsView:	KCCollectionView?
	private var mSubToolsView:	KCCollectionView?
	private var mBezierView:	KCBezierView?

	#if os(OSX)
	public override init(frame : NSRect){
		mCurrentTool	= .pencil
		mMainToolsView	= nil
		mSubToolsView	= nil
		mBezierView	= nil
		super.init(frame: frame) ;
		setup()
	}
	#else
	public override init(frame: CGRect){
		mCurrentTool	= .pencil
		mMainToolsView	= nil
		mSubToolsView	= nil
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
		mCurrentTool	= .pencil
		mMainToolsView	= nil
		mSubToolsView	= nil
		mBezierView	= nil
		super.init(coder: coder)
		setup()
	}

	private func setup(){
		/* Holizontal axis*/
		self.axis = .horizontal

		/* Allocate tool box */
		let toolbox = KCStackView()
		toolbox.axis = .vertical
		self.addArrangedSubView(subView: toolbox)

		/* Add main tool component */
		let maintool = KCCollectionView()
		maintool.store(data: allocateMainToolImages())
		maintool.numberOfColumuns = 2
		toolbox.addArrangedSubView(subView: maintool)
		mMainToolsView = maintool

		/* Add sub tool component */
		let subtool = KCCollectionView()
		subtool.store(data: allocateSubToolImages(toolType: mCurrentTool))
		subtool.numberOfColumuns = 1
		toolbox.addArrangedSubView(subView: subtool)
		mSubToolsView = subtool

		/* Add drawing area */
		let bezierview = KCBezierView()
		self.addArrangedSubView(subView: bezierview)
		mBezierView = bezierview
	}

	private func allocateMainToolImages() -> CNCollection {
		let images: Array<CNCollection.Item> = [
			.image(CNSymbol.shared.URLOfSymbol(type: .pencil	)),
			.image(CNSymbol.shared.URLOfSymbol(type: .paintbrush	)),
			.image(CNSymbol.shared.URLOfSymbol(type: .characterA	))
		]
		let cdata = CNCollection()
		cdata.add(header: "", footer: "", items: images)
		return cdata
	}

	private func allocateSubToolImages(toolType tool: ToolType) -> CNCollection {
		let images: Array<CNCollection.Item>
		switch tool {
		case .pencil, .paintBrush, .characterA:
			images = [
				.image(CNSymbol.shared.URLOfSymbol(type: .line1P )),
				.image(CNSymbol.shared.URLOfSymbol(type: .line2P )),
				.image(CNSymbol.shared.URLOfSymbol(type: .line4P )),
				.image(CNSymbol.shared.URLOfSymbol(type: .line8P )),
				.image(CNSymbol.shared.URLOfSymbol(type: .line16P))
			]
		}
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

