/**
 * @file	KCGraphicsView.h
 * @brief	Define KCGraphicsView class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Cocoa

public class KCGraphicsView: KCView
{
	private var mGraphicsViewCore : KCGraphicsViewCore? = nil

	public override init(frame f: NSRect){
		super.init(frame: f)
		setupContext() ;
	}

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
}

