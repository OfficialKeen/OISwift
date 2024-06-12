//
//  Button.swift
//  OISwift
//
//  Created by keenoi on 17/05/24.
//

/*import UIKit

extension UIButton {
    public typealias Action = () -> Void
    
    private struct AssociatedKeys {
        static var actionKey: UInt8 = 0
    }
    
    private var action: Action? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.actionKey) as? Action
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.actionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    convenience init(_ action: @escaping Action, setup: (UIButton) -> Void) {
        self.init(type: .system)
        content(action, setup: setup)
    }
    
    @discardableResult
    public func content(_ action: @escaping Action, setup: (UIButton) -> Void) -> UIButton {
        setup(self)
        self.action = action
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return self
    }
    
    convenience init(_ action: @escaping Action, setup: () -> Void) {
        self.init(type: .system)
        content(action, setup: setup)
    }
    
    @discardableResult
    public func content(_ action: @escaping Action, setup: () -> Void) -> UIButton {
        setup()
        self.action = action
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return self
    }
    
    @objc private func buttonTapped() {
        action?()
    }

    public func frame(width: CGFloat? = nil, height: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    @discardableResult
    public func textAlignment(horizontal: UIControl.ContentHorizontalAlignment? = nil, vertical: UIControl.ContentVerticalAlignment? = nil, horizontalPadding: CGFloat? = nil, verticalPadding: CGFloat? = nil) -> UIButton {
        if let horizontal = horizontal {
            contentHorizontalAlignment = horizontal
        }
        if let vertical = vertical {
            contentVerticalAlignment = vertical
        }
        
        var edgeInsets = UIEdgeInsets.zero
        
        if let horizontalPadding = horizontalPadding {
            edgeInsets.left = horizontalPadding
            edgeInsets.right = horizontalPadding
        }
        
        if let verticalPadding = verticalPadding {
            edgeInsets.top = verticalPadding
            edgeInsets.bottom = verticalPadding
        }
        
        titleEdgeInsets = edgeInsets
        return self
    }
    
    @discardableResult
    public func textAlignment(_ horizontal: UIControl.ContentHorizontalAlignment? = nil, _ padding: CGFloat? = nil) -> UIButton {
        if let horizontal = horizontal {
            contentHorizontalAlignment = horizontal
        }
        var edgeInsets = UIEdgeInsets.zero
        if let horizontalPadding = padding {
            edgeInsets.left = horizontalPadding
            edgeInsets.right = horizontalPadding
        }
        
        titleEdgeInsets = edgeInsets
        return self
    }
    
    @discardableResult
    public func textAlignment(_ vertical: UIControl.ContentVerticalAlignment? = nil, _ padding: CGFloat? = nil) -> UIButton {
        if let vertical = vertical {
            contentVerticalAlignment = vertical
        }
        var edgeInsets = UIEdgeInsets.zero
        if let verticalPadding = padding {
            edgeInsets.top = verticalPadding
            edgeInsets.bottom = verticalPadding
        }
        titleEdgeInsets = edgeInsets
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ color: UIColor, for state: UIControl.State = .normal) -> UIButton {
        setTitleColor(color, for: state)
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ hex: UInt, for state: UIControl.State = .normal) -> UIButton {
        let color = UIColor(hex: UInt32(hex))
        setTitleColor(color, for: state)
        return self
    }
    
    @discardableResult
    public func title(_ title: String?, for state: UIControl.State = .normal) -> UIButton {
        setTitle(title, for: state)
        return self
    }
    
    @discardableResult
    public func title(_ title: String?, fontSize size: CGFloat? = nil, for state: UIControl.State = .normal) -> UIButton {
        setTitle(title, for: state)
        if let size = size {
            titleLabel?.font = titleLabel?.font.withSize(size)
        }
        return self
    }
    
    @discardableResult
    public func title(_ title: String?, font fonts: UIFont? = nil, for state: UIControl.State = .normal) -> UIButton {
        setTitle(title, for: state)
        if let font = fonts {
            titleLabel?.font = font
        }
        return self
    }
    
    @discardableResult
    public func title(_ title: String?, fontSize size: CGFloat? = nil, font fonts: UIFont? = nil, for state: UIControl.State = .normal) -> UIButton {
        setTitle(title, for: state)
        if let size = size {
            titleLabel?.font = titleLabel?.font.withSize(size)
        }
        if let font = fonts {
            titleLabel?.font = font
        }
        return self
    }

    
    @discardableResult
    public func image(_ name: String, for state: UIControl.State = .normal) -> UIButton {
        if let image = UIImage(named: name) {
            setImage(image, for: state)
        }
        return self
    }
    
    @discardableResult
    public func image(systemName: String, for state: UIControl.State = .normal) -> UIButton {
        if #available(iOS 13.0, *) {
            if let image = UIImage(systemName: systemName) {
                setImage(image, for: state)
            }
        } else {
            // Fallback on earlier versions
        }
        return self
    }
    
    @discardableResult
    public func image(_ name: String, tintColor: UIColor, for state: UIControl.State = .normal) -> UIButton {
        if let image = UIImage(named: name)?.withRenderingMode(.alwaysTemplate) {
            setImage(image, for: state)
            self.tintColor = tintColor
        }
        return self
    }

    @discardableResult
    public func image(systemName: String, tintColor: UIColor, for state: UIControl.State = .normal) -> UIButton {
        if #available(iOS 13.0, *) {
            if let image = UIImage(systemName: systemName)?.withRenderingMode(.alwaysTemplate) {
                setImage(image, for: state)
                self.tintColor = tintColor
            }
        } else {
            // Fallback on earlier versions
        }
        return self
    }
    
    @discardableResult
    public func image(_ name: String, at position: ImagePosition, spacing: CGFloat = 0, for state: UIControl.State = .normal) -> UIButton {
        if let image = UIImage(named: name) {
            setImage(image, for: state)
            positionImage(imagePosition: position, spacing: spacing)
        }
        return self
    }
    
    @discardableResult
    public func image(systemName: String, at position: ImagePosition, spacing: CGFloat = 0, for state: UIControl.State = .normal) -> UIButton {
        if #available(iOS 13.0, *) {
            if let image = UIImage(systemName: systemName) {
                setImage(image, for: state)
                positionImage(imagePosition: position, spacing: spacing)
            }
        } else {
            // Fallback on earlier versions
        }
        return self
    }
    
    @discardableResult
    public func image(_ name: String, at position: ImagePosition, spacing: CGFloat = 0, tintColor: UIColor, for state: UIControl.State = .normal) -> UIButton {
        if let image = UIImage(named: name)?.withRenderingMode(.alwaysTemplate) {
            setImage(image, for: state)
            self.tintColor = tintColor
            positionImage(imagePosition: position, spacing: spacing)
        }
        return self
    }
    
    @discardableResult
    public func image(systemName: String, at position: ImagePosition, spacing: CGFloat = 0, tintColor: UIColor, for state: UIControl.State = .normal) -> UIButton {
        if #available(iOS 13.0, *) {
            if let image = UIImage(systemName: systemName)?.withRenderingMode(.alwaysTemplate) {
                setImage(image, for: state)
                self.tintColor = tintColor
                positionImage(imagePosition: position, spacing: spacing)
            }
        } else {
            // Fallback on earlier versions
        }
        return self
    }
    
    private func positionImage(imagePosition: ImagePosition, spacing: CGFloat = 0) {
        guard let imageView = imageView, let image = imageView.image, let titleLabel = titleLabel else {
            return
        }
        
        let imageInset: CGFloat = 0.0
        let titleInset: CGFloat = 0.0
        
        switch imagePosition {
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -imageInset - spacing, bottom: 0, right: imageInset)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: titleInset, bottom: 0, right: -titleInset)
        case .right:
            let imageSize = image.size
            imageEdgeInsets = UIEdgeInsets(top: 0, left: titleLabel.frame.size.width + titleInset + (spacing + 30), bottom: 0, right: -titleLabel.frame.size.width - titleInset - (spacing + 30))
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width - imageInset, bottom: 0, right: imageSize.width + imageInset)
        }
    }
}

public enum ImagePosition {
    case left
    case right
}

extension UIButton {
    @discardableResult
    public func title(_ state: SBinding<String?>, for controlState: UIControl.State = .normal) -> UIButton {
        setTitle(state.wrappedValue, for: controlState)
        
        state.didSet = { [weak self] newTitle in
            self?.setTitle(newTitle, for: controlState)
        }
        
        return self
    }
    
    @discardableResult
    public func title(_ state: SBinding<String>, for controlState: UIControl.State = .normal) -> UIButton {
        setTitle(state.wrappedValue, for: controlState)
        
        state.didSet = { [weak self] newTitle in
            self?.setTitle(newTitle, for: controlState)
        }
        
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ state: SBinding<UIColor?>, for controlState: UIControl.State = .normal) -> UIButton {
        state.didSet = { [weak self] newColor in
            self?.setTitleColor(newColor, for: controlState)
        }
        
        state.didSet?(state.wrappedValue)
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ state: SBinding<UIColor>, for controlState: UIControl.State = .normal) -> UIButton {
        state.didSet = { [weak self] newColor in
            self?.setTitleColor(newColor, for: controlState)
        }
        
        state.didSet?(state.wrappedValue)
        return self
    }

    @discardableResult
    public func foregroundColor(_ state: SBinding<UInt?>, for controlState: UIControl.State = .normal) -> UIButton {
        state.didSet = { [weak self] hexValue in
            guard let hex = hexValue else { return }
            let color = UIColor(hex: UInt32(hex))
            self?.setTitleColor(color, for: controlState)
        }
        
        state.didSet?(state.wrappedValue)
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ state: SBinding<UInt>, for controlState: UIControl.State = .normal) -> UIButton {
        state.didSet = { [weak self] hex in
            let color = UIColor(hex: UInt32(hex))
            self?.setTitleColor(color, for: controlState)
        }
        
        state.didSet?(state.wrappedValue)
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ cornerRadius: CGFloat) -> UIButton {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        return self
    }
    
    @discardableResult
    public func image(_ state: SBinding<UIImage?>, for controlState: UIControl.State = .normal) -> UIButton {
        state.didSet = { [weak self] newImage in
            self?.setImage(newImage, for: controlState)
        }
        
        state.didSet?(state.wrappedValue)
        return self
    }
    
    @discardableResult
    public func image(_ state: SBinding<UIImage>, for controlState: UIControl.State = .normal) -> UIButton {
        state.didSet = { [weak self] newImage in
            self?.setImage(newImage, for: controlState)
        }
        
        state.didSet?(state.wrappedValue)
        return self
    }
    
    @discardableResult
    public func image(systemName state: SBinding<String?>, defaultImageName: String? = nil, for controlState: UIControl.State = .normal) -> UIButton {
        if #available(iOS 13.0, *) {
            state.didSet = { [weak self] newSystemName in
                if let systemName = newSystemName, let image = UIImage(systemName: systemName) {
                    self?.setImage(image, for: controlState)
                }
            }
        } else {
            guard let defaultImageName = defaultImageName, let image = UIImage(named: defaultImageName) else {
                return self
            }
            state.didSet = { [weak self] _ in
                self?.setImage(image, for: controlState)
            }
        }
        
        state.didSet?(state.wrappedValue)
        return self
    }
    
    @discardableResult
    public func image(_ name: SBinding<String?>, tintColor: SBinding<UIColor>, for controlState: UIControl.State = .normal) -> UIButton {
        name.didSet = { [weak self] newName in
            guard let imageName = newName, let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate) else {
                return
            }
            self?.setImage(image, for: controlState)
        }
        
        tintColor.didSet = { [weak self] newTintColor in
            self?.tintColor = newTintColor
        }
        
        name.didSet?(name.wrappedValue)
        tintColor.didSet?(tintColor.wrappedValue)
        
        return self
    }
    
    @discardableResult
    public func image(systemName state: SBinding<String?>, defaultImageName: String? = nil, tintColor: SBinding<UIColor>, for controlState: UIControl.State = .normal) -> UIButton {
        if #available(iOS 13.0, *) {
            state.didSet = { [weak self] newSystemName in
                guard let systemName = newSystemName, let image = UIImage(systemName: systemName)?.withRenderingMode(.alwaysTemplate) else {
                    return
                }
                self?.setImage(image, for: controlState)
            }
        } else {
            guard let defaultImageName = defaultImageName, let image = UIImage(named: defaultImageName)?.withRenderingMode(.alwaysTemplate) else {
                return self
            }
            state.didSet = { [weak self] _ in
                self?.setImage(image, for: controlState)
            }
        }
        
        tintColor.didSet = { [weak self] newTintColor in
            self?.tintColor = newTintColor
        }
        
        state.didSet?(state.wrappedValue)
        tintColor.didSet?(tintColor.wrappedValue)
        
        return self
    }
    
    @discardableResult
    public func image(_ name: SBinding<String?>, at position: ImagePosition, spacing: CGFloat = 0, for controlState: UIControl.State = .normal) -> UIButton {
        name.didSet = { [weak self] newName in
            guard let imageName = newName, let image = UIImage(named: imageName) else {
                return
            }
            self?.setImage(image, for: controlState)
            self?.positionImage(imagePosition: position, spacing: spacing)
        }
        
        name.didSet?(name.wrappedValue)
        
        return self
    }

    @discardableResult
    public func image(_ image: SBinding<UIImage?>, at position: ImagePosition, spacing: CGFloat = 0, for controlState: UIControl.State = .normal) -> UIButton {
        image.didSet = { [weak self] newImage in
            guard let image = newImage else {
                return
            }
            self?.setImage(image, for: controlState)
            self?.positionImage(imagePosition: position, spacing: spacing)
        }
        
        image.didSet?(image.wrappedValue)
        
        return self
    }
    
    @discardableResult
    public func image(systemName name: SBinding<String?>, at position: ImagePosition, spacing: CGFloat = 0, for controlState: UIControl.State = .normal) -> UIButton {
        if #available(iOS 13.0, *) {
            name.didSet = { [weak self] newName in
                guard let systemName = newName, let image = UIImage(systemName: systemName) else {
                    return
                }
                self?.setImage(image, for: controlState)
                self?.positionImage(imagePosition: position, spacing: spacing)
            }
        } else {
            guard let defaultImageName = name.wrappedValue, let image = UIImage(named: defaultImageName) else {
                return self
            }
            name.didSet = { [weak self] _ in
                self?.setImage(image, for: controlState)
                self?.positionImage(imagePosition: position, spacing: spacing)
            }
        }
        
        name.didSet?(name.wrappedValue)
        
        return self
    }
    
    @discardableResult
    public func image(_ name: SBinding<String?>, at position: ImagePosition, spacing: CGFloat = 0, tintColor: SBinding<UIColor>, for controlState: UIControl.State = .normal) -> UIButton {
        name.didSet = { [weak self] newName in
            guard let imageName = newName, let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate) else {
                return
            }
            self?.setImage(image, for: controlState)
            self?.positionImage(imagePosition: position, spacing: spacing)
        }
        
        tintColor.didSet = { [weak self] newTintColor in
            self?.tintColor = newTintColor
        }
        
        name.didSet?(name.wrappedValue)
        tintColor.didSet?(tintColor.wrappedValue)
        
        return self
    }
    
    @discardableResult
    public func image(systemName name: SBinding<String?>, at position: ImagePosition, spacing: CGFloat = 0, tintColor: SBinding<UIColor>, for controlState: UIControl.State = .normal) -> UIButton {
        if #available(iOS 13.0, *) {
            name.didSet = { [weak self] newName in
                guard let systemName = newName, let image = UIImage(systemName: systemName)?.withRenderingMode(.alwaysTemplate) else {
                    return
                }
                self?.setImage(image, for: controlState)
                self?.positionImage(imagePosition: position, spacing: spacing)
            }
        } else {
            guard let defaultImageName = name.wrappedValue, let image = UIImage(named: defaultImageName)?.withRenderingMode(.alwaysTemplate) else {
                return self
            }
            name.didSet = { [weak self] _ in
                self?.setImage(image, for: controlState)
                self?.positionImage(imagePosition: position, spacing: spacing)
            }
        }
        
        tintColor.didSet = { [weak self] newTintColor in
            self?.tintColor = newTintColor
        }
        
        name.didSet?(name.wrappedValue)
        tintColor.didSet?(tintColor.wrappedValue)
        
        return self
    }
    
    @discardableResult
    public func font(size: CGFloat, weight: UIFont.Weight = .regular) -> UIButton {
        self.titleLabel?.font = UIFont.systemFont(ofSize: size, weight: weight)
        return self
    }
    
    @discardableResult
    public func font(size: SBinding<CGFloat?>, weight: SBinding<UIFont.Weight?> = SBinding(wrappedValue: .regular)) -> UIButton {
        size.didSet = { [weak self] newSize in
            guard let newSize = newSize else { return }
            let currentWeight = weight.wrappedValue ?? .regular
            self?.titleLabel?.font = UIFont.systemFont(ofSize: newSize, weight: currentWeight)
        }

        weight.didSet = { [weak self] newWeight in
            guard let newWeight = newWeight else { return }
            let currentSize = size.wrappedValue ?? UIFont.systemFontSize
            self?.titleLabel?.font = UIFont.systemFont(ofSize: currentSize, weight: newWeight)
        }

        size.didSet?(size.wrappedValue)
        weight.didSet?(weight.wrappedValue)

        return self
    }
    
    @discardableResult
    public func isEnabled(_ isEnabled: Bool = true) -> Self {
        self.isEnabled = isEnabled
        return self
    }
    
    @discardableResult
    public func isEnabled(_ isEnabled: SBinding<Bool>) -> Self {
        isEnabled.didSet = { [weak self] newIsEnabled in
            self?.isEnabled = newIsEnabled
        }
        isEnabled.didSet?(isEnabled.wrappedValue)
        return self
    }
}

extension UIButton {
    @discardableResult
    public func image(_ name: String, tintColor: UInt, for state: UIControl.State = .normal) -> UIButton {
        let color = UIColor(hex: UInt32(tintColor))
        if let image = UIImage(named: name)?.withRenderingMode(.alwaysTemplate) {
            setImage(image, for: state)
            self.tintColor = color
        }
        return self
    }
    
    @discardableResult
    public func image(_ name: SBinding<String?>, tintColor: UInt, for controlState: UIControl.State = .normal) -> UIButton {
        name.didSet = { [weak self] newName in
            guard let imageName = newName, let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate) else {
                return
            }
            self?.setImage(image, for: controlState)
        }
        
        let color = UIColor(hex: UInt32(tintColor))
        self.tintColor = color
        
        name.didSet?(name.wrappedValue)
        
        return self
    }
}*/


