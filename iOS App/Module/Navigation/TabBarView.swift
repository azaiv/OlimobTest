import SwiftUI

struct TabBarView: View {
    
    @StateObject private var audioSession = AudioRecorder()
    @State private var tabSelection: TabType = .audio
    
    init() {
        let savedTab = UserDefaults.standard.integer(forKey: "PrimaryTab")
        _tabSelection = State(initialValue: TabType(rawValue: savedTab) ?? .audio)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Constants.Colors.FOREGROUND)
        UITabBar.appearance().barTintColor = UIColor(Constants.Colors.BACKGROUND)
    }

    var body: some View {
        ZStack {
            TabView(selection: $tabSelection,
                    content:  {
                ForEach(TabType.allCases, id: \.rawValue) { tab in
                    Group {
                        switch tab {
                        case .audio:
                            AudioView()
                        case .history:
                            HistoryView()
                        case .cleaner:
                            CleanerView()
                        case .settings:
                            SettingsView()
                        }
                    }
                    .tag(tab)
                    .tabItem {
                        Label(
                            title: {
                                Text(tab.title)
                                    .font(.custom(Constants.Fonts.MEDIUM, size: 12))
                            },
                            icon: { Image(systemName: tab.systemImage) }
                        )
                        .tint(Constants.Colors.FOREGROUND)
                        .onTapGesture {
                            HapticManager.shared.feedback(.light)
                        }
                    }
                    .environmentObject(audioSession)
                }
            })
            .tint(Constants.Colors.SECOND_ACCENT)
        }
    }
}


#Preview {
    TabBarView()
}

