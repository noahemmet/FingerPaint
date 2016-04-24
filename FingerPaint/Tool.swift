//
//  Tools.swift
//  FingerPaint
//
//  Created by Noah Emmet on 4/21/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public enum AnchorType {
	case Center
	case Corner
}

public enum Tool {
	case Line
	case Square
	case Circle
	case Polygon
	case Spiral
}

public enum FinalEdit {
	case Fill()
}