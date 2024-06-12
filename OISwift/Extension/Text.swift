//
//  Text.swift
//  OISwift
//
//  Created by keenoi on 18/05/24.
//

/*import UIKit

public enum FontDesign {
    case `default`
    case monospaced
    case serif
    case rounded

    var fontName: String {
        switch self {
        case .default:
            return UIFont.systemFont(ofSize: 12).familyName
        case .monospaced:
            return "Courier New"
        case .serif:
            return "Times New Roman"
        case .rounded:
            return "Arial Rounded MT Bold"
        }
    }
}

extension UILabel {
    @discardableResult
    public func text(_ text: String) -> Self {
        self.text = text
        return self
    }

    @discardableResult
    public func font(_ size: CGFloat, weight: UIFont.Weight = .regular, design: FontDesign = .default) -> Self {
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
    public func fontDesign(_ design: FontDesign) -> Self {
        return self.font(self.font?.pointSize ?? UIFont.systemFontSize, weight: .regular, design: design)
    }


    @discardableResult
    public func fontWeight(_ weight: UIFont.Weight) -> Self {
        let existingFont = self.font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        self.font = UIFont.systemFont(ofSize: existingFont.pointSize, weight: weight)
        return self
    }

    @discardableResult
    public func bold() -> Self {
        return fontWeight(.bold)
    }

    @discardableResult
    public func underline(_ isActive: Bool = true, color: UIColor? = nil) -> Self {
        if isActive {
            addUnderline(color: color)
        }
        return self
    }

    @discardableResult
    public func italic() -> Self {
        apply(style: .font, value: UIFont.italicSystemFont(ofSize: self.font?.pointSize ?? UIFont.systemFontSize))
        return self
    }

    @discardableResult
    public func strikethrough(_ isActive: Bool = true, color: UIColor? = nil) -> Self {
        if isActive {
            apply(style: .strikethroughStyle, value: NSUnderlineStyle.single.rawValue, color: color)
        }
        return self
    }

    @discardableResult
    public func foregroundColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    public func foregroundColor(_ hex: UInt) -> Self {
        let color = UIColor(hex: UInt32(hex))
        self.textColor = color
        return self
    }
    
    @discardableResult
    public func tintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
    
    public func tintColor(_ hex: UInt) -> Self {
        let color = UIColor(hex: UInt32(hex))
        self.tintColor = color
        return self
    }

    @discardableResult
    public func alignment(_ textAlignment: NSTextAlignment) -> Self {
        let container = UIView()
        container.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false

        switch textAlignment {
        case .left, .justified:
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        case .center:
            self.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        case .right:
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        case .natural:
            if UIView.userInterfaceLayoutDirection(for: container.semanticContentAttribute) == .leftToRight {
                self.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
            } else {
                self.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
            }
        @unknown default:
            break
        }

        return self
    }

    @discardableResult
    public func multilineTextAlignment(_ alignment: NSTextAlignment = .center) -> Self {
        self.textAlignment = alignment
        self.numberOfLines = 0
        return self
    }
    
    @discardableResult
    public func baselineOffset(_ baselineOffset: CGFloat) -> Self {
        let attributedString = NSMutableAttributedString(string: self.text ?? "")
        attributedString.addAttribute(.baselineOffset, value: baselineOffset, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
        return self
    }
    
    @discardableResult
    public func kerning(_ kerning: CGFloat) -> Self {
        let attributedString = NSMutableAttributedString(string: self.text ?? "")
        attributedString.addAttribute(.kern, value: kerning, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
        return self
    }
    
    private func addUnderline(color: UIColor? = nil) {
        guard let attributedText = self.attributedText else {
            return
        }

        let attributedString = NSMutableAttributedString(attributedString: attributedText)
        let range = NSRange(location: 0, length: attributedString.length)

        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)

        if let underlineColor = color {
            attributedString.addAttribute(.underlineColor, value: underlineColor, range: range)
        }

        self.attributedText = attributedString
    }

    private func apply(style: NSAttributedString.Key, value: Any, color: UIColor? = nil) {
        var attributes: [NSAttributedString.Key: Any] = [style: value]

        if let strikethroughColor = color {
            attributes[.strikethroughColor] = strikethroughColor
        }

        if let existingText = self.attributedText {
            let attributedString = NSMutableAttributedString(attributedString: existingText)
            attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString
        } else {
            self.attributedText = NSAttributedString(string: self.text ?? "", attributes: attributes)
        }
    }
}

extension UILabel {
    @discardableResult
    public func multilineTextAlignment(_ alignment: NSTextAlignment = .center, _ lines: Int) -> Self {
        self.textAlignment = alignment
        self.numberOfLines = lines
        return self
    }
    
    @discardableResult
    public func multilineTextAlignment(_ state: SBinding<NSTextAlignment>) -> Self {
        self.textAlignment = state.wrappedValue
        self.numberOfLines = 0
        
        state.didSet = { [weak self] newText in
            self?.textAlignment = newText
        }
        return self
    }
    
    @discardableResult
    public func text(_ state: SBinding<String>) -> Self {
        self.text = state.wrappedValue
        state.didSet = { [weak self] newText in
            self?.text = newText
        }
        return self
    }
    
    @discardableResult
    public func tintColor(_ state: SBinding<UIColor>) -> Self {
        self.tintColor = state.wrappedValue
        state.didSet = { [weak self] newText in
            self?.tintColor = newText
        }
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ state: SBinding<UIColor?>) -> Self {
        self.textColor = state.wrappedValue
        state.didSet = { [weak self] newText in
            self?.textColor = newText
        }
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ state: SBinding<UIColor>) -> Self {
        self.textColor = state.wrappedValue
        state.didSet = { [weak self] newText in
            self?.textColor = newText
        }
        return self
    }
    
    @discardableResult
    func foregroundColor(_ hex: SBinding<UInt>) -> Self {
        hex.didSet = { [weak self] newHex in
            let color = UIColor(hex: UInt32(newHex))
            self?.textColor = color
        }
        hex.didSet?(hex.wrappedValue)
        return self
    }
    
    @discardableResult
    func foregroundColor(_ hex: SBinding<UInt?>) -> Self {
        hex.didSet = { [weak self] newHex in
            guard let hexValue = newHex else { return }
            let color = UIColor(hex: UInt32(hexValue))
            self?.textColor = color
        }
        hex.didSet?(hex.wrappedValue)
        return self
    }
    
    @discardableResult
    public func font(_ state: SBinding<UIFont?>) -> Self {
        self.font = state.wrappedValue
        state.didSet = { [weak self] newText in
            self?.font = newText
        }
        return self
    }
    
    @discardableResult
    public func font(_ state: SBinding<UIFont>) -> Self {
        self.font = state.wrappedValue
        state.didSet = { [weak self] newText in
            self?.font = newText
        }
        return self
    }
    
    @discardableResult
    public func fontWeight(_ state: SBinding<UIFont.Weight>) -> Self {
        let existingFont = self.font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        self.font = UIFont.systemFont(ofSize: existingFont.pointSize, weight: state.wrappedValue)
        state.didSet = { [weak self] newWeight in
            let updatedFont = UIFont.systemFont(ofSize: existingFont.pointSize, weight: newWeight)
            self?.font = updatedFont
        }
        
        return self
    }
    
    @discardableResult
    public func fontDesign(_ state: SBinding<FontDesign>) -> Self {
        let newFont = UIFont(name: state.wrappedValue.fontName, size: self.font?.pointSize ?? UIFont.systemFontSize) ?? UIFont.systemFont(ofSize: 12)
        
        self.setFont(newFont)
        
        state.didSet = { [weak self] newDesign in
            let updatedFont = UIFont(name: newDesign.fontName, size: self?.font?.pointSize ?? UIFont.systemFontSize) ?? UIFont.systemFont(ofSize: 12)
            self?.setFont(updatedFont)
        }
        
        return self
    }
    
    @discardableResult
    public func baselineOffset(_ state: SBinding<CGFloat>, _ isActive: Bool = true) -> Self {
        if isActive {
            let attributedString = NSMutableAttributedString(string: self.text ?? "")
            attributedString.addAttribute(.baselineOffset, value: state.wrappedValue, range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString
            
            state.didSet = { [weak self] newBaselineOffset in
                let newAttributedString = NSMutableAttributedString(string: self?.text ?? "")
                newAttributedString.addAttribute(.baselineOffset, value: newBaselineOffset, range: NSRange(location: 0, length: newAttributedString.length))
                self?.attributedText = newAttributedString
            }
        }
        return self
    }
    
    @discardableResult
    public func kerning(_ state: SBinding<CGFloat>, _ isActive: Bool = true) -> Self {
        if isActive {
            let attributedString = NSMutableAttributedString(string: self.text ?? "")
            attributedString.addAttribute(.kern, value: state.wrappedValue, range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString
            
            state.didSet = { [weak self] newKerning in
                let newAttributedString = NSMutableAttributedString(string: self?.text ?? "")
                newAttributedString.addAttribute(.kern, value: newKerning, range: NSRange(location: 0, length: newAttributedString.length))
                self?.attributedText = newAttributedString
            }
        }
        return self
    }
    
    @discardableResult
    public func strikethrough(_ state: SBinding<Bool>, color: UIColor? = nil) -> Self {
        apply(style: .strikethroughStyle, value: state.wrappedValue ? NSUnderlineStyle.single.rawValue : 0, color: color)
        
        state.didSet = { [weak self] isActive in
            self?.apply(style: .strikethroughStyle, value: isActive ? NSUnderlineStyle.single.rawValue : 0, color: color)
        }
        
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

private extension UIView {
    func setFont(_ font: UIFont) {
        if let label = self as? UILabel {
            label.font = font
        } else if let button = self as? UIButton {
            button.titleLabel?.font = font
        }
    }
}*/

