//
//  ControlsView.swift
//  Audio Effects Player
//
//  Created by hadiajabran on 15/10/2025.
//

import SwiftUI

struct ControlsView: View {
	@ObservedObject var vm: AudioPlayerViewModel
	
	var body: some View {
		HStack(spacing: 32) {
			NeoButton(icon: "stop.fill", color: Color.white.opacity(0.12)) {
				vm.stop()
			}
			NeoButton(icon: vm.isPlaying ? "pause.fill" : "play.fill", color: Color.blue) {
				if vm.isPlaying { vm.pause() } else { vm.play() }
			}
			NeoButton(icon: "gobackward", color: Color.white.opacity(0.12)) {
				let new = max(vm.currentTime - 3, 0)
				vm.seek(to: new)
			}
			NeoButton(icon: "goforward", color: Color.white.opacity(0.12)) {
				let new = min(vm.currentTime + 3, vm.duration)
				vm.seek(to: new)
			}
		}
	}
}

struct NeoButton: View {
	let icon: String
	let color: Color
	let action: () -> Void
	
	var body: some View {
		Button(action: action) {
			Image(systemName: icon)
				.font(.system(size: 22, weight: .semibold))
				.foregroundColor(icon == "play.fill" ? .white : .white)
				.frame(width: 64, height: 64)
				.background(
					ZStack {
						RoundedRectangle(cornerRadius: 18, style: .continuous)
							.fill(color)
						RoundedRectangle(cornerRadius: 18, style: .continuous)
							.stroke(Color.white.opacity(0.06), lineWidth: 1)
					}
				)
		}
		.buttonStyle(PlainButtonStyle())
		.shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 6)
	}
}

