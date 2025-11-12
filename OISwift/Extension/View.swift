//
//  View.swift
//  OISwift
//
//  Created by keenoi on 17/05/24.
//

/*import UIKit

extension UIView {
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
    public func background(_ hex: UInt) -> Self {
        let color = UIColor(hex: UInt32(hex))
        return background(color)
    }
    
    @discardableResult
    public func width(_ width: CGFloat) -> Self {
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }
    
    @discardableResult
    public func height(_ height: CGFloat) -> Self {
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult
    public func frame(width: CGFloat, height: CGFloat) -> Self {
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ radius: CGFloat? = nil) -> Self {
        self.layer.cornerRadius = radius ?? 0
        self.layer.masksToBounds = true
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ radius: CGFloat? = nil, withShadow shadowConfig: (() -> Shadow)? = nil) -> Self {
        self.layer.cornerRadius = radius ?? 0
        self.layer.masksToBounds = true
        
        if let shadowConfig = shadowConfig?() {
            applyShadow(with: shadowConfig)
        }
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ corner: UIRectCorner, _ radius: CGFloat, withShadow shadowConfig: (() -> Shadow)? = nil) -> Self {
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
        
        if let shadowConfig = shadowConfig?() {
            applyShadow(with: shadowConfig)
        }
        
        return self
    }
    
    private func applyShadow(with config: Shadow) {
        layer.masksToBounds = false
        layer.shadowColor = config.color.cgColor
        layer.shadowOpacity = config.opacity
        layer.shadowOffset = config.offset
        layer.shadowRadius = config.radius
    }
    
    @discardableResult
    public func stroke(_ color: UIColor? = .black, lineWidth: CGFloat? = 1) -> Self {
        self.layer.borderColor = color?.cgColor
        self.layer.borderWidth = lineWidth ?? 0
        return self
    }
    
    public func stroke(_ hexColor: UInt, lineWidth: CGFloat? = 1) -> Self {
        let color = UIColor(hex: UInt32(hexColor))
        return stroke(color, lineWidth: lineWidth)
    }
    
    @discardableResult
    public func overlay(_ overlay: (UIView) -> Void) -> Self {
        let overlayView = UIView()
        overlay(overlayView)
        
        addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        return self
    }
}

public struct Shadow {
    public init(color: UIColor, radius: CGFloat, opacity: Float, offset: CGSize) {
        self.color = color
        self.radius = radius
        self.opacity = opacity
        self.offset = offset
    }

    var color: UIColor
    var radius: CGFloat
    var opacity: Float
    var offset: CGSize
}

extension UIView {
    @discardableResult
    private func addView(paddingTop: CGFloat = 0, paddingLeft: CGFloat = 0, paddingBottom: CGFloat = 0, paddingRight: CGFloat = 0, @UIStackViewBuilder content: () -> [UIView]) -> UIView {
        let container = UIView()
        addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let guide = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: guide.topAnchor, constant: paddingTop),
            container.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: paddingLeft),
            container.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -paddingRight),
            container.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -paddingBottom)
        ])
        
        let views = content()
        for view in views {
            container.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: container.topAnchor),
                view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
        }
        
        return container
    }
    
    @discardableResult
    public func addView(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0, @UIStackViewBuilder content: () -> [UIView]) -> UIView {
        return addView(paddingTop: top, paddingLeft: left, paddingBottom: bottom, paddingRight: right, content: content)
    }
    
    @discardableResult
    public func addView(padding: CGFloat = 0, @UIStackViewBuilder content: () -> [UIView]) -> UIView {
        return addView(paddingTop: padding, paddingLeft: padding, paddingBottom: padding, paddingRight: padding, content: content)
    }
    
    @discardableResult
    public func addView(padding: CGFloat = 0, verticalPadding: CGFloat = 0, horizontalPadding: CGFloat = 0, @UIStackViewBuilder content: () -> [UIView]) -> UIView {
        return addView(paddingTop: padding + verticalPadding, paddingLeft: padding + horizontalPadding, paddingBottom: padding + verticalPadding, paddingRight: padding + horizontalPadding, content: content)
    }
}

extension UIView {
    @discardableResult
    public func width(_ state: SBinding<CGFloat>) -> Self {
        state.didSet = { [weak self] newWidth in
            self?.widthAnchor.constraint(equalToConstant: newWidth).isActive = true
        }
        
        state.didSet?(state.wrappedValue)
        return self
    }
    
    @discardableResult
    public func height(_ state: SBinding<CGFloat>) -> Self {
        state.didSet = { [weak self] newHeight in
            self?.heightAnchor.constraint(equalToConstant: newHeight).isActive = true
        }
        
        state.didSet?(state.wrappedValue)
        return self
    }
    
    @discardableResult
    public func background(_ state: SBinding<UIColor>, opacity: CGFloat = 1.0) -> Self {
        state.didSet = { [weak self] newColor in
            self?.backgroundColor = newColor.withAlphaComponent(opacity)
        }
        
        state.didSet?(state.wrappedValue)
        return self
    }
    
    @discardableResult
    public func background(_ state: SBinding<UInt>, opacity: CGFloat = 1.0) -> Self {
        state.didSet = { [weak self] hexValue in
            let color = UIColor(hex: UInt32(hexValue))
            self?.backgroundColor = color
        }
        
        state.didSet?(state.wrappedValue)
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ radius: SBinding<CGFloat?>) -> Self {
        radius.didSet = { [weak self] newRadius in
            self?.layer.cornerRadius = newRadius ?? 0
            self?.layer.masksToBounds = true
        }
        radius.didSet?(radius.wrappedValue)
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ radiusState: SBinding<CGFloat>) -> Self {
        radiusState.didSet = { [weak self] newRadius in
            self?.layer.cornerRadius = newRadius
            self?.layer.masksToBounds = true
        }
        radiusState.didSet?(radiusState.wrappedValue)
        return self
    }
    
    @discardableResult
    public func isHidden(_ state: SBinding<Bool>) -> Self {
        self.isHidden = state.wrappedValue
        state.didSet = { [weak self] newValue in
            self?.isHidden = newValue
        }
        return self
    }
    
    @discardableResult
    public func isUserEnabled(_ isEnabled: Bool = true) -> Self {
        self.isUserInteractionEnabled = isEnabled
        return self
    }
    
    @discardableResult
    public func isUserEnabled(_ isEnabled: SBinding<Bool>) -> Self {
        isEnabled.didSet = { [weak self] newIsEnabled in
            self?.isUserInteractionEnabled = newIsEnabled
        }
        isEnabled.didSet?(isEnabled.wrappedValue)
        return self
    }
}

extension UIView {
    @discardableResult
    public func overlay(_ radius: CGFloat? = nil, withShadow shadowConfig: (() -> Shadow)? = nil) -> Self {
        self.layer.cornerRadius = radius ?? 0
        self.layer.masksToBounds = true
        
        if let shadowConfig = shadowConfig?() {
            applyShadow(with: shadowConfig)
        }
        return self
    }

    @discardableResult
    public func overlay(_ corner: UIRectCorner, _ radius: CGFloat, withShadow shadowConfig: (() -> Shadow)? = nil) -> Self {
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
        
        if let shadowConfig = shadowConfig?() {
            applyShadow(with: shadowConfig)
        }
        
        return self
    }

}*/


