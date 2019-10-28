import Foundation

protocol MockDataSource {
	func fakeData(for request: URLRequest) -> Result<Data?, Error>
}

extension String: MockDataSource {
	func fakeData(for request: URLRequest) -> Result<Data?, Error> {
		return .success(self.data(using: .isoLatin1)!)
	}
}

extension Data: MockDataSource {
	func fakeData(for request: URLRequest) -> Result<Data?, Error> {
		return .success(self)
	}
}

extension TestError: MockDataSource {
	func fakeData(for request: URLRequest) -> Result<Data?, Error> {
		return .failure(self)
	}
}
