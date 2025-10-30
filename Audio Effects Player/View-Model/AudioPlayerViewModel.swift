//
//  AudioPlayerViewModel.swift
//  Audio Effects Player
//
//  Created by hadiajabran on 14/10/2025.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

@MainActor
final class AudioPlayerViewModel: ObservableObject {
	@Published var title: String = "Sample Track"
	@Published var duration: TimeInterval = 0
	@Published var currentTime: TimeInterval = 0
	@Published var isPlaying: Bool = false
	@Published var rate: Float = 1.0 { didSet { engine.setRate(rate) } }
	@Published var pitch: Float = 0.0 { didSet { engine.setPitch(pitch) } }
	@Published var reverbEnabled: Bool = false { didSet { engine.setReverb(enabled: reverbEnabled) } }
	@Published var echoEnabled: Bool = false { didSet { engine.setDelay(enabled: echoEnabled) } }
	
	private let engine = AudioEngineManager()
	private var timer: Timer?
	
	init() {
		rate = 1.0
		pitch = 0
		reverbEnabled = false
		echoEnabled = false
	}
	

	func loadBundledAudio(named fileName: String, ext: String = "mp3") {
		if let url = Bundle.main.url(forResource: fileName, withExtension: ext) {
			do {
				try engine.load(fileURL: url)
				duration = engine.duration()
				title = fileName
				
				engine.setRate(rate)
				engine.setPitch(pitch)
				engine.setReverb(enabled: reverbEnabled)
				engine.setDelay(enabled: echoEnabled)
			} catch {
				print("Failed to load audio:", error)
			}
		} else {
			print("Audio file not found in bundle.")
		}
	}

	func play() {
		Task {
			do {
				try engine.play(from: currentTime)
				isPlaying = true
				startTimer()
			} catch {
				print("Play error:", error)
			}
		}
	}
	
	func pause() {
		engine.pause()
		isPlaying = false
		stopTimer()
	}
	
	func stop() {
		engine.stop()
		isPlaying = false
		currentTime = 0
		stopTimer()
	}
	
	func resetEffects() {
		rate = 1.0
		pitch = 0.0
		reverbEnabled = false
		echoEnabled = false
		engine.setRate(rate)
		engine.setPitch(pitch)
		engine.setReverb(enabled: false)
		engine.setDelay(enabled: false)
	}

	func seek(to time: TimeInterval) {
		currentTime = max(0, min(time, duration))
		
		if isPlaying {
			Task {
				do {
					try engine.play(from: currentTime)
				} catch {
					print("Seek play error:", error)
				}
			}
		} else {
			// update engine's internal position for next play by scheduling from this time
			// handled during play(from:)
		}
	}

	private func startTimer() {
		stopTimer()
		timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
			guard let self = self else { return }
			let t = self.engine.currentTime()
			Task { @MainActor in
				self.currentTime = t
				if self.currentTime >= self.duration - 0.05 {
					self.stop()
				}
			}
		}
	}
	
	private func stopTimer() {
		timer?.invalidate()
		timer = nil
	}
}