import UIKit

public class View: UIView {
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
    public func background(_ hex: UInt) -> Self {
        let color = UIColor(hex: UInt32(hex))
        return background(color)
    }
    
    @discardableResult
    public func width(_ width: CGFloat) -> Self {
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }
    
    @discardableResult
    public func height(_ height: CGFloat) -> Self {
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult
    public func frame(width: CGFloat, height: CGFloat) -> Self {
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ radius: CGFloat? = nil) -> Self {
        self.layer.cornerRadius = radius ?? 0
        self.layer.masksToBounds = true
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ radius: CGFloat? = nil, withShadow shadowConfig: (() -> Shadow)? = nil) -> Self {
        self.layer.cornerRadius = radius ?? 0
        self.layer.masksToBounds = true
        
        if let shadowConfig = shadowConfig?() {
            applyShadow(with: shadowConfig)
        }
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ corner: UIRectCorner, _ radius: CGFloat) -> Self {
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
    public func cornerRadius(_ corner: UIRectCorner, _ radius: CGFloat, withShadow shadowConfig: (() -> Shadow)? = nil) -> Self {
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
        
        if let shadowConfig = shadowConfig?() {
            applyShadow(with: shadowConfig)
        }
        
        return self
    }
    
    private func applyShadow(with config: Shadow) {
        layer.masksToBounds = false
        layer.shadowColor = config.color.cgColor
        layer.shadowOpacity = config.opacity
        layer.shadowOffset = config.offset
        layer.shadowRadius = config.radius
    }
    
    @discardableResult
    public func stroke(_ color: UIColor? = .black, lineWidth: CGFloat? = 1) -> Self {
        self.layer.borderColor = color?.cgColor
        self.layer.borderWidth = lineWidth ?? 0
        return self
    }
    
    @discardableResult
    public func stroke(_ hexColor: UInt, lineWidth: CGFloat? = 1) -> Self {
        let color = UIColor(hex: UInt32(hexColor))
        return stroke(color, lineWidth: lineWidth)
    }
    
    @discardableResult
    public func overlay(_ overlay: (UIView) -> Void) -> Self {
        let overlayView = UIView()
        overlay(overlayView)
        
        addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        return self
    }
}

extension UIView {
    @discardableResult
    public func addView(paddingTop: CGFloat = 0, paddingLeft: CGFloat = 0, paddingBottom: CGFloat = 0, paddingRight: CGFloat = 0, @UIStackViewBuilder content: () -> [UIView]) -> UIView {
        let container = UIView()
        addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let guide = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: guide.topAnchor, constant: paddingTop),
            container.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: paddingLeft),
            container.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -paddingRight),
            container.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -paddingBottom)
        ])
        
        let views = content()
        for view in views {
            container.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: container.topAnchor),
                view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
        }
        
        return container
    }
    
    @discardableResult
    public func addView(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0, @UIStackViewBuilder content: () -> [UIView]) -> UIView {
        return addView(paddingTop: top, paddingLeft: left, paddingBottom: bottom, paddingRight: right, content: content)
    }
    
    @discardableResult
    public func addView(padding: CGFloat = 0, @UIStackViewBuilder content: () -> [UIView]) -> UIView {
        return addView(paddingTop: padding, paddingLeft: padding, paddingBottom: padding, paddingRight: padding, content: content)
    }
    
    @discardableResult
    public func addView(padding: CGFloat = 0, verticalPadding: CGFloat = 0, horizontalPadding: CGFloat = 0, @UIStackViewBuilder content: () -> [UIView]) -> UIView {
        return addView(paddingTop: padding + verticalPadding, paddingLeft: padding + horizontalPadding, paddingBottom: padding + verticalPadding, paddingRight: padding + horizontalPadding, content: content)
    }
}

