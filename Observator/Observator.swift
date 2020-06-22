//
//  Observator.swift
//  Observator
//
//  Created by Daniel Eke on 2020. 06. 20..
//

import Foundation

// Need to be stored externally due to the generic type setup
fileprivate var observators: [String: AnyObject] = [:]

open class Observator<T> {

    private static var identifier: String {
        return "\(String(describing: Self.self))\(String(describing: T.self))"
    }

    public static var shared: Self {
        if let singleton = observators[Self.identifier],
            let instance = singleton as? Self {
            return instance
        } else {
            let instance = Self.init()
            observators[Self.identifier] = instance
            return instance
        }
    }

    private var notificationName: Notification.Name {
        return Notification.Name(rawValue: Self.identifier)
    }

    private var queue: DispatchQueue {
        return DispatchQueue(
            label: "observator.\(Self.identifier)",
            qos: .default, attributes: .concurrent
        )
    }

    private var internalData: T?
    public var data: T? {
        get {
            var data: T?
            queue.sync {
                if let internalData = self.internalData {
                    data = self.readTransform(internalData)
                }
            }
            return data
        }
        set {
            queue.async(flags: .barrier) {
                self.internalData = newValue
            }
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
    }

    required public init() {}

    // Will be applied on the getter of the data when it's not nil
    open func readTransform(_ input: T) -> T {
        return input
    }

    public func subscribe(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(
            observer, selector: selector,
            name: notificationName, object: nil
        )
    }

    public func unsubscribe(_ observer: Any) {
        NotificationCenter.default.removeObserver(
            observer, name: notificationName, object: nil
        )
    }

}
