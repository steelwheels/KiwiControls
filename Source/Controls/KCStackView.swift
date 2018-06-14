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
	public enum Alignment {
		case Leading
		case Center
		case Trailing

		public var description: String {
			get {
				let result: String
				switch self {
				case .Center:   result  = "center"
				case .Leading:  result = "leading"
				case .Trailing: result = "trailing"
				}
				return result
			}
		}
	}
	
	#if os(OSX)
	public override init(frame : NSRect){
		super.init(frame: frame) ;
		setupContext() ;
	}
	#else
	public override init(frame: CGRect){
		super.init(frame: frame) ;
		setupContext()
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
	}

	private func setupContext(){
		if let newview = loadChildXib(thisClass: KCStackView.self, nibName: "KCStackViewCore") as? KCStackViewCore {
			setCoreView(view: newview)
			newview.setup(frame: self.frame)
			allocateSubviewLayout(subView: newview)
			setPriorityToResistAutoResize(holizontalPriority: .LowPriority, verticalPriority: .LowPriority)
		} else {
			fatalError("Can not load KCStackCore")
		}
	}

	public var orientation: KCOrientation {
		get		{ return coreView.orientation }
		set(newval)	{ coreView.orientation = newval }
	}

	public var alignment: Alignment {
		get		{ return coreView.alignment }
		set(newval)	{ coreView.alignment = newval }
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

	private var coreView: KCStackViewCore {
		get { return getCoreView() }
	}
}

