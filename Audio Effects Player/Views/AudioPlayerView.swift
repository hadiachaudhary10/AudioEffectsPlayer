//
//  AudioPlayerView.swift
//  Audio Effects Player
//
//  Created by hadiajabran on 14/10/2025.
//

import SwiftUI

struct AudioPlayerView: View {
	@StateObject private var vm = AudioPlayerViewModel()
	
	var body: some View {
		ZStack {
			LinearGradient(
				gradient: Gradient(colors: [Color.bgStart, Color.bgEnd]),
				startPoint: .topLeading,
				endPoint: .bottomTrailing
			)
			.ignoresSafeArea()
			
			VStack(spacing: 20) {
				
				HeaderView(title: vm.title, isPlaying: vm.isPlaying, progress: vm.currentTime / max(vm.duration, 1))
					.padding(.top, 40)
	
				VisualizerView(level: vm.currentTime, isPlaying: vm.isPlaying)
					.frame(height: 120)
					.padding(.horizontal)
	
				VStack {
					Slider(value: Binding(
						get: { vm.currentTime },
						set: { newValue in vm.seek(to: newValue) }
					), in: 0...max(vm.duration, 0.0001))
					.accentColor(.white)
					
					HStack {
						Text(timeString(vm.currentTime))
							.font(.caption2)
							.foregroundColor(.white.opacity(0.8))
						Spacer()
						Text(timeString(vm.duration))
							.font(.caption2)
							.foregroundColor(.white.opacity(0.8))
					}
					.padding(.horizontal)
				}
			
				EffectsPanelView(vm: vm)
					.padding(.horizontal)
	
				PresetsView(vm: vm)
					.padding(.horizontal)

				ControlsView(vm: vm)
					.padding(.vertical)
				
				Spacer(minLength: 12)
			}
			.padding()
			.background(.ultraThinMaterial)
			.clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
			.padding(16)
			.shadow(color: Color.black.opacity(0.25), radius: 20, x: 0, y: 10)
		}
		.onAppear {
			vm.loadBundledAudio(named: "ABC-Song", ext: "mp3")
		}
	}

	func timeString(_ t: TimeInterval) -> String {
		guard t.isFinite && t > 0 else { return "0:00" }
		let total = Int(t)
		let s = total % 60
		let m = (total / 60) % 60
		return String(format: "%d:%02d", m, s)
	}
}
