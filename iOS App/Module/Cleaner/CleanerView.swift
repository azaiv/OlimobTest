import SwiftUI
import Combine

struct CleanerView: View {
    
    @StateObject private var cleanerManager = CleanerManager()
    @State private var value: Double = 0
    @State private var timer: AnyCancellable?
    
    let timerInterval: TimeInterval = 1
    
    init() {
        setupNavigation()
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { frame in
                if cleanerManager.isPlaying {
                    VStack(spacing: 20) {
                        
                        Text("It is highly recommended to use cleaner only for 10 seconds!")
                            .font(.custom(Constants.Fonts.MEDIUM, size: 16))
                            .multilineTextAlignment(.center)
                            .foregroundColor(value <= 7 ? .white : .red)
                        ProgressView(value: value, total: 10)
                            .progressViewStyle(.linear)
                            .tint(Constants.Colors.SECOND_ACCENT)
                        
                    }
                    .padding(.horizontal, 40)
                    .position(x: frame.size.width / 2, y: 50)
                }
                
                VStack(spacing: 30) {
                    Button(action: {
                        if cleanerManager.isPlaying {
                            stopTimer()
                            value = 0
                            cleanerManager.stopSound()
                            HapticManager.shared.feedback(.light)
                        } else {
                            HapticManager.shared.feedback(.light)
                            startTimer()
                            cleanerManager.playSound()
                        }
                    }) {
                        ZStack {
                            Circle()
                                .frame(width: 200)
                                .foregroundColor(Constants.Colors.FIRST_ACCENT)
                            Image(systemName: cleanerManager.isPlaying ? "pause" : "power")
                                .resizable()
                                .scaledToFit()
                                .frame(width: cleanerManager.isPlaying ? 35 : 70)
                                .foregroundColor(Constants.Colors.BACKGROUND)
                                .font(.largeTitle)
                        }
                    }
                    .buttonStyle(.plain)
                    
                    Text(!cleanerManager.isPlaying ? "Tap the button above to activate blower" : "Tap the button above to deactivate blower")
                        .multilineTextAlignment(.center)
                        .font(.custom(Constants.Fonts.MEDIUM, size: 16))
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                }
                .position(x: frame.size.width / 2, y: frame.size.height / 2)
            }
            .background(Constants.Colors.BACKGROUND)
            .navigationViewStyle(.stack)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(TabType.cleaner.title)
            
        }
        .onDisappear {
            if cleanerManager.isPlaying {
                stopTimer()
                cleanerManager.stopSound()
            }
        }
    }
    
    private func startTimer() {
        timer = Timer.publish(every: timerInterval, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if self.value < 10 {
                    self.value += 1
                } else {
                    self.stopTimer()
                    self.value = 0
                    self.cleanerManager.stopSound()
                }
            }
    }
    
    private func stopTimer() {
        timer?.cancel()
    }
}

#Preview {
    CleanerView()
}
