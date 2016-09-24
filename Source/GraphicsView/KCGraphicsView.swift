/**
 * @file	KCGraphicsView.swifr
 * @brief	Define KCGraphicsView class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif

public class KCGraphicsView: KCView
{
	private var mGraphicsViewCore : KCGraphicsViewCore? = nil

	#if os(iOS)
	public override init(frame f: CGRect){
		super.init(frame: f)
		setupContext() ;
	}
	#else
	public override init(frame f: NSRect){
		super.init(frame: f)
		setupContext() ;
	}
	#endif

	public required init?(coder c: NSCoder) {
		super.init(coder: c)
		setupContext() ;
	}

	private func setupContext(){
		if let view = loadChildXib(thisClass: KCGraphicsView.self, nibName: "KCGraphicsViewCore") as? KCGraphicsViewCore {
			mGraphicsViewCore = view ;
			view.setOriginPosition()
		} else {
			fatalError("Can not load KCConsoleTextView")
		}
	}

	public var drawCallback: ((_ context:CGContext, _ bounds:CGRect, _ dirtyRect:CGRect) -> Void)? {
		get {
			if let core = mGraphicsViewCore {
				return core.drawCallback
			} else {
				return nil
			}
		}
		set(callback){
			if let core = mGraphicsViewCore {
				core.drawCallback = callback
			}
		}
	}

	public var mouseEventCallback: ((_ event: KCMouseEvent, _ point: CGPoint) -> Bool)? {
		get {
			if let core = mGraphicsViewCore {
				return core.mouseEventCallback
			} else {
				return nil
			}
		}
		set(callback){
			if let core = mGraphicsViewCore {
				core.mouseEventCallback = callback
			}
		}
	}
}

