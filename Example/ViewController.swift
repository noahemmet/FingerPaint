//
//  ViewController.swift
//  Example
//
//  Created by Noah Emmet on 4/24/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import UIKit
import FingerPaint

class ViewController: UIViewController {
	
	@IBOutlet var canvasView: CanvasView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		canvasView.canvasDelegate = self
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}


extension ViewController: CanvasDelegate {
	func touchPathCreated(touchPath: TouchPath) {
		print("created", touchPath)
	}
	
	func touchPathUpdated(touchPath: TouchPath) {
		print("updated", touchPath)
	}
	
	func touchPathEnded(touchPath: TouchPath) {
		print("ended", touchPath)
	}
}