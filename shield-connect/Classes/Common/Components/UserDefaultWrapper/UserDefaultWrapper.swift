//
//  UserDefaultWrapper.swift
//  shield-connect
//
//  Created by Александр on 11.04.2025.
//

import Foundation

/// - Parameters:
///   - key: Data will be saved and extracted using this key
///   - defaultValue: This value will be substituted when there is no value
///   - userDefaults: NSUserDefaults is a hierarchical persistent interprocess (optionally distributed) key-value store, optimized for storing user settings.
///
/// Types an UserDefaultsWrapper can work with:
///```
///  URL?
///  [Any]?
///  [String : Any]?
///  String?
///  [String]?
///  Data?
///  Bool
///  Int
///  Float
///  Double
/// ```
///
/// - Warning:
///  If the type is not optional, default == nil will cause a crash.
///
/// Exemple:
/// ```
/// class User {
///
///    @UserDefaultsWrapper<String>(key: "FirstName", default: "John") var firstName
///    @UserDefaultsWrapper(key: "LastName", default: "John") var lastName: String
///
///    // OR
///
///    @UserDefaultsWrapper(key: "Age") var age: Int?
///    @UserDefaultsWrapper(key: "Old", default: 6) var old: Int?
/// }
///
/// let user = User()
/// print(user.firstName) // John
/// user.firstName = "Misha"
/// print(user.firstName) // Misha
/// $user.firstName.removeObject()
///
/// print(user.old) // optional(6)
/// user.old = 18
/// print(user.old) // optional(18)
/// user.old = nil
/// print(user.old) // optional(6)
///
/// print(user.age) // nil
/// user.age = 18
/// print(user.age) // optional(18)
/// user.age = nil
/// print(user.age) // nil
/// ```
@propertyWrapper
public struct UserDefaultsWrapper<T> {
    private let key: String
    private let defaultValue: T!
    private let userDefaults: UserDefaults

    public var wrappedValue: T {
        get {
            let anyValue = userDefaults.value(forKey: key)
            let value: T = (anyValue as? T) ?? defaultValue
            return value
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                userDefaults.removeObject(forKey: key)

                if let defaultValue = defaultValue {
                    self.set(newValue: defaultValue)
                }
            } else {
                self.set(newValue: newValue)
            }
            userDefaults.synchronize()
        }
    }

    public var projectedValue: ActionUserDefault { self }

    /// - Parameters:
    ///   - key: Data will be saved and extracted using this key
    ///   - defaultValue: This value will be substituted when there is no value
    ///   - userDefaults: NSUserDefaults is a hierarchical persistent interprocess (optionally distributed) key-value store, optimized for storing user settings.
    ///
    /// - Warning:
    ///  If the type is not optional, default == nil will cause a crash.
    public init(key: String, default defaultValue: T? = nil, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.userDefaults = userDefaults
        self.defaultValue = defaultValue
    }

    private func set(newValue: T) {
        userDefaults.setValue(newValue, forKey: key)
    }
}

// MARK: - ActionUserDefault

extension UserDefaultsWrapper: ActionUserDefault {

    public func removeObject() {
        userDefaults.removeObject(forKey: key)

        if let defaultValue = defaultValue {
            self.set(newValue: defaultValue)
        }
    }
}

// MARK: - Helper classes

private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}

public protocol ActionUserDefault {
    func removeObject()
}
