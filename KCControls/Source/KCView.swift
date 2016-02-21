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
			state.removeStateObserver(self)
		}
	}
	
	public var state : CNState? {
		get {
			return mState
		}
		set(state) {
			if let orgstate = mState {
				orgstate.removeStateObserver(self)
			}
			mState = state
			if let s = state {
				s.addStateObserver(self)
			}
		}
	}
	
	public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		if let state = object as? CNState {
			if keyPath == CNState.stateKey {
				observeState(state)
			}
		}
	}
	
	public func observeState(state : CNState){
		/* Do nothing (Override this method) */
	}
	
	private func allocateLayout(subview : NSView, attr: NSLayoutAttribute) -> NSLayoutConstraint {
		return NSLayoutConstraint(item: self, attribute: attr, relatedBy: NSLayoutRelation.Equal, toItem: subview, attribute: attr, multiplier: 1.0, constant: 0.0) ;
	}
	
	public func allocateSubviewLayout(subview : NSView){
		addConstraint(allocateLayout(subview, attr: NSLayoutAttribute.Top)) ;
		addConstraint(allocateLayout(subview, attr: NSLayoutAttribute.Left)) ;
		addConstraint(allocateLayout(subview, attr: NSLayoutAttribute.Bottom)) ;
		addConstraint(allocateLayout(subview, attr: NSLayoutAttribute.Right)) ;
	}
	
	public func loadChildXib(thisclass : AnyClass, nibname : String) -> KCView? {
		let bundle : NSBundle = NSBundle(forClass: thisclass) ;
		let nibp : NSNib? = NSNib(nibNamed: nibname, bundle: bundle) ;
		if let nib = nibp {
			var viewsp : NSArray? ;
			if(nib.instantiateWithOwner(nil, topLevelObjects: &viewsp)){
				if let views = viewsp {
					for (var i = 0; i < views.count; i++) {
						if let view = views[i] as? KCView {
							view.frame = self.bounds ;
							addSubview(view) ;
							return view ;
						}
					}
				}
			}
		}
		NSLog("Failed to load " + nibname)
		return nil ;
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


