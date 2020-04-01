import UIKit

/// Abstract class for view controller that may be presented using slide-in transition
class SlideInViewController: UIViewController {
    weak var scrollView: UIScrollView!

    // MARK: Calculated variables

    private var isPresentedAsForm: Bool {
        return navigationController?.presentationController?.adaptivePresentationStyle(for: traitCollection) == .some(.formSheet)
    }
    
    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.bounces = isPresentedAsForm
    }

    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        setPreferredContentSize()
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)

        scrollView.bounces = isPresentedAsForm
    }

    // MARK: Custom methods

    func setPreferredContentSize() {
        var contentSize = scrollView.contentSize
        contentSize.width = view.frame.width
        preferredContentSize = contentSize
    }
}
