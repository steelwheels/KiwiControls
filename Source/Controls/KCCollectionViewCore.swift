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
public  typealias KCCollectionViewBase 		 	= NSCollectionView
private typealias KCCollectionViewDataSourceBase 	= NSCollectionViewDataSource
private typealias KCCollectionViewDelegateBase	 	= NSCollectionViewDelegateFlowLayout
private typealias KCCollectionViewFlowLayout	 	= NSCollectionViewFlowLayout
private typealias KCCollectionViewSectionHeaderViewBase	= NSCollectionViewSectionHeaderView
#else
public  typealias KCCollectionViewBase 		 	= UICollectionView
private typealias KCCollectionViewDataSourceBase 	= UICollectionViewDataSource
private typealias KCCollectionViewDelegateBase	 	= UICollectionViewDelegate
private typealias KCCollectionViewFlowLayout	 	= UICollectionViewFlowLayout
#endif

#if os(OSX)
private let ItemIdentifier = NSUserInterfaceItemIdentifier(rawValue: "valueItem")
#else
private let ItemIdentifier = "ImageCell"
#endif

open class KCCollectionViewCore: KCCoreView, KCCollectionViewDataSourceBase, KCCollectionViewDelegateBase
{
	public typealias SelectionCallback = (_ section: Int, _ item: Int) -> Void

	static let HeaderIdentifier = "header"

	#if os(OSX)
	@IBOutlet weak var osxCollectionView: NSCollectionView!
	#else
	@IBOutlet weak var iosCollectionView: UICollectionView!
	#endif

	private var mCollectionData		= CNCollection()
	private var mNumberOfColumns		= 2
	private var mLoadedItemNum		= 0
	private var mSymbolSize			= CNSymbolSize.regular
	private var mTotalItemNum		= 0
	private var mHeaderFont			= CNFont.boldSystemFont(ofSize: CNFont.systemFontSize)
	private var mSelectionCallback: 	SelectionCallback? = nil
	private var mIsSelectable		= false
	private var mIsDragSupported		= false

	private var collectionView: KCCollectionViewBase { get {
		#if os(OSX)
			return osxCollectionView
		#else
			return iosCollectionView
		#endif
	}}

	public func setup(frame frm: CGRect) -> Void {
		let colview = collectionView
		super.setup(isSingleView: true, coreView: colview)
		KCView.setAutolayoutMode(views: [self, colview])
		colview.dataSource = self
		colview.delegate   = self
		self.isSelectable  = true

		#if os(OSX)
			let bdl = Bundle(for: KCCollectionViewCore.self)
			let nib = NSNib(nibNamed: "KCCollectionViewItem", bundle: bdl)
			colview.register(nib, forItemWithIdentifier: ItemIdentifier)

			colview.register(KCCollectionHeaderView.self,
					 forSupplementaryViewOfKind: NSCollectionView.elementKindSectionHeader,
					 withIdentifier: NSUserInterfaceItemIdentifier(rawValue: KCCollectionViewCore.HeaderIdentifier))
		#else
			let bdl = Bundle(for: KCCollectionViewCore.self)
			let nib = UINib(nibName: "KCCollectionViewCell", bundle: bdl)
			colview.register(nib, forCellWithReuseIdentifier: ItemIdentifier)

			/* This assignment is added to avoid error message:
			 *   "The behavior of the UICollectionViewFlowLayout is not defined because: ..."
			 * See https://stackoverflow.com/questions/32082726/the-behavior-of-the-uicollectionviewflowlayout-is-not-defined-because-the-cell
			 */
			if let layout = collectionView.collectionViewLayout as? KCCollectionViewFlowLayout {
				layout.estimatedItemSize = CGSize(width: 1, height: 1)
			}
		#endif
	}

	public func store(data dat: CNCollection){
		mCollectionData = dat
		mLoadedItemNum  = 0
		mTotalItemNum   = dat.totalCount()

		updateHeaderSize(collection: dat)

		collectionView.reloadData()
		//self.selectItem(indexPath: IndexPath(item: 0, section: 0))
		self.invalidateIntrinsicContentSize()
		self.requireLayout()
	}

