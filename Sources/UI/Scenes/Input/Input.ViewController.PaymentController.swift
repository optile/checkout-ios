import Foundation

protocol PaymentControllerDelegate: class {
    func paymentController(paymentCompleteWith result: PaymentResult)
    func paymentController(presentURL url: URL)

    /// Payment has been failed and an error should be displayed
    /// - Parameters:
    ///   - isRetryable: user may correct an input, view shouldn't be dismissed
    func paymentController(paymentFailedWith error: Error, withResult result: PaymentResult, isRetryable: Bool)
}

extension Input.ViewController {
    class PaymentController {
        let paymentServiceFactory: PaymentServicesFactory

        weak var delegate: PaymentControllerDelegate?

        init(paymentServiceFactory: PaymentServicesFactory) {
            self.paymentServiceFactory = paymentServiceFactory
        }
    }
}

extension Input.ViewController.PaymentController {
    func submitPayment(for network: Input.Network) {
         let service = paymentServiceFactory.createPaymentService(forNetworkCode: network.networkCode, paymentMethod: network.paymentMethod)
         service?.delegate = self

         var inputFieldsDictionary = [String: String]()
         var expiryDate: String?
         for element in network.uiModel.inputFields + network.uiModel.separatedCheckboxes {
             if element.name == "expiryDate" {
                 // Expiry date is processed below
                 expiryDate = element.value
                 continue
             }

             inputFieldsDictionary[element.name] = element.value
         }

         // Split expiry date
         if let expiryDate = expiryDate {
             inputFieldsDictionary["expiryMonth"] = String(expiryDate.prefix(2))
            
             // Create expiry year
             guard let shortExpiryYear = Int(expiryDate.suffix(2)) else {
                 let errorInteraction = Interaction(code: .RETRY, reason: .CLIENTSIDE_ERROR)
                 let error = InternalError(description: "Couldn't convert expiry date's year to integer: %@", expiryDate)
                 let paymentResult = PaymentResult(operationResult: nil, interaction: errorInteraction, error: error)
                delegate?.paymentController(paymentFailedWith: error, withResult: paymentResult, isRetryable: true)
                 return
             }
            
             let fullExpiryYear = createFullYear(fromShortYear: shortExpiryYear)
             inputFieldsDictionary["expiryYear"] = String(fullExpiryYear)
         }

         let request = PaymentRequest(networkCode: network.networkCode, operationURL: network.operationURL, inputFields: inputFieldsDictionary)

         service?.send(paymentRequest: request)
     }

    /// Create a full expiry year from the last part of the expiry year.
    /// This will use dynamic windowing of -30 years and +70 year.
    /// - Parameter toYear: year which the user entered, from 00 or 99
    /// - Returns: transformed year value using dynamic rule, from 00 to 99
    private func createFullYear(fromShortYear shortYear: Int) -> Int {
        let currentYear = Calendar.current.component(.year, from: Date())
        
        let startingYear = currentYear - 30
        let endingYear = currentYear + 70

        let year = shortYear > (startingYear % 100) ? startingYear : endingYear
        return (year - (year % 100)) + shortYear
    }
}

extension Input.ViewController.PaymentController: PaymentServiceDelegate {
    func paymentService(presentURL url: URL) {
        delegate?.paymentController(presentURL: url)
    }

    func paymentService(didReceivePaymentResult paymentResult: PaymentResult) {
        switch Interaction.Code(rawValue: paymentResult.interaction.code) {
        case .PROCEED, .ABORT, .VERIFY, .RELOAD:
            delegate?.paymentController(paymentCompleteWith: paymentResult)
        case .RETRY:
            let error = Input.LocalizableError(interaction: paymentResult.interaction)
            delegate?.paymentController(paymentFailedWith: error, withResult: paymentResult, isRetryable: true)
        case .TRY_OTHER_ACCOUNT, .TRY_OTHER_NETWORK:
            let error = Input.LocalizableError(interaction: paymentResult.interaction)
            delegate?.paymentController(paymentFailedWith: error, withResult: paymentResult, isRetryable: false)
        case .none:
            // Unknown interaction code was met
            delegate?.paymentController(paymentCompleteWith: paymentResult)
        }
    }
}

private extension Input.LocalizableError {
    init(interaction: Interaction) {
        let localizationKeyPrefix = "interaction." + interaction.code + "." + interaction.reason + "."

        titleKey = localizationKeyPrefix + "title"
        messageKey = localizationKeyPrefix + "text"
    }
}
