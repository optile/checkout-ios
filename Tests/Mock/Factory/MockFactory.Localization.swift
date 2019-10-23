import Foundation

extension MockFactory {
	class Localization {
		private init() {}
	}
}

extension MockFactory.Localization {
	static var paymentPage: String {
		return """
			registeredNetworksTitle=
			availableNetworksTitle=

			submitNetworkButton=Pay
			updateNetworkButton=Update
			deleteRegistrationButton=Delete
			preferredPaymentMethod=Preferred method

			acceptTermsLabel=I accept terms and conditions
			autoRegistrationLabel=Register this account for next purchase
			allowRecurrenceLabel=I authorize recurring charges on my account

			addNewAccountLabel=Use another account
			savedAccountsLabel=Saved accounts

			validFieldMessage=Valid

			deleteRegistrationConfirmation=Remove ${account.displayLabel} from your stored payment accounts?
			deleteRegistrationTooltip=Delete payment account
			deleteRegistrationTitle=Delete payment account

			networks.preset.title=Previously selected account
			networks.preset.text=Unless authorized previously, this account is not saved or retained at the end of the payment session

			button.confirm.label=Yes
			button.cancel.label=No
			button.back.label=Back

			button.charge.label=Pay
			button.update.label=Save
			button.delete.label=Delete
			button.payout.label=Credit
			button.preset.label=Continue
			button.activate.label=Check rates availability

			button.registered.charge.label=Pay
			button.registered.payout.label=Credit
			button.registered.update.label=Save
			button.registered.delete.label=Delete

			interaction.TRY_OTHER_NETWORK.BLOCKED=Payment has failed. Please try other payment network.
			interaction.TRY_OTHER_NETWORK.NETWORK_FAILURE=Payment has failed. Please try other payment network.
			interaction.TRY_OTHER_NETWORK.ADDITIONAL_NETWORKS=Additional payment networks are now available.
			interaction.TRY_OTHER_NETWORK.INVALID_REQUEST=Payment with this method is unfortunately not possible at the moment. Please use a different one.
			interaction.TRY_OTHER_NETWORK.RISK_DETECTED=Payment with this method is unfortunately not possible at the moment. Please use a different one.

			interaction.TRY_OTHER_ACCOUNT.BLOCKED=Payment has failed. Please try another account.
			interaction.TRY_OTHER_ACCOUNT.BLACKLISTED=Payment has failed. Please try another account.
			interaction.TRY_OTHER_ACCOUNT.CUSTOMER_ABORT=Payment with this account has failed. Please try a different account.
			interaction.TRY_OTHER_ACCOUNT.INVALID_ACCOUNT=Payment with this account has failed. Please try a different account.
			interaction.TRY_OTHER_ACCOUNT.EXCEEDS_LIMIT=The account exceeded its limit. Please use a different one.
			interaction.TRY_OTHER_ACCOUNT.EXPIRED_ACCOUNT=The account / card seems to be expired. Please provide new expiration date or use a different account / card.

			interaction.RETRY.STRONG_AUTHENTICATION=Payment has failed. Please try again.
			interaction.RETRY.DECLINED=Request has failed. Please try again.
			interaction.RETRY.EXCEEDS_LIMIT=The account exceeded its limit. Please use a different one.
			interaction.RETRY.TEMPORARY_FAILURE=Payment has failed. Please try again.
			interaction.RETRY.TRUSTED_CUSTOMER=The provided data seems incorrect. Please correct and retry.
			interaction.RETRY.UNKNOWN_CUSTOMER=The provided data seems incorrect. Please correct and retry.
			interaction.RETRY.ACCOUNT_NOT_ACTIVATED=The account / card seems to be not activated yet. Please activate it or try a different one.
			interaction.RETRY.EXPIRED_SESSION=The payment session has expired. Please go back and return to this step.
			interaction.RETRY.EXPIRED_ACCOUNT=The account / card seems to be expired. Please provide new expiration date or use a different account / card.
			interaction.RETRY.INVALID_REQUEST=Please agree to the registration.

			interaction.VERIFY.COMMUNICATION_FAILURE=The status of your order could not be confirmed at this time. If you do not receive a confirmation soon, please contact customer support.

			interaction.RELOAD.ACTIVATED=
			interaction.RELOAD.UPDATED=
		"""
	}
	
	static var paymentNetwork: String {
		return """
			network.label=Visa Electron Localized

			account.number.label=Card Number
			account.number.placeholder=13 to 19 digits
			account.expiryMonth.label=Expiry month
			account.expiryMonth.placeholder=MM
			account.expiryYear.label=Expiry year
			account.expiryYear.placeholder=YY
			account.expiryDate.label=Valid Thru Month / Year
			account.expiryDate.placeholder=MM / YY
			account.verificationCode.label=Security Code
			account.verificationCode.generic.placeholder=CVV
			account.verificationCode.specific.placeholder=3 digits
			account.holderName.label=Holder Name
			account.holderName.placeholder=Name on card

			account.expiryMonth.01=01
			account.expiryMonth.02=02
			account.expiryMonth.03=03
			account.expiryMonth.04=04
			account.expiryMonth.05=05
			account.expiryMonth.06=06
			account.expiryMonth.07=07
			account.expiryMonth.08=08
			account.expiryMonth.09=09
			account.expiryMonth.10=10
			account.expiryMonth.11=11
			account.expiryMonth.12=12
			account.expiryYear.2019=2019
			account.expiryYear.2020=2020
			account.expiryYear.2021=2021
			account.expiryYear.2022=2022
			account.expiryYear.2023=2023
			account.expiryYear.2024=2024
			account.expiryYear.2025=2025
			account.expiryYear.2026=2026
			account.expiryYear.2027=2027
			account.expiryYear.2028=2028
			account.expiryYear.2029=2029
			account.expiryYear.2030=2030
			account.expiryYear.2031=2031
			account.expiryYear.2032=2032
			account.expiryYear.2033=2033

			error.INVALID_ACCOUNT_NUMBER=Invalid card number!
			error.MISSING_ACCOUNT_NUMBER=Missing card number
			error.INVALID_EXPIRY_MONTH=Invalid expiry month!
			error.MISSING_EXPIRY_MONTH=Missing expiry month
			error.INVALID_EXPIRY_YEAR=Invalid expiry year!
			error.MISSING_EXPIRY_YEAR=Missing expiry year
			error.INVALID_EXPIRY_DATE=Invalid expiry date!
			error.MISSING_EXPIRY_DATE=Missing expiry date
			error.INVALID_VERIFICATION_CODE=Invalid verification code!
			error.MISSING_VERIFICATION_CODE=Missing verification code
			error.INVALID_HOLDER_NAME=Invalid holder name!
			error.MISSING_HOLDER_NAME=Missing holder name

			account.verificationCode.hint.what.title=What is the Cardholder Verification Value?
			account.verificationCode.hint.what.text=The Cardholder Verification Value (CVV) is a 3-digit code ensuring that the physical card is in the cardholder's possession while shopping online.
			account.verificationCode.hint.where.title=Where can I find it?
			account.verificationCode.hint.where.text=The security code is a 3-digit number on the back side of your card.
			account.verificationCode.hint.where.shortText=Last 3 digits on card's back side.
			account.verificationCode.hint.why.title=What does it do?
			account.verificationCode.hint.why.text=The CVV code helps organizations to prevent unauthorized or fraudaulent  use. The CVV is sent electronically to the card-issuing bank to verify its validity. The  result is returned in real-time with the authorization of the payment amount.
			account.verificationCode.length=3
		"""
	}
}
