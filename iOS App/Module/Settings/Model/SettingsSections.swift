import Foundation

enum SettingsSections: String, CaseIterable {
    case customization
    case community
    case legal
    case history
}

enum CustomizationSection: CaseIterable {
    case primaryTab
    case haptics
    
    var title: String {
        switch self {
        case .primaryTab:
            "Primary Tab"
        case .haptics:
            "Haptics"
        }
    }
    
    var systemImage: String {
        switch self {
        case .primaryTab:
            "house.fill"
        case .haptics:
            "bell.fill"
        }
    }
}

enum CommunitySection: CaseIterable {
    case rate
    case support
    
    var title: String {
        switch self {
        case .rate:
            "Rate Our App"
        case .support:
            "Support"
        }
    }
    
    var systemImage: String {
        switch self {
        case .rate:
            "star.fill"
        case .support:
            "envelope.badge.shield.half.filled.fill"
        }
    }
}

enum LegalSection: String, CaseIterable {
    case privacy
    
    var systemImage: String {
        switch self {
        case .privacy:
            "person.badge.shield.checkmark.fill"
        }
    }
}

enum HistorySection: CaseIterable {
    case clear
    
    var title: String {
        switch self {
        case .clear:
            return "Clear History"
        }
    }
}
