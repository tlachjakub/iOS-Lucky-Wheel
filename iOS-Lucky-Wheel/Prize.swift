//
//  Prize.swift
//  iOS-Lucky-Wheel
//
//  Created by Jakub Tlach on 12/25/17.
//  Copyright © 2017 Jakub Tlach. All rights reserved.
//

import UIKit

class Prize: NSObject {

	let name: String
	let icon: String
	let angle: CGFloat
	var count: Int
	var maxCount: Int
	var probability: Int
	
	
	init(name: String, icon: String, angle: CGFloat, count: Int, maxCount: Int, probability: Int) {
		
		self.name = name
		self.icon = icon
		self.angle = angle
		self.count = count
		self.maxCount = maxCount
		self.probability = probability
		
		super.init()
	}

}
