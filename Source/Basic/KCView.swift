/**
 * @file	KCView.h
 * @brief	Define KCView class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Cocoa
import Canary

open class KCView : NSView
{
	private dynamic var mState: CNState?   = nil
	
	deinit {
		if let state = mState {
			state.remove(stateObserver: self)
		}
	}
	
	public var state : CNState? {
		get {
			return mState
		}
		set(state) {
			if let orgstate = mState {
				orgstate.remove(stateObserver: self)
			}
			mState = state
			if let s = state {
				s.add(stateObserver: self)
			}
		}
	}

	open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if let state = object as? CNState {
			if keyPath == CNState.stateKey {
				observe(state: state)
			}
		}
	}
	
	open func observe(state stat: CNState){
		/* Do nothing (Override this method) */
	}
	
	private func allocateLayout(subView sview : NSView, attribute attr: NSLayoutAttribute) -> NSLayoutConstraint {
		return NSLayoutConstraint(item: self, attribute: attr, relatedBy: NSLayoutRelation.equal, toItem: sview, attribute: attr, multiplier: 1.0, constant: 0.0) ;
	}
	
	public func allocateSubviewLayout(subView sview: NSView){
		sview.translatesAutoresizingMaskIntoConstraints = false
		addConstraint(allocateLayout(subView: sview, attribute: NSLayoutAttribute.top)) ;
		addConstraint(allocateLayout(subView: sview, attribute: NSLayoutAttribute.left)) ;
		addConstraint(allocateLayout(subView: sview, attribute: NSLayoutAttribute.bottom)) ;
		addConstraint(allocateLayout(subView: sview, attribute: NSLayoutAttribute.right)) ;
	}

	public func loadChildXib(thisClass tc: AnyClass, nibName nn: String) -> KCView {
		let bundle : Bundle = Bundle(for: tc) ;
		if let nib = NSNib(nibNamed: nn, bundle: bundle) {
			var views : NSArray = NSArray()
			if(nib.instantiate(withOwner: nil, topLevelObjects: &views)){
				for i in 0..<views.count {
					if let view = views[i] as? KCView {
						view.frame = self.bounds ;
						addSubview(view) ;
						return view ;
					}
				}
			}
		}
		fatalError("Failed to load " + nn)
	}
	
	public func searchSubViewByType<T>(view v: NSView) -> T? {
		for subview in v.subviews {
			if let targetview = subview as? T {
				return targetview
			}
		}
		return nil
	}
}


