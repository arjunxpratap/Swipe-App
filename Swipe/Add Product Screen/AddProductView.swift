//
//  AddProductView.swift
//  Swipe
//
//  Created by Arjun Pratap Choudhary on 23/12/24.
//
import SwiftUI
import Lottie

struct AddProductView: View {
    @StateObject private var viewModel = AddProductViewModel()
    @State private var showImagePicker = false
    @State private var playAnimation = false // Local animation trigger
    @State private var navigateToContentView = false // Navigation trigger
    @State private var showingAlert = false   // <--- For offline alert
    
    @Environment(\.dismiss) private var dismiss
    var onProductAdded: () -> Void

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                // Title
                Text("Add Product")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal)

                // Section: Product Details
                VStack(alignment: .leading, spacing: 12) {
                    Text("PRODUCT DETAILS")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.horizontal)

                    // Product Name
                    TextboxView(
                        placeholder: "Product Name",
                        text: $viewModel.productName,
                        keyBoardType: .default
                    )
                    .padding(.horizontal)
                    .frame(height: 80)

                    // Selling Price
                    TextboxView(
                        placeholder: "Selling Price (₹)",
                        text: $viewModel.price,
                        keyBoardType: .decimalPad
                    )
                    .padding(.horizontal)
                    .frame(height: 30)

                    // Tax Rate
                    TextboxView(
                        placeholder: "Tax Rate (%)",
                        text: $viewModel.tax,
                        keyBoardType: .decimalPad
                    )
                    .padding(.horizontal)
                    .frame(height: 80)
                }

                // Product Type and Image Picker
                HStack(alignment: .top, spacing: 16) {
                    // Product Type and Picker
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Product Type:")
                            .font(.headline)
                            .foregroundColor(.white)
                        PickerView(selectedCode: $viewModel.productType, options: viewModel.productTypes)
                    }
                    .frame(maxWidth: .infinity)

                    // Product Image Picker
                    VStack(alignment: .center, spacing: 12) {
                        Text("Product Image:")
                            .font(.headline)
                            .foregroundColor(.white)

                        if let selectedImage = viewModel.image {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .onTapGesture {
                                    showImagePicker.toggle()
                                }
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    showImagePicker.toggle()
                                }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)

                Spacer()

                // Lottie Animation Submit Button
                ZStack {
                    // Background Circle
                    Circle()
                        .fill(playAnimation ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                        .frame(width: 120, height: 120)

                    // Lottie Animation View
                    CustomLottieView(animationName: "Submit", isPlaying: playAnimation)
                        .frame(width: 100, height: 100)
                        .scaleEffect(0.2)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
                .onTapGesture {
                    if viewModel.validateFields() {
                        playAnimation = true
                        viewModel.submitProduct { success in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                playAnimation = false
                                // If submission was successful, or even if offline
                                // we still dismiss the screen to show "success" in your flow.
                                dismiss()
                                onProductAdded()
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding(.vertical)
            .background(Color.black.ignoresSafeArea()) // Dark background
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $viewModel.image)
            }
            .onTapGesture {
                hideKeyboard()
            }
            // Whenever alertTitle changes, show the alert if non-empty
            .onChange(of: viewModel.alertTitle) { newValue in
                if !newValue.isEmpty {
                    showingAlert = true
                }
            }
            .alert(viewModel.alertTitle, isPresented: $showingAlert) {
                Button("OK") {
                    // Optionally clear out the alert after user taps OK
                    viewModel.alertTitle = ""
                    viewModel.alertMessage = ""
                }
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }
}

// Custom Lottie Animation View
struct CustomLottieView: UIViewRepresentable {
    let animationName: String
    var isPlaying: Bool

    private let animationView = LottieAnimationView()

    func makeUIView(context: Context) -> LottieAnimationView {
        animationView.animation = LottieAnimation.named(animationName)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        return animationView
    }

    func updateUIView(_ uiView: LottieAnimationView, context: Context) {
        if isPlaying {
            uiView.play()
        } else {
            uiView.stop()
        }
    }
}

// Reusable PickerView Component
struct PickerView: View {
    @Binding var selectedCode: String
    let options: [String]

    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    selectedCode = option
                }) {
                    Text(option)
                }
            }
        } label: {
            HStack {
                Text(selectedCode.isEmpty ? "Select Type" : selectedCode)
                    .foregroundColor(selectedCode.isEmpty ? .gray : .white)
                    .frame(minWidth: 90, alignment: .leading)
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 10)
            .frame(height: 44)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
        }
    }
}

// Reusable TextboxView & HideKeyboard extension, if needed

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}