import UIKit

public enum FontDesign {
    case `default`
    case monospaced
    case serif
    case rounded

    var fontName: String {
        switch self {
        case .default:
            return UIFont.systemFont(ofSize: 12).familyName
        case .monospaced:
            return "Courier New"
        case .serif:
            return "Times New Roman"
        case .rounded:
            return "Arial Rounded MT Bold"
        }
    }
}

public class Text: UILabel {
    @discardableResult
    public func text(_ text: String) -> Self {
        self.text = text
        return self
    }

    @discardableResult
    public func font(_ size: CGFloat, weight: UIFont.Weight = .regular, design: FontDesign = .default) -> Self {
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
    public func fontDesign(_ design: FontDesign) -> Self {
        return self.font(self.font?.pointSize ?? UIFont.systemFontSize, weight: .regular, design: design)
    }


    @discardableResult
    public func fontWeight(_ weight: UIFont.Weight) -> Self {
        let existingFont = self.font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        self.font = UIFont.systemFont(ofSize: existingFont.pointSize, weight: weight)
        return self
    }

    @discardableResult
    public func bold() -> Self {
        return fontWeight(.bold)
    }

    @discardableResult
    public func underline(_ isActive: Bool = true, color: UIColor? = nil) -> Self {
        if isActive {
            addUnderline(color: color)
        }
        return self
    }

    @discardableResult
    public func italic() -> Self {
        apply(style: .font, value: UIFont.italicSystemFont(ofSize: self.font?.pointSize ?? UIFont.systemFontSize))
        return self
    }

    @discardableResult
    public func strikethrough(_ isActive: Bool = true, color: UIColor? = nil) -> Self {
        if isActive {
            apply(style: .strikethroughStyle, value: NSUnderlineStyle.single.rawValue, color: color)
        }
        return self
    }

    @discardableResult
    public func foregroundColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ hex: UInt) -> Self {
        let color = UIColor(hex: UInt32(hex))
        self.textColor = color
        return self
    }
    
