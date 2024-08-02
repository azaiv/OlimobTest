import Foundation
import SwiftUI

final class SettingsManager: ObservableObject {
    
    @AppStorage("PrimaryTab") var primaryTab: Int = TabType.audio.rawValue
    @AppStorage("HapticsEnabled") var hapticEnabled: Bool = true
    
    
}
