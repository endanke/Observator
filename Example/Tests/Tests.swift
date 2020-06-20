import XCTest
import Observator

// Sample testing classes
struct Customer {
    var name: String
    var age: Int
}

struct Appointment {
    var date: Date
    var customer: Customer
}

// Some observator examples
class CustomersObservator: Observator<[Customer]> {}
class ArrivingCustomers: CustomersObservator {}
class PreviousCustomers: CustomersObservator {}
class NextAppointment: Observator<Appointment> {}
class GlobalAnswer: Observator<Int> {}

class Tests: XCTestCase {
    
   func testExample() {
        let exp = expectation(description: "")
        let receiver = SampleReceiver()
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) {
            ArrivingCustomers.shared.data = [Customer(name: "A", age: 22)]
        }
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1.0) {
            if receiver.dataArrived {
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 2.0)
    }
    
}

// Helper class to test subscriptions
class SampleReceiver {
    
    var dataArrived = false
    
    init() {
        ArrivingCustomers.shared.subscribe(self, selector: #selector(updated))
    }
    
    @objc private func updated() {
        dataArrived = (ArrivingCustomers.shared.data != nil)
    }
    
}
