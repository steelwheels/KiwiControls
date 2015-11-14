/**
 * @file	KCView.h
 * @brief	Define KCView class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Cocoa

public class KCView : NSView
{
	private var mState : KCState? = nil
	private class var stateKey : String { get{ return "mState" }}
	
	deinit {
		if let currentstate = mState {
			currentstate.removeObserver(self, forKeyPath: KCView.stateKey, context: nil)
		}
	}
	
	public var state : KCState? {
		get {
			return mState
		}
		set (newstate) {
			if let nextstate = newstate {
				nextstate.addObserver(self, forKeyPath: KCView.stateKey, options: NSKeyValueObservingOptions.New, context: nil)
				mState = nextstate
			} else {
				if let currentstate = mState {
					currentstate.removeObserver(self, forKeyPath: KCView.stateKey, context: nil)
				}
				mState = nil
			}
		}
	}
	
	public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		if let manager = object as? KCState {
			if keyPath == KCView.stateKey {
				observeState(manager)
			}
		}
	}
	
	public func observeState(state : KCState){
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


