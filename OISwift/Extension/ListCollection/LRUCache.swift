//
//  LRUCache.swift
//  OISwift
//
//  Created by keenoi on 24/01/26.
//

import UIKit

final class LRUCache<Key: Hashable, Value> {
    private let maxSize: Int
    private var dict: [Key: Value] = [:]
    private var order: [Key] = []
    
    init(maxSize: Int) {
        self.maxSize = maxSize
    }
    
    subscript(key: Key) -> Value? {
        get {
            guard let value = dict[key] else { return nil }
            if let idx = order.firstIndex(of: key) { order.remove(at: idx) }
            order.append(key)
            return value
        }
        set {
            if let newValue = newValue {
                dict[key] = newValue
                if let idx = order.firstIndex(of: key) {
                    order.remove(at: idx)
                }
                order.append(key)
                
                if order.count > maxSize {
                    let oldest = order.removeFirst()
                    dict.removeValue(forKey: oldest)
                }
            } else {
                dict.removeValue(forKey: key)
                order.removeAll(where: { $0 == key })
            }
        }
    }
    
    func removeAll() {
        dict.removeAll()
        order.removeAll()
    }
}
