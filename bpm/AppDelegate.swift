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
            button.keyEquivalent = ""
            
        }
        let answer = dialogOKCancel("Instructions", text: ("Control-Click to quit the app.\nTap to calculate BPM.\n\n\nBuilt by Ben Brook:   www.builtbybenbrook.com"))
    }
    
    var lastPress = NSDate()
    var avg = 0.0
    var i = 1.0
    var timer = NSTimer()
    
    
    func dialogOKCancel(question: String, text: String) -> Bool {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = question
        myPopup.informativeText = text
        myPopup.alertStyle = NSAlertStyle.WarningAlertStyle
        myPopup.addButtonWithTitle("OK")
        let res = myPopup.runModal()
        if res == NSAlertFirstButtonReturn {
            return true
        }
        return false
    }
    
    func clicked(sender: AnyObject?) {
        var clickMask: Int = 0
        let clickEvent = NSApp.currentEvent!  // see what caused calling of the menu action
            // modifierFlags contains a number with bits set for various modifier keys
            // ControlKeyMask is the enum for the Ctrl key
            // use logical and with the raw values to find if the bit is set in modifierFlags
        clickMask = Int(clickEvent.modifierFlags.rawValue) & Int(NSEventModifierFlags.ControlKeyMask.rawValue)
        
        if clickMask != 0 { NSApplication.sharedApplication().terminate(self) } // click with Ctrl pressed
            
        // Regular click
        else {
            timer.invalidate()
            let elapsedTime = NSDate().timeIntervalSinceDate(lastPress)
            print(elapsedTime)
            if elapsedTime > 2.5 {
                print("1")
                avg = 0.0
                i = 1.0
                lastPress = NSDate()
            } else {
                print("2")
                avg = (avg*(i-1) + elapsedTime) / i
                lastPress = NSDate()
                i = i + 1
                let x = Int(60/avg)
                statusItem.title = String(x)
            }
            timer = NSTimer.scheduledTimerWithTimeInterval(2.5, target:self, selector: Selector("updateCounter"), userInfo: nil, repeats: false)
        }
    }
    
    func updateCounter() {
        statusItem.title = "bpm"
    }
    
}