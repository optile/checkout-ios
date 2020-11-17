import UIKit
import MaterialComponents.MaterialTextFields

protocol CVVTextFieldViewCellDelegate: class {
    func presentHint(viewController: UIViewController)
}

extension Input.Table {
    class CVVTextFieldViewCell: TextFieldViewCell {
        weak var cvvDelegate: CVVTextFieldViewCellDelegate?
        
        override init(frame: CGRect) {
            super.init(frame: frame)

            let button = UIButton()
            button.setImage(AssetProvider.iconCVVQuestionMark, for: .normal)
            button.addTarget(self, action: #selector(hintButtonDidTap), for: .touchUpInside)

            textField.rightView = button
            textField.rightViewMode = .always
            textField.clearButtonMode = .never
        }

        @objc private func hintButtonDidTap() {
            // Get texts
            let title: String = model.translator.translation(forKey: "account.verificationCode.hint.where.title")
            let text: String = model.translator.translation(forKey: "account.verificationCode.hint.where.text")
            let okLabel: String = model.translator.translation(forKey: TranslationKey.okLabel.rawValue)

            // Get image
            let hintImage: UIImage?
            if let cvvModel = model as? Input.Field.VerificationCode {
                hintImage = cvvModel.hintImage
            } else {
                hintImage = AssetProvider.cvvCard
            }
            
            // Alert controller
            let alertController = AlertController(title: title, message: text, preferredStyle: .alert)
            alertController.view.tintColor = tintColor
            alertController.setTitleImage(hintImage)
            
            let okAction = UIAlertAction(title: okLabel, style: .default, handler: nil)
            alertController.addAction(okAction)

            cvvDelegate?.presentHint(viewController: alertController)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

/// Adds ability to display `UIImage` above the title label of `UIAlertController`.
/// Functionality is achieved by adding “\n” characters to `title`, to make space
/// for `UIImageView` to be added to `UIAlertController.view`. Set `title` as
/// normal but when retrieving value use `originalTitle` property.
private class AlertController: UIAlertController {
    /// - Return: value that was set on `title`
    private(set) var originalTitle: String?
    private var spaceAdjustedTitle: String = ""
    private weak var imageView: UIImageView? = nil
    private var previousImgViewSize: CGSize = .zero
    
    override var title: String? {
        didSet {
            // Keep track of original title
            if title != spaceAdjustedTitle {
                originalTitle = title
            }
        }
    }
    
    /// - parameter image: `UIImage` to be displayed about title label
    func setTitleImage(_ image: UIImage?) {
        guard let imageView = self.imageView else {
            let imageView = UIImageView(image: image)
            self.view.addSubview(imageView)
            self.imageView = imageView
            return
        }
        imageView.image = image
    }
    
    // MARK: -  Layout code
    
    override func viewDidLayoutSubviews() {
        guard let imageView = imageView else {
            super.viewDidLayoutSubviews()
            return
        }
        // Adjust title if image size has changed
        if previousImgViewSize != imageView.bounds.size {
            previousImgViewSize = imageView.bounds.size
            adjustTitle(for: imageView)
        }
        // Position `imageView`
        let linesCount = newLinesCount(for: imageView)
        let padding = Constants.padding(for: preferredStyle)
        imageView.center.x = view.bounds.width / 2.0
        imageView.center.y = padding + linesCount * lineHeight / 2.0
        super.viewDidLayoutSubviews()
    }
    
    /// Adds appropriate number of "\n" to `title` text to make space for `imageView`
    private func adjustTitle(for imageView: UIImageView) {
        let linesCount = Int(newLinesCount(for: imageView))
        let lines = (0..<linesCount).map({ _ in "\n" }).reduce("", +)
        spaceAdjustedTitle = lines + (originalTitle ?? "")
        title = spaceAdjustedTitle
    }
    
    /// - Return: Number new line chars needed to make enough space for `imageView`
    private func newLinesCount(for imageView: UIImageView) -> CGFloat {
        return ceil(imageView.bounds.height / lineHeight)
    }
    
    /// Calculated based on system font line height
    private lazy var lineHeight: CGFloat = {
        let style: UIFont.TextStyle = self.preferredStyle == .alert ? .headline : .callout
        return UIFont.preferredFont(forTextStyle: style).pointSize
    }()
    
    struct Constants {
        static var paddingAlert: CGFloat = 22
        static var paddingSheet: CGFloat = 11
        static func padding(for style: UIAlertController.Style) -> CGFloat {
            return style == .alert ? Constants.paddingAlert : Constants.paddingSheet
        }
    }
}

private extension Input.Field.VerificationCode {
    var hintImage: UIImage? {
        return networkCode == "AMEX" ? AssetProvider.cvvAMEX : AssetProvider.cvvCard
    }
}
