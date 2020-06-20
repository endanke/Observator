# Observator

[![Version](https://img.shields.io/cocoapods/v/Observator.svg?style=flat)](https://cocoapods.org/pods/Observator)
[![Platform](https://img.shields.io/cocoapods/p/Observator.svg?style=flat)](https://cocoapods.org/pods/Observator)

Observator is a simple global data sharing mechanism for Swift. A single class dependency that helps you to create generic singleton wrappers around a specific type, with built-in notitifcations. This setup allows you to read and write data in different components of your app asynchronously.

## Example

```swift
// Define your custom observator subclass:
class CityName: Observator<String> {}

// Listen for data modification:
CityName.shared.subscribe(self, selector: #selector(cityNameChanged))

// Update the stored value:
CityName.shared.data = "Helsinki"
```

## Installation

Manual: Just copy `Observator.swift` into your project.

Cocoapods: Observator is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Observator'
```