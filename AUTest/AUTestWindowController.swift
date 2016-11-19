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

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
	@IBAction func play(_ sender: NSButton) {
	}
	@IBOutlet weak var showSynthButton: NSButton!
	@IBOutlet weak var showEffectButton: NSButton!
	@IBOutlet var popover: NSPopover!
}
