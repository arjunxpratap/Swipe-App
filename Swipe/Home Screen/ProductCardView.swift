import SwiftUI
import Lottie

struct ProductCardView: View {
    let product: Product
    @ObservedObject var viewModel: ProductViewModel
    @State private var playAnimation = false // Local animation trigger

    var body: some View {
        HStack {
            // Product Image
            if let imageUrl = product.imageUrl {
                AsyncImageView(url: imageUrl)
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(product.productName)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(product.productType)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(String(format: "₹%.2f", product.price))
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            Spacer()

            // Lottie Animation as Favorite Button
            ZStack {
                Circle()
                    .fill(product.isFavorite ? Color.red.opacity(0.1) : Color.white.opacity(0.1))
                    .frame(width: 44, height: 44)

                LottieView(animationName: "favourite1", isPlaying: playAnimation, isFavorited: product.isFavorite)
                    .frame(width: 28, height: 28)
                    .scaleEffect(0.05)
            }
            .onTapGesture {
                playAnimation = true // Trigger animation for the tapped product
                viewModel.toggleFavorite(for: product) // Update the favorite status
                // Reset animation state after short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    playAnimation = false
                }
            }
        }
        .padding()
        .background(Color(red: 30/255, green: 30/255, blue: 30/255))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

struct LottieView: UIViewRepresentable {
    let animationName: String
    var isPlaying: Bool
    var isFavorited: Bool

    private let animationView = LottieAnimationView()

    func makeUIView(context: Context) -> LottieAnimationView {
        animationView.animation = LottieAnimation.named(animationName)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce

        // If already favorited, jump directly to the end of the animation
        if isFavorited {
            animationView.currentProgress = 1
        }
        return animationView
    }

    func updateUIView(_ uiView: LottieAnimationView, context: Context) {
        // Play if just tapped
        if isPlaying {
            uiView.play()
        }
        // Otherwise ensure it reflects favorite state
        else if isFavorited {
            uiView.currentProgress = 1
        } else {
            uiView.currentProgress = 0
        }
    }
}
