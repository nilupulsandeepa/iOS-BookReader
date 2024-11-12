//
//  ConnectivityManager.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-11-12.
//

import Foundation
import Network

public class ConnectivityManager: NSObject {
    
    //---- MARK: Properties
    public static let shared: ConnectivityManager = ConnectivityManager()
    
    private var networkMonitor: NWPathMonitor!
    private var networkMonitorQueue: DispatchQueue!
    
    //---- MARK: Initialization
    private override init() {
        super.init()
        
        initialization()
    }
    
    private func initialization() {
        networkMonitor = NWPathMonitor()
        networkMonitor.pathUpdateHandler = {
            [weak self]
            (path) in
            if (path.status == .satisfied) {
                if let self {
                    self.broadcastNetworkStateChanged(status: .available)
                }
            } else {
                if let self {
                    self.broadcastNetworkStateChanged(status: .unavailable)
                }
            }
        }
        networkMonitorQueue = DispatchQueue(label: "com.bookreaderapp.test.networkmonitorqueue", qos: .utility)
        networkMonitor.start(queue: networkMonitorQueue)
    }
    
    //---- MARK: Action Methods
    public func startListening() {
        
    }
    
    //---- MARK: Helper Methods
    private func broadcastNetworkStateChanged(status: NetworkState) {
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: NameSpaces.NotificationIdentifiers.networkStateChangedNotification),
            object: nil,
            userInfo: ["networkState": status])
    }
}
