//
//  Image.swift
//  OISwift
//
//  Created by keenoi on 18/05/24.
//

/*import UIKit

extension UIImageView {
    @discardableResult
    public func image(_ name: String) -> Self {
        self.image = UIImage(named: name)
        return self
    }
    
    @discardableResult
    public func image(systemName: String) -> Self {
        if #available(iOS 13.0, *) {
            self.image = UIImage(systemName: systemName)
        } else {
            // Fallback on earlier versions
        }
        return self
    }
    
    @discardableResult
    public func renderingMode(_ renderingMode: UIImage.RenderingMode) -> Self {
        self.image = self.image?.withRenderingMode(renderingMode)
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
    
    public func foregroundColor(_ hex: UInt) -> Self {
        let color = UIColor(hex: UInt32(hex))
        self.tintColor = color
        return self
    }
    
    @discardableResult
    public func resizable() -> Self {
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        return self
    }
    
    @discardableResult
    public func scaledToFill() -> Self {
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        return self
    }
    
    @discardableResult
    public func scaledToFit() -> Self {
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = true
        return self
    }
    
    @discardableResult
    public func clipped() -> Self {
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        return self
    }
    
    @discardableResult
    public func aspectRatio(aspectRatio: CGSize? = nil, contentMode: UIView.ContentMode) -> Self {
        self.contentMode = contentMode
        self.clipsToBounds = true
        
        if let aspectRatio = aspectRatio, aspectRatio.width > 0, aspectRatio.height > 0 {
            self.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: aspectRatio.width / aspectRatio.height).isActive = true
        } else if let aspectRatio = aspectRatio, aspectRatio.height > 0, aspectRatio.width > 0 {
            self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: aspectRatio.height / aspectRatio.width).isActive = true
        }
        
        return self
    }
    
    public enum Alignment {
        case center
        case leading
        case trailing
    }
    
    @discardableResult
    public func frame(width: CGFloat?, height: CGFloat?, alignment: Alignment? = nil) -> Self {
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let alignment = alignment {
            switch alignment {
            case .center:
                self.center = superview?.center ?? CGPoint.zero
            case .leading:
                self.frame.origin.x = 0
            case .trailing:
                if let superviewWidth = superview?.frame.width {
                    self.frame.origin.x = superviewWidth - self.frame.width
                }
            }
        }
        
        return self
    }
    
    @discardableResult
    public func frame(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        minWidth: CGFloat? = nil,
        idealWidth: CGFloat? = nil,
        maxWidth: CGFloat? = nil,
        minHeight: CGFloat? = nil,
        idealHeight: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        alignment: Alignment? = nil
    ) -> Self {
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let minWidth = minWidth {
            self.widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth).isActive = true
        }
        
        if let idealWidth = idealWidth {
            self.widthAnchor.constraint(equalToConstant: idealWidth).priority = .defaultHigh
        }
        
        if let maxWidth = maxWidth {
            self.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth).isActive = true
        }
        
        if let minHeight = minHeight {
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight).isActive = true
        }
        
        if let idealHeight = idealHeight {
            self.heightAnchor.constraint(equalToConstant: idealHeight).priority = .defaultHigh
        }
        
        if let maxHeight = maxHeight {
            self.heightAnchor.constraint(lessThanOrEqualToConstant: maxHeight).isActive = true
        }
        
        if let alignment = alignment {
            switch alignment {
            case .center:
                self.center = superview?.center ?? CGPoint.zero
            case .leading:
                self.frame.origin.x = 0
            case .trailing:
                if let superviewWidth = superview?.frame.width {
                    self.frame.origin.x = superviewWidth - self.frame.width
                }
            }
        }
        
        return self
    }
}

extension UIImageView {
    @discardableResult
    public func image(_ state: SBinding<UIImage?>) -> Self {
        state.didSet = { [weak self] newImage in
            self?.image = newImage
        }
        state.didSet?(state.wrappedValue)
        return self
    }
    
    @discardableResult
    public func image(_ state: SBinding<String?>) -> Self {
        state.didSet = { [weak self] newImageName in
            guard let imageName = newImageName else { return }
            self?.image = UIImage(named: imageName)
        }
        state.didSet?(state.wrappedValue)
        return self
    }
    
    @discardableResult
    public func image(systemName: SBinding<String?>) -> Self {
        if #available(iOS 13.0, *) {
            systemName.didSet = { [weak self] newImageName in
                guard let imageName = newImageName else { return }
                self?.image = UIImage(systemName: imageName)
            }
        } else {
            guard let defaultImageName = systemName.wrappedValue else {
                return self
            }
            let image = UIImage(named: defaultImageName)
            systemName.didSet = { [weak self] _ in
                self?.image = image
            }
        }
        
        systemName.didSet?(systemName.wrappedValue)
        return self
    }
    
    @discardableResult
    public func image(systemName: SBinding<UIImage?>) -> Self {
        systemName.didSet = { [weak self] newImage in
            self?.image = newImage
        }
        systemName.didSet?(systemName.wrappedValue)
        return self
    }
    
    @discardableResult
    public func renderingMode(_ renderingMode: SBinding<UIImage.RenderingMode>) -> Self {
        renderingMode.didSet = { [weak self] newRenderingMode in
            self?.image = self?.image?.withRenderingMode(newRenderingMode)
        }
        renderingMode.didSet?(renderingMode.wrappedValue)
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ color: SBinding<UIColor>) -> Self {
        color.didSet = { [weak self] newColor in
            self?.tintColor = newColor
        }
        color.didSet?(color.wrappedValue)
        return self
    }
    
    public func foregroundColor(_ hex: SBinding<UInt>) -> Self {
        hex.didSet = { [weak self] newHex in
            let color = UIColor(hex: UInt32(newHex))
            self?.tintColor = color
        }
        hex.didSet?(hex.wrappedValue)
        return self
    }
    
    @discardableResult
    public func image(_ state: SBinding<UIImage?>, renderingModeState: SBinding<UIImage.RenderingMode?> = SBinding<UIImage.RenderingMode?>(wrappedValue: nil)) -> Self {
        state.didSet = { [weak self] newImage in
            self?.image = newImage
        }
        state.didSet?(state.wrappedValue)
        
        renderingModeState.didSet = { [weak self] newRenderingMode in
            guard let renderingMode = newRenderingMode else { return }
            self?.image = self?.image?.withRenderingMode(renderingMode)
        }
        renderingModeState.didSet?(renderingModeState.wrappedValue)
        return self
    }
    
    @discardableResult
    public func image(_ state: SBinding<String?>, renderingModeState: SBinding<UIImage.RenderingMode?> = SBinding<UIImage.RenderingMode?>(wrappedValue: nil)) -> Self {
        state.didSet = { [weak self] newImageName in
            guard let imageName = newImageName else { return }
            self?.image = UIImage(named: imageName)
        }
        state.didSet?(state.wrappedValue)
        
        renderingModeState.didSet = { [weak self] newRenderingMode in
            guard let renderingMode = newRenderingMode else { return }
            self?.image = self?.image?.withRenderingMode(renderingMode)
        }
        renderingModeState.didSet?(renderingModeState.wrappedValue)
        return self
    }
    
    @discardableResult
    public func image(_ name: String, _ renderingMode: UIImage.RenderingMode = .alwaysTemplate) -> Self {
        self.image = UIImage(named: name)
        self.image = self.image?.withRenderingMode(renderingMode)
        return self
    }
    
    @discardableResult
    public func image(systemName: String, _ renderingMode: UIImage.RenderingMode = .alwaysTemplate) -> Self {
        self.image = UIImage(named: systemName)
        self.image = self.image?.withRenderingMode(renderingMode)
        return self
    }
}*/

