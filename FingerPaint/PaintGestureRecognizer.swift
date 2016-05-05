//
//  PaintGestureRecognizer.swift
//  FingerPaint
//
//  Created by Noah Emmet on 4/24/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

public protocol PaintGestureDelegate {
//	func paintGestureRecognizer(paintGestureRecognizer: PaintGestureRecognizer, didUpdateTouchPath: TouchPath)
}

public class PaintGestureRecognizer: UIGestureRecognizer {
	
	
	public var anchor: Anchor = .None
	public var paintDelegate: PaintGestureDelegate?
//	public var stroke: Stroke = Stroke(points: [])
//	private var touchPath: TouchPath!
	public var touchManager = TouchManager()
	
	public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
		super.touchesBegan(touches, withEvent: event)
		touchManager.addUITouches(touches)
//		self.state = touchManager.state
//		self.state = touchManager.state
		if touchManager.touches.count == touches.count {
			self.state = .Began
		} else {
			self.state = .Changed
		}
		print("began: ", touches.count)
	}
	
	override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
		super.touchesMoved(touches, withEvent: event)
		touchManager.addUITouches(touches)
		self.state = .Changed
//		self.state = touchManager.state
//		print("ended: ", touches.count)
//		let allTouches = Array(touches).map { Touch(uiTouch: $0) }
//		switch allTouches.count {
//		case 1:
//			anchor = .Single(touch: allTouches[0])
//		case 2:
//			anchor = .Double(first: allTouches[0], second: allTouches[1])
//		default:
//			print("default began (failed)")
//			state = .Failed
//		}
//		touchPath.addTouches(anchor.touches)
//		paintDelegate?.paintGestureRecognizer(self, didUpdateTouchPath: touchPath)

	}
	
	override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
		super.touchesEnded(touches, withEvent: event)
//		touchManager.setUITouches(touches)
//		self.state = .Changed
//		self.state = touchManager.state
//		for touch in touches {
//			touchManager.touches.remove(Touch(uiTouch: touch))
//		}
		touchManager.removeUITouches(touches)
		print("ended: ", touchManager.touches.count)
		
		if touchManager.touches.isEmpty {
			state = .Ended
		} else {
			state = .Changed
		}
	}
	
	public override func touchesCancelled(touches: Set<UITouch>, withEvent event: UIEvent) {
		super.touchesCancelled(touches, withEvent: event)
		touchManager.removeUITouches(touches)
		self.state = .Cancelled
	}
	
	public override func shouldRequireFailureOfGestureRecognizer(otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		if otherGestureRecognizer is UITapGestureRecognizer {
			return true
		}
		return false
	}
}