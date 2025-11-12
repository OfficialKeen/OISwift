//
//  LoaderView.swift
//  OISwift
//
//  Created by keenoi on 15/07/24.
//

import UIKit

public class LoaderView: UIActivityIndicatorView {

    // Inisialisasi dengan chaining method
    @discardableResult
    public func setStyle(_ style: UIActivityIndicatorView.Style) -> LoaderView {
        self.style = style
        return self
    }

    @discardableResult
    public func setColor(_ color: UIColor) -> LoaderView {
        self.color = color
        return self
    }
    
    @discardableResult
    public func setColor(_ hex: UInt) -> Self {
        let color = UIColor(hex: UInt32(hex))
        self.color = color
        return self
    }
    
    @discardableResult
    public func setColor(_ state: SBinding<UIColor?>) -> Self {
        self.color = state.wrappedValue
        state.didSet = { [weak self] newText in
            self?.color = newText
        }
        return self
    }
    
    @discardableResult
    public func setColor(_ state: SBinding<UIColor>) -> Self {
        self.color = state.wrappedValue
        state.didSet = { [weak self] newText in
            self?.color = newText
        }
        return self
    }
    
    @discardableResult
    public func setColor(_ hex: SBinding<UInt>) -> Self {
        hex.didSet = { [weak self] newHex in
            let color = UIColor(hex: UInt32(newHex))
            self?.color = color
        }
        hex.didSet?(hex.wrappedValue)
        return self
    }
    
    @discardableResult
    public func setColor(_ hex: SBinding<UInt?>) -> Self {
        hex.didSet = { [weak self] newHex in
            guard let hexValue = newHex else { return }
            let color = UIColor(hex: UInt32(hexValue))
            self?.color = color
        }
        hex.didSet?(hex.wrappedValue)
        return self
    }

    @discardableResult
    public func setHidesWhenStopped(_ hidesWhenStopped: Bool) -> LoaderView {
        self.hidesWhenStopped = hidesWhenStopped
        return self
    }
    
    @discardableResult
    public func startAnimatingAndReturn() -> LoaderView {
        self.startAnimating()
        return self
    }

    @discardableResult
    public func stopAnimatingAndReturn() -> LoaderView {
        self.stopAnimating()
        return self
    }
    
    // Metode untuk memulai animasi dengan closure chaining
    @discardableResult
    public func startLoader(_ closure: (LoaderView) -> Void) -> LoaderView {
        closure(self)
        return self
    }
    
    // Metode untuk menghentikan animasi dengan closure chaining
    @discardableResult
    public func endLoader(_ closure: (LoaderView) -> Void) -> LoaderView {
        closure(self)
        return self
    }
}
