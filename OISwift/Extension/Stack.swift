//
//  Stack.swift
//  OISwift
//
//  Created by keenoi on 17/05/24.
//

/*import UIKit

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
}*/


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
    public func stroke(_ color: SBinding<UIColor?>, lineWidth: SBinding<CGFloat?>) -> Self {
        self.layer.borderColor = color.wrappedValue?.cgColor
        self.layer.borderWidth = lineWidth.wrappedValue ?? 0
        color.didSet = { [weak self] newColor in
            self?.layer.borderColor = newColor?.cgColor
        }
        lineWidth.didSet = { [weak self] newLineWidth in
            self?.layer.borderWidth = newLineWidth ?? 0
        }
        return self
    }
    
    @discardableResult
    public func stroke(_ hexColor: SBinding<UInt>, lineWidth: SBinding<CGFloat?>) -> Self {
        let color = SBinding<UIColor?>(
            wrappedValue: UIColor(hex: UInt32(hexColor.wrappedValue)),
            didSet: { [weak self] newColor in
                self?.layer.borderColor = newColor?.cgColor
            }
        )
        return stroke(color, lineWidth: lineWidth)
    }
    
    @discardableResult
    public func stroke(_ state: SBinding<UIColor>, lineWidth: CGFloat = 1.0) -> Self {
        self.layer.borderWidth = lineWidth
        state.didSet = { [weak self] newColor in
            self?.layer.borderColor = newColor.cgColor
        }
        
        state.didSet?(state.wrappedValue)
        return self
    }
    
    @discardableResult
    public func stroke(_ state: SBinding<UIColor>, lineWidth: SBinding<CGFloat>) -> Self {
        self.layer.borderWidth = lineWidth.wrappedValue
        state.didSet = { [weak self] newColor in
            self?.layer.borderColor = newColor.cgColor
        }
        lineWidth.didSet = { [weak self] newLineWidth in
            self?.layer.borderWidth = newLineWidth
        }
        state.didSet?(state.wrappedValue)
        lineWidth.didSet?(lineWidth.wrappedValue)
        
        return self
    }
    
    @discardableResult
    public func stroke(_ state: SBinding<UInt>, lineWidth: CGFloat = 1.0) -> Self {
        self.layer.borderWidth = lineWidth
        state.didSet = { [weak self] hexValue in
            let color = UIColor(hex: UInt32(hexValue))
            self?.layer.borderColor = color.cgColor
        }
        
        state.didSet?(state.wrappedValue)
        return self
    }
    
    @discardableResult
    public func stroke(_ state: SBinding<UInt>, lineWidth: SBinding<CGFloat>) -> Self {
        self.layer.borderWidth = lineWidth.wrappedValue
        state.didSet = { [weak self] hexValue in
            let color = UIColor(hex: UInt32(hexValue))
            self?.layer.borderColor = color.cgColor
        }
        lineWidth.didSet = { [weak self] newLineWidth in
            self?.layer.borderWidth = newLineWidth
        }
        state.didSet?(state.wrappedValue)
        lineWidth.didSet?(lineWidth.wrappedValue)
        
        return self
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

extension UIStackView {
    private func findViewController() -> UIViewController? {
        var nextResponder: UIResponder? = self
        while let responder = nextResponder {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            nextResponder = responder.next
        }
        return nil
    }
    
    @discardableResult
    public func ignoresNavBar(_ bool: Bool = true) -> UIStackView {
        if let viewController = self.findViewController() {
            viewController.navigationController?.setToolbarHidden(bool, animated: true)
            viewController.navigationController?.setNavigationBarHidden(bool, animated: true)
        }
        return self
    }
    
    @discardableResult
    public func ignoresNavBar(_ binding: SBinding<Bool>) -> UIStackView {
        binding.didSet = { [weak self] bool in
            guard let self = self, let viewController = self.findViewController() else { return }
            viewController.navigationController?.setToolbarHidden(bool, animated: true)
            viewController.navigationController?.setNavigationBarHidden(bool, animated: true)
        }
        
        // Set the initial value
        binding.didSet?(binding.wrappedValue)
        
        return self
    }
    
    @discardableResult
    public func ignoresSafeArea() -> UIStackView {
        if let superview = self.superview {
            self.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: superview.topAnchor),
                self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                self.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            ])
        }
        // Mengatur layoutMargins menjadi UIEdgeInsets zero untuk menghindari konflik
        self.layoutMargins = .zero
        self.isLayoutMarginsRelativeArrangement = false
        return self
    }
    
    // Fungsi untuk mengkonfigurasi efek blur pada UINavigationBar
    private func configureNavigationBarAppearance() {
        if let viewController = self.findViewController() {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundEffect = UIBlurEffect(style: .systemMaterial)
            viewController.navigationController?.navigationBar.standardAppearance = appearance
            viewController.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
    @discardableResult
    public func navigationTitle(_ title: String, _ isBlurEffect: Bool = false) -> UIStackView {
        if let viewController = self.findViewController() {
            viewController.navigationItem.title = title
            
            configureNavigationBarAppearance()
        }
        return self
    }
    
    @discardableResult
    public func navigationBarTitleDisplayMode(_ mode: UINavigationItem.LargeTitleDisplayMode) -> UIStackView {
        if let viewController = self.findViewController() {
            viewController.navigationController?.navigationBar.prefersLargeTitles = (mode != .never)
            viewController.navigationItem.largeTitleDisplayMode = mode
        }
        return self
    }
    
    @discardableResult
    public func toolbar(@ToolbarItemBuilder _ content: () -> [ToolbarItem]) -> UIStackView {
        if let viewController = self.findViewController() {
            let toolbarItems = content()
            var leadingItems: [UIBarButtonItem] = []
            var trailingItems: [UIBarButtonItem] = []
            var principalItem: UIBarButtonItem?
            
            for item in toolbarItems {
                let barButtonItem = item.toBarButtonItem()
                switch item.placement {
                case .topBarLeading:
                    leadingItems.append(barButtonItem)
                case .topBarTrailing:
                    trailingItems.append(barButtonItem)
                case .bottomBar:
                    // For toolbar at the bottom, handle keyboard automatically
                    self.setupKeyboardNotifications(for: barButtonItem.customView)
                    viewController.toolbarItems = (viewController.toolbarItems ?? []) + [barButtonItem]
                case .principal:
                    principalItem = barButtonItem
                }
            }
            
            viewController.navigationItem.leftBarButtonItems = leadingItems
            viewController.navigationItem.rightBarButtonItems = trailingItems
            if let principalItem = principalItem {
                viewController.navigationItem.titleView = principalItem.customView
            }
        }
        return self
    }
    
    // Setup keyboard notifications
    private func setupKeyboardNotifications(for bottomBarItem: UIView?) {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak bottomBarItem] notification in
            guard let userInfo = notification.userInfo,
                  let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            
            UIView.animate(withDuration: 0.3) {
                bottomBarItem?.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height)
            }
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak bottomBarItem] notification in
            UIView.animate(withDuration: 0.3) {
                bottomBarItem?.transform = .identity
            }
        }
    }
}

