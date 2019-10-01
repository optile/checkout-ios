import Foundation

public struct Interaction: Decodable {
	/// Interaction code that advices further interaction with this customer or payment.
	/// See list of [Interaction Codes](https://www.optile.io/opg#292619).
	public let code: Code
	
	/// Reason of this interaction, complements interaction code and has more detailed granularity.
	/// See list of [Interaction Codes](https://www.optile.io/opg#292619).
	public let reason: Reason
	
	/// If supplied, holds recommended time for next retry. Only applicable for recurring payments.
	public let retryAfter: Date?
	
	// MARK: - Enumerations
	
	/// Interaction code that advices further interaction with this customer or payment.
	/// See list of [Interaction Codes](https://www.optile.io/opg#292619).
	public enum Code: String, Decodable {
		case PROCEED, ABORT, TRY_OTHER_NETWORK, TRY_OTHER_ACCOUNT, RETRY, RELOAD
	}
	
	/// Reason of this interaction, complements interaction code and has more detailed granularity.
	/// See list of [Interaction Codes](https://www.optile.io/opg#292619).
	public enum Reason: String, Decodable {
		case OK, PENDING, TRUSTED, STRONG_AUTHENTICATION, DECLINED, EXPIRED, EXCEEDS_LIMIT, TEMPORARY_FAILURE, UNKNOWN, NETWORK_FAILURE, BLACKLISTED, BLOCKED, SYSTEM_FAILURE, INVALID_ACCOUNT, FRAUD, ADDITIONAL_NETWORKS, INVALID_REQUEST, SCHEDULED, NO_NETWORKS, DUPLICATE_OPERATION, CHARGEBACK, RISK_DETECTED, CUSTOMER_ABORT, EXPIRED_SESSION, EXPIRED_ACCOUNT, ACCOUNT_NOT_ACTIVATED, TRUSTED_CUSTOMER, UNKNOWN_CUSTOMER, ACTIVATED, UPDATED, TAKE_ACTION
	}
}
