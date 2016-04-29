//
//  Touch.swift
//  FingerPaint
//
//  Created by Noah Emmet on 4/20/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public class TouchPath {
	public let initialTouch: Touch
	public var touches: [Touch]
	
	public init(initial: Touch) {
		self.initialTouch = initial
		touches = [self.initialTouch]
	}
}

public struct Touch {
	
	public let location: CGPoint
	
	public init(uiTouch: UITouch) {
		self.location = uiTouch.locationInView(uiTouch.view)
		print(location)
	}
	
	public init(location: CGPoint) {
		self.location = location
	}
}
