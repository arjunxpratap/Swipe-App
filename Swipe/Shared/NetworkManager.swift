//
//  NetworkManager.swift
//  Swipe
//
//  Created by Arjun Pratap Choudhary on 23/12/24.
//


import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func postRequest(url: URL, body: Data, contentType: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request, completionHandler: completion).resume()
    }
}