import UIKit

public class Image: UIImageView {
    @discardableResult
    public func image(_ name: String) -> Self {
        self.image = UIImage(named: name)
        return self
    }
    
    @discardableResult
    public func image(systemName: String) -> Self {
        if #available(iOS 13.0, *) {
            self.image = UIImage(systemName: systemName)
        } else {
            // Fallback on earlier versions
        }
        return self
    }
    
    @discardableResult
    public func renderingMode(_ renderingMode: UIImage.RenderingMode) -> Self {
        self.image = self.image?.withRenderingMode(renderingMode)
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ hex: UInt) -> Self {
        let color = UIColor(hex: UInt32(hex))
        self.tintColor = color
        return self
    }
    
    @discardableResult
    public func resizable() -> Self {
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        return self
    }
    
    @discardableResult
    public func scaledToFill() -> Self {
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        return self
    }
    
    @discardableResult
    public func scaledToFit() -> Self {
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = true
        return self
    }
    
    @discardableResult
    public func clipped() -> Self {
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        return self
    }
    
    @discardableResult
    public func aspectRatio(aspectRatio: CGSize? = nil, contentMode: UIView.ContentMode) -> Self {
        self.contentMode = contentMode
        self.clipsToBounds = true
        
        if let aspectRatio = aspectRatio, aspectRatio.width > 0, aspectRatio.height > 0 {
            self.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: aspectRatio.width / aspectRatio.height).isActive = true
        } else if let aspectRatio = aspectRatio, aspectRatio.height > 0, aspectRatio.width > 0 {
            self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: aspectRatio.height / aspectRatio.width).isActive = true
        }
        
        return self
    }
    
    public enum Alignment {
        case center
        case leading
        case trailing
    }
    
    @discardableResult
    public func frame(width: CGFloat?, height: CGFloat?, alignment: Alignment? = nil) -> Self {
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let alignment = alignment {
            switch alignment {
            case .center:
                self.center = superview?.center ?? CGPoint.zero
            case .leading:
                self.frame.origin.x = 0
            case .trailing:
                if let superviewWidth = superview?.frame.width {
                    self.frame.origin.x = superviewWidth - self.frame.width
                }
            }
        }
        
        return self
    }
    
    @discardableResult
    public func frame(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        minWidth: CGFloat? = nil,
        idealWidth: CGFloat? = nil,
        maxWidth: CGFloat? = nil,
        minHeight: CGFloat? = nil,
        idealHeight: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        alignment: Alignment? = nil
    ) -> Self {
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let minWidth = minWidth {
            self.widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth).isActive = true
        }
        
        if let idealWidth = idealWidth {
            self.widthAnchor.constraint(equalToConstant: idealWidth).priority = .defaultHigh
        }
        
        if let maxWidth = maxWidth {
            self.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth).isActive = true
        }
        
        if let minHeight = minHeight {
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight).isActive = true
        }
        
        if let idealHeight = idealHeight {
            self.heightAnchor.constraint(equalToConstant: idealHeight).priority = .defaultHigh
        }
        
        if let maxHeight = maxHeight {
            self.heightAnchor.constraint(lessThanOrEqualToConstant: maxHeight).isActive = true
        }
        
        if let alignment = alignment {
            switch alignment {
            case .center:
                self.center = superview?.center ?? CGPoint.zero
            case .leading:
                self.frame.origin.x = 0
            case .trailing:
                if let superviewWidth = superview?.frame.width {
                    self.frame.origin.x = superviewWidth - self.frame.width
                }
            }
        }
        
        return self
    }
}

