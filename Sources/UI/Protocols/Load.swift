import Foundation

/// Enumeration that is used for any object that can't be instantly loaded (e.g. fetched from a network)
public enum Load<Success> {
	case loading
	case failure(Error)
	case success(Success)
}

