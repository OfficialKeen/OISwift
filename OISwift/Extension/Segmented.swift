//
//  Segmented.swift
//  OISwift
//
//  Created by keenoi on 18/05/24.
//


/*import UIKit

extension UISegmentedControl {
    @discardableResult
    public func items(_ items: [String]) -> UISegmentedControl {
        removeAllSegments()
        for (index, title) in items.enumerated() {
            insertSegment(withTitle: title, at: index, animated: false)
        }
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ radius: CGFloat) -> UISegmentedControl {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        return self
    }
    
    @discardableResult
    public func setDefaultIndex(_ index: Int) -> UISegmentedControl {
        selectedSegmentIndex = index
        return self
    }
    
    @discardableResult
    public func selectedColor(_ hex: UInt) -> UISegmentedControl {
        if #available(iOS 13.0, *) {
            selectedSegmentTintColor = UIColor(hex: UInt32(hex))
        } else {
            // Fallback on earlier versions
        }
        return self
    }
    
    @discardableResult
    public func selectedColor(_ color: UIColor) -> UISegmentedControl {
        if #available(iOS 13.0, *) {
            selectedSegmentTintColor = color
        } else {
            // Fallback on earlier versions
        }
        return self
    }
    
    @discardableResult
    public func titleSelectColor(_ hex: UInt) -> UISegmentedControl {
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hex: UInt32(hex))], for: .selected)
        return self
    }
    
    @discardableResult
    public func titleSelectColor(_ color: UIColor) -> UISegmentedControl {
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color], for: .selected)
        return self
    }
    
    @discardableResult
    public func titleUnselectColor(_ hex: UInt) -> UISegmentedControl {
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hex: UInt32(hex))], for: .normal)
        return self
    }
    
    @discardableResult
    public func titleUnselectColor(_ color: UIColor) -> UISegmentedControl {
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color], for: .normal)
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ hex: UInt) -> UISegmentedControl {
        tintColor = UIColor(hex: UInt32(hex))
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ color: UIColor) -> UISegmentedControl {
        tintColor = color
        return self
    }
    
    @discardableResult
    public func fontSize(_ size: CGFloat) -> UISegmentedControl {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: size)]
        setTitleTextAttributes(attributes, for: .normal)
        return self
    }
    
    @discardableResult
    public func fontSize(_ size: CGFloat, weight: UIFont.Weight) -> UISegmentedControl {
        let font = UIFont.systemFont(ofSize: size, weight: weight)
        let attributes = [NSAttributedString.Key.font: font]
        setTitleTextAttributes(attributes, for: .normal)
        return self
    }
    
    @discardableResult
    public func isMomentary(_ value: Bool) -> UISegmentedControl {
        isMomentary = value
        return self
    }
    
    @discardableResult
    public func isEnabled(_ value: Bool) -> UISegmentedControl {
        isEnabled = value
        return self
    }
    
    @discardableResult
    public func apportionsSegmentWidthsByContent(_ value: Bool) -> UISegmentedControl {
        apportionsSegmentWidthsByContent = value
        return self
    }
    
    @discardableResult
    public func setSegmentTitle(_ title: String?, forSegmentAt segment: Int) -> UISegmentedControl {
        setTitle(title, forSegmentAt: segment)
        return self
    }
    
    @discardableResult
    public func setSegmentImage(_ image: UIImage?, forSegmentAt segment: Int) -> UISegmentedControl {
        setImage(image, forSegmentAt: segment)
        return self
    }
    
    @discardableResult
    public func setSegmentWidth(_ width: CGFloat, forSegmentAt segment: Int) -> UISegmentedControl {
        setWidth(width, forSegmentAt: segment)
        return self
    }
    
    @discardableResult
    public func onValueChanged(_ closure: @escaping (Int) -> Void) -> UISegmentedControl {
        addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
        self.valueChangedClosure = closure
        
        return self
    }
    
    private var valueChangedClosure: ((Int) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.valueChangedClosure) as? (Int) -> Void
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.valueChangedClosure, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc private func valueChanged(_ segmentedControl: UISegmentedControl) {
        valueChangedClosure?(segmentedControl.selectedSegmentIndex)
    }
}

private struct AssociatedKeys {
    static var valueChangedClosure: UInt8 = 0
}

extension UISegmentedControl {
    @discardableResult
    public func items(_ items: SBinding<[String]>) -> UISegmentedControl {
        items.didSet = { [weak self] newItems in
            self?.removeAllSegments()
            for (index, title) in newItems.enumerated() {
                self?.insertSegment(withTitle: title, at: index, animated: false)
            }
        }
        items.didSet?(items.wrappedValue)
        return self
    }
    
    @discardableResult
    public func setDefaultIndex(_ index: SBinding<Int>) -> UISegmentedControl {
        index.didSet = { [weak self] newIndex in
            self?.selectedSegmentIndex = newIndex
        }
        index.didSet?(index.wrappedValue)
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
*/

