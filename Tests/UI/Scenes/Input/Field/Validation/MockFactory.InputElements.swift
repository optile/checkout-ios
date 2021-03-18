// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation
@testable import PayoneerCheckout

extension MockFactory {
    class Validation {}
}

extension MockFactory.Validation {
    static var validationTestCases: [Network] {
        let jsonData = validationJSON.data(using: .utf8)!
        return try! JSONDecoder().decode([Network].self, from: jsonData)
    }

    static var validationJSON: String {
        return """
            [
              {
                "inputElements": [
                  {
                    "name": "number",
                    "tests": [
                      {
                        "value": "12345",
                        "error": null
                      },
                      {
                        "value": "12345ABC",
                        "error": "INVALID_ACCOUNT_NUMBER"
                      },
                      {
                        "value": "",
                        "error": "MISSING_ACCOUNT_NUMBER"
                      },
                      {
                        "value": null,
                        "error": "MISSING_ACCOUNT_NUMBER"
                      }
                    ]
                  },
                  {
                    "name": "holderName",
                    "tests": [
                      {
                        "value": "John Doe",
                        "error": null
                      },
                      {
                        "value": "",
                        "error": "MISSING_HOLDER_NAME"
                      },
                      {
                        "value": null,
                        "error": "MISSING_HOLDER_NAME"
                      },
                      {
                        "value": "MoreThan128_XPEV349YOlM5aAL3nx7equiKeaUvavq6ZFbSh2M3JKZyJQ5weuZ9wWRTmzYwBcpjm7VhNhl3fTe7FQxRtmIpQbKvnlsfewjQmiWlFvXGt3fojnJhO2HT2Hy55v0Rk0VZF",
                        "error": "INVALID_HOLDER_NAME"
                      },
                      {
                        "value": "aa",
                        "error": "INVALID_HOLDER_NAME"
                      }
                    ]
                  },
                  {
                    "name": "bankCode",
                    "tests": [
                      {
                        "value": "abcd",
                        "error": null
                      },
                      {
                        "value": "",
                        "error": "MISSING_BANK_CODE"
                      },
                      {
                        "value": null,
                        "error": "MISSING_BANK_CODE"
                      }
                    ]
                  },
                  {
                    "name": "iban",
                    "tests": [
                      {
                        "value": "AT022050302101023600",
                        "error": null
                      },
                      {
                        "value": "DE27100777770209299700",
                        "error": null
                      },
                      {
                        "value": "AT1234567890123456",
                        "error": "INVALID_IBAN"
                      },
                      {
                        "value": "ABCD",
                        "error": "INVALID_IBAN"
                      },
                      {
                        "value": "",
                        "error": "MISSING_IBAN"
                      },
                      {
                        "value": null,
                        "error": "MISSING_IBAN"
                      }
                    ]
                  },
                  {
                    "name": "bic",
                    "tests": [
                      {
                        "value": "AABSDE31XXX",
                        "error": null
                      },
                      {
                        "value": "ABCD",
                        "error": "INVALID_BIC"
                      },
                      {
                        "value": "",
                        "error": "MISSING_BIC"
                      },
                      {
                        "value": null,
                        "error": "MISSING_BIC"
                      }
                    ]
                  },
                  {
                    "name": "verificationCode",
                    "tests": [
                      {
                        "value": "1234",
                        "error": null
                      },
                      {
                        "value": "12a",
                        "error": "INVALID_VERIFICATION_CODE"
                      },
                      {
                        "value": "",
                        "error": null
                      },
                      {
                        "value": null,
                        "error": null
                      }
                    ]
                  }
                ]
              },
              {
                "method": "CREDIT_CARD",
                "inputElements": [
                  {
                    "name": "number",
                    "tests": [
                      {
                        "value": "36699",
                        "error": null
                      },
                      {
                        "value": "4556260657599841",
                        "error": null
                      },
                      {
                        "value": "5386813397330555",
                        "error": null
                      },
                      {
                        "value": "6011206880824187",
                        "error": null
                      },
                      {
                        "value": "376848137807457",
                        "error": null
                      },
                      {
                        "value": "3540173304463363",
                        "error": null
                      },
                      {
                        "value": "5545674672092247",
                        "error": null
                      },
                      {
                        "value": "30121723749105",
                        "error": null
                      },
                      {
                        "value": "36394455633086",
                        "error": null
                      },
                      {
                        "value": "6762174698488713",
                        "error": null
                      },
                      {
                        "value": "4917582391037711",
                        "error": null
                      },
                      {
                        "value": "6393363361928900",
                        "error": null
                      },
                      {
                        "value": "12345",
                        "error": "INVALID_ACCOUNT_NUMBER"
                      },
                      {
                        "value": "1234567890123456",
                        "error": "INVALID_ACCOUNT_NUMBER"
                      },
                      {
                        "value": "",
                        "error": "MISSING_ACCOUNT_NUMBER"
                      },
                      {
                        "value": null,
                        "error": "MISSING_ACCOUNT_NUMBER"
                      }
                    ]
                  }
                ]
              },
              {
                "method": "CREDIT_CARD",
                "code": "AMEX",
                "inputElements": [
                  {
                    "name": "number",
                    "tests": [
                      {
                        "value": "373051954985299",
                        "error": null
                      },
                      {
                        "value": "36699",
                        "error": "INVALID_ACCOUNT_NUMBER"
                      },
                      {
                        "value": "",
                        "error": "MISSING_ACCOUNT_NUMBER"
                      },
                      {
                        "value": null,
                        "error": "MISSING_ACCOUNT_NUMBER"
                      }
                    ]
                  },
                  {
                    "name": "verificationCode",
                    "tests": [
                      {
                        "value": "1234",
                        "error": null
                      },
                      {
                        "value": "123a",
                        "error": "INVALID_VERIFICATION_CODE"
                      },
                      {
                        "value": "123",
                        "error": "INVALID_VERIFICATION_CODE"
                      },
                      {
                        "value": "",
                        "error": "MISSING_VERIFICATION_CODE"
                      },
                      {
                        "value": null,
                        "error": "MISSING_VERIFICATION_CODE"
                      }
                    ]
                  }
                ]
              },
              {
                "method": "CREDIT_CARD",
                "code": "CASTORAMA",
                "inputElements": [
                  {
                    "name": "number",
                    "tests": [
                      {
                        "value": "4111111111111111",
                        "error": null
                      },
                      {
                        "value": "36699",
                        "error": "INVALID_ACCOUNT_NUMBER"
                      },
                      {
                        "value": "",
                        "error": "MISSING_ACCOUNT_NUMBER"
                      },
                      {
                        "value": null,
                        "error": "MISSING_ACCOUNT_NUMBER"
                      }
                    ]
                  },
                  {
                    "name": "verificationCode",
                    "tests": [
                      {
                        "value": "1234",
                        "error": null
                      },
                      {
                        "value": "123a",
                        "error": "INVALID_VERIFICATION_CODE"
                      },
                      {
                        "value": "123",
                        "error": "INVALID_VERIFICATION_CODE"
                      },
                      {
                        "value": "",
                        "error": "MISSING_VERIFICATION_CODE"
                      },
                      {
                        "value": null,
                        "error": "MISSING_VERIFICATION_CODE"
                      }
                    ]
                  }
                ]
              },
              {
                "method": "CREDIT_CARD",
                "code": "DINERS",
                "inputElements": [
                  {
                    "name": "number",
                    "tests": [
                      {
                        "value": "30282713214300",
                        "error": null
                      },
                      {
                        "value": "36699",
                        "error": "INVALID_ACCOUNT_NUMBER"
                      },
                      {
                        "value": "",
                        "error": "MISSING_ACCOUNT_NUMBER"
                      },
                      {
                        "value": null,
                        "error": "MISSING_ACCOUNT_NUMBER"
                      }
                    ]
                  },
                  {
                    "name": "verificationCode",
                    "tests": [
                      {
                        "value": "123",
                        "error": null
                      },
                      {
                        "value": "12a",
                        "error": "INVALID_VERIFICATION_CODE"
                      },
                      {
                        "value": "1234",
                        "error": "INVALID_VERIFICATION_CODE"
                      },
                      {
                        "value": "",
                        "error": "MISSING_VERIFICATION_CODE"
                      },
                      {
                        "value": null,
                        "error": "MISSING_VERIFICATION_CODE"
                      }
                    ]
                  }
                ]
              },
              {
                "method": "CREDIT_CARD",
                "code": "DISCOVER",
                "inputElements": [
                  {
                    "name": "number",
                    "tests": [
                      {
                        "value": "6011548597185331",
                        "error": null
                      },
                      {
                        "value": "36699",
                        "error": "INVALID_ACCOUNT_NUMBER"
                      },
                      {
                        "value": "",
                        "error": "MISSING_ACCOUNT_NUMBER"
                      },
                      {
                        "value": null,
                        "error": "MISSING_ACCOUNT_NUMBER"
                      }
                    ]
                  },
                  {
                    "name": "verificationCode",
                    "tests": [
                      {
                        "value": "123",
                        "error": null
                      },
                      {
                        "value": "12a",
                        "error": "INVALID_VERIFICATION_CODE"
                      },
                      {
                        "value": "1234",
                        "error": "INVALID_VERIFICATION_CODE"
                      },
                      {
                        "value": "",
                        "error": "MISSING_VERIFICATION_CODE"
                      },
                      {
                        "value": null,
                        "error": "MISSING_VERIFICATION_CODE"
                      }
                    ]
                  }
                ]
              },
              {
                "method": "CREDIT_CARD",
                "code": "MASTERCARD",
                "inputElements": [
                  {
                    "name": "number",
                    "tests": [
                      {
                        "value": "5290836048016633",
                        "error": null
                      },
                      {
                        "value": "36699",
                        "error": "INVALID_ACCOUNT_NUMBER"
                      },
                      {
                        "value": "",
                        "error": "MISSING_ACCOUNT_NUMBER"
                      },
                      {
                        "value": null,
                        "error": "MISSING_ACCOUNT_NUMBER"
                      }
                    ]
                  },
                  {
                    "name": "verificationCode",
                    "tests": [
                      {
                        "value": "123",
                        "error": null
                      },
                      {
                        "value": "12a",
                        "error": "INVALID_VERIFICATION_CODE"
                      },
                      {
                        "value": "1234",
                        "error": "INVALID_VERIFICATION_CODE"
                      },
                      {
                        "value": "",
                        "error": "MISSING_VERIFICATION_CODE"
                      },
                      {
                        "value": null,
                        "error": "MISSING_VERIFICATION_CODE"
                      }
                    ]
                  }
                ]
              },
              {
                "method": "CREDIT_CARD",
                "code": "UNIONPAY",
                "inputElements": [
                  {
                    "name": "number",
                    "tests": [
                      {
                        "value": "62123456789000003",
                        "error": null
                      },
                      {
                        "value": "36699",
                        "error": "INVALID_ACCOUNT_NUMBER"
                      },
                      {
                        "value": "",
                        "error": "MISSING_ACCOUNT_NUMBER"
                      },
                      {
                        "value": null,
                        "error": "MISSING_ACCOUNT_NUMBER"
                      }
                    ]
                  },
                  {
                    "name": "verificationCode",
                    "tests": [
                      {
                        "value": "123",
                        "error": null
                      },
                      {
                        "value": "12a",
                        "error": "INVALID_VERIFICATION_CODE"
                      },
                      {
                        "value": "1234",
                        "error": "INVALID_VERIFICATION_CODE"
                      },
                      {
                        "value": "",
                        "error": "MISSING_VERIFICATION_CODE"
                      },
                      {
                        "value": null,
                        "error": "MISSING_VERIFICATION_CODE"
                      }
                    ]
                  }
                ]
              },
              {
                "method": "CREDIT_CARD",
                "code": "VISA",
                "inputElements": [
                  {
                    "name": "number",
                    "tests": [
                      {
                        "value": "4556260657599841",
                        "error": null
                      },
                      {
                        "value": "36699",
                        "error": "INVALID_ACCOUNT_NUMBER"
                      },
                      {
                        "value": "",
                        "error": "MISSING_ACCOUNT_NUMBER"
                      },
                      {
                        "value": null,
                        "error": "MISSING_ACCOUNT_NUMBER"
                      }
                    ]
                  },
                  {
                    "name": "verificationCode",
                    "tests": [
                      {
                        "value": "123",
                        "error": null
                      },
                      {
                        "value": "12a",
                        "error": "INVALID_VERIFICATION_CODE"
                      },
                      {
                        "value": "1234",
                        "error": "INVALID_VERIFICATION_CODE"
                      },
                      {
                        "value": "",
                        "error": "MISSING_VERIFICATION_CODE"
                      },
                      {
                        "value": null,
                        "error": "MISSING_VERIFICATION_CODE"
                      }
                    ]
                  }
                ]
              },
              {
                "method": "CREDIT_CARD",
                "code": "VISA_DANKORT",
                "inputElements": [
                  {
                    "name": "number",
                    "tests": [
                      {
                        "value": "4917300800000000",
                        "error": null
                      },
                      {
                        "value": "36699",
                        "error": "INVALID_ACCOUNT_NUMBER"
                      },
                      {
                        "value": "",
                        "error": "MISSING_ACCOUNT_NUMBER"
                      },
                      {
                        "value": null,
                        "error": "MISSING_ACCOUNT_NUMBER"
                      }
                    ]
                  },
                  {
                    "name": "verificationCode",
                    "tests": [
                      {
                        "value": "123",
                        "error": null
                      },
                      {
                        "value": "12a",
                        "error": "INVALID_VERIFICATION_CODE"
                      },
                      {
                        "value": "1234",
                        "error": "INVALID_VERIFICATION_CODE"
                      },
                      {
                        "value": "",
                        "error": "MISSING_VERIFICATION_CODE"
                      },
                      {
                        "value": null,
                        "error": "MISSING_VERIFICATION_CODE"
                      }
                    ]
                  }
                ]
              },
              {
                "method": "DEBIT_CARD",
                "code": "VISAELECTRON",
                "inputElements": [
                  {
                    "name": "number",
                    "tests": [
                      {
                        "value": "4917300800000000",
                        "error": null
                      },
                      {
                        "value": "36699",
                        "error": "INVALID_ACCOUNT_NUMBER"
                      },
                      {
                        "value": "",
                        "error": "MISSING_ACCOUNT_NUMBER"
                      },
                      {
                        "value": null,
                        "error": "MISSING_ACCOUNT_NUMBER"
                      }
                    ]
                  },
                  {
                    "name": "verificationCode",
                    "tests": [
                      {
                        "value": "123",
                        "error": null
                      },
                      {
                        "value": "12a",
                        "error": "INVALID_VERIFICATION_CODE"
                      },
                      {
                        "value": "1234",
                        "error": "INVALID_VERIFICATION_CODE"
                      },
                      {
                        "value": "",
                        "error": "MISSING_VERIFICATION_CODE"
                      },
                      {
                        "value": null,
                        "error": "MISSING_VERIFICATION_CODE"
                      }
                    ]
                  }
                ]
              },
              {
                "method": "DEBIT_CARD",
                "code": "CARTEBANCAIRE",
                "inputElements": [
                  {
                    "name": "number",
                    "tests": [
                      {
                        "value": "4035501000000008",
                        "error": null
                      },
                      {
                        "value": "36699",
                        "error": "INVALID_ACCOUNT_NUMBER"
                      },
                      {
                        "value": "",
                        "error": "MISSING_ACCOUNT_NUMBER"
                      },
                      {
                        "value": null,
                        "error": "MISSING_ACCOUNT_NUMBER"
                      }
                    ]
                  },
                  {
                    "name": "verificationCode",
                    "tests": [
                      {
                        "value": "123456",
                        "error": null
                      },
                      {
                        "value": "123ABC",
                        "error": "INVALID_VERIFICATION_CODE"
                      },
                      {
                        "value": "",
                        "error": null
                      },
                      {
                        "value": null,
                        "error": null
                      }
                    ]
                  }
                ]
              },
              {
                "method": "DEBIT_CARD",
                "code": "MAESTRO",
                "inputElements": [
                  {
                    "name": "number",
                    "tests": [
                      {
                        "value": "6759649826438453",
                        "error": null
                      },
                      {
                        "value": "36699",
                        "error": "INVALID_ACCOUNT_NUMBER"
                      },
                      {
                        "value": "",
                        "error": "MISSING_ACCOUNT_NUMBER"
                      },
                      {
                        "value": null,
                        "error": "MISSING_ACCOUNT_NUMBER"
                      }
                    ]
                  },
                  {
                    "name": "verificationCode",
                    "tests": [
                      {
                        "value": "123456",
                        "error": null
                      },
                      {
                        "value": "123ABC",
                        "error": "INVALID_VERIFICATION_CODE"
                      },
                      {
                        "value": "",
                        "error": null
                      },
                      {
                        "value": null,
                        "error": null
                      }
                    ]
                  }
                ]
              },
              {
                "method": "DEBIT_CARD",
                "code": "MAESTROUK",
                "inputElements": [
                  {
                    "name": "number",
                    "tests": [
                      {
                        "value": "6759649826438453",
                        "error": null
                      },
                      {
                        "value": "36699",
                        "error": "INVALID_ACCOUNT_NUMBER"
                      },
                      {
                        "value": "",
                        "error": "MISSING_ACCOUNT_NUMBER"
                      },
                      {
                        "value": null,
                        "error": "MISSING_ACCOUNT_NUMBER"
                      }
                    ]
                  },
                  {
                    "name": "verificationCode",
                    "tests": [
                      {
                        "value": "123456",
                        "error": null
                      },
                      {
                        "value": "123ABC",
                        "error": "INVALID_VERIFICATION_CODE"
                      },
                      {
                        "value": "",
                        "error": null
                      },
                      {
                        "value": null,
                        "error": null
                      }
                    ]
                  }
                ]
              }
            ]
        """
    }
}

extension MockFactory.Validation {
    struct Network: Decodable {
        let code: String?
        let method: String?
        let inputElements: [InputElement]
    }

    struct InputElement: Decodable {
        let name: String
        let tests: [InputElementTestCase]
    }

    struct InputElementTestCase: Decodable {
        let value: String?
        let error: String?
    }
}