    @discardableResult
    public func tintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
    
    @discardableResult
    public func tintColor(_ hex: UInt) -> Self {
        let color = UIColor(hex: UInt32(hex))
        self.tintColor = color
        return self
    }

    @discardableResult
    public func alignment(_ textAlignment: NSTextAlignment) -> Self {
        let container = UIView()
        container.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false

        switch textAlignment {
        case .left, .justified:
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        case .center:
            self.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        case .right:
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        case .natural:
            if UIView.userInterfaceLayoutDirection(for: container.semanticContentAttribute) == .leftToRight {
                self.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
            } else {
                self.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
            }
        @unknown default:
            break
        }

        return self
    }

    @discardableResult
    public func multilineTextAlignment(_ alignment: NSTextAlignment = .center) -> Self {
        self.textAlignment = alignment
        self.numberOfLines = 0
        return self
    }
    
    @discardableResult
    public func baselineOffset(_ baselineOffset: CGFloat) -> Self {
        let attributedString = NSMutableAttributedString(string: self.text ?? "")
        attributedString.addAttribute(.baselineOffset, value: baselineOffset, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
        return self
    }
    
    @discardableResult
    public func kerning(_ kerning: CGFloat) -> Self {
        let attributedString = NSMutableAttributedString(string: self.text ?? "")
        attributedString.addAttribute(.kern, value: kerning, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
        return self
    }
    
    private func addUnderline(color: UIColor? = nil) {
        guard let attributedText = self.attributedText else {
            return
        }

        let attributedString = NSMutableAttributedString(attributedString: attributedText)
        let range = NSRange(location: 0, length: attributedString.length)

        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)

        if let underlineColor = color {
            attributedString.addAttribute(.underlineColor, value: underlineColor, range: range)
        }

        self.attributedText = attributedString
    }

    func apply(style: NSAttributedString.Key, value: Any, color: UIColor? = nil) {
        var attributes: [NSAttributedString.Key: Any] = [style: value]

        if let strikethroughColor = color {
            attributes[.strikethroughColor] = strikethroughColor
        }

        if let existingText = self.attributedText {
            let attributedString = NSMutableAttributedString(attributedString: existingText)
            attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString
        } else {
            self.attributedText = NSAttributedString(string: self.text ?? "", attributes: attributes)
        }
    }
    
    @discardableResult
    public func multilineTextAlignment(_ alignment: NSTextAlignment = .center, _ lines: Int) -> Self {
        self.textAlignment = alignment
        self.numberOfLines = lines
        return self
    }
    
    @discardableResult
    public func multilineTextAlignment(_ state: SBinding<NSTextAlignment>) -> Self {
        self.textAlignment = state.wrappedValue
        self.numberOfLines = 0
        
        state.didSet = { [weak self] newText in
            self?.textAlignment = newText
        }
        return self
    }
    
    @discardableResult
    public func text(_ state: SBinding<String>) -> Self {
        self.text = state.wrappedValue
        state.didSet = { [weak self] newText in
            self?.text = newText
        }
        return self
    }
    
    @discardableResult
    public func tintColor(_ state: SBinding<UIColor>) -> Self {
        self.tintColor = state.wrappedValue
        state.didSet = { [weak self] newText in
            self?.tintColor = newText
        }
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ state: SBinding<UIColor?>) -> Self {
        self.textColor = state.wrappedValue
        state.didSet = { [weak self] newText in
            self?.textColor = newText
        }
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ state: SBinding<UIColor>) -> Self {
        self.textColor = state.wrappedValue
        state.didSet = { [weak self] newText in
            self?.textColor = newText
        }
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ hex: SBinding<UInt>) -> Self {
        hex.didSet = { [weak self] newHex in
            let color = UIColor(hex: UInt32(newHex))
            self?.textColor = color
        }
        hex.didSet?(hex.wrappedValue)
        return self
    }
    
    @discardableResult
    public func foregroundColor(_ hex: SBinding<UInt?>) -> Self {
        hex.didSet = { [weak self] newHex in
            guard let hexValue = newHex else { return }
            let color = UIColor(hex: UInt32(hexValue))
            self?.textColor = color
        }
        hex.didSet?(hex.wrappedValue)
        return self
    }
    
    @discardableResult
    public func font(_ state: SBinding<UIFont?>) -> Self {
        self.font = state.wrappedValue
        state.didSet = { [weak self] newText in
            self?.font = newText
        }
        return self
    }
    
    @discardableResult
    public func font(_ state: SBinding<UIFont>) -> Self {
        self.font = state.wrappedValue
        state.didSet = { [weak self] newText in
            self?.font = newText
        }
        return self
    }
    
    @discardableResult
    public func fontWeight(_ state: SBinding<UIFont.Weight>) -> Self {
        let existingFont = self.font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        self.font = UIFont.systemFont(ofSize: existingFont.pointSize, weight: state.wrappedValue)
        state.didSet = { [weak self] newWeight in
            let updatedFont = UIFont.systemFont(ofSize: existingFont.pointSize, weight: newWeight)
            self?.font = updatedFont
        }
        
        return self
    }
    
    @discardableResult
    public func fontDesign(_ state: SBinding<FontDesign>) -> Self {
        let newFont = UIFont(name: state.wrappedValue.fontName, size: self.font?.pointSize ?? UIFont.systemFontSize) ?? UIFont.systemFont(ofSize: 12)
        
        self.setFont(newFont)
        
        state.didSet = { [weak self] newDesign in
            let updatedFont = UIFont(name: newDesign.fontName, size: self?.font?.pointSize ?? UIFont.systemFontSize) ?? UIFont.systemFont(ofSize: 12)
            self?.setFont(updatedFont)
        }
        
        return self
    }
    
    @discardableResult
    public func baselineOffset(_ state: SBinding<CGFloat>, _ isActive: Bool = true) -> Self {
        if isActive {
            let attributedString = NSMutableAttributedString(string: self.text ?? "")
            attributedString.addAttribute(.baselineOffset, value: state.wrappedValue, range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString
            
            state.didSet = { [weak self] newBaselineOffset in
                let newAttributedString = NSMutableAttributedString(string: self?.text ?? "")
                newAttributedString.addAttribute(.baselineOffset, value: newBaselineOffset, range: NSRange(location: 0, length: newAttributedString.length))
                self?.attributedText = newAttributedString
            }
        }
        return self
    }
    
    @discardableResult
    public func kerning(_ state: SBinding<CGFloat>, _ isActive: Bool = true) -> Self {
        if isActive {
            let attributedString = NSMutableAttributedString(string: self.text ?? "")
            attributedString.addAttribute(.kern, value: state.wrappedValue, range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString
            
            state.didSet = { [weak self] newKerning in
                let newAttributedString = NSMutableAttributedString(string: self?.text ?? "")
                newAttributedString.addAttribute(.kern, value: newKerning, range: NSRange(location: 0, length: newAttributedString.length))
                self?.attributedText = newAttributedString
            }
        }
        return self
    }
    
    @discardableResult
    public func strikethrough(_ state: SBinding<Bool>, color: UIColor? = nil) -> Self {
        apply(style: .strikethroughStyle, value: state.wrappedValue ? NSUnderlineStyle.single.rawValue : 0, color: color)
        
        state.didSet = { [weak self] isActive in
            self?.apply(style: .strikethroughStyle, value: isActive ? NSUnderlineStyle.single.rawValue : 0, color: color)
        }
        
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

private extension UIView {
    func setFont(_ font: UIFont) {
        if let label = self as? UILabel {
            label.font = font
        } else if let button = self as? UIButton {
            button.titleLabel?.font = font
        }
    }
}
