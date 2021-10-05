//
//  BPMTapper.swift
//  bpm
//
//  Created by Harry Clegg on 03/10/2021.
//

import Foundation

class BPMTapper {
    
    let placeholderString = "bpm"
    let waitingForSecondString = "bpm"
    
    // Store time since last click to find intervals.
    var lastPress : NSDate = NSDate()
    
    // Reset if no click for 1.5 seconds
    let resetInterval : Double = 1.5
    var resetTimer : Timer = Timer()
    
    // Store average of time between clicks, and how many have occurred.
    var nClicks : UInt = 0
    var averageInterval : Double = 0
    
    var averageIntervalAsString : String {
        return String(Int(60 / averageInterval))
    }
    
    func recordInterval(withNewInterval newInterval: Double) -> String {
        // How long do all the existing presses equate to?
        let totalTime = ((averageInterval * Double(nClicks)) + newInterval)
        
        // The user has clicked, increment counter.
        nClicks += 1
        
        // Now we can find the average of all click intervals.
        averageInterval = totalTime / Double(nClicks);
        
        // If the user has clicked only once, return the waiting for second click string.
        // Otherwise, return the average BPM value as a rounded string.
        return nClicks > 1 ? averageIntervalAsString : waitingForSecondString
    }
    
    func click(withResetCallback callback: @escaping (String) -> Void, andWasRightClick rightClick : Bool) -> String {
        
        if rightClick {
            // Reset internal variables if right click.
            self.clear()
        }
        
        // Clear any existing timer.
        resetTimer.invalidate()
        
        // Create a timer that will reset the bpm bar item message to placeholder after time is up.
        resetTimer = Timer.scheduledTimer(withTimeInterval: resetInterval,  repeats: false) { timer in
            callback(self.reset())
        }
        
        // Determine how long since last press.
        let thisInterval = NSDate().timeIntervalSince(lastPress as Date)
        
        // Store current time.
        lastPress = NSDate()
        
        // Store the new value by melding it in to the existing average.
        // This function returns the string to display to the user.
        return recordInterval(withNewInterval: thisInterval)
    }
    
    func clear() {
        // Clear average interval tracking variables.
        self.nClicks = 0
        self.averageInterval = 0
    }
    
    func reset() -> String {
        // Clear average interval tracking variables.
        self.clear()
        
        // Store current time. This means if the user right clicks to reset the counter because
        // it is way off, this click will count towards timing.
        lastPress = NSDate()
        
        // We don't want the timer to fire now in any case.
        resetTimer.invalidate()
        
        return placeholderString
    }
    
}