extension Image {
    @discardableResult
    public func image(_ state: SBinding<UIImage?>) -> Self {
        state.didSet = { [weak self] newImage in
            self?.image = newImage
        }
        state.didSet?(state.wrappedValue)
        return self
    }
    
    @discardableResult
    public func image(_ state: SBinding<String?>) -> Self {
        state.didSet = { [weak self] newImageName in
            guard let imageName = newImageName else { return }
            self?.image = UIImage(named: imageName)
        }
        state.didSet?(state.wrappedValue)
        return self
    }
    
    @discardableResult
    public func image(systemName: SBinding<String?>) -> Self {
        if #available(iOS 13.0, *) {
            systemName.didSet = { [weak self] newImageName in
                guard let imageName = newImageName else { return }
                self?.image = UIImage(systemName: imageName)
            }
        } else {
            guard let defaultImageName = systemName.wrappedValue else {
                return self
            }
            let image = UIImage(named: defaultImageName)
            systemName.didSet = { [weak self] _ in
                self?.image = image
            }
        }
        
        systemName.didSet?(systemName.wrappedValue)
        return self
    }
    
    @discardableResult
    public func image(systemName: SBinding<UIImage?>) -> Self {
        systemName.didSet = { [weak self] newImage in
            self?.image = newImage
        }
        systemName.didSet?(systemName.wrappedValue)
        return self
    }
    
    @discardableResult
    public func renderingMode(_ renderingMode: SBinding<UIImage.RenderingMode>) -> Self {
        renderingMode.didSet = { [weak self] newRenderingMode in
            self?.image = self?.image?.withRenderingMode(newRenderingMode)
        }
        renderingMode.didSet?(renderingMode.wrappedValue)
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ color: SBinding<UIColor>) -> Self {
        color.didSet = { [weak self] newColor in
            self?.tintColor = newColor
        }
        color.didSet?(color.wrappedValue)
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ hex: SBinding<UInt>) -> Self {
        hex.didSet = { [weak self] newHex in
            let color = UIColor(hex: UInt32(newHex))
            self?.tintColor = color
        }
        hex.didSet?(hex.wrappedValue)
        return self
    }
    
    @discardableResult
    public func image(_ state: SBinding<UIImage?>, renderingModeState: SBinding<UIImage.RenderingMode?> = SBinding<UIImage.RenderingMode?>(wrappedValue: nil)) -> Self {
        state.didSet = { [weak self] newImage in
            self?.image = newImage
        }
        state.didSet?(state.wrappedValue)
        
        renderingModeState.didSet = { [weak self] newRenderingMode in
            guard let renderingMode = newRenderingMode else { return }
            self?.image = self?.image?.withRenderingMode(renderingMode)
        }
        renderingModeState.didSet?(renderingModeState.wrappedValue)
        return self
    }
    
    @discardableResult
    public func image(_ state: SBinding<String?>, renderingModeState: SBinding<UIImage.RenderingMode?> = SBinding<UIImage.RenderingMode?>(wrappedValue: nil)) -> Self {
        state.didSet = { [weak self] newImageName in
            guard let imageName = newImageName else { return }
            self?.image = UIImage(named: imageName)
        }
        state.didSet?(state.wrappedValue)
        
        renderingModeState.didSet = { [weak self] newRenderingMode in
            guard let renderingMode = newRenderingMode else { return }
            self?.image = self?.image?.withRenderingMode(renderingMode)
        }
        renderingModeState.didSet?(renderingModeState.wrappedValue)
        return self
    }
    
    @discardableResult
    public func image(_ name: String, _ renderingMode: UIImage.RenderingMode = .alwaysTemplate) -> Self {
        self.image = UIImage(named: name)
        self.image = self.image?.withRenderingMode(renderingMode)
        return self
    }
    
    @discardableResult
    public func image(systemName: String, _ renderingMode: UIImage.RenderingMode = .alwaysTemplate) -> Self {
        self.image = UIImage(named: systemName)
        self.image = self.image?.withRenderingMode(renderingMode)
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
}
