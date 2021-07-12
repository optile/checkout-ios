// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

class ApplicableNetwork: NSObject, Decodable {
    /// Payment network code.
    let code: String

    /// Display label of the payment network.
    let label: String

    /// Indicates payment method this network belongs to.
    let method: String

    /// Grouping code; helps to group several payment networks together while displaying them on payment page (e.g. credit cards).
    let grouping: String

    /// Indicates whether this payment network supports registration and how this should be presented on payment page
    let registration: String

    /// Indicates whether this payment network supports recurring registration and how this should be presented on payment page
    let recurrence: String

    /// If `true` the payment via this network will result in redirect to the PSP web-site (e.g. PayPal, Sofortüberweisung, etc.)
    let redirect: Bool

    /// Code of button-label when this network is selected.
    let button: String?

    /// If `true` this network should been initially pre-selected.
    let selected: Bool?

    /// Map of available contract data from the first possible route.
    // let contractData: String?

    /// Data what should been used to dynamically pre-fill a form for this network
    let formData: FormData?

    /// IFrame height for selective native, only supplied if "iFrame" link is present
    let iFrameHeight: Int?

    /// Indicates that form for this network is empty, without any text and input elements
    let emptyForm: Bool?

    ///  Collection of form input elements. This information is only exposed if merchant indicated `jsonForms` option in the `view` query parameter.
    let inputElements: [InputElement]?

    /// Collection of links related to this payment network in scope of the `LIST` session
    let links: [String: URL]?

    /// Types of possible operations
    let operationType: String

    // swiftlint:disable:next line_length
    internal init(code: String, label: String, method: String, grouping: String, registration: String, recurrence: String, redirect: Bool, button: String? = nil, selected: Bool? = nil, formData: FormData? = nil, iFrameHeight: Int? = nil, emptyForm: Bool? = nil, inputElements: [InputElement]?, links: [String: URL]? = nil, operationType: String) {
        self.code = code
        self.label = label
        self.method = method
        self.grouping = grouping
        self.registration = registration
        self.recurrence = recurrence
        self.redirect = redirect
        self.button = button
        self.selected = selected
        self.formData = formData
        self.iFrameHeight = iFrameHeight
        self.emptyForm = emptyForm
        self.inputElements = inputElements
        self.links = links
        self.operationType = operationType
    }

    // MARK: -

    enum Requirement: String {
        case NONE, OPTIONAL, OPTIONAL_PRESELECTED, FORCED, FORCED_DISPLAYED
    }

    var registrationRequirement: Requirement? { Requirement(rawValue: registration) }
    var recurrenceRequirement: Requirement? {
        Requirement(rawValue: recurrence)
    }
}
