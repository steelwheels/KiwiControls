//
//  SingleViewController.swift
//  UTLayout
//
//  Created by Tomoo Hamada on 2019/05/20.
//  Copyright © 2019 Steel Wheels Project. All rights reserved.
//

import KiwiControls
import CoconutData
import Foundation

public class SingleViewController: KCSingleViewController
{
	public override func loadView() {
		super.loadView()

		let topview = KCStackView()

		//allocateContents0(topView: topview)
		allocateContents1(topView: topview)

		if let root = super.rootView, let cons = console {
			log(type: .Flow, string: "setup root view", file: #file, line: #line, function: #function)
			root.setup(childView: topview)

			let winsize  = KCLayouter.windowSize(viewController: self, console: cons)
			let layouter = KCLayouter(viewController: self, console: cons)
			layouter.layout(rootView: root, windowSize: winsize)
		} else {
			fatalError("No root view")
		}
	}
	
	private func allocateContents0(topView topview: KCStackView){
		let dmyrect   = KCRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)

		//let imgname = "WideImage-1"
		let imgname = "TallImage-1"
		if let imgurl = CNFilePath.URLForResourceFile(fileName: imgname, fileExtension: "png") {
			if let imgdata = CNImage(contentsOf: imgurl) {
				NSLog("image-size: original -> \(imgdata.size)")
				let imgview = KCImageView()
				imgview.set(image: imgdata)
				topview.addArrangedSubView(subView: imgview)
			}
		}

		let button0   = KCButton(frame: dmyrect)
		button0.title = "OK"
		topview.addArrangedSubView(subView: button0)
	}

	private func allocateContents1(topView topview: KCStackView){
		let dmyrect = KCRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
		let hbox    = KCStackView(frame: dmyrect)
		hbox.axis   = .horizontal

		let text0   = KCTextField(frame: dmyrect)
		text0.text  = "Hello-------------------------------------------------------------"
		let text1   = KCTextField(frame: dmyrect)
		text1.text  = "Good morning"
		
		hbox.addArrangedSubViews(subViews: [text0, text1])

		topview.addArrangedSubView(subView: hbox)
	}

	private func doDumpView(message msg: String){
		if let view = self.rootView, let cons = console {
			log(type: .Flow, string: msg, file: #file, line: #line, function: #function)
			let dumper = KCViewDumper(console: cons)
			dumper.dump(view: view)
		} else {
			fatalError("No root view or console")
		}
	}
}