	private func updateHeaderSize(collection col: CNCollection){
		let attrs: [NSAttributedString.Key: Any] = [
			NSAttributedString.Key.font: mHeaderFont
		]
		var result = CGSize.zero
		for sec in 0..<col.sectionCount {
			let label  = col.header(ofSection: sec)
			if !label.isEmpty {
				let labstr = NSAttributedString(string: label, attributes: attrs)
				result = CNMaxSize(result, labstr.size())
			}
		}
		self.headerReferenceSize = result
	}

	public var numberOfColumuns: Int {
		get		{ return mNumberOfColumns }
		set(newval)	{ mNumberOfColumns = newval }
	}

	public var numberOfSections: Int { get {
		return mCollectionData.sectionCount
	}}

	public func numberOfItems(inSection sec: Int) -> Int? {
		return mCollectionData.itemCount(inSection: sec)
	}

	public var isSelectable: Bool {
		get         { return mIsSelectable }
		set(newval) {
			mIsSelectable = newval
			#if os(OSX)
				collectionView.isSelectable            = newval
				collectionView.allowsEmptySelection    = true
				collectionView.allowsMultipleSelection = false
			#else
				collectionView.allowsSelection         = newval
				collectionView.allowsMultipleSelection = false
			#endif
		}
	}

	public var selectedItems: Set<IndexPath> { get {
		#if os(OSX)
			return collectionView.selectionIndexPaths
		#else
			if let arr = collectionView.indexPathsForSelectedItems {
				return Set(arr)
			} else {
				return Set()
			}
		#endif
	}}

	public func selectItem(indexPath path: IndexPath){
		#if os(OSX)
			collectionView.selectItems(at: [path], scrollPosition: .top)
		#else
			collectionView.selectItem(at: path, animated: true, scrollPosition: .top)
		#endif
	}

