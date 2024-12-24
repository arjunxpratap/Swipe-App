import SwiftUI

struct SplashView: View {
    @State private var isActive: Bool = false
    @State private var progress: CGFloat = 0.0
    @State private var loadedPercentage: Int = 0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea() // Set background color to black

            VStack {
                Spacer()

                // App Logo
                Image("swipe_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .scaleEffect(2.0)

                // Tagline
                Text("Your Products, Simplified.")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.white) // Adjusted for dark background
                    .padding(.top, 16)

                // Loading Progress Bar
                VStack {
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .white)) // White progress bar
                        .frame(width: UIScreen.main.bounds.width * 0.7, height: 8)
                        .background(Color.gray.opacity(0.2).cornerRadius(4))

                    Text("\(loadedPercentage)%")
                        .foregroundColor(.white) // White text for percentage
                        .font(.system(size: 16, weight: .bold))
                        .padding(.top, 8)
                }

                Spacer()
            }
        }
        .onAppear {
            startLoading()
        }
        .fullScreenCover(isPresented: $isActive) {
            ContentView() // Transition to ContentView after loading
        }
    }
    private func startLoading() {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if self.progress < 1.0 {
                self.progress = min(self.progress + 0.01, 1.0) // Clamp to 1.0
                self.loadedPercentage = Int(self.progress * 100)
            } else {
                timer.invalidate()
                self.isActive = true // Transition to the next view
            }
        }
    }
}
