/**
 * @file	KCSceneViewCore.h
 * @brief	Define KCSceneViewCore class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import KCControls
import SceneKit

public class KCSceneViewCore: KCView
{
	@IBOutlet weak var sceneView: SCNView!
	
	public override init(frame : NSRect){
		super.init(frame: frame) ;
		setupContext() ;
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder) ;
		setupContext() ;
	}
	
	private func setupContext(){
		
	}
	
	public var backgroundColor: NSColor {
		get {
			return sceneView.backgroundColor
		}
		set(newcolor){
			sceneView.backgroundColor = newcolor
		}
	}
}