import UIKit

public class Button: UIButton {
    public typealias Action = () -> Void
    
    private struct AssociatedKeys {
        static var actionKey: UInt8 = 0
    }
    
    private var action: Action? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.actionKey) as? Action
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.actionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    convenience init(_ action: @escaping Action, setup: (Self) -> Void) {
        self.init(type: .system)
        content(action, setup: setup)
    }
    
    @discardableResult
    public func content(_ action: @escaping Action, setup: (Self) -> Void) -> Self {
        setup(self)
        self.action = action
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return self
    }
    
    convenience init(_ action: @escaping Action, setup: () -> Void) {
        self.init(type: .system)
        content(action, setup: setup)
    }
    
    @discardableResult
    public func content(_ action: @escaping Action, setup: () -> Void) -> Self {
        setup()
        self.action = action
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return self
    }
    
    @objc private func buttonTapped() {
        action?()
    }

    public func frame(width: CGFloat? = nil, height: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    @discardableResult
    public func textAlignment(horizontal: UIControl.ContentHorizontalAlignment? = nil, vertical: UIControl.ContentVerticalAlignment? = nil, horizontalPadding: CGFloat? = nil, verticalPadding: CGFloat? = nil) -> Self {
        if let horizontal = horizontal {
            contentHorizontalAlignment = horizontal
        }
        if let vertical = vertical {
            contentVerticalAlignment = vertical
        }
        
        var edgeInsets = UIEdgeInsets.zero
        
        if let horizontalPadding = horizontalPadding {
            edgeInsets.left = horizontalPadding
            edgeInsets.right = horizontalPadding
        }
        
        if let verticalPadding = verticalPadding {
            edgeInsets.top = verticalPadding
            edgeInsets.bottom = verticalPadding
        }
        
        titleEdgeInsets = edgeInsets
        return self
    }
    
    @discardableResult
    public func textAlignment(_ horizontal: UIControl.ContentHorizontalAlignment? = nil, _ padding: CGFloat? = nil) -> Self {
        if let horizontal = horizontal {
            contentHorizontalAlignment = horizontal
        }
        var edgeInsets = UIEdgeInsets.zero
        if let horizontalPadding = padding {
            edgeInsets.left = horizontalPadding
            edgeInsets.right = horizontalPadding
        }
        
        titleEdgeInsets = edgeInsets
        return self
    }
    
    @discardableResult
    public func textAlignment(_ vertical: UIControl.ContentVerticalAlignment? = nil, _ padding: CGFloat? = nil) -> Self {
        if let vertical = vertical {
            contentVerticalAlignment = vertical
        }
        var edgeInsets = UIEdgeInsets.zero
        if let verticalPadding = padding {
            edgeInsets.top = verticalPadding
            edgeInsets.bottom = verticalPadding
        }
        titleEdgeInsets = edgeInsets
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        setTitleColor(color, for: state)
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ hex: UInt, for state: UIControl.State = .normal) -> Self {
        let color = UIColor(hex: UInt32(hex))
        setTitleColor(color, for: state)
        return self
    }
    
    @discardableResult
    public func title(_ title: String?, for state: UIControl.State = .normal) -> Self {
        setTitle(title, for: state)
        return self
    }
    
    @discardableResult
    public func title(_ title: String?, fontSize size: CGFloat? = nil, for state: UIControl.State = .normal) -> Self {
        setTitle(title, for: state)
        if let size = size {
            titleLabel?.font = titleLabel?.font.withSize(size)
        }
        return self
    }
    
    @discardableResult
    public func title(_ title: String?, font fonts: UIFont? = nil, for state: UIControl.State = .normal) -> Self {
        setTitle(title, for: state)
        if let font = fonts {
            titleLabel?.font = font
        }
        return self
    }
    
    @discardableResult
    public func title(_ title: String?, fontSize size: CGFloat? = nil, font fonts: UIFont? = nil, for state: UIControl.State = .normal) -> Self {
        setTitle(title, for: state)
        if let size = size {
            titleLabel?.font = titleLabel?.font.withSize(size)
        }
        if let font = fonts {
            titleLabel?.font = font
        }
        return self
    }

    
    @discardableResult
    public func image(_ name: String, for state: UIControl.State = .normal) -> Self {
        if let image = UIImage(named: name) {
            setImage(image, for: state)
        }
        return self
    }
    
    @discardableResult
    public func image(systemName: String, for state: UIControl.State = .normal) -> Self {
        if #available(iOS 13.0, *) {
            if let image = UIImage(systemName: systemName) {
                setImage(image, for: state)
            }
        } else {
            // Fallback on earlier versions
        }
        return self
    }
    
    @discardableResult
    public func image(_ name: String, tintColor: UIColor, for state: UIControl.State = .normal) -> Self {
        if let image = UIImage(named: name)?.withRenderingMode(.alwaysTemplate) {
            setImage(image, for: state)
            self.tintColor = tintColor
        }
        return self
    }

    @discardableResult
    public func image(systemName: String, tintColor: UIColor, for state: UIControl.State = .normal) -> Self {
        if #available(iOS 13.0, *) {
            if let image = UIImage(systemName: systemName)?.withRenderingMode(.alwaysTemplate) {
                setImage(image, for: state)
                self.tintColor = tintColor
            }
        } else {
            // Fallback on earlier versions
        }
        return self
    }
    
    @discardableResult
    public func image(_ name: String, at position: ImagePosition, spacing: CGFloat = 0, for state: UIControl.State = .normal) -> Self {
        if let image = UIImage(named: name) {
            setImage(image, for: state)
            positionImage(imagePosition: position, spacing: spacing)
        }
        return self
    }
    
    @discardableResult
    public func image(systemName: String, at position: ImagePosition, spacing: CGFloat = 0, for state: UIControl.State = .normal) -> Self {
        if #available(iOS 13.0, *) {
            if let image = UIImage(systemName: systemName) {
                setImage(image, for: state)
                positionImage(imagePosition: position, spacing: spacing)
            }
        } else {
            // Fallback on earlier versions
        }
        return self
    }
    
    @discardableResult
    public func image(_ name: String, at position: ImagePosition, spacing: CGFloat = 0, tintColor: UIColor, for state: UIControl.State = .normal) -> Self {
        if let image = UIImage(named: name)?.withRenderingMode(.alwaysTemplate) {
            setImage(image, for: state)
            self.tintColor = tintColor
            positionImage(imagePosition: position, spacing: spacing)
        }
        return self
    }
    
    @discardableResult
    public func image(systemName: String, at position: ImagePosition, spacing: CGFloat = 0, tintColor: UIColor, for state: UIControl.State = .normal) -> Self {
        if #available(iOS 13.0, *) {
            if let image = UIImage(systemName: systemName)?.withRenderingMode(.alwaysTemplate) {
                setImage(image, for: state)
                self.tintColor = tintColor
                positionImage(imagePosition: position, spacing: spacing)
            }
        } else {
            // Fallback on earlier versions
        }
        return self
    }
    
    private func positionImage(imagePosition: ImagePosition, spacing: CGFloat = 0) {
        guard let imageView = imageView, let image = imageView.image, let titleLabel = titleLabel else {
            return
        }
        
        let imageInset: CGFloat = 0.0
        let titleInset: CGFloat = 0.0
        
        switch imagePosition {
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -imageInset - spacing, bottom: 0, right: imageInset)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: titleInset, bottom: 0, right: -titleInset)
        case .right:
            let imageSize = image.size
            imageEdgeInsets = UIEdgeInsets(top: 0, left: titleLabel.frame.size.width + titleInset + (spacing + 30), bottom: 0, right: -titleLabel.frame.size.width - titleInset - (spacing + 30))
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width - imageInset, bottom: 0, right: imageSize.width + imageInset)
        }
    }
}

