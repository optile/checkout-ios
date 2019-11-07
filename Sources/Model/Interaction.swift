import Foundation

@objc public class Interaction: NSObject, Decodable {
	/// Interaction code that advices further interaction with this customer or payment.
	/// See list of [Interaction Codes](https://www.optile.io/opg#292619).
	public let code: String
	
	/// Reason of this interaction, complements interaction code and has more detailed granularity.
	/// See list of [Interaction Codes](https://www.optile.io/opg#292619).
	public let reason: String
}

public extension Interaction {
	enum Code: String, Decodable {
		case PROCEED, ABORT, TRY_OTHER_NETWORK, TRY_OTHER_ACCOUNT, RETRY, RELOAD
	}
	
	var interactionCode: Code? { Code(rawValue: code) }
	
	enum Reason: String, Decodable {
		case OK, PENDING, TRUSTED, STRONG_AUTHENTICATION, DECLINED, EXPIRED, EXCEEDS_LIMIT, TEMPORARY_FAILURE, UNKNOWN, NETWORK_FAILURE, BLACKLISTED, BLOCKED, SYSTEM_FAILURE, INVALID_ACCOUNT, FRAUD, ADDITIONAL_NETWORKS, INVALID_REQUEST, SCHEDULED, NO_NETWORKS, DUPLICATE_OPERATION, CHARGEBACK, RISK_DETECTED, CUSTOMER_ABORT, EXPIRED_SESSION, EXPIRED_ACCOUNT, ACCOUNT_NOT_ACTIVATED, TRUSTED_CUSTOMER, UNKNOWN_CUSTOMER, ACTIVATED, UPDATED, TAKE_ACTION
	}
	
	var interactionReason: Reason? { Reason(rawValue: reason) }
}