// Define ToolbarItem for UI elements in the toolbar
public struct ToolbarItem {
    public let placement: ToolbarItemPlacement
    public let content: () -> UIView
    
    public init(placement: ToolbarItemPlacement, content: @escaping () -> UIView) {
        self.placement = placement
        self.content = content
    }
    
    public func toBarButtonItem() -> UIBarButtonItem {
        let view = content()
        return UIBarButtonItem(customView: view)
    }
}

// Result builder for ToolbarItem
@resultBuilder
public struct ToolbarItemBuilder {
    public static func buildBlock(_ items: ToolbarItem...) -> [ToolbarItem] {
        return items
    }
}

// Enum untuk menentukan posisi item di toolbar
public enum ToolbarItemPlacement {
    case topBarLeading
    case topBarTrailing
    case bottomBar
    case principal
}







// Enum untuk SafeArea
public enum SafeArea {
    case top
    case bottom
    case leading
    case trailing
    case horizontal
    case vertical
}

// MARK: UIStackView Extension
extension UIStackView {
    @discardableResult
    public func ignoresSafeArea(_ edges: SafeArea...) -> UIStackView {
        guard let superview = self.superview else { return self }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = []
        
        for edge in edges {
            switch edge {
            case .top:
                constraints.append(self.topAnchor.constraint(equalTo: superview.topAnchor))
            case .bottom:
                constraints.append(self.bottomAnchor.constraint(equalTo: superview.bottomAnchor))
            case .leading:
                constraints.append(self.leadingAnchor.constraint(equalTo: superview.leadingAnchor))
            case .trailing:
                constraints.append(self.trailingAnchor.constraint(equalTo: superview.trailingAnchor))
            case .horizontal:
                constraints.append(contentsOf: [
                    self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                    self.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
                ])
            case .vertical:
                constraints.append(contentsOf: [
                    self.topAnchor.constraint(equalTo: superview.topAnchor),
                    self.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
                ])
            }
        }
        
        NSLayoutConstraint.activate(constraints)
        
        // Mengatur layoutMargins menjadi UIEdgeInsets zero untuk menghindari konflik
        self.layoutMargins = .zero
        self.isLayoutMarginsRelativeArrangement = false
        
        return self
    }
}
