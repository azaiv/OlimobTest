import SwiftUI

struct LineChartView: View {
    let data: [Int]
    
    @State private var selectedIndex: Int = 0
    @State private var dragLocation: CGPoint = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let minValue = data.min() ?? 0
                let maxValue = data.max() ?? 0
                let avgValue = (minValue + maxValue) / 2
                
                let height = geometry.size.height
                Path { path in
                    guard !data.isEmpty else { return }
                    
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let minValue = data.min() ?? 0
                    let maxValue = data.max() ?? 0
                    let stepX = width / CGFloat(data.count - 1)
                    let normalizedHeight = height / CGFloat(maxValue - minValue)
           
                    path.move(to: CGPoint(x: 0, y: height - (CGFloat(data[0] - minValue) * normalizedHeight)))
                    
                    for index in 1..<data.count {
                        let x = CGFloat(index) * stepX
                        let y = height - (CGFloat(data[index] - minValue) * normalizedHeight)
                   
                        let prevX = CGFloat(index - 1) * stepX
                        let prevY = height - (CGFloat(data[index - 1] - minValue) * normalizedHeight)
                        
                        let controlX1 = (prevX + x) / 2
                        let controlY1 = prevY
                        let controlX2 = (prevX + x) / 2
                        let controlY2 = y
                        
                        path.addCurve(to: CGPoint(x: x, y: y),
                                      control1: CGPoint(x: controlX1, y: controlY1),
                                      control2: CGPoint(x: controlX2, y: controlY2))
                    }
                }
                .stroke(Constants.Colors.SECOND_ACCENT, lineWidth: 3)
                
                .padding(.leading, 10)

                let width = geometry.size.width
                let stepX = width / CGFloat(data.count - 1)
                let x = CGFloat(selectedIndex) * stepX
                let minValue2 = data.min() ?? 0
                let height2 = geometry.size.height
                let normalizedHeight2 = height2 / CGFloat((data.max() ?? 0) - minValue)
                let y = height - (CGFloat(data[selectedIndex] - minValue2) * normalizedHeight2)
                HStack(spacing: 3) {
                    VStack(alignment: .leading) {
                        Text(String(format: "%.0f", Double(maxValue)))
                            .font(.custom(Constants.Fonts.REGULAR, size: 12))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        Spacer()
                        Text(String(format: "%.0f", Double(avgValue)))
                            .font(.custom(Constants.Fonts.REGULAR, size: 12))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        Spacer()
                        Text(String(format: "%.0f", Double(minValue)))
                            .font(.custom(Constants.Fonts.REGULAR, size: 12))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(x: 0, y: height))
                    }
                    .stroke(.gray, lineWidth: 2)
                }
                .position(x: -3, y: geometry.size.height / 2)
                Rectangle()
                    .fill(Constants.Colors.FIRST_ACCENT)
                    .frame(width: geometry.size.width, height: 1)
                    .position(x: (geometry.size.width / 2) + 5, y: y)
                
                Rectangle()
                    .fill(Constants.Colors.FIRST_ACCENT)
                    .frame(width: 1, height: geometry.size.height)
                    .position(x: x + 5, y: geometry.size.height / 2)
                    .overlay(content: {
                        Text("\(data[selectedIndex])")
                            .font(.custom(Constants.Fonts.REGULAR, size: 12))
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Constants.Colors.SECOND_ACCENT)
                            .shadow(radius: 5)
                            .clipShape(Circle())
                            .position(x: x + 5, y: y)
                    })

                Color.clear
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let width = geometry.size.width
                                let stepX = width / CGFloat(data.count - 1)
                                let index = Int(round(value.location.x / stepX))
                                
                                if index >= 0 && index < data.count {
                                    selectedIndex = index
                                    dragLocation = value.location
                                }
                            }
                            .onEnded({ _ in 
                                HapticManager.shared.feedback(.light)
                            })
                    )
            }
        }
    }
}