/*extension UIView {
    @discardableResult
    public func addView(
        paddingTop: CGFloat = 0,
        paddingLeft: CGFloat = 0,
        paddingBottom: CGFloat = 0,
        paddingRight: CGFloat = 0,
        centerX: Bool = false,
        centerY: Bool = false,
        @UIStackViewBuilder content: () -> [UIView]
    ) -> UIView {
        let container = UIView()
        addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false

        let guide = safeAreaLayoutGuide

        // anchor leading / trailing / top / bottom akan di-override
        // jika centerX / centerY diaktifkan
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: guide.topAnchor, constant: paddingTop),
            container.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: paddingLeft),
            container.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -paddingRight),
            container.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -paddingBottom)
        ])

        let views = content()
        for view in views {
            container.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false

            // centering
            if centerX {
                view.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            } else {
                view.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
                view.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
            }

            if centerY {
                view.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
            } else {
                view.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
                view.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
            }
        }
        return container
    }

    // overload tetap ada
    @discardableResult
    public func addView(
        top: CGFloat = 0,
        left: CGFloat = 0,
        bottom: CGFloat = 0,
        right: CGFloat = 0,
        centerX: Bool = false,
        centerY: Bool = false,
        @UIStackViewBuilder content: () -> [UIView]
    ) -> UIView {
        addView(paddingTop: top, paddingLeft: left, paddingBottom: bottom,
                paddingRight: right, centerX: centerX, centerY: centerY, content: content)
    }

    @discardableResult
    public func addView(
        padding: CGFloat = 0,
        centerX: Bool = false,
        centerY: Bool = false,
        @UIStackViewBuilder content: () -> [UIView]
    ) -> UIView {
        addView(paddingTop: padding, paddingLeft: padding, paddingBottom: padding,
                paddingRight: padding, centerX: centerX, centerY: centerY, content: content)
    }
}

// helper agar bisa dipakai di builder
public func Centered(
    centerX: Bool = false,
    centerY: Bool = false,
    padding: CGFloat = 0,
    @UIStackViewBuilder content: () -> [UIView]
) -> UIView {
    let dummy = UIView()
    return dummy.addView(padding: padding, centerX: centerX, centerY: centerY, content: content)
}*/

