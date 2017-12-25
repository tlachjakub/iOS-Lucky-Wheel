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
	var icon: String
	
	
	
	init(name: String, icon: String) {
		self.name = name
		self.icon = icon
		super.init()
	}
	
	
	
}
