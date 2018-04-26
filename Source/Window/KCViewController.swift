/**
 * @file	KCViewController.swift
 * @brief	Define KCViewController class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif
import CoconutData

#if os(iOS)
	public typealias KCViewControllerBase = UIViewController
#else
	public typealias KCViewControllerBase = NSViewController
#endif

open class KCViewControllerDelegate
{
	public init(){ }
	/* Appear */
	open func viewDidLoad(rootView view: KCView){			}
	open func viewWillAppear(rootView view: KCView){		}
	open func viewDidAppear(rootView view: KCView){			}
	/* Resize */
	open func updateViewConstraints(rootView view: KCView){		}
	#if false
	open func viewWillLayout(rootView view: KCView){		}
	open func viewDidLayout(rootView view: KCView){			}
	#endif
	/* Disappear */
	open func viewWillDisappear(rootView view: KCView){		}
	open func viewDidDisappear(rootView view: KCView){		}
}

open class KCViewController : KCViewControllerBase
{
	public var delegate: KCViewControllerDelegate? = nil

	public class func loadViewController(delegate dlgt: KCViewControllerDelegate) -> KCViewController
	{
		let bundle : Bundle = Bundle(for: KCViewController.self) ;
		let nibname: String = "KCViewController"
		#if os(iOS)
			let nib = UINib(nibName: nibname, bundle: bundle)
			let controllers = nib.instantiate(withOwner: nil, options: nil)
			for i in 0..<controllers.count {
				if let controller = controllers[i] as? KCViewController {
					controller.delegate = dlgt
					if let rootview = controller.view as? KCView {
						dlgt.viewDidLoad(rootView: rootview)
					} else {
						NSLog("No root view")
					}
					return controller ;
				}
			}
		#else
			if let nib = NSNib(nibNamed: NSNib.Name(rawValue: nibname), bundle: bundle) {
				var controllersp : NSArray? = NSArray()
				if(nib.instantiate(withOwner: nil, topLevelObjects: &controllersp)){
					if let controllers = controllersp {
						for i in 0..<controllers.count {
							if let controller = controllers[i] as? KCViewController {
								controller.delegate = dlgt
								if let rootview = controller.view as? KCView {
									dlgt.viewDidLoad(rootView: rootview)
								} else {
									NSLog("No root view")
								}
								return controller
							}
						}
					}
				}
			}
		#endif
		fatalError("Failed to load " + nibname)
	}
	
	open override func viewDidLoad(){
		super.viewDidLoad()
		if let dlgt = delegate, let view = self.view as? KCView {
			dlgt.viewDidLoad(rootView: view)
		}
	}

	#if os(iOS)
	open override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let dlgt = delegate, let view = self.view as? KCView {
			dlgt.viewWillAppear(rootView: view)
		}
	}
	#else
	open override func viewWillAppear() {
		super.viewWillAppear()
		if let dlgt = delegate, let view = self.view as? KCView {
			dlgt.viewWillAppear(rootView: view)
		}
	}
	#endif

	#if os(iOS)
	open override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if let dlgt = delegate, let view = self.view as? KCView {
			dlgt.viewDidAppear(rootView: view)
		}
	}
	#else
	open override func viewDidAppear() {
		super.viewDidAppear()
		if let dlgt = delegate, let view = self.view as? KCView {
			dlgt.viewDidAppear(rootView: view)
		}
	}
	#endif

	open override func updateViewConstraints() {
		super.updateViewConstraints()
		if let dlgt = delegate, let view = self.view as? KCView {
			dlgt.updateViewConstraints(rootView: view)
		}
	}

	#if false
	public override func viewWillLayout() {
		super.viewWillLayout()
		if let dlgt = delegate, let view = self.view as? KCView {
			dlgt.viewWillLayout(rootView: view)
		}
	}

	public override func viewDidLayout() {
		super.viewDidLayout()
		if let dlgt = delegate, let view = self.view as? KCView {
			dlgt.viewDidLayout(rootView: view)
		}
	}
	#endif

	#if os(iOS)
	open override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if let dlgt = delegate, let view = self.view as? KCView {
			dlgt.viewWillDisappear(rootView: view)
		}
	}
	#else
	open override func viewWillDisappear() {
		super.viewWillDisappear()
		if let dlgt = delegate, let view = self.view as? KCView {
			dlgt.viewWillDisappear(rootView: view)
		}
	}
	#endif

	#if os(iOS)
	open override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		if let dlgt = delegate, let view = self.view as? KCView {
			dlgt.viewDidDisappear(rootView: view)
		}
	}
	#else
	open override func viewDidDisappear() {
		super.viewDidDisappear()
		if let dlgt = delegate, let view = self.view as? KCView {
			dlgt.viewDidDisappear(rootView: view)
		}
	}
	#endif
}

