import Foundation

final class PaymentSession {
    let networks: [PaymentNetwork]
    let registeredAccounts: [RegisteredAccount]?
    
    init(networks: [TranslatedModel<ApplicableNetwork>], accounts: [TranslatedModel<AccountRegistration>]?) {
        self.networks = networks.map {
            .init(from: $0.model, localizeUsing: $0.translator)
        }
        
        self.registeredAccounts = accounts?.map {
            .init(from: $0.model, localizeUsing: $0.translator)
        }
    }
}
