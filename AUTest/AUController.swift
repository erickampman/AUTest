//
//  AUController.swift
//  AUTest
//
//  Created by Eric Kampman on 11/18/16.
//  Copyright © 2016 Eric Kampman. All rights reserved.
//

import Cocoa
import AVFoundation


let kAudioUnitSubType_Sin3 = UTGetOSTypeFromString("sin3" as CFString)
let kAudioUnitSubType_Filter = UTGetOSTypeFromString("f1tR" as CFString)
let kAudioUnitManufacturer_Demo = UTGetOSTypeFromString("Demo" as CFString)

let MIDI_NOTE_OFF = UInt8(0x80)
let MIDI_NOTE_ON = UInt8(0x90)

enum NoteDirection {
	case up
	case down
}

class AUController: NSObject {
	func setupSynth() {
		let synthDesc = AudioComponentDescription(componentType: kAudioUnitType_MusicDevice,
		                                          componentSubType: kAudioUnitSubType_Sin3,
		                                          componentManufacturer: kAudioUnitManufacturer_Demo,
		                                          componentFlags: 0, componentFlagsMask: 0);
		
		weak var weakSelf = self
		AVAudioUnit.instantiate(with: synthDesc, options: []) {
			//			[weak self]
			au, error in

			guard let strongSelf = weakSelf else { return }
			guard let au = au else { return }
			strongSelf.synthAU = au
			
			strongSelf.noteBlock = au.auAudioUnit.scheduleMIDIEventBlock
			
			strongSelf.auEngine.attach(au)
			
			let hardwareFormat = strongSelf.auEngine.outputNode.outputFormat(forBus: 0)
			
			let stereoFormat = AVAudioFormat(standardFormatWithSampleRate: hardwareFormat.sampleRate, channels: 2)
			strongSelf.auEngine.connect(self.synthAU!, to: strongSelf.auEngine.mainMixerNode, format: stereoFormat)
			
		}
	}

	func setupEffect() {
		let effectDesc = AudioComponentDescription(componentType: kAudioUnitType_Effect,
		                                           componentSubType: kAudioUnitSubType_Filter,
		                                           componentManufacturer: kAudioUnitManufacturer_Demo,
		                                           componentFlags: 0, componentFlagsMask: 0);
		
		
		AVAudioUnit.instantiate(with: effectDesc, options: []) {
			//			[weak self]
			au, error in
			guard let au = au else { return }
			guard let synthAU = self.synthAU  else { return }
			self.effectAU = au
			
			self.auEngine.attach(au)
			
			// it would be more efficient to connect everything at once...
			self.auEngine.disconnectNodeInput(self.auEngine.mainMixerNode)
			let hardwareFormat = self.auEngine.outputNode.outputFormat(forBus: 0)
			let stereoFormat = AVAudioFormat(standardFormatWithSampleRate: hardwareFormat.sampleRate, channels: 2)
			self.auEngine.connect(synthAU, to: self.effectAU!, format: stereoFormat)
			self.auEngine.connect(self.effectAU!, to: self.auEngine.mainMixerNode, format: stereoFormat)
		}
	}
	
	func startPlaying() {
		guard noteTimer == nil else { return }
		
		do {
			try auEngine.start()
		}
		catch {
			fatalError("Could not start engine. error: \(error).")
		}
		
		noteTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(AUController.doNextNote), userInfo: nil, repeats: true)
		
		doNote(key: notes[noteIndex], direction: .down)
	}
	
	func stopPlaying() {
		guard let timer = noteTimer else { return }
		
		timer.invalidate()
		noteTimer = nil
		
		doNote(key: notes[noteIndex], direction: .up)
		incrementNoteIndex()
		
		auEngine.stop()
	}
	
	private func doNote(key: UInt8, direction: NoteDirection) {
		var bytes: [UInt8] = [0, 0, 100];

		withUnsafePointer(to: &bytes) {p in
			var bytes = p.pointee
			
			bytes[0] = direction == .down ? MIDI_NOTE_ON : MIDI_NOTE_OFF
			bytes[1] = key
			bytes[2] = 100	// velocity
			
			self.noteBlock(AUEventSampleTimeImmediate, 0, 3, bytes)
		}
	}
	
	private func incrementNoteIndex() {
		noteIndex += 1
		if noteIndex == notes.count {
			noteIndex = 0
		}
	}
	
	func doNextNote(timer: Timer) {
		doNote(key: notes[noteIndex], direction: .up)
		incrementNoteIndex()
		doNote(key: notes[noteIndex], direction: .down)
		
	}
	
	public var isPlaying: Bool {
		get {
			return noteTimer != nil
		}
	}


	private let notes: [UInt8] = [ 74, 76, 72, 60, 67 ]
	private var noteIndex = 0
	private var playing = false
	private var noteTimer: Timer?
	
	public var synthAU: AVAudioUnit?
	public var effectAU: AVAudioUnit?
	private let auEngine = AVAudioEngine()
	private var noteBlock: AUScheduleMIDIEventBlock!
	

}
