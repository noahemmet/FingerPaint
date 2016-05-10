//
//  TouchPath.swift
//  FingerPaint
//
//  Created by Noah Emmet on 5/9/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public class TouchPath {
	public private(set) var frames: [TouchFrame]
	public var gestureState: UIGestureRecognizerState {
		if frames.count == 1 {
			return .Began
		} else if frames.last?.touches.count == 0 {
			return .Ended
		} else if frames.last!.touches.count == frames[frames.count-1].touches.count {
			return .Changed
		} else {
			return .Possible
		}
	}
	
	public init() {
		let emptyTouchFrame = TouchFrame(addTouches: [])
		frames = [emptyTouchFrame]
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

extension TouchPath {
	public var validPoints: [CGPoint] {
		guard frames.count > 1 else {
			return []
		}
		var points: [CGPoint] = []
		var anchors: [Touch] = []
		
		for (index, frame) in frames.enumerate() {
			guard let nextFrame = frames.elementAtIndex(index+1) else {
				continue
			}
			let nextFramePoints = nextFrame.touches.map { $0.location }
			let countDiff = (from: frame.touches.count, to: nextFrame.touches.count)
			switch countDiff {
			case (from: 0, to: 1):
				points.appendContentsOf(nextFramePoints)
			case (from: 0, to: 2):
				points.appendContentsOf(nextFramePoints)
				anchors = nextFrame.touches
			case (from: 1, to: 0):
				points.appendContentsOf(nextFramePoints)
				anchors = []
			case (from: 1, to: 1):
				points.appendContentsOf(nextFramePoints)
			case (from: 1, to: 2):
				anchors = [frame.touches[0]]
			case (from: 2, to: 0):
				anchors = []
			case (from: 2, to: 1):
				points.appendContentsOf(nextFramePoints)
//				anchors = []
			case (from: 2, to: 2):
				if anchors.count == 1 {
					points.removeAtIndex(points.count-2)
					points.append(nextFramePoints.last!)
				} else if anchors.count == 2 {
					points.removeLast(2)
					points.appendContentsOf(nextFramePoints)
				}
			default:
				fatalError("todo")
			}
		}
		return points
	}
	
	public var bezierPath: UIBezierPath? {
		guard frames.count > 1 else {
			return nil
		}
		let bezierPath = UIBezierPath()
		let points = validPoints
		bezierPath.moveToPoint(points.first!)
		for point in points {
			bezierPath.addLineToPoint(point)
		}
		return bezierPath
	}
	
	public var stroke: Stroke {
		let stroke = Stroke(points: validPoints)
		return stroke
	}
}

extension TouchPath: CustomStringConvertible {
	public var description: String {
		return "Frame count: " + String(frames.count)
	}
}
