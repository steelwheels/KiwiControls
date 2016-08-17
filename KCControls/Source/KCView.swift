/**
 * @file	KCView.h
 * @brief	Define KCView class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Cocoa
import Canary

public class KCView : NSView
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
	
	public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		if let state = object as? CNState {
			if keyPath == CNState.stateKey {
				observe(state: state)
			}
		}
	}
	
	public func observe(state stat: CNState){
		/* Do nothing (Override this method) */
	}
	
	private func allocateLayout(subview : NSView, attr: NSLayoutAttribute) -> NSLayoutConstraint {
		return NSLayoutConstraint(item: self, attribute: attr, relatedBy: NSLayoutRelation.Equal, toItem: subview, attribute: attr, multiplier: 1.0, constant: 0.0) ;
	}
	
	public func allocateSubviewLayout(subview : NSView){
		subview.translatesAutoresizingMaskIntoConstraints = false
		addConstraint(allocateLayout(subview, attr: NSLayoutAttribute.Top)) ;
		addConstraint(allocateLayout(subview, attr: NSLayoutAttribute.Left)) ;
		addConstraint(allocateLayout(subview, attr: NSLayoutAttribute.Bottom)) ;
		addConstraint(allocateLayout(subview, attr: NSLayoutAttribute.Right)) ;
	}

	public func loadChildXib(thisclass : AnyClass, nibname : String) -> KCView {
		let bundle : NSBundle = NSBundle(forClass: thisclass) ;
		if let nib = NSNib(nibNamed: nibname, bundle: bundle) {
			var viewsp : NSArray? ;
			if(nib.instantiateWithOwner(nil, topLevelObjects: &viewsp)){
				if let views = viewsp {
					for i in 0..<views.count {
						if let view = views[i] as? KCView {
							view.frame = self.bounds ;
							addSubview(view) ;
							return view ;
						}
					}
				}
			}
		}
		fatalError("Failed to load " + nibname)
	}
	
	public func searchSubViewByType<T>(view : NSView) -> T? {
		for subview in view.subviews {
			if let targetview = subview as? T {
				return targetview
			}
		}
		return nil
	}
}


