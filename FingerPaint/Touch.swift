//
//  Touch.swift
//  FingerPaint
//
//  Created by Noah Emmet on 4/20/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public struct Touch {
	
	enum Event {
		case Down
		case Up
	}
	
	let location: CGPoint
	let event: Event
	init(location: CGPoint, event: Event = .Down) {
		self.location = location
		self.event = event
	}
}