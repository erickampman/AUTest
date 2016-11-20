//
//  AUTestWindowController.swift
//  AUTest
//
//  Created by Eric Kampman on 11/18/16.
//  Copyright © 2016 Eric Kampman. All rights reserved.
//

import Cocoa
import AVFoundation
import CoreAudioKit

class AUTestWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
		
		auController.setupSynth()
		auController.setupEffect()
    }
    
	dynamic var playButtonTitle: String {
		get {
			return auController.isPlaying ? "Stop" : "Play"
		}
	}
	@IBAction func playStop(_ sender: NSButton) {
		if auController.isPlaying {
			auController.stopPlaying()
		} else {
			auController.startPlaying()
		}
	}
	
	@IBAction func showSynth(_ sender: NSButton) {
		guard let au = auController.synthAU?.auAudioUnit else {
			return
		}

		au.requestViewController { [weak self] viewController in
			guard let strongSelf = self else { return }
			
			guard let viewController = viewController else { return }
			
			//			let view = viewController.view
			
			strongSelf.synthPopover.contentViewController = viewController
			
			strongSelf.synthPopover.show(relativeTo: sender.bounds, of: sender,
			                        preferredEdge: NSRectEdge.maxX)
		}
	}
	
	@IBAction func showEffect(_ sender: NSButton) {
		guard let au = auController.effectAU?.auAudioUnit else {
			return
		}
		
		au.requestViewController { [weak self] viewController in
			guard let strongSelf = self else { return }
			
			guard let viewController = viewController else { return }
			
			strongSelf.effectPopover.contentViewController = viewController
			
			strongSelf.effectPopover.show(relativeTo: sender.bounds, of: sender,
			                        preferredEdge: NSRectEdge.maxX)
		}
	}
	
	@IBOutlet weak var showSynthButton: NSButton!
	@IBOutlet weak var showEffectButton: NSButton!
	@IBOutlet weak var playButton: NSButton!
	@IBOutlet var synthPopover: NSPopover!
	@IBOutlet var effectPopover: NSPopover!
	
	dynamic let auController = AUController()
}
