import Foundation

public class InstallmentsPlan: NSObject, Decodable {
	enum CodingKeys: String, CodingKey {
		case planDescription = "description"
		case id, numberOfInstallments, schedule, dueDays, currency, interestAmount, installmentSetupFee, installmentPeriodicFee, installmentFee, totalAmount, effectiveInterestRate, creditInformationUrl, dataPrivacyConsentUrl, logoUrl
	}
	
	/// An ID of installments plan.
	public let id: String?
	
	/// Description of the installments plan.
	/// - Note: renamed for Objective-C compatability, JSON original key: `description`
	public let planDescription: String?
	
	/// Number of installments in the installments plan.
	public let numberOfInstallments: Int?
	
	/// Collection of particular installment with payment date and amount.
	public let schedule: [InstallmentItem]?
	
	/// Collection of possible payment days like 1, 15, 28, etc.
	public let dueDays: [Int]?
	
	/// 3-letter currency code (ISO 4217) of all payment amounts within current installments plan.
	public let currency: String?
	
	/// The interest amount in major units.
	public let interestAmount: Double?
	
	/// The fee for setting up the installment plan in major units.
	public let installmentSetupFee: Double?
	
	/// The constant periodic fee for each installment in major units.
	/// Should be supplied only when it is equal for every installment payment.
	public let installmentPeriodicFee: Double?
	
	/// The total fee for the installment payment (or service-charge-amount) in major units.
	/// It should match the sum of all installment periodic fees and the installment set-up fee.
	public let installmentFee: Double?
	
	/// The total transaction amount in major units (including original amount, all fees and the interest).
	public let totalAmount: Double?
	
	/// The effective interest rate per year in percentages (Effektivzins).
	public let effectiveInterestRate: Double?
	
	/// URL to the Credit Information document.
	public let creditInformationUrl: URL?
	
	/// URL to the data privacy consent document.
	public let dataPrivacyConsentUrl: URL?
	
	/// URL to the installment plan logo.
	public let logoUrl: URL?
}
