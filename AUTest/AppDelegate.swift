//
//  AppDelegate.swift
//  AUTest
//
//  Created by Eric Kampman on 11/18/16.
//  Copyright © 2016 Eric Kampman. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	var auTestWindowController: AUTestWindowController!
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		auTestWindowController = AUTestWindowController(windowNibName: "AUTestWindowController")
		auTestWindowController.showWindow(self)
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


}

