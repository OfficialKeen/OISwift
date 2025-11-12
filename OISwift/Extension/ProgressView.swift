//
//  ProgressView.swift
//  OISwift
//
//  Created by keenoi on 18/05/24.
//

/*import UIKit

public extension UIProgressView {
    @discardableResult
    func onProgress(_ progress: Float, animated: Bool = true) -> UIProgressView {
        self.setProgress(progress, animated: animated)
        return self
    }
    
    @discardableResult
    func onProgress(_ progress: SBinding<Float>, animated: Bool = true) -> UIProgressView {
        progress.didSet = { [weak self] newProgress in
            self?.setProgress(newProgress, animated: animated)
        }
        progress.didSet?(progress.wrappedValue)
        return self
    }
    
    @discardableResult
    func onProgress(_ progress: SBinding<Float?>, animated: Bool = true) -> UIProgressView {
        progress.didSet = { [weak self] newProgress in
            self?.setProgress(newProgress ?? 0.0, animated: animated)
        }
        progress.didSet?(progress.wrappedValue)
        return self
    }
    
    @discardableResult
    func progressTintColor(_ color: UIColor) -> UIProgressView {
        self.progressTintColor = color
        return self
    }
    
    func progressTintColor(_ hex: UInt) -> UIProgressView {
        let color = UIColor(hex: UInt32(hex))
        self.progressTintColor = color
        return self
    }
    
    @discardableResult
    func trackTintColor(_ color: UIColor) -> UIProgressView {
        self.trackTintColor = color
        return self
    }
    
    func trackTintColor(_ hex: UInt) -> UIProgressView {
        let color = UIColor(hex: UInt32(hex))
        self.trackTintColor = color
        return self
    }
    
    @discardableResult
    func progressImage(_ image: UIImage?) -> UIProgressView {
        self.progressImage = image
        return self
    }
    
    @discardableResult
    func trackImage(_ image: UIImage?) -> UIProgressView {
        self.trackImage = image
        return self
    }
    
    @discardableResult
    func observedProgress(_ progress: Progress?) -> UIProgressView {
        self.observedProgress = progress
        return self
    }
    
    @discardableResult
    func progressViewStyle(_ style: UIProgressView.Style) -> UIProgressView {
        self.progressViewStyle = style
        return self
    }
}*/


import UIKit

public class ProgressView: UIProgressView {
    @discardableResult
    public func onProgress(_ progress: Float, animated: Bool = true) -> Self {
        self.setProgress(progress, animated: animated)
        return self
    }
    
    @discardableResult
    public func onProgress(_ progress: SBinding<Float>, animated: Bool = true) -> Self {
        progress.didSet = { [weak self] newProgress in
            self?.setProgress(newProgress, animated: animated)
        }
        progress.didSet?(progress.wrappedValue)
        return self
    }
    
    @discardableResult
    public func onProgress(_ progress: SBinding<Float?>, animated: Bool = true) -> Self {
        progress.didSet = { [weak self] newProgress in
            self?.setProgress(newProgress ?? 0.0, animated: animated)
        }
        progress.didSet?(progress.wrappedValue)
        return self
    }
    
    @discardableResult
    public func progressTintColor(_ color: UIColor) -> Self {
        self.progressTintColor = color
        return self
    }
    
    @discardableResult
    public func progressTintColor(_ hex: UInt) -> Self {
        let color = UIColor(hex: UInt32(hex))
        self.progressTintColor = color
        return self
    }
    
    @discardableResult
    public func trackTintColor(_ color: UIColor) -> Self {
        self.trackTintColor = color
        return self
    }
    
    @discardableResult
    public func trackTintColor(_ hex: UInt) -> Self {
        let color = UIColor(hex: UInt32(hex))
        self.trackTintColor = color
        return self
    }
    
    @discardableResult
    public func progressImage(_ image: UIImage?) -> Self {
        self.progressImage = image
        return self
    }
    
    @discardableResult
    public func trackImage(_ image: UIImage?) -> Self {
        self.trackImage = image
        return self
    }
    
    @discardableResult
    public func observedProgress(_ progress: Progress?) -> Self {
        self.observedProgress = progress
        return self
    }
    
    @discardableResult
    public func progressViewStyle(_ style: UIProgressView.Style) -> Self {
        self.progressViewStyle = style
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
}
