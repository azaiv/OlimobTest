import SwiftUI

struct RowView<Content: View>: View {
    
    let image: String
    let title: String
    let accessoryType: Bool
    @ViewBuilder var customView: Content
    
    var body: some View {
        HStack {
            Image(systemName: image)
                .foregroundColor(.white)
            Text(title)
                .foregroundColor(.white)
                .font(.custom(Constants.Fonts.MEDIUM, size: 16))
            Spacer()
            customView
            if accessoryType {
                Image(systemName: "chevron.forward")
                    .foregroundColor(Constants.Colors.FIRST_ACCENT)
                    .font(.system(size: 16, weight: .medium))
                    .padding(.leading, 5)
            }
        }
        .padding(.vertical, 10)
    }
    
}

#Preview {
    RowView(
        image: "star.fill",
        title: "Test text",
        accessoryType: true, 
        customView: {
            EmptyView()
        })
}
