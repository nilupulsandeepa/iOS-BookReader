//
//  BackgroundTimer.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-11-21.
//

import Foundation

public class BackgroundTimer {
    //---- MARK: Properties
    public static let shared: BackgroundTimer = BackgroundTimer()
    
    private var rentalCheckingTimer: Timer? = nil
    
    //---- Initialization
    public func startRentalTimer() {
        if (rentalCheckingTimer != nil) {
            rentalCheckingTimer!.invalidate()
            rentalCheckingTimer = nil
        }
        rentalCheckingTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) {
            [weak self]
            _ in
            if let self {
                self.notifyTimerTrigger()
            }
        }
    }
    
    //---- Action Methods
    
    //---- Helper Methods
    private func notifyTimerTrigger() {
        print("Background Timer: Notify Trigger")
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: NameSpaces.NotificationIdentifiers.backgroundRentCheckNotification),
            object: nil,
            userInfo: nil
        )
    }
    
    deinit {
        if (rentalCheckingTimer != nil) {
            rentalCheckingTimer!.invalidate()
        }
        rentalCheckingTimer = nil
    }
}
