import SwiftUI

extension View {
    
    public func modifyView<ModifiedContent: View>(
        @ViewBuilder body: (_ content: Self) -> ModifiedContent
    ) -> ModifiedContent {
        body(self)
    }
    
    public func setupNavigation() {
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: Constants.Fonts.BOLD, size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor(Constants.Colors.FOREGROUND)
        ]
        UINavigationBar.appearance().barTintColor = UIColor(Constants.Colors.BACKGROUND)
    }
    
    public func setupList() {
        UITableView.appearance().showsVerticalScrollIndicator = false
        UITableView.appearance().backgroundColor = .clear
        UICollectionView.appearance().backgroundColor = .clear
    }
    
}
