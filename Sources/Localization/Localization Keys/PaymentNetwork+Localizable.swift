import Foundation

extension PaymentNetwork: Localizable {
	var localizableFields: [LocalizationKey<PaymentNetwork>] {
		return [
			.init(\.label, key: "network.label"),
		]
	}
}
