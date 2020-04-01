import UIKit

private extension CGFloat {
    static let logoWidth: CGFloat = 40
    static let imageLabelSpacing: CGFloat = 16
}

extension Input.Table {
    class DetailedTextLogoView: UIView {
        private let label: UILabel
        private let detailedLabel: UILabel
        private let logoView: UIImageView
        
        override init(frame: CGRect) {
            label = .init(frame: .zero)
            detailedLabel = .init(frame: .zero)
            logoView = .init(frame: .zero)
            
            super.init(frame: frame)
            
            // FIXME: Return checkmark
//            self.accessoryType = .checkmark

            self.preservesSuperviewLayoutMargins = true
            
            label.font = .preferredFont(forTextStyle: .body)
            label.lineBreakMode = .byTruncatingMiddle
            detailedLabel.font = .preferredFont(forTextStyle: .footnote)
            label.textColor = .text
            detailedLabel.textColor = .text
            
            self.addSubview(label)
            self.addSubview(detailedLabel)
            self.addSubview(logoView)

            label.translatesAutoresizingMaskIntoConstraints = false
            detailedLabel.translatesAutoresizingMaskIntoConstraints = false
            
            logoView.translatesAutoresizingMaskIntoConstraints = false
            logoView.contentMode = .scaleAspectFit
            logoView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: logoView.trailingAnchor, constant: .imageLabelSpacing),
                label.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
                label.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
                
                detailedLabel.topAnchor.constraint(equalTo: label.bottomAnchor),
                detailedLabel.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
                detailedLabel.leadingAnchor.constraint(equalTo: label.leadingAnchor),
                detailedLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
                
                logoView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
                logoView.topAnchor.constraint(equalTo: label.topAnchor),
                logoView.bottomAnchor.constraint(equalTo: detailedLabel.bottomAnchor),
                logoView.widthAnchor.constraint(equalToConstant: .logoWidth),
            ])
         }
         
         required init?(coder: NSCoder) {
             fatalError("init(coder:) has not been implemented")
         }
    }
}

extension Input.Table.DetailedTextLogoView {
    func configure(with model: Input.TextHeader) {
        let image: UIImage?
        if let imageData = model.logoData {
            image = UIImage(data: imageData)
        } else {
            image = nil
        }
        
        logoView.image = image
        label.text = model.label
        detailedLabel.text = model.detailedLabel
    }
}
