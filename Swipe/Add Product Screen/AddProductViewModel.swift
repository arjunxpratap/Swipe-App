//
//  AddProductViewModel.swift
//  Swipe
//
//  Created by Arjun Pratap Choudhary on 23/12/24.
//
import SwiftUI
import Combine

class AddProductViewModel: ObservableObject {
    @Published var productName = ""
    @Published var productType = "Product"
    @Published var price = ""
    @Published var tax = ""
    @Published var image: UIImage?
    
    // Alert-related fields
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    let productTypes = ["Books", "Electronics", "Clothing", "Others", "Phone", "Grocery", "Accessories"]
    private let offlineStorageFile = "offlineProducts.json"
    private var cancellables = Set<AnyCancellable>()
    
    func validateFields() -> Bool {
        guard !productName.isEmpty else {
            alertTitle = "Invalid Input"
            alertMessage = "Product name is required."
            return false
        }
        guard productType != "Product" else {
            alertTitle = "Invalid Input"
            alertMessage = "Please select a valid product type."
            return false
        }
        guard Double(price) != nil else {
            alertTitle = "Invalid Input"
            alertMessage = "Price must be a valid number."
            return false
        }
        guard Double(tax) != nil else {
            alertTitle = "Invalid Input"
            alertMessage = "Tax rate must be a valid number."
            return false
        }
        return true
    }
    
    func submitProduct(completion: @escaping (Bool) -> Void) {
        // 1. Check network first
        if !NetworkMonitor.shared.isConnected {
            // 2. Save product offline
            saveOffline()
            // 3. Show user-friendly offline alert
            alertTitle = "Offline: Product Saved Locally"
            alertMessage = "You're not connected to the internet. Your product has been saved locally and will be automatically uploaded once you're online."
            completion(false)
            return
        }
        
        // If online, proceed with normal upload
        guard let url = URL(string: "https://app.getswipe.in/api/public/add") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let body = createBody(boundary: boundary)
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let message = json["message"] as? String {
                    self.alertTitle = "Success"
                    self.alertMessage = message
                    completion(true)
                } else {
                    self.alertTitle = "Error"
                    self.alertMessage = "Failed to add product."
                    completion(false)
                }
            }
        }.resume()
    }
    
    func uploadOfflineProducts() {
        guard NetworkMonitor.shared.isConnected else { return }
        
        let storedProducts = loadOffline()
        guard !storedProducts.isEmpty else { return }
        
        for product in storedProducts {
            guard let url = URL(string: "https://app.getswipe.in/api/public/add") else { continue }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let boundary = UUID().uuidString
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            var body = Data()
            func addField(_ name: String, value: String) {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(value)\r\n".data(using: .utf8)!)
            }
            
            // Basic fields
            addField("product_name", value: product.productName)
            addField("product_type", value: product.productType)
            addField("price", value: "\(product.price)")
            addField("tax", value: "\(product.tax)")
            
            // Decode the Base64 image if it exists
            if let base64String = product.image,
               let imageData = Data(base64Encoded: base64String) {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"files[]\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(imageData)
                body.append("\r\n".data(using: .utf8)!)
            }
            
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
            request.httpBody = body

            URLSession.shared.dataTask(with: request) { data, response, error in
                // Optionally check for errors or parse response
            }.resume()
        }
        
        JSONStorageManager.shared.removeFile(named: offlineStorageFile)
    }
    
    // MARK: - Offline Save/Load
    private func saveOffline() {
        // Convert the user's selected UIImage to Base64
        var base64String: String? = nil
        if let uiImage = image,
           let jpegData = uiImage.jpegData(compressionQuality: 0.8) {
            base64String = jpegData.base64EncodedString()
        }
        
        // Now save it into the Product's .image field
        let localProduct = Product(
            productName: productName,
            productType: productType,
            price: Double(price) ?? 0.0,
            tax: Double(tax) ?? 0.0,
            image: base64String  // <-- store the base64
        )
        
        var stored = loadOffline()
        stored.append(localProduct)
        JSONStorageManager.shared.saveAny(stored, fileName: offlineStorageFile)
        print("DEBUG: Saved product offline -> \(localProduct.productName)")
    }
    
    private func loadOffline() -> [Product] {
        JSONStorageManager.shared.loadAny([Product].self, fileName: offlineStorageFile) ?? []
    }

    // MARK: - Create Multipart Body
    private func createBody(boundary: String) -> Data {
        var body = Data()
        func addField(_ name: String, value: String) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        addField("product_name", value: productName)
        addField("product_type", value: productType)
        addField("price", value: price)
        addField("tax", value: tax)
        
        if let imageData = image?.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"files[]\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
}
