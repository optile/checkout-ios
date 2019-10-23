import Foundation

protocol MockDataSource {
	var fakeData: Result<Data?, Error> { get }
}

extension String: MockDataSource {
	var fakeData: Result<Data?, Error> {
		return .success(self.data(using: .isoLatin1)!)
	}
}

extension Data: MockDataSource {
	var fakeData: Result<Data?, Error> {
		return .success(self)
	}
}

extension TestError: MockDataSource {
	var fakeData: Result<Data?, Error> {
		return .failure(self)
	}
}
