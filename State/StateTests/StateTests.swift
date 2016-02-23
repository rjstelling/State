//
//  StateTests.swift
//  StateTests
//
//  Created by Richard Stelling on 06/10/2015.
//  Copyright © 2015 Naim Audio Ltd. All rights reserved.
//

import XCTest
@testable import State

class StateTests: XCTestCase {
    
    class Mock : StateDelegate {
        
        enum TestState {
            
            case Zero
            case One
            case Two
            case Three
            case Four
            case Five
            case Six
            case Seven
            case A
            case B
            case C
            case D
        }
        
        typealias StateType = TestState
        
        func shouldTransitionFrom(from:StateType, to:StateType) -> Bool {
            
            switch(from, to) {
                
            case(.Zero, .One),
                (.One, .Two),
                (.Two, .Three),
                (.Three, .Four),
                (.Four, .Five), (.Four, .A),
                (.Five, .Six),
                (.Six, .Seven),
                (.Seven, .One):
                return true
                
            case(.A, .B), (.A, .C),
                (.B, .C),
                (.C, .D),
                (.D, .Zero):
                return true
            
            default:
                return false
            }
            
        }
        
        func didTransitionFrom(from:StateType, to:StateType) {
            
        }
        
        func failedTransitionFrom(from:StateType, to:StateType) {
            
        }

    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStateMachineNumbersLoop() {

        let mock = Mock()
        let stateMachine = State<Mock>(initialState: Mock.TestState.Zero, delegate: mock)
        
        XCTAssertEqual(stateMachine.state, Mock.TestState.Zero, "State machine is not at Zero")
        
        for step in 0...10 {
            for state in [Mock.TestState.One, Mock.TestState.Two, Mock.TestState.Three, Mock.TestState.Four, Mock.TestState.Five, Mock.TestState.Six, Mock.TestState.Seven] {
                stateMachine.state = state
            }
            print("Loop #\(step)")
            XCTAssertEqual(stateMachine.state, Mock.TestState.Seven, "State machine is not at Seven: \(stateMachine.state)")
            
            stateMachine.state = Mock.TestState.One
            XCTAssertEqual(stateMachine.state, Mock.TestState.One, "State machine is not at One: \(stateMachine.state)")
        }
    }
    
    func testStateMachineLettersLoop() {
        
        let mockDelegate = Mock()
        let stateMachineLettersLoop = State<Mock>(initialState: Mock.TestState.Zero, delegate: mockDelegate)
        XCTAssertEqual(stateMachineLettersLoop.state, Mock.TestState.Zero, "State machine is not at Zero")
        
        stateMachineLettersLoop.state = Mock.TestState.One
        XCTAssertEqual(stateMachineLettersLoop.state, Mock.TestState.One, "State machine is not at One: \(stateMachineLettersLoop.state)")
        
        for step in 0...10 {
        
        XCTAssertEqual(stateMachineLettersLoop.state, Mock.TestState.One, "State machine is not at One: \(stateMachineLettersLoop.state)")
        
        for state in [Mock.TestState.Two, Mock.TestState.Three, Mock.TestState.Four, Mock.TestState.A, Mock.TestState.B, Mock.TestState.C, Mock.TestState.D] {
        stateMachineLettersLoop.state = state
        }
        print("Loop #\(step)")
        XCTAssertEqual(stateMachineLettersLoop.state, Mock.TestState.D, "State machine is not at D: \(stateMachineLettersLoop.state)")
        
        stateMachineLettersLoop.state = Mock.TestState.Zero
        XCTAssertEqual(stateMachineLettersLoop.state, Mock.TestState.Zero, "State machine is not at Zero: \(stateMachineLettersLoop.state)")
        
        stateMachineLettersLoop.state = Mock.TestState.One
        XCTAssertEqual(stateMachineLettersLoop.state, Mock.TestState.One, "State machine is not at One: \(stateMachineLettersLoop.state)")
        }
    }
    
