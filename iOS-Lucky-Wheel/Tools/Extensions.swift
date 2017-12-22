//
//  Extensions.swift
//  iOS-Lucky-Wheel
//
//  Created by Jakub Tlach on 12/13/17.
//  Copyright © 2017 Jakub Tlach. All rights reserved.
//

import Foundation
import UIKit




////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: CGPoint extension
////////////////////////////////////////////////////////////////////////////////////////////////

extension CGPoint {
	
	static func pointBetween(_ left: CGPoint, andPoint right: CGPoint) -> CGPoint {
		return CGPoint(x: (right.x - left.x) / 2.0 + left.x, y: (right.y - left.y) / 2.0 + left.y)
	}
	
	
	func distanceToPoint(_ right: CGPoint) -> CGFloat {
		let l: CGFloat = fabs(right.x - self.x) as CGFloat
		let h: CGFloat = fabs(right.y - self.y) as CGFloat
		return sqrt(l * l + h * h)
	}
	
	func angleToPoint(_ right: CGPoint) -> CGFloat {
		return (180 / CGFloat.pi) * self.angleRadToPoint(right)
	}
	
	func angleRadToPoint(_ point: CGPoint) -> CGFloat {
		var l = point.x - self.x
		let h = point.y - self.y
		
		if l == 0.0 {
			l = 0.000001
		}
		
		if self.x > point.x {
			return atan(h / l) + CGFloat.pi
		} else {
			return atan(h / l)
		}
	}
	
	func angleRadPositiveToPoint(_ point: CGPoint) -> CGFloat {
		var angle = self.angleRadToPoint(point)
		if angle < 0.0 {
			angle += (CGFloat.pi * 2.0)
		}
		return angle
	}
	
	func angleRadToPoint(_ point: CGPoint, startingAt startAngle:CGFloat) -> CGFloat {
		var angle = self.angleRadToPoint(point) - startAngle
		if angle < 0.0 {
			angle += (CGFloat.pi * 2.0)
		}
		return angle
	}
	
	func pointAtDistance(_ distance: CGFloat, angle: CGFloat) -> CGPoint {
		let x = self.x + cos(angle * (CGFloat.pi / 180.0)) * distance
		let y = self.y + sin(angle * (CGFloat.pi / 180.0)) * distance
		return CGPoint(x: x, y: y)
	}
	
	func pointAtDistance(_ distance: CGFloat, angleRad: CGFloat) -> CGPoint {
		let x = self.x + cos(angleRad) * distance
		let y = self.y + sin(angleRad) * distance
		return CGPoint(x: x, y: y)
	}
}




////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: CGFloat extension
////////////////////////////////////////////////////////////////////////////////////////////////

extension CGFloat {
	/// Randomly returns either 1.0 or -1.0.
	var randomSign:CGFloat {
		get {
			return (arc4random_uniform(2) == 0) ? 1.0 : -1.0
		}
	}
	/// Returns a random floating point number between 0.0 and 1.0, inclusive.
	var random:CGFloat {
		get {
			return CGFloat(arc4random())
		}
	}
	/**
	Create a random num CGFloat
	
	- parameter min: CGFloat
	- parameter max: CGFloat
	
	- returns: CGFloat random number
	*/
	func random(min: CGFloat, max: CGFloat) -> CGFloat {
		return random * (max - min) + min
	}
}




////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: UIImage extension
////////////////////////////////////////////////////////////////////////////////////////////////

extension UIImage {
	func rotate(radians: Float) -> UIImage? {
		var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
		//Trim off the extremely small float value to prevent core graphics from rounding it up
		newSize.width = floor(newSize.width)
		newSize.height = floor(newSize.height)
		
		UIGraphicsBeginImageContext(newSize);
		let context = UIGraphicsGetCurrentContext()!
		
		//Move origin to middle
		context.translateBy(x: newSize.width/2, y: newSize.height/2)
		//Rotate around middle
		context.rotate(by: CGFloat(radians))
		
		self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
		
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage
	}
}




////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: Array extension
////////////////////////////////////////////////////////////////////////////////////////////////

extension Array {
	func randomIndex() -> Element? {
		if isEmpty { return nil }
		let index = Int(arc4random_uniform(UInt32(self.count)))
		return self[index]
	}
}
