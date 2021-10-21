/**
 * @file KCCollectionViewCore.swift
 * @brief Define KCCollectionViewCore class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

#if os(OSX)
import Cocoa
#else
import UIKit
#endif
import CoconutData
import Foundation

#if os(OSX)
private typealias KCCollectionViewBase 		 = NSCollectionView
private typealias KCCollectionViewDataSourceBase = NSCollectionViewDataSource
private typealias KCCollectionViewDelegateBase	 = NSCollectionViewDelegateFlowLayout
#else
private typealias KCCollectionViewBase 		 = UICollectionView
private typealias KCCollectionViewDataSourceBase = UICollectionViewDataSource
private typealias KCCollectionViewDelegateBase	 = UICollectionViewDelegate
#endif

#if os(OSX)
private let ItemIdentifier = NSUserInterfaceItemIdentifier(rawValue: "valueItem")
#else
private let ItemIdentifier = "valueItem"
#endif

open class KCCollectionViewCore: KCCoreView
{
	#if os(OSX)
	@IBOutlet weak var osxCollectionView: NSCollectionView!
	#else
	@IBOutlet weak var iosCollectionView: UICollectionView!
	#endif

	private var mDataSource = KCCollectionViewDataSource()
	private var mDelegate   = KCCollectionViewDelegate()

	private var collectionView: KCCollectionViewBase {
		get {
			#if os(OSX)
				return osxCollectionView
			#else
				return iosCollectionView
			#endif
		}
	}

	public func setup(frame frm: CGRect) -> Void {
		NSLog("setup")
		let colview = collectionView
		super.setup(isSingleView: true, coreView: colview)
		KCView.setAutolayoutMode(views: [self, colview])
		colview.dataSource = mDataSource
		colview.delegate   = mDelegate

		#if os(OSX)
			let bdl = Bundle(for: KCCollectionViewCore.self)
			NSLog("bundle: \(bdl.description)")
			let nib = NSNib(nibNamed: "KCCollectionViewItem", bundle: bdl)
			colview.register(nib, forItemWithIdentifier: ItemIdentifier)
		#else
			colview.register(KCCollectionViewCell.self, forCellWithReuseIdentifier: ItemIdentifier)
		#endif
	}

	public func store(data dat: KCCollectionData){
		NSLog("store new interface")
		mDataSource.collectionData = dat
		collectionView.reloadData()
		self.invalidateIntrinsicContentSize()
		self.requireLayout()
	}

	public var numberOfSections: Int { get {
		if let data = mDataSource.collectionData {
			NSLog("numberOfSections -> \(data.sectionCount)")
			return data.sectionCount
		} else {
			NSLog("numberOfSections -> nil")
			return 0
		}
	}}

	public var isSelectable: Bool {
		get {
			#if os(OSX)
				return collectionView.isSelectable
			#else
				return collectionView.allowsSelection
			#endif
		}
		set(newval) {
			NSLog("set selectable: \(newval)")
			#if os(OSX)
				collectionView.isSelectable            = newval
				collectionView.allowsEmptySelection    = newval
				collectionView.allowsMultipleSelection = false
			#else
				collectionView.allowsSelection         = newval
				collectionView.allowsMultipleSelection = false
			#endif
		}
	}

	public var firstResponderView: KCViewBase? { get {
		return collectionView
	}}
}

private class KCCollectionViewDataSource: NSObject, KCCollectionViewDataSourceBase
{
	static let ResuseIdentifier = "value"

	public var collectionData: KCCollectionData? = nil

	public override init(){
	}

	public func numberOfSections(in collectionView: KCCollectionViewBase) -> Int {
		if let data = collectionData {
			return data.sectionCount
		} else {
			return 0
		}
	}

	public func collectionView(_ collectionView: KCCollectionViewBase, numberOfItemsInSection section: Int) -> Int {
		if let data = collectionData {
			NSLog("numberOfItemsInSection(\(section)) -> \(data.sectionCount)")
			return data.sectionCount
		} else {
			NSLog("numberOfItemsInSection(\(section)) -> nil")
			return 0
		}
	}

	#if os(OSX)
	public func collectionView(_ collectionView: KCCollectionViewBase, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		let image: KCCollectionData.CollectionImage
		if let data = collectionData {
			image = data.value(section: indexPath.section, item: indexPath.item)
		} else {
			image = .none
		}
		NSLog("value of item -> \(image.description)")
		let view = collectionView.makeItem(withIdentifier: ItemIdentifier, for: indexPath)
		if let v = view as? KCCollectionViewItem {
			v.image = allocateImage(type: image)
		} else {
			NSLog("Unexpected item type: \(view.description)")
		}
		return view
	}
	#else
	public func collectionView(_ collectionView: KCCollectionViewBase, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KCCollectionViewDataSource.ResuseIdentifier, for: indexPath)
		return cell
	}
	#endif

	private func allocateImage(type typ: KCCollectionData.CollectionImage) -> CNImage {
		var result: CNImage
		switch typ {
		case .none:
			result = KCImageResource.imageResource(type: .questionmark)
		case .resource(let type):
			result = KCImageResource.imageResource(type: type)
		case .url(let url):
			if let img = CNImage(contentsOf: url){
				result = img
			} else {
				result = KCImageResource.imageResource(type: .questionmark)
			}
		}
		return result
	}
}

private class KCCollectionViewDelegate: NSObject, KCCollectionViewDelegateBase
{
	#if os(OSX)
	public func collectionView(_ collectionView: KCCollectionViewBase, shouldSelectItemsAt indexPaths: Set<IndexPath>) -> Set<IndexPath> {
		NSLog("shouldSelectItems")
		return indexPaths
	}
	#else
	public func collectionView(_ collectionView: KCCollectionViewBase, shouldSelectItemAt indexPath: IndexPath) -> Bool {

		NSLog("shouldSelectItems")
		return true
	}
	#endif

	#if os(OSX)
	public func collectionView(_ collectionView: KCCollectionViewBase, didSelectItemsAt indexPaths: Set<IndexPath>) {
		NSLog("didSelectItems")
		if let path = indexPaths.first {
			didSelect(itemAt: path)
		}
	}
	#else
	public func collectionView(_ collectionView: KCCollectionViewBase, didSelectItemAt indexPath: IndexPath) {
		didSelect(itemAt: indexPath)
	}
	#endif

	private func didSelect(itemAt indexPath: IndexPath){
		#if os(OSX)
			NSLog("DidSelect: sec=\(indexPath.section), row=\(indexPath.item)")
		#else
			NSLog("DidSelect: sec=\(indexPath.section), row=\(indexPath.row)")
		#endif
	}
}

#if os(OSX)
/*
private class KCCollectionViewItem: NSCollectionViewItem
{
	private var mValue:      CNValue = .nullValue
	private var mDidUpdated: Bool	 = false

	public var value: CNValue {
		get		{ return mValue }
		set(newval)	{
			mValue = newval
			mDidUpdated = true
		}
	}

	public override func viewDidLoad() {
		super.viewDidLoad()
	}

	public override func loadView() {
		if mDidUpdated {
			let newview   		= KCValueView()
			newview.value 		= mValue
			self.view     		= newview
			self.view.wantsLayer	= true
			mDidUpdated   		= false
		}
	}

	public override var highlightState: NSCollectionViewItem.HighlightState {
		get {
			return super.highlightState
		}
		set(newstat){
			NSLog("hilight state: \(newstat)")
			super.highlightState = newstat
		}
	}
}
*/
#else

public class KCCollectionViewCell: UICollectionViewCell
{

}

#endif



