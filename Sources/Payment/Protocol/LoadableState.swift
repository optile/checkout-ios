import Foundation

/// Enumeration that is used for any object that can't be instantly loaded (e.g. fetched from a network)
public enum LoadableState<T> {
	case inactive
	case loading
	case fetched(Result<T, Error>)
}
