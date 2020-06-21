# Observator

[![Version](https://img.shields.io/cocoapods/v/Observator.svg?style=flat)](https://cocoapods.org/pods/Observator)
[![Platform](https://img.shields.io/cocoapods/p/Observator.svg?style=flat)](https://cocoapods.org/pods/Observator)

Observator is a simple global data sharing mechanism for Swift. A single class dependency that helps you to create generic singleton wrappers around a specific type, with built-in notitifcations. This setup allows you to read and write data in different components of your app asynchronously.

## Example

Basic usage:

```swift
// Define your custom observator subclass:
class CityName: Observator<String> {}

// Listen for data modification:
CityName.shared.subscribe(self, selector: #selector(cityNameChanged))

// Update the stored value:
CityName.shared.data = "Helsinki"
```

Advanced features:

```swift
// You can override some methods in the observator subclass to automatically transform the stored data
class CityName: Observator<String> {
    override func readTransform(_ input: String) -> String {
        return "\(input) Finland"
    }
}

// Which should return on access: "Helsinki Finland"
CityName.shared.data = "Helsinki"

// It also supports subclasses of a customized observator 
class DepartureCity: CityName {}
class DestinationCity: CityName {}

// Should be: "Tampere Finland"
DepartureCity.shared.data = "Tampere"
// Should be: "Oulu Finland"
DestinationCity.shared.data = "Oulu"

// Observator can be also used to store the data fetching and processing logic of custom types. You can create a generic subclass with the shared data management features and do the fetching in specialized subclasses.
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
```

## Installation

Manual: Just copy `Observator.swift` into your project.

Cocoapods: Observator is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Observator'
```