extension View {
    @discardableResult
    public func width(_ state: SBinding<CGFloat>) -> Self {
        state.didSet = { [weak self] newWidth in
            self?.widthAnchor.constraint(equalToConstant: newWidth).isActive = true
        }
        
        state.didSet?(state.wrappedValue)
        return self
    }
    
    @discardableResult
    public func height(_ state: SBinding<CGFloat>) -> Self {
        state.didSet = { [weak self] newHeight in
            self?.heightAnchor.constraint(equalToConstant: newHeight).isActive = true
        }
        
        state.didSet?(state.wrappedValue)
        return self
    }
    
    @discardableResult
    public func background(_ state: SBinding<UIColor>, opacity: CGFloat = 1.0) -> Self {
        state.didSet = { [weak self] newColor in
            self?.backgroundColor = newColor.withAlphaComponent(opacity)
        }
        
        state.didSet?(state.wrappedValue)
        return self
    }
    
    @discardableResult
    public func background(_ state: SBinding<UInt>, opacity: CGFloat = 1.0) -> Self {
        state.didSet = { [weak self] hexValue in
            let color = UIColor(hex: UInt32(hexValue))
            self?.backgroundColor = color
        }
        
        state.didSet?(state.wrappedValue)
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ radius: SBinding<CGFloat?>) -> Self {
        radius.didSet = { [weak self] newRadius in
            self?.layer.cornerRadius = newRadius ?? 0
            self?.layer.masksToBounds = true
        }
        radius.didSet?(radius.wrappedValue)
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ radiusState: SBinding<CGFloat>) -> Self {
        radiusState.didSet = { [weak self] newRadius in
            self?.layer.cornerRadius = newRadius
            self?.layer.masksToBounds = true
        }
        radiusState.didSet?(radiusState.wrappedValue)
        return self
    }
    
    @discardableResult
    public func isHidden(_ state: SBinding<Bool>) -> Self {
        self.isHidden = state.wrappedValue
        state.didSet = { [weak self] newValue in
            self?.isHidden = newValue
        }
        return self
    }
    
    @discardableResult
    public func isUserEnabled(_ isEnabled: Bool = true) -> Self {
        self.isUserInteractionEnabled = isEnabled
        return self
    }
    
    @discardableResult
    public func isUserEnabled(_ isEnabled: SBinding<Bool>) -> Self {
        isEnabled.didSet = { [weak self] newIsEnabled in
            self?.isUserInteractionEnabled = newIsEnabled
        }
        isEnabled.didSet?(isEnabled.wrappedValue)
        return self
    }
}

extension View {
    @discardableResult
    public func overlay(_ radius: CGFloat? = nil, withShadow shadowConfig: (() -> Shadow)? = nil) -> Self {
        self.layer.cornerRadius = radius ?? 0
        self.layer.masksToBounds = true
        
        if let shadowConfig = shadowConfig?() {
            applyShadow(with: shadowConfig)
        }
        return self
    }

