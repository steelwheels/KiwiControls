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
private let ItemIdentifier = "ImageCell"
#endif

open class KCCollectionViewCore: KCCoreView
{
	public typealias SelectedCallback = (_ section: Int, _ item: Int) -> Void

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
		let colview = collectionView
		super.setup(isSingleView: true, coreView: colview)
		KCView.setAutolayoutMode(views: [self, colview])
		colview.dataSource = mDataSource
		colview.delegate   = mDelegate

		#if os(OSX)
			let bdl = Bundle(for: KCCollectionViewCore.self)
			let nib = NSNib(nibNamed: "KCCollectionViewItem", bundle: bdl)
			colview.register(nib, forItemWithIdentifier: ItemIdentifier)
		#else
			let bdl = Bundle(for: KCCollectionViewCore.self)
			let nib = UINib(nibName: "KCCollectionViewCell", bundle: bdl)
			colview.register(nib, forCellWithReuseIdentifier: ItemIdentifier)
		#endif
	}

	public func store(data dat: KCCollectionData){
		mDataSource.collectionData = dat
		collectionView.reloadData()
		self.select(section: 0, item: 0)
		self.invalidateIntrinsicContentSize()
		self.requireLayout()
	}

	public var numberOfSections: Int { get {
		if let data = mDataSource.collectionData {
			return data.sectionCount
		} else {
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
			#if os(OSX)
				collectionView.isSelectable            = newval
				collectionView.allowsEmptySelection    = false
				collectionView.allowsMultipleSelection = false
			#else
				collectionView.allowsSelection         = newval
				collectionView.allowsMultipleSelection = false
			#endif
		}
	}

	public var selectedItems: Set<IndexPath> {
		get {
			#if os(OSX)
				return collectionView.selectionIndexPaths
			#else
				if let arr = collectionView.indexPathsForSelectedItems {
					return Set(arr)
				} else {
					return Set()
				}
			#endif
		}
	}

	public func select(section sec: Int, item itm: Int) {
		let path = IndexPath(item: itm, section: sec)
		#if os(OSX)
		if let item = collectionView.item(at: path) {
			item.isSelected = true
		} else {
			CNLog(logLevel: .error, message: "Invalid index (\(sec), \(itm))", atFunction: #function, inFile: #file)
		}
		#else
		if let cell = collectionView.cellForItem(at: path) {
			cell.isSelected = true
		} else {
			CNLog(logLevel: .error, message: "Invalid index (\(sec), \(itm))", atFunction: #function, inFile: #file)
		}
		#endif
	}

	public func set(callback cbfunc: @escaping SelectedCallback) {
		mDelegate.set(callback: cbfunc)
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
			return data.sectionCount
		} else {
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
		let view = collectionView.makeItem(withIdentifier: ItemIdentifier, for: indexPath)
		if let v = view as? KCCollectionViewItem {
			v.image = allocateImage(type: image)
		} else {
			CNLog(logLevel: .error, message: "Unexpected item type: \(view.description)", atFunction: #function, inFile: #file)
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
		let symbols = CNSymbol.shared
		switch typ {
		case .none:
			result = symbols.load(symbol: .questionmark)
		case .resource(let type):
			result = symbols.load(symbol: type)
		case .url(let url):
			if let img = CNImage(contentsOf: url){
				result = img
			} else {
				result = symbols.load(symbol: .questionmark)
			}
		}
		return result
	}
}

private class KCCollectionViewDelegate: NSObject, KCCollectionViewDelegateBase
{
	public typealias SelectedCallback = KCCollectionViewCore.SelectedCallback

	private var mCallback: SelectedCallback? = nil

	#if os(OSX)
	public func collectionView(_ collectionView: KCCollectionViewBase, shouldSelectItemsAt indexPaths: Set<IndexPath>) -> Set<IndexPath> {
		return indexPaths
	}
	#else
	public func collectionView(_ collectionView: KCCollectionViewBase, shouldSelectItemAt indexPath: IndexPath) -> Bool {
		return true
	}
	#endif

	#if os(OSX)
	public func collectionView(_ collectionView: KCCollectionViewBase, didSelectItemsAt indexPaths: Set<IndexPath>) {
		if let path = indexPaths.first {
			didSelect(itemAt: path)
		}
	}
	#else
	public func collectionView(_ collectionView: KCCollectionViewBase, didSelectItemAt indexPath: IndexPath) {
		didSelect(itemAt: indexPath)
	}
	#endif

	public func set(callback cbfunc: @escaping SelectedCallback) {
		mCallback = cbfunc
	}

	private func didSelect(itemAt indexPath: IndexPath){
		if let cbfunc = mCallback {
			cbfunc(indexPath.section, indexPath.item)
		}
	}
}


