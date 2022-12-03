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

	public var mainToolType: KCVectorToolType {
		get {
			if let view = mVectorGraphicsView {
				return view.toolType
			} else {
				CNLog(logLevel: .error, message: "No graphics view (get)", atFunction: #function, inFile: #file)
				return .path(false)
			}
		}
		set(newval) {
			if let view = mVectorGraphicsView {
				view.toolType = newval
			} else {
				CNLog(logLevel: .error, message: "No graphics view (set)", atFunction: #function, inFile: #file)
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
		let initmaintools: Array<KCVectorToolType> = [
			.mover,
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
		maintool.store(data: allocateMainToolImages(mainTools: initmaintools))
		maintool.numberOfColumuns = 2
		maintool.set(selectionCallback: {
			(_ section: Int, _ item: Int) -> Void in
			self.selectMainTool(item: item)
		})
		toolbox.addArrangedSubView(subView: maintool)
		mMainToolsView = maintool

		/* Add sub tool component */
		let subtool = KCCollectionView()
		subtool.store(data: allocateSubToolImages(toolType: initmaintools[0]))
		subtool.numberOfColumuns = 1
		subtool.set(selectionCallback: {
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
		self.mainToolType = initmaintools[0]

		/* assign default color */
		strokeview.color = bezierview.strokeColor
		fillview.color   = bezierview.fillColor
	}

	private func allocateMainToolImages(mainTools tools: Array<KCVectorToolType>) -> CNCollection {
		var items: Array<CNSymbol> = []
		for tool in tools {
			let item: CNSymbol
			switch tool {
			case .mover:
				item = .handRaised
			case .path(let dofill):
				item = CNSymbol.pencil(doFill: dofill)
			case .rect(let dofill, let hasround):
				item = CNSymbol.rectangle(doFill: dofill, hasRound: hasround)
			case .string:
				item = .character
			case .oval(let dofill):
				item = CNSymbol.oval(doFill: dofill)
			}
			items.append(item)
		}
		let cdata = CNCollection()
		cdata.add(header: "", footer: "", items: items)
		return cdata
	}

	private func selectMainTool(item itm: Int){
		let newtype: KCVectorToolType
		switch itm {
		case 0: newtype = .mover
		case 1:	newtype = .string
		case 2: newtype = .path(false)
		case 3:	newtype = .path(true)
		case 4:	newtype = .rect(false, false)
		case 5:	newtype = .rect(true,  false)
		case 6: newtype = .rect(false, true)
		case 7: newtype = .rect(true,  true)
		case 8: newtype = .oval(false)
		case 9: newtype = .oval(true)
		default:
			CNLog(logLevel: .error, message: "Unexpected main tool item", atFunction: #function, inFile: #file)
			return
		}
		self.mainToolType = newtype
	}

	private func allocateSubToolImages(toolType tool: KCVectorToolType) -> CNCollection {
		let symbols: Array<CNSymbol>
		switch tool {
		case .mover, .path, .rect, .oval, .string:
			symbols = [.line_1p, .line_2p, .line_4p, .line_8p, .line_16p]
		}
		let cdata = CNCollection()
		cdata.add(header: "", footer: "", items: symbols)
		return cdata
	}

	private func selectSubTool(item itm: Int){
		switch self.mainToolType {
		case .mover, .path, .rect, .oval, .string:
			switch itm {
			case 0:	bezierLineWidth =  1.0	// line1P
			case 1: bezierLineWidth =  2.0	// line2P
			case 2: bezierLineWidth =  4.0	// line4P
			case 3: bezierLineWidth =  8.0	// line8P
			case 4: bezierLineWidth = 16.0	// line16P
			default:
				CNLog(logLevel: .error, message: "Unexpected item: \(itm)", atFunction: #function, inFile: #file)
			}
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

	public var firstResponderView: KCViewBase? { get {
		return mVectorGraphicsView
	}}

	/*
	 * load/store
	 */
	public func toValue() -> CNValue {
		if let view = mVectorGraphicsView {
			return view.toValue()
		} else {
			return CNValue.null
		}
	}

	public func load(from url: URL) -> Bool {
		if let view = mVectorGraphicsView {
			return view.load(from: url)
		} else {
			CNLog(logLevel: .error, message: "No vector graphics view", atFunction: #function, inFile: #file)
			return false
		}
	}
}

