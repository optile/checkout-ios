#if canImport(UIKit)
import UIKit

private struct UIConstant {
    static let defaultSpacing: CGFloat = 8
}

extension Input.Table {
    /// Cell that represents all text inputs, contains label and text field.
    /// Upon some actions calls `delegate`, don't forget to set it.
    ///
    /// - Warning: after initialization before using you have to set `indexPath` to cell's indexPath
    class TextFieldViewCell: UITableViewCell, DequeueableTableCell, ContainsInputCellDelegate {
        weak var delegate: InputCellDelegate?
        
        private let label: UILabel
        let textField: UITextField
        private weak var errorLabel: UILabel?
        private var bottomConstraint: NSLayoutConstraint?
        
        var indexPath: IndexPath!
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            label = .init(frame: .zero)
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
            
            textField = .init(frame: .zero)
            
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            textField.delegate = self
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
            
            contentView.addSubview(label)
            contentView.addSubview(textField)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            textField.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: textField.leadingAnchor, constant: -UIConstant.defaultSpacing),
                label.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
                label.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
                label.widthAnchor.constraint(equalToConstant: 140),

                textField.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
                textField.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor)
            ])
            
            let bottomConstraint = textField.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
            bottomConstraint.isActive = true
            self.bottomConstraint = bottomConstraint
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

// MARK: - Cell configuration

extension Input.Table.TextFieldViewCell {
    override var canBecomeFirstResponder: Bool { return true }
    
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
            return textField.becomeFirstResponder()
    }
    
    func configure(with model: TextInputField & DefinesKeyboardStyle) {
        label.text = model.label
        textField.placeholder = model.placeholder
        textField.text = model.value

        textField.keyboardType = model.keyboardType
        textField.autocapitalizationType = model.autocapitalizationType
        
        if let contentType = model.contentType {
            textField.textContentType = contentType
        }
        
        showValidationResult(for: model)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        delegate?.inputCellValueDidChange(to: textField.text, at: indexPath)
    }
}

// MARK: - Validation error label

extension Input.Table.TextFieldViewCell {
    func showValidationResult(for model: Any) {
        // If model is not validatable just set a normal text color
        guard let model = model as? Validatable else {
            if #available(iOS 13.0, *) {
                label.textColor = .label
            } else {
                label.textColor = .darkText
            }
            
            return
        }
        
        if let errorText = model.validationErrorText {
            showErrorLabel(withText: errorText)
        } else {
            removeErrorLabel()
            
            if #available(iOS 13.0, *) {
                label.textColor = .label
            } else {
                label.textColor = .darkText
            }
        }
    }
    
    private func showErrorLabel(withText: String) {
        if let label = errorLabel {
            label.text = withText
            return
        }
        
        let errorLabel = UILabel(frame: .zero)
        errorLabel.textColor = .systemRed
        errorLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        errorLabel.text = withText
        
        contentView.addSubview(errorLabel)
        self.errorLabel = errorLabel
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: UIConstant.defaultSpacing)
        ])
        
        bottomConstraint?.isActive = false
        
        let bottomConstraint = errorLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        bottomConstraint.isActive = true
        self.bottomConstraint = bottomConstraint
    }
    
    private func removeErrorLabel() {
        errorLabel?.removeFromSuperview()
        
        bottomConstraint?.isActive = false
        
        let bottomConstraint = textField.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        bottomConstraint.isActive = true
        self.bottomConstraint = bottomConstraint
    }
}

// MARK: - UITextFieldDelegate

extension Input.Table.TextFieldViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.inputCellBecameFirstResponder(at: indexPath)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.inputCellDidEndEditing(at: indexPath)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowed: CharacterSet
        switch textField.keyboardType {
        case .numbersAndPunctuation:
            var set = CharacterSet.decimalDigits
            set.formUnion(CharacterSet(charactersIn: " -"))
            allowed = set
        case .numberPad:
            allowed = .decimalDigits
        default: return true
        }
        
        if CharacterSet(charactersIn: string).isSubset(of: allowed) {
            return true
        } else {
            return false
        }
    }
}
#endif