public enum ImagePosition {
    case left
    case right
}

extension Button {
    @discardableResult
    public func title(_ state: SBinding<String?>, for controlState: UIControl.State = .normal) -> Self {
        setTitle(state.wrappedValue, for: controlState)
        
        state.didSet = { [weak self] newTitle in
            self?.setTitle(newTitle, for: controlState)
        }
        
        return self
    }
    
    @discardableResult
    public func title(_ state: SBinding<String>, for controlState: UIControl.State = .normal) -> Self {
        setTitle(state.wrappedValue, for: controlState)
        
        state.didSet = { [weak self] newTitle in
            self?.setTitle(newTitle, for: controlState)
        }
        
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ state: SBinding<UIColor?>, for controlState: UIControl.State = .normal) -> Self {
        state.didSet = { [weak self] newColor in
            self?.setTitleColor(newColor, for: controlState)
        }
        
        state.didSet?(state.wrappedValue)
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ state: SBinding<UIColor>, for controlState: UIControl.State = .normal) -> Self {
        state.didSet = { [weak self] newColor in
            self?.setTitleColor(newColor, for: controlState)
        }
        
        state.didSet?(state.wrappedValue)
        return self
    }

    @discardableResult
    public func foregroundColor(_ state: SBinding<UInt?>, for controlState: UIControl.State = .normal) -> Self {
        state.didSet = { [weak self] hexValue in
            guard let hex = hexValue else { return }
            let color = UIColor(hex: UInt32(hex))
            self?.setTitleColor(color, for: controlState)
        }
        
        state.didSet?(state.wrappedValue)
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ state: SBinding<UInt>, for controlState: UIControl.State = .normal) -> Self {
        state.didSet = { [weak self] hex in
            let color = UIColor(hex: UInt32(hex))
            self?.setTitleColor(color, for: controlState)
        }
        
        state.didSet?(state.wrappedValue)
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
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
    public func image(_ state: SBinding<UIImage?>, for controlState: UIControl.State = .normal) -> Self {
        state.didSet = { [weak self] newImage in
            self?.setImage(newImage, for: controlState)
        }
        
        state.didSet?(state.wrappedValue)
        return self
    }
    
    @discardableResult
    public func image(_ state: SBinding<UIImage>, for controlState: UIControl.State = .normal) -> Self {
        state.didSet = { [weak self] newImage in
            self?.setImage(newImage, for: controlState)
        }
        
        state.didSet?(state.wrappedValue)
        return self
    }
    
    @discardableResult
    public func image(systemName state: SBinding<String?>, defaultImageName: String? = nil, for controlState: UIControl.State = .normal) -> Self {
        if #available(iOS 13.0, *) {
            state.didSet = { [weak self] newSystemName in
                if let systemName = newSystemName, let image = UIImage(systemName: systemName) {
                    self?.setImage(image, for: controlState)
                }
            }
        } else {
            guard let defaultImageName = defaultImageName, let image = UIImage(named: defaultImageName) else {
                return self
            }
            state.didSet = { [weak self] _ in
                self?.setImage(image, for: controlState)
            }
        }
        
        state.didSet?(state.wrappedValue)
        return self
    }
    
