// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

#if canImport(UIKit)
import UIKit

/// Observer that will fire events when keyboard frame will be changed (shown, hidden or resized)
/// - Note: Call `addKeyboardFrameChangesObserver()` on init, e.g. on `viewWillAppear`
///            and `removeKeyboardFrameChangesObserver()` on deinit, e.g. on `viewDidDisappear`
protocol KeyboardFrameChangesObserver: AnyObject {
    func willChangeKeyboardFrame(_ frame: CGRect, animationDuration: TimeInterval, animationOptions: UIView.AnimationOptions)
}

extension KeyboardFrameChangesObserver {
    func addKeyboardFrameChangesObserver() {
        let center = NotificationCenter.default

        center.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] (notification) in
            self?.sendDelegate(notification: notification, willHide: false)
        }

        center.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] (notification) in
            self?.sendDelegate(notification: notification, willHide: true)
        }
    }

    func removeKeyboardFrameChangesObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func sendDelegate(notification: Notification, willHide: Bool) {
        guard let userInfo = notification.userInfo,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let rawAnimationCurveNumber = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber else { return }

        let rawAnimationCurve = rawAnimationCurveNumber.uint32Value << 16
        let animationCurve = UIView.AnimationOptions(rawValue: UInt(rawAnimationCurve))

        willChangeKeyboardFrame(keyboardEndFrame,
                                animationDuration: animationDuration,
                                animationOptions: [.beginFromCurrentState, animationCurve])
    }
}

/// Insets of a scroll view will be changed when keyboard will appear
protocol ModifableInsetsOnKeyboardFrameChanges: KeyboardFrameChangesObserver {
}

/// Default implementation for `UIViewController`
extension ModifableInsetsOnKeyboardFrameChanges where Self: UIViewController {
    func willChangeKeyboardFrame(_ frame: CGRect, animationDuration: TimeInterval, animationOptions: UIView.AnimationOptions) {
        UIView.animate(withDuration: animationDuration, animations: {
            let keyboardFrameInView = self.view.convert(frame, from: nil)
            let safeAreaFrame = self.view.safeAreaLayoutGuide.layoutFrame.insetBy(dx: 0, dy: -self.additionalSafeAreaInsets.bottom)
            let intersection = safeAreaFrame.intersection(keyboardFrameInView)

            UIView.animate(withDuration: animationDuration,
                           delay: 0,
                           options: animationOptions,
                           animations: {
                self.additionalSafeAreaInsets.bottom = intersection.height
            }, completion: nil)
        })
    }
}
#endif
