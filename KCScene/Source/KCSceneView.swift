/**
 * @file	KCSceneView.h
 * @brief	Define KCSceneView class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import KCControls
import KCGraphics
import SceneKit

public class KCSceneView: KCView, SCNSceneRendererDelegate
{
	private var mCoreView:		KCSceneViewCore?	= nil

	public var renderCallback: ((renderer: SCNSceneRenderer, rootNode:SCNNode, updateAtTime: NSTimeInterval) -> Void)? = nil ;

	public override init(frame f: NSRect){
		super.init(frame: f) ;
		loadContext() ;
		coreView().delegate = self
	}

	public required init?(coder c: NSCoder) {
		super.init(coder: c) ;
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

	public func setup(lightPoint lp: KCPoint3, cameraPoint cp: KCLine3){
		coreView().setup(lightPoint: lp, cameraPoint: cp)
	}

	public func addChildNode(node n: SCNNode){
		coreView().rootNode.addChildNode(n)
	}

	public func startAnimation() {
		coreView().startAnimation()
	}

	public func stopAnimation() {
		coreView().stopAnimation()
	}

	public override var description: String {
		get {
			let camerapos = coreView().cameraSourceNode.position.description()
			let lightpos  = coreView().lightNode.position.description()
			return "(camera " + camerapos + ")\n" +
			       "(light  " + lightpos + ")"
		}
	}

	public var cameraSourceNode: SCNNode {
		get { return coreView().cameraSourceNode }
	}

	public var cameraDestinationNode: SCNNode {
		get { return coreView().cameraDestionationNode }
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

	public func renderer(renderer rend: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
		if let callback = renderCallback {
			callback(renderer: rend, rootNode: coreView().rootNode, updateAtTime: time)
		}
	}
}

