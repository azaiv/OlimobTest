import Foundation
import UIKit

final class HapticManager {
    
    static let shared = HapticManager()

    private init() { }
    
    func feedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        if UserDefaults.standard.bool(forKey: "HapticsEnabled") {
            let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: style)
            impactFeedbackGenerator.prepare()
            impactFeedbackGenerator.impactOccurred()
        }
    }
}
