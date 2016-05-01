//
//  Paint.swift
//  FingerPaint
//
//  Created by Noah Emmet on 4/28/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public enum Segment {
	// FreeForm?
	case Free(points: [CGPoint])
	case Line(pointOne: CGPoint, pointTwo: CGPoint)
	case Lines(points: [CGPoint])
}

/// Perhaps this always represents an in-progress `[Segment]`, 
/// with the non-mutable variant simply a `[Segment]` itself.
public class Stroke {
	public private(set) var segments: [Segment]
	public private(set) var currentSegment: Segment
	var temporaryPoints: [CGPoint] = []
	
	public init(segment: Segment) {
		segments = [segment]
		currentSegment = segment
		appendSegment(segment)
	}
	
	public func appendPoint() {
		
	}
	
	public func appendSegment(segment: Segment) {
		segments.append(segment)
//		if currentSegment.dynamicType != segment.dynamicType {
//		}
//		switch segment {
//		case .Free(let points):
//			
//		}
		currentSegment = segment
	}
}