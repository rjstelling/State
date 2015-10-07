//
//  State.swift
//  SSESwift
//
//  Created by Richard Stelling on 05/10/2015.
//  Copyright © 2015 Naim Audio Ltd. All rights reserved.
//

import Foundation

public protocol StateDelegate : class {
    
    typealias StateType
    
    func shouldTransitionFrom(from:StateType, to:StateType) -> Bool
    func didTransitionFrom(from:StateType, to:StateType)
    func failedTransitionFrom(from:StateType, to:StateType)
}

public class State<P:StateDelegate> {
    
    private unowned let delegate:P
    
    // MARK: Locking

    let lockingQueueName : String = "State.Locking.queue"
    
    let queue : dispatch_queue_t
    
    private func synchronise(f: Void -> Void) {
        dispatch_sync(queue, f)
    }
    
    // MARK: Getting and Setting State
    
    private var _state : P.StateType! {
        
        didSet {
            self.delegate.didTransitionFrom(oldValue, to: self._state)
        }
    }
    
    public var state:P.StateType {
        
        get {
            return _state
        }
        
        set {
            if self.delegate.shouldTransitionFrom(self._state, to: newValue) {
                self.synchronise {
                    self._state = newValue
                }
            }
            else {
                self.synchronise {
                    self.delegate.failedTransitionFrom(self._state, to: newValue)
                }
            }
        }
    }

    // MARK: Init
    
    public init(initialState:P.StateType, delegate:P) {
        
        self.delegate = delegate
        _state = initialState //set the primitive to avoid calling the delegate.
        
        self.queue = dispatch_queue_create(lockingQueueName, nil)
    }
}
