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
public class AsynchronousOperation: Operation {
	public override var isAsynchronous: Bool { return true }
	public override var isExecuting: Bool { return state == .executing }
	public override var isFinished: Bool { return state == .finished }
	
	var state = State.ready {
		willSet {
			willChangeValue(forKey: state.keyPath)
			willChangeValue(forKey: newValue.keyPath)
		}
		didSet {
			didChangeValue(forKey: state.keyPath)
			didChangeValue(forKey: oldValue.keyPath)
		}
	}
	
	enum State: String {
		case ready = "Ready"
		case executing = "Executing"
		case finished = "Finished"
		fileprivate var keyPath: String { return "is" + self.rawValue }
	}
	
	public override func start() {
		if self.isCancelled {
			state = .finished
		} else {
			state = .ready
			main()
		}
	}
	
	public override func main() {
		if self.isCancelled {
			state = .finished
		} else {
			state = .executing
		}
	}
}
