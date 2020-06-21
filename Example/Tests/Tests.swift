import XCTest
import Observator

// Sample testing classes
struct Customer: Codable {
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

// Transform test
class CityName: Observator<String> {
    override func readTransform(_ input: String) -> String {
        return "\(input) Finland"
    }
}

// Inheritance test
class DepartureCity: CityName {}
class DestinationCity: CityName {}

class APIObservator<T>: Observator<T> {
    let session = URLSession(configuration: .default)
    let baseURL = URL(string: "...")!
}
class CustomerList: APIObservator<[Customer]> {
    func fetchCustomers() {
        session.dataTask(with: baseURL) { (data, _, _) in
            if let data = data {
                self.data = try? JSONDecoder().decode([Customer].self, from: data)
            }
        }
    }
}

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
    
    func testReadTransform() {
        CityName.shared.data = "Helsinki"
        XCTAssertEqual(CityName.shared.data, "Helsinki Finland")
    }
    
    func testInheritance() {
        DepartureCity.shared.data = "Tampere"
        DestinationCity.shared.data = "Oulu"
        XCTAssertEqual(DepartureCity.shared.data, "Tampere Finland")
        XCTAssertEqual(DestinationCity.shared.data, "Oulu Finland")
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
