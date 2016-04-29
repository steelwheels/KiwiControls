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
	private var mCoreView:		KCSceneViewCore? = nil

	private var mNearPoint	= KCPoint3(x:0.0, y:0.0, z:0.0)
	private var mFarPoint	= KCPoint3(x:0.0, y:0.0, z:0.0)

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

	public func setup(nearPoint: KCPoint3, farPoint: KCPoint3){
		mNearPoint = nearPoint
		mFarPoint  = farPoint
		coreView().setup(nearPoint, farPoint: farPoint)
	}

	public var nearPoint: KCPoint3 {
		get { return mNearPoint }
	}

	public var farPoint: KCPoint3 {
		get { return mFarPoint }
	}

	public func addChildNode(node: SCNNode){
		coreView().addChildNode(node)
	}

	public func startAnimation() {
		coreView().startAnimation()
	}

	public func stopAnimation() {
		coreView().stopAnimation()
	}

	public var delegate: SCNSceneRendererDelegate? {
		get		{ return coreView().delegate }
		set(newval)	{ coreView().delegate = newval }
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

