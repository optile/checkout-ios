// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit

/// Model that contains loadable logo
protocol LoadableLogo: AnyObject {
    var logo: Loadable<UIImage>? { get set }
}