    @discardableResult
    public func overlay(_ corner: UIRectCorner, _ radius: CGFloat, withShadow shadowConfig: (() -> Shadow)? = nil) -> Self {
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
        
        if let shadowConfig = shadowConfig?() {
            applyShadow(with: shadowConfig)
        }
        
        return self
    }

}

public struct Shadow {
    public init(color: UIColor, radius: CGFloat, opacity: Float, offset: CGSize) {
        self.color = color
        self.radius = radius
        self.opacity = opacity
        self.offset = offset
    }

    var color: UIColor
    var radius: CGFloat
    var opacity: Float
    var offset: CGSize
}

extension View {
    @discardableResult
    public func shadow(color: UIColor, opacity: Float, radius: CGFloat, offset: CGSize) -> Self {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
        return self
    }
    
    @discardableResult
    public func shadow(color: UInt, opacity: Float, radius: CGFloat, offset: CGSize) -> Self {
        let hexColor = UIColor(hex: UInt32(color))
        self.layer.shadowColor = hexColor.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
        return self
    }
}

/*extension View {
    @discardableResult
    public func concaveCornerRadius(_ radius: CGFloat, corners: UIRectCorner = .allCorners) -> Self {
        let path = UIBezierPath()
        
        let bounds = self.bounds
        
        // Titik sudut kiri atas
        let topLeft = CGPoint(x: bounds.minX, y: bounds.minY)
        // Titik sudut kanan atas
        let topRight = CGPoint(x: bounds.maxX, y: bounds.minY)
        // Titik sudut kanan bawah
        let bottomRight = CGPoint(x: bounds.maxX, y: bounds.maxY)
        // Titik sudut kiri bawah
        let bottomLeft = CGPoint(x: bounds.minX, y: bounds.maxY)
        
        path.move(to: CGPoint(x: topLeft.x + radius, y: topLeft.y))
        
        // Top edge (jika .topLeft tidak termasuk)
        if !corners.contains(.topLeft) && !corners.contains(.topRight) {
            path.addLine(to: CGPoint(x: topRight.x - radius, y: topRight.y))
        }
        
        // Top-right concave corner
        if corners.contains(.topRight) {
            path.addQuadCurve(to: CGPoint(x: topRight.x, y: topRight.y + radius),
                            controlPoint: topRight)
        } else {
            path.addLine(to: topRight)
        }
        
        // Right edge
        if !corners.contains(.topRight) && !corners.contains(.bottomRight) {
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y - radius))
        }
        
        // Bottom-right concave corner
        if corners.contains(.bottomRight) {
            path.addQuadCurve(to: CGPoint(x: bottomRight.x - radius, y: bottomRight.y),
                            controlPoint: bottomRight)
        } else {
            path.addLine(to: bottomRight)
        }
        
        // Bottom edge
        if !corners.contains(.bottomRight) && !corners.contains(.bottomLeft) {
            path.addLine(to: CGPoint(x: bottomLeft.x + radius, y: bottomLeft.y))
        }
        
        // Bottom-left concave corner
        if corners.contains(.bottomLeft) {
            path.addQuadCurve(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y - radius),
                            controlPoint: bottomLeft)
        } else {
            path.addLine(to: bottomLeft)
        }
        
        // Left edge
        if !corners.contains(.bottomLeft) && !corners.contains(.topLeft) {
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y + radius))
        }
        
        // Top-left concave corner
        if corners.contains(.topLeft) {
            path.addQuadCurve(to: CGPoint(x: topLeft.x + radius, y: topLeft.y),
                            controlPoint: topLeft)
        } else {
            path.addLine(to: topLeft)
        }
        
        path.close()
        
        // Create shape layer
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.fillColor = UIColor.black.cgColor
        
        // Apply mask
        self.layer.mask = shape
        
        return self
    }
}*/

