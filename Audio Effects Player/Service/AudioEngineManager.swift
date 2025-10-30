//
//  AudioEngineManager.swift
//  Audio Effects Player
//
//  Created by hadiajabran on 14/10/2025.
//

import Foundation
import AVFoundation

final class AudioEngineManager {
	private let engine = AVAudioEngine()
	private let playerNode = AVAudioPlayerNode()
	private let timePitch = AVAudioUnitTimePitch()
	private let reverb = AVAudioUnitReverb()
	private let delay = AVAudioUnitDelay()
	
	private var audioFile: AVAudioFile?
	private var audioLengthSeconds: TimeInterval = 0
	
	init() {
		setupEngine()
	}
	
	private func setupEngine() {
		timePitch.rate = 1.0
		timePitch.pitch = 0.0
		reverb.loadFactoryPreset(.mediumHall)
		reverb.wetDryMix = 0
		delay.wetDryMix = 0
		delay.delayTime = 0.3
		delay.feedback = 30

		engine.attach(playerNode)
		engine.attach(timePitch)
		engine.attach(reverb)
		engine.attach(delay)

		engine.connect(playerNode, to: timePitch, format: nil)
		engine.connect(timePitch, to: reverb, format: nil)
		engine.connect(reverb, to: delay, format: nil)
		engine.connect(delay, to: engine.mainMixerNode, format: nil)
	}
	
	func load(fileURL: URL) throws {
		stop()
		audioFile = try AVAudioFile(forReading: fileURL)
		if let file = audioFile {
			audioLengthSeconds = file.length == 0 ? 0 : Double(file.length) / file.processingFormat.sampleRate
		} else {
			audioLengthSeconds = 0
		}
	}
	
	func duration() -> TimeInterval { audioLengthSeconds }
	
	func startEngineIfNeeded() throws {
		if !engine.isRunning {
			try engine.start()
		}
	}
	
	func play(from time: TimeInterval = 0) throws {
		guard let file = audioFile else { return }
		try startEngineIfNeeded()
		playerNode.stop()

		let sampleRate = file.processingFormat.sampleRate
		let startFrame = AVAudioFramePosition(time * sampleRate)
		let framesToPlay = file.length - startFrame
		if framesToPlay <= 0 { return }
		
		playerNode.scheduleSegment(file, startingFrame: startFrame, frameCount: AVAudioFrameCount(framesToPlay), at: nil) {}
		playerNode.play()
	}
	
	func pause() {
		playerNode.pause()
	}
	
	func stop() {
		playerNode.stop()
	}
	
	var isPlaying: Bool {
		playerNode.isPlaying
	}

	func setRate(_ rate: Float) {
		timePitch.rate = max(0.25, min(rate, 4.0))
	}
	
	func setPitch(_ cents: Float) {
		timePitch.pitch = cents
	}
	
	func setReverb(enabled: Bool, wetDry: Float = 50) {
		reverb.wetDryMix = enabled ? wetDry : 0
	}
	
	func setDelay(enabled: Bool, time: TimeInterval = 0.25, wetDry: Float = 30) {
		delay.delayTime = max(0, min(time, 2.0))
		delay.wetDryMix = enabled ? wetDry : 0
	}

	func currentTime() -> TimeInterval {
		guard let nodeTime = playerNode.lastRenderTime,
			  let playerTime = playerNode.playerTime(forNodeTime: nodeTime),
			  let file = audioFile
		else { return 0 }
		let seconds = Double(playerTime.sampleTime) / playerTime.sampleRate
		return max(0, min(seconds, duration()))
	}
}
