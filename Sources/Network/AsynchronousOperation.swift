//
//  AsynchronousOperation.swift
//
//  Created by Vasily Ulianov on 09.02.17.
//  Copyright © 2017 Vasily Ulianov. All rights reserved.
//

import Foundation

/// Subclass of `Operation` that add support of asynchronous operations.
/// ## How to use:
/// 1. Call `super.main()` when override `main` method, call `super.start()` when override `start` method.
/// 2. When operation is finished or cancelled set `self.state = .finished`
///
/// - ToDo: check threading issues mentioned [here](https://gist.github.com/Sorix/57bc3295dc001434fe08acbb053ed2bc).
//public class AsynchronousOperation: Operation {
//	public override var isAsynchronous: Bool { return true }
//	public override var isExecuting: Bool { return state == .executing }
//	public override var isFinished: Bool { return state == .finished }
//	
//	var state = State.ready {
//		willSet {
//			willChangeValue(forKey: state.keyPath)
//			willChangeValue(forKey: newValue.keyPath)
//		}
//		didSet {
//			didChangeValue(forKey: state.keyPath)
//			didChangeValue(forKey: oldValue.keyPath)
//		}
//	}
//	
//	enum State: String {
//		case ready = "Ready"
//		case executing = "Executing"
//		case finished = "Finished"
//		fileprivate var keyPath: String { return "is" + self.rawValue }
//	}
//	
//	public override func start() {
//		if self.isCancelled {
//			state = .finished
//		} else {
//			state = .ready
//			main()
//		}
//	}
//	
//	public override func main() {
//		if self.isCancelled {
//			state = .finished
//		} else {
//			state = .executing
//		}
//	}
//}

open class AsynchronousOperation: Operation {

    /// State for this operation.

    @objc private enum OperationState: Int {
        case ready
        case executing
        case finished
    }

    /// Concurrent queue for synchronizing access to `state`.

    private let stateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".rw.state", attributes: .concurrent)

    /// Private backing stored property for `state`.

    private var _state: OperationState = .ready

    /// The state of the operation

    @objc private dynamic var state: OperationState {
        get { return stateQueue.sync { _state } }
        set { stateQueue.async(flags: .barrier) { self._state = newValue } }
    }

    // MARK: - Various `Operation` properties

    open         override var isReady:        Bool { return state == .ready && super.isReady }
    public final override var isExecuting:    Bool { return state == .executing }
    public final override var isFinished:     Bool { return state == .finished }
    public final override var isAsynchronous: Bool { return true }

    // KVN for dependent properties

    open override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        if ["isReady", "isFinished", "isExecuting"].contains(key) {
            return [#keyPath(state)]
        }

        return super.keyPathsForValuesAffectingValue(forKey: key)
    }

    // Start

    public final override func start() {
        if isCancelled {
            state = .finished
            return
        }

        state = .executing

        main()
    }

    /// Subclasses must implement this to perform their work and they must not call `super`. The default implementation of this function throws an exception.

    open override func main() {
        fatalError("Subclasses must implement `main`.")
    }

    /// Call this function to finish an operation that is currently executing

    public final func finish() {
        if !isFinished { state = .finished }
    }
}
