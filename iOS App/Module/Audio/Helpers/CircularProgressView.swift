import SwiftUI


struct CircularProgressView: View {
    @Binding var progress: CGFloat
    
    private var normalizedProgress: CGFloat {
        return min(max((progress + 120) / 120, 0), 1)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.1)
                .foregroundColor(Constants.Colors.FOREGROUND)
            
            Circle()
                .trim(from: 0.0, to: normalizedProgress)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .foregroundColor(Constants.Colors.FIRST_ACCENT)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: normalizedProgress)
        }
    }
}
