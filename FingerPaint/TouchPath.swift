//
//  TouchPath.swift
//  FingerPaint
//
//  Created by Noah Emmet on 5/9/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public class TouchPath {
	public private(set) var frames: [TouchFrame] = []
	public var gestureState: UIGestureRecognizerState {
		if frames.last?.touches.count == 0 && frames.count > 0 {
			return .Began
		} else if frames.last?.touches.count == 0 {
			return .Ended
		} else if frames.last!.touches.count == frames[frames.count-1].touches.count {
			return .Changed
		} else {
			return .Possible
		}
	}
	
	public func appendTouchFrame(touchFrame: TouchFrame) {
		frames.append(touchFrame)
	}
	
	public func addTouches(touches: [Touch]) {
		let touchFrame = TouchFrame(previous: frames.last, addTouches: touches)
		appendTouchFrame(touchFrame)	
	}
	
	public func moveTouches(touches: [Touch]) {
		let touchFrame = TouchFrame(previous: frames.last!, addTouches: touches)
		appendTouchFrame(touchFrame)
	}
	
	public func removeTouches(touches:  [Touch]) {
		let touchFrame = TouchFrame(previous: frames.last!, addTouches: touches)
		appendTouchFrame(touchFrame)
	}
	
	public func addTouches(uiTouches: Set<UITouch>) {
		let touchFrame = TouchFrame(previous: frames.last, addTouches: uiTouches)
		appendTouchFrame(touchFrame)
	}
	
	public func moveTouches(uiTouches: Set<UITouch>) {
		let touchFrame = TouchFrame(previous: frames.last!, moveTouches: uiTouches)
		appendTouchFrame(touchFrame)
	}
	
	public func removeTouches(uiTouches: Set<UITouch>) {
		let touchFrame = TouchFrame(previous: frames.last!, removeTouches: uiTouches)
		appendTouchFrame(touchFrame)
	}
}