import Foundation

final class PaymentNetwork {
    let applicableNetwork: ApplicableNetwork
    let translation: TranslationProvider

    let label: String
    let submitButtonLabel: String
    var logo: Loadable<Data>?
    
    init(from applicableNetwork: ApplicableNetwork, localizeUsing localizer: TranslationProvider) {
        self.applicableNetwork = applicableNetwork
        self.translation = localizer
        
        self.label = localizer.translation(forKey: "network.label")
        self.submitButtonLabel = translation.translation(forKey: applicableNetwork.button ?? "button.charge.label")
        
        if let logoURL = applicableNetwork.links?["logo"] {
            logo = .notLoaded(logoURL)
        } else {
            logo = nil
        }
    }
}

enum Loadable<T> {
    case loaded(Result<T, Error>)
    case notLoaded(URL)
    
    var value: T? {
        guard case let .loaded(loadedResult) = self else { return nil }
        
        return try? loadedResult.get()
    }
}

extension PaymentNetwork: Equatable, Hashable {
    public static func == (lhs: PaymentNetwork, rhs: PaymentNetwork) -> Bool {
        return (lhs.applicableNetwork.code == rhs.applicableNetwork.code)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(applicableNetwork.code)
    }
}

#if canImport(UIKit)
import UIKit

extension Loadable where T == Data {
    var image: UIImage? {
        guard let data = value else { return nil }
        return UIImage(data: data)
    }
}
#endif
