//
//  Color+Extensions.swift
//  Audio Effects Player
//
//  Created by hadiajabran on 15/10/2025.
//

import SwiftUI

extension Color {
	static let bgStart = Color(red: 18/255, green: 12/255, blue: 40/255)
	static let bgEnd = Color(red: 58/255, green: 16/255, blue: 100/255)
	
	static func named(_ name: String) -> Color {
		Color(name)
	}
}
