import Foundation
@testable import Optile

extension MockFactory {
    class ListResult {
        private init() {}
    }
}

extension MockFactory.ListResult {
    static var paymentSession: PaymentSession {
        let listResultData = listResult.data(using: .utf8)!
        let listResult = try! JSONDecoder().decode(Optile.ListResult.self, from: listResultData)

        let translatedNetworks = listResult.networks.applicable.map {
            TranslatedModel(model: $0, translator: MockFactory.Localization.provider)
        }
        
        return PaymentSession(networks: translatedNetworks, accounts: nil)
    }

    static var listResult: String {
        let json = """
		{
		  "links": {
			"self": "https://api.sandbox.oscato.com/pci/v1/5da7002fa6cd3d5b4b32f045l7q04nh5g1uimnm68dc7ktuf51"
		  },
		  "resultInfo": "4 applicable and 0 registered networks are found",
		  "interaction": {
			"code": "PROCEED",
			"reason": "OK"
		  },
		  "networks": {
			"applicable": [
			  {
				"code": "VISAELECTRON",
				"label": "Visa Electron",
				"method": "DEBIT_CARD",
				"grouping": "DEBIT_CARD",
				"registration": "OPTIONAL",
				"recurrence": "NONE",
				"redirect": false,
				"links": {
				  "logo": "https://resources.sandbox.oscato.com/resource/network/VASILY_DEMO/en_US/VISAELECTRON/logo.png",
				  "self": "https://api.sandbox.oscato.com/pci/v1/5da7002fa6cd3d5b4b32f045l7q04nh5g1uimnm68dc7ktuf51/VISAELECTRON",
				  "lang": "https://resources.sandbox.oscato.com/resource/lang/VASILY_DEMO/en_US/VISAELECTRON.properties",
				  "operation": "https://api.sandbox.oscato.com/pci/v1/5da7002fa6cd3d5b4b32f045l7q04nh5g1uimnm68dc7ktuf51/VISAELECTRON/charge",
				  "validation": "https://api.sandbox.oscato.com/pci/v1/5da7002fa6cd3d5b4b32f045l7q04nh5g1uimnm68dc7ktuf51/VASILY_DEMO/en_US/VISAELECTRON/standard/validate"
				},
				"button": "button.charge.label",
				"selected": false,
				"localizedInputElements": [
				  {
					"name": "number",
					"type": "numeric",
					"label": "Card Number"
				  },
				  {
					"name": "holderName",
					"type": "string",
					"label": "Holder Name"
				  },
				  {
					"name": "expiryMonth",
					"type": "select",
					"label": "Expiry month",
					"options": [
					  {
						"value": "01",
						"label": "01"
					  },
					  {
						"value": "02",
						"label": "02"
					  },
					  {
						"value": "03",
						"label": "03"
					  },
					  {
						"value": "04",
						"label": "04"
					  },
					  {
						"value": "05",
						"label": "05"
					  },
					  {
						"value": "06",
						"label": "06"
					  },
					  {
						"value": "07",
						"label": "07"
					  },
					  {
						"value": "08",
						"label": "08"
					  },
					  {
						"value": "09",
						"label": "09"
					  },
					  {
						"value": "10",
						"label": "10"
					  },
					  {
						"value": "11",
						"label": "11"
					  },
					  {
						"value": "12",
						"label": "12"
					  }
					]
				  },
				  {
					"name": "expiryYear",
					"type": "select",
					"label": "Expiry year",
					"options": [
					  {
						"value": "2019",
						"label": "2019"
					  },
					  {
						"value": "2020",
						"label": "2020"
					  },
					  {
						"value": "2021",
						"label": "2021"
					  },
					  {
						"value": "2022",
						"label": "2022"
					  },
					  {
						"value": "2023",
						"label": "2023"
					  },
					  {
						"value": "2024",
						"label": "2024"
					  },
					  {
						"value": "2025",
						"label": "2025"
					  },
					  {
						"value": "2026",
						"label": "2026"
					  },
					  {
						"value": "2027",
						"label": "2027"
					  },
					  {
						"value": "2028",
						"label": "2028"
					  },
					  {
						"value": "2029",
						"label": "2029"
					  },
					  {
						"value": "2030",
						"label": "2030"
					  },
					  {
						"value": "2031",
						"label": "2031"
					  },
					  {
						"value": "2032",
						"label": "2032"
					  },
					  {
						"value": "2033",
						"label": "2033"
					  }
					]
				  },
				  {
					"name": "verificationCode",
					"type": "integer",
					"label": "Security Code"
				  }
				]
			  },
			  {
				"code": "MASTERCARD",
				"label": "Mastercard",
				"method": "CREDIT_CARD",
				"grouping": "CREDIT_CARD",
				"registration": "OPTIONAL",
				"recurrence": "NONE",
				"redirect": false,
				"links": {
				  "logo": "https://resources.sandbox.oscato.com/resource/network/VASILY_DEMO/en_US/MASTERCARD/logo.png",
				  "self": "https://api.sandbox.oscato.com/pci/v1/5da7002fa6cd3d5b4b32f045l7q04nh5g1uimnm68dc7ktuf51/MASTERCARD",
				  "lang": "https://resources.sandbox.oscato.com/resource/lang/VASILY_DEMO/en_US/MASTERCARD.properties",
				  "operation": "https://api.sandbox.oscato.com/pci/v1/5da7002fa6cd3d5b4b32f045l7q04nh5g1uimnm68dc7ktuf51/MASTERCARD/charge",
				  "validation": "https://api.sandbox.oscato.com/pci/v1/5da7002fa6cd3d5b4b32f045l7q04nh5g1uimnm68dc7ktuf51/VASILY_DEMO/en_US/MASTERCARD/standard/validate"
				},
				"button": "button.charge.label",
				"selected": false,
				"localizedInputElements": [
				  {
					"name": "number",
					"type": "numeric",
					"label": "Card Number"
				  },
				  {
					"name": "holderName",
					"type": "string",
					"label": "Holder Name"
				  },
				  {
					"name": "expiryMonth",
					"type": "select",
					"label": "Expiry month",
					"options": [
					  {
						"value": "01",
						"label": "01"
					  },
					  {
						"value": "02",
						"label": "02"
					  },
					  {
						"value": "03",
						"label": "03"
					  },
					  {
						"value": "04",
						"label": "04"
					  },
					  {
						"value": "05",
						"label": "05"
					  },
					  {
						"value": "06",
						"label": "06"
					  },
					  {
						"value": "07",
						"label": "07"
					  },
					  {
						"value": "08",
						"label": "08"
					  },
					  {
						"value": "09",
						"label": "09"
					  },
					  {
						"value": "10",
						"label": "10"
					  },
					  {
						"value": "11",
						"label": "11"
					  },
					  {
						"value": "12",
						"label": "12"
					  }
					]
				  },
				  {
					"name": "expiryYear",
					"type": "select",
					"label": "Expiry year",
					"options": [
					  {
						"value": "2019",
						"label": "2019"
					  },
					  {
						"value": "2020",
						"label": "2020"
					  },
					  {
						"value": "2021",
						"label": "2021"
					  },
					  {
						"value": "2022",
						"label": "2022"
					  },
					  {
						"value": "2023",
						"label": "2023"
					  },
					  {
						"value": "2024",
						"label": "2024"
					  },
					  {
						"value": "2025",
						"label": "2025"
					  },
					  {
						"value": "2026",
						"label": "2026"
					  },
					  {
						"value": "2027",
						"label": "2027"
					  },
					  {
						"value": "2028",
						"label": "2028"
					  },
					  {
						"value": "2029",
						"label": "2029"
					  },
					  {
						"value": "2030",
						"label": "2030"
					  },
					  {
						"value": "2031",
						"label": "2031"
					  },
					  {
						"value": "2032",
						"label": "2032"
					  },
					  {
						"value": "2033",
						"label": "2033"
					  }
					]
				  },
				  {
					"name": "verificationCode",
					"type": "integer",
					"label": "Security Code"
				  }
				]
			  },
			  {
				"code": "SEPADD",
				"label": "SEPA",
				"method": "DIRECT_DEBIT",
				"grouping": "DIRECT_DEBIT",
				"registration": "OPTIONAL",
				"recurrence": "NONE",
				"redirect": false,
				"links": {
				  "logo": "https://resources.sandbox.oscato.com/resource/network/VASILY_DEMO/en_US/SEPADD/logo.png",
				  "self": "https://api.sandbox.oscato.com/pci/v1/5da7002fa6cd3d5b4b32f045l7q04nh5g1uimnm68dc7ktuf51/SEPADD",
				  "lang": "https://resources.sandbox.oscato.com/resource/lang/VASILY_DEMO/en_US/SEPADD.properties",
				  "operation": "https://api.sandbox.oscato.com/pci/v1/5da7002fa6cd3d5b4b32f045l7q04nh5g1uimnm68dc7ktuf51/SEPADD/charge",
				  "validation": "https://api.sandbox.oscato.com/pci/v1/5da7002fa6cd3d5b4b32f045l7q04nh5g1uimnm68dc7ktuf51/VASILY_DEMO/en_US/SEPADD/standard/validate"
				},
				"button": "button.charge.label",
				"selected": false,
				"localizedInputElements": [
				  {
					"name": "holderName",
					"type": "string",
					"label": "Account holder's name"
				  },
				  {
					"name": "iban",
					"type": "string",
					"label": "IBAN"
				  },
				  {
					"name": "bic",
					"type": "string",
					"label": "BIC"
				  }
				]
			  },
			  {
				"code": "VISA",
				"label": "Visa",
				"method": "CREDIT_CARD",
				"grouping": "CREDIT_CARD",
				"registration": "OPTIONAL",
				"recurrence": "NONE",
				"redirect": false,
				"links": {
				  "logo": "https://resources.sandbox.oscato.com/resource/network/VASILY_DEMO/en_US/VISA/logo.png",
				  "self": "https://api.sandbox.oscato.com/pci/v1/5da7002fa6cd3d5b4b32f045l7q04nh5g1uimnm68dc7ktuf51/VISA",
				  "lang": "https://resources.sandbox.oscato.com/resource/lang/VASILY_DEMO/en_US/VISA.properties",
				  "operation": "https://api.sandbox.oscato.com/pci/v1/5da7002fa6cd3d5b4b32f045l7q04nh5g1uimnm68dc7ktuf51/VISA/charge",
				  "validation": "https://api.sandbox.oscato.com/pci/v1/5da7002fa6cd3d5b4b32f045l7q04nh5g1uimnm68dc7ktuf51/VASILY_DEMO/en_US/VISA/standard/validate"
				},
				"button": "button.charge.label",
				"selected": false,
				"localizedInputElements": [
				  {
					"name": "number",
					"type": "numeric",
					"label": "Card Number"
				  },
				  {
					"name": "holderName",
					"type": "string",
					"label": "Holder Name"
				  },
				  {
					"name": "expiryMonth",
					"type": "select",
					"label": "Expiry month",
					"options": [
					  {
						"value": "01",
						"label": "01"
					  },
					  {
						"value": "02",
						"label": "02"
					  },
					  {
						"value": "03",
						"label": "03"
					  },
					  {
						"value": "04",
						"label": "04"
					  },
					  {
						"value": "05",
						"label": "05"
					  },
					  {
						"value": "06",
						"label": "06"
					  },
					  {
						"value": "07",
						"label": "07"
					  },
					  {
						"value": "08",
						"label": "08"
					  },
					  {
						"value": "09",
						"label": "09"
					  },
					  {
						"value": "10",
						"label": "10"
					  },
					  {
						"value": "11",
						"label": "11"
					  },
					  {
						"value": "12",
						"label": "12"
					  }
					]
				  },
				  {
					"name": "expiryYear",
					"type": "select",
					"label": "Expiry year",
					"options": [
					  {
						"value": "2019",
						"label": "2019"
					  },
					  {
						"value": "2020",
						"label": "2020"
					  },
					  {
						"value": "2021",
						"label": "2021"
					  },
					  {
						"value": "2022",
						"label": "2022"
					  },
					  {
						"value": "2023",
						"label": "2023"
					  },
					  {
						"value": "2024",
						"label": "2024"
					  },
					  {
						"value": "2025",
						"label": "2025"
					  },
					  {
						"value": "2026",
						"label": "2026"
					  },
					  {
						"value": "2027",
						"label": "2027"
					  },
					  {
						"value": "2028",
						"label": "2028"
					  },
					  {
						"value": "2029",
						"label": "2029"
					  },
					  {
						"value": "2030",
						"label": "2030"
					  },
					  {
						"value": "2031",
						"label": "2031"
					  },
					  {
						"value": "2032",
						"label": "2032"
					  },
					  {
						"value": "2033",
						"label": "2033"
					  }
					]
				  },
				  {
					"name": "verificationCode",
					"type": "integer",
					"label": "Security Code"
				  }
				]
			  }
			]
		  },
		  "operationType": "CHARGE",
		  "style": {
			"language": "en_US"
		  }
		}
		"""

        return json
    }
}
