import Foundation

enum LocalTranslation: String, CaseIterable {
	case errorEmpty = "pmpage_error_empty"
	case errorNotSupported = "pmpage_error_notsupported"
	case contentDescription = "pmpage_contentdescription"
	
	case subtitleDate = "pmlist_subtitle_date"
	case widgetDate = "pmlist_widget_date"
	
	case listTitle = "pmlocal_list_title"
	case listHeaderNetworks = "pmlocal_list_header_networks"
	
	case chargeTitle = "pmlocal_charge_title"
	case chargeText = "pmlocal_charge_text"
	case chargeInterrupted = "pmlocal_charge_interrupted"
	
	case errorConnection = "pmlocal_error_connection"
	case errorDefault = "pmlocal_error_default"
	
	case buttonCancel = "pmlocal_button_cancel"
	case buttonRetry = "pmlocal_button_retry"
	case buttonUpdate = "pmlocal_button_update"
	
	var localizedString: String {
		switch self {
		case .errorEmpty: return "There are no payment methods available."
		case .errorNotSupported: return "The payment methods in the current payment session are not supported by this app."
		case .contentDescription: return "PaymentImage"
			
		case .subtitleDate: return "%1$02d / %2$d"
		case .widgetDate: return "%1$s / %2$s"
			
		case .listTitle: return "Payment methods"
		case .listHeaderNetworks: return "Choose a method"
			
		case .chargeTitle: return "Payment processing…"
		case .chargeText: return "Confirmation may take up to 30 seconds. Don't close or click the back button."
		case .chargeInterrupted: return "Please wait for the payment to process."
			
		case .errorConnection: return "There was a problem with your internet connection."
		case .errorDefault: return "Unfortunately we were unable to continue with your payment request. Maybe it was submitted already or timed out. You could start the payment checkout again."
			
		case .buttonCancel: return "Cancel"
		case .buttonRetry: return "Retry"
		case .buttonUpdate: return "Update"
		}
	}
}
