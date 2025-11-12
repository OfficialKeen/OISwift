//
//  SBinding.swift
//  OISwift
//
//  Created by keenoi on 17/05/24.
//

/*import UIKit

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
}*/

import UIKit

@propertyWrapper
public class SBinding<Value> {
    private var value: Value
    public var didSet: ((Value) -> Void)?
    
    // Property untuk mendapatkan dan mengubah nilai
    public var wrappedValue: Value {
        get { value }
        set {
            // Periksa apakah value dan newValue adalah array, jika ya, bandingkan panjang array
            if let oldArray = value as? [Any], let newArray = newValue as? [Any], oldArray.count != newArray.count {
                value = newValue
                didSet?(value)
            } else {
                value = newValue
                didSet?(value)
            }
        }
    }
    
    // Property untuk memberikan akses binding kepada objek SBinding
    public var projectedValue: SBinding<Value> { self }
    
    // Inisialisasi dengan nilai awal dan closure didSet opsional
    public init(wrappedValue: Value, didSet: ((Value) -> Void)? = nil) {
        self.value = wrappedValue
        self.didSet = didSet
    }
}
