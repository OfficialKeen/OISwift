//
//  Padding.swift
//  OISwift
//
//  Created by keenoi on 17/05/24.
//

import UIKit

public enum Edge {
    case top, leading, trailing, bottom, vertical, horizontal, all
}

// MARK: UIStackView
extension UIStackView {
    @discardableResult
    public func padding(_ length: CGFloat = 8.0) -> UIStackView {
        let pads: [Edge] = [.all]
        for padding in pads {
            switch padding {
            case .top:
                self.layoutMargins.top = length
            case .leading:
                self.layoutMargins.left = length
            case .trailing:
                self.layoutMargins.right = length
            case .bottom:
                self.layoutMargins.bottom = length
            case .vertical:
                self.layoutMargins.top = length
                self.layoutMargins.bottom = length
            case .horizontal:
                self.layoutMargins.left = length
                self.layoutMargins.right = length
            case .all:
                self.layoutMargins = UIEdgeInsets(top: length, left: length, bottom: length, right: length)
            }
        }
        
        self.isLayoutMarginsRelativeArrangement = true
        return self
    }
    
    @discardableResult
    public func padding(_ edges: Edge, _ length: CGFloat = 8.0) -> UIStackView {
        switch edges {
        case .top:
            self.layoutMargins.top = length
        case .leading:
            self.layoutMargins.left = length
        case .trailing:
            self.layoutMargins.right = length
        case .bottom:
            self.layoutMargins.bottom = length
        case .vertical:
            self.layoutMargins.top = length
            self.layoutMargins.bottom = length
        case .horizontal:
            self.layoutMargins.left = length
            self.layoutMargins.right = length
        case .all:
            self.layoutMargins = UIEdgeInsets(top: length, left: length, bottom: length, right: length)
        }
        
        self.isLayoutMarginsRelativeArrangement = true
        return self
    }
    
    @discardableResult
    public func padding(_ edges: [Edge] = [.all], _ length: CGFloat = 8.0) -> UIStackView {
        for padding in edges {
            switch padding {
            case .top:
                self.layoutMargins.top = length
            case .leading:
                self.layoutMargins.left = length
            case .trailing:
                self.layoutMargins.right = length
            case .bottom:
                self.layoutMargins.bottom = length
            case .vertical:
                self.layoutMargins.top = length
                self.layoutMargins.bottom = length
            case .horizontal:
                self.layoutMargins.left = length
                self.layoutMargins.right = length
            case .all:
                self.layoutMargins = UIEdgeInsets(top: length, left: length, bottom: length, right: length)
            }
        }
        
        self.isLayoutMarginsRelativeArrangement = true
        return self
    }
    
    @discardableResult
    public func background(_ color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
    
    @discardableResult
    public func isHidden(_ bool: Bool = true) -> Self {
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
    public func background(_ hex: UInt) -> Self {
        let color = UIColor(hex: UInt32(hex))
        return background(color)
    }
    
    @discardableResult
    func width(_ width: CGFloat) -> Self {
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }
    
    @discardableResult
    func height(_ height: CGFloat) -> Self {
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult
    func cornerRadius(_ radius: CGFloat? = nil) -> Self {
        self.layer.cornerRadius = radius ?? 0
        self.layer.masksToBounds = true
        return self
    }
    
    @discardableResult
    func cornerRadius(_ corner: UIRectCorner, _ radius: CGFloat) -> Self {
        layer.maskedCorners = []
        
        if corner.contains(.topLeft) {
            layer.maskedCorners.insert(.layerMinXMinYCorner)
        }
        
        if corner.contains(.bottomLeft) {
            layer.maskedCorners.insert(.layerMinXMaxYCorner)
        }
        
        if corner.contains(.topRight) {
            layer.maskedCorners.insert(.layerMaxXMinYCorner)
        }
        
        if corner.contains(.bottomRight) {
            layer.maskedCorners.insert(.layerMaxXMaxYCorner)
        }
        
        layer.cornerRadius = radius
        layer.masksToBounds = true
        
        return self
    }
    
    @discardableResult
    func shadow(color: UIColor, opacity: Float, radius: CGFloat, offset: CGSize) -> Self {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
        return self
    }
    
    @discardableResult
    func shadow(color: UInt, opacity: Float, radius: CGFloat, offset: CGSize) -> Self {
        let hexColor = UIColor(hex: UInt32(color))
        self.layer.shadowColor = hexColor.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
        return self
    }
    
    @discardableResult
    func stroke(_ color: UIColor? = .black, lineWidth: CGFloat? = 1) -> Self {
        self.layer.borderColor = color?.cgColor
        self.layer.borderWidth = lineWidth ?? 0
        return self
    }
    
    @discardableResult
    func stroke(_ hexColor: UInt, lineWidth: CGFloat? = 1) -> Self {
        let color = UIColor(hex: UInt32(hexColor))
        return stroke(color, lineWidth: lineWidth)
    }
}

