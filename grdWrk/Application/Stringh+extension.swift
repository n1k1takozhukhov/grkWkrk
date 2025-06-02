import Foundation

extension String {
    var localized: String {
        NSLocalizedString(
            self,
            comment: "\(self) not be found in Localization")
    }
}
