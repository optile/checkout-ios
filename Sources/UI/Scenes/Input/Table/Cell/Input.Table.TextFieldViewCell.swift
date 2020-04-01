#if canImport(UIKit)
import UIKit
import MaterialComponents.MaterialTextFields

extension CGFloat {
    static let cellVerticalSpacing: CGFloat = 8
}

extension Input.Table {
    /// Cell that represents all text inputs, contains label and text field.
    /// Upon some actions calls `delegate`, don't forget to set it.
    ///
    /// - Warning: after initialization before using you have to set `indexPath` to cell's indexPath
    class TextFieldViewCell: UITableViewCell, DequeueableTableCell, ContainsInputCellDelegate {
        weak var delegate: InputCellDelegate?

        private let textField: MDCTextField
        fileprivate let textFieldController: MDCTextInputControllerFilled
        
        private(set) var model: (TextInputField & DefinesKeyboardStyle)!
        
        var indexPath: IndexPath!
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            textField = .init()
            textFieldController = .init(textInput: textField)
            textField.leadingUnderlineLabel.numberOfLines = 0
            textField.leadingUnderlineLabel.lineBreakMode = .byWordWrapping
                        
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            textField.delegate = self
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
            
            contentView.addSubview(textField)
            
            textField.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                textField.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
                textField.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
                textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .cellVerticalSpacing / 2),
                contentView.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: .cellVerticalSpacing / 2)
            ])
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
        self.model = model
        
        textField.tintColor = self.tintColor
        textFieldController.activeColor = textField.tintColor
        textFieldController.floatingPlaceholderActiveColor = textField.tintColor
        textFieldController.leadingUnderlineLabelTextColor = textField.tintColor
        
        textFieldController.textInputFont = .preferredFont(forTextStyle: .body)
        textFieldController.inlinePlaceholderFont = textFieldController.textInputFont
        
        textFieldController.placeholderText = model.label
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
        guard let model = model as? Validatable else { return }
        
        if let errorText = model.validationErrorText {
            showErrorLabel(withText: errorText)
        } else {
            removeErrorLabel()
        }
    }
    
    private func showErrorLabel(withText: String) {
        textFieldController.setErrorText(withText, errorAccessibilityValue: nil)
    }
    
    private func removeErrorLabel() {
        textFieldController.setErrorText(nil, errorAccessibilityValue: nil)
    }
}

// MARK: - UITextFieldDelegate

extension Input.Table.TextFieldViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldController.setHelperText(model.placeholder, helperAccessibilityLabel: model.placeholder)
        delegate?.inputCellBecameFirstResponder(at: indexPath)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldController.setHelperText(nil, helperAccessibilityLabel: nil)
        delegate?.inputCellDidEndEditing(at: indexPath)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard containsOnlyAllowedCharacters(string: string, allowedKeyBoardType: textField.keyboardType) else {
            return false
        }
        
        guard isValidLength(for: textField, changedCharactersIn: range, replacementString: string) else {
            return false
        }
        
        return true
    }
    
    private func isValidLength(for textField: UITextField, changedCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let maxInputLength = model.maxInputLength else { return true }
        
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return true
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= maxInputLength
    }
    
    private func containsOnlyAllowedCharacters(string: String, allowedKeyBoardType: UIKeyboardType) -> Bool {
        let allowed: CharacterSet
        switch allowedKeyBoardType {
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
