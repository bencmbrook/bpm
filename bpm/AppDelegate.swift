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
    
    // load NSUserDefaults
    let defaults = NSUserDefaults.standardUserDefaults()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        statusItem.title = "bpm"
        
        if let button = statusItem.button {
            button.action = Selector("clicked:")
            button.keyEquivalent = ""
        }
        
        if !defaults.boolForKey("noShowDialogOnStart") {
            dialogOKCancelNoshow("Instructions", text: ("Control-Click to quit the app.\nAlt-Click to show this window again.\n\nTap to calculate BPM.\n\n\nBuilt by Ben Brook:   www.builtbybenbrook.com"))
        }
    }
    
    var lastPress = NSDate()
    var avg = 0.0
    var i = 1.0
    var timer = NSTimer()
    
    
    func dialogOKCancelNoshow(question: String, text: String) -> Bool {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = question
        myPopup.informativeText = text
        myPopup.alertStyle = NSAlertStyle.WarningAlertStyle
        myPopup.addButtonWithTitle("OK")
        
        myPopup.showsSuppressionButton = true
        myPopup.suppressionButton?.title = "Do not show this message on launch"
        
        let res = myPopup.runModal()
        
        if (myPopup.suppressionButton?.state == 1) {
            defaults.setObject(true, forKey: "noShowDialogOnStart")
        } else {
            defaults.setObject(false, forKey: "noShowDialogOnStart")
        }
        
        if res == NSAlertFirstButtonReturn {        // return based on button selected
            return true                                //  return 1 for OK
        }
        return false                                    //  else return 0 for cancel
    }
    
    func clicked(sender: AnyObject?) {
        let clickEvent = NSApp.currentEvent!  // see what caused calling of the menu action
            // modifierFlags contains a number with bits set for various modifier keys
            // ControlKeyMask is the enum for the Ctrl key
            // AlternateKeyMask is the enum for the Alt key
            // use logical and with the raw values to find if the bit is set in modifierFlags
        if (Int(clickEvent.modifierFlags.rawValue) & Int(NSEventModifierFlags.ControlKeyMask.rawValue)) != 0 {      // ctrl click to quit
            NSApplication.sharedApplication().terminate(self)
        } else if (Int(clickEvent.modifierFlags.rawValue) & Int(NSEventModifierFlags.AlternateKeyMask.rawValue)) != 0 {     // alt click to show info
            dialogOKCancelNoshow("Instructions", text: ("Control-Click to quit the app.\nAlt-Click to show this window again.\n\nTap to calculate BPM.\n\nBuilt by Ben Brook:   www.builtbybenbrook.com\n"))
        } else { // regular click
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