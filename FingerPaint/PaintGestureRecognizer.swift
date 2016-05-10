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
	
	public var paintDelegate: PaintGestureDelegate?
//	public var stroke: Stroke = Stroke(points: [])
//	private var touchPath: TouchPath!
	public var touchManager = TouchManager()
	public var touchPath = TouchPath()
	
	public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
		super.touchesBegan(touches, withEvent: event)
		if touchPath.frames.last?.touches.isEmpty == true {
			touchPath = TouchPath()
		}
		touchPath.addTouches(touches)
		self.state = touchPath.gestureState
		print("began: ", touchPath.frames.last?.touches.count)
	}
	
	override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
		super.touchesMoved(touches, withEvent: event)
		touchPath.moveTouches(touches)
		self.state = touchPath.gestureState
	}
	
	override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
		super.touchesEnded(touches, withEvent: event)
		touchPath.removeTouches(touches)
		print("ended: ", touchManager.touchFrames.last?.touches.count)
		self.state = touchPath.gestureState
	}
	
	public override func touchesCancelled(touches: Set<UITouch>, withEvent event: UIEvent) {
		super.touchesCancelled(touches, withEvent: event)
		touchPath.removeTouches(touches)
		self.state = .Cancelled
	}
	
	public override func shouldRequireFailureOfGestureRecognizer(otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		if otherGestureRecognizer is UITapGestureRecognizer {
			return true
		}
		return false
	}
}