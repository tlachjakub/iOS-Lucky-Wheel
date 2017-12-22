//
//  Calculations.swift
//  iOS-Lucky-Wheel
//
//  Created by Jakub Tlach on 12/20/17.
//  Copyright © 2017 Jakub Tlach. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
	
	// Round number by moved angle
	func myRound(number: CGFloat) -> CGFloat {
		
		if 0.0 <= number && number <= 2*CGFloat.pi/12 {
			return 0.0
		}
		if 2*CGFloat.pi/12 < number && number <= (2*CGFloat.pi/12)*2 {
			return (2*CGFloat.pi/12)*2
		}
		if (2*CGFloat.pi/12)*2 < number && number <= (2*CGFloat.pi/12)*3 {
			return (2*CGFloat.pi/12)*3
		}
		if (2*CGFloat.pi/12)*3 < number && number <= (2*CGFloat.pi/12)*4 {
			return (2*CGFloat.pi/12)*4
		}
		if (2*CGFloat.pi/12)*4 < number && number <= (2*CGFloat.pi/12)*5 {
			return (2*CGFloat.pi/12)*5
		}
		if (2*CGFloat.pi/12)*5 < number && number <= (2*CGFloat.pi/12)*6 {
			return (2*CGFloat.pi/12)*6
		}
		if (2*CGFloat.pi/12)*6 < number && number <= (2*CGFloat.pi/12)*7 {
			return (2*CGFloat.pi/12)*7
		}
		if (2*CGFloat.pi/12)*7 < number && number <= (2*CGFloat.pi/12)*8 {
			return (2*CGFloat.pi/12)*8
		}
		if (2*CGFloat.pi/12)*8 < number && number <= (2*CGFloat.pi/12)*9 {
			return (2*CGFloat.pi/12)*9
		}
		if (2*CGFloat.pi/12)*9 < number && number <= (2*CGFloat.pi/12)*10 {
			return (2*CGFloat.pi/12)*10
		}
		if (2*CGFloat.pi/12)*10 < number && number <= (2*CGFloat.pi/12)*11 {
			return (2*CGFloat.pi/12)*11
		}
		if (2*CGFloat.pi/12)*11 < number && number <= 2*CGFloat.pi {
			return (2*CGFloat.pi/12)*12
		}
		return 2*CGFloat.pi/12
	}
}
