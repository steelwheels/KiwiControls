/**
 * @file	KCSizeFitter.swift
 * @brief	Define KCSizeFitter class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCIntrisicSizeUpdater: KCViewVisitor
{
	private weak var mViewController 	: KCSingleViewController?
	private var mWindowFrame		: KCRect

	public init(viewController vcont: KCSingleViewController){
		mViewController		= vcont
		let winsize		= KCIntrisicSizeUpdater.windowSize(viewController: vcont)
		mWindowFrame		= KCRect(origin: KCPoint.zero, size: winsize)
	}

	open override func visit(rootView view: KCRootView){
		/* Setup root view */
		view.frame     = mWindowFrame
		view.bounds    = mWindowFrame
		view.fixedSize = mWindowFrame.size
		view.translatesAutoresizingMaskIntoConstraints = true

		/* Setup content view */
		if let core: KCView = view.getCoreView() {
			let cinset = KCIntrisicSizeUpdater.safeAreaInset(viewController: mViewController!)
			view.allocateSubviewLayout(subView: core, in: cinset)

			/* Visit core view */
			core.accept(visitor: self)
		}
	}

	open override func visit(coreView view: KCCoreView){
		let (prih, priv) = view.expansionPriorities()

		let width: CGFloat
		switch prih {
		case .High:
			width = KCView.noIntrinsicMetric
		case .Low, .Fixed:
			width = view.frame.size.width
		}

		let height: CGFloat
		switch priv {
		case .High:
			height = KCView.noIntrinsicMetric
		case .Low, .Fixed:
			height = view.frame.size.height
		}

		view.fixedSize = KCSize(width: width, height: height)
	}

	private class func windowSize(viewController vcont: KCSingleViewController) -> KCSize {
		if let parent = vcont.parentController {
			let result: KCSize
			#if os(OSX)
			if let window = parent.view.window {
				result = window.entireFrame.size
			} else {
				NSLog("\(#function) [Error] No window")
				result = KCSize(width: 100.0, height: 100.0)
			}
			#else
			result = UIScreen.main.bounds.size
			#endif
			return result
		} else {
			NSLog("\(#function) [Error] No parent controller")
			return KCSize(width: 0.0, height: 0.0)
		}
	}

	private class func safeAreaInset(viewController vcont: KCSingleViewController) -> KCEdgeInsets {
		if let parent = vcont.parentController {
			let space = KCPreference.shared.layoutPreference.spacing
			#if os(OSX)
			let result = KCEdgeInsets(top: space, left: space, bottom: space, right: space)
			#else
			let topmargin: CGFloat
			if KCPreference.shared.layoutPreference.isPortrait {
				topmargin =  16.0 - space
			} else {
				topmargin =  0.0
			}
			let insets = parent.view.safeAreaInsets
			let result = KCEdgeInsets(top:    insets.top    + topmargin + space,
						  left:   insets.left   + space,
						  bottom: insets.bottom + space,
						  right:  insets.right  + space)
			#endif
			return result
		} else {
			NSLog("\(#function) [Error] No parent controller")
			return KCEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
		}
	}
}

