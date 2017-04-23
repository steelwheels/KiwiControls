/**
 * @file	ViewController.swift
 * @brief	View controller for UTGraphicsEditor
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Cocoa
import KiwiControls
import KiwiGraphics

class ViewController: NSViewController {

	@IBOutlet weak var mGraphicsView: KCLayerView!

	override func viewDidLoad() {
        
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override func viewDidLayout() {
		super.viewDidLayout()

		let bounds = mGraphicsView.bounds
		let frame  = mGraphicsView.frame
		Swift.print("mGraphicsView: frame=\(frame.description), bounds=\(bounds.description)")
		let stroke = KCStrokeEditorLayer(frame: bounds)
		stroke.backgroundColor = KGColorTable.blue.cgColor
		mGraphicsView.rootLayer.addSublayer(stroke)
	}

	override var representedObject: Any? {
		didSet {
            
		// Update the view, if already loaded.
		}
	}
    


}

