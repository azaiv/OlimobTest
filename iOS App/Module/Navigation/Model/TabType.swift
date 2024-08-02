import Foundation

enum TabType: Int, CaseIterable {
    
    case audio = 0
    case history
    case cleaner
    case settings
    
    var title: String {
        switch self {
        case .audio:
            "Audio"
        case .history:
            "History"
        case .cleaner:
            "Cleaner"
        case .settings:
            "Settings"
        }
    }
    
    var systemImage: String {
        switch self {
        case .audio:
            "waveform"
        case .history:
            "clock.fill"
        case .cleaner:
            "bolt.heart.fill"
        case .settings:
            "gearshape.fill"
        }
    }
}
