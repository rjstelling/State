/*: **State Tests** - this is a quike overview of how to use State.
State is a very simple FSM. It vends a very simple delegate that can be used to observe the state cahnge.*/
import XCPlayground
import State

//Page set up
let page = XCPlaygroundPage.currentPage

//Frist, create an object that will implement the State delegate functions.
class ElectricCar : StateDelegate {
//: **Finite States Enum**
    enum CarState {
        case Parked
        case Driving
        case Charging
        case BrokenDown
    }
    
    typealias StateType = CarState
    
    //MARK: StateDelegate functions
//:Simple switch/case statements can be used to define the logic of the state machine.
    func shouldTransitionFrom(from:StateType, to:StateType) -> Bool {

        switch (from, to) {
            
        case(.Parked, .Driving),
            (.Parked, .Charging):
            return true
            
        case(.Driving, .Parked),
            (.Driving, .BrokenDown):
            return true
            
        case(.Charging, .Parked):
            return true
            
        case(.BrokenDown, .Parked):
            return true
            
        // For anything not explicity listed above re return false and do not change the state
        default:
            return false
            
        }
        
    }
    
    func didTransitionFrom(from:StateType, to:StateType) {
        page.captureValue(to, withIdentifier: "Succssful State Change")
        page.captureValue(to, withIdentifier: "State")
    }
    
    func failedTransitionFrom(from:StateType, to:StateType) {
        page.captureValue(to, withIdentifier: "Failed State Change")
        page.captureValue(from, withIdentifier: "State")
    }
}

//: Next, we create a `State` object passing in the `ElecticCar` object as a type and delegate
let car = ElectricCar()
let stateMachine = State<ElectricCar>(initialState: .Parked, delegate: car)

//: Simple tests to show successful state changes and failed state changes

stateMachine.state = .Driving //This should work
stateMachine.state = .BrokenDown
stateMachine.state = .Parked
stateMachine.state = .Charging
stateMachine.state = .BrokenDown //This should not work
stateMachine.state = .Parked
stateMachine.state = .Driving
stateMachine.state = .BrokenDown
stateMachine.state = .Charging


//: Tests — this is a simple test to make sure State meets all our assumptions, it si not a replacement for formal unit tests
assert(stateMachine.state == .BrokenDown, "State did not change as expected!")



