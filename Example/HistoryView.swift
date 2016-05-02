//
//  HistoryView.swift
//  FingerPaint
//
//  Created by Noah Emmet on 5/1/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import UIKit
import FingerPaint

protocol HistoryViewDelegate: class {
	func resetToStroke(stroke: Stroke, atIndex index: Int)
}

class HistoryView: UICollectionView {
	
	var history: History!
	weak var historyViewDelegate: HistoryViewDelegate?
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.dataSource = self
		self.delegate = self
	}
}

extension HistoryView: UICollectionViewDataSource, UICollectionViewDelegate {
	
	override func numberOfSections() -> Int {
		return 1
	}
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return history.strokes.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HistoryCell", forIndexPath: indexPath)
		let stroke = history.strokes.reverse()[indexPath.row]
		cell.contentView.layer.sublayers?.removeAll()
		let layer = stroke.createLayer(scale: 0.1)
		cell.contentView.layer.addSublayer(layer)
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if indexPath.item == history.strokes.count - 1 {
			return
		}
		let stroke = history.strokes[indexPath.row]
		historyViewDelegate?.resetToStroke(stroke, atIndex: indexPath.row + 1)
		history.resetToStroke(stroke, atIndex: indexPath.row + 1)
		self.reloadData()
	}
}

extension HistoryView: HistoryDelegate {
	func historyUpdated(history: History) {
		self.reloadData()
		let lastIndexPath = NSIndexPath(forItem: history.strokes.count - 1, inSection: 0)
		self.scrollToItemAtIndexPath(lastIndexPath, atScrollPosition: .Right, animated: true)
	}
}