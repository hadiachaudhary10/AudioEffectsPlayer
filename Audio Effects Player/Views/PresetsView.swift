//
//  PresetsView.swift
//  Audio Effects Player
//
//  Created by hadiajabran on 15/10/2025.
//

import SwiftUI

struct PresetsView: View {
	@ObservedObject var vm: AudioPlayerViewModel
	
	var body: some View {
		HStack(spacing: 12) {
			PresetButton(title: "Deep", emoji: "🎤") {
				vm.pitch = -700
				vm.rate = 0.9
				vm.reverbEnabled = true
				vm.echoEnabled = false
			}
			PresetButton(title: "Robot", emoji: "👾") {
				vm.pitch = -300
				vm.rate = 1.2
				vm.reverbEnabled = false
				vm.echoEnabled = true
			}
			PresetButton(title: "Chipmunk", emoji: "🐿") {
				vm.pitch = 900
				vm.rate = 1.4
				vm.reverbEnabled = false
				vm.echoEnabled = false
			}
			PresetButton(title: "Studio", emoji: "🏠") {
				vm.pitch = 0
				vm.rate = 1.0
				vm.reverbEnabled = true
				vm.echoEnabled = true
			}
		}
	}
}

struct PresetButton: View {
	let title: String
	let emoji: String
	let action: () -> Void
	
	var body: some View {
		Button(action: action) {
			VStack(spacing: 8) {
				Text(emoji)
				Text(title)
					.font(.caption)
					.bold()
			}
			.padding(.vertical, 8)
			.frame(width: 70)
			.background(LinearGradient(colors: [Color.white.opacity(0.12), Color.white.opacity(0.06)], startPoint: .topLeading, endPoint: .bottomTrailing))
			.cornerRadius(12)
		}
		.buttonStyle(PlainButtonStyle())
	}
}

