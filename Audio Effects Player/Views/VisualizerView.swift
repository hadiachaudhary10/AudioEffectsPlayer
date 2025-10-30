//
//  VisualizerView.swift
//  Audio Effects Player
//
//  Created by hadiajabran on 15/10/2025.
//

import SwiftUI

struct VisualizerView: View {
	let level: TimeInterval
	let isPlaying: Bool
	@State private var phases: [Double] = Array(repeating: 0, count: 12)
	
	var body: some View {
		HStack(alignment: .center, spacing: 6) {
			ForEach(0..<phases.count, id: \.self) { i in
				Capsule()
					.fill(LinearGradient(colors: [Color.white.opacity(0.95), Color.white.opacity(0.6)], startPoint: .top, endPoint: .bottom))
					.frame(width: 8, height: barHeight(index: i))
					.opacity(isPlaying ? 1 : 0.5)
					.animation(.easeInOut(duration: 0.25 + Double(i) * 0.02), value: phases[i])
			}
		}
		.onAppear {
			for i in phases.indices { phases[i] = Double.random(in: 0.2...1.0) }

			withAnimation(.linear(duration: 0.4).repeatForever(autoreverses: true)) {
				for i in phases.indices { phases[i] = Double.random(in: 0.2...1.0) }
			}
		}
		.onChange(of: level, { oldValue, newValue in
			if isPlaying {
				for i in phases.indices {
					phases[i] = 0.3 + 0.7 * fmod((level / 0.3) + Double(i) * 0.13, 1.0)
				}
			}
		})
	}
	
	private func barHeight(index: Int) -> CGFloat {
		let base: CGFloat = 20
		let variable = CGFloat(phases[index]) * 80
		return base + variable
	}
}