    @discardableResult
    public func image(_ name: SBinding<String?>, tintColor: SBinding<UIColor>, for controlState: UIControl.State = .normal) -> Self {
        name.didSet = { [weak self] newName in
            guard let imageName = newName, let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate) else {
                return
            }
            self?.setImage(image, for: controlState)
        }
        
        tintColor.didSet = { [weak self] newTintColor in
            self?.tintColor = newTintColor
        }
        
        name.didSet?(name.wrappedValue)
        tintColor.didSet?(tintColor.wrappedValue)
        
        return self
    }
    
    @discardableResult
    public func image(systemName state: SBinding<String?>, defaultImageName: String? = nil, tintColor: SBinding<UIColor>, for controlState: UIControl.State = .normal) -> Self {
        if #available(iOS 13.0, *) {
            state.didSet = { [weak self] newSystemName in
                guard let systemName = newSystemName, let image = UIImage(systemName: systemName)?.withRenderingMode(.alwaysTemplate) else {
                    return
                }
                self?.setImage(image, for: controlState)
            }
        } else {
            guard let defaultImageName = defaultImageName, let image = UIImage(named: defaultImageName)?.withRenderingMode(.alwaysTemplate) else {
                return self
            }
            state.didSet = { [weak self] _ in
                self?.setImage(image, for: controlState)
            }
        }
        
        tintColor.didSet = { [weak self] newTintColor in
            self?.tintColor = newTintColor
        }
        
        state.didSet?(state.wrappedValue)
        tintColor.didSet?(tintColor.wrappedValue)
        
        return self
    }
    
    @discardableResult
    public func image(_ name: SBinding<String?>, at position: ImagePosition, spacing: CGFloat = 0, for controlState: UIControl.State = .normal) -> Self {
        name.didSet = { [weak self] newName in
            guard let imageName = newName, let image = UIImage(named: imageName) else {
                return
            }
            self?.setImage(image, for: controlState)
            self?.positionImage(imagePosition: position, spacing: spacing)
        }
        
        name.didSet?(name.wrappedValue)
        
        return self
    }

    @discardableResult
    public func image(_ image: SBinding<UIImage?>, at position: ImagePosition, spacing: CGFloat = 0, for controlState: UIControl.State = .normal) -> Self {
        image.didSet = { [weak self] newImage in
            guard let image = newImage else {
                return
            }
            self?.setImage(image, for: controlState)
            self?.positionImage(imagePosition: position, spacing: spacing)
        }
        
        image.didSet?(image.wrappedValue)
        
        return self
    }
    
    @discardableResult
    public func image(systemName name: SBinding<String?>, at position: ImagePosition, spacing: CGFloat = 0, for controlState: UIControl.State = .normal) -> Self {
        if #available(iOS 13.0, *) {
            name.didSet = { [weak self] newName in
                guard let systemName = newName, let image = UIImage(systemName: systemName) else {
                    return
                }
                self?.setImage(image, for: controlState)
                self?.positionImage(imagePosition: position, spacing: spacing)
            }
        } else {
            guard let defaultImageName = name.wrappedValue, let image = UIImage(named: defaultImageName) else {
                return self
            }
            name.didSet = { [weak self] _ in
                self?.setImage(image, for: controlState)
                self?.positionImage(imagePosition: position, spacing: spacing)
            }
        }
        
        name.didSet?(name.wrappedValue)
        
        return self
    }
    
    @discardableResult
    public func image(_ name: SBinding<String?>, at position: ImagePosition, spacing: CGFloat = 0, tintColor: SBinding<UIColor>, for controlState: UIControl.State = .normal) -> Self {
        name.didSet = { [weak self] newName in
            guard let imageName = newName, let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate) else {
                return
            }
            self?.setImage(image, for: controlState)
            self?.positionImage(imagePosition: position, spacing: spacing)
        }
        
        tintColor.didSet = { [weak self] newTintColor in
            self?.tintColor = newTintColor
        }
        
        name.didSet?(name.wrappedValue)
        tintColor.didSet?(tintColor.wrappedValue)
        
        return self
    }
    
    @discardableResult
    public func image(systemName name: SBinding<String?>, at position: ImagePosition, spacing: CGFloat = 0, tintColor: SBinding<UIColor>, for controlState: UIControl.State = .normal) -> Self {
        if #available(iOS 13.0, *) {
            name.didSet = { [weak self] newName in
                guard let systemName = newName, let image = UIImage(systemName: systemName)?.withRenderingMode(.alwaysTemplate) else {
                    return
                }
                self?.setImage(image, for: controlState)
                self?.positionImage(imagePosition: position, spacing: spacing)
            }
        } else {
            guard let defaultImageName = name.wrappedValue, let image = UIImage(named: defaultImageName)?.withRenderingMode(.alwaysTemplate) else {
                return self
            }
            name.didSet = { [weak self] _ in
                self?.setImage(image, for: controlState)
                self?.positionImage(imagePosition: position, spacing: spacing)
            }
        }
        
        tintColor.didSet = { [weak self] newTintColor in
            self?.tintColor = newTintColor
        }
        
        name.didSet?(name.wrappedValue)
        tintColor.didSet?(tintColor.wrappedValue)
        
        return self
    }
    
    @discardableResult
    public func font(size: CGFloat, weight: UIFont.Weight = .regular) -> Self {
        self.titleLabel?.font = UIFont.systemFont(ofSize: size, weight: weight)
        return self
    }
    
    @discardableResult
    public func font(size: SBinding<CGFloat?>, weight: SBinding<UIFont.Weight?> = SBinding(wrappedValue: .regular)) -> UIButton {
        size.didSet = { [weak self] newSize in
            guard let newSize = newSize else { return }
            let currentWeight = weight.wrappedValue ?? .regular
            self?.titleLabel?.font = UIFont.systemFont(ofSize: newSize, weight: currentWeight)
        }

        weight.didSet = { [weak self] newWeight in
            guard let newWeight = newWeight else { return }
            let currentSize = size.wrappedValue ?? UIFont.systemFontSize
            self?.titleLabel?.font = UIFont.systemFont(ofSize: currentSize, weight: newWeight)
        }

        size.didSet?(size.wrappedValue)
        weight.didSet?(weight.wrappedValue)

        return self
    }
    
    @discardableResult
    public func isEnabled(_ isEnabled: Bool = true) -> Self {
        self.isEnabled = isEnabled
        return self
    }
    
    @discardableResult
    public func isEnabled(_ isEnabled: SBinding<Bool>) -> Self {
        isEnabled.didSet = { [weak self] newIsEnabled in
            self?.isEnabled = newIsEnabled
        }
        isEnabled.didSet?(isEnabled.wrappedValue)
        return self
    }
}

