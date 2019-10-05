import Foundation
import Network

@propertyWrapper
public struct CurrentValue<Output> {
	private let publisher = BasicPublisher()

	public var value: Output {
		didSet {
			publisher.handler?(wrappedValue)
		}
	}
	
	public var wrappedValue: Output {
		get { value }
		set {
			value = newValue
			
		}
	}
	
	/// The property that can be accessed with the `$` syntax and allows access to the `BasicPublisher`
	public var projectedValue: BasicPublisher {
		get {
			return publisher
		}
	}
	
    public mutating func set(_ newValue: Output) {
        value = newValue
    }
	
	public init(wrappedValue: Output) {
		self.value = wrappedValue
	}
	
	// MARK: - Type definitions
	
	public class BasicPublisher {
		fileprivate var handler: ((Output) -> Void)?
		
		/// Attaches a subscriber with closure-based behavior.
		///
		/// - Note: only one subscriber can be active at the same moment
		///
		/// - parameter receiveValue: The closure to execute on receipt of a value.
		public func subscribe(receiveValue: @escaping ((Output) -> Void)) {
			handler = receiveValue
		}
	}
}