import UIKit

public class Segmented: UISegmentedControl {
    private struct Keys {
        static var textsKey  = "texts"
        static var imagesKey = "images"
    }
    @available(iOS 13.0, *)
    @discardableResult
    public func items(texts: [String], images: [UIImage?]) -> Segmented {
        guard texts.count == images.count else { return self }
        
        // simpan di associated object
        objc_setAssociatedObject(self, &Keys.textsKey,  texts,  .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(self, &Keys.imagesKey, images, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        // reset & isi gambar dulu
        removeAllSegments()
        images.enumerated().forEach { insertSegment(with: $1, at: $0, animated: false) }
        
        // listener
        removeTarget(self, action: #selector(updateSegments), for: .valueChanged)
        addTarget(self, action: #selector(updateSegments), for: .valueChanged)
        
        selectedSegmentIndex = 0
        updateSegments()
        return self
    }
    @available(iOS 13.0, *)
    @objc private func updateSegments() {
        guard
            let texts  = objc_getAssociatedObject(self, &Keys.textsKey)  as? [String],
            let images = objc_getAssociatedObject(self, &Keys.imagesKey) as? [UIImage?]
        else { return }
        
        for idx in 0..<numberOfSegments {
            let img = idx == selectedSegmentIndex
            ? titleImage(texts[idx])
            : images[idx]
            setImage(img, forSegmentAt: idx)
        }
    }
    @available(iOS 13.0, *)
    private func titleImage(_ string: String,
                            font: UIFont = .systemFont(ofSize: 14, weight: .semibold),
                            color: UIColor = .label) -> UIImage? {
        let size = (string as NSString).size(withAttributes: [.font: font])
        return UIGraphicsImageRenderer(size: size).image { _ in
            (string as NSString).draw(at: .zero,
                                      withAttributes: [.font: font,
                                                       .foregroundColor: color])
        }
    }
    
    @discardableResult
    public func items(_ items: [String]) -> Segmented {
        removeAllSegments()
        for (index, title) in items.enumerated() {
            insertSegment(withTitle: title, at: index, animated: false)
        }
        return self
    }
    
    @discardableResult
    public func items(_ images: [UIImage?]) -> Segmented {
        removeAllSegments()
        for (index, image) in images.enumerated() {
            insertSegment(with: image, at: index, animated: false)
        }
        return self
    }
    
    @discardableResult
    public func imageSize(width: CGFloat? = nil, height: CGFloat? = nil) -> Segmented {
        for index in 0..<numberOfSegments {
            if let image = imageForSegment(at: index) {
                let resizedImage = image.resizedSegmentedImage(toWidth: width, height: height)
                setSegmentImage(resizedImage, forSegmentAt: index)
            }
        }
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ radius: CGFloat) -> Segmented {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        return self
    }
    
    @discardableResult
    public func setDefaultIndex(_ index: Int) -> Segmented {
        selectedSegmentIndex = index
        return self
    }
    
    @discardableResult
    public func selectedColor(_ hex: UInt) -> Segmented {
        if #available(iOS 13.0, *) {
            selectedSegmentTintColor = UIColor(hex: UInt32(hex))
        } else {
            // Fallback on earlier versions
        }
        return self
    }
    
    @discardableResult
    public func selectedColor(_ color: UIColor) -> Segmented {
        if #available(iOS 13.0, *) {
            selectedSegmentTintColor = color
        } else {
            // Fallback on earlier versions
        }
        return self
    }
    
    @discardableResult
    public func titleSelectColor(_ hex: UInt) -> Segmented {
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hex: UInt32(hex))], for: .selected)
        return self
    }
    
    @discardableResult
    public func titleSelectColor(_ color: UIColor) -> Segmented {
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color], for: .selected)
        return self
    }
    
    @discardableResult
    public func titleUnselectColor(_ hex: UInt) -> Segmented {
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hex: UInt32(hex))], for: .normal)
        return self
    }
    
    @discardableResult
    public func titleUnselectColor(_ color: UIColor) -> Segmented {
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color], for: .normal)
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ hex: UInt) -> Segmented {
        tintColor = UIColor(hex: UInt32(hex))
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ color: UIColor) -> Segmented {
        tintColor = color
        return self
    }
    
    @discardableResult
    public func fontSize(_ size: CGFloat) -> Segmented {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: size)]
        setTitleTextAttributes(attributes, for: .normal)
        return self
    }
    
    @discardableResult
    public func fontSize(_ size: CGFloat, weight: UIFont.Weight) -> Segmented {
        let font = UIFont.systemFont(ofSize: size, weight: weight)
        let attributes = [NSAttributedString.Key.font: font]
        setTitleTextAttributes(attributes, for: .normal)
        return self
    }
    
    @discardableResult
    public func isMomentary(_ value: Bool) -> Segmented {
        isMomentary = value
        return self
    }
    
    @discardableResult
    public func isEnabled(_ value: Bool) -> Segmented {
        isEnabled = value
        return self
    }
    
    @discardableResult
    public func apportionsSegmentWidthsByContent(_ value: Bool) -> Segmented {
        apportionsSegmentWidthsByContent = value
        return self
    }
    
    @discardableResult
    public func setSegmentTitle(_ title: String?, forSegmentAt segment: Int) -> Segmented {
        setTitle(title, forSegmentAt: segment)
        return self
    }
    
    @discardableResult
    public func setSegmentImage(_ image: UIImage?, forSegmentAt segment: Int) -> Segmented {
        setImage(image, forSegmentAt: segment)
        return self
    }
    
    @discardableResult
    public func setSegmentWidth(_ width: CGFloat, forSegmentAt segment: Int) -> Segmented {
        setWidth(width, forSegmentAt: segment)
        return self
    }
    
    @discardableResult
    public func onValueChanged(_ closure: @escaping (Int) -> Void) -> Segmented {
        addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
        self.valueChangedClosure = closure
        
        return self
    }
    
    private var valueChangedClosure: ((Int) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.valueChangedClosure) as? (Int) -> Void
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.valueChangedClosure, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc private func valueChanged(_ segmentedControl: Segmented) {
        valueChangedClosure?(segmentedControl.selectedSegmentIndex)
    }
}

