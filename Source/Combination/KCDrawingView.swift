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
	public enum MainToolType {
		case pencil
		case paintBrush
		case characterA
	}

	private var mCurrentMainTool:	MainToolType
	private var mMainToolsView:	KCCollectionView?
	private var mSubToolsView:	KCCollectionView?
	private var mBezierView:	KCVectorGraphics?

	#if os(OSX)
	public override init(frame : NSRect){
		mCurrentMainTool	= .pencil
		mMainToolsView		= nil
		mSubToolsView		= nil
		mBezierView		= nil
		super.init(frame: frame) ;
		setup()
	}
	#else
	public override init(frame: CGRect){
		mCurrentMainTool	= .pencil
		mMainToolsView		= nil
		mSubToolsView		= nil
		mBezierView		= nil
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
		mCurrentMainTool	= .pencil
		mMainToolsView		= nil
		mSubToolsView		= nil
		mBezierView		= nil
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
		maintool.set(callback: {
			(_ section: Int, _ item: Int) -> Void in
			self.selectMainTool(item: item)
		})
		toolbox.addArrangedSubView(subView: maintool)
		mMainToolsView = maintool

		/* Add sub tool component */
		let subtool = KCCollectionView()
		subtool.store(data: allocateSubToolImages(toolType: mCurrentMainTool))
		subtool.numberOfColumuns = 1
		subtool.set(callback: {
			(_ section: Int, _ item: Int) -> Void in
			self.selectSubTool(item: item)
		})
		toolbox.addArrangedSubView(subView: subtool)
		mSubToolsView = subtool

		/* Add drawing area */
		let bezierview = KCVectorGraphics()
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

	private func selectMainTool(item itm: Int){
		let newtool: MainToolType
		switch itm {
		case 0:
			newtool = .pencil
		case 1:
			newtool = .paintBrush
		case 2:
			newtool = .characterA
		default:
			CNLog(logLevel: .error, message: "Unexpected main tool item", atFunction: #function, inFile: #file)
			return
		}
		mCurrentMainTool = newtool
	}
	
	private func allocateSubToolImages(toolType tool: MainToolType) -> CNCollection {
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

	private func selectSubTool(item itm: Int){
		switch mCurrentMainTool {
		case .pencil:
			switch itm {
			case 0:	bezierLineWidth =  1.0	// line1P
			case 1: bezierLineWidth =  2.0	// line2P
			case 2: bezierLineWidth =  4.0	// line4P
			case 3: bezierLineWidth =  8.0	// line8P
			case 4: bezierLineWidth = 16.0	// line16P
			default:
				CNLog(logLevel: .error, message: "Unexpected item: \(itm)", atFunction: #function, inFile: #file)
			}
		case .characterA:
			break
		case .paintBrush:
			break
		}
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

	private var bezierLineWidth: CGFloat {
		get {
			if let bezier = mBezierView {
				return bezier.lineWidth
			} else {
				CNLog(logLevel: .error, message: "No bezier view", atFunction: #function, inFile: #file)
				return 0.0
			}
		}
		set(newval){
			if let bezier = mBezierView {
				bezier.lineWidth = newval
			} else {
				CNLog(logLevel: .error, message: "No bezier view", atFunction: #function, inFile: #file)
			}
		}
	}
}

