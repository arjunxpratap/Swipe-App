//
//  NetworkMonitor.swift
//  Swipe
//
//  Created by Arjun Pratap Choudhary on 23/12/24.
//

import Network
import Combine

class NetworkMonitor: ObservableObject {
    // Singleton instance so you can call NetworkMonitor.shared
    static let shared = NetworkMonitor()

    @Published var isConnected: Bool = true
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    // Make the init private to enforce singleton usage
    private init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = (path.status == .satisfied)
            }
        }
        monitor.start(queue: queue)
    }
}
