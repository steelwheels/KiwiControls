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
	private var mMainToolsView:		KCCollectionView?
	private var mSubToolsView:		KCCollectionView?
	private var mStrokeColorView:		KCColorSelector?
	private var mFillColorView:		KCColorSelector?
	private var mVectorGraphicsView:	KCVectorGraphics?

	#if os(OSX)
	public override init(frame : NSRect){
		mMainToolsView		= nil
		mSubToolsView		= nil
		mStrokeColorView	= nil
		mFillColorView		= nil
		mVectorGraphicsView	= nil
		super.init(frame: frame) ;
		setup()
	}
	#else
	public override init(frame: CGRect){
		mMainToolsView		= nil
		mSubToolsView		= nil
		mStrokeColorView	= nil
		mFillColorView		= nil
		mVectorGraphicsView	= nil
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
		mStrokeColorView	= nil
		mFillColorView		= nil
		mVectorGraphicsView	= nil
		super.init(coder: coder)
		setup()
	}

	public var mainTool: CNVectorGraphicsType {
		get {
			if let view = mVectorGraphicsView {
				return view.currentType
			} else {
				return .path(false)
			}
		}
		set(newval){
			if let view = mVectorGraphicsView {
				view.currentType = newval
			}
		}
	}

	public var strokeColor: CNColor {
		get {
			if let view = mVectorGraphicsView {
				return view.strokeColor
			} else {
				return CNColor.clear
			}
		}
		set(newval) {
			if let view = mVectorGraphicsView {
				view.strokeColor = newval
			}
		}
	}

	public var fillColor: CNColor {
		get {
			if let view = mVectorGraphicsView {
				return view.fillColor
			} else {
				return CNColor.clear
			}
		}
		set(newval) {
			if let view = mVectorGraphicsView {
				view.fillColor = newval
			}
		}
	}

	private func setup(){
		let initmailtools: Array<CNVectorGraphicsType> = [
			.string,
			.path(false),
			.path(true),
			.rect(false, false),
			.rect(true,  false),
			.rect(false, true),
			.rect(true,  true),
			.oval(false),
			.oval(true)
		]

		/* Holizontal axis*/
		self.axis = .horizontal

		/* Allocate tool box */
		let toolbox = KCStackView()
		toolbox.axis = .vertical
		self.addArrangedSubView(subView: toolbox)

		/* Add main tool component */
		let maintool = KCCollectionView()
		maintool.store(data: allocateMainToolImages(mainTools: initmailtools))
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

		/* Add color tool component */
		let strokeview   = KCColorSelector()
		strokeview.callbackFunc = {
			(_ color: CNColor) -> Void in
			self.strokeColor = color
		}
		mStrokeColorView = strokeview

		let fillview     = KCColorSelector()
		fillview.callbackFunc = {
			(_ color: CNColor) -> Void in
			self.fillColor = color
		}
		mFillColorView	 = fillview

		let colorbox    = KCStackView()
		colorbox.axis   = .horizontal
		colorbox.addArrangedSubView(subView: strokeview)
		colorbox.addArrangedSubView(subView: fillview)
		toolbox.addArrangedSubView(subView: colorbox)

		/* Add drawing area */
		let bezierview = KCVectorGraphics()
		self.addArrangedSubView(subView: bezierview)
		mVectorGraphicsView = bezierview

		/* assign initial tool */
		self.mainTool = initmailtools[0]
		
		/* assign default color */
		strokeview.color = bezierview.strokeColor
		fillview.color   = bezierview.fillColor
	}

	private func allocateMainToolImages(mainTools tools: Array<CNVectorGraphicsType>) -> CNCollection {
		var images: Array<CNCollection.Item> = []
		for tool in tools {
			let item: CNCollection.Item
			switch tool {
			case .path(let dofill):
				item = .image(CNSymbol.shared.URLOfSymbol(type: .pencil(dofill)))
			case .rect(let dofill, let hasround):
				item = .image(CNSymbol.shared.URLOfSymbol(type: .rectangle(dofill, hasround)))
			case .string:
				item = .image(CNSymbol.shared.URLOfSymbol(type: .characterA))
			case .oval(let dofill):
				item = .image(CNSymbol.shared.URLOfSymbol(type: .oval(dofill)))
			@unknown default:
				CNLog(logLevel: .error, message: "Unknown case", atFunction: #function, inFile: #file)
				item = .image(CNSymbol.shared.URLOfSymbol(type: .pencil(false)))
			}
			images.append(item)
		}
		let cdata = CNCollection()
		cdata.add(header: "", footer: "", items: images)
		return cdata
	}

	private func selectMainTool(item itm: Int){
		let newtype: CNVectorGraphicsType
		switch itm {
		case 0:	newtype = .string
		case 1: newtype = .path(false)
		case 2:	newtype = .path(true)
		case 3:	newtype = .rect(false, false)
		case 4:	newtype = .rect(true,  false)
		case 5: newtype = .rect(false, true)
		case 6: newtype = .rect(true,  true)
		case 7: newtype = .oval(false)
		case 8: newtype = .oval(true)
		default:
			CNLog(logLevel: .error, message: "Unexpected main tool item", atFunction: #function, inFile: #file)
			return
		}
		self.mainTool = newtype
	}
	
	private func allocateSubToolImages(toolType tool: CNVectorGraphicsType) -> CNCollection {
		let images: Array<CNCollection.Item>
		switch tool {
		case .path, .rect, .oval, .string:
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
		case .path, .rect, .oval, .string:
			switch itm {
			case 0:	bezierLineWidth =  1.0	// line1P
			case 1: bezierLineWidth =  2.0	// line2P
			case 2: bezierLineWidth =  4.0	// line4P
			case 3: bezierLineWidth =  8.0	// line8P
			case 4: bezierLineWidth = 16.0	// line16P
			default:
				CNLog(logLevel: .error, message: "Unexpected item: \(itm)", atFunction: #function, inFile: #file)
			}
		@unknown default:
			CNLog(logLevel: .error, message: "Unknown graphics type", atFunction: #function, inFile: #file)
		}
	}

	public var drawingWidth: CGFloat? {
		get {
			if let view = mVectorGraphicsView {
				return view.width
			} else {
				return nil
			}
		}
		set(newval){
			if let view = mVectorGraphicsView {
				view.width = newval
			} else {
				CNLog(logLevel: .error, message: "No bezier view", atFunction: #function, inFile: #file)
			}
		}
	}

	public var drawingHeight: CGFloat? {
		get {
			if let view = mVectorGraphicsView {
				return view.height
			} else {
				return nil
			}
		}
		set(newval){
			if let view = mVectorGraphicsView {
				view.height = newval
			} else {
				CNLog(logLevel: .error, message: "No bezier view", atFunction: #function, inFile: #file)
			}
		}
	}

	private var bezierLineWidth: CGFloat {
		get {
			if let bezier = mVectorGraphicsView {
				return bezier.lineWidth
			} else {
				CNLog(logLevel: .error, message: "No bezier view", atFunction: #function, inFile: #file)
				return 0.0
			}
		}
		set(newval){
			if let bezier = mVectorGraphicsView {
				bezier.lineWidth = newval
			} else {
				CNLog(logLevel: .error, message: "No bezier view", atFunction: #function, inFile: #file)
			}
		}
	}
}