    func testStateMachineFullLoop() {
        
        let mockDelegate = Mock()
        let stateMachineLettersLoop = State<Mock>(initialState: Mock.TestState.Zero, delegate: mockDelegate)
        XCTAssertEqual(stateMachineLettersLoop.state, Mock.TestState.Zero, "State machine is not at Zero")
        
        stateMachineLettersLoop.state = Mock.TestState.One
        XCTAssertEqual(stateMachineLettersLoop.state, Mock.TestState.One, "State machine is not at One: \(stateMachineLettersLoop.state)")
        
        for step in 0...10 {
            
            XCTAssertEqual(stateMachineLettersLoop.state, Mock.TestState.One, "State machine is not at One: \(stateMachineLettersLoop.state)")
            
            for state in [Mock.TestState.Two, Mock.TestState.Three, Mock.TestState.Four, Mock.TestState.A, Mock.TestState.B, Mock.TestState.C, Mock.TestState.D, Mock.TestState.Zero, Mock.TestState.One, Mock.TestState.Two, Mock.TestState.Three, Mock.TestState.Four, Mock.TestState.Five, Mock.TestState.Six, Mock.TestState.Seven] {
                stateMachineLettersLoop.state = state
            
                XCTAssertEqual(stateMachineLettersLoop.state, state, "State machine is not at \(state): \(stateMachineLettersLoop.state)")
            }
            print("Loop #\(step)")
            XCTAssertEqual(stateMachineLettersLoop.state, Mock.TestState.Seven, "State machine is not at Severn: \(stateMachineLettersLoop.state)")
            
            stateMachineLettersLoop.state = Mock.TestState.One
            XCTAssertEqual(stateMachineLettersLoop.state, Mock.TestState.One, "State machine is not at One: \(stateMachineLettersLoop.state)")
        }
    }
    
    func testPerformanceSpawn() {
        
        self.measureBlock {
            for _ in 0...100000 {
                
                let mockObj = Mock()
                let sm = State<Mock>(initialState: .Zero, delegate: mockObj)
                
                _ = sm.lockingQueueName
            }
        }
    }
    
    func testPerformanceFullLoop() {
        
        self.measureBlock {
            
            let mockDelegate = Mock()
            let stateMachineLettersLoop = State<Mock>(initialState: Mock.TestState.Zero, delegate: mockDelegate)
            XCTAssertEqual(stateMachineLettersLoop.state, Mock.TestState.Zero, "State machine is not at Zero")
            
            stateMachineLettersLoop.state = Mock.TestState.One
            XCTAssertEqual(stateMachineLettersLoop.state, Mock.TestState.One, "State machine is not at One: \(stateMachineLettersLoop.state)")
                
            XCTAssertEqual(stateMachineLettersLoop.state, Mock.TestState.One, "State machine is not at One: \(stateMachineLettersLoop.state)")
            
            for _ in 0...1000 {
                for state in [Mock.TestState.Two, Mock.TestState.Three, Mock.TestState.Four, Mock.TestState.A, Mock.TestState.B, Mock.TestState.C, Mock.TestState.D, Mock.TestState.Zero, Mock.TestState.One, Mock.TestState.Two, Mock.TestState.Three, Mock.TestState.Four, Mock.TestState.Five, Mock.TestState.Six, Mock.TestState.Seven, Mock.TestState.One, Mock.TestState.Two, Mock.TestState.Three, Mock.TestState.Four, Mock.TestState.A, Mock.TestState.C, Mock.TestState.D, Mock.TestState.Zero, Mock.TestState.One, Mock.TestState.Two, Mock.TestState.Three, Mock.TestState.Four, Mock.TestState.Five, Mock.TestState.Six, Mock.TestState.Seven] {
                        stateMachineLettersLoop.state = state
                        
                        XCTAssertEqual(stateMachineLettersLoop.state, state, "State machine is not at \(state): \(stateMachineLettersLoop.state)")
                }
                
                XCTAssertEqual(stateMachineLettersLoop.state, Mock.TestState.Seven, "State machine is not at Severn: \(stateMachineLettersLoop.state)")
                    
                stateMachineLettersLoop.state = Mock.TestState.One
                XCTAssertEqual(stateMachineLettersLoop.state, Mock.TestState.One, "State machine is not at One: \(stateMachineLettersLoop.state)")
            }
        }
    }
    
    func testVersionString() {
        
        let version = State<Mock>.version
        
        XCTAssertTrue(version.characters.count > 1, "Version string is invalid")
    }
}