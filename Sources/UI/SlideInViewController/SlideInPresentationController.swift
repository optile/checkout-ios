import UIKit

class SlideInPresentationController: UIPresentationController {
    fileprivate var dimmingView: UIView!
    var currentKeyboardHeight: CGFloat = 0

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        setupDimmingView()
    }

    override func presentationTransitionWillBegin() {
        addKeyboardFrameChangesObserver()
        containerView?.insertSubview(dimmingView, at: 0)

        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|",
                                           options: [], metrics: nil, views: ["dimmingView": dimmingView as Any]))
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|",
                                           options: [], metrics: nil, views: ["dimmingView": dimmingView as Any]))

        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }

        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }

    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }

        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
        
        removeKeyboardFrameChangesObserver()
    }

    override func containerViewWillLayoutSubviews() {
        guard adaptivePresentationStyle(for: traitCollection) != .formSheet else {
            return
        }
        
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return container.preferredContentSize
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard adaptivePresentationStyle(for: traitCollection) != .formSheet else {
            return super.frameOfPresentedViewInContainerView
        }
        
        guard let containerView = self.containerView else {
            return CGRect.zero
        }
        
        var frameSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView.bounds.size)
        var frameY = (containerView.frame.height - presentedViewController.preferredContentSize.height) - currentKeyboardHeight

        if #available(iOS 11.0, *) {
            // Add extra space for safe areas on borderless devices when keyboard is hidden
            if currentKeyboardHeight == 0 {
                frameSize.height += containerView.safeAreaInsets.bottom
                frameY -= containerView.safeAreaInsets.bottom
            }
        }
        
        let origin = CGPoint(x: 0, y: frameY)
        
        let frame = CGRect(origin: origin, size: frameSize)
        return frame
    }

    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        guard adaptivePresentationStyle(for: traitCollection) != .formSheet else {
            return
        }
        
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        self.containerView?.setNeedsLayout()
    }

    override func adaptivePresentationStyle(for traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        if traitCollection.verticalSizeClass == .compact || traitCollection.horizontalSizeClass == .regular {
            return .formSheet
        } else {
            return .none
        }
    }
}

private extension SlideInPresentationController {
    func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        dimmingView.addGestureRecognizer(recognizer)
    }

    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
}

extension SlideInPresentationController: KeyboardFrameChangesObserver {
    func willChangeKeyboardFrame(height: CGFloat, animationDuration: TimeInterval, animationOptions: UIView.AnimationOptions) {
        currentKeyboardHeight = height

        if adaptivePresentationStyle(for: traitCollection) == .formSheet { return }

        UIView.animate(withDuration: animationDuration, delay: 0, options: animationOptions, animations: {
            self.presentedView?.frame = self.frameOfPresentedViewInContainerView
        }, completion: nil)
    }
}
