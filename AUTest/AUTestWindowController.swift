//
//  AUTestWindowController.swift
//  AUTest
//
//  Created by Eric Kampman on 11/18/16.
//  Copyright © 2016 Eric Kampman. All rights reserved.
//

import Cocoa

class AUTestWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
		
		auController.setupSynth()
		auController.setupEffect()
    }
    
	@IBAction func playStop(_ sender: NSButton) {
		if auController.isPlaying {
			auController.stopPlaying()
		} else {
			auController.startPlaying()
		}
	}
	
	dynamic var playButtonTitle: String {
		get {
			return auController.isPlaying ? "Stop" : "Play"
		}
	}
	
	@IBOutlet weak var showSynthButton: NSButton!
	@IBOutlet weak var showEffectButton: NSButton!
	@IBOutlet weak var playButton: NSButton!
	@IBOutlet var popover: NSPopover!
	
	dynamic let auController = AUController()
}
