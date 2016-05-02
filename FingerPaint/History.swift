//
//  History.swift
//  FingerPaint
//
//  Created by Noah Emmet on 5/1/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public protocol HistoryDelegate: class {
	func historyUpdated(history: History)
}

public class History {
	public weak var delegate: HistoryDelegate?
	public private(set) var strokes: [Stroke] = []
	
	public init() {
		
	}
	
	public func appendStroke(stroke: Stroke) {
		strokes.insert(stroke, atIndex: 0)
		delegate?.historyUpdated(self)
	}
	
	public func resetToStroke(stroke: Stroke, atIndex index: Int) {
		strokes.removeLast(strokes.count - index)
	}
}
