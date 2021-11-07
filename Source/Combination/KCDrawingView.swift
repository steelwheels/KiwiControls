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
	private var mMainToolsView:	KCCollectionView?
	private var mSubToolsView:	KCCollectionView?
	private var mBezierView:	KCVectorGraphics?

	#if os(OSX)
	public override init(frame : NSRect){
		mMainToolsView		= nil
		mSubToolsView		= nil
		mBezierView		= nil
		super.init(frame: frame) ;
		setup()
	}
	#else
	public override init(frame: CGRect){
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
		mMainToolsView		= nil
		mSubToolsView		= nil
		mBezierView		= nil
		super.init(coder: coder)
		setup()
	}

	public var mainTool: CNVectorGraphicsType {
		get {
			if let view = mBezierView {
				return view.currentType
			} else {
				return .path
			}
		}
		set(newval){
			if let view = mBezierView {
				view.currentType = newval
			}
		}
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
		subtool.store(data: allocateSubToolImages(toolType: self.mainTool))
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
			.image(CNSymbol.shared.URLOfSymbol(type: .pencil		)),
			.image(CNSymbol.shared.URLOfSymbol(type: .rectangle		)),
			.image(CNSymbol.shared.URLOfSymbol(type: .rectangleFilled	))
		]
		let cdata = CNCollection()
		cdata.add(header: "", footer: "", items: images)
		return cdata
	}

	private func selectMainTool(item itm: Int){
		let newtype: CNVectorGraphicsType
		switch itm {
		case 0:
			newtype = .path
		case 1:
			newtype = .rect
		case 2:
			newtype = .rect
		default:
			CNLog(logLevel: .error, message: "Unexpected main tool item", atFunction: #function, inFile: #file)
			return
		}
		self.mainTool = newtype
	}
	
	private func allocateSubToolImages(toolType tool: CNVectorGraphicsType) -> CNCollection {
		let images: Array<CNCollection.Item>
		switch tool {
		case .path, .rect:
			images = [
				.image(CNSymbol.shared.URLOfSymbol(type: .line1P )),
				.image(CNSymbol.shared.URLOfSymbol(type: .line2P )),
				.image(CNSymbol.shared.URLOfSymbol(type: .line4P )),
				.image(CNSymbol.shared.URLOfSymbol(type: .line8P )),
				.image(CNSymbol.shared.URLOfSymbol(type: .line16P))
			]
		@unknown default:
			CNLog(logLevel: .error, message: "Unknown graphics type", atFunction: #function, inFile: #file)
			images = []
		}
		let cdata = CNCollection()
		cdata.add(header: "", footer: "", items: images)
		return cdata
	}

	private func selectSubTool(item itm: Int){
		switch self.mainTool {
		case .path:
			switch itm {
			case 0:	bezierLineWidth =  1.0	// line1P
			case 1: bezierLineWidth =  2.0	// line2P
			case 2: bezierLineWidth =  4.0	// line4P
			case 3: bezierLineWidth =  8.0	// line8P
			case 4: bezierLineWidth = 16.0	// line16P
			default:
				CNLog(logLevel: .error, message: "Unexpected item: \(itm)", atFunction: #function, inFile: #file)
			}
		case .rect:
			break
		@unknown default:
			CNLog(logLevel: .error, message: "Unknown graphics type", atFunction: #function, inFile: #file)
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

