/**
 * @file	KCSceneView.h
 * @brief	Define KCSceneView class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import KCControls
import SceneKit

public class KCSceneView: KCView, SCNSceneRendererDelegate
{
	private var mCoreView:		KCSceneViewCore? = nil

	private var mNearPoint	= SCNVector3(x:0.0, y:0.0, z:0.0)
	private var mFarPoint	= SCNVector3(x:0.0, y:0.0, z:0.0)

	public var renderCallback: ((renderer: SCNSceneRenderer, rootNode:SCNNode, updateAtTime: NSTimeInterval) -> Void)? = nil ;
	
	public override init(frame : NSRect){
		super.init(frame: frame) ;
		loadContext() ;
		coreView().delegate = self
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder) ;
		loadContext() ;
		coreView().delegate = self
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

	public func setup(nearPoint: SCNVector3, farPoint: SCNVector3){
		mNearPoint = nearPoint
		mFarPoint  = farPoint
		coreView().setup(nearPoint, farPoint: farPoint)
	}

	public var nearPoint: SCNVector3 {
		get { return mNearPoint }
	}

	public var farPoint: SCNVector3 {
		get { return mFarPoint }
	}

	public func addChildNode(node: SCNNode){
		coreView().rootNode.addChildNode(node)
	}

	public func startAnimation() {
		coreView().startAnimation()
	}

	public func stopAnimation() {
		coreView().stopAnimation()
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
	
	public func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
		if let callback = renderCallback {
			callback(renderer: renderer, rootNode: coreView().rootNode, updateAtTime: time)
		}
	}
}

