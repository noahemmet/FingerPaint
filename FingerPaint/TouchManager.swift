//
//  TouchManager.swift
//  FingerPaint
//
//  Created by Noah Emmet on 5/8/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public class TouchManager {
	
	public private(set) var stroke: Stroke = Stroke(points: [])
	public private(set) var anchors: [Touch] = []
	public private(set) var touchFrames: [TouchFrame] = [] 
	//	public private(set) var touches: Set<Touch> = [] 
	public var state: UIGestureRecognizerState {
		guard let previousFrame = touchFrames.elementAtIndex(touchFrames.count-2),
			let newestFrame = touchFrames.last else {
			return .Possible
		}
		if previousFrame.touches.count == 0 {
			return .Began
		} else if newestFrame.touches.count == 0 {
			touchFrames = []
			return .Ended
		} else {
			return .Changed
		}
	}
	
	public var bezierPath: UIBezierPath {
		let bezierPath = UIBezierPath()
		bezierPath.moveToPoint(touchFrames.first!.touches.first!.location)
		print("Count: ", touchFrames.count)
		for (index, touchFrame) in touchFrames.enumerate() {
			print(index)
			guard let previousFrame = touchFrames.elementAtIndex(index-1) else {
				print("nope ", index)
				for touch in touchFrame.touches {
					bezierPath.addLineToPoint(touch.location)
				}
				continue
			}
			let diffCount = (from: previousFrame.touches.count, to: touchFrame.touches.count)
			switch diffCount {
			case (from: 0, to: 0):
				fatalError("Beginning from .None to .None is illegal")
				
			case (from: 0, to: 1):
				print("began from .None to .Single")
				
				
			case (from: 0, to: 2):
				print("began from .None to .Double")
				
				
			case (from: 1, to: 0):
				print("ended from .Single to .None")
				
			case (from: 1, to: 1):
				//			print("moved from .Single to .Single")
				break
				
			case (from: 1, to: 2):
				print("changed from .Single to .Double")
				
			case (from: 2, to: 0):
				print("ended from .Double to .None")
				
				
			case (from: 2, to: 1):
				print("changed from .Double to .Single")
				//			touchNodes.append(next)
				
			case (from: 2, to: 2):
				print("moved from .Double to .Double")
				break
				
			default:
				print("Not handling >2 touches")
				//				fatalError("Not handling >2 touches")
			}

			
		}
		
		return bezierPath
	}
	
	public func appendTouchFrame(touchFrame: TouchFrame) {
		touchFrames.append(touchFrame)
	}
	
	public func addTouches(touches: [Touch]) {
		let touchFrame = TouchFrame(previous: touchFrames.last, addTouches: touches)
		appendTouchFrame(touchFrame)	
	}
	
	public func moveTouches(touches: [Touch]) {
		let touchFrame = TouchFrame(previous: touchFrames.last!, addTouches: touches)
		appendTouchFrame(touchFrame)
	}
	
	public func removeTouches(touches:  [Touch]) {
		let touchFrame = TouchFrame(previous: touchFrames.last!, addTouches: touches)
		appendTouchFrame(touchFrame)
	}
	
	public func addTouches(uiTouches: Set<UITouch>) {
		let touchFrame = TouchFrame(previous: touchFrames.last, addTouches: uiTouches)
		touchFrames.append(touchFrame)
	}
	
	public func moveTouches(uiTouches: Set<UITouch>) {
		let touchFrame = TouchFrame(previous: touchFrames.last!, moveTouches: uiTouches)
		touchFrames.append(touchFrame)
	}
	
	public func removeTouches(uiTouches: Set<UITouch>) {
		let touchFrame = TouchFrame(previous: touchFrames.last!, removeTouches: uiTouches)
		touchFrames.append(touchFrame)
	}
}








