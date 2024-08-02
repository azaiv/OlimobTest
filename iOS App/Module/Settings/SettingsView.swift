import SwiftUI

struct SettingsView: View {
    
    @Environment(\.openURL) private var openURL
    
    @StateObject private var viewModel = SettingsManager()
    
    @State private var openRate: Bool = false
    
    init() {
        setupNavigation()
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(SettingsSections.allCases, id: \.hashValue) { section in
                    Section(content: {
                        switch section {
                        case .customization:
                            customizationSection()
                        case .community:
                            communitySection()
                        case .legal:
                            legalSection()
                        case .history:
                            Button(action: {
                                Task {
                                    HapticManager.shared.feedback(.light)
                                    SoundStorageService.shared.clearAllData(completion: { result in
                                        print(result)
                                    })
                                }
                            }, label: {
                                Text(HistorySection.clear.title)
                                    .frame(maxWidth: .infinity)
                            })
                            .buttonStyle(AppButtonStyle())
                            .tint(Constants.Colors.FIRST_ACCENT)
                        }
                    }, header: {
                        Text(section.rawValue.capitalized)
                            .textCase(nil)
                            .foregroundColor(Constants.Colors.FIRST_ACCENT)
                            .font(.custom(Constants.Fonts.MEDIUM, size: 14))
                    })
                    
                }
                .listRowBackground(Constants.Colors.BACKGROUND)
                .listRowSeparatorTint(Constants.Colors.FOREGROUND)
                .listRowBackground(Color.clear)
                .listSectionSeparator(.hidden)
            }
            .listStyle(.grouped)
            .background(Constants.Colors.BACKGROUND)
            .navigationViewStyle(.stack)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(TabType.settings.title)
            .modifyView(body: {
                if #available(iOS 16.0, *) {
                    $0
                        .scrollContentBackground(.hidden)
                        .scrollIndicators(.hidden)
                } else {
                    $0
                        .onAppear(perform: {
                            setupList()
                        })
                }
            })
        }
        .tint(Constants.Colors.FIRST_ACCENT)
        .sheet(isPresented: $openRate, content: {
            RateView()
        })
    }
    
    @ViewBuilder
    private func customizationSection() -> some View {
        
        RowView(
            image: CustomizationSection.primaryTab.systemImage,
            title: CustomizationSection.primaryTab.title,
            accessoryType: true,
            customView: {
                Text(TabType.allCases.first(where: { $0.rawValue == viewModel.primaryTab
                })?.title ?? "")
                    .foregroundStyle(Constants.Colors.FOREGROUND)
                    .font(.custom(Constants.Fonts.REGULAR, size: 16))
            })
        .background(content: {
            NavigationLink(destination: {
                PrimaryTabView(viewModel: viewModel)
            }, label: {
                Text("")
            })
            .accentColor(Constants.Colors.SECOND_ACCENT)
            .opacity(0.0)
        })
        
        RowView(
            image: CustomizationSection.haptics.systemImage,
            title: CustomizationSection.haptics.title,
            accessoryType: false,
            customView: {
                Toggle(isOn: $viewModel.hapticEnabled,
                       label: { EmptyView() })
                .tint(Constants.Colors.SECOND_ACCENT)
            })

    }
    
    @ViewBuilder
    private func communitySection() -> some View {
        ForEach(CommunitySection.allCases, id: \.hashValue) { row in
            RowView(
                image: row.systemImage,
                title: row.title,
                accessoryType: true,
                customView: { EmptyView() })
            .contentShape(Rectangle())
            .onTapGesture {
                HapticManager.shared.feedback(.light)
                if row == .rate {
                    openRate = true
                } else if row == .support {
                    sendMail()
                }
            }
        }
    }
    
    @ViewBuilder
    private func legalSection() -> some View {
        ForEach(LegalSection.allCases, id: \.hashValue) { row in
            RowView(
                image: row.systemImage,
                title: row.rawValue.capitalized,
                accessoryType: true,
                customView: { EmptyView() })
            .contentShape(Rectangle())
            .onTapGesture {
                HapticManager.shared.feedback(.light)
                if row == .privacy {
                    let url = URL(string: "https://www.google.com")!
                    openURL(url)
                }
            }
        }
    }
    
    private func sendMail() {
        let subject = "Description"
        let application = UIApplication.shared

        let body = """
        
        
        Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
        """

        let coded = "mailto:example@gmail.com?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let emailURL = URL(string: coded!), application.canOpenURL(emailURL) {
            application.open(emailURL)
        }
    }
    
}

#Preview {
    SettingsView()
}


struct AppButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Constants.Colors.BACKGROUND)
            .font(.custom(Constants.Fonts.BOLD, size: 18))
            .padding(8)
            .frame(maxWidth: .infinity, maxHeight: 60)
            .background(Constants.Colors.SECOND_ACCENT)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .font(.system(size: 18, weight: .semibold, design: .rounded))
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0, anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
