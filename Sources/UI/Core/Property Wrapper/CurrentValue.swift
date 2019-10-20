import Foundation


/// An object that wraps a single value and publishes a new element whenever the value changes.
@propertyWrapper struct CurrentValue<Output> {
	private let publisher = BasicPublisher()

	var value: Output {
		didSet {
			publisher.handler?(oldValue, wrappedValue)
		}
	}
	
	var wrappedValue: Output {
		get { value }
		set {
			value = newValue
			
		}
	}
	
	/// The property that can be accessed with the `$` syntax and allows access to the `BasicPublisher`
	var projectedValue: BasicPublisher {
		get {
			return publisher
		}
	}
	
	mutating func set(_ newValue: Output) {
        value = newValue
    }
	
	init(wrappedValue: Output) {
		self.value = wrappedValue
	}
	
	// MARK: -
	
	class BasicPublisher {
		typealias SubscriptionHandler = ((_ oldValue: Output, _ newValue: Output) -> Void)
		
		var handler: SubscriptionHandler?
		
		/// Attaches a subscriber with closure-based behavior.
		///
		/// - Note: only one subscriber can be active at the same moment
		///
		/// - parameter receiveValue: The closure to execute on receipt of a value.
		func subscribe(receiveValue: @escaping SubscriptionHandler) {
			handler = receiveValue
		}
	}
}
