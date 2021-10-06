//
//  AppDelegate.swift
//  bpm
//
//  Created by Ben Brook on 2015-12-21.
//  Copyright © 2015 Ben Brook. All rights reserved.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!
    
    let defaults = UserDefaults.standard
    
    let tapper = BPMTapper()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create status bar item.
        let statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(
            withLength: 27)
        
        // Give button initial formatting.
        if let button = statusBarItem.button {
            button.title = tapper.placeholderString
            button.action = #selector(self.handleClick(sender:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            button.keyEquivalent = ""
        }
        
        // Hide dock icon at all times.
        NSApplication.shared.setActivationPolicy(.accessory)
        DispatchQueue.main.async {
            NSApplication.shared.activate(ignoringOtherApps: true)
            NSApplication.shared.windows.first!.makeKeyAndOrderFront(self)
        }
        
        // Show about menu unless user has ticked don't show.
        if !defaults.bool(forKey: "noShowDialogOnStart") {
            aboutApp()
        }
    }
    
    @objc func handleClick(sender: NSStatusItem?) {
        // See what caused calling of the menu action.
        let clickEvent = NSApp.currentEvent!
        
        // Determine whether it was a right click.
        let wasRightClick = clickEvent.type == NSEvent.EventType.rightMouseUp
        
        if (clickEvent.modifierFlags.contains(.control)) {
            // Ctrl click to quit.
            NSApplication.shared.terminate(self)
            
        } else if (clickEvent.modifierFlags.contains(.option)) {
            // Alt click to show info.
            aboutApp()
            
        } else {
            // Calculate new average interval, and display to user as button string.
            updateButton(withString: tapper.click(withResetCallback: updateButton(withString:), andWasRightClick: wasRightClick))
        }
    }
    
    @objc func updateButton(withString: String) {
        // Update status bar button string.
        if let button = statusBarItem.button {
            button.title = withString
        }
    }
    
    func aboutApp() {
        // Show help popup.
        
        let question = "Instructions"
        let text = "Click to calculate BPM.\nRight click to reset.\n\nControl-Click to quit the app.\nAlt-Click to show this window again."
        
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = question
        myPopup.informativeText = text
        myPopup.alertStyle = NSAlert.Style.warning
        myPopup.addButton(withTitle: "OK")
        
        myPopup.showsSuppressionButton = true
        myPopup.suppressionButton?.title = "Do not show this message on launch"
        
        myPopup.runModal()
        
        if (myPopup.suppressionButton?.state == .on) {
            defaults.set(true, forKey: "noShowDialogOnStart")
        } else {
            defaults.set(false, forKey: "noShowDialogOnStart")
        }
    }
}
