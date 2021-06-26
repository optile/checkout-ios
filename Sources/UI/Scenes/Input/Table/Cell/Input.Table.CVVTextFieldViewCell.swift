// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit
import MaterialComponents.MaterialTextFields

protocol CVVTextFieldViewCellDelegate: AnyObject {
    func presentHint(viewController: UIViewController)
}

extension Input.Table {
    class CVVTextFieldViewCell: TextFieldViewCell, UIAdaptivePresentationControllerDelegate {
        weak var cvvDelegate: CVVTextFieldViewCellDelegate?
        private let hintButton = UIButton(frame: .zero)

        override init(frame: CGRect) {
            super.init(frame: frame)

            hintButton.setImage(AssetProvider.iconCVVQuestionMark, for: .normal)
            hintButton.addTarget(self, action: #selector(hintButtonDidTap(button:)), for: .touchUpInside)

        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        @objc private func hintButtonDidTap(button: UIButton) {
            let tooltipVC = TooltipViewController()

            // Configure view controller
            tooltipVC.detailLabelText = model.translator.translation(forKey: "account.verificationCode.hint.where.text")
            tooltipVC.titleLabelText = model.translator.translation(forKey: "account.verificationCode.hint.where.title")

            if let cvvModel = model as? Input.Field.VerificationCode {
                tooltipVC.image = cvvModel.hintImage
            } else {
                tooltipVC.image = AssetProvider.cvvCard
            }

            // Presentation
            tooltipVC.modalPresentationStyle = .popover

            if let presentationController = tooltipVC.presentationController {
                presentationController.delegate = self
            }

            if let popoverController = tooltipVC.popoverPresentationController {
                popoverController.sourceView = button
                popoverController.sourceRect = button.bounds
                popoverController.permittedArrowDirections = [.up, .down, .right]
            }

            cvvDelegate?.presentHint(viewController: tooltipVC)
        }

        override func configure(with model: CellRepresentable & DefinesKeyboardStyle) {
            textField.rightView = hintButton
            textField.rightViewMode = .always
            textField.clearButtonMode = .never

            self.model = model
            textFieldController.model = model
            showValidationResult(for: model)
        }
    }
}

private extension Input.Field.VerificationCode {
    var hintImage: UIImage? {
        return networkCode == "AMEX" ? AssetProvider.cvvAMEX : AssetProvider.cvvCard
    }
}

extension Input.Table.CVVTextFieldViewCell: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        .none
    }
}
