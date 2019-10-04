import Foundation
import Network

public class ObservableObject<T> {
	private var didChangeHandler: ((T) -> Void)?

	public var value: T {
		didSet {
			didChangeHandler?(value)
		}
	}
	public func didChange(handler: @escaping ((T) -> Void)) {
		self.didChangeHandler = handler
	}
	
	public init(_ value: T) {
		self.value = value
	}
}
