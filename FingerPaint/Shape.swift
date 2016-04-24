//
//  Shapes.swift
//  FingerPaint
//
//  Created by Noah Emmet on 4/21/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public enum Border {
	case None
	case SingleLine
}

public enum Fill {
	case Empty
	case Solid
	case Checkered
	case Stripes(rows: Int, columns: Int, offset: Int)
}

public struct Shape {
	public let points: [CGPoint]
	public let border: Border
	public let fill: Fill
	public init(points: [CGPoint], border: Border = .SingleLine, fill: Fill = .Empty) {
		self.points = points
		self.border = border
		self.fill = fill
	}
}
