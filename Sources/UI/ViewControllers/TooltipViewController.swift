// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit

/// ViewController with image, title and text, used with popover presentation style.
class TooltipViewController: UIViewController {
    // MARK: Views

    private let imageView: UIImageView
    private let detailLabel: UILabel
    private let titleLabel: UILabel

    // MARK: Model

    var titleLabelText: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    var detailLabelText: String? {
        get { detailLabel.text }
        set { detailLabel.text = newValue }
    }

    var image: UIImage? {
        get { imageView.image }
        set { imageView.image = newValue }
    }

    // MARK: - Initializers

    init() {
        imageView = UIImageView()
        detailLabel = UILabel(frame: .zero)
        titleLabel = UILabel(frame: .zero)

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure custom views
        imageView.contentMode = .scaleAspectFit

        detailLabel.numberOfLines = 0
        detailLabel.textAlignment = .center
        detailLabel.lineBreakMode = .byWordWrapping
        detailLabel.font = .preferredThemeFont(forTextStyle: .body)

        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.font = .preferredThemeFont(forTextStyle: .headline)

        // Add custom views in view hierarchy
        for customView in [imageView, titleLabel, detailLabel] {
            view.addSubview(customView)
            customView.translatesAutoresizingMaskIntoConstraints = false
        }

        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        detailLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        activateConstraints()
        setPreferredContentSize()
    }

    // MARK: - Private methods

    private func setPreferredContentSize() {
        let tooltipSize = CGSize(width: 300, height: UIView.layoutFittingCompressedSize.height)
        preferredContentSize = view.systemLayoutSizeFitting(tooltipSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
        self.preferredContentSize = preferredContentSize
    }

    /// Activate constraints for custom views
    private func activateConstraints() {
        let horizontalSpacing: CGFloat = 24
        let verticalSpacing: CGFloat = 16
        let minimumImageHeight: CGFloat = 50
        let titleDetailLabelSpacing: CGFloat = 4

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: verticalSpacing),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalSpacing),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing),
            imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: minimumImageHeight),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: verticalSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing),

            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: titleDetailLabelSpacing),
            detailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalSpacing),
            detailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing),
            detailLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -verticalSpacing)
        ])
    }
}
