//
//  SBinding.swift
//  OISwift
//
//  Created by keenoi on 17/05/24.
//

import UIKit

@propertyWrapper
public class SBinding<Value> {
    private var value: Value
    public var didSet: ((Value) -> Void)?
    
    public var wrappedValue: Value {
        get { value }
        set {
            value = newValue
            didSet?(value)
        }
    }
    
    public var projectedValue: SBinding<Value> { self }
    
    public init(wrappedValue: Value, didSet: ((Value) -> Void)? = nil) {
        self.value = wrappedValue
        self.didSet = didSet
    }
}

