//
//  AppDelegate.swift
//  bpm
//
//  Created by Ben Brook on 2015-12-21.
//  Copyright © 2015 Ben Brook. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        statusItem.title = "bpm"
        if let button = statusItem.button {
            button.action = Selector("clicked:")
        }
    }
    
    var lastPress = NSDate()
    var avg = 0.0
    var i = 1.0
    var timer = NSTimer()
    
    func clicked(sender: AnyObject?) {
        timer.invalidate()
        let elapsedTime = NSDate().timeIntervalSinceDate(lastPress)
        if elapsedTime > 2.5 {
            avg = 0.0
            i = 1.0
            lastPress = NSDate()
        } else {
            avg = (avg*(i-1) + elapsedTime) / i
            lastPress = NSDate()
            i = i + 1
            let x = Int(60/avg)
            statusItem.title = String(x)
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(2.5, target:self, selector: Selector("updateCounter"), userInfo: nil, repeats: false)
    }
    
    func updateCounter() {
        statusItem.title = "bpm"
    }
    
}