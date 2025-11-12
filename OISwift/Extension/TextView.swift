//
//  TextView.swift
//  OISwift
//
//  Created by keenoi on 18/05/24.
//

/*import UIKit

extension UITextView {
    @discardableResult
    public func text(_ text: String) -> Self {
        self.text = text
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    public func foregroundColor(_ hex: UInt32) -> Self {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        self.textColor = color
        return self
    }
    
    @discardableResult
    public func tintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
    
    public func tintColor(_ hex: UInt32) -> Self {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        self.tintColor = color
        return self
    }
    
    @discardableResult
    public func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    @discardableResult
    public func font(_ size: CGFloat = 16, weight: UIFont.Weight = .regular, design: FontDesign = .default) -> Self {
        let traits: [UIFontDescriptor.TraitKey: Any] = [.weight: weight]

        let fontDescriptor = UIFontDescriptor(fontAttributes: [
            .family: design.fontName,
            .traits: traits
        ])

        self.font = UIFont(descriptor: fontDescriptor, size: size)
        return self
    }

    @discardableResult
    public func font(_ style: UIFont.TextStyle) -> Self {
        self.font = UIFont.preferredFont(forTextStyle: style)
        return self
    }
    
    @discardableResult
    public func alignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }
    
    @discardableResult
    public func padding(_ value: CGFloat) -> Self {
        let insets = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
        self.textContainerInset = insets
        return self
    }
    
    private var placeholderLabel: UILabel? {
        return self.viewWithTag(100) as? UILabel
    }
    
    @discardableResult
    func placeholder(_ text: String, fontSize: CGFloat? = nil, font: UIFont? = nil, position: CGPoint) -> Self {
        let placeholderLabel = UILabel()
        placeholderLabel.font = font ?? self.font // Gunakan font default jika tidak diberikan
        placeholderLabel.textColor = UIColor.purple
        placeholderLabel.text = text
        placeholderLabel.font = placeholderLabel.font.withSize(fontSize ?? 16) // Gunakan ukuran font default 17 jika tidak diberikan
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = position // Mengatur posisi placeholder sesuai parameter
        placeholderLabel.tag = 100 // for accessing the placeholder label later
        self.addSubview(placeholderLabel)
        
        // Menambahkan observer untuk notifikasi ketika teks berubah
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
        
        return self
    }
    
    @objc private func textDidChange() {
        // Sembunyikan placeholder jika terdapat teks
        placeholderLabel?.isHidden = !self.text.isEmpty
    }
}*/

import UIKit

public class TextView: UITextView, UITextViewDelegate {
    private var textBinding: SBinding<String>?

    @discardableResult
    public func text(_ text: String) -> Self {
        self.text = text
        return self
    }
    
    @discardableResult
    public func text(_ state: SBinding<String>) -> Self {
        self.text = state.wrappedValue
        self.textBinding = state
        state.didSet = { [weak self] newText in
            self?.text = newText
        }
        self.delegate = self // Set the delegate to self to capture text changes
        return self
    }

    public func textViewDidChange(_ textView: UITextView) {
        textBinding?.wrappedValue = textView.text
    }
    
    @discardableResult
    public func foregroundColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ hex: UInt32) -> Self {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        self.textColor = color
        return self
    }
    
    @discardableResult
    public func tintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
    
    @discardableResult
    public func tintColor(_ hex: UInt32) -> Self {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        self.tintColor = color
        return self
    }
    
    @discardableResult
    public func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    @discardableResult
    public func font(_ size: CGFloat = 16, weight: UIFont.Weight = .regular, design: FontDesign = .default) -> Self {
        let traits: [UIFontDescriptor.TraitKey: Any] = [.weight: weight]

        let fontDescriptor = UIFontDescriptor(fontAttributes: [
            .family: design.fontName,
            .traits: traits
        ])

        self.font = UIFont(descriptor: fontDescriptor, size: size)
        return self
    }

    @discardableResult
    public func font(_ style: UIFont.TextStyle) -> Self {
        self.font = UIFont.preferredFont(forTextStyle: style)
        return self
    }
    
    @discardableResult
    public func alignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }
    
    @discardableResult
    public func padding(_ value: CGFloat) -> Self {
        let insets = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
        self.textContainerInset = insets
        return self
    }
    
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
    public func cornerRadius(_ radius: CGFloat? = nil) -> Self {
        self.layer.cornerRadius = radius ?? 0
        self.layer.masksToBounds = true
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
    
    private var placeholderLabel: UILabel? {
        return self.viewWithTag(100) as? UILabel
    }
    
    @discardableResult
    public func placeholder(_ text: String, fontSize: CGFloat? = nil, font: UIFont? = nil, position: CGPoint) -> Self {
        let placeholderLabel = UILabel()
        placeholderLabel.font = font ?? self.font
        placeholderLabel.textColor = UIColor.purple
        placeholderLabel.text = text
        placeholderLabel.font = placeholderLabel.font.withSize(fontSize ?? 16)
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = position
        placeholderLabel.tag = 100
        self.addSubview(placeholderLabel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
        
        return self
    }
    
    @objc private func textDidChange() {
        placeholderLabel?.isHidden = !self.text.isEmpty
    }
}
