//
//  Toggle.swift
//  OISwift
//
//  Created by keenoi on 18/05/24.
//

import UIKit

public class Toggle: UISwitch {
    @discardableResult
    func frame(x: CGFloat, y: CGFloat) -> Self {
        self.transform = CGAffineTransform(scaleX: x, y: y)
        return self
    }
    
    @discardableResult
    func isOn(_ isOn: Bool) -> Self {
        self.isOn = isOn
        return self
    }
    
    @discardableResult
    func onTintColor(_ color: UIColor) -> Self {
        self.onTintColor = color
        return self
    }
    
    @discardableResult
    func thumbTintColor(_ color: UIColor) -> Self {
        self.thumbTintColor = color
        return self
    }
    
    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
    
    @discardableResult
    func onTintColor(_ hex: Int) -> Self {
        let color = UIColor(hex: UInt32(hex))
        self.onTintColor = color
        return self
    }
    
    @discardableResult
    func thumbTintColor(_ hex: Int) -> Self {
        let color = UIColor(hex: UInt32(hex))
        self.thumbTintColor = color
        return self
    }
    
    @discardableResult
    func tintColor(_ hex: Int) -> Self {
        let color = UIColor(hex: UInt32(hex))
        self.tintColor = color
        return self
    }
    
    @discardableResult
    func onImage(_ image: UIImage?) -> Self {
        self.onImage = image
        return self
    }
    
    @discardableResult
    func offImage(_ image: UIImage?) -> Self {
        self.offImage = image
        return self
    }
    
    @discardableResult
    func isEnabled(_ isEnabled: Bool) -> Self {
        self.isEnabled = isEnabled
        return self
    }
    
    @discardableResult
    func isHidden(_ bool: Bool = true) -> Self {
        self.isHidden = bool
        return self
    }
    
    @discardableResult
    func isHidden(_ state: SBinding<Bool>) -> Self {
        self.isHidden = state.wrappedValue
        state.didSet = { [weak self] newValue in
            self?.isHidden = newValue
        }
        return self
    }
    
    @discardableResult
    func onChange(_ handler: @escaping (UISwitch) -> Void) -> Self {
        self.addTarget(self, action: #selector(handleValueChanged(_:)), for: .valueChanged)
        self.valueChangedHandler = handler
        return self
    }
    
    private struct AssociatedKeys {
        static var valueChangedHandler: UInt8 = 0
    }
    
    private var valueChangedHandler: ((UISwitch) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.valueChangedHandler) as? (UISwitch) -> Void
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.valueChangedHandler, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc private func handleValueChanged(_ sender: UISwitch) {
        valueChangedHandler?(sender)
    }
}

extension Toggle {
    // Method untuk mengatur isOn dengan @UIState
    func isOn(_ isOn: SBinding<Bool>) -> Self {
        self.isOn = isOn.wrappedValue
        isOn.didSet = { [weak self] newValue in
            self?.isOn = newValue
        }
        return self
    }
    
    @discardableResult
    func onTintColor(_ color: SBinding<UIColor>) -> Self {
        color.didSet = { [weak self] newColor in
            self?.onTintColor = newColor
        }
        color.didSet?(color.wrappedValue)
        return self
    }
    
    @discardableResult
    func onTintColor(_ hex: SBinding<Int>) -> Self {
        hex.didSet = { [weak self] newHex in
            let color = UIColor(hex: UInt32(newHex))
            self?.onTintColor = color
        }
        hex.didSet?(hex.wrappedValue)
        return self
    }
    
    @discardableResult
    func isEnabled(_ isEnabled: SBinding<Bool>) -> Self {
        isEnabled.didSet = { [weak self] newIsEnabled in
            self?.isEnabled = newIsEnabled
        }
        isEnabled.didSet?(isEnabled.wrappedValue)
        return self
    }
}

extension Toggle {
    // Method untuk menambahkan closure valueChange
    func onChange(_ handler: @escaping (Bool) -> Void) -> Self {
        addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
        valueChangedHandlers = handler
        return self
    }
    
    @objc private func valueChanged(_ sender: UISwitch) {
        valueChangedHandlers?(sender.isOn)
    }
    
    private var valueChangedHandlers: ((Bool) -> Void)? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.valueChangedHandler) as? (Bool) -> Void }
        set { objc_setAssociatedObject(self, &AssociatedKeys.valueChangedHandler, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

