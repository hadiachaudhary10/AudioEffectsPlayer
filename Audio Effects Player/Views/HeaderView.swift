//
//  HeaderView.swift
//  Audio Effects Player
//
//  Created by hadiajabran on 15/10/2025.
//

import SwiftUI

struct HeaderView: View {
	let title: String
	let isPlaying: Bool
	let progress: Double
	
	var body: some View {
		VStack(spacing: 8) {
			HStack {
				VStack(alignment: .leading, spacing: 4) {
					Text("Audio Effects")
						.font(.headline)
						.foregroundColor(.white)
						.bold()
					Text(title)
						.font(.subheadline)
						.foregroundColor(.white.opacity(0.9))
				}
				Spacer()

				Circle()
					.fill(isPlaying ? Color.green : Color.gray)
					.frame(width: 14, height: 14)
					.overlay(
						Circle()
							.stroke(Color.white.opacity(0.2), lineWidth: 1)
					)
			}

			ZStack(alignment: .leading) {
				Capsule()
					.fill(Color.white.opacity(0.12))
					.frame(height: 6)
				Capsule()
					.fill(LinearGradient(colors: [Color.white.opacity(0.9), Color.white.opacity(0.5)], startPoint: .leading, endPoint: .trailing))
					.frame(width: max(6, CGFloat(progress) * UIScreen.main.bounds.width * 0.65), height: 6)
					.animation(.easeInOut(duration: 0.15), value: progress)
			}
		}
		.padding(.horizontal)
	}
}
