//
//  TouchManagerTestCase.swift
//  FingerPaint
//
//  Created by Noah Emmet on 5/4/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import XCTest
@testable import FingerPaint

let testPointOne = CGPoint(x: 0, y: 0)
let testPointTwo = CGPoint(x: 10, y: 10)
let testPointThree = CGPoint(x: 25, y: 15)
let testPointFour = CGPoint(x: 40, y: 65)
let testPointFive = CGPoint(x: 70, y: 100)

class TouchManagerTestCase: XCTestCase {
	var touchManager: TouchManager!
	
    override func setUp() {
        super.setUp()
		touchManager = TouchManager()
    }
    
    override func tearDown() {
        touchManager = nil
        super.tearDown()
    }

    func testTouchCount() {
		let touchOne = Touch(location: testPointOne)
		let touchTwo = Touch(location: testPointTwo)
		let touches: Set<Touch> = [touchOne, touchTwo]
		touchManager.addTouches(touches)
		// Initial add
		XCTAssertEqual(touchManager.touches.count, 2)
		// Add dupes
		touchManager.addTouches(touches)
		XCTAssertEqual(touchManager.touches.count, 2)
		// Remove first
		touchManager.removeTouches([touchOne])
		XCTAssertEqual(touchManager.touches.count, 1)
		// Remove dupe
		touchManager.removeTouches([touchOne])
		XCTAssertEqual(touchManager.touches.count, 1)
		// Remove second
		touchManager.removeTouches([touchTwo])
		XCTAssertEqual(touchManager.touches.count, 0)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
