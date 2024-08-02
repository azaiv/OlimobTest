import Foundation

enum Rate: Int, CaseIterable {
    
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    
    var emoji: String {
        switch self {
        case .one:
            "😤"
        case .two:
            "😠"
        case .three:
            "☹️"
        case .four:
            "😁"
        case .five:
            "😃"
        }
    }
}
