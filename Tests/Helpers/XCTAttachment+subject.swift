import XCTest

extension XCTAttachment {
	convenience init<T>(subject: T) {
		var text = String()
		dump(subject, to: &text)
		self.init(string: text)
	}
}
