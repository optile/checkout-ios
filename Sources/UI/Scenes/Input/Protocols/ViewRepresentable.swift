import UIKit

/// Model that could configure view to represent itself.
protocol ViewRepresentable {
    var configurableViewType: UIView.Type { get }
    
    /// - Throws: `InternalError` if input view is not supported.
    func configure(view: UIView) throws
}

extension ViewRepresentable {
    func errorForIncorrectView(_ view: UIView) -> InternalError {
        return InternalError(description: "Unable to configure unexpected view: %@", objects: view)
    }
}