	public var axis: CNAxis {
		get {
			if let layout = collectionView.collectionViewLayout as? KCCollectionViewFlowLayout {
				let result: CNAxis
				switch layout.scrollDirection {
				case .vertical:		result = .vertical
				case .horizontal:	result = .horizontal
				@unknown default:
					CNLog(logLevel: .error, message: "Unsupported case", atFunction: #function, inFile: #file)
					result = .vertical
				}
				return result
			} else {
				CNLog(logLevel: .error, message: "Unexpected layout (4-0)", atFunction: #function, inFile: #file)
				return .vertical
			}
		}
		set(newval){
			if let layout = collectionView.collectionViewLayout as? KCCollectionViewFlowLayout {
				switch newval {
				case .horizontal:	layout.scrollDirection = .horizontal
				case .vertical:		layout.scrollDirection = .vertical
				@unknown default:
					CNLog(logLevel: .error, message: "Unsupported case (4-1)", atFunction: #function, inFile: #file)
				}
			} else {
				CNLog(logLevel: .error, message: "Unexpected layout (4-2)", atFunction: #function, inFile: #file)
			}
		}
	}

	private var minimumLineSpacing: CGFloat {
		get {
			if let layout = collectionView.collectionViewLayout as? KCCollectionViewFlowLayout {
				return layout.minimumLineSpacing
			} else {
				CNLog(logLevel: .error, message: "Unexpected layout (1-0)", atFunction: #function, inFile: #file)
				return 0.0
			}
		}
		set(newval){
			if let layout = collectionView.collectionViewLayout as? KCCollectionViewFlowLayout {
				layout.minimumLineSpacing = newval
			} else {
				CNLog(logLevel: .error, message: "Unexpected layout (1-1)", atFunction: #function, inFile: #file)
			}
		}
	}

	private var minimumInteritemSpacing: CGFloat {
		get {
			if let layout = collectionView.collectionViewLayout as? KCCollectionViewFlowLayout {
				return layout.minimumInteritemSpacing
			} else {
				CNLog(logLevel: .error, message: "Unexpected layout (2-0)", atFunction: #function, inFile: #file)
				return 0.0
			}
		}
		set(newval){
			if let layout = collectionView.collectionViewLayout as? KCCollectionViewFlowLayout {
				layout.minimumInteritemSpacing = newval
			} else {
				CNLog(logLevel: .error, message: "Unexpected layout (2-1)", atFunction: #function, inFile: #file)
			}
		}
	}

	private var sectionInset: KCEdgeInsets {
		get {
			if let layout = collectionView.collectionViewLayout as? KCCollectionViewFlowLayout {
				return layout.sectionInset
			} else {
				CNLog(logLevel: .error, message: "Unexpected layout (3-0)", atFunction: #function, inFile: #file)
				return KCEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
			}
		}
		set(newval){
			if let layout = collectionView.collectionViewLayout as? KCCollectionViewFlowLayout {
				layout.sectionInset = newval
			} else {
				CNLog(logLevel: .error, message: "Unexpected layout (3-1)", atFunction: #function, inFile: #file)
			}
		}
	}

	private var headerReferenceSize: CGSize {
		get {
			if let layout = collectionView.collectionViewLayout as? KCCollectionViewFlowLayout {
				return CNMinSize(layout.headerReferenceSize, self.limitSize)
			} else {
				CNLog(logLevel: .error, message: "Unexpected layout (5-0)", atFunction: #function, inFile: #file)
				return CGSize.zero
			}
		}
		set(newval){
			if let layout = collectionView.collectionViewLayout as? KCCollectionViewFlowLayout {
				layout.headerReferenceSize = newval
			} else {
				CNLog(logLevel: .error, message: "Unexpected layout (5-0)", atFunction: #function, inFile: #file)
			}
		}
	}

	private var footerReferenceSize: CGSize {
		get {
			if let layout = collectionView.collectionViewLayout as? KCCollectionViewFlowLayout {
				return CNMinSize(layout.footerReferenceSize, self.limitSize)
			} else {
				CNLog(logLevel: .error, message: "Unexpected layout (5-0)", atFunction: #function, inFile: #file)
				return CGSize.zero
			}
		}
		set(newval){
			if let layout = collectionView.collectionViewLayout as? KCCollectionViewFlowLayout {
				layout.footerReferenceSize = newval
			} else {
				CNLog(logLevel: .error, message: "Unexpected layout (5-0)", atFunction: #function, inFile: #file)
			}
		}
	}

	public override func setFrameSize(_ newsize: CGSize) {
		let maxsize = mSymbolSize.toSize()
		let maxnum  = mCollectionData.maxItemCount()
		let colnum: Int = Int(newsize.width / maxsize.width)
		mNumberOfColumns = min(maxnum, colnum)
		super.setFrameSize(newsize)
	}

	#if os(OSX)
	open override var fittingSize: CGSize {
		get { return CNMinSize(contentsSize(), self.limitSize) }
	}
	#else
	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		return  CNMinSize(adjustContentsSize(size: size), self.limitSize)
	}
	#endif

	public override var intrinsicContentSize: CGSize { get {
		return CNMinSize(contentsSize(), self.limitSize)
	}}

	public override func contentsSize() -> CGSize {
		let colnum = mNumberOfColumns

		let dovert: Bool
		switch self.axis {
		case .horizontal:	dovert = false
		case .vertical:		dovert = true
		@unknown default:	dovert = true
		}

		let secinset = self.sectionInset
		let symsize  = mSymbolSize.toSize()
		let hdrsize  = self.headerReferenceSize
		let ftrsize  = self.footerReferenceSize

		var result = CGSize.zero
		for sec in 0..<mCollectionData.sectionCount {
			let itemnum = mCollectionData.itemCount(inSection: sec)
			let rownum  = (itemnum + colnum - 1) / colnum
			let width   = symsize.width  * CGFloat(colnum)
				      + CGFloat(colnum + 1) * self.minimumInteritemSpacing
			let height  = symsize.height * CGFloat(rownum)
				      + CGFloat(rownum + 1) * self.minimumLineSpacing
			let secsize = CGSize(width: width, height: height)

			let expsize0 = CNUnionSize(secsize,  hdrsize, doVertical: true, spacing: 0.0)
			let expsize1 = CNUnionSize(expsize0, ftrsize, doVertical: true, spacing: 0.0)
			let expsize2 = CNExpandSize(expsize1, byInsets: secinset)

			result = CNUnionSize(result, expsize2, doVertical: dovert, spacing: 0.0)
		}
		return result
	}

	public override func adjustContentsSize(size newsize: CGSize) -> CGSize {
		let maxsize = mSymbolSize.toSize()
		let maxnum  = mCollectionData.maxItemCount()
		let colnum: Int = Int(newsize.width / maxsize.width)
		mNumberOfColumns = min(maxnum, colnum)
		return contentsSize()
	}

	public func set(selectionCallback cbfunc: @escaping SelectionCallback) {
		mSelectionCallback = cbfunc
	}

	public var firstResponderView: KCViewBase? { get {
		return collectionView
	}}

	/*
	 * Data source methods
	 */
	public func numberOfSections(in collectionView: KCCollectionViewBase) -> Int {
		return mCollectionData.sectionCount
	}

	public func collectionView(_ collectionView: KCCollectionViewBase, numberOfItemsInSection section: Int) -> Int {
		return mCollectionData.itemCount(inSection: section)
	}

	#if os(OSX)
	public func collectionView(_ collectionView: KCCollectionViewBase, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		let view = collectionView.makeItem(withIdentifier: ItemIdentifier, for: indexPath)
		var didset = false
		if let item = mCollectionData.value(section: indexPath.section, item: indexPath.item) {
			if let v = view as? KCCollectionViewItem {
				let _ = v.set(symbol: item, size: mSymbolSize)
				didset = true
			} else {
				CNLog(logLevel: .error, message: "Unexpected item type: \(view.description)", atFunction: #function, inFile: #file)
			}
		}
		if didset {
			mLoadedItemNum += 1
			if mLoadedItemNum == mTotalItemNum {
				self.invalidateIntrinsicContentSize()
				self.requireLayout()
				self.notify(viewControlEvent: .updateSize(self))
			}
		} else {
			CNLog(logLevel: .error, message: "Failed to set image: \(indexPath.description)", atFunction: #function, inFile: #file)
		}
		return view
	}
	#else
	public func collectionView(_ collectionView: KCCollectionViewBase, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemIdentifier, for: indexPath)
		var didset = false
		if let vcell = cell as? KCCollectionViewCell, let item = mCollectionData.value(section: indexPath.section, item: indexPath.item) {
			let _ = vcell.set(symbol: item, size: mSymbolSize)
			didset = true
		}
		if didset {
			mLoadedItemNum += 1
			if mLoadedItemNum == mTotalItemNum {
				self.invalidateIntrinsicContentSize()
				self.requireLayout()
				self.notify(viewControlEvent: .updateSize(self))
			}
		} else {
			CNLog(logLevel: .error, message: "Failed to set image: \(indexPath.description)", atFunction: #function, inFile: #file)
		}
		return cell
	}
	#endif

	/*
	 * Delegate
	 */
	#if os(OSX)
	public func collectionView(_ collectionView: KCCollectionViewBase, didSelectItemsAt indexPaths: Set<IndexPath>) {
		if let path = indexPaths.first {
			didSelect(itemAt: path)
		}
	}

	public func collectionView(_ collectionView: KCCollectionViewBase, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let ptsize = mSymbolSize.toPointSize()
		return CGSize(width: ptsize, height: ptsize)
	}
	#else
	public func collectionView(_ collectionView: KCCollectionViewBase, didSelectItemAt indexPath: IndexPath) {
		didSelect(itemAt: indexPath)
	}

	public func collectionView(_ collectionView: KCCollectionViewBase, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let ptsize = mSymbolSize.toPointSize()
		return CGSize(width: ptsize, height: ptsize)
	}
	#endif

	private func didSelect(itemAt indexPath: IndexPath){
		if let cbfunc = mSelectionCallback {
			cbfunc(indexPath.section, indexPath.item)
		}
	}

	#if os(OSX)
	public func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
		/* Allocate header/footer view */
		let ident = NSUserInterfaceItemIdentifier(KCCollectionViewCore.HeaderIdentifier)
		let view  = collectionView.makeSupplementaryView(ofKind: kind, withIdentifier: ident, for: indexPath)
		if let v = view as? KCCollectionHeaderView {
			v.isEditable = false
			v.font       = mHeaderFont
			v.text       = mCollectionData.header(ofSection: indexPath.section)
		}
		return view
	}
	#endif

	/*
	 * Drag
	 */
	#if os(OSX)
	public func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt index: IndexPath) -> NSPasteboardWriting? {
		var result: NSPasteboardWriting? = nil
		if mIsDragSupported {
			if let item = mCollectionData.value(section: index.section, item: index.item) {
				result   = item.load(size: mSymbolSize) as NSImage
			}
		}
		return result
	}
	#endif
}

#if os(OSX)
private class KCCollectionHeaderView: KCTextEdit, KCCollectionViewSectionHeaderViewBase
{
}
#endif


