/**
 * @file	KCSceneView.h
 * @brief	Define KCSceneView class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import KCControls
import SceneKit

public class KCSceneView: KCView
{
	private var mCoreView: KCSceneViewCore? = nil
	
	public override init(frame : NSRect){
		super.init(frame: frame) ;
		loadContext() ;
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder) ;
		loadContext() ;
	}
	
	private func loadContext(){
		if let view = loadChildXib(KCSceneViewCore.self, nibname: "KCSceneViewCore") as? KCSceneViewCore {
			mCoreView = view ;
		} else {
			fatalError("Can not load KCConsoleTextView")
		}
	}
	
	private func coreView() -> KCSceneViewCore {
		if let coreview = mCoreView {
			return coreview
		}
		fatalError("No coreview")
	}
	
	public func setup(){
		coreView().setup()
	}
	
	public func addChildNode(node: SCNNode){
		coreView().addChildNode(node)
	}
	
	public var cameraNode: SCNNode {
		get { return coreView().cameraNode }
	}
	
	public var lightNode: SCNNode {
		get { return coreView().lightNode }
	}
	
	public var backgroundColor: NSColor {
		get {
			return coreView().backgroundColor
		}
		set(newcolor){
			coreView().backgroundColor = newcolor
		}
	}
}

