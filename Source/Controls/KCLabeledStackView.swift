/**
 * @file	KCLabeledStackView.swift
 * @brief	Define KCLabeledStackView class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif
import CoconutData

open class KCLabeledStackView: KCCoreView
{
	#if os(OSX)
	public override init(frame : NSRect){
		super.init(frame: frame)
		setupContext(frame: frame)
	}
	#else
	public override init(frame: CGRect){
		super.init(frame: frame)
		setupContext(frame: frame)
	}
	#endif

	public convenience init(){
		#if os(OSX)
			let frame = NSRect(x: 0.0, y: 0.0, width: 188, height: 21)
		#else
			let frame = CGRect(x: 0.0, y: 0.0, width: 160, height: 32)
		#endif
		self.init(frame: frame)
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupContext(frame: self.frame)
	}

	private func setupContext(frame frm: CGRect){
		if let newview = loadChildXib(thisClass: KCLabeledStackViewCore.self, nibName: "KCLabeledStackViewCore") as? KCLabeledStackViewCore {
			setCoreView(view: newview)
			newview.setup(frame: frm)
			allocateSubviewLayout(subView: newview)
		} else {
			fatalError("Can not load KCLabeledStackViewCore")
		}
	}

	open override func expansionPriorities() -> (ExpansionPriority /* Holiz */, ExpansionPriority /* Vert */) {
		return (.High, .High)
	}

	public var title: String {
		get { return coreView.title }
		set(newstr){ coreView.title = newstr }
	}

	public var contentsView: KCStackView {
		get { return coreView.contentsView }
	}

	public func sizeToContain(size content: KCSize) -> KCSize {
		return coreView.sizeToContain(size: content)
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(labeledStackView: self)
	}

	private var coreView : KCLabeledStackViewCore {
		get { return getCoreView() }
	}
}
