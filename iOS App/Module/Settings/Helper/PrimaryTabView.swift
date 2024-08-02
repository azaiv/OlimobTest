import SwiftUI

struct PrimaryTabView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: SettingsManager

    
    var body: some View {
        List {
            ForEach(TabType.allCases, id: \.rawValue) { row in

                Button(action: {
                    HapticManager.shared.feedback(.light)
                    viewModel.primaryTab = row.rawValue
                }, label: {
                    HStack {
                        Text(row.title)
                            .foregroundStyle(.white)
                            .font(.custom(Constants.Fonts.MEDIUM, size: 16))
                        Spacer()
                        if viewModel.primaryTab == row.rawValue {
                            Image(systemName: "checkmark")
                                .foregroundColor(Constants.Colors.SECOND_ACCENT)
                        }
                    }
                    .frame(maxWidth: .infinity, 
                           maxHeight: .infinity)
                    .contentShape(Rectangle())
                })
                .contentShape(Rectangle())
                .buttonStyle(.plain)
            }
            .clipShape(Rectangle())
            .listRowSeparatorTint(Constants.Colors.FOREGROUND)
            .listRowBackground(Color.clear)
            .listSectionSeparator(.hidden)
        }
        .listStyle(.grouped)
        .navigationTitle(CustomizationSection.primaryTab.title)
        .background(Constants.Colors.BACKGROUND)
        .navigationViewStyle(.stack)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading, content: {
                Button(action: {
                    dismiss()
                }, label: {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Back")
                            .font(.custom(Constants.Fonts.REGULAR, size: 18))
                    }
                })
            })
        })
        .modifyView(body: { view in
            if #available(iOS 16.0, *) {
                view
                    .scrollContentBackground(.hidden)
            } else {
                view
                    .onAppear(perform: {
                        UITableView.appearance().isScrollEnabled = false
                        UITableView.appearance().backgroundColor = .clear
                        UICollectionView.appearance().backgroundColor = .clear
                    })
            }
        })
    }
}

#Preview {
    PrimaryTabView(viewModel: SettingsManager())
}
