import SwiftUI
import StoreKit

struct RateView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var selectedIndex: Int = 4
    
    var body: some View {
        ZStack {
            Constants.Colors.BACKGROUND
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Enjoying our app?")
                    .foregroundStyle(.white)
                    .font(.custom(Constants.Fonts.BOLD, size: 32))
                Spacer()
                Text(Rate.allCases[selectedIndex - 1].emoji)
                    .font(.system(size: 120))
                    .background(
                        ForEach(2...Rate.allCases.count - 1, id: \.hashValue) { index in
                            Circle()
                                .scale(CGFloat(index))
                                .stroke(Constants.Colors.SECOND_ACCENT,
                                        style: .init(lineWidth: 1.5,
                                                     lineCap: .round,
                                                     lineJoin: .round,
                                                     dash: [ 10 - CGFloat(index)]))
                                .opacity(0.2)
                        }
                    )
                Spacer()
                Text("Rate Us!")
                    .foregroundStyle(.white)
                    .font(.custom(Constants.Fonts.BOLD, size: 32))
                Spacer()
                HStack {
                    ForEach(Rate.allCases, id: \.hashValue) { index in
                        Button(action: {
                            HapticManager.shared.feedback(.light)
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedIndex = index.rawValue
                            }
                        }, label: {
                            Image(systemName: index.rawValue <= selectedIndex ? "star.fill" : "star")
                                .foregroundStyle(Constants.Colors.FIRST_ACCENT)
                                .font(.system(size: 42))
                        })
                        .buttonStyle(.plain)
                    }
                }
                Spacer()
                Button(action: {
                    HapticManager.shared.feedback(.light)
                    dismiss()
                }, label: {
                    Text("Submit")
                })
                .buttonStyle(AppButtonStyle())
            }
            .padding()
        }
    }
}

#Preview {
    RateView()
}
