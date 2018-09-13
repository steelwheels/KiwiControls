/**
 * @file	KCFrameAllocLayouter.swift
 * @brief	Define KCFrameAllocLayouter class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCFrameAllocLayouter: KCViewVisitor
{
	private var mViewController:	KCSingleViewController
	private var mCurrentFrames:	CNStack<KCRect>
	private var mConsole:		CNConsole

	public init(viewController vcont: KCSingleViewController, console cons: CNConsole){
		mViewController	= vcont
		mCurrentFrames  = CNStack<KCRect>()
		mConsole	= cons

		/* Push screen size */
		let winsize = KCFrameAllocLayouter.windowSize(viewController: vcont)
		mCurrentFrames.push(KCRect(origin: KCPoint.zero, size: winsize))
	}

	open override func visit(rootView view: KCRootView){
		if let frame = mCurrentFrames.peek() {
			/* Setup root view */
			view.frame     = frame
			view.bounds    = frame
			view.fixedSize = frame.size
			//view.setFixedSizeForLayout(size: frame.size)
			view.translatesAutoresizingMaskIntoConstraints = true

			/* Setup content view */
			if let core: KCView = view.getCoreView() {
				let cinset = KCFrameAllocLayouter.safeAreaInset(viewController: mViewController)
				view.allocateSubviewLayout(subView: core, in: cinset)

				let cframe = KCEdgeInsetsInsetRect(frame, cinset)
				mCurrentFrames.push(cframe)
				core.accept(visitor: self)
				let _ = mCurrentFrames.pop()
			}
		} else {
			fatalError("\(#function): Can not happen")
		}
	}

	open override func visit(stackView view: KCStackView){
		self.visit(coreView: view)

		if let frame = mCurrentFrames.peek() {
			/* Decide size of children */
			var cframe: KCRect
			switch view.alignment {
			case .horizontal(_):
				let newx      = KCView.noIntrinsicMetric
				let newy      = frame.origin.y
				let newwidth  = KCView.noIntrinsicMetric
				let newheight = frame.size.height
				cframe = KCRect(x: newx, y: newy, width: newwidth, height: newheight)
			case .vertical(_):
				let newx      = frame.origin.x
				let newy      = KCView.noIntrinsicMetric
				let newwidth  = frame.size.width
				let newheight = KCView.noIntrinsicMetric
				cframe = KCRect(x: newx, y: newy, width: newwidth, height: newheight)
			}
			/* Visit subviews */
			mCurrentFrames.push(cframe)
			for subview in view.arrangedSubviews() {
				subview.accept(visitor: self)
			}
			let _ = mCurrentFrames.pop()
		}
	}

	open override func visit(coreView view: KCCoreView){
		if let frame = mCurrentFrames.peek() {
			view.fixedSize   = frame.size

			let (hexp, vexp) = view.expansionPriorities()

			let width  = frame.size.width
			if width > 0.0 {
				view.frame.size.width   = width
				view.bounds.size.width  = width
				view.setContentHuggingPriority(.defaultLow-1.0, for: .horizontal)
			} else {
				switch hexp {
				case .High:	view.setContentHuggingPriority(.defaultLow,     for: .horizontal)
				case .Low:	view.setContentHuggingPriority(.defaultHigh,    for: .horizontal)
				case .Fixed:	view.setContentHuggingPriority(.defaultLow-1.0, for: .horizontal)
				}
			}

			let height = frame.size.height
			if height > 0.0 {
				view.frame.size.height  = height
				view.bounds.size.height = height
				view.setContentHuggingPriority(.defaultLow-1.0, for: .vertical)
			} else {
				switch vexp {
				case .High:	view.setContentHuggingPriority(.defaultLow,     for: .vertical)
				case .Low:	view.setContentHuggingPriority(.defaultHigh,    for: .vertical)
				case .Fixed:	view.setContentHuggingPriority(.defaultLow-1.0, for: .vertical)
				}
			}
		}
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

