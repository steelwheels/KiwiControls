/**
 * @file	KCSceneView.h
 * @brief	Define KCSceneView class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import KCControls

public class KCSceneView: KCView
{
	private var mCoreView: KCSceneViewCore? = nil
	
	public override init(frame : NSRect){
		super.init(frame: frame) ;
		setupContext() ;
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder) ;
		setupContext() ;
	}
	
	private func setupContext(){
		if let view = loadChildXib(KCSceneViewCore.self, nibname: "KCSceneViewCore") as? KCSceneViewCore {
			mCoreView = view ;
		} else {
			fatalError("Can not load KCConsoleTextView")
		}
	}
	
	public var backgroundColor: NSColor {
		get {
			if let core = mCoreView {
				return core.backgroundColor
			}
			fatalError("No core object")
		}
		set(newcolor){
			if let core = mCoreView {
				core.backgroundColor = newcolor
			}
		}
	}
}

