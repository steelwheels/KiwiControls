/**
 * @file KCStackView.swift
 * @brief Define KCStackView class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData

open class KCStackView : KCCoreView
{
	public typealias Axis		= KCStackViewCore.Axis
	public typealias Alignment	= KCStackViewCore.Alignment
	public typealias Distribution	= KCStackViewCore.Distribution

	#if os(OSX)
	public override init(frame : NSRect){
		super.init(frame: frame) ;
		setupContext()
		setupLayout()
	}
	#else
	public override init(frame: CGRect){
		super.init(frame: frame)
		setupContext()
		setupLayout()
	}
	#endif

	public convenience init(){
		#if os(OSX)
			let frame = NSRect(x: 0.0, y: 0.0, width: 480, height: 270)
		#else
			let frame = CGRect(x: 0.0, y: 0.0, width: 375, height: 346)
		#endif
		self.init(frame: frame)
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder) ;
		setupContext() ;
		setupLayout()
	}

	private func setupContext(){
		if let newview = loadChildXib(thisClass: KCStackView.self, nibName: "KCStackViewCore") as? KCStackViewCore {
			setCoreView(view: newview)
			newview.setup(frame: self.frame)
			allocateSubviewLayout(subView: newview)
		} else {
			fatalError("Can not load KCStackCore")
		}
	}

	open override func expansionPriorities() -> (ExpansionPriority /* Holiz */, ExpansionPriority /* Vert */) {
		let prih 	: ExpansionPriority
		let priv	: ExpansionPriority
		switch axis {
		case .vertical:
			prih = .Low
			priv = .High
		case .horizontal:
			prih = .High
			priv = .Low
		}
		return (prih, priv)
	}

	private func setupLayout(){
		self.distribution = .fill
	}

	public var axis: Axis {
		get 		{ return coreView.axis 		}
		set(newval)	{ coreView.axis = newval	}
	}

	public var alignment: Alignment {
		get		{ return coreView.alignment }
		set(newval)	{ coreView.alignment = newval }
	}

	public var distribution: Distribution {
		get 		{ return coreView.distributtion }
		set(newval)	{ coreView.distributtion = newval }
	}

	open func addArrangedSubViews(subViews vs:Array<KCView>){
		coreView.addArrangedSubViews(subViews: vs)
	}

	open func addArrangedSubView(subView v: KCView){
		coreView.addArrangedSubView(subView: v)
	}

	open func arrangedSubviews() -> Array<KCView> {
		return coreView.arrangedSubviews()
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(stackView: self)
	}

	private var coreView: KCStackViewCore {
		get { return getCoreView() }
	}
}

