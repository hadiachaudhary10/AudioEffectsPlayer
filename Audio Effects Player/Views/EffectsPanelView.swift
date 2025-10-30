//
//  EffectsPanelView.swift
//  Audio Effects Player
//
//  Created by hadiajabran on 15/10/2025.
//

import SwiftUI

struct EffectsPanelView: View {
	@ObservedObject var vm: AudioPlayerViewModel
	
	var body: some View {
		VStack(spacing: 12) {
			HStack {
				Label("Effects", systemImage: "slider.horizontal.3")
					.font(.subheadline)
					.foregroundColor(.white)
				Spacer()
				Button(action: { vm.resetEffects() }) {
					Text("Reset")
						.font(.caption)
						.foregroundColor(.white.opacity(0.9))
						.padding(.horizontal, 10)
						.padding(.vertical, 6)
						.background(Color.white.opacity(0.08))
						.clipShape(Capsule())
				}
			}
	
			VStack(alignment: .leading) {
				Text("Speed: \(String(format: "%.2fx", vm.rate))")
					.font(.caption)
					.foregroundColor(.white.opacity(0.9))
				GradientSlider(value: $vm.rate, range: 0.5...2.0, gradient: LinearGradient(colors: [Color.pink, Color.purple], startPoint: .leading, endPoint: .trailing))
			}
	
			VStack(alignment: .leading) {
				Text("Pitch: \(Int(vm.pitch)) cents")
					.font(.caption)
					.foregroundColor(.white.opacity(0.9))
				GradientSlider(value: $vm.pitch, range: -1200...1200, gradient: LinearGradient(colors: [Color.blue, Color.cyan], startPoint: .leading, endPoint: .trailing))
			}
		
			HStack(spacing: 20) {
				ToggleIcon(title: "Reverb", systemIcon: "aqi.medium", isOn: $vm.reverbEnabled)
				ToggleIcon(title: "Echo", systemIcon: "waveform.path.ecg", isOn: $vm.echoEnabled)
			}
		}
		.padding()
		.background(Color.white.opacity(0.06))
		.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
	}
}

struct ToggleIcon: View {
	let title: String
	let systemIcon: String
	@Binding var isOn: Bool
	
	var body: some View {
		Toggle(isOn: $isOn) {
			Label(title, systemImage: systemIcon)
				.font(.caption)
				.foregroundColor(.white)
		}
		.toggleStyle(SwitchToggleStyle(tint: .gray))
	}
}

struct GradientSlider: View {
	@Binding var value: Float
	let range: ClosedRange<Float>
	let gradient: LinearGradient
	
	var body: some View {
		GeometryReader { g in
			ZStack(alignment: .leading) {
				Capsule()
					.fill(Color.white.opacity(0.12))
					.frame(height: 6)
				Capsule()
					.fill(gradient)
					.frame(width: progressWidth(in: g.size.width), height: 6)
			}
			.cornerRadius(6)
		}
		.overlay {
			Slider(value: Binding(get: { Double(value) }, set: { value = Float($0) }), in: Double(range.lowerBound)...Double(range.upperBound))
				.accentColor(.clear)
				.offset(y: 3)
		}
		.padding()
	}
	
	private func progressWidth(in full: CGFloat) -> CGFloat {
		let pct = CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound))
		return max(6, full * pct)
	}
}
