//
//  ArrayExtensions.swift
//  FingerPaint
//
//  Created by Noah Emmet on 5/8/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

extension Array {
	public func elementAtIndex(index: Int) -> Element? {
		guard index < self.count && index > 0 else {
			return nil
		}
		
		return self[index]
	}
	
	
}

extension Array where Element: Equatable {
	public mutating func insertUniquely(element: Element) {
		if !self.contains(element) {
			self.append(element)
		}
	}
	
	public mutating func insertUniqueContentsOf(elements: [Element]) {
		for element in elements {
			self.insertUniquely(element)
		}
	}
	
	public mutating func remove(element: Element) {
		guard let index = self.indexOf(element) else {
			print("element not found")
			return
		}
		self.removeAtIndex(index)
	}
	
	public mutating func removeContentsOf(elements: [Element]) {
		for element in elements {
			self.remove(element)
		}
	}
}