private struct AssociatedKeys {
    static var valueChangedClosure: UInt8 = 0
}

extension Segmented {
    @discardableResult
    public func items(_ items: SBinding<[String]>) -> Segmented {
        items.didSet = { [weak self] newItems in
            self?.removeAllSegments()
            for (index, title) in newItems.enumerated() {
                self?.insertSegment(withTitle: title, at: index, animated: false)
            }
        }
        items.didSet?(items.wrappedValue)
        return self
    }
    
    @discardableResult
    public func setDefaultIndex(_ index: SBinding<Int>) -> Segmented {
        index.didSet = { [weak self] newIndex in
            self?.selectedSegmentIndex = newIndex
        }
        index.didSet?(index.wrappedValue)
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
    
    @discardableResult
    public func width(_ width: CGFloat) -> Segmented {
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }
    
    @discardableResult
    public func height(_ height: CGFloat) -> Segmented {
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult
    public func isHidden(_ bool: Bool = true) -> Segmented {
        self.isHidden = bool
        return self
    }
    
    @discardableResult
    public func isHidden(_ state: SBinding<Bool>) -> Segmented {
        self.isHidden = state.wrappedValue
        state.didSet = { [weak self] newValue in
            self?.isHidden = newValue
        }
        return self
    }
}

extension UIImage {
    func resizedSegmentedImage(toWidth width: CGFloat? = nil, height: CGFloat? = nil) -> UIImage {
        let originalSize = self.size
        let newWidth = width ?? originalSize.width
        let newHeight = height ?? originalSize.height
        
        let newSize = CGSize(width: newWidth, height: newHeight)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? self
    }
}