extension Button {
    @discardableResult
    public func image(_ name: String, tintColor: UInt, for state: UIControl.State = .normal) -> Self {
        let color = UIColor(hex: UInt32(tintColor))
        if let image = UIImage(named: name)?.withRenderingMode(.alwaysTemplate) {
            setImage(image, for: state)
            self.tintColor = color
        }
        return self
    }
    
    @discardableResult
    public func image(_ name: SBinding<String?>, tintColor: UInt, for controlState: UIControl.State = .normal) -> Self {
        name.didSet = { [weak self] newName in
            guard let imageName = newName, let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate) else {
                return
            }
            self?.setImage(image, for: controlState)
        }
        
        let color = UIColor(hex: UInt32(tintColor))
        self.tintColor = color
        
        name.didSet?(name.wrappedValue)
        
        return self
    }
}

extension Button {
    @discardableResult
    public func background(_ color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
    
    @discardableResult
    public func background(_ hex: UInt) -> Self {
        let color = UIColor(hex: UInt32(hex))
        return background(color)
    }
    
    @discardableResult
    public func isHidden(_ bool: Bool = true) -> Self {
        self.isHidden = bool
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
}

extension Button {
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
    public func shadow(color: UIColor, radius: CGFloat, opacity: Float, offset: CGSize) -> Self {
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.masksToBounds = false
        return self
    }
    
    @discardableResult
    public func shadow(color: UInt, radius: CGFloat, opacity: Float, offset: CGSize) -> Self {
        let hexColor = UIColor(hex: UInt32(color))
        layer.shadowColor = hexColor.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.masksToBounds = false
        return self
    }
}