extension View {
    public func concaveCornerRadius(_ radius: CGFloat,
                                    corners: UIRectCorner = .allCorners) -> Self {
        // Force the view to calculate its real bounds once
        self.layoutIfNeeded()
        
        let path = UIBezierPath()
        let b = self.bounds          // now non-zero
        let tl = CGPoint(x: b.minX, y: b.minY)
        let tr = CGPoint(x: b.maxX, y: b.minY)
        let br = CGPoint(x: b.maxX, y: b.maxY)
        let bl = CGPoint(x: b.minX, y: b.maxY)
        
        path.move(to: CGPoint(x: tl.x + radius, y: tl.y))
        
        // top-right
        if corners.contains(.topRight) {
            path.addQuadCurve(to: CGPoint(x: tr.x, y: tr.y + radius),
                              controlPoint: tr)
        } else {
            path.addLine(to: tr)
        }
        
        // bottom-right
        if corners.contains(.bottomRight) {
            path.addQuadCurve(to: CGPoint(x: br.x - radius, y: br.y),
                              controlPoint: br)
        } else {
            path.addLine(to: br)
        }
        
        // bottom-left
        if corners.contains(.bottomLeft) {
            path.addQuadCurve(to: CGPoint(x: bl.x, y: bl.y - radius),
                              controlPoint: bl)
        } else {
            path.addLine(to: bl)
        }
        
        // top-left
        if corners.contains(.topLeft) {
            path.addQuadCurve(to: CGPoint(x: tl.x + radius, y: tl.y),
                              controlPoint: tl)
        } else {
            path.addLine(to: tl)
        }
        
        path.close()
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return self
    }
}

extension UIView {
    @discardableResult
    func concaveEnds(depth: CGFloat) -> Self {
        layoutIfNeeded() // <-- penting agar bounds sudah valid
        
        let width = bounds.width
        let height = bounds.height
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addQuadCurve(
            to: CGPoint(x: width, y: height),
            controlPoint: CGPoint(x: width - height * depth, y: height / 2)
        )
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addQuadCurve(
            to: .zero,
            controlPoint: CGPoint(x: height * depth, y: height / 2)
        )
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        layer.masksToBounds = false
        
        return self
    }
}


public enum CenteredView {
    case centerX
    case centerY
    case centerXY
    case none
}

extension UIView {
    @discardableResult
    public func addView(
        paddingTop: CGFloat = 0,
        paddingLeft: CGFloat = 0,
        paddingBottom: CGFloat = 0,
        paddingRight: CGFloat = 0,
        centered: CenteredView = .none,
        @UIStackViewBuilder content: () -> [UIView]
    ) -> UIView {
        let container = UIView()
        addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let guide = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: guide.topAnchor, constant: paddingTop),
            container.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: paddingLeft),
            container.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -paddingRight),
            container.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -paddingBottom)
        ])
        
        let views = content()
        for view in views {
            container.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            // Handle centering logic
            let centerX = centered == .centerX || centered == .centerXY
            let centerY = centered == .centerY || centered == .centerXY
            
            if centerX {
                view.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            } else {
                view.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
                view.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
            }
            
            if centerY {
                view.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
            } else {
                view.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
                view.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
            }
        }
        return container
    }
    
    // Overloads yang compatible
    @discardableResult
    public func addView(
        top: CGFloat = 0,
        left: CGFloat = 0,
        bottom: CGFloat = 0,
        right: CGFloat = 0,
        centered: CenteredView = .none,
        @UIStackViewBuilder content: () -> [UIView]
    ) -> UIView {
        addView(paddingTop: top, paddingLeft: left, paddingBottom: bottom,
                paddingRight: right, centered: centered, content: content)
    }
    
    @discardableResult
    public func addView(
        padding: CGFloat = 0,
        centered: CenteredView = .none,
        @UIStackViewBuilder content: () -> [UIView]
    ) -> UIView {
        addView(paddingTop: padding, paddingLeft: padding, paddingBottom: padding,
                paddingRight: padding, centered: centered, content: content)
    }
}

// Helper yang updated
public func Centered(
    _ centered: CenteredView = .none,
    padding: CGFloat = 0,
    @UIStackViewBuilder content: () -> [UIView]
) -> UIView {
    let dummy = UIView()
    return dummy.addView(padding: padding, centered: centered, content: content)
}
