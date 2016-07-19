//
//  State.swift
//  State
//
//  Created by Richard Stelling on 05/10/2015.
//  Copyright © 2015 Naim Audio Ltd. All rights reserved.
//

import Foundation

public protocol StateDelegate : class {
    
#if swift(>=2.2)
    associatedtype StateType
#else
    typealias StateType
#endif
    
    func shouldTransitionFrom(from:StateType, to:StateType) -> Bool
    func didTransitionFrom(from:StateType, to:StateType)
    func failedTransitionFrom(from:StateType, to:StateType)
}

@available(iOS 9, OSX 10.11, *)
public class State<P:StateDelegate> {
    
    private unowned let delegate:P
    
    // MARK: Locking

    let lockingQueueName : String = "State.Locking.Queue"
    
    let queue : dispatch_queue_t
    
    private func synchronise(f: Void -> Void) {
        dispatch_sync(queue, f)
    }
    
    // MARK: Getting and Setting State
    
    private var _state : P.StateType! {
        
        didSet {
            dispatch_sync(dispatch_get_main_queue()) {
                self.delegate.didTransitionFrom(oldValue, to: self._state)
            }
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
                dispatch_sync(dispatch_get_main_queue()) {
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

extension State {
    
    //MARK: Versions
    public class var version : String {
        get {
            return "v\(StateVersionNumber)"
        }
    }
}
