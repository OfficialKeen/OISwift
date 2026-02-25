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
/*
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
}*/

/*
import Foundation

// =======================================================
// MARK: - Type-Erased Observer Token (Outside Generic Class)
// =======================================================
/// Type-safe token untuk observer removal
/// ✅ Moved outside SBinding untuk avoid generic type conflicts
public struct SBindingObserverToken: Hashable {
    fileprivate let uuid: UUID
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    public static func == (lhs: SBindingObserverToken, rhs: SBindingObserverToken) -> Bool {
        lhs.uuid == rhs.uuid
    }
}

// =======================================================
// MARK: - SBinding: Production-Grade Reactive Property Wrapper
// =======================================================
/// Thread-safe, memory-safe, SwiftUI-like reactive binding
/// with multi-observer support and lifecycle management
@propertyWrapper
public final class SBinding<Value> {
    
    // MARK: - Types
    
    /// Observer configuration
    public struct ObserverConfig {
        let queue: DispatchQueue
        let fireImmediately: Bool
        
        public static var `default`: ObserverConfig {
            ObserverConfig(
                queue: .main,
                fireImmediately: true
            )
        }
        
        public static var background: ObserverConfig {
            ObserverConfig(
                queue: .global(qos: .background),
                fireImmediately: true
            )
        }
        
        public static var immediate: ObserverConfig {
            ObserverConfig(
                queue: .main,
                fireImmediately: true
            )
        }
        
        public static var lazy: ObserverConfig {
            ObserverConfig(
                queue: .main,
                fireImmediately: false
            )
        }
    }
    
    // MARK: - Storage
    
    private let lock = NSRecursiveLock()
    private var _value: Value
    private var _listeners: [UUID: (Value) -> Void] = [:]
    private var _listenerQueues: [UUID: DispatchQueue] = [:]
    
    // Legacy compatibility
    public var didSet: ((Value) -> Void)? {
        didSet {
            if didSet != nil {
                print("⚠️ SBinding.didSet is deprecated. Use observe() instead.")
            }
        }
    }
    
    // MARK: - Wrapped Value
    
    public var wrappedValue: Value {
        get {
            lock.lock()
            defer { lock.unlock() }
            return _value
        }
        set {
            lock.lock()
            let oldValue = _value
            _value = newValue
            let listeners = _listeners
            let queues = _listenerQueues
            let legacyDidSet = didSet
            lock.unlock()
            
            // Notify outside lock to prevent deadlock
            if let legacyDidSet = legacyDidSet {
                DispatchQueue.main.async {
                    legacyDidSet(newValue)
                }
            }
            
            // Notify all observers on their designated queues
            for (uuid, listener) in listeners {
                let queue = queues[uuid] ?? .main
                queue.async {
                    listener(newValue)
                }
            }
        }
    }
    
    public var projectedValue: SBinding<Value> { self }
    
    // MARK: - Initialization
    
    public init(wrappedValue: Value, didSet: ((Value) -> Void)? = nil) {
        self._value = wrappedValue
        self.didSet = didSet
    }
    
    // MARK: - Observer Management
    
    /// Add observer with full control over execution queue and initial firing
    @discardableResult
    public func observe(
        on queue: DispatchQueue = .main,
        fireImmediately: Bool = true,
        _ listener: @escaping (Value) -> Void
    ) -> SBindingObserverToken {
        let token = SBindingObserverToken(uuid: UUID())
        
        lock.lock()
        _listeners[token.uuid] = listener
        _listenerQueues[token.uuid] = queue
        let currentValue = _value
        lock.unlock()
        
        // Fire immediately if requested
        if fireImmediately {
            queue.async {
                listener(currentValue)
            }
        }
        
        return token
    }
    
    /// Overload dengan ObserverConfig
    @discardableResult
    public func observe(
        config: ObserverConfig = .default,
        _ listener: @escaping (Value) -> Void
    ) -> SBindingObserverToken {
        observe(
            on: config.queue,
            fireImmediately: config.fireImmediately,
            listener
        )
    }
    
    /// Remove specific observer
    public func remove(_ token: SBindingObserverToken) {
        lock.lock()
        _listeners.removeValue(forKey: token.uuid)
        _listenerQueues.removeValue(forKey: token.uuid)
        lock.unlock()
    }
    
    /// Remove all observers
    public func removeAllObservers() {
        lock.lock()
        _listeners.removeAll()
        _listenerQueues.removeAll()
        lock.unlock()
    }
    
    /// Get total observer count (useful for debugging)
    public var observerCount: Int {
        lock.lock()
        defer { lock.unlock() }
        return _listeners.count
    }
    
    // MARK: - Advanced Operations
    
    /// Batch update - mencegah multiple notifications
    public func update(_ mutate: (inout Value) -> Void) {
        lock.lock()
        var mutableValue = _value
        mutate(&mutableValue)
        lock.unlock()
        
        wrappedValue = mutableValue
    }
    
    /// Manual trigger notification tanpa ubah value
    public func notifyObservers() {
        lock.lock()
        let currentValue = _value
        let listeners = _listeners
        let queues = _listenerQueues
        lock.unlock()
        
        for (uuid, listener) in listeners {
            let queue = queues[uuid] ?? .main
            queue.async {
                listener(currentValue)
            }
        }
    }
    
    // MARK: - Transformations
    
    /// Map value ke type lain (mirip SwiftUI binding)
    /// ⚠️ IMPORTANT: Simpan reference ke returned binding untuk prevent deallocation
    public func map<T>(_ transform: @escaping (Value) -> T) -> SBinding<T> {
        let mapped = SBinding<T>(wrappedValue: transform(wrappedValue))
        
        // ✅ Create strong reference chain via observer
        let token = observe(on: .global(qos: .userInitiated), fireImmediately: false) { [weak mapped] newValue in
            mapped?.wrappedValue = transform(newValue)
        }
        
        // ✅ Store token and parent reference (type-erased)
        mapped.parentObserverToken = token
        mapped.parentBinding = self
        
        return mapped
    }
    
    // ✅ Internal storage untuk mapped bindings (type-erased)
    private var parentObserverToken: SBindingObserverToken?
    private var parentBinding: Any?
    
    /// Bi-directional map (get + set)
    public func bimap<T>(
        get: @escaping (Value) -> T,
        set: @escaping (T) -> Value
    ) -> SBinding<T> {
        let mapped = SBinding<T>(wrappedValue: get(wrappedValue))
        
        // Parent -> Child
        let token = observe(on: .global(qos: .userInitiated), fireImmediately: false) { [weak mapped] newValue in
            mapped?.wrappedValue = get(newValue)
        }
        
        // Child -> Parent
        mapped.observe(on: .global(qos: .userInitiated), fireImmediately: false) { [weak self] newMappedValue in
            self?.wrappedValue = set(newMappedValue)
        }
        
        // ✅ Store references
        mapped.parentObserverToken = token
        mapped.parentBinding = self
        
        return mapped
    }
    
    // MARK: - Utilities
    
    /// Combine dengan binding lain
    public func combine<T, Result>(
        _ other: SBinding<T>,
        transform: @escaping (Value, T) -> Result
    ) -> SBinding<Result> {
        let combined = SBinding<Result>(
            wrappedValue: transform(wrappedValue, other.wrappedValue)
        )
        
        let token1 = observe(fireImmediately: false) { [weak combined, weak other] newValue in
            guard let combined = combined, let other = other else { return }
            combined.wrappedValue = transform(newValue, other.wrappedValue)
        }
        
        let token2 = other.observe(fireImmediately: false) { [weak combined, weak self] newOtherValue in
            guard let combined = combined, let self = self else { return }
            combined.wrappedValue = transform(self.wrappedValue, newOtherValue)
        }
        
        // ✅ Store both tokens and references (type-erased tuple)
        combined.parentObserverToken = token1
        combined.parentBinding = (self, other, token2)
        
        return combined
    }
    
    // MARK: - Debugging
    
    deinit {
        #if DEBUG
        if observerCount > 0 {
            print("⚠️ SBinding deallocated with \(observerCount) active observers")
        }
        #endif
    }
}

// MARK: - Convenience Extensions

extension SBinding where Value: Equatable {
    /// Only notify observers kalau value bener-bener berubah
    public var wrappedValueDistinct: Value {
        get { wrappedValue }
        set {
            lock.lock()
            let oldValue = _value
            lock.unlock()
            
            guard newValue != oldValue else { return }
            wrappedValue = newValue
        }
    }
}

extension SBinding {
    /// Debounced setter - useful untuk search fields
    public func debounced(interval: TimeInterval) -> (Value) -> Void {
        var workItem: DispatchWorkItem?
        
        return { [weak self] newValue in
            workItem?.cancel()
            
            let item = DispatchWorkItem { [weak self] in
                self?.wrappedValue = newValue
            }
            
            workItem = item
            DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: item)
        }
    }
}

// MARK: - AutoCleanup (Automatic observer removal)

/// Wrapper untuk auto-cleanup observers
public final class ObserverBag {
    // ✅ Now stores non-generic tokens
    private var tokens: Set<SBindingObserverToken> = []
    private let lock = NSLock()
    
    public init() {}
    
    /// Add token to bag untuk auto-cleanup
    public func add(_ token: SBindingObserverToken) {
        lock.lock()
        defer { lock.unlock() }
        tokens.insert(token)
    }
    
    /// Remove all observers
    public func removeAll() {
        lock.lock()
        tokens.removeAll()
        lock.unlock()
    }
    
    deinit {
        removeAll()
    }
}

extension SBindingObserverToken {
    /// Store token di bag untuk auto-cleanup
    public func store(in bag: ObserverBag) {
        bag.add(self)
    }
}
*/



