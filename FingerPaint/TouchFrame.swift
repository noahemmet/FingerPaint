//
//  TouchFrame.swift
//  FingerPaint
//
//  Created by Noah Emmet on 5/9/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public struct TouchFrame {
	public let touches: [Touch]
	public var isEmpty: Bool {
		return touches.isEmpty
	}
	
	// MARK:- Touch init
	
	public init(previous: TouchFrame? = nil, addTouches: [Touch]) {
		guard let previous = previous else {
			self.touches = addTouches
			return
		}
		var nextTouches = previous.touches
		nextTouches.insertUniqueContentsOf(addTouches)
		self.touches = nextTouches
	}
	
	public init(previous: TouchFrame, moveTouches: [Touch]) {
		let updatedTouches = moveTouches
		for var touch in updatedTouches {
			touch.update()
		}
		self.touches = updatedTouches
	}
	
	public init(previous: TouchFrame, removeTouches: [Touch]) {
		var nextTouches = previous.touches
		nextTouches.removeContentsOf(removeTouches)
		self.touches = nextTouches
	}
	
	// MARK:- UITouch init
	
	public init(previous: TouchFrame? = nil, addTouches: Set<UITouch>) {
		let touches = addTouches.map { Touch(uiTouch: $0) }
		self = TouchFrame(previous: previous, addTouches: touches)
	}
	
	public init(previous: TouchFrame, moveTouches: Set<UITouch>) {
		let touches = moveTouches.map { Touch(uiTouch: $0) }
		self = TouchFrame(previous: previous, moveTouches: touches)
	}
	
	public init(previous: TouchFrame, removeTouches: Set<UITouch>) {
		let touches = removeTouches.map { Touch(uiTouch: $0) }
		self = TouchFrame(previous: previous, removeTouches: touches)
	}
}

extension TouchFrame: CustomStringConvertible {
	public var description: String {
		return "Touch count: " + String(touches.count)
	}
}
