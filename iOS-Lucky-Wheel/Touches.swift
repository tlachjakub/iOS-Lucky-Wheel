//
//  Touches.swift
//  iOS-Lucky-Wheel
//
//  Created by Jakub Tlach on 12/20/17.
//  Copyright © 2017 Jakub Tlach. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
	
	
	// Position, where the touch started on the screen
	//////////////////////////////////////////////////////////////////////////////////////////////////
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		if let touch = touches.first {
			
			self.imageView.layer.removeAllAnimations()
			
			// Current Touch Angle
			let position = touch.preciseLocation(in: self.mainView)
			let center = imageView.center
			startTouchAngle = center.angleRadPositiveToPoint(position)
			
			
			// Current Image Angle
			startImageAngle = CGFloat(atan2f(Float(imageView.transform.b), Float(imageView.transform.a)))
			moveTouchAngle = 0.0
		}
	}
	
	
	
	// Move with wheel while moving with finger on the screen
	//////////////////////////////////////////////////////////////////////////////////////////////////
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		if let touch = touches.first {
			
			// Current Touch Angle
			let position = touch.preciseLocation(in: self.mainView)
			let center = imageView.center
			moveTouchAngle = center.angleRadPositiveToPoint(position)
			
			print("angle: \(moveTouchAngle)")
			rotateAngle(angle: startImageAngle + (moveTouchAngle - startTouchAngle))
		}
	}
	
	
	
	
	// Position, where the touch ended on the screen
	//////////////////////////////////////////////////////////////////////////////////////////////////
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		if moveTouchAngle == 0 {
			return
		}
		
		if let touch = touches.first {
			
			// Current Touch Angle
			let position = touch.preciseLocation(in: self.mainView)
			let center = imageView.center
			let lastTouchAngle = center.angleRadPositiveToPoint(position)
			
			
			let delta = lastTouchAngle - moveTouchAngle
			//if delta < 0 { delta *= -1 }
			let start = startImageAngle + (moveTouchAngle - startTouchAngle)
			lastAngle = start + delta
			//let rounded = myRound(number: moveTouchAngle)
			random = CGFloat(arc4random_uniform(12))
			let randomCase = myRoundInt(number: random)
			
			let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
			rotateAnimation.fromValue = start
			rotateAnimation.toValue = myRoundInt(number: random)
			rotateAnimation.duration = min(max(Double(delta * 10), 4), 8)
			rotateAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.0, 0.5, 0.3, 1)
			rotateAnimation.delegate = self
			
			self.imageView.layer.add(rotateAnimation, forKey: nil)
			
			print("random: \(randomCase)")
			//print("rounded: \(rounded)")
			print("delta: \(delta * 100)")
			
			self.view.isUserInteractionEnabled = false
		}
	}
	
	
}