import UIKit

@propertyWrapper
public class SBinding<Value> {
    private var value: Value
    
    // Support multiple observers
    private var observers: [(Value) -> Void] = []
    
    // Backward compatibility - didSet masih bisa dipake
    public var didSet: ((Value) -> Void)? {
        didSet {
            if let callback = didSet {
                observers.append(callback)
            }
        }
    }
    
    public var wrappedValue: Value {
        get { value }
        set {
            let oldValue = value
            value = newValue
            
            // Notify semua observers
            observers.forEach { $0(newValue) }
            
            // Optional: trigger onChange dengan old & new value
            onChangeCallback?(oldValue, newValue)
        }
    }
    
    public var projectedValue: SBinding<Value> { self }
    
    // Callback tambahan buat dapetin old & new value
    private var onChangeCallback: ((Value, Value) -> Void)?
    
    // MARK: - Initializers
    
    public init(wrappedValue: Value, didSet: ((Value) -> Void)? = nil) {
        self.value = wrappedValue
        if let callback = didSet {
            self.observers.append(callback)
        }
    }
    
    // MARK: - Public Methods
    
    /// Subscribe ke perubahan value
    public func observe(_ callback: @escaping (Value) -> Void) {
        observers.append(callback)
    }
    
    /// Subscribe dengan old & new value
    public func onChange(_ callback: @escaping (Value, Value) -> Void) {
        self.onChangeCallback = callback
    }
    
    /// Hapus semua observers
    public func removeAllObservers() {
        observers.removeAll()
        onChangeCallback = nil
    }
    
    /// Update value tanpa trigger observers (silent update)
    public func setSilently(_ newValue: Value) {
        value = newValue
    }
    
    /// Force trigger observers tanpa ubah value
    public func notifyObservers() {
        observers.forEach { $0(value) }
    }
}

// MARK: - Equatable Extension

extension SBinding where Value: Equatable {
    /// Update value cuma kalo beda (optimized)
    public func setIfChanged(_ newValue: Value) {
        guard value != newValue else { return }
        wrappedValue = newValue
    }
